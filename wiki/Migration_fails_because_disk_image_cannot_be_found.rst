.. contents::

Migration fails because disk image cannot be found
--------------------------------------------------

A domain cannot be migrated because libvirt complains that it cannot
access disk image(s):

::

   # virsh migrate qemu qemu+tcp://fedora2/system
   error: Unable to allow access for disk path /var/lib/libvirt/images/qemu.img: No such file or directory

Background
~~~~~~~~~~

By default, migration only transfers in-memory state of a running domain
(memory, CPU state, ...). Disk images are not transferred during
migration but they need to be accessible at the same path from both
hosts.

Solution
~~~~~~~~

Some kind of shared storage needs to be setup and mounted at the same
place on both hosts.

The simplest solution is to use NFS:

-  Setup an NFS server on a host serving as shared storage (this may
   even be one of the hosts involved in migration, as long as all hosts
   involved are accessing via NFS):

::

   # mkdir -p /exports/images
   # cat >>/etc/exports <<EOF
   /exports/images    192.168.122.0/24(rw,no_root_squash)
   EOF

-  Mount the exported directory at a common place on all hosts running
   libvirt (let's suppose the IP address of our NFS server is
   192.168.122.1):

::

   # cat >>/etc/fstab <<EOF
   192.168.122.1:/exports/images  /var/lib/libvirt/images  nfs  auto  0 0
   EOF
   # mount /var/lib/libvirt/images

Beware, that naive solution of exporting a local directory from one host
using NFS and mounting it at the same path on the other host would not
work. The directory used for storing disk images has to be mounted from
shared storage on both hosts. Otherwise, the domain may lose access to
its disk images during migration because source libvirtd may change the
owner, permissions, and SELinux labels on the disk images once it
successfully migrates the domain to its destination. Libvirt avoids
doing such things if it detects that the disk images are mounted from a
shared storage.
