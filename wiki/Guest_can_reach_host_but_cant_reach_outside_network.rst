.. contents::

Guest can reach host, but can't reach outside network
=====================================================

When a guest interface is of type='network' (i.e. using a
libvirt-managed "virtual network"), sometimes the guest will be able to
reach the host (both via its IP address on the virtual network, e.g.
192.168.122.1 for the "default" virtual network, and via the host's
publicly visible IP address, but it won't be able to reach any IP
address outside of the host (on the physical network). There can be a
few possible reasons for this:

1) The iptables rules setup on the host has been disturbed.
-----------------------------------------------------------

This can happen if, for example, a firewall management application
decides to clear all iptables rules and reload its own rules. Since it
doesn't know about the rules added by libvirt, they will be lost.
Alternately, sometimes another application inserts a new rule before
libvirt's rules which takes precedence over the rules added by libvirt.

To see if this is the source of the problem, simply restart libvirtd,
e.g.:

::

     service libvirtd restart

This does not disrupt running guests in any way, and libvirtd will
reload all of its iptables rules when it restarts.

2) IP forwarding has been disabled on the host.
-----------------------------------------------

To see if this is the problem, run this command:

::

     sysctl net.ipv4.ip_forward

If the result is:

::

     net.ipv4.ip_forward = 1

then IP forwarding is not your problem. If the result is:

::

     net.ipv4.ip_forward = 0

then it definitely is at least **one of** your problems. libvirtd
normally enables ip_forwarding whenever it starts a network that has
<forward mode='route|nat'>, but it **does not** 1) permanently set it in
/etc/sysctl.conf, or 2) re-set it if libvirtd is reloaded.

This is normally not a problem, but can become a problem if some other
application or service sets IP forwarding back to 0. For example, when
NetworkManager is started/restarted, it will run "sysctl -p", which
reloads all of the sysctl settings in /etc/sysctl.conf. The default
value of net.ipv4.ip_forward in that file is "0", meaning that every
time NetworkManager is reloaded, it will disable IP forwarding.

Temporary Solution
------------------

::

     # sysctl -w net.ipv4.ip_forward=1

Permanent Solution
------------------

Change the setting in /etc/sysctl.conf to

::

     net.ipv4.ip_forward = 1

and run

::

     sysctl -p

3) The libvirt network has <forward mode='route'/> and the outside network doesn't have a route to reach libvirt's virtual network
----------------------------------------------------------------------------------------------------------------------------------

If your libvirt network is using <forward mode='route'/>, you are
responsible for informing the rest of your network that the gateway to
this network is the external/public IP address of your virtualization
host. Instructions on how to do this are dependent on the setup of your
network, and beyond the scope of this troubleshooting guide.
