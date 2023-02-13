.. contents::

This page provides an introduction to the common networking
configurations used by libvirt based applications. This information
applies to all hypervisors, whether Xen, KVM or another.

The two common setups are "virtual network" or "shared physical device".
The former is identical across all distributions and available
out-of-the-box. The latter needs distribution specific manual
configuration.

NAT forwarding (aka "virtual networks")
---------------------------------------

Host configuration (NAT)
~~~~~~~~~~~~~~~~~~~~~~~~

Every standard libvirt installation provides NAT based connectivity to
virtual machines out of the box. This is the so called 'default virtual
network'. You can verify that it is available with

::

   # virsh net-list --all
   Name                 State      Autostart 
   -----------------------------------------
   default              active     yes

If it is missing, then the example XML config can be reloaded &
activated


::

   # virsh net-define /usr/share/libvirt/networks/default.xml
   Network default defined from /usr/share/libvirt/networks/default.xml
   # virsh net-autostart default
   Network default marked as autostarted
   # virsh net-start default
   Network default started

When the libvirt default network is running, you will see an isolated
bridge device. This device explicitly does \*NOT\* have any physical
interfaces added, since it uses NAT + forwarding to connect to outside
world. Do not add interfaces

::

   # brctl show
   bridge name bridge id       STP enabled interfaces
   virbr0      8000.000000000000   yes

Libvirt will add iptables rules to allow traffic to/from guests attached
to the virbr0 device in the INPUT, FORWARD, OUTPUT and POSTROUTING
chains. It will also attempt to enable ip_forward. Some other
applications may disable it, so the best option is to add the following
to /etc/sysctl.conf

::

    net.ipv4.ip_forward = 1

If you are already running dnsmasq on your machine, please see `libvirtd
and dnsmasq <Libvirtd_and_dnsmasq.html>`__.

Guest configuration (NAT)
~~~~~~~~~~~~~~~~~~~~~~~~~

Once the host configuration is complete, a guest can be connected to the
virtual network based on the network name. E.g. to connect a guest to
the 'default' virtual network, you need to edit the domain configuration
file for this guest:

::

     virsh edit <guest>

where <guest> is the name or uuid of the guest. Add the following
snippet of XML to the config file:

::

     <interface type='network'>
        <source network='default'/>
        <mac address='00:16:3e:1a:b3:4a'/>
     </interface>

N.B. the MAC address is optional and will be automatically generated if
omitted.

Applying modifications to the network
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sometimes, one needs to edit the network definition and apply the
changes on the fly. The most common scenario for this is adding new
static MAC+IP mappings for the network's DHCP server. If you edit the
network with "virsh net-edit", any changes you make won't take effect
until the network is destroyed and re-started, which unfortunately will
cause a all guests to lose network connectivity with the host until
their network interfaces are explicitly re-attached (which is
automatically done as a side effect of restarting the libvirtd service).

virsh net-update
^^^^^^^^^^^^^^^^

Fortunately, many changes to the network configuration (including the
aforementioned addition of a static MAC+IP mapping for DHCP) can be done
with "virsh net-update", which can be told to enact the changes
immediately. For example, to add a DHCP static host entry to the network
named "default" mapping MAC address 53:54:00:00:01 to IP address
192.168.122.45 and hostname "bob", you could use this command:

::

       virsh net-update default add ip-dhcp-host \
             "<host mac='52:54:00:00:00:01' \
              name='bob' ip='192.168.122.45' />" \
              --live --config

Along with the "add" subcommand, virsh net-update also has a "delete"
sub-command as well as "modify" (for some items), "add-first", and
"add-last".

The config items in a network that can be changed with virsh net-update
are:

::

      ip-dhcp-host
      ip-dhcp-range (add/delete only, no modify)
      forward-interface (add/delete only)
      portgroup
      dns-host
      dns-txt
      dns-srv

