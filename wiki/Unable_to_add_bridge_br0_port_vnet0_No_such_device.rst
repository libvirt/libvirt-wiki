.. contents::

Unable to add bridge br0 port vnet0: No such device
===================================================

or, in libvirt 0.9.6 and earlier:

Failed to add tap interface to bridge 'br0': No such device
===========================================================

These messages mean that the bridge device specified in the domain's
<interface> definition doesn't exist.

You can verify that the bridge device doesn't exist with the shell
command "ifconfig br0" (or whatever device name was given in the error
message) - if it returns a message like the following, then the host has
no bridge by that name:

::

    br0: error fetching interface information: Device not found

If something like the following is returned, then you have a different
problem, and must look elsewhere for a solution:

::

    br0       Link encap:Ethernet  HWaddr 00:00:5A:11:70:48  
              inet addr:10.22.1.5  Bcast:10.255.255.255  Mask:255.0.0.0
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:249841 errors:0 dropped:0 overruns:0 frame:0
              TX packets:281948 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:106327234 (101.4 MiB)  TX bytes:21182634 (20.2 MiB)

Solution
--------

Either use "virsh edit $guestname" to change the <interface> definition
to use a bridge or network that already exists (e.g. change
"type='bridge'" to "type='network'", and "<source bridge='br0'/>" to
"<source network='default'/>", or add the given bridge device to the
host system configuration.

Create a Host Bridge Using virsh
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you have libvirt >= 0.9.8 and your distro supports the virsh iface-\*
commands (e.g. RHEL and Fedora) a bridge device can be created in one
easy step with the "virsh iface-bridge" command. The following command
will create a bridge device "br0" that has interface "eth0" attached:

::

     virsh iface-bridge eth0 br0

You can later remove this bridge and restore the original eth0
configuration with:

::

     virsh iface-unbridge br0

Create a Host Bridge Manually
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For older versions of libvirt and other OS distros that don't support
the virsh iface-\*, you can manually create a bridge device on the host
using `these instructions <Networking.html#host-configuration-bridged>`__.
