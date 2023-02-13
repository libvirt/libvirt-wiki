.. contents::

Domain cannot be installed
--------------------------

Symptom
~~~~~~~

Even with qemu installed, virt-install fails to install a domain:

::

   hp ~ # virt-install --virt-type kvm --arch x86_64 --debug
   Mon, 06 Feb 2012 19:57:29 DEBUG    Launched with command line:
   /usr/bin/virt-install --virt-type kvm --arch x86_64 --debug
   Mon, 06 Feb 2012 19:57:29 DEBUG    Requesting libvirt URI default
   Mon, 06 Feb 2012 19:57:29 DEBUG    Received libvirt URI qemu:///system
   Mon, 06 Feb 2012 19:57:29 DEBUG    Requesting virt method 'default', hv type 'kvm'.
   Mon, 06 Feb 2012 19:57:29 ERROR    Host does not support any virtualization options for arch 'x86_64'
   Mon, 06 Feb 2012 19:57:29 DEBUG    Traceback (most recent call last):
     File "/usr/bin/virt-install-2.7", line 272, in get_virt_type
       machine=options.machine)
     File "/usr/lib64/python2.7/site-packages/virtinst/CapabilitiesParser.py", line 732, in guest_lookup
       {'virttype' : osstr, 'arch' : archstr})
   ValueError: Host does not support any virtualization options for arch 'x86_64'

Investigation
~~~~~~~~~~~~~

If host doesn't support any virtualization options it is weird. Let see
what libvirt thinks:

::

   hp ~ # virsh --connect qemu:///system capabilities
   <capabilities>

     <host>
       <uuid>604c8a12-cb5b-d911-985d-5404a67ef15d</uuid>
       <cpu>
         <arch>x86_64</arch>
         <model>Westmere</model>
         <vendor>Intel</vendor>
         <topology sockets='1' cores='4' threads='2'/>
         <feature name='rdtscp'/>
         <feature name='x2apic'/>
         <feature name='xtpr'/>
         <feature name='tm2'/>
         <feature name='est'/>
         <feature name='vmx'/>
         <feature name='ds_cpl'/>
         <feature name='monitor'/>
         <feature name='pbe'/>
         <feature name='tm'/>
         <feature name='ht'/>
         <feature name='ss'/>
         <feature name='acpi'/>
         <feature name='ds'/>
         <feature name='vme'/>
       </cpu>
       <migration_features>
         <live/>
         <uri_transports>
           <uri_transport>tcp</uri_transport>
         </uri_transports>
       </migration_features>
     </host>

   </capabilities>

A quick look into libvirt logs shows the root of problem:

::

   12:03:11.938: 3137: error : qemuCapsParseHelpStr:1165 : internal error cannot parse /usr/bin/qemu-system-x86_64
   version number in 'QEMU emulator version 1.0 (qemu-kvm-1.0), Copyright (c) 2003-2008 Fabrice Bellard'

In the past, libvirt expected qemu to use three fields when describing
version. However, new qemu uses only 2 fields. This was fixed in 0.9.8:
http://libvirt.org/git/?p=libvirt.git;a=commitdiff;h=dd8e8956060f38b084d581ed63f934c3d8202071

Solution
~~~~~~~~

#. Update to the latest libvirt (0.9.8+)
#. Downgrade qemu so it reports micro version number too.
