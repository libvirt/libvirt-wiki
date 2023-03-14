.. contents::

Switching to libvirt managed QEMU instances
===========================================

This page gives tips for migrating from standalone QEMU instances, over
to managed libvirt instances. It assumes your host is already configured
to run libvirt and QEMU. If it is not, then consult appropriate guide
for your OS

-  `Ubuntu libvirt + KVM walkthrough <UbuntuKVMWalkthrough.html>`__


Command line argument equivalence
---------------------------------

This section shows equivalence between QEMU command line arguments, and
libvirt XML configuration elements.

-drive, -hda, -cdrom, -sda, -fda, etc
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The QEMU command line options for specifying disk drives map to the
`<disk> configuration
element <http://libvirt.org/formatdomain.html#elementsDisks>`__ .
libvirt only uses -hda /-fda for very old QEMU, prefering -drive
whereever available.

If the path for the disk is under /dev, then use type='block', otherwise
use type='file' as on the top <disk> element. By default all disks are
exposed as harddisks, to request a CDROM or Floppy device, it is
neccessary to add device='cdrom' or device='floppy' to the <disk>
element.

If the path was under /dev, then it should be specified using <source
dev='/dev/XXX'/>, otherwise use <source file='/some/path'/>

By default, QEMU will probe for disk format. This is a potential
security hole because the guest OS can write data into the disk that
might trick the format probing code on future reboots. This can be
avoided by specifying a <driver> element. The 'name' attribute should
always be 'qemu', while the 'type' attribute will be the disk format.
eg, <driver name='qemu' type='qcow2'/>.

The final important thing is to specify the target device name and/or
bus type. This is done with the <target> element, eg <target dev='hda'
bus='ide'/>

::

      <disk type='block' device='disk'>
        <source dev='/dev/HostVG/VirtTest'/>
        <target dev='hda' bus='ide'/>
      </disk>

-S (uppercase)
~~~~~~~~~~~~~~

This is used internally by libvirt when starting all virtual machines.
It allows libvirt to set virtual CPU affinity between the time the CPU
threads are created but before the CPUs start executing.


-s (lowercase)
~~~~~~~~~~~~~~

The '-s' option provides a way to attach a remote debugger to a running
kernel in kvm. This option (and other options) can be specified by using
the qemu namespace for libvirt.

::

    <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>

and then:

::

    <qemu:commandline>
      <qemu:arg value='-s'/>
    </qemu:commandline>

-M (uppercase)
~~~~~~~~~~~~~~

Sets the machine type emulator. Valid machine types can be found in the
capabilities XML, eg via 'virsh capabilties'. If not specified libvirt
attempts to pick a suitable default. It can be configured in the <os>
element, via the machine attribute

::

    <os>
      <type arch='i686' machine='pc'>hvm</type>
      <boot dev='hd'/>
    </os>

-cpu
~~~~

Not currently exposed in the XML configuration.

If the emulator binary is 64-bit capable, but the requested guest
architecture is 32-bit, then libvirt will set "qemu32" as the CPU type

-no-kqemu
~~~~~~~~~

If the QEMU binary advertises support for KQEMU, and the libvirt domain
type is not kqemu, then this flag is passed, eg

::

    <domain type='qemu'>

will cause -no-kqemu to be set

-no-kvm
~~~~~~~

If the QEMU binary advertises support for KVM, and the libvirt domain
type is not kvm, then this flag is passed, eg

::

    <domain type='qemu'>

| cause -no-kvm to be set


-m (lowercase)
~~~~~~~~~~~~~~

This sets the maximum memory for the guest at boot time, as per the
<memory> XML element

::

    <memory>256000</memory>

| If there is also a 'currentMemory' element with a lower value, then
  the monitor 'balloon' command will be used at bootup

::

    <currentMemory>128000</currentMemory>

| libvirt specifies memory in KB, while QEMU only allows a granularity
  of MB, so libvirt values will be rounded to the nearest MB

-smp
~~~~

The number of virtual CPUs to create, as per the 'vcpu' XML element:

::

     <vcpu cpuset='1'>1</vcpu>

| If the 'cpuset' parameter is given, libvirt will call
  'sched_setaffinity' to map the virtual CPU threads onto the requested
  physical CPUs.

-name
~~~~~

THis is controlled by the libvirt guest name XML element

::

    <name>VirtTest</name>

-uuid
~~~~~

This is controlled by the libvirt guest UUID element

::

    <uuid>82038f2a-1344-aaf7-1a85-2a7250be2076</uuid>

-domid (xenner)
~~~~~~~~~~~~~~~

This is a xenner specific argument, used by libvirt to specify the guest
domain ID needed by Xen disk/network backends. This is allocated on
demand by libvirt and not user configurable

-nographic
~~~~~~~~~~

