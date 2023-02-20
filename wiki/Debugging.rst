.. contents::

When trying to figure out what libvirt does,
`DebugLogs <https://libvirt.org/kbase/debuglogs.html>`__ might not always be enough. And sometimes
you might want to get some information from a user, but you do not want
to waste both your and their time by explaining how to do stuff in gdb
to, for example, get a backtrace. Here are some useful tips that you
might use.

Prerequisites
-------------

In cases where you want to see details of what is happening, you need to
have debugging symbols installed, at least for the package you are
trying to debug. Although having debugging symbols for all dependent
libraries is usually helpful as well. Usually ``gdb`` will tell you what
you need to do in order to get the proper data to your machine when you
run it with a binary.

Example:
~~~~~~~~

Running this command on 32bit Fedora 29 tells us what to install in
order to get the proper debugging symbols:

::

   # gdb $(which libvirtd)
   GNU gdb (GDB) Fedora 8.2-6.fc29
   ...
   Reading symbols from /usr/sbin/libvirtd...(no debugging symbols found)...done.
   Missing separate debuginfos, use: dnf debuginfo-install libvirt-daemon-4.7.0-1.fc29.i686

When the package is installed, we can break on main and run until then
(gdb's command ``start`` is perfect for this):

::

   # gdb $(which libvirtd)
   GNU gdb (GDB) Fedora 8.2-6.fc29
   ...
   Reading symbols from /usr/sbin/libvirtd...Reading symbols from /usr/lib/debug/usr/sbin/libvirtd-4.7.0-1.fc29.i386.debug...done.
   done.
   (gdb) start
   Temporary breakpoint 1 at 0x18fc0: file remote/remote_daemon.c, line 1030.
   Starting program: /usr/sbin/libvirtd 
   Missing separate debuginfos, use: dnf debuginfo-install glibc-2.28-26.fc29.i686
   Missing separate debuginfo for /lib/libvirt-lxc.so.0
   Try: dnf --enablerepo='*debug*' install /usr/lib/debug/.build-id/4d/16496b686ec54ca4201bd769b04293f6c756b3.debug
   Missing separate debuginfo for /lib/libvirt-qemu.so.0
   Try: dnf --enablerepo='*debug*' install /usr/lib/debug/.build-id/ea/91d5346bd3e265ffb12ae641ca93643443e6e7.debug
   Missing separate debuginfo for /lib/libvirt.so.0
   Try: dnf --enablerepo='*debug*' install /usr/lib/debug/.build-id/02/af3a96fc6227ed5e3a447344bcbb672bde14ba.debug
   ...
   Temporary breakpoint 1, main (argc=1, argv=0xbffff614) at remote/remote_daemon.c:1030
   1030    int main(int argc, char **argv) {
   Missing separate debuginfos, use: dnf debuginfo-install audit-libs-3.0-0.5.20181218gitbdb72c0.fc29.i686 avahi-libs-0.7-16.fc29.i686 brotli-1.0.5-1.fc29.i686 cyrus-sasl-lib-2.1.27-0.3rc7.fc29.i686 dbus-libs-1.12.12-1.fc29.i686 device-mapper-libs-1.02.154-1.fc29.i686 gmp-6.1.2-9.fc29.i686 gnutls-3.6.6-1.fc29.i686 keyutils-libs-1.5.10-8.fc29.i686 krb5-libs-1.16.1-25.fc29.i686 libacl-2.2.53-2.fc29.i686 libattr-2.4.48-3.fc29.i686 libblkid-2.32.1-1.fc29.i686 libcap-2.25-12.fc29.i686 libcap-ng-0.7.9-5.fc29.i686 libcom_err-1.44.4-1.fc29.i686 libcurl-7.61.1-10.fc29.i686 libffi-3.1-18.fc29.i686 libgcrypt-1.8.4-1.fc29.i686 libidn2-2.1.1a-1.fc29.i686 libmount-2.32.1-1.fc29.i686 libnghttp2-1.34.0-1.fc29.i686 libnl3-3.4.0-6.fc29.i686 libpsl-0.20.2-5.fc29.i686 libselinux-2.8-6.fc29.i686 libsepol-2.8-3.fc29.i686 libssh-0.8.7-1.fc29.i686 libssh2-1.8.1-1.fc29.i686 libtirpc-1.1.4-2.rc2.fc29.i686 libunistring-0.9.10-4.fc29.i686 libuuid-2.32.1-1.fc29.i686 libwsman1-2.6.5-8.fc29.i686 libxcrypt-4.4.4-2.fc29.i686 libxml2-2.9.8-5.fc29.i686 lz4-libs-1.8.3-1.fc29.i686 numactl-libs-2.0.12-1.fc29.i686 openldap-2.4.46-10.fc29.i686 openssl-libs-1.1.1b-3.fc29.i686 p11-kit-0.23.15-2.fc29.i686 pcre2-10.32-8.fc29.i686 xz-libs-5.2.4-3.fc29.i686 yajl-2.1.0-11.fc29.i686 zlib-1.2.11-14.fc29.i686

You might need to run the above commands for more complete output. It is
very dependent on the actually problem, whether you need this or not,
but it will never hurt to actually have all the data installed.

When libvirt hangs
------------------

When a process hangs, we usually ask for a backtrace. To avoid problems
with paging and so on, it is usually very helpful to just get a
backtrace for one instance of the particular process. For that you can
use something like this:

::

   # gdb -batch -p $(pidof libvirtd) -ex 't a a bt f'

This command will attach to currently running libvirtd process and run
``t a a bt f``, which is short for ``thread apply all backtrace full``,
feel free to combine with ``sudo`` for users. If you are using this for
virsh, or any other binary which might have multiple processes running,
then make sure you supply the right pid for the ``-p`` option. For more
info, read below about how to `automate
gdb <Debugging.html#automating-gdb>`__.

When libvirt crashes
--------------------

Different distros have different mechanisms of catching and reporting
crashes. The automated ones are usually enabled only for the packaged
binaries, but that should be enough for users. Developers will have
their own way of doing things anyway.

-  **systemd-coredump** -- ``coredumpctl show`` shows all needed
   information (even a backtrace) of the last crash, use
   ``coredumpctl ls`` to list all crashes cordumpctl knows about.

-  **abrt** -- ``abrt-cli`` works similarly to the above (TBD: how to
   get the backtrace using abrt-cli)

-  **setup your own** -- you can do one of these things:

   -  set the ulimit for the service (depends on your init system) and
      look for the file that gets created
   -  set kernel.core_pattern using sysctl to a command (rather than a
      filename template) that gets ran with each core dump. This one
      does not need any ulimit setting, but you need to know what to
      specify there.

For more information see related documentation.

Automating gdb
--------------

When you need more specific behaviour from gdb, you can automate that,
but for multiline commands you need an input redirection or execute them
from the file.

Multiline example:
~~~~~~~~~~~~~~~~~~

Simple example that will print backtrace when ``abort()`` is reached.

::

   $ cat >/var/lib/libvirt/gdbabortscript <<EOF
   start
   break abort
   commands
   t a a bt full
   end
   continue
   EOF

This file instructs gdb to ``start`` the program (run until ``main()``),
that will load all the libraries so that we can setup a breakpoint for
(p[retty much) any existing function. It then sets up a breakpoint for
the ``abort()`` function and immediately sets up a list of ``commands``
that will run when that breakpoint is hit (list of commands ends with
``end``). After that it allows the process to ``continue`` its
execution.

Systemd example:
~~~~~~~~~~~~~~~~

Let's say you need to debug an issue which happens only when the daemon
is run as a service as it does not happen when run manually. Ideally you
would connect to a running instance, but if the issue happens right
after starting the daemon. One option would be utilizing ``systemtap``
to add a ``sleep()`` in one of the early functions (TBD: add an
automated way of doing that or remove this tip if it's not worth it).
Another idea is to make the init system run the gdb command we need.

In systemd world we can do this easily by overriding the ``ExecStart``
parameter:

::

   # cat >/etc/systemd/system/libvirtd.service.d/override.conf <<EOF
   [Service]
   ExecStart=
   ExecStart=/usr/bin/gdb --batch -x /var/lib/libvirt/gdbabortscript /usr/sbin/libvirtd $LIBVIRTD_ARGS
   EOF

Daemon needs to be reloaded to know about this file:

::

   # systemctl daemon-reload

We also need to make sure that the file we created will be readable by
the service. DAC should be fine, SELinux might get tricky. By placing
the file under ``/var/lib/libvirt`` this should be readable by both the
init system and the libvirt daemon, but we need to make sure it has a
proper context:

::

   # restorecon -F /var/lib/libvirt/gdbabortscript /etc/systemd/system/libvirtd.service.d/override.conf

We actually do not need this to be read by the init system, but gdb will
most probably run under the same SELinux context as init, the context
for libvirtd gets changed by a transition rule which depends on the
current runnning context and the context of the binary being executed,
so that whould apply only when libvirtd is being started. This *should*
work most of the time. If it does not work for you, please figure out a
way and add it here.

Now we need to restart the daemon:

::

   # systemctl restart libvirtd.service

Beware, the command will not end until libvirtd itself ends as systemd
is waiting for ``sd_notify()`` from gdb's PID, but that function is
being called by libvirtd.

You should get the full backtrace in the output of:

::

   # journalctl -u libvirtd.service
