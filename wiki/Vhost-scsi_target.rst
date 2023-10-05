.. contents::

A vhost-scsi target uses a fabric module in a host kernel to provide KVM
guests with a fast virtio-based connection to SCSI LUNs.

Host Setup
----------

Presuming that a host has one or more SCSI LUNs configured, a vhost
target and unique WWN must be created to represent them. This can be
done by manually editing ``/sys/kernel/config`` but will be much easier
to use a utility such as
`targetcli <http://linux-iscsi.org/wiki/Targetcli>`__. For example,
using a single SCSI LUN, we can see:

::

   # targetcli
   targetcli shell version 2.1.fb35
   Copyright 2011-2013 by Datera, Inc and others.
   For help on commands, type 'help'.

   /> backstores/block create name=disk0 write_back=false \
      dev=/dev/disk/by-id/dm-uuid-mpath-36005076306ffc7630000000000002000
   Created block storage object disk0 using
      /dev/disk/by-id/dm-uuid-mpath-36005076306ffc7630000000000002000.
   /> vhost/ create
   Created target naa.500140568720f76f.
   Created TPG 1.
   /> vhost/naa.500140568720f76f/tpg1/luns create /backstores/block/disk0
   Created LUN 0.
   /> exit

The above example creates a number of directories and files in
``/sys/kernel/config/``

::

   # ls /sys/kernel/config/target/vhost/
   discovery_auth  naa.500140568720f76f  version
   # ls -l /sys/kernel/config/target/vhost/naa.500140568720f76f/tpgt_1/lun/lun_0/
   total 0
   lrwxrwxrwx 1 root root    0 Nov 14 14:42 a08824829b -> ../../../../../../target/core/iblock_0/disk0
   -rw-r--r-- 1 root root 4096 Nov 28 19:08 alua_tg_pt_gp
   -rw-r--r-- 1 root root 4096 Nov 28 19:08 alua_tg_pt_offline
   -rw-r--r-- 1 root root 4096 Nov 28 19:08 alua_tg_pt_status
   -rw-r--r-- 1 root root 4096 Nov 28 19:08 alua_tg_pt_write_md
   drwxr-xr-x 5 root root    0 Nov 14 14:42 statistics
   # cat /sys/kernel/config/target/vhost/naa.500140568720f76f/tpgt_1/lun/lun_0/a08824829b/info 
   Status: ACTIVATED  Max Queue Depth: 0  SectorSize: 512  HwMaxSectors: 4592
           iBlock device: dm-0  UDEV PATH: /dev/disk/by-id/dm-uuid-mpath-36005076306ffc7630000000000002000  readonly: 0
           Major: 252 Minor: 0  CLAIMED: IBLOCK

In this example, a multipath SCSI LUN identifier is specified because of
``multipathd`` running on the host. However, only one path exists for
the device being configured.

::

   # multipath -l | grep -A 4 36005076306ffc7630000000000002000
   mpathb (36005076306ffc7630000000000002000) dm-0 IBM     ,2107900         
   size=14G features='1 queue_if_no_path' hwhandler='0' wp=rw
   `-+- policy='service-time 0' prio=0 status=active
     `- 0:0:9:1073758240  sda 8:0   active undef running
   mpathh (36005076306ffc7630000000000002006) dm-6 IBM     ,2107900

If additional paths are configured on the host they can be joined via
``multipathd``. Alternatively, the paths can be excluded from multipath
and the individual paths added to the vhost-scsi target. The latter will
make the independent paths visible to the guest OS, such that it's own
``multipathd`` can perform the grouping.

QEMU Arguments
--------------

With a vhost-scsi target defined on the host, the WWN of the target can
be specified on a QEMU command line for the guest being created, in
order to give control of all LUNs within it to that guest:

::

   -device vhost-scsi-pci,wwpn=naa.500140568720f76f,bus=pci.0,addr=0x5

::

   -device vhost-scsi-ccw,wwpn=naa.500140568720f76f,devno=fe.0.1000

Libvirt XML
-----------

To recreate this information in Libvirt XML, a new
``hostdev mode='subsystem'`` XML tag can be specified with a
``type='scsi_host'``:

::

   <hostdev mode='subsystem' type='scsi_host'>
     <source protocol='vhost' wwpn='naa.500140568720f76f'/>
   </hostdev>

As with other ``hostdev`` tags, an optional ``address`` can be specified
depending on whether the guest machine using PCI or CCW addressing:

::

   <hostdev mode='subsystem' type='scsi_host'>
     <source protocol='vhost' wwpn='naa.500140568720f76f'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
   </hostdev>

::

   <hostdev mode='subsystem' type='scsi_host'>
     <source protocol='vhost' wwpn='naa.500140568720f76f'/>
     <address type='ccw' cssid='0xfe' ssid='0x0' devno='0x1000'/>
   </hostdev>

Guest Viewpoint
---------------

From the guest's point of view, the SCSI LUN(s) attached to the
vhost-scsi target will be presented via the guest device drivers, such
as ``sd`` and ``sg``.

::

   # lsscsi -g
   [0:0:1:0]    disk    LIO-ORG  disk0            4.0   /dev/sda   /dev/sg0 
   # dmesg | grep 0:
   [    2.749783] scsi host0: Virtio SCSI HBA
   [    2.751955] scsi 0:0:1:0: Direct-Access     LIO-ORG  disk0            4.0  PQ: 0 ANSI: 5
   [    2.972780] sd 0:0:1:0: Attached scsi generic sg0 type 0
   [    2.972789] sd 0:0:1:0: [sda] 29360128 512-byte logical blocks: (15.0 GB/14.0 GiB)
   [    2.972892] sd 0:0:1:0: [sda] Write Protect is off
   [    2.972893] sd 0:0:1:0: [sda] Mode Sense: 43 00 10 08
   [    2.972962] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
   [    2.974199] sd 0:0:1:0: [sda] Attached SCSI disk
