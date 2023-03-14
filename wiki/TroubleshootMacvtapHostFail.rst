.. contents::

Guest can reach outside network, but can't reach host (macvtap)
===============================================================

macvtap interfaces (type='direct' - `see the libvirt documentation on
the
topic <https://libvirt.org/formatdomain.html#elementsNICSDirect>`__)
can be useful even when not connecting to a VEPA or VNLINK capable
switch - setting the mode of such an interface to 'bridge' will allow
the guest to be directly connected to the physical network in a very
simple manner without the setup hassles (or NetworkManager
incompatibility) that accompany use of a traditional host bridge device.

However, once a guest has been configured to use a "type='direct'"
network interface (a.k.a. macvtap), users will commonly be surprised
that the guest is able to communicate with other guests, and also with
other external hosts on the network, but cannot communicate with the
virt host on which the guest in question lives.

**This is not a bug**, it is the defined behavior of macvtap - due to
the way that the host's physical ethernet is attached to the macvtap
bridge, traffic into that bridge from the guests that is forwarded to
the physical interface cannot be bounced back up to the host's IP stack
(and also, traffic from the host's IP stack that is sent to the physical
interface cannot be bounced back up to the macvtap bridge for forwarding
to the guests.)

Solution
~~~~~~~~

One possible method of eliminating this problem would be to create a
separate macvtap interface for host use, and give it the IP
configuration previously on the physical ethernet (see `this
page <http://virt.kernelnewbies.org/MacVTap>`__ for an example of how to
manually configure an interface on the physical host to use macvtap, and
`this
page <http://www.furorteutonicus.eu/2013/08/04/enabling-host-guest-networking-with-kvm-macvlan-and-macvtap/>`__
for a script) - in this way, the host would be an equal peer attached to
the macvlap bridge, and thus guest and host could communicate directly.

However, this solution has two problems - 1) it reintroduces just as
much complexity to the configuration as would setting up a traditional
Linux host bridge and 2) Just as NetworkManager currently doesn't
understand bridge devices, it also doesn't understand macvtap devices,
so NetworkManager would be unable to monitor the online state of the
macvtap interface, and would give erroneous reports about the online
status of the host. In other words, it's really no better than just
using a traditional host bridge (with the added problem that even the
traditional methods of network configuration (e.g. initscripts on Fedora
and RHEL) don't support configuration of a macvtap device).

Less Painful Solution
~~~~~~~~~~~~~~~~~~~~~

There is an alternate solution which preserves NetworkManager
compatibility while allowing guest and host to directly communicate. In
short, the solution is use libvirt to create an isolated network, and
give each guest a second interface that is connected to this network;
host<-->guest communication will then take place over the isolated
network.

1) Save the following XML to /tmp/isolated.xml:

   ::

         <network>
           <name>isolated</name>
             <ip address='192.168.254.1' netmask='255.255.255.0'>
             <dhcp>
               <range start='192.168.254.2' end='192.168.254.254' />
             </dhcp>
           </ip>
         </network>

   (if the 192.168.254.0/24 network is already in use elsewhere on your
   network, you can choose a different network).

2) Create the network, set it to autostart, and start it:

   ::

         virsh net-define /tmp/isolated.xml
         virsh net-autostart isolated
         virsh net-start isolated

3) Edit (using "virsh edit $guestname") the configuration of each guest
   that uses direct (macvtap) for its network connection and add a new
   <interface> in the <devices> section similar to the following:

   ::

         <interface type='network'>
           <source network='isolated'/>
           <model type='virtio'/> <-- This line is optional.
         </interface>

4) shutdown, then restart each of these guests.

   The guests will now be able to reach the host at the address
   192.168.254.1, and the host will be able to reach the guests at whatever
   IP address they acquired from DHCP (alternately you can manually
   configure them). Since this new network is isolated to only the host and
   guests, all other communication from the guests will use the macvtap
   interface.
