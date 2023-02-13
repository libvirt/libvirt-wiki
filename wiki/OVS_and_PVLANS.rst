.. contents::

OpenvSwitch and Private VLANS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Goal
^^^^

Private VLANS are commonly used where a normal L2 network domain does
not satisfy security requirements with respect to firewalling between
two hosts in the same L2 network.

Since OpenvSwitch does not implement a PVLAN feature at the time of this
writing, the author has attempted to build something similar with the
existing features of OpenvSwitch - flows.

In this scenario one VM is acting as the router, while all other VMs are
connected to isolated ports and can only talk to each other being routed
by the router VM.

The following Proof of Concept already works across multiple hypervisors
and allocates just one VLAN on the upstream switches.

Summary
^^^^^^^

-  naming convention in libvirt networking/portgroup to recognize
   isolated members
-  libvirt hook script to add/delete flows

XML
^^^

The isolated VM will have an interface according to the follwoing
snippet:

::

      <interface type='network'>
        <mac address='52:54:00:c8:d5:1c'/>
        <source network='ovs' portgroup='isolated-2102'/>
        <virtualport type='openvswitch'>
          <parameters interfaceid='4b1ae476-66a3-4386-ad91-34e3c3dc5c61'/>
        </virtualport>
        <target dev='foo'/>
        <model type='virtio'/>
        <driver name='vhost'/>
        <alias name='net0'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
      </interface>

| The respective network looks like:

::

      <network connections='1'>
        <name>ovs</name>
        <uuid>3a77c5b1-ad11-48cc-81ab-cc4185844b92</uuid>
        <forward mode='bridge'/>
        <bridge name='br0'/>
        <virtualport type='openvswitch'/>
          <portgroup name='isolated-2102' default='yes'>
        </portgroup>
      </network>

Router
^^^^^^

For the router or promisc VM it is sufficient to be in the VLAN 2102 in
this case.

For proxy ARP to work properly for the connected isolated VMs
``net.ipv4.conf.$IFACE.proxy_arp_pvlan=1`` is required:

::

      auto vlan2102
      iface vlan2102 inet manual
          vlan_raw_device eth0
          up ip link set up dev $IFACE
          up sysctl net.ipv4.conf.$IFACE.proxy_arp_pvlan=1 || :
          up /etc/network/static_arp $IFACE || :


Hook Script
^^^^^^^^^^^

The /etc/libvirt/hooks/qemu script was implemented with bash and
xmlstarlet:


::

   #!/bin/bash                                                                     


   #/etc/libvirt/hooks/qemu guest_name started begin -         
                                                                                                                                                    
   #grep bridge from somewhere?                                                                                                                   
                                                                                                                                                    
   flowdir=/var/run/openvswitch/libvirt-flows                                                                                                       
   mkdir -p "${flowdir}"                                                                                                                            
                                                                                                                                                    
   bridge="br0"                                                                                                                                     
                                                                                                                                                    
   domain_name="$1"
   domain_task="$2"

   flow_add(){
       xmlstarlet select -t -m "//devices/interface[@type='network']" \
           -v "concat(mac/@address, ' ', source/@portgroup, ' ', target/@dev)" -n | \
       while read -r mac portgroup port; do
           if [ "$mac" != "" -a "$portgroup" != "" -a "$port" != "" ]; then
               nport="$(ovs-ofctl show "${bridge}" | egrep "\(${port}\)" | cut -d '(' -f 1|tr -d ' ')"
               ethtool -K ${port} tx off
               case "${portgroup}" in
                 isolated-*)
                   vlan="${portgroup/isolated-}"
                   #tag ingress packet with vlanid, continue with normal action, drop other stuff from port
                   echo "priority=201,dl_src=${mac},in_port=${nport},dl_vlan=0xffff,actions=mod_vlan_vid:${vlan},normal" > "${flowdir}/${domain_name}"
                   echo "priority=200,in_port=${nport},actions=drop" >> "${flowdir}/${domain_name}"
                   #egress packet with vlanidXX and dstmac to corresponding port 
                   echo "priority=201,dl_dst=${mac},dl_vlan=${vlan},actions=strip_vlan,output:${nport}" >> "${flowdir}/${domain_name}"
                   #turn of flooding on port
           ovs-ofctl mod-port "${bridge}" "${nport}" no-flood
           #activate flows
                   ovs-ofctl add-flows "${bridge}" "${flowdir}/${domain_name}"
                   ;;
               esac
           fi
       done
   }

   flow_del() {
       xmlstarlet select -t -m "//devices/interface[@type='network']" \
           -v "concat(mac/@address, ' ', source/@portgroup, ' ', target/@dev)" -n | \
       while read -r mac portgroup port; do
           if [ "$mac" != "" -a "$portgroup" != "" -a "$port" != "" ]; then
               case "${portgroup}" in
                 isolated-*)
                   if [ -e "${flowdir}/${domain_name}" ]; then
                       cat "${flowdir}/${domain_name}" | sed -e 's/^priority=[0-9]*,//' | sed -e 's/,actions=.*//' | ovs-ofctl del-flows "${bridge}" -
                       rm -f "${flowdir}/${domain_name}"
                   fi
                   ;;
               esac
           fi
       done
   }

   case "${domain_task}" in
     started)
       flow_add
       ;;
     stopped)
       flow_del
       ;;
     reconnect)
       flow_del
       flow_add
       ;;
     migrate)
       flow_add
       ;;
     *)
       exit 0
       echo "qemu hook called with unexpected options $*" >&2
       ;;
   esac

   exit 0

    

This script will generate three flow entries per VM upon start/migration
and write these to /var/run/openvswitch/libvirt-flows. It will also turn
of flooding on an isolated port.

Limitations
^^^^^^^^^^^

-  The flow entries have to be recreated every time a machine is started
   or migrated.
-  No flooding. So stuff that relies on broadcast/multicast between
   hosts might break.
-  Since there is no flooding on the VM's OVS port the promiscous VM
   which acts as router has to have static ARP entries for all VMs it is
   directly connected to.
-  Tested with libvirt 1.2.1.
-  libvirt 1.2.4 strips the portgroup element upon start.
-  hackish script ;)
