.. contents::

The domain cannot be started when specifying different processor
----------------------------------------------------------------

Symptom
~~~~~~~

Running on Intel Nehalem (or older Penryn) processor, a KVM domain is
created using virt-manager. After instalation, the domain's processor is
changed to match the host's CPU. The domain is then unable to start:

::

   2012-02-06 17:49:15.985+0000: 20757: error : qemuBuildCpuArgStr:3565 : internal error guest CPU is not compatible with host CPU

Moreover, clicking "Copy host cpu configuration" in virt-manager will
show "Pentium III" instead of Nehalem/Penryn.

.. image:: images/Virt-manager-copy-host-cpu-configuration.png

Investigation
~~~~~~~~~~~~~

In ``/usr/share/libvirt/cpu_map.xml`` we can see which flags define what
CPU model. If we take a look at Nehalem/Penryn definition, we can see
this:

::

   <feature name='nx'/>

which means ``nx`` flag needs to be presented to identify CPU as
Nehalem/Penryn. However, taking look into ``/proc/cpuinfo`` we can see
this flag is missing.

Solution
~~~~~~~~

Nearly all new BIOSes allow to enable or disable 'No eXecute' bit.
However, if disabled some CPUs doesn't report this flag and thus libvirt
detects different CPU. Enabling this functionality will then make
libvirt report the correct CPU.
