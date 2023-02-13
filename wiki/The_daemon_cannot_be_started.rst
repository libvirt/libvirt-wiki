.. contents::

The daemon cannot be started
----------------------------

Symptom
~~~~~~~

The libvirt daemon cannot be started:

::

   # /etc/init.d/libvirtd start
   * Caching service dependencies ...                                                                                             [ ok ]
   * Starting libvirtd ...
   /usr/sbin/libvirtd: error: Unable to initialize network sockets. Check /var/log/messages or run without --daemon for more info.
   * start-stop-daemon: failed to start `/usr/sbin/libvirtd'                                                                      [ !! ]
   * ERROR: libvirtd failed to start

However, there is nothing in the ``/var/log/messages``. Therefore we
need to change libvirt logging:

``/etc/libvirt/libvirtd.conf``:

::

   # You need to uncomment this line
   log_outputs="3:syslog:libvirtd"

After that, we try to startup libvirt once again. This time we can see
the problem: ``/var/log/messages:``

::

   Feb  6 17:22:09 bart libvirtd: 17576: info : libvirt version: 0.9.9
   Feb  6 17:22:09 bart libvirtd: 17576: error : virNetTLSContextCheckCertFile:92: Cannot read CA certificate '/etc/pki/CA/cacert.pem': No such file or directory
   Feb  6 17:22:09 bart /etc/init.d/libvirtd[17573]: start-stop-daemon: failed to start `/usr/sbin/libvirtd'
   Feb  6 17:22:09 bart /etc/init.d/libvirtd[17565]: ERROR: libvirtd failed to start

Investigation
~~~~~~~~~~~~~

In libvirtd manpage, we can find that missing file is used as TLS
authority when libvirt is run in 'Listen for TCP/IP connections' mode.
In other words, the ``--listen`` parameter is being passed.

Solution
~~~~~~~~

#. Install CA certificate
#. Don't use TLS but bare TCP instead. In ``/etc/libvirt/libvirtd.conf``
   set ``listen_tls = 0`` and ``listen_tcp = 1``.
#. Don't pass ``--listen``. In ``/etc/sysconfig/libvirtd`` change
   ``LIBVIRTD_ARGS`` variable.
