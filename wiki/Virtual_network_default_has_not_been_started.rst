.. contents::

Virtual network 'default' has not been started
----------------------------------------------

Normally the config for a virtual network called "default" is installed
as part of the libvirt package, and it is setup to autostart when
libvirtd is started.

If, for some reason, the "default" network (or any other locally-created
network) could not be started, any domains configured to use that
network for its connectivity will also fail to start, giving the message
in the title.

One of the most common causes for a libvirt virtual network's failure to
start is that the dnsmasq instance required to serve DHCP and DNS
requests from clients on that network failed to start. To determine if
this was the cause, run the following command from a root shell:

::

     virsh net-start default

If it is successful, the problem was some other intermittent condition
that has now passed. If not, look in /var/log/libvirt/libvirtd.log for
the full error log message. If you see a message similar to the
following:

::

      Could not start virtual network 'default': internal error
      Child process (/usr/sbin/dnsmasq --strict-order --bind-interfaces
      --pid-file=/var/run/libvirt/network/default.pid --conf-file=
      --except-interface lo --listen-address 192.168.122.1
      --dhcp-range 192.168.122.2,192.168.122.254
      --dhcp-leasefile=/var/lib/libvirt/dnsmasq/default.leases
      --dhcp-lease-max=253 --dhcp-no-override) status unexpected: exit status 2

(the important parts are "dnsmasq" and "exit status 2") then the problem
is most likely a systemwide dnsmasq instance that is already listening
on libvirt's bridge (thus preventing libvirt's own dnsmasq instance from
doing so).

Solution
--------

1) If you're not actually using dnsmasq on this machine to serve DHCP
for the \*physical network\*, you should just disable dnsmasq
completely.

Here is a handy pointer to instructions on
starting/stopping/enabling/disabling systems services on various flavors
of Linux:

http://linuxhelp.blogspot.com/2006/04/enabling-and-disabling-services-during_01.html

2) In the unlikely case that you do need to run dnsmasq to serve DHCP
for the physical network, you should edit /etc/dnsmasq.conf, and add (or
uncomment) the following lines:

::

    bind-interfaces
    interface=[some physical interface name, e.g. eth0]
    listen-address=[ip address of the interface you want, e.g. 192.168.1.1]

(pick one of either line 2 or line 3, but not both)

After you've made this change and saved the file, restart the systemwide
dnsmasq service (see the above link for directions specific to your
Linux distro).

Now you should be able to start the default network:

::

     virsh net-start default

and after this, you should be able to start your domains.
