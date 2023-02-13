.. contents::

Virtio
======

So-called "full virtualization" is a nice feature because it allows you
to run any operating system virtualized. However, it's slow because the
hypervisor has to emulate actual physical devices such as RTL8139
network cards . This emulation is both complicated and inefficient.

Virtio is a virtualization standard for network and disk device drivers
where just the guest's device driver "knows" it is running in a virtual
environment, and cooperates with the hypervisor. This enables guests to
get high performance network and disk operations, and gives most of the
performance benefits of paravirtualization.

Note that virtio is different, but architecturally similar to, Xen
paravirtualized device drivers (such as the ones that you can install in
a Windows guest to make it go faster under Xen). Also similar is
VMWare's Guest Tools.

This page describes how to configure libvirt to use virtio with KVM
guests.

Requirements
------------

-  KVM or recent (not 0.9.1) development QEMU
-  A virtio-compatible guest: any Linux OS with kernel >= 2.6.25 should
   be OK. Fedora 9 and above are explicitly supported.
-  libvirt >= 0.4.4

We assume that you have installed the virtio-compatible guest under KVM
using libvirt (ie. using something like virt-install or virt-manager).

For a Windows guest, it is necessary to install the latest `virtio
drivers <http://www.linux-kvm.org/page/WindowsGuestDrivers/Download_Drivers>`__
into the guest OS. Additional
`network <http://www.linux-kvm.com/content/tip-how-setup-windows-guest-paravirtual-network-drivers>`__
and
`disk <http://www.linux-kvm.com/content/redhat-54-windows-virtio-drivers-part-2-block-drivers>`__
tips are available, outlining the process for installing drivers.

Network driver
--------------

First, shut down the guest and then edit its configuration file:

::

   virsh edit guestname

In the <interface> section, add a virtio model, like this:

::

   <interface type='network'>
     ...
     <model type='virtio' />
   </interface>

When you boot the guest (``virsh start guestname``), if it worked you
should still have a working network, and you should see (from inside the
guest) that you are using the virtio_net driver:

::

   # /sbin/lsmod | grep virtio
   [shows virtio_pci, virtio_net and others loaded]
   # cat /sys/devices/virtio-pci/0/net/eth0/statistics/rx_bytes
   ...

If it doesn't work, then check the following file in the host for
errors:

::

   /var/log/libvirt/qemu/[guestname].log

There are quite a lot of things that could go wrong such as: not using
KVM, or not using a sufficiently recent version of KVM.

Disk (block) device driver
--------------------------

Similar to above, except the the configuration file should be changed to
e.g.:

::

   <disk type='...' device='disk'>
     ...
     <target dev='vda' bus='virtio'/>
   </disk>

If there remove any

::

   <address .../>

element for this disk that may exist, allowing libvirt to regenerated it
appropriately.

However, if this is to be the disk which holds the guest's root
filesystem, you first need to ensure that the guest will be able to
mount the virtio disk during bootup.

On Fedora 9 or later, you can do this using mkinitrd:

::

    # mkinitrd --with virtio_pci --with virtio_blk -f /boot/initrd-$(uname -r).img $(uname -r)

Note, this step is only needed in order to transition a guest from IDE
or SCSI to virtio. If you initially install the guest using a virtio
disk, or if you update the kernel package while booted from a virtio
disk, then this step is not needed.

External links
--------------

-  http://www.linux-kvm.com/content/block-driver-updates-install-drivers-during-windows-installation
-  http://www.linux-kvm.org/page/WindowsGuestDrivers/Download_Drivers
-  http://www.linux-kvm.com/content/latest-windows-virtio-drivers
-  http://www.linux-kvm.org/page/Virtio
-  http://www.linux-kvm.org/page/Using_VirtIO_NIC
-  `Boot from virtio block
   device <http://www.linux-kvm.org/page/Boot_from_virtio_block_device>`__
-  `How to install Windows guest with virtio network and disk
   controllers <http://www.linux-kvm.com/content/tip-how-setup-windows-guest-paravirtual-network-drivers>`__
-  `How to switch Windows guest to virtio network and disk
   controllers <http://blog.bfccomputing.com/articles/2009/09/14/converting-a-windows-vista-kvm-virtual-machine-to-redhat-virtio-drivers>`__