In each case, the final argument on the commandline (aside from "--live
--config") should be the XML section that you want to add/modify or
delete. For example, the proper XML for "virsh net-update default add
forward-interface" would be something like "<interface dev='eth20'/>"
(note the careful use of quotes - due to the XML containing spaces and
shell redirection characters, you must put quotes around the entire XML
snippet, but this means that any quotes within the XML must either be
single quotes, or be escaped with a backslash.)

Arbitrary changes to the network
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Although the most common cases of changing network config can be handled
with "virsh net-update", there are some parts of the config that can't
be modified in this way, and in those cases you will be left with all
running guests detached from the network after it is restarted. This can
be remedied by restarting the libvirtd service, which checks that all
guest tap devices are connected to their proper bridges during
initialization.

Forwarding Incoming Connections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default, guests that are connected via a virtual network with
<forward mode='nat'/> can make any outgoing network connection they
like. Incoming connections are allowed from the host, and from other
guests connected to the same libvirt network, but all other incoming
connections are blocked by iptables rules.

If you would like to make a service that is on a guest behind a NATed
virtual network publicly available, you can setup libvirt's "hook"
script for qemu to install the necessary iptables rules to forward
incoming connections to the host on any given port HP to port GP on the
guest GNAME:

1) Determine a) the name of the guest "G" (as defined in the libvirt
   domain XML), b) the IP address of the guest "I", c) the port on the
   guest that will receive the connections "GP", and d) the port on the
   host that will be forwarded to the guest "HP".

   (To assure that the guest's IP address remains unchanged, you can either
   configure the guest OS with static ip information, or add a <host>
   element inside the <dhcp> element of the network that is used by your
   guest. See `the libvirt network XML documentation address
   section <http://libvirt.org/formatnetwork.html#elementsAddress>`__ for
   defails and an example.)

2) Stop the guest if it's running.

3) Create the file /etc/libvirt/hooks/qemu (or add the following to an
   already existing hook script), with contents similar to the following
   (replace GNAME, IP, GP, and HP appropriately for your setup):

   Use the basic script below or see an "advanced" version, which can
   handle several different machines and port mappings
   `here <https://github.com/nest/anubis-puppet/blob/master/manifests/files/puppet/libvirt/hooks/qemu>`__
   (improvements are welcome) or `here's a python
   script <https://github.com/saschpe/libvirt-hook-qemu>`__ which does a
   similar thing and is easy to understand and configure (improvements are
   welcome):

     ::

      #!/bin/bash

      # IMPORTANT: Change the "VM NAME" string to match your actual VM Name.
      # In order to create rules to other VMs, just duplicate the below block and configure
      # it accordingly.
      if [ "${1}" = "VM NAME" ]; then

         # Update the following variables to fit your setup
         GUEST_IP=
         GUEST_PORT=
         HOST_PORT=

         if [ "${2}" = "stopped" ] || [ "${2}" = "reconnect" ]; then
          /sbin/iptables -D FORWARD -o virbr0 -p tcp -d $GUEST_IP --dport $GUEST_PORT -j ACCEPT
          /sbin/iptables -t nat -D PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
         fi
         if [ "${2}" = "start" ] || [ "${2}" = "reconnect" ]; then
          /sbin/iptables -I FORWARD -o virbr0 -p tcp -d $GUEST_IP --dport $GUEST_PORT -j ACCEPT
          /sbin/iptables -t nat -I PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
         fi
      fi

4) chmod +x /etc/libvirt/hooks/qemu

5) Restart the libvirtd service.

