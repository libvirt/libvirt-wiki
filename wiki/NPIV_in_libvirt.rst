.. contents::

**NPIV** (N_Port ID Virtualization) is a Fibre Channel technology to
share a single physical Fibre Channel HBA with multiple virtual ports.
Henceforth known as a "virtual port" or "virtual Host Bus Adapter"
(vHBA), each virtual port is identified by its own WWPN (Word Wide Port
Name) and WWNN (Word Wide Node Name). In the virtualization world the
vHBA controls the LUNs for virtual machines.

The libvirt implementation provides flexibility to configure the LUN's
either directly to the virtual machine or as part of a storage pool
which then can be configured for use on a virtual machine.

NPIV support in libvirt was first added to libvirt **0.6.5**; however,
the following sections will describe NPIV functionality as of more
modern libvirt releases providing release specific differentiation as
functionality was added. There will be a troubleshooting and prior
version considerations section to describe some historical differences.

Discovery
---------

Discovery of HBA(s) capable of NPIV is provided through the virsh
command "virsh nodedev-list --cap vports" which will return a list of
scsi_host's capable of generating a vHBA. These scsi_host's will be
described as the **parent**. If no HBA is returned, then the host
configuration should be checked.

From the list of NPIV capable HBA(s), use the virsh command "virsh
nodedev-dumpxml scsi_hostN" to view more details. The XML output will
will list fields <name>, <wwnn>, <wwpn>, and <fabric_wwn> that may be
used to create a vHBA. Take care to also note the <max_vports> and
<vports> values as they provide the number of vports currently defined
for vHBA usage and the maximum vports that may be created for vHBA
usage.

The following example indicates a host which has two HBAs to support
vHBA and the layout of a HBA's XML:

::

      # virsh nodedev-list --cap vports
      scsi_host3
      scsi_host4

::

      # virsh nodedev-dumpxml scsi_host3
      <device>
        <name>scsi_host3</name>
        <path>/sys/devices/pci0000:00/0000:00:04.0/0000:10:00.0/host3</path>
        <parent>pci_0000_10_00_0</parent>
        <capability type='scsi_host'>
          <host>3</host>
          <unique_id>0</unique_id>
          <capability type='fc_host'>
            <wwnn>20000000c9848140</wwnn>
            <wwpn>10000000c9848140</wwpn>
            <fabric_wwn>2002000573de9a81</fabric_wwn>
          </capability>
          <capability type='vport_ops'>
            <max_vports>127</max_vports>
            <vports>1</vports>
          </capability>
        </capability>
      </device>

The "max_vports" value indicates there are a possible of 127 vports
available for use in the HBA configuration. The "vports" value indicates
the number of vports currently being used.

Support for detection of HBA's capable of NPIV support prior to libvirt
**1.0.4** is described in the "`#Troubleshooting <#Troubleshooting>`__"
section.

Creation of the vHBA
--------------------

A vHBA is created either directly using the node device driver or
indirectly via a libvirt storage pool. Which methodology to use depends
on your usage model. When creating via the node device driver, the vHBA
will be available during the current system boot. If the host reboots,
then management and regeneration of the vHBA is a system administration
task. When creating via a storage pool, libvirt will automatically
create the vHBA when the storage pool is started and destroy the vHBA
when the storage pool is destroyed. If the storage pool is automatically
started when libvirt is started, then the vHBA will be available to be
used by libvirt domains. Automatic pool startup can be managed via the
"virsh pool-autostart" command.

In libvirt terminology, a node device driver created vHBA would be
considered transient across host reboots, while a storage pool created
vHBA would be considered persistent. It is recommended to define a
libvirt storage pool based on the HBA in order to preserve the vHBA
configuration. Additionally, storage pools will discover and list all
the LUNs available for domain usage providing a simple mechanism in
order to provide the LUN to the domain. A storage pool also provides a
consistent naming mechanism for migration.

