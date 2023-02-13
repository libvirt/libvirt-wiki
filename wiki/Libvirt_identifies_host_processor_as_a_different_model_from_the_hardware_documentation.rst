.. contents::

Libvirt identifies host processor as a different model from the hardware documentation
--------------------------------------------------------------------------------------

Symptom
~~~~~~~

Libvirt occasionally identifies the host processor as a different model
from the hardware's documentation, almost always as a less capable
model. This identification difference can cause problems when comparing
machines, creating clusters that expect same processor models etc. This
problem is then propagated to upper layers that use libvirt to determine
the processor model or ask libvirt for a best supported processor model
for a guest (vdsm, oVirt etc.).

For example the user expects to see 'Westmere' in the output of the
command, but the output looks like this:

::

   $ virsh capabilities
   <capabilities>

     <host>
       <uuid>604c8a12-cb5b-d911-985d-5404a67ef15d</uuid>
       <cpu>
         <arch>x86_64</arch>
         <model>Nehalem</model>
   [...]

Investigation
~~~~~~~~~~~~~

Because libvirt compares the processor model according to its features,
there is probably some feature missing. The file used for that is
'/usr/share/libvirt/cpu_map.xml'. Looking at the file, there is only one
difference between these models:

::

       <model name='Westmere'>
         <model name='Nehalem'/>
         <feature name='aes'/>
       </model>

As can be seen from this example, the processor model 'Westmere'
inherits all the features from model 'Nehalem' and adds suport for AES,
so let's double check that:

::

   $ grep aes /proc/cpuinfo
   $ #(Notice there was no output)

No output from the previous command means there is no support for AES
and hence the libvirt identified it correctly from this point of view
(if there was an output with 'aes' mentioned, that would mean a bug).

Solution
~~~~~~~~

It might happen that there is a "bug in hardware", but there are some
cases in which there's still a solution related to software/firmware as
on few occasions reported by users this could be triggered by
manipulating BIOS settings or UEFI settings. Some of these experiences
follow.

**Westmere or better recognized as Nehalem:**

If this machine happens to be a IBM BladeCenter, you most probably need
the IBM Advanced Settings Utility (ASU) from
http://www-947.ibm.com/support/entry/portal/docdisplay?lndocid=TOOL-ASU
that can manipulate UEFI settings.

Instructions for 64-bit Linux host (modify according to your host
machine/OS, IBM manual and your installation):

Reading the config parameter value

::

   ./asu64 show uEFI.AesEnable

Setting the value:

::

   ./asu64 set uEFI.AesEnable Enable

After the modification and host reboot the processor should have AES
support.

**AMD Quad Core Opteron G3 or better recognized as Opteron G2:**

This is once again thanks to the AES flag, but this time it may be
sometimes possible to fix this by enabling NX bit support in BIOS.
