.. contents::

Tips
====

This is a general place to put hints and tips for libvirt.

Debian/Ubuntu guests under KVM don't shut down properly
-------------------------------------------------------

KVM just sends an ACPI signal to the guest to tell it to shut down. Of
course, this means the guest needs to do something useful when it
receives the signal! By default Debian/Ubuntu guests don't.

Solution: install ``acpid`` in the guest.

(Thanks to Soren Hansen)

Libvirt wont connect to qemu hypervisor (KVM)
---------------------------------------------

Clean install on Ubuntu 8.10 desktop. Built KVM from scratch, and
installed in default location. Built LibVirtD from scratch, and also
installed in the default location. Entering virsh -c qemu:///system gave
an error about not being able to connect to the hypervisor.

The problem is the hard-coded list of places it looks for qemu/kvm:

::

   if ((virFileExists("/usr/bin/qemu")) ||
         (virFileExists("/usr/bin/qemu-kvm")) ||
         (virFileExists("/usr/bin/kvm")) ||
         (virFileExists("/usr/bin/xenner")))
         return 1;

The solution was to symlink the real qemu launcher program to one of the
above locations.

UPDATE: As of the 0.7.6 release, libvirt will now search in $PATH for
all the binaries

The connection fails using md5 digest auth
------------------------------------------

virsh will just say:

::

   failed to connect to the hypervisor

and virt-manager:

::

   Failed to start SASL negotiation: -4 (SASL(-4): no mechanism available: No worthy mechs found)

Make sure all the necessary SASL libraries are installed. On
Debian/Ubuntu the package libsasl2-modules is necessary to get it to
work.

Enabling debug output for libvirtd and virsh
--------------------------------------------

::

   export  LIBVIRT_DEBUG=yes

Will enable debug messages. Provided ENABLE_DEBUG is specified at the
./configure stage (i think). This is very helpful in diagnosing
problems.

Increasing the disk size of a virtual machine
---------------------------------------------

Using virt-rescue
~~~~~~~~~~~~~~~~~

Consider the case of a VM created with default storage size, where the
guest is running Fedora on an lvm partition. If the VM runs out of disk
space, because the default disk allocation turned out to be
insufficient, then it is desirable to allocate more storage from the
host. By far the easiest way to do this is to use
`virt-resize <http://libguestfs.org/virt-resize.1.html>`__.

However, using virt-resize requires storage space on the host for both
the old and new images at the same time.

Another method is to use
`virt-rescue <http://libguestfs.org/virt-rescue.1.html>`__ which gives
you a text-based rescue CD containing parted. This lets you move and
manipulate partitions in the guest by hand (be careful).

A third way is as follows (example using a Fedora 12 host):

-  Increase the size of the backing file on the host, then inform
   libvirtd of the change:

::

   su
   cd /var/libvirt/images
   truncate --size=+2G storage.img
   virsh pool-refresh default

**default** may vary if you use other storage options. Use the following
command to list all available pools:

::

   virsh pool-list --all

-  Update the VM description to boot from a LiveDVD image that can
   access partition resizing tools (for example, the latest Fedora image
   http://fedoraproject.org/en/get-fedora-all). The virt-manager gui
   makes this easier:

::

   choose the VM to be resized
   gracefully shut it down
   Edit->Virtual Machine Details
   select Boot Options, set Boot Device to CDROM, and Apply
   select IDE CDROM 1, Connect, and browse to .iso image

-  Boot the VM using the LiveDVD image, to rearrange partitions. Once
   booted, open a terminal, and:

::

   su
   yum install gparted system-config-lvm
   gparted
    - select the free space
    - create a new ext4 partition
    - apply changes
    - exit
   system-config-lvm
    - under Uninitialized Entities, find the newly-created partition, and select Initialize
    - select add to an existing volume group, and choose the correct group name
    - under Volume Groups, find the Logical View of the modified volume group, and Edit Properties
    - change the size of the logical volume to consume the free space remaining from the volume group
   shutdown

-  Update the VM description back to normal disk boot. The virt-manager
   gui makes this easier:

::

   choose the VM that was just resized
   Edit->Virtual Machine Details
   select Boot Options, set Boot Device to Hard Disk, and Apply
   select IDE CDROM 1, Disconnect

-  Boot the VM, and check that the disk size increased as desired:

::

   df

Using qemu-img and cloud utils
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. `extend/increase KVM Virtual Machine (VM) disk
   size <https://computingforgeeks.com/how-to-extend-increase-kvm-virtual-machine-disk-size/>`__
#. `extend root filesystem using LVM on
   Linux <https://computingforgeeks.com/extending-root-filesystem-using-lvm-linux/>`__
   or `extend root filesystem using LVM on
   Linux <https://computingforgeeks.com/extending-root-filesystem-using-lvm-linux/>`__

Adding an alternative storage pool
----------------------------------

If the default storage location of /var/lib/libvirt/images does not have
enough space for the volumes that you wish to assign to virtual
machines, you can add a second storage pool. These steps may prove
helpful:

::

   virsh pool-dumpxml default > pool.xml
   edit pool.xml # with new name and path
   virsh pool-create pool.xml
   virsh pool-refresh name

One side note: You will need to delete the UUID field in the xml file if
you intend to keep the default pool - no two pools defined can have the
same UUID - but keep the brackets like so: '<uuid></uuid>'