Creation of a vHBA using the node device driver
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to create a vHBA using the node device driver, select an HBA
with available "vport" space, use the HBA "<name>" field as the
"<parent>" field in the following XML:

::

      <device>
        <parent>scsi_host3</parent>
        <capability type='scsi_host'>
          <capability type='fc_host'>
          </capability>
        </capability>
      </device>

<parent> support was added in libvirt **1.1.2**.

Since the parent scsi_hostN value can change between reboots or after
hardware reconfiguration, libvirt **3.0.0** added two more ways to
identify which HBA will be used to create the vHBA. The <parent> XML was
extended to allow providing attributes "wwnn" and "wwpn" or "fabric_wwn"
in the XML as follows:

::

      <device>
        <parent wwnn='20000000c9848140' wwpn='10000000c9848140'/>
        <capability type='scsi_host'>
          <capability type='fc_host'>
          </capability>
        </capability>
      </device>

or:

::

      <device>
        <parent fabric_wwn='2002000573de9a81'/>
        <capability type='scsi_host'>
          <capability type='fc_host'>
          </capability>
        </capability>
      </device>

You will note that the parent wwnn/wwpn and fabric_wwn match the same
named capability elements found in the scsi_host3 nodedev-dumpxml
output. Only one of the three options needs to be provided. If multiple
parent options are provided, the parent name will take precedence over
the parent wwnn/wwpn which takes precedence over parent fabric_wwn. Only
the first found parent element is decoded.

**NOTE:** As of libvirt **3.0.0** it is also possible to not provide any
parent information and the nodedev-create will find an NPIV capable HBA
for you.

To create the vHBA use the command "virsh nodedev-create" (assuming
above XML file is named "vhba.xml"):

::

      # virsh nodedev-create vhba.xml
      Node device scsi_host12 created from vhba.xml

**NOTE:** If you specify "name" for the vHBA, then it will be ignored.
The kernel will automatically pick the next SCSI host name in sequence
not already used. If not provided, the "wwpn" and "wwnn" values for the
vHBA will be generated by libvirt and the "fabric_wwn" will match that
of the parent. In order to provide a specific "wwnn" and "wwpn" use the
following example:

::

      <device>
        <parent>scsi_host3</parent>
        <capability type='scsi_host'>
          <capability type='fc_host'>
            <wwnn>2001001b32a9da5e</wwnn>
            <wwpn>2101001b32a9da5e</wwpn>
          </capability>
        </capability>
      </device>

In order to see the generated vHBA XML, use the command "virsh
nodedev-dumpxml" as follows:

::

      # virsh nodedev-dumpxml scsi_host12
      <device>
        <name>scsi_host12</name>
        <path>/sys/devices/pci0000:00/0000:00:04.0/0000:10:00.0/host3/vport-3:0-4/host12</path>
        <parent>scsi_host3</parent>
        <capability type='scsi_host'>
          <host>12</host>
          <unique_id>9</unique_id>
          <capability type='fc_host'>
            <wwnn>5001a4a833f78d55</wwnn>
            <wwpn>5001a4a533cb7cc5</wwpn>
            <fabric_wwn>2002000573de9a81</fabric_wwn>
          </capability>
        </capability>
      </device>

This vHBA will only be defined as long the host is not rebooted. In
order to create a persistent vHBA, one must use a libvirt storage pool.

Creation of a vHBA by the storage pool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using a storage pool to create and manage the vHBA allows for the
discovery and listing of LUN's via the "virsh vol-list" command and
provides a seamless mechanism to migrate virtual machine's that are
using a vHBA LUN as long as the same storage pool by name is defined and
started on the source and target host.

Similar to the node device driver creation, choose the HBA to be used
for the vHBA in order to create a 'scsi' storage pool using the `storage
pool XML <https://libvirt.org/formatstorage.html>`__ syntax as follows:

