.. contents::

Libvirt FAQ
===========

General
-------

What is libvirt?
~~~~~~~~~~~~~~~~

Libvirt is collection of software that provides a convenient way to
manage virtual machines and other virtualization functionality, such as
storage and network interface management. These software pieces include
an API library, a daemon (libvirtd), and a command line utility (virsh).

An primary goal of libvirt is to provide a single way to manage multiple
different virtualization providers/hypervisors. For example, the command
'virsh list --all' can be used to list the existing virtual machines for
any supported hypervisor (KVM, Xen, VMWare ESX, etc.) No need to learn
the hypervisor specific tools!

I heard someone say they 'use libvirt'. What do they mean?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When people say they 'use libvirt', this usually means that they manage
virtual machines using tools such as 'virsh', 'virt-manager', or
'virt-install', which are all built around libvirt functionality. They
likely DO NOT directly use tools like 'xm' for Xen, or the qemu/qemu-kvm
binary.

How do I know if I am using libvirt?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You are using libvirt if you manage virtual machines using virsh,
virt-manager, or virt-install (pretty much any virtualization tool that
starts with virt-\*).

If you are using hypervisor specific tools like 'xm', 'qemu-kvm', etc.
directly, you probably are not using libvirt.

If you have virtual machines on your existing machine and you are using
libvirt, 'virsh list --all' (usually run as root) should show something.

What is some of the major functionality provided by libvirt?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some of the major libvirt features are:

-  **VM management**: Various domain lifecycle operations such as start,
   stop, pause, save, restore, and migrate. Hotplug operations for many
   device types including disk and network interfaces, memory, and cpus.

-  **Remote machine support**: All libvirt functionality is accessible
   on any machine running the libvirt daemon, including remote machines.
   A variety of network transports are supported for connecting
   remotely, with the simplest being SSH, which requires no extra
   explicit configuration. If example.com is running libvirtd and SSH
   access is allowed, the following command will provide access to all
   virsh commands on the remote host for qemu/kvm:

::

      virsh --connect qemu+ssh://root@example.com/system

For more info, see: https://libvirt.org/remote.html

-  **Storage management**: Any host running the libvirt daemon can be
   used to manage various types of storage: create file images of
   various formats (qcow2, vmdk, raw, ...), mount NFS shares, enumerate
   existing LVM volume groups, create new LVM volume groups and logical
   volumes, partition raw disk devices, mount iSCSI shares, and much
   more. Since libvirt works remotely as well, all these options are
   available for remote hosts as well. For more info, see:
   https://libvirt.org/storage.html

-  **Network interface management**: Any host running the libvirt daemon
   can be used to manage physical and logical network interfaces.
   Enumerate existing interfaces, as well as configure (and create)
   interfaces, bridges, vlans, and bond devices. This is with the help
   of netcf, For more info, see: https://fedorahosted.org/netcf/

-  **Virtual NAT and Route based networking**: Any host running the
   libvirt daemon can manage and create virtual networks. Libvirt
   virtual networks use firewall rules to act as a router, providing VMs
   transparent access to the host machines network.

What hypervisors does libvirt support?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A complete list can be found here: https://libvirt.org/drivers.html

How can I check my libvirt version?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For the installed virsh version:

::

   virsh --version

For the libvirt daemon version:

::

   libvirtd --version

For the library and default hypervisor version:

::

   virsh --version

What are the libvirt mailing lists/IRC?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See: https://libvirt.org/contact.html

Where should I report libvirt bugs?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For bug reporting, see: https://libvirt.org/bugs.html

Is libvirt the 'lowest common denominator' of hypervisor features?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Short answer: ABSOLUTELY NOT.

Libvirt's goal is to expose all useful hypervisor features. Period.

The only caveat is that this feature needs to be exposed in a general
way that is compatible with the libvirt architecture. Even if only a
single supported hypervisor implements feature FOO, the API and XML
changes need to be made sufficiently general in case any other
hypervisor eventually supports FOO.


Common VM Configuration
-----------------------

What is the 'virsh edit' command and how do I use it?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

'virsh edit' is the recommended way to make changes to an existing VM
configuration. The command looks like:

::

   virsh edit $your-vm-name

This command will open a text editor containing the existing VM XML: any
changes that are made and saved will be checked for errors when the
editor exits. If no errors are found, the changes are made permanent.

The text editor used is whatever is specified by the EDITOR environment
variable. By default, this is usually 'vi'. You can override this with:

::

   EDITOR=$your-favorite-editor virsh edit $your-vm-name'.

For example, on a gnome system 'EDITOR=gedit virsh edit myvm' will edit
myvm's XML in a graphical text editor.

Where are VM config files stored? How do I edit a VM's XML config?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to edit a VMs XML, use 'virsh edit $vmname'. If you want to
backup the XML, use 'virsh dumpxml $vmname'.

Where VM configuration is stored depends on the hypervisor. For example,
Xen and VMWare store their own configs, and libvirt just translates this
to XML when 'virsh dumpxml' is called.. For qemu and lxc, libvirt stores
the XML on disk and in memory.

libvirt is often configured to store qemu VM and other XML descriptions
in /etc, but editing those files is not a valid way to change
configuration. While editing those files and restarting libvirtd may
work some (or even much) of the time, it's very possible that libvirtd
will overwrite the changes and they will be lost. Equally importantly,
using virsh edit or other API to edit the XML allows libvirt to validate
your changes. A common problem seen when people edit the on-disk XML is
a VM that simply vanishes the next time libvirtd is restarted after the
edit. The VM disappears from libvirt because the XML has become invalid,
after which libvirt can't do anything with it.

This advice applies for ALL libvirt XML. The equivalent virsh commands
for other libvirt XML types are:

-  Virtual Networks: net-edit, net-dumpxml
-  Storage Pools: pool-edit, pool-dumpxml
-  Storage Volumes: vol-edit, vol-dumpxml
-  Interfaces: iface-edit, iface-dumpxml

If I change the XML of running machine, do the changes take immediate effect?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NO. Redefining the XML of a running machine will not change anything,
the changes will take effect after the next VM start up. Libvirt has a
set of commands for making live changes to running guests, which have
varying support depending on the hypervisor, ex virsh attach-\*. virsh
detach-\*, virsh setmem, virsh setvcpus

How do I shutdown my VMs?
~~~~~~~~~~~~~~~~~~~~~~~~~

There are two shutdown operations via virsh:

-  virsh shutdown $vm-name : Request a soft shutdown, akin to pressing
   the power button on a physical machine.
-  virsh destroy $vm-name : Hard poweroff a physical machine. Akin to
   ripping the power cord from a running machine.

The other option it to shut down your VM normally from inside the guest
operating system, like you would for a physical machine.

Note: At least for the qemu/kvm guests, shutdown requires ACPI enabled
in the guest. See the QEMU/KVM shutdown FAQ entry.

Will restarting the libvirt daemon stop my virtual machines?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NO, as of version 0.6.0 (Jan 2009). Versions older than this will kill
VMs if the libvirtd daemon is stopped, so beware.


Common Errors
-------------

My VM doesn't show up with 'virsh list'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

First, make sure you are passing the --all flag:

::

   virsh list --all

'virsh list' only shows running VMs: --all is required to see every VM.

If your VM is still not listed, determine which URI virsh is defaulting
to with:

::

   virsh uri

If the default URI is not as expected, you can manually specify a URI
with:

::

   virsh --connect URI

If you are using QEMU/KVM and you created your VM with virt-manager, the
URI you probably want is qemu:///system. If that doesn't work, read
`What is the difference between qemu:///system and qemu:///session? Which one should I use?`_

Error: Failed to add tap interface 'vnet%d' to bridge 'virbr0' No such file or directory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is commonly caused by 2 things

-  The 'tun' module is not loaded. Try running:

::

   modprobe tun

-  The virtual network used by your VM is not running. This is usually
   the 'default' network, which can be started with

::

   virsh net-start default

Error: unable to connect to '/var/run/libvirt/libvirt-sock'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is usually caused by one of the following:

-  libvirtd is not running. On fedora systems, this can be fixed with:

::

   service libvirtd restart

-  Or you could run it like this

