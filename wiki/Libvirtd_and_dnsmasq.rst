.. contents::

Running your own dnsmasq with libvirtd
======================================

On linux host servers, libvirtd uses dnsmasq to service the virtual
networks, such as the `default network <Networking.html>`__. A new
instance of dnsmasq is started for each virtual network, only accessible
to guests in that specific network.

If you are running your own "global" dnsmasq, then this can cause your
own dnsmasq to fail to start (or for libvirtd to fail to start its
dnsmasq and the given virtual network). This happens because both
instances of dnsmasq might try to bind to the same port number on the
same network interfaces.

You have to change the global **/etc/dnsmasq.conf** as follows:

*Either:*

::

   interface=eth0

*or*

::

   listen-address=192.168.0.1

(Replace interface or listen-address with the interfaces or addresses
you want your global dnsmasq to answer queries on).

*And* uncomment this line to tell dnsmasq to only bind specific
interfaces, not try to bind all interfaces:

::

   bind-interfaces