6) Start the guest.

   (NB: This method is a hack, and has one annoying flaw in versions of
   libvirt prior to 0.9.13 - if libvirtd is restarted while the guest is
   running, all of the standard iptables rules to support virtual networks
   that were added by libvirtd will be reloaded, thus changing the order of
   the above FORWARD rule relative to a reject rule for the network, hence
   rendering this setup non-working until the guest is stopped and
   restarted. Thanks to the new "reconnect" hook in libvirt-0.9.13 and
   newer (which is used by the above script if available), this flaw is not
   present in newer versions of libvirt (however, this hook script should
   still be considered a hack).

Bridged networking (aka "shared physical device")
-------------------------------------------------


Host configuration (bridged)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The NAT based connectivity is useful for quick & easy deployments, or on
machines with dynamic/sporadic networking connectivity. More advanced
users will want to use full bridging, where the guest is connected
directly to the LAN. The instructions for setting this up vary by
distribution, and even by release.

**Important Note:** Unfortunately, wireless interfaces cannot be
attached to a Linux host bridge, so if your connection to the external
network is via a wireless interface ("wlanX"), you will not be able to
use this mode of networking for your guests.

**Important Note:** If, after trying to use the bridge interface, you
find your network link becomes dead and refuses to work again, it might
be that the router/switch upstream is blocking "unauthorized switches"
in the network (for example, by detecting BPDU packets). You'll have to
change its configuration to explicitly allow the host machine/network
port as a "switch".

Fedora/RHEL Bridging
^^^^^^^^^^^^^^^^^^^^

This outlines how to setup briding using standard network initscripts
and systemctl.

Using NetworkManager directly
'''''''''''''''''''''''''''''

If your distro was released some time after 2015 and uses
NetworkManager, it likely supports bridging natively. See these
instructions for creating a bridge directly with NetworkManager:

-  Using nm-connection-editor UI:
   https://www.happyassassin.net/2014/07/23/bridged-networking-for-libvirt-with-networkmanager-2014-fedora-21/
-  Using the command line:
   https://lukas.zapletalovi.com/2015/09/fedora-22-libvirt-with-bridge.html


Disabling NetworkManager (for older distros)
''''''''''''''''''''''''''''''''''''''''''''

If your distro was released before 2015, the NetworkManager version
likely does not handle bridging, so it is necessary to use "classic"
network initscripts for the bridge, and to explicitly mark them as
independent from NetworkManager (the "NM_CONTROLLED=no" lines in the
scripts below).

If desired, you can also completely disable NetworkManager:

::

   # chkconfig NetworkManager off
   # chkconfig network on
   # service NetworkManager stop
   # service network start


Creating network initscripts
''''''''''''''''''''''''''''

In the /etc/sysconfig/network-scripts directory it is neccessary to
create 2 config files. The first (ifcfg-eth0) defines your physical
network interface, and says that it will be part of a bridge:

::

   # cat > ifcfg-eth0 <<EOF
   DEVICE=eth0
   HWADDR=00:16:76:D6:C9:45
   ONBOOT=yes
   BRIDGE=br0
   NM_CONTROLLED=no
   EOF

Obviously change the HWADDR to match your actual NIC's address. You may
also wish to configure the device's MTU here using e.g. MTU=9000.

The second config file (ifcfg-br0) defines the bridge device:

::

   # cat > ifcfg-br0 <<EOF
   DEVICE=br0
   TYPE=Bridge
   BOOTPROTO=dhcp
   ONBOOT=yes
   DELAY=0
   NM_CONTROLLED=no
   EOF

**WARNING:** The line TYPE=Bridge is case-sensitive - it must have
uppercase 'B' and lower case 'ridge'

After changing this restart networking (or simply reboot)

::

    # service network restart

The final step is to disable netfilter on the bridge:

::

    # cat >> /etc/sysctl.conf <<EOF
    net.bridge.bridge-nf-call-ip6tables = 0
    net.bridge.bridge-nf-call-iptables = 0
    net.bridge.bridge-nf-call-arptables = 0
    EOF
    # sysctl -p /etc/sysctl.conf

It is recommended to do this for performance and security reasons. See
`Fedora bug #512206 <https://bugzilla.redhat.com/512206>`__.
Alternatively you can configure iptables to allow all traffic to be
forwarded across the bridge:

::

   # echo "-I FORWARD -m physdev --physdev-is-bridged -j ACCEPT" > /etc/sysconfig/iptables-forward-bridged
   # lokkit --custom-rules=ipv4:filter:/etc/sysconfig/iptables-forward-bridged
   # service libvirtd reload

You should now have a "shared physical device", to which guests can be
attached and have full LAN access

::

    # brctl show
    bridge name     bridge id               STP enabled     interfaces
    virbr0          8000.000000000000       yes
    br0             8000.000e0cb30550       yes             eth0

Note how this bridge is completely independant of the virbr0. Do \*NOT\*
attempt to attach a physical device to 'virbr0' - this is only for NAT
connectivity

Debian/Ubuntu Bridging
^^^^^^^^^^^^^^^^^^^^^^

See the debian wiki for up to date instructions of bridging:
https://wiki.debian.org/BridgeNetworkConnections


Guest configuration (Bridge)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to let your virtual machines use this bridge, their
configuration should include the interface definition as described in
`Bridge to
LAN <http://libvirt.org/formatdomain.html#elementsNICSBridge>`__. In
essence you are specifying the bridge name to connect to. Assuming a
shared physical device where the bridge is called "br0", the following
guest XML would be used:

::

    <interface type='bridge'>
       <source bridge='br0'/>
       <mac address='00:16:3e:1a:b3:4a'/>
       <model type='virtio'/>   # try this if you experience problems with VLANs
    </interface>

NB, the mac address is optional and will be automatically generated if
omitted.

To edit the virtual machine's configuration, use:

virsh edit <VM name>

For more information, see the FAQ entry at:

http://wiki.libvirt.org/page/FAQ#Where_are_VM_config_files_stored.3F_How_do_I_edit_a_VM.27s_XML_config.3F

PCI Passthrough of host network devices
---------------------------------------

It is possible to directly assign a host's PCI network device to a
guest. One pre-requisite for doing this assignment is that the host must
support either the Intel VT-d or AMD IOMMU extensions. There are two
methods of setting up assignment of a PCI device to a guest:

Assignment with <hostdev>
~~~~~~~~~~~~~~~~~~~~~~~~~

This is the traditional method of assigning any generic PCI device to a
guest. It's covered well in the following guide:

`libvirt PCI Device
Assignment <https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Host_Configuration_and_Guest_Installation_Guide/chap-Virtualization_Host_Configuration_and_Guest_Installation_Guide-PCI_Device_Config.html>`__

Assignment with <interface type='hostdev'> (SRIOV devices only)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SRIOV network cards provide multiple "Virtual Functions" (VF) that can
each be individually assigned to a guest using PCI device assignment,
and each will behave as a full physical network device. This permits
many guests to gain the performance advantage of direct PCI device
assignment, while only using a single slot on the physical machine.

These VFs can be assigned to guests in the traditional manner using
<hostdev>, however that method ends up being problematic because (unlike
regular network devices) SRIOV VF network devices do not have permanent
unique MAC addresses, but are instead given a new and different random
MAC address each time the host OS is rebooted. The result will be that
even if the guest is assigned the same VF each time, any time the host
is rebooted the guest will see that its network adapter has a new MAC
address, which will lead to the guest believing there is new hardware
connected, requiring re-configuration of the guest's network settings.

It is possible for the host to set the MAC address prior to assigning
the VF to the guest, but there is no provision for this in the <hostdev>
settings (since <hostdev> is for a generic PCI device, it knows nothing
of function-specific items like MAC address). In order to solve this
problem, libvirt-0.9.10 added a new <interface type='hostdev'>
(`documented
here <http://www.libvirt.org/formatdomain.html#elementsNICSHostdev>`__).
This new type of interface device behaves as a hybrid of an <interface>
and a <hostdev> - libvirt will first do any network-specific
hardware/switch initialization indicated (such as setting the MAC
address, and/or associating with an 802.1Qbh switch), then perform the
PCI device assignment to the guest.

In order to use <interface type='hostdev'>, you must have an
SRIOV-capable network card, host hardware that supports either the Intel
VT-d or AMD IOMMU extensions, and you must learn the PCI address of the
VF that you wish to assign (see `this
document <http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Host_Configuration_and_Guest_Installation_Guide/chap-Virtualization_Host_Configuration_and_Guest_Installation_Guide-PCI_Assignment.html>`__
for instructions on how to do that).

Once you have verified/learned the above information, you can edit your
guest's domain configuration to have a device entry like the following:

::

    ...
    <devices>
      ...
      <interface type='hostdev' managed='yes'>
        <source>
          <address type='pci' domain='0x0' bus='0x00' slot='0x07' function='0x0'/>
        </source>
        <mac address='52:54:00:6d:90:02'>
        <virtualport type='802.1Qbh'>
          <parameters profileid='finance'/>
        </virtualport>
      </interface>
      ...
    </devices>

(Note that if you do not provide a mac address, one will be
automatically generated, just as with any other type of interface
device. Also, the <virtualport> element is only used if you are
connecting to an 802.11Qgh hardware switch (802.11Qbg (a.k.a. "VEPA")
switches are currently not supported in this mode)).

When the guest starts, it should see a network device of the type
provided by the physical adapter, with the configured MAC address. This
MAC address will remain unchanged across guest and host reboots.

Assignment from a pool of SRIOV VFs in a libvirt <network> definition
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Hard coding the PCI address of a particular VF into a guest's
configuration has two serious limitations:

1) The specified VF must be available any time the guest is started,
   implying that the administrator must permanently assign each VF to a
   single guest (or modify the configuration of a guest to specify a
   currently unused VF's PCI address each time the guest is started).

2) If the guest is moved to another host, that host must have exactly
   the same hardware in the same location on the PCI bus (or, again, the
   guest configuration must be modified prior to start).

   Starting with libvirt 0.10.0, it is possible to avoid both of these
   problems by creating a libvirt network with a device pool containing all
   the VFs of an SR-IOV device, then configuring the guest to reference
   this network; each time the guest is started, a single VF will be
   allocated from the pool and assigned to the guest; when the guest is
   stopped, the VF will be returned to the pool for use by another guest.

   The following is an example network definition that will make available
   a pool of all VFs for the SR-IOV adapter with its PF (Physical Function)
   at "eth3' on the host:

   ::

      <network>
        <name>passthrough</name>
        <forward mode='hostdev' managed='yes'>
          <pf dev='eth3'/>
        </forward>
      </network>

   To use this network, place the above text in, e.g., /tmp/passthrough.xml
   (replaceing "eth3" with the netdev name of your own SR-IOV device's PF),
   then execute the following commands:

   ::

       virsh net-define /tmp/passthrough.xml
       virsh net-autostart passthrough
       virsh net-start passthrough.

   Although only a single device is shown, libvirt will automatically
   derive the list of all VFs associated with that PF the first time a
   guest is started with an interface definition like the following:

   ::

       <interface type='network'>
         <source network='passthrough'>
       </interface>

   You can verify this by running "virsh net-dumpxml passthrough" after
   starting the first guest that uses the network; you will get output
   similar to the following:

   ::

       <network connections='1'>
         <name>passthrough</name>
         <uuid>a6b49429-d353-d7ad-3185-4451cc786437</uuid>
         <forward mode='hostdev' managed='yes'>
           <pf dev='eth3'/>
           <address type='pci' domain='0x0000' bus='0x02' slot='0x10' function='0x1'/>
           <address type='pci' domain='0x0000' bus='0x02' slot='0x10' function='0x3'/>
           <address type='pci' domain='0x0000' bus='0x02' slot='0x10' function='0x5'/>
           <address type='pci' domain='0x0000' bus='0x02' slot='0x10' function='0x7'/>
           <address type='pci' domain='0x0000' bus='0x02' slot='0x11' function='0x1'/>
           <address type='pci' domain='0x0000' bus='0x02' slot='0x11' function='0x3'/>
           <address type='pci' domain='0x0000' bus='0x02' slot='0x11' function='0x5'/>
         </forward>
       </network>

Other networking docs/links
---------------------------

-  `David Lutterkort's
   guide <http://www.watzmann.net/blog/index.php/2007/04/27/networking_with_kvm_and_libvirt>`__.
   NB the naming of devices 'peth0' (physical) and 'eth0' (bridge) does
   not work in Fedora 9 anymore. Following the 'eth0' (physical) and
   'br0' (bridge) naming shown above instead
-  `Anthony Liguori's
   guide <http://kvm.qumranet.com/kvmwiki/AnthonyLiguori/Networking>`__
   . Shows tips for 'shared physical devices' on Debian
-  `manual KVM
   networking <http://kvm.qumranet.com/kvmwiki/Networking>`__ - for
   people not using libvirt to launch guests
-  `Ubuntu libvirt
   guide <http://doc.ubuntu.com/ubuntu/serverguide/C/libvirt.html>`__
   with a section on network bridge setup