::

   /etc/init.d/libvirtd restart

-  You manually installed from source, and something is screwy. virsh
   may be looking for the socket in '/usr/local/var', but your installed
   libvirtd isn't creating it correctly.

It's recommended that you configure a manual libvirt install with
--prefix=/usr to correct these issues.

Why doesn't 'shutdown' seem to work?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are using Xen HVM or QEMU/KVM, ACPI must be enabled in the guest
for a graceful shutdown to work. To check if ACPI is enabled, run:

::

   virsh dumpxml $your-vm-name | grep acpi

If nothing is printed, ACPI is not enabled for your machine. Use 'virsh
edit' to add the following XML under <domain>:

::

   <features><acpi/></features>

If your VM is running Linux, the VM additionally needs to be running
acpid to receive the ACPI events.

HOWEVER, if your VM is running Windows, this won't be enough. If windows
does not detect ACPI at install time, it disables the necessary support.
The recommended way to remedy this seems to be a 'repair install' using
windows install media. More info can be found here:

http://support.microsoft.com/kb/314088/EN-US/
http://support.microsoft.com/?kbid=309283

Error: domain did not show up
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For a while, this was a kind of catch all error for qemu/kvm guest start
up failures. See 'My VM fails to start'

Error: monitor socket did not show up.: Connection refused
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This message usually masks a more specific error at domain start up. See
'My VM fails to start'

My VM fails to start. What should I do?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If your VM is failing to start, and libvirt isn't returning a helpful
error message, you can find more info in the log files. For qemu/kvm,
this is /var/log/libvirt/qemu/$your-vm-name.log. This will show
generated qemu command line, and any error output qemu throws. Certain
versions of libvirt weren't good at returning this info to the user, so
there may be a fixable error here, like a missing storage file.

If you can't determine anything to fix, please report a bug (see the bug
reporting FAQ).

error: Unknown Failure
~~~~~~~~~~~~~~~~~~~~~~

This is caused by faulty error reporting in libvirt. Whenever you
encounter this error, please `file a
bug <https://libvirt.org/bugs.html>`__. You can typically get more
information by running

::

    tail -f /var/log/messages

and reproducing the failure. If you encounter this during VM migration,
you will want to run that command on both the source and destination
host. You will also want to make sure your hosts are properly configured
for migration (see the migration section of this FAQ).

internal error: canonical hostname pointed to localhost, but this is not allowed
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is an error often encountered when trying to migrate with QEMU/KVM.
What this means is that 'virsh hostname' on the destination host returns
'localhost', which can cause problems with plain migration. The easiest
way to work around this is to manually specify a migration hostname/IP
address. This can be done with:

::

    virsh migrate with the option '--migrateuri tcp://hostname:port'

error: operation failed: migration to '...' failed: migration failed
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is an error often encountered when trying to migrate with QEMU/KVM.
This typically happens with plain migration, when the source VM cannot
connect to the destination host. You will want to make sure your hosts
are properly configured for migration (see the migration section of this
FAQ)

networking is unavailable in virt-manager / virsh - libvirt's default network fails to start
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This problem can have several causes:

1) The most common is that dnsmasq is unable to start due to another
instance of dnsmasq (usually the host system's main instance, controlled
by /etc/dnsmasq.conf) already running and listening on all network
interfaces - the symptom will be that dnsmasq exits immediately with an
error code of "2". You can solve this by either disabling the host
dnsmasq instance completely (on Fedora/RHEL you can do this with
"chkconfig dnsmasq off"), or by modifying the offending dnsmasq
configuration to only listen on specific interfaces (see the
listen-address and interface options in /etc/dnsmasq.conf).

2) Sometimes it appears that networking (or some other common feature)
is unavailable because the user has accidentally connected to the
qemu:///session (which can be used as any user, and is the default used
by virsh when not run as root) as opposed to qemu:///system (which can
only be accessed by root, and is the default used by virsh when run as
root). To solve this problem, be sure to su to root prior to running
virsh. See
`What is the difference between qemu:///system and qemu:///session? Which one should I use?`_
for more details.

