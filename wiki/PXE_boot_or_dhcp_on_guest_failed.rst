.. contents::

PXE boot (or dhcp) on guest failed
----------------------------------

If a guest starts but is unable to acquire an IP address from DHCP
and/or to boot using the PXE protocol, there are a few common causes:

libvirt's iptables Rules Overridden
-----------------------------------

If the guest is connected to one of libvirt's own virtual networks,
libvirt adds several iptables rules to allow DHCP requests from the
guest to reach the dnsmasq instance libvirt runs on the host for that
virtual network. Unfortunately, there are several management
applications that add/remove iptables rules, and there is currently no
central controlling authority to make sure that these programs
(including libvirt itself) don't add rules that override (or sometimes
even completely remove) the rules added by others.

**Solution**

To see if this is the cause of your problem, simply restart the libvirtd
service:

::

    # service libvirtd restart

When libvirtd is restarted it will reload all of its iptables rules,
putting them in the proper order relative to other rules so that guest
traffic will once again be allowed.

If this solves your problem, but it recurs later, try to figure out what
iptables-related application was run prior to the failure (usually it
will be some sort of firewall management application), and and remember
to restart libvirtd after it's run in the future.

The long term solution to this problem will be in the form of the
firewalld project, which is intended to become the above mentioned
"central controlling authority". At the moment, though, firewalld itself
creates exactly this problem - if you are experiencing this problem and
firewalld is enabled, stop and disable it, then restart libvirtd:

::

    # service firewalld stop
    # service firewalld disable
    # service libvirtd restart

Long Forward Delay Time on Bridge
---------------------------------

This is by far the most common. If the guest network interface is
connecting to a bridge device that has STP (Spanning Tree Protocol)
enabled, and a long "forward delay", the bridge will not forward packets
from the guest onto the bridge until at least $forwardDelay seconds have
elapsed since the guest was connected to the bridge (this delay gives
the bridge time to watch the traffic from the interface and determine
what mac addresses are behind it, to prevent forwarding loops in the
network topology).

If the forward delay is longer than the timeout of the guest's PXE/DHCP
client, then the client's operation will fail, and the guest will either
fail to boot (in the case of PXE) or fail to acquire an IP address (in
the case of DHCP).


**Solution**

To solve this problem, you should change the forward delay on the bridge
to 0, and/or disable STP on the bridge (note that this is only good
advice if the bridge is not used to connect multiple networks, but just
to connect multiple endpoints to a single network (the most common use
case for bridges used by libvirt)).

If the guest in question has interfaces connecting to a libvirt-managed
virtual network, you can accomplish this by editing the definition for
the network, and restarting it, e.g. for the default network:

::

     # virsh net-edit default

Add the following attributes to the <bridge> element:

::

      <bridge name='virbr0' delay='0' stp='on'/>

(note that delay='0' and stp='on' are actually the default settings for
virtual networks, so you will probably only need to do this to change to
some *other* value in case the configuration has already been modified
from the default)

If the guest interface is connected to a host bridge (one configureed
outside of libvirt), the method of changing the delay depends on the
Linux distro you are using:

Fedora/RHEL/Suse
^^^^^^^^^^^^^^^^

Edit the file /etc/sysconfig/network-scripts/ifcfg-${brname} (where
${brname} is the name of the bridge device the guest is connecting to)
and add/edit the following lines to turn STP on with a 0 second delay:

::

      STP=on
      DELAY=0

Debian/Ubuntu
^^^^^^^^^^^^^

Edit /etc/network/interfaces and find the section that configures
${brname}. Add/edit the following lines:

::

     bridge_stp on
     bridge_maxwait 0

All distros
^^^^^^^^^^^

After changing the config, restart the bridge device:

::

      /sbin/ifdown ${brname}
      /sbin/ifup ${brname}

Caveat
~~~~~~

Unfortunately, even if you set the forward delay on ${brname} to 0, if
it is not the "root bridge" in the network, it will eventually have its
delay time set to the delay configured for the root bridge. In this
case, currently the only solution is to disable STP completely on
${brname}.

iptables/kernel doesn't support CHECKSUM mangling rules
-------------------------------------------------------

This is only a problem if **all four** of the following are true:

1) your guest is using virtio network devices (the config will have
"<model type='virtio/>")

2) the host has the "vhost-net" module loaded ("ls /dev/vhost-net" will
not return an empty result).

3) The iptables version on the host is older than 1.4.10, which added
the libxt_CHECKSUM extension. You will know this is the case if you see
the following message in libvirtd's logs:

::

     warning: Could not add rule to fixup DHCP response checksums on network 'default'
     warning: May need to update iptables package & kernel to support CHECKSUM rule.

**(IMPORTANT NOTE: Unless the other 3 points in this list are also true,
the above warning message is completely innocuous, and is not an
indicator of any other problems!)**

4) The guest is attempting to get an IP address from a DHCP server that
is running directly on the host.

The problem is that the vhost-net path for packets causes UDP packets
destined for the guest that originate on the host the guests to have
uncomputed checksums. The result is that the guest's network stack sees
the packet as invalid, and discards it.


**Solution**

To solve this problem, you can invalidate any of the four points above.
If it's possible to update the host iptables and kernel to
iptables-1,4.10+, that is the best solution. Otherwise, the most
specific fix is to disable the vhost-net driver for this particular
guest. To do that, you need to edit the configuration for the guest:

::

     virsh edit ${guestname}

and change/add a <driver> line to the <interface> section:

::

     <interface type='network'>
       <model type='virtio'/>
       <driver name='qemu'/>
       ...
     </interface>

After you save the change, shutdown the guest, then restart it.
