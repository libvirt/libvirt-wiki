.. contents::

No guest machines are present
-----------------------------

Symptom
~~~~~~~

No virtual machines are present although the daemon was successfuly
started.

::

   # virsh list --all
    Id    Name                           State
   ----------------------------------------------------
   #

Solution
~~~~~~~~

There are multiple possibilities what could have gone wrong:

-  Verify that KVM kernel modules are inserted in the kernel:

::

   # lsmod | grep kvm
   kvm_intel             121346  0
   kvm                   328927  1 kvm_intel

(kvm_amd on a AMD machine)

If the modules are not present insert them using the *modprobe
<modulename>* command. (Note: KVM virtualization support may be compiled
into the kernel, so modules are not needed. This is uncommon.)

-  Verify that virtualization extensions are enabled/supported on the
   host:

::

   # egrep "(vmx|svm)" /proc/cpuinfo
   flags       : fpu vme de pse tsc ... svm ... skinit wdt npt lbrv svm_lock nrip_save
   flags       : fpu vme de pse tsc ... svm ... skinit wdt npt lbrv svm_lock nrip_save

Enable virtualization extensions in your hardware's firmware
configuration (BIOS setup).

-  Verify that the URI of the client is as desired ( Trying to connect
   to a qemu hypervisor)

::

   # virsh uri
   vbox:///system

There may be other hypervisors present and libvirt will talk to them by
default.
