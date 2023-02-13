.. contents::

Configuring the libvirt daemon to use TLS
=========================================

The libvirt daemon on both virtualisation servers needs to be configured
to use the TLS Certificates and Private Keys that have been installed.

If you have installed the TLS Certificates and keys in their default
locations, and if using the default network port is acceptable, the next
step is very simple.

All that needs to be done is instruct libvirt to listen for network
connections.

On RHEL 6 and Fedora, this is done by uncommenting the **LIBVIRTD_ARGS**
line in */etc/sysconfig/libvirtd*.

i.e. Changing the line from this:

::

    #LIBVIRTD_ARGS="--listen"

to this:

::

    LIBVIRTD_ARGS="--listen"

Then restart the libvirt daemon:

::

    # service libvirtd restart
    Stopping libvirtd daemon:                                  [  OK  ]
    Starting libvirtd daemon:                                  [  OK  ]

::

    # ps -ef |grep libvirtd
    root      6910     1 18 09:49 ?        00:00:01 libvirtd --daemon --listen

If for some reason the libvirt daemon hasn't restarted correctly with
this enabled, try manually starting the daemon from the command line. It
will helpfully display an error message indicating the problem, before
it exits.

For example, with the server certificate not in place, this is given:

::

    # libvirtd --listen
    09:58:12.968: error : remoteCheckCertFile:277 : Cannot access server certificate '/etc/pki/libvirt/servercert.pem': No such file or directory


Restricting access
------------------

To assist in protecting your virtualisation servers against unauthorised
access, you can instruct libvirt to only accept TLS connections from a
given list of client systems.

This is done by configuring the **tls_allowed_dn_list** option in the
*libvirtd.conf* configuration file, listing the **Distinguished Name**
of each virtualisation client allowed to connect.

::

    tls_allowed_dn_list = ["Client 1",
                           "Client 2",
                           "Client 3"]

The Distinguished Name is in the output from the certtool command used
when creating Client Certificates, as shown in the `previous
step <TLSCreateClientCerts.html#combine-the-template-files-with-the-private-key-files-to-create-the-client-certificates>`__.

For example:

::

    tls_allowed_dn_list = ["C=AU,O=libvirt.org,L=Brisbane,ST=Queensland,CN=host1",
                           "C=AU,O=libvirt.org,L=Brisbane,ST=Queensland,CN=host2",
                           "C=AU,O=libvirt.org,L=Brisbane,ST=Queensland,CN=admindesktop"]

**NOTE - Do not enable this option with an empty list. That will cause
libvirt to listen for TLS connections but reject all of them.**

For this change to take effect, the libvirt daemon needs to be
restarted:

::

    # service libvirtd restart
    Stopping libvirtd daemon:                                  [  OK  ]
    Starting libvirtd daemon:                                  [  OK  ]


Verifying it all works
----------------------

The final step is to verify TLS connections are set up and working
correctly.

This can be done using the virsh utility, and client to server path
should be individually tested. In our example scenario this means
testing:

-  From the admin desktop to both virtualisation hosts
-  From host 1 to host 2
-  From host 2 to host 1

If the connection works, then we'll be able to run an administrative
command on the remote host. We use the virsh command "hostname" for our
testing, to retrieve the host name of the remote host. This doesn't
change anything on the remote host, but proves the TLS connection is
working.

If something is not set up correctly, the connection will fail with
virsh giving an error message. For example:

::

    # virsh -c qemu+tls://host1/system hostname
    error: server verification (of our certificate or IP address) failed
    error: failed to connect to the hypervisor

It's worth also remembering that TLS is the default connection type
attempted for QEMU URL's, so we don't need to include **+tls** in the
connection string. Both of these are equivalent:

::

    # virsh -c qemu://host2/system

::

    # virsh -c qemu+tls://host2/system

| **Testing from the admin desktop to both hosts**

.. image:: images/Tls_small_admin_desktop_to_both_hosts.png

::

    # virsh -c qemu://host1/system hostname
    host1.libvirt.org

::

    # virsh -c qemu://host2/system hostname
    host2.libvirt.org

| **From host 1 to host 2**

.. image:: images/Tls_small_testing_connection_host1_to_host2.png

::

    # virsh -c qemu://host2/system hostname
    host2.libvirt.org

| Finally, **from host 2 to host 1**

.. image:: images/Tls_small_testing_connection_host2_to_host1.png

::

    # virsh -c qemu://host1/system hostname
    host1.libvirt.org

| **If all of the tests worked fine (they should), then congratulations,
  the TLS Configuration is complete**


Full list of steps
------------------

#. `TLS Concepts in libvirt <TLSSetup.html>`__
#. `Create the Certificate Authority Certificate <TLSCreateCACert.html>`__
#. `Create the Server Certificates <TLSCreateServerCerts.html>`__
#. `Create the Client Certificates <TLSCreateClientCerts.html>`__
#. Configure the libvirt daemon - **this page**
#. `Further References <TLSFurtherReferences.html>`__
