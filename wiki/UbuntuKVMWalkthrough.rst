.. contents::

Walk-through using QEMU/KVM with libvirt on Ubuntu
==================================================

This walk-through assumes you start qemu/kvm either manually or from a
script. You already have a filesystem (eg: disk image, LVM partition).
You are familiar with kvm/qemu networking.

Download libvirt
----------------

First, you'll need the libvirt tools:

::

    apt-get install libvirt-bin libvirt-doc

Networking
----------

UML-Switch or VDE2
~~~~~~~~~~~~~~~~~~

Todo

Bridged Networking
~~~~~~~~~~~~~~~~~~

Follow the instructions in the `Networking hints and
tips <Networking.html>`__.

Create The Domain
-----------------

Create Domain Using python-virtinst
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Virtinst is a set of commandline tools to create virtual machines using
libvirt.

::

    apt-get install python-virtinst

Now use virt-install to create your virtual machine, as described
`here <http://doc.ubuntu.com/ubuntu/serverguide/C/libvirt.html>`__. For
example, to create a guest domain called 'vader' using a pre-existing
LVM partition and KVM:

::

    virt-install -n vader -r 384 -f /dev/mapper/vg-vaderlv --accelerate --vnc --noautoconsole -v --network bridge:br0

The above command will create the domain definition file
/etc/libvirt/qemu/vader.xml, and will attempt to start the domain.

FIXME: The above command will ask for a CDROM and attempt to boot from
it. This is unnecessary if a filesystem already exists on
/dev/mapper/vg-vaderlv. I bypassed this by setting the CDROM to
/dev/null and then restarting the domain after the initial boot failure.

FIXME: If you are running Ubuntu and cannot bring up eth0 on your guest
domain, it is likely that there is a conflict with your MAC address from
your pre-existing domain. Note the MAC address assigned on the host
domain in the file /etc/libvirt/qemu/vader.xml. Log into the guest
domain using the console and edit the file
/etc/udev/rules.d/70-persistent-net.rules. Remove the line containing
'NAME="eth1"' (provided you are only running 1 interface). Edit the line
containing 'NAME="eth0"' and modify ATTR{address}== field with the
current MAC address.

Create Domain Manually
~~~~~~~~~~~~~~~~~~~~~~

To create a domain called 'vader' using your favorite text editor,
create a file called vader.xml which looks something like the following.

Note the uuid must be unique to this domain; if you leave it out,
correct (random) one will be generated for you.

::

   <domain type='kvm'>
     <name>vader</name>
     <uuid>f5b8c05b-9c7a-3211-49b9-2bd635f7e2aa</uuid>
     <memory>393216</memory>
     <currentMemory>393216</currentMemory>
     <vcpu>1</vcpu>
     <os>
       <type>hvm</type>
       <boot dev='hd'/>
     </os>
     <features>
       <acpi/>
     </features>
     <clock offset='utc'/>
     <on_poweroff>destroy</on_poweroff>
     <on_reboot>restart</on_reboot>
     <on_crash>destroy</on_crash>
     <devices>
       <emulator>/usr/bin/kvm</emulator>
       <disk type='block' device='disk'>
         <source dev='/dev/mapper/vg-vaderlv'/>
         <target dev='hda' bus='ide'/>
       </disk>
       <interface type='bridge'>
         <mac address='52:54:00:00:01:89'/>
         <source bridge='br0'/>
       </interface>
       <input type='tablet' bus='usb'/> 
       <input type='mouse' bus='ps2'/>
       <graphics type='vnc' port='-1' listen='127.0.0.1'/>
     </devices>
   </domain>

For more information, see the `domain format
documentation <http://libvirt.org/formatdomain.html>`__.

After that file is created, you can define it in libvirt with the
following command:

::

   virsh define vader.xml

Domain Control: Start, Stop, Etc.
---------------------------------

You can verify your changes have taken effect with the command:

::

   virsh dumpxml vader

To list all currently-running domains:

::

    virsh list

To display info on a specific domain:

::

    virsh dominfo vader

To start/stop/reboot a domain:

::

    virsh start vader
    virsh shutdown vader
    virsh reboot vader

To hard-stop a domain (no elegant shutdown):

::

    virsh destroy vader

Connect to Guest display
------------------------

Usually issuing the following command should be enough and should deal
with possible combinations:

::

    virt-viewer vader

The virt-viewer is in a separate package with

Connect to a VNC Console
------------------------

The above examples connect a VNC terminal to the loopback device
(127.0.0.1). Pay attention to the port number if you have multiple
domains running.

You can connect from the host machine:

::

    vncviewer localhost

or over the network using ssh port-forwarding. Login to the host:

::

    ssh deathstar -L 5900:127.0.0.1:5900

On the local computer, now run:

::

    vncviewer localhost

Start The Domain At Boot
------------------------

Set the 'autostart' flag so the domain is started upon boot:

::

   virsh autostart vader

Elegant Guest Shutdown
----------------------

To enable elegant shutdown of domains, ensure they respond to ACPI power
button presses. On Linux, install acpid in the guest OS.