If the guest XML does \*NOT\* contain any <graphics> elements, this flag
will be passed to disable the default SDL display.

Since SDL is the default, the following:

::

      <graphics type='sdl' display=':0.0' xauth='/root/.Xatuh'/>

| will cause libvirt to \*NOT\* set the -nographic flag, and also set
  $DISPLAY and $XAUTHORITY environment variables

-monitor
~~~~~~~~

This is used internally by libvirt and is not configurable. Historically
libvirt used 'pty', but as of 0.7.0 has switched to use a UNIX domain
socket configuration.

-localtime
~~~~~~~~~~

This will be set if the guest XML contains a request for a clock synced
to localtime, eg

::

    <clock offset='localtime'/>

By default libvirt leaves guests in UTC mode

-no-reboot
~~~~~~~~~~

Controlled by the 'on_reboot' configuration element. Specifically, if it
is set to an action of 'destroy', then -no-reboot will be set, eg

::

    <on_reboot>destroy</on_reboot>

The default is to allow reboots.

-no-acpi
~~~~~~~~

If the <features> element does \*not\* contain <acpi>, then this flag
will be set. You really always want ACPI enabled, so ensure the XML has

::

    <features>
      <acpi/>
    </features>

-boot
~~~~~

The boot ordering is controlled via the <os> element's <boot> setting

::

    <os>
      <type arch='i686' machine='pc'>hvm</type>
      <boot dev='hd'/>
    </os>

| Valid device values are 'fd', 'hd', 'cdrom', and 'network',
  corresponding to 'a', 'c', 'd', and 'n'.

-kernel
~~~~~~~

If the <os> element has a <kernel> path specified, that will be used to
boot the guest

::

    <os>
      <type arch='i686' machine='pc'>hvm</type>
      <boot dev='hd'/>
      <kernel>/root/vmlinux<kernel>
    </os>

-initrd
~~~~~~~

If the <os> element has a <kernel> path specified, an initrd can also be
provided

::

    <os>
      <type arch='i686' machine='pc'>hvm</type>
      <boot dev='hd'/>
      <kernel>/root/vmlinux<kernel>
      <ramdisk>/root/initrd<ramdisk>
    </os>

-append
~~~~~~~

If the <os> element has a <kernel> path specified, extra command line
args can also be provided

::

    <os>
      <type arch='i686' machine='pc'>hvm</type>
      <boot dev='hd'/>
      <kernel>/root/vmlinux<kernel>
      <cmdline>console=ttyS0<cmdline>
    </os>

-bootloader (xenner)
~~~~~~~~~~~~~~~~~~~~

This is a xenner specific argument that can be used to pass a bootloader
path for paravirt guests

::

      <bootloader>/usr/bin/pygrub</bootloader>

-net
~~~~

libvirt supports a large number of the QEMU networking options
including, tap, user, mcast, client, server. An example which uses tap
indirectly for virtual networks is

::

      <interface type='network'>
        <mac address='52:54:00:39:38:cb'/>
        <source network='default'/>
      </interface>

-serial
~~~~~~~

libvirt supports nearly all the different character device options. A
really simple example is

::

      <serial type='pty'>
        <target port='0'/>
      </serial>

-parallel
~~~~~~~~~

libvirt supports nearly all the different character device options. A
really simple example is

::

      <parallel type='pty'>
        <target port='0'/>
      </parallel>

-usb
~~~~

libvirt will always enable USB for all guests, allowing for hotplug of
USB devices even if none were initially specified at boot time. As such
there is no configuration parameter required here.

-vnc
~~~~

VNC is the preferred graphical output, and configurable with something
like:

::

      <graphics type='vnc' port='-1' autoport='yes'/>

| Some of the settings are also controlled via defaults in
  /etc/libvirt/qemu.conf. libvirt will probe for and pick a free port
  number if autoport is enabled.

-k
~~

This is driven off the 'keymap' attribute on the <graphics> element

::

      <graphics type='vnc' port='-1' autoport='yes' keymap='de'/>

-full-screen
~~~~~~~~~~~~

This is drive off the fullscreen attribute for SDL graphics
configuration

::

      <graphics type='sdl' fullscreen='yes'/>

-vga
~~~~

This is used if QEMU is new enough, to support all the different video
adapter types, vga, cirrus, vmware, etc

::

      <video>
        <model type='vga'/>
      </video>

-std-vga
~~~~~~~~

This is used if 'vga' is requested and the -vga arg is not supported

::

      <video>
        <model type='vga'/>
      </video>

-vmwarevga
~~~~~~~~~~

This is used if the -vga parameter is not available

::

      <video>
        <model type='vmware'/>
      </video>

-soundhw
~~~~~~~~


-usbdevice
~~~~~~~~~~

This argument is used for assigning USB devices from the physical host
to a guest.

