.. contents::

Libvirt daemon is not listening on TCP ports
--------------------------------------------

While libvirtd should listen on TCP ports for connections the
connections fail:

::

   # virsh -c qemu+tcp://host/system
   error: unable to connect to server at 'host:16509': Connection refused
   error: failed to connect to the hypervisor

Symptom
~~~~~~~

Libvirt daemon is not listening on TCP ports even after changing
configuration in /etc/libvirt/libvirtd.conf:

::

   # grep listen_ /etc/libvirt/libvirtd.conf
   listen_tls = 1
   listen_tcp = 1
   listen_addr = "0.0.0.0"

But the TCP ports for libvirt are not open:

::

   # netstat -lntp | grep libvirtd
   #

Problem
~~~~~~~

Libvirt daemon was started without the **--listen** option. You may
verify that by running:

::

   # ps aux | grep libvirtd
   root     27314  0.0  0.0 1000920 18304 ?       Sl   Feb16   1:19 libvirtd --daemon

The output does not contain the option **--listen**

Solution
~~~~~~~~

Start the daemon with the opiton **--listen**.

On RHEL/Fedora/CentOS modify the file **/etc/sysconfig/libvirtd** and
uncomment the following line:

::

   #LIBVIRTD_ARGS="--listen"

On Gentoo modify file **/etc/conf.d/libvirtd** and uncomment:

::

   #LIBVIRTD_OPTS="--listen"

| Restart the libvirtd service afterwards:

::

   # /etc/init.d/libvirtd restart
