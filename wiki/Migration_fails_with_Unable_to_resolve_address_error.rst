.. contents::

Migration fails with "Unable to resolve address" error
------------------------------------------------------

Trying to migrate qemu domain fails:

::

   # virsh migrate qemu qemu+tcp://192.168.122.12/system
   error: Unable to resolve address 'fedora2' service '49155': Name or service not known

The error looks strange as we did not use "fedora2" name anywhere.

Background
~~~~~~~~~~

During migration, libvirtd running on destination host creates a URI
from an address and port where it expects to receive migration data and
sends it back to libvirtd running on source host. In our case,
destination host (192.168.122.12) has its name set to "fedora2". For
some reason, libvirtd running on that host was not able to resolve the
name to an IP address that could be sent back and still be useful and
thus it sent the hostname hoping the source libvirtd would be more
successful with resolving the name. This may happen if DNS is not
properly configured or ``/etc/hosts`` has the hostname associated with
local loopback address (127.0.0.1).

Note that the address used for migration data cannot be automatically
determined from the address used for connecting to destination libvirtd
(i.e., from ``qemu+tcp://192.168.122.12/system``) because source
libvirtd may need to use different network infrastructure to communicate
with destination libvirtd than what virsh (possibly running on a
separate machine) needs to use.

Solution
~~~~~~~~

The most general and also preferred solution is to properly configure
DNS so that all hosts involved in migration are able to resolve all host
names.

If, for whatever reason, DNS cannot be configured properly, all hosts
used for migration may be added to ``/etc/hosts`` on each of the hosts.
However, keeping such lists consistent in dynamic environment is hard.

In case host names cannot be made resolvable by any mean,
``virsh migrate`` supports specifying migration host explicitly:

::

   # virsh migrate qemu qemu+tcp://192.168.122.12/system tcp://192.168.122.12

Destination libvirtd will take the ``tcp://192.168.122.12`` URI and
append automatically generated port number. If this is not desirable
(because of firewall configuration, for example), the port number can be
specified explicitly:

::

   # virsh migrate qemu qemu+tcp://192.168.122.12/system tcp://192.168.122.12:12345

Another option would be to use tunneled migration, which does not create
separate connection for migration data and rather tunnels the data
through the connection used for communication with destination libvirtd
(i.e., ``qemu+tcp://192.168.122.12/system``):

::

   # virsh migrate qemu qemu+tcp://192.168.122.12/system --p2p --tunnelled