::

       <pool type='scsi'>
         <name>poolvhba0</name>
         <source>
           <adapter type='fc_host' wwnn='20000000c9831b4b' wwpn='10000000c9831b4b' parent='scsi_host3'/>
         </source>
         <target>
           <path>/dev/disk/by-path</path>
           <permissions>
             <mode>0700</mode>
             <owner>0</owner>
             <group>0</group>
           </permissions>
         </target>
       </pool>

The vHBA must use the pool "type='scsi'". The source adapter attribute
type must be "fc_host". The required attributes "wwnn" and "wwpn"
provide a unique and consistent naming mechanism for the LUNs.

The "parent" attribute (as of libvirt **1.0.4**) provides a mechanism to
define which parent HBA will be used to create the vHBA. The
"parent_wwnn" and "parent_wwpn" or "parent_fabric_wwn" attributes (as of
libvirt **3.0.0**) provide a more consistent mechanism to find the
parent HBA between host reboots. Similar to the node device the order of
precedence is parent followed by the parent_wwnn/parent_wwpn pair, and
finally the parent_fabric_wwn.

If none of the parent attributes are provided, the libvirt will pick the
first HBA capable of NPIV that has not exceeded its maximum vports. In
this instance, the parent remains undefined when displaying the created
pool. The following are examples of other parent selection options:

::

          <adapter type='fc_host' parent_wwnn='20000000c9848140' parent_wwpn='10000000c9848140' wwnn='20000000c9831b4b' wwpn='10000000c9831b4b'/>

or

::

      <adapter type='fc_host' parent_fabric_wwn='2002000573de9a81' wwnn='20000000c9831b4b' wwpn='10000000c9831b4b'/>

**NOTE:** The order of attributes does not matter

Define and Start the vHBA storage pool
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To define the persistent pool (assuming the above XML is named as
poolvhba0.xml):

::

       # virsh pool-define poolvhba0.xml
       Pool poolvhba0 defined from poolvhba0.xml

**NOTE:** One must use pool-define to define the pool as persistent,
since a pool created by pool-create is transient and it will disappear
after a system reboot or a libvirtd restart.

Once the pool is successfully defined, to start the pool:

::

       # virsh pool-start poolvhba0

| When starting the pool, libvirt will check if the vHBA with same
  "wwpn:wwpn" already exists. If it does not exist, a new vHBA with the
  provided "wwpn:wwnn" will be created. If one already exists, the
  define command will fail indicating the wwnn/wwpn are already being
  used.

Finally, in order to ensure that subsequent reboots of your host will
automatically define vHBA's for use in virtual machines, one must set
the storage pool autostart feature as follows (assuming the name of the
created pool was "poolvhba0"):

::

      # virsh pool-autostart poolvhba0

Finding LUNs on your vHBA
-------------------------

A libvirt storage pool essentially automates the task of finding the
vHBA LUN's as described in the node device driver section below. As it
will soon become obvious, using storage pools is far easier.

Finding LUN's from a vHBA created using the node device driver
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Finding an available LUN from a vHBA created using the node device
driver can be achieved either via use of the "virsh nodedev-list"
command or through manual searching of the hosts system file system.

Use the "virsh nodedev-list --tree \| more" and find the parent HBA to
which the vHBA was configured. The following example lists the pertinent
part of the tree for the example HBA "scsi_host5":

::

             +- scsi_host5
                 |
                 +- scsi_host7
                 +- scsi_target5_0_0
                 |   |
                 |   +- scsi_5_0_0_0
                 |
                 +- scsi_target5_0_1
                 |   |
                 |   +- scsi_5_0_1_0
                 |
                 +- scsi_target5_0_2
                 |   |
                 |   +- scsi_5_0_2_0
                 |       |
                 |       +- block_sdb_3600a0b80005adb0b0000ab2d4cae9254
                 |
                 +- scsi_target5_0_3
                     |
                     +- scsi_5_0_3_0