::

          <hostdev mode='subsystem' type='usb' managed='yes'>
            <source>
             <address bus='001' device='003'/>
            </source>
          </hostdev>

The bus/device IDs can be obtained from virsh via the 'virsh
nodedev-list --tree' and 'virsh nodedev-dumpxml' commands or using
'lsusb' to determine the bus and device.

The USB device can be hotplug from virsh via the 'virsh attach-device
{VMNAME} {custom_name}.xml'. The {custom_name}.xml file can be create as
above. The USB device can be detach from virsh via the 'virsh
detach-device {VMNAME} {custom_name}.xml'. The attach and detach command
can be execute on a running guest domain.

-pcidevice
~~~~~~~~~~

This argument is used for assigning PCI devices from the physical host
to a guest. It typically requires VT-D (Intel) or IOMMU (AMD) support in
the host chipset.

::

          <hostdev mode='subsystem' type='pci' managed='yes'>
            <source>
             <address bus='0x00' slot='0x19' function='0x00'/>
            </source>
          </hostdev>

The bus/slot/function IDs can be obtained from virsh via the 'virsh
nodedev-list --tree' and 'virsh nodedev-dumpxml' commands

-incoming
~~~~~~~~~

This is used internally by libvirt when performing an incoming
migration, or restoring a VM from a save file. As such it is not
configurable by the user

Monitor command equivalence
---------------------------

This section shows equivalence between QEMU monitor commands, and
libvirt APIs / virsh commands.

change DEV PATH
~~~~~~~~~~~~~~~

This command allows media for disks to be changed, eg changing CDROM
media

::

    change hdc /some/path/cdimage.iso

From the command line

::

    virsh attach-disk --type cdrom --mode readonly myguest /some/path/cdimage.iso hdc

Or from an API call, pass the following XML

::

    <disk type='file' device='cdrom'>
       <source file='/some/path/cdimage.iso'/>
       <target dev='hdc'/>
       <readonly/>
    </disk>

eject DEV
~~~~~~~~~

This command allows media for disks to be removed, eg removing CDROM
media

::

    eject hdc

From the command line

::

    virsh attach-disk --type cdrom --mode readonly myguest "" hdc

Or from an API call, pass the following XML, ie leave out the <source>
tag

::

    <disk type='file' device='cdrom'>
       <target dev='hdc'/>
       <readonly/>
    </disk>

change vnc PASSWORD
~~~~~~~~~~~~~~~~~~~

This command is issued automatically by libvirt when starting a new
guest, if the guest XML has a VNC password specified, or if
/etc/libvirt/qemu.conf has a default VNC password.

info cpus
~~~~~~~~~

This command is issued automatically by libvirt when starting a new
guest, to determine what OS threads correspond to virtual CPUs. This
enables libvirt to then call sched_setaffinity to fix the pCPU <-> vCPU
mapping

info balloon
~~~~~~~~~~~~

Triggered when virDomainGetXMLDescription, or virDomainGetInfo() are
called. It is used to determine the current guest memory balloon level.

info blockstats
~~~~~~~~~~~~~~~

Triggered from the
`virDomainGetBlockStats <http://libvirt.org/html/libvirt-libvirt-domain.html#virDomainBlockStats>`__
command to determine the I/O stats for a block device.

cont
~~~~

When booting a guest, libvirt always sets the '-S' flag so the guest is
initially stopped. After using 'info cpus' to determine and set
affinity, and setting a VNC password, 'cont' will be issued to start the
guest CPUs. It is also used to temporarily pause the guest when doing
certain operations, such as non-live migration, core dumps,
save/restore. Finally it can be done explicitly via the
virDomainResume() API call

stop
~~~~

Can be done by the virDomainSuspend() API call. Is also used
automatically in certain places like non-live migration, core dumps,
save/restore

system_powerdown
~~~~~~~~~~~~~~~~

Issued when doing virDomainShutdown() to request a controlled shutdown
of the guest. The guest may not honour this if ACPI is disabled, or if
nothing is listening for the ACPI event

balloon
~~~~~~~

If the guest XML is configured with a lower initial memory limit, the
'balloon' command will be called at startup to set the lower limit. It
can also be adjusted on the fly using virDomainSetMemory()

migrate exec:COMMAND
~~~~~~~~~~~~~~~~~~~~

This is used for generating core dumps, and VM state save files, ie the
virDomainDumpCore and virDomainSave() APIs

migrate set_speed
~~~~~~~~~~~~~~~~~

Used to throttle migration data rate.

migrate ``tcp:ADDR``
~~~~~~~~~~~~~~~~~~~~

Used for insecure, live migration between hosts.

pci_add ADDR storage CONFIG
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Used to hot-plug SCSI and VirtIO disks

pci_add ADDR nic CONFIG
~~~~~~~~~~~~~~~~~~~~~~~

