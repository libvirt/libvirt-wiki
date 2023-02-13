.. contents::

Domain starting fails with Error "monitor socket did not show up"
-----------------------------------------------------------------

Symptom
~~~~~~~

Domain starting fails with error "monitor socket did not show up". e.g.

% virsh -c qemu:///system create vm.xml error: Failed to create domain
from vm.xml error: monitor socket did not show up.: Connection refused

Investigation
~~~~~~~~~~~~~

The error can tell we 3 points:

::

    1) libvirt works well
    2) qemu process fails to start up 
    3) libvirt quits when trying to connect the qemu or qemu agent monitor socket

To known the exact error, we should look into the guest log. e.g.

::

   % cat /var/log/libvirt/qemu/vm.log
   LC_ALL=C PATH=/sbin:/usr/sbin:/bin:/usr/bin QEMU_AUDIO_DRV=none /usr/bin/qemu-kvm -S -M fedora-13 -enable-kvm -m 768 -smp 1,sockets=1,cores=1,threads=1 -name vm -uuid ebfaadbe-e908-ba92-fdb8-3fa2db557a42 -nodefaults -chardev socket,id=monitor,path=/var/lib/libvirt/qemu/vm.monitor,server,nowait -mon chardev=monitor,mode=readline -no-reboot -boot c -kernel /var/lib/libvirt/boot/vmlinuz -initrd /var/lib/libvirt/boot/initrd.img -append method=http://www.mirrorservice.org/sites/download.fedora.redhat.com/pub/fedora/linux/releases/12/Fedora/x86_64/os/ -drive file=/var/lib/libvirt/images/vm.img,if=none,id=drive-ide0-0-0,boot=on -device ide-drive,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0 -device virtio-net-pci,vlan=0,id=net0,mac=52:40:00:f4:f1:0a,bus=pci.0,addr=0x4 -net tap,fd=42,vlan=0,name=hostnet0 -chardev pty,id=serial0 -device isa-serial,chardev=serial0 -usb -vnc 127.0.0.1:0 -k en-gb -vga cirrus -device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x3 
   char device redirected to /dev/pts/1
   qemu: could not load kernel '/var/lib/libvirt/boot/vmlinuz':
   Permission denied

Solution
~~~~~~~~

The cause could be various, in most cases, the error in guest log could
tell what happened, and one could fix the problem according to the
error.

One particular problem, present with libvirt older than 0.9.5, is if a
host was shutdown while the guest was running, and the libvirt-guests
init script attempted to perform a managed save of the guest. If the
managed save was incomplete (such as loss of power before the managed
save image was flushed to disk), then the save image is corrupted and
will not be loaded by qemu, but the older libvirt did not recognize the
corruption, making the problem perpetual. In this particular failure
case, the guest log will show an attempt to use "-incoming" as one of
its arguments, meaning that libvirt is trying to do start qemu by
migrating in the saved state file. The problem can be fixed by running
'virsh managedsave-remove $domain' to remove the corrupted managed save
image. Newer libvirt takes steps to avoid the corruption in the first
place, as well as adding 'virsh start --force-boot $domain' as a way to
bypass any managed save image.