The "block\_" indicates it's a block device, the "sdb\_" is a convention
to signify the the short device path of "/dev/sdb", and the short device
path or the number can be used to search the
"/dev/disk/by-{id,path,uuid,label}/" name space for the specific LUN by
name, for example:

::

     # ls /dev/disk/by-id/ | grep 3600a0b80005adb0b0000ab2d4cae9254
     scsi-3600a0b80005adb0b0000ab2d4cae9254

::

     # ls /dev/disk/by-path/ -l | grep sdb
     lrwxrwxrwx. 1 root root  9 Sep 16 05:58 pci-0000:04:00.1-fc-0x203500a0b85ad1d7-lun-0 -> ../../sdb

As an option to using "virsh nodedev-list", it is possible to manually
iterate through the "/sys/bus/scsi/device" and "/dev/disk/by-path"
directory trees in order to find a LUN using the following steps:

**1. Iterate over all the directories beginning with the SCSI host
number of the vHBA under the "/sys/bus/scsi/devices" tree**

For example, if the SCSI host number is 6, the command would be:

::

      # ls /sys/bus/scsi/devices/6:* -d
      /sys/bus/scsi/devices/6:0:0:0  /sys/bus/scsi/devices/6:0:1:0
      /sys/bus/scsi/devices/6:0:2:0  /sys/bus/scsi/devices/6:0:3:0

**2. List the "block" names of all the entries belongs to the SCSI host
as follows**

::

      # ls /sys/bus/scsi/devices/6:*/block/
      /sys/bus/scsi/devices/6:0:2:0/block/:
      sdc
      /sys/bus/scsi/devices/6:0:3:0/block/:
      sdd

This indicates that "scsi_host6" has two LUNs, one is attached to
"6:0:2:0", with the short device name "sdc", and the other is attached
to "6:0:3:0", with the short device name "sdd".

**3. Determine the stable path to the LUN**

Unfortunately a device name such as "sdc" is not stable enough for use
by libvirt. In order to get the stable path, use the "ls -l
/dev/disk/by-path" and look for the "sdc" path:

::

      # ls -l /dev/disk/by-path/ | grep sdc
      lrwxrwxrwx. 1 root root  9 Sep 10 22:28 pci-0000:08:00.1-fc-0x205800a4085a3127-lun-0 -> ../../sdc

Thus "/dev/disk/by-path/pci-0000:08:00.1-fc-0x205800a4085a3127-lun-0" is
the stable path of the LUN attached to address "6:0:2:0" and will be
used in virtual machine configurations.

Finding LUN's from a vHBA created by the storage pool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Assuming that a storage pool was created for a vHBA, use the command
"virsh vol-list" command in order to generate a list of available LUN's
on the vHBA, as follows:

::

      # virsh vol-list poolvhba0
        Name                 Path                                    
      ------------------------------------------------------------------------------
       unit:0:4:0           /dev/disk/by-path/pci-0000:10:00.0-fc-0x5006016844602198-lun-0
       unit:0:5:0           /dev/disk/by-path/pci-0000:10:00.0-fc-0x5006016044602198-lun-0

The list of LUN names displayed will be available for use as disk
volumes in virtual machine configurations.

Virtual machine configuration change to use vHBA LUN
----------------------------------------------------

Adding the vHBA LUN to the virtual machine configuration is done via an
XML modification to the virtual machine.

Using a LUN from a vHBA created by the storage pool (pool)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The vHBA LUNs can be added to the domain XML configuration or hotplugged
to the domain as either a "disk" or pass-through "lun". The `domain
XML <https://libvirt.org/formatdomain.html#elementsDisks>`__ format
documentation describes the various details regarding usage of a "disk"
or "lun". When hot-plugging a device, use the "virsh attach-device"
command syntax.

**NOTE:** If migration is important, it's important to understand that
volume's name presented in the "virsh vol-list" output (e.g. unit:A:B:C
or unit:0:4:0) may differ between two hosts for the same physical vHBA
LUN depending on the order in which there were discovered by each of the
hosts. Thus for migration a disk assigned to a guest using storage pool
and volume name might map to a different disk at the destination host.
Hence, it is recommended to describe the disk by path name in the domain
XML for such use cases.