Used to hot-plug all types of NIC

pci_del ADDR
~~~~~~~~~~~~

Used to hot-unplug NICs and Disks

host_net_remove VLAN NAME
~~~~~~~~~~~~~~~~~~~~~~~~~

Used to un-configure the NIC backend during hotunplug

host_net_add VLAN CONFIG
~~~~~~~~~~~~~~~~~~~~~~~~

Used to configure the NIC backend during hotplug

getfd FD
~~~~~~~~

Used when hotplugging a NIC that requires a TAP device

closefd FD
~~~~~~~~~~

Used in error cleanup path if NIC hotplug failed

usb_add disk:CONFIG
~~~~~~~~~~~~~~~~~~~

Used to hotplug a USB disk

usb_add host:VENDOR:PRODUCT
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Used to hotplug a host USB device into the guest

usb_add host:BUS.ADDRESS
~~~~~~~~~~~~~~~~~~~~~~~~

Used to hoplug a host USB device into the guest

memsave FILE
~~~~~~~~~~~~

Used for virDomainMemoryPeek to save a small region of guest virtual
memory

pmemsave FILE
~~~~~~~~~~~~~

Used for virDomainMemoryPeek to save a small region of guest physical
memory


Libvirt API to monitor commands (Outdated)
------------------------------------------

This section lists libvirt API functions that use QEMU monitor commands.

Please, observe that "indirectly" in the table below means that the
monitor command is actually executed as a result of calling another
function. Also, note that the execution of some commands may depend on
the result of conditional tests.

+----------------+----------------+----------------+----------------+
| virsh command  | Public API     | QEMU driver    | Monitor        |
|                |                | function       | command        |
+----------------+----------------+----------------+----------------+
| virsh create   | virDom         | qemud          | info cpus,     |
| XMLFILE        | ainCreateXML() | DomainCreate() | cont, change   |
|                |                |                | vnc password,  |
|                |                |                | balloon (all   |
|                |                |                | indirectly)    |
+----------------+----------------+----------------+----------------+
| virsh suspend  | virD           | qemudD         | stop           |
| GUEST          | omainSuspend() | omainSuspend() |                |
+----------------+----------------+----------------+----------------+
| virsh resume   | vir            | qemud          | cont           |
| GUEST          | DomainResume() | DomainResume() |                |
+----------------+----------------+----------------+----------------+
| virsh shutdown | virDo          | qemudDo        | sy             |
| GUEST          | mainShutdown() | mainShutdown() | stem_powerdown |
+----------------+----------------+----------------+----------------+
| virsh setmem   | virDom         | qemudDom       | balloon        |
| GUEST MEM-KB   | ainSetMemory() | ainSetMemory() | (indirectly)   |
+----------------+----------------+----------------+----------------+
| virsh dominfo  | virD           | qemudD         | info balloon   |
| GUEST          | omainGetInfo() | omainGetInfo() | (indirectly)   |
+----------------+----------------+----------------+----------------+
| virsh save     | v              | qem            | stop, migrate  |
| GUEST FILENAME | irDomainSave() | udDomainSave() | exec           |
+----------------+----------------+----------------+----------------+
| virsh restore  | virD           | qemudD         | cont           |
| FILENAME       | omainRestore() | omainRestore() |                |
+----------------+----------------+----------------+----------------+
| virsh dumpxml  | virD           | qemudD         | info balloon   |
| GUEST          | omainDumpXML() | omainDumpXML() | (indirectly)   |
+----------------+----------------+----------------+----------------+
| virsh          | virDomain      | qemudDomain    | change, eject, |
| attach-device  | AttachDevice() | AttachDevice() | usb_add,       |
| GUEST XMLFILE  |                |                | pci_add (all   |
|                |                |                | indirectly)    |
+----------------+----------------+----------------+----------------+
| virsh          | virDomain      | qemudDomain    | pci_del        |
| detach-device  | DetachDevice() | DetachDevice() | (indirectly)   |
| GUEST XMLFILE  |                |                |                |
+----------------+----------------+----------------+----------------+
| virsh migrate  | virD           | qemudDomainMi  | stop,          |
| GUEST DEST-URI | omainMigrate() | gratePerform() | migr           |
|                |                |                | ate_set_speed, |
|                |                |                | migrate, cont  |
+----------------+----------------+----------------+----------------+
| virsh          | virDoma        | qemudDoma      | info           |
| domblkstat     | inBlockStats() | inBlockStats() | blockstats     |
| GUEST          |                |                |                |
+----------------+----------------+----------------+----------------+
| -              | virDom         | qemudDoma      | memsave        |
|                | ainBlockPeek() | inMemoryPeek() |                |
+----------------+----------------+----------------+----------------+

NB, the attach-device/detach-device commands can also be run via
attach-disk/attach-interface without needing an XML file.
