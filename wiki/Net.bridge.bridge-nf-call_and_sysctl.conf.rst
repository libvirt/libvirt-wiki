.. contents::

Most virtual guests configured using libvirt connect to the network via
a Linux host bridge; the behavior of the bridge changes depending on the
setting of 3 "tunables" recognized by the kernel bridge module:

::

    net.bridge.bridge-nf-call-arptables
    net.bridge.bridge-nf-call-ip6tables
    net.bridge.bridge-nf-call-iptables

These control whether or not packets traversing the bridge are sent to
iptables for processing. In the case of using bridges to connect virtual
machines to the network, generally such processing is \*not\* desired,
as it results in guest traffic being blocked due to host iptables rules
that only account for the host itself, and not for the guests.

However, the bridge module in the kernel has the default for all three
of these values set to "1" ("on", i.e. "\*do\* send the packets to
iptables"), and for historical reasons the kernel maintainers refuse to
change this default (see http://patchwork.ozlabs.org/patch/29319/ )

After the rejection of the above change to the compiled-in defaults by
the kernel, many Linux distros (including Fedora, RHEL, and CentOS) made
an attempt to solve this problem by adding lines to /etc/sysctl.conf to
modify the default settings compiled into the bridge module:

::

     net.bridge.bridge-nf-call-arptables = 0
     net.bridge.bridge-nf-call-ip6tables = 0
     net.bridge.bridge-nf-call-iptables = 0

The settings in /etc/sysctl.conf are applied anytime the command "sysctl
-p" is run, and it happens that this command is run at least once during
system boot, generally by either the network service or the
NetworkManager service, coincidentally a short time after those services
have created any bridge devices in the host system network configuration
(i.e. listed in /etc/sysconfig/network-scripts). Since creating a bridge
device causes the bridge module to be autoloaded, it will be present in
the kernel (and can act on the provided settings) at the time "sysctl
-p" is run.

However, if the bridge module \*isn't\* loaded at the time "sysctl -p"
is run, there will be two problems:

**1) misleading false error messages**

"sysctl -p" (which is run at boot time regardless of whether or there is
a bridge device in the system network configuration) will generate an
error message about an attempt to set "unknown keys" (since the bridge
module doesn't exist, there is nobody to recognize the keys):

::

     error: "net.bridge.bridge-nf-call-ip6tables" is an unknown key
     error: "net.bridge.bridge-nf-call-iptables" is an unknown key
     error: "net.bridge.bridge-nf-call-arptables" is an unknown key

This causes an annoyance to some system administrators (and it recurs
any time "sysctl -p" is later run manually, as long as the bridge module
still isn't loaded).

**2) Incorrect setting of tunables when bridge module is loaded later**

If some program creates a bridge at a later time, the bridge module will
be autoloaded, but sysctl -p won't be run (and the previously "unknown"
keys won't have been otherwise saved for application at a later time),
so the kernel-set defaults for the tunables will remain in effect.

The above description is the current state of affairs in RHEL6/CentOS6.
Things are different in recent Fedora and RHEL7, which we'll get to
further down.

**Attempted/Proposed Solutions in RHEL6 / pre-systemd**

Several solutions to the above problem have been proposed, and some
tried, over the years. There are many bug reports dealing with it. One
public bug report that has a lot of information is this:

::

    https://bugzilla.redhat.com/show_bug.cgi?id=634736

**\* modify sysctl to ignore errors caused by unknown keys**

This silences the complaints of people concerned about the false error
reports. However it could also suppress \*real\* errors. And on top of
that, it doesn't help problem (2) above.

**\* Build the bridge module into the kernel**

This would be bad because a) anybody wanting to minimize their footprint
would be stuck with the bridge module whether or not they used it, and
b) if someone built their own kernel, they may configure it to be
loadable anyway, thus negating the fix. (reason (b) is a bit weak, but
reason (a) would probably carry the day).

**\* Change the system startup to always force loading of the bridge
module very early on during system boot.**

Again, there would be complaints from those trying to maintain a very
small footprint.

**\* Move the settings from /etc/sysctl.conf to
/etc/sysctl.d/bridge.conf**

The problem with this "solution" is that it only solves one of the two
problems, and it's the least harmful problem that's being solved.
**And** beyond that, it creates a **new** problem.

1) At boot time, the settings in /etc/sysctl.d are loaded [in some other
manner], so in the case that there is a bridge device in the system
network config, they are applied. GOOD

2) Since "sysctl -p" only loads settings from /etc/sysctl.conf, if there
are no bridge devices running "sysctl -p" will not generate the above
errors. GOOD

3) If a bridge is created later, then sysctl -p won't be automatically
run (same as before). BAD (or NEUTRAL, depending on your thinking)

4) Even if the sysadmin has setup their own scripts to run "sysctl -p"
(based on previous behavior of the system) to force these settings, that
will \*still\* not load the bridge tunable settings, since (as stated
above) sysctl -p ignores /etc/sysctl.d. BAD **(a regression from current
behavior)**

**\* have libvirtd run "sysctl -p"**

This FAILs because it would mean that \*all\* the settings from
/etc/sysctl.conf would be re-applied, some of those possibly overriding
other transient settings made elsewhere by the sysadmin. Also, in many
cases libvirt is using a bridge device that was already created by
someone else, and in other cases it is simply calling the ioctl to
create the bridge - the module is autoloaded when necessary and libvirt
has no idea when this happens.

**\* Manually set these items in libvirt whenever libvirt creates a
bridge - this also fails in many ways:**

1) In the end, this is a system security policy that affects things
outside of libvirt and the virtual machines it manages, so it should not
be unceremoniously changed by libvirt.

2) libvirt isn't always the entity creating the bridge (and although we
are personally only concerned about libvirt, it isn't necessarily the
only \*user\* of bridges).

(just to mix things up a bit - note that some uses of libvirt's
"nwfilter" guest network packet filtering require all these settings to
be "on" in order to function properly).

From libvirt's point of view, the only of the above proposals that would
supply what we need are

**Attempted/Proposed Solutions with systemd**

Now that systemd is in widespread use, there has been at least one
attempt to fix this problem - the net.bridge.bridge-nf-call-\* settings
have been moved from /etc/sysctl to /usr/lib/sysctl.d/00-system.conf.
This does eliminate the problem of bogus errors being reported when
"sysctl -p" is run. However, it still does nothing to cause the settings
to be re-checked once the bridge module \*is\* loaded. The failure of
this attempt is noted in the followin bugzilla entry:

::

    https://bugzilla.redhat.com/show_bug.cgi?id=1054178

Apparently, though, systemd has the ability to apply certain settings at
the time a module is loaded. So the real solution on systems with
systemd is apparently to take advantage this capability - leave the
seetings in /usr/lbi/sysctl.d/\* and make sure that systemd detects when
the bridge module is loaded, and reloads these settings (however that is
done). That way both problems (1) and (2) at the top of this document
would be taken care of, with no new problems introduced (this
unfortunately doesn't help those people still on RHEL6/CentOS6).