Adding a vHBA LUN as a disk in the domain XML (pool)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Adding the vHBA LUN to the virtual machine is handled via XML to create
a disk volume on the virtual machine with the following example XML:

::

      <disk type='volume' device='disk'>
        <driver name='qemu' type='raw'/>
        <source pool='poolvhba0' volume='unit:0:4:0'/>
        <target dev='sda' bus='scsi'/>
      </disk>

In particular note the usage of the "<source>" directive with the "pool"
and "volume" attributes listing the storage pool and the short volume
name.

**NOTE:** It is also possible to provide the path to volume instead of
the unit name as follows:

::

      <source pool=poolvhba0' volume='/dev/disk/by-path/pci-0000\:10\:00.0-fc-0x5006016844602198-lun-0'/>

Usage of backslashes prior to the colons are required, since colons are
considered as delimiters.

Adding a vHBA LUN as a pass-through device in the domain XML (pool)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Similar to disk example, except using 'lun' for the device type:

::

      <disk type='volume' device='lun'>
        <driver name='qemu' type='raw'/>
        <source pool='poolvhba0' volume='unit:0:4:0'/>
        <target dev='sda' bus='scsi'/>
      </disk>


Using a LUN from a vHBA created by the storage pool (device)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you've gone through the trouble of finding the vHBA LUN, it is still
relatively simple to add the LUN to the domain. However, it's important
to understand that host reboots will require domain XML modification in
order to ensure the proper LUN is being used as it's possible that a
hardware reconfiguration or just scsi_host discovery order has changed
the path to the LUN.


Adding a vHBA LUN as a disk in the domain XML (device)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Configuring a vHBA disk on the virtual machine can be done with its
stable path (path of {by-id|by-path|by-uuid|by-label}). The following is
an XML example of a direct LUN path:

::

      <disk type='block' device='disk'>
        <driver name='qemu' type='raw'/>
        <source dev='/dev/disk/by-path/pci-0000\:04\:00.1-fc-0x203400a0b85ad1d7-lun-0'/>
        <target dev='sda' bus='scsi'/>
      </disk>

**NOTE:** The use of "device='disk'" and the long "<source>" device
name. The example uses the "by-path" option. The backslashes prior to
the colons are required, since colons can be considered as delimiters.


Adding a vHBA LUN as a pass-through device in the domain XML (device)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Similar to the disk example, except exchanging 'disk' for 'lun':

::

      <disk type='block' device='lun'>
        <driver name='qemu' type='raw'/>
        <source dev='/dev/disk/by-path/pci-0000\:04\:00.1-fc-0x203400a0b85ad1d7-lun-0'/>
        <target dev='sda' bus='scsi'/>
      </disk>

**NOTE:** The use of "device='lun'" and again the long "<source>" device
name. Again, the backslashes prior to the colons are required.


Destroying a vHBA
-----------------

A vHBA created by the storage pool can be destroyed by the virsh command
"pool-destroy", for example:

::

       # virsh pool-destroy poolvhba0

**NOTE:** If the storage pool is persistent, the vHBA will also be
removed by libvirt when it destroys the storage pool.

A vHBA created using the node device driver can be destroyed by the
command "virsh nodedev-destroy", for example (assuming that scsi_host12
was created as shown earlier):

::

       # virsh nodedev-destroy scsi_host12

Destroying a vHBA removes it just as a reboot would do since the node
device driver does not support persistent configurations.

Troubleshooting
---------------

Discovery of HBA capable of NPIV prior to 1.0.4
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Prior to libvirt **1.0.4**, discovery of HBAs capable of NPIV requires
checking each of the HBAs on the host for the capability flag
"vport_ops", as follows:

