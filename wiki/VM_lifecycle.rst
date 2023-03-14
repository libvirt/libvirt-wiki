.. contents::

Virtual Machine Lifecycle
=========================

This page describes the basics of the virtual machine lifecycle. Its aim
is to provide fundamental information to create, run, stop, migrate and
delete a virtual machines in one page.

Terminology
-----------

It is always important to know what is meant by the terms used in
documentation and *meaning* of commands and syntax. Please refer to
`this <https://libvirt.org/goals.html>`__ page if you are not familiar
with basic libvirt concepts such as nodes and domains and to get an
overview of the libvirt project goals and scope.

Concepts
========

Guest domains are described using XML configuration
---------------------------------------------------

XML is used as the file format for storing the configuration of
everything in libvirt including domain, network, storage and other
elements. XML enables users to use the editors they are comfortable with
and to easily integrate with other technologies and tools.

For example, devices in a domain are represented by XML elements by
assigning attributes and/or child elements. A fragment is shown below:


::

   <domain type='qemu'>
      <name>demo</name>
      ...
      <devices>
         ...
         <disk type='file' device='disk'> ... </disk>
         <disk type='file' device='cdrom'> ... </disk>
         <input type='mouse' bus='ps2'/>
         ...
      </devices>
   </domain>

Libvirt uses XPath technology to select nodes from XML document.

Transient guest domains vs Persistent guest domains
---------------------------------------------------

Libvirt distinguishes between two different types of domains:
*transient* and *persistent*.

-  Transient domains only exist until the domain is shutdown or when the
   host server is restarted.
-  Persistent domains last indefinitely.

Once a domain is created (no matter what type) its state can be saved
into a file and then restored indefinitely as long as the original file
still exists. Thus even a transient domain can be restored over and over
again.

Creation of transient domains differs slightly from the creation of
persistent domains. Persistent domains need to be defined before being
started up. Transient domains are created and started at once. The
commands differ when dealing with the two different types.

While transient domains are created and destroyed on-the-fly, all of
their components (e.g. storage, networks, devices, etc.) need to exist
beforehand.

States that a guest domain can be in
------------------------------------

Domain can be in several states:

#. **Undefined** - This is a baseline state. Libvirt does not know
   anything about domains in this state because the domain hasn't been
   defined or created yet.
#. **Defined** or **Stopped** - The domain has been defined, but it's
   not running. This state is also called *stopped*. Only persistent
   domains can be in this state. When a transient domain is stopped or
   shutdown, it ceases to exist.
#. **Running** - The domain has been created and started either as
   transient or persistent domain. Either domain in this state is being
   actively executed on the node's hypervisor.
#. **Paused** - The domain execution on hypervisor has been suspended.
   Its state has been temporarily stored until it is resumed. The domain
   does not have any knowledge whether it was paused or not. If you are
   familiar with processes in operating systems, this is the similar.
#. **Saved** - Similar to the *paused* state, but the domain state is
   stored to persistent storage. Again, the domain in this state can be
   restored and it does not notice that any time has passed.

The diagram below shows how domain states flow into one another. The
rectangles represent the different domain states and the arrows show the
commands that move a domain from one state to another.

.. image:: images/Vm_lifecycle_graph.png

From the picture above, one can see that with the *shutdown* command one
can move from a *running* state to a *defined* or *undefined* state. In
this case, a *transient domain* would become *undefined* (cease to
exist) and a *persistent domain* would be become *defined* upon a
*shutdown*.

Snapshots
---------

A snapshot is a view of a virtual machine's operating system and all its
applications at a given point in time. Having a restorable *snapshot* of
a virtual machine is a basic feature of the virtualization landscape.
Snapshots allow users to save their virtual machine's state at a point
in time and roll back to that state. Basic use cases include taking a
snapshot, installing new applications, updates or upgrades (discovering
they are terrible or broke things) and then rolling back to a prior
time.

It should be obvious that any changes that occur after a snapshot is
taken are **not** included in the snapshot. A snapshot does not
continually update. It represents the virtual machine's state at a
single point in time.

Migration (concept)
-------------------

A running domain or virtual machine can be migrated to another host as
long as the virtual machine's storage is shared between the hosts and
the host's CPU is capable of supporting the guest's CPU model. Depending
on the type and application, migration of virtual machines does not need
to cause any service interruption.

Libvirt supports a number of different migration types:

-  **Standard**- A domain is suspended while its resources are being
   transferred to the destination host. Once done, the VM resumes
   operation on the destination host. The time spent in suspended state
   is directly proportional to domain's memory size.
-  **Peer-to-peer** - This type is used whenever source and destination
   hosts can communicate directly.
-  **Tunnelled** - A tunnel is created between source and destination
   hosts, such as a SSH tunnel. All network communication between the
   source and destination nodes or physical hosts is sent through the
   tunnel.