3) Another problem is missing third-party binaries required on the host
to initialize the network. The dependencies registered as part of the
libvirt package will normally assure that all necessary binaries are
present, but on some systems (e.g. gentoo) the practice of building your
own packages, and allowing "minimal" packages, can lead to problems. For
example, the binary /sbin/ip, which is part of the iproute package
(called iproute2 in some cases) is required to set the IP addresses of
the bridge devices used by libvirt, but it's possible on gentoo to build
the iproute2 package "minimally" which results in no /sbin/ip. The
symptom will be that libvirt complains it can't set the bridge device IP
address. Here is a list of the networking-related packages that need to
be installed on the host for libvirt networking to work properly:

::

    bridge-utils
    module-init-tools
    iproute
    dnsmasq >= 2.41
    radvd (if using IPv6)
    iptables
    iptables-ipv6 (if using IPv6)
    ebtables (if using libvirt's nwfilter)

Again, the installation of required dependencies should be handled by
your OS' package installation system, but if there are problems it may
be useful to reference this list (and/or the file libvirt.spec in the
libvirt source tree for a full list of all package dependencies -
required packages will be listed on lines beginning with "Required:").

Migration
---------

What are the different migration methods?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are two primary types of migration with QEMU/KVM and libvirt:

-  Plain migration: The source host VM opens a direct unencrypted TCP
   connection to the destination host for sending the migration data.
   Unless a port is manually specified, libvirt will choose a migration
   port in the range 49152-49215, which will need to be open in the
   firewall on the remote host.

-  Tunneled migration: The source host libvirtd opens a direct
   connection to the destination host libvirtd for sending migration
   data. This allows the option of encrypting the data stream. This mode
   doesn't require any extra firewall configuration, but is only
   supported with qemu 0.12.0 or later, and libvirt 0.7.2.

What setup is required for QEMU/KVM migration?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For all QEMU/KVM migrations, libvirtd must be running on the source and
destination host. You must be able to open a valid connection to the
remote libvirt host.

For tunneled migration, no extra configuration should be required, you
simply need to pass the --tunnelled flag to virsh migrate.

For plain unencrypted migration, the TCP port range 49152-49215 must be
opened in the firewall on the destination host. If you would like to use
a specific port rather than have libvirt choose, you can pass a manual
URI to virsh:

::

    virsh migrate $VMNAME $REMOTE_HOST_URI --migrateuri tcp://$REMOTE_HOST:$PORT


QEMU/KVM
--------

Can I connect to the QEMU monitor with libvirt?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

No. Libvirt deliberately does not enable user access to the QEMU
monitor. Interacting with the monitor behind libvirt's back can cause
reported virtual machine state to be out of sync, which will likely end
with errors.

The only way to interact with the monitor is through libvirt APIs (see
the following question for a complete list of support)

What monitor commands does libvirt support? What QEMU/KVM command line flags does libvirt support?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For a complete list, please see:
`QEMUSwitchToLibvirt <QEMUSwitchToLibvirt.html>`__

What is the difference between qemu:///system and qemu:///session? Which one should I use?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All 'system' URIs (be it qemu, lxc, uml, ...) connect to the libvirtd
daemon running as root which is launched at system startup. Virtual
machines created and run using 'system' are usually launched as root,
unless configured otherwise (for example in /etc/libvirt/qemu.conf).

All 'session' URIs launch a libvirtd instance as your local user, and
all VMs are run with local user permissions.

You will definitely want to use qemu:///system if your VMs are acting as
servers. VM autostart on host boot only works for 'system', and the root
libvirtd instance has necessary permissions to use proper networkings
via bridges or virtual networks. qemu:///system is generally what tools
like virt-manager default to.

qemu:///session has a serious drawback: since the libvirtd instance does
not have sufficient privileges, the only out of the box network option
is qemu's usermode networking, which has nonobvious limitations, so its
usage is discouraged. More info on qemu networking options:
http://people.gnome.org/~markmc/qemu-networking.html

The benefit of qemu:///session is that permission issues vanish: disk
images can easily be stored in $HOME, serial PTYs are owned by the user,
etc.

How can I get QEMU's PID for a VM using libvirt APIs?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You cannot. And there are multiple reasons for that:

#. You should not need that for anything. Usually, if someone needs to
   know the PID, they want to do something to the VM behind libvirt's
   back. The less libvirt knows about the VM, the less accurate
   decisions it can make, i.e. it might break few things here and there.
#. The PID is not strictly tied to the VM. If you were to get the PID
   and then do something using it, you might be doing that to another
   process as the VM could've been restarted in the meantime. With the
   UUID/name/ID of the VM, you are guaranteed that whatever you need
   will be done on that particular domain.
#. libvirt is designed to be used remotely, there would be no point in
   exposing such information to a different host.

So whatever needs to be done, should be done through our APIs which will
keep libvirt's internal state in sync. They might not exist yet, but
they might be added.

But I really need to know the PID, I won't ask for help when something breaks, I promise
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Well, since you want to use it, you have access to the machine. So you
can look for the UUID (or name) of the VM in the process list.

Networking
----------

What is libvirt doing with iptables?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default, libvirt provides a virtual network named 'default' which
acts as a NAT router for virtual machines, routing traffic to the
network connected to your host machine. This functionality uses
iptables.

For more info, see: `nat-forwarding-aka-virtual-networks <Networking.html#nat-forwarding-aka-virtual-networks>`__

How can I make libvirt stop using iptables?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

WARNING: Any VMs already configured to use these virtual networks will
need to be edited: simply removing the <interface> devices via 'virsh
edit' should be sufficient. Not doing this step will cause starting to
fail, and even after the editing step the VMs will not have network
access.

You can remove all libvirt virtual networks on the machine:

-  Use 'virsh net-list --all' to see a list of all virtual networks
-  Use 'virsh net-destroy $net-name' to shutdown each running network
-  Use 'virsh net-undefine $net-name' to permanently remove the network

Why doesn't libvirt just auto configure a regular network bridge?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While this would be nice, it is difficult/impossible to do in a safe way
that won't hit a lot of trouble with non trivial networking
configurations. A static bridge is also not compatible with a laptop
mode of networking, switching between wireless and wired. Static bridges
also do not play well with NetworkManager as of this writing (Feb 2010).

You can find more info about the motivation virtual networks here:
http://www.gnome.org/~markmc/virtual-networking.html

How do I manually configure a network bridge?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See: `Setting up a Host Bridge <Networking.html#host-configuration-bridged>`__

How do I get my VM to use an existing network bridge?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See: `Configuring Guests to use a Host Bridge <Networking.html#guest-configuration-bridge>`__

How do I forward incoming connections to a guest that is connected via a NATed virtual network? =
-------------------------------------------------------------------------------------------------

See: `Forwarding Incoming Connections <Networking.html#forwarding-incoming-connections>`__

Developing with libvirt
-----------------------

What is libvirt's license?
~~~~~~~~~~~~~~~~~~~~~~~~~~

libvirt is released under the `GNU Lesser General Public
License <http://www.opensource.org/licenses/lgpl-license.html>`__, see
the file COPYING.LIB in the distribution for the precise wording.

Where can I get the source code? How do I compile and install?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See https://libvirt.org/downloads.html

If you are using Fedora, the following packages are pre-requisites to a
minimal build that will pass 'make check':

-  cyrus-sasl-devel
-  device-mapper-devel
-  gnutls-devel
-  libxml2-devel

The following packages are also useful for building all optional
features:

-  avahi-devel
-  e2fsprogs-devel
-  hal-devel
-  libcap-ng-devel
-  libnl-devel
-  libpciaccess-devel
-  libselinux-devel
-  libssh2-devel
-  libudev-devel
-  netcf-devel
-  numactl-devel
-  parted-devel
-  python-devel
-  readline-devel
-  xen-devel
-  xhtml1-dtds
-  xmlrpc-c-devel
-  yajl-devel

Is libvirt thread safe?
~~~~~~~~~~~~~~~~~~~~~~~

Yes, libvirt is thread safe as of version 0.6.0. This means that
multiple threads can act on a single virConnect instance without issue.

Previous libvirt versions required opening a separate connection for
each thread: this method has several major drawbacks and is not
recommended.