First you need to find out all the HBA by capability flag "scsi_host":

::

      # virsh nodedev-list --cap scsi_host
      scsi_host0
      scsi_host1
      scsi_host2
      scsi_host3
      scsi_host4
      scsi_host5

Now check each HBA to find one with the "vport_ops" capability, either
one at a time as follows:

::

      # virsh nodedev-dumpxml scsi_host3
      <device>
        <name>scsi_host3</name>
        <parent>pci_0000_00_08_0</parent>
        <capability type='scsi_host'>
          <host>3</host>
        </capability>
      </device>

That says "scsi_host3" doesn't support vHBA

::

      # virsh nodedev-dumpxml scsi_host5
      <device>
        <name>scsi_host5</name>
        <parent>pci_0000_04_00_1</parent>
        <capability type='scsi_host'>
          <host>5</host>
          <capability type='fc_host'>
            <wwnn>2001001b32a9da4e</wwnn>
            <wwpn>2101001b32a9da4e</wwpn>
            <fabric_wwn>2001000dec9877c1</fabric_wwn>
          </capability>
          <capability type='vport_ops' />
        </capability>
      </device>

But "scsi_host5" supports it.

**NOTE:** In addition to libvirt **1.0.4** automating the lookup of
HBA's capable of supporting a vHBA configuration, the XML tags
"max_vports" and "vports" will describe the maximum vports allowed and
the current vports in use.

As an alternative and smarter way, you can avoid above cumbersome steps
by simple script like:

::

      for i in $(virsh nodedev-list --cap scsi_host); do
          if virsh nodedev-dumpxml $i | grep vport_ops > /dev/null; then
              echo $i;
          fi
      done

**NOTE:** It is possible that node device is named
"pci_10df_fe00_scsi_host_0". This is because libvirt supports two
backends for the node device driver ("udev" and "HAL"), but they lead to
completely different naming styles. The udev backend is preferred over
the HAL backend since HAL support is in maintenance mode. The udev
backend is more common; however, if your destribution packager built the
libvirt binaries without the udev backend, then the more complicated
names such as "pci_10df_fe00_scsi_host_0" must be used.

Creation of a vHBA using the node device driver prior to 0.9.10
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For libvirt prior to **0.9.10**, you will need to specify the "wwnn" and
"wwpn" manually when creating a vHBA, example XML as follows:

::

      <device>
        <name>scsi_host6</name>
        <parent>scsi_host5</parent>
        <capability type='scsi_host'>
          <capability type='fc_host'>
            <wwnn>2001001b32a9da5e</wwnn>
            <wwpn>2101001b32a9da5e</wwpn>
          </capability>
        </capability>
      </device>

Creation of storage pool based on vHBA prior to 1.0.5
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Prior to libvirt **1.0.5**, one can define a "scsi" type pool based on a
vHBA by it's SCSI host name (e.g. "host5" in XML below), using an
example XML as follows:

::

      <pool type='scsi'>
        <name>poolhba0</name>
        <uuid>e9392370-2917-565e-692b-d057f46512d6</uuid>
        <capacity unit='bytes'>0</capacity>
        <allocation unit='bytes'>0</allocation>
        <available unit='bytes'>0</available>
        <source>
          <adapter name='host0'/>
        </source>
        <target>
          <path>/dev/disk/by-path</path>
          <permissions>
            <mode>0700</mode>
            <owner>0</owner>
            <group>0</group>
          </permissions>
        </target>
      </pool>

There are two disadvantage of using the SCSI host name as the source
adapter. First the SCSI host number is not stable, thus it may cause
trouble for your storage pool after a system reboot. Second, the adapter
name (e.g. "host5") is not consistent with node device name (e.g.
"scsi_host5").

Moreover, using the SCSI host name as the source adapter doesn't allow
you to create a vHBA.

**NOTE:** Since **1.0.5**, the source adapter name was changed to be
consistent with node device name, thus the second disadvantage is
destroyed.