-  **Live vs non-live** - When migrating in live mode, the domain is not
   paused and all services on it continue to run. On the destination
   host the non-live domain or virtual machine has all processes
   stopped. The domain is effectively invisible during the time
   necessary to transfer its state through network. Live migration is
   therefore sensitive to application load. When live migrating a
   domain, it's allocated memory is sent to the destination host while
   being watched for changes on the source host. The domain on the
   source host remains active until all of the memory on both nodes are
   identical. At that point the domain on the destination node becomes
   active and the domain on the source node becomes passive or invisible
   to other machines on the network.
-  **Direct** - libvirt initiates the migration using the hypervisor and
   then the process is entirely under control of the hypervisors. Often
   they have features to talk directly to each other (e.g. Xen on the
   source host communicates directly to Xen on the destination host
   without any libvirt intervention).

Requirements for migration:

-  Shared storage accessible under same paths and locations,e.g. iSCSI,
   NFS, etc.
-  Exactly the same versions of hypervisor software on both physical
   hosts
-  Same network configuration.
-  Same CPUs or better. The CPUs must be from the same vendor and the
   CPU flags on the destination host must be superset of CPU flags on
   the source host.

Guest data security when removing a domain
------------------------------------------

Some applications store sensitive information. As with any process that
involves sensitive data, thought should be given to the safe and secure
disposal of that information. Like any file on the filesystem, when a
virtual machine is deleted from the system only the filesystem pointers
are deleted. The occupied blocks on the storage media typically remain
occupied, they are simply flagged as empty by the filesystem. Really, it
depends on your filesystem.

Hopefully, if the application is dealing with such *heavy* data, then
the machines themselves are physically secured and access to the network
is similarly safeguarded.

Security is always an important factor to consider, even if only to keep
out vandals and prevent innocent, but disastrous accidents.

Tasks
=====

Creating a domain
-----------------

In order to run a domain it is first necessary to create one. This can
be done in several ways. The `following
page <CreatingNewVM_in_VirtualMachineManager.html>`__ describes the
process using the Virtual Machine Manager GUI. The second way is by
using the virt-install command line tool.

::

   # virt-install \
                --connect qemu:///system \
                --virt-type kvm \
                --name MyNewVM \
                --ram 512 \
                --disk path=/var/lib/libvirt/images/MyNewVM.img,size=8 \
                --vnc \
                --cdrom /var/lib/libvirt/images/Fedora-14-x86_64-Live-KDE.iso \
                --network network=default,mac=52:54:00:9c:94:3b \
                --os-variant fedora14

This command creates a new domain called 'MyNewVM', with 512 MB RAM and
8 GB disk space using KVM. Please read the manual page for any further
information.

The last way is to create an XML definition of the domain and volume(s)
and run virsh with the appropriate commands: vol-create and define.

Volumes are joined in a pool. By default, there exists one pool called
"*default*". This is a directory-type pool, which means all volumes are
stored as files in one directory. But please read `this
page <https://libvirt.org/storage.html>`__ if you are not completely
aware of libvirt storage management. You may find more suitable storage
solution there.

Example of volume XML definition (new_volume.xml):

::

   <volume>
    <name>sparse.img</name>
    <capacity unit="G">10</capacity>
   </volume>

This defines a new volume with a capacity of 10 GB. To create volume in
"*default*" pool:

::

   # virsh vol-create default new_volume.xml

Example of domain XML definition (MyNewVM.xml):

::

   <domain type='kvm'>
     <name>MyNewVM</name>
     <currentMemory>524288</currentMemory>
     <memory>524288</memory>
     <uuid>30d18a08-d6d8-d5d4-f675-8c42c11d6c62</uuid>
     <os>
       <type arch='x86_64'>hvm</type>
       <boot dev='hd'/>
     </os>
     <features>
       <acpi/><apic/><pae/>
     </features>
     <clock offset="utc"/>
     <on_poweroff>destroy</on_poweroff>
     <on_reboot>restart</on_reboot>
     <on_crash>restart</on_crash>
     <vcpu>1</vcpu>
     <devices>
       <emulator>/usr/bin/qemu-kvm</emulator>
       <disk type='file' device='disk'>
         <driver name='qemu' type='raw'/>
         <source file='/var/lib/libvirt/images/MyNewVM.img'/>
         <target dev='vda' bus='virtio'/>
       </disk>
       <disk type='block' device='cdrom'>
         <target dev='hdc' bus='ide'/>
         <readonly/>
       </disk>
       <interface type='network'>
         <source network='default'/>
         <mac address='52:54:00:9c:94:3b'/>
         <model type='virtio'/>
       </interface>
       <input type='tablet' bus='usb'/>
       <graphics type='vnc' port='-1'/>
       <console type='pty'/>
       <sound model='ac97'/>
       <video>
         <model type='cirrus'/>
       </video>
     </devices>
   </domain>

To define a new presistent domain:

::

   # virsh define MyNewVM.xml

Domain XML format has many optional elements which you may find useful.
Therefore read `this page <https://libvirt.org/formatdomain.html>`__
which is a complete domain XML format reference including examples and
most common scenarios.

Editing a domain
----------------

Any domain can be edited in a user's favourite editor. What is needed is
to set the $VISUAL or $EDITOR environment variable and run:

::

   # virsh edit <domain>

If neither of these variables are not set, the vi editor is used by
default. After closing the editor libvirt will automatically check for
changes and apply them. However, it is also possible to edit domain in
Virtual Machine Manager.


Starting a domain
-----------------

Once a domain is created, one is able to run it. This is possible
through Virtual Machine Manager or by running virsh start <domain>
command. For example:

::

   # virsh start MyNewVM

This command however performs either so called clean boot up or restores
the domain from the previously saved state. See managedsave virsh
command for details. It is important to notice, a domain can't be
started if any of its components are not up, e.g. network.

As mentioned above, a transient domain can be run without previous
definition:

::

   # virsh create /path/to/MyNewVM.xml

Stopping or rebooting a domain
------------------------------

To stop running domain just run:

::

   # virsh shutdown <domain>

To reboot a persistent domain:

::

   # virsh reboot <domain>

Rebooting a transient domain is not possible, since right after shutdown
are transient domains also undefined.

An inelegant shutdown, also known as hard-stop:

::

   # virsh destroy <domain>

This is equivalent to unplugging the power cable.

Pausing a guest domain
----------------------

Domain can be paused in virsh:

::

   # virsh suspend <domain>

or in Virtual Machine Manager by clicking *Pause* button from main
toolbar. When a guest is in a suspended state, it consumes system RAM
but not processor resources. Disk and network I/O does not occur while
the guest is suspended. This operation is immediate

Unpausing a guest domain
------------------------

Any paused or suspended domain can be resumed by:

::

   # virsh resume <domain>

or by unclicking the appropriate *Pause* button in Virtual Manager.

Taking a Snapshot of a guest domain
-----------------------------------

Creating a snapshot is done by executing:

::

   # virsh snapshot-create <domain>

Listing the snapshots of a guest domain
---------------------------------------

All snapshosts of a guest domain can be viewed in virsh:

::

   # virsh snapshot-list <domain>

For instance, the output might look like this:

::

    Name                 Creation Time             State
   ---------------------------------------------------
    1295973577           2011-01-25 17:39:37 +0100 running
    1295978837           2011-01-25 19:07:17 +0100 running

| We can see one snapshot created at 17:39:17 local time, with the name
  1295973577 which corresponds to Unix time. The other was created at
  19:07:17 with the name 1295978837.

Restoring a guest domain from a snapshot
----------------------------------------

To restore a guest domain from a previous snapshot you can use:

::

   # virsh snapshot-restore <domain> <snapshotname>

This restores a specified domain to a state represented by snapshotname.
**Please note that any changes made will be destroyed!**

Removing a snapshot from a guest domain
---------------------------------------

Any snaphsot of a given domain can be removed via:

::

   # virsh snapshot-delete <domain> <snapshotname>


Migration (Task)
----------------

Libvirt provides migration support. It means you can migrate a domain
from one host to another over the network. Migration can operate in two
main modes:

-  Plain migration: The source host VM opens a direct unencrypted TCP
   connection to the destination host for sending the migration data.
   Unless a port is manually specified, libvirt will choose a migration
   port in the range 49152-49215, which will need to be open in the
   firewall on the remote host.

-  Tunneled migration: The source host libvirtd opens a direct
   connection to the destination host libvirtd for sending migration
   data. This allows the option of encrypting the data stream. This mode
   doesn't require any extra firewall configuration, but is only
   supported with qemu 0.12.0 or later, and libvirt 0.7.2 or later.

For a successful migration there are couple of things needed to be done.
For instance, storage settings have to match. All volumes that migrated
domain use have to be stored under the same paths.

Once pre-migration checks are done, you can migrate machine using virsh:

::

   # virsh migrate <domain> <remote host URI> --migrateuri tcp://<remote host>:<port>

Deletion of a domain
--------------------

One may delete an inactive domain in virsh:

::

   # virsh undefine <domain>

As usual, there is also the possibility of deleting it in Virtual
Machine Manager, covered in `this
page <DeletingVirtualMachine_in_VirtualMachineManager.html>`__ .

Wiping the storage used by a guest domain
-----------------------------------------

A volume used by a domain can contain confidential data, hence it is
necessary to wipe it before removal. Libvirt offers a helping hand for
such cases:

::

   # virsh vol-wipe <volume>

which truncates and extends the volume to its original size. This in
fact fills the file with zeroes. This ensures that data previously
stored on volume is not accessible to reads anymore. After this, you can
remove volume :

::

   # virsh vol-delete <volume>

Reference
=========

These pages may also provide useful further information:

-  `Domain XML format <https://libvirt.org/formatdomain.html>`__
-  `RHEL 8 - Configuring and managing
   virtualization <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_virtualization/virtualization-in-rhel-8-an-overview_configuring-and-managing-virtualization>`__
-  `Anatomy of the libvirt virtualization
   library <http://www.ibm.com/developerworks/linux/library/l-libvirt/index.html?ca=dgr-lnxw97LXlibvirt-APIdth-LX&S_TACT=105AGX59&S_CMP=lnxw97#basic_architecture>`__
