.. contents::

Failed to connect to the hypervisor
-----------------------------------

There are lots of errors that can occur while connecting to the server
(when running virsh for example)

No connection driver available
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Symptom**

When running a command, the following error (or similar) appears:

::

   $ virsh -c <uri> list
   error: no connection driver available for No connection for URI <uri>
   error: failed to connect to the hypervisor

**Cause**

This can happen when libvirt is compiled from sources. The error means
there is no driver to use with the specified URI (e.g. "Xen" for
"xen://server/")

**Investigation**

Check the last part of configure ('./configure' or './autogen') output,
you should see something like this:

::

   configure: Drivers
   configure: 
   configure: <driver>: yes

For example talking about Xen:

::

   configure: Drivers
   configure: 
   configure:     Xen: yes

If however you see "<driver>: no" (e.g. "Xen:no"), that means configure
failed to find all the tools/libraries necessary to implement this
support or there was "--without-<driver>" parameter specified on the
command line.

**Solution**

Do not specify "--without-<driver>" on the command line of the
configuration script and make sure there are all development libraries
installed as well, then configure the sources again.

Cannot read CA certificate
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Symptom**

When running a command, the following error (or similar) appears:

::

   $ virsh -c <uri> list
   error: Cannot read CA certificate '/etc/pki/CA/cacert.pem': No such file or directory
   error: failed to connect to the hypervisor


**Investigation**

This error can be caused by various things, for some of them, the error
message is little misleading:

#. specified URI is wrong (missing one '/' -- e.g. 'qemu://system')
#. connection is not configured


**Solution**

**specified URI is wrong**

In the case of specifying 'qemu://system' or 'qemu://session' as a
connection URI, virsh is trying to connect to hostname 'system' or
'session' respectively because when hostname is specified, the transport
for qemu defaults to 'tls' and thus the need for a certificates. Use
three slashes in this case.

**connection is not configured**

You specified correct URI (e.g. 'qemu[+tls]://server/system') but the
certificates were not set up properly on your machine. There is a great
`In depth guide to configuring TLS <TLSSetup.html>`__. The solution is
most probably there.

Permission denied
~~~~~~~~~~~~~~~~~


**Symptom**

When running a command, the following error (or similar) appears:

::

   $ virsh -c qemu:///system list
   error: Failed to connect socket to '/var/run/libvirt/libvirt-sock': Permission denied
   error: failed to connect to the hypervisor


**Investigation**

You are trying to connect using unix socket. The connection to "qemu"
without any hostname specified is by default using unix sockets. If
there is no error running this command as root it's probably just
misconfigured.


**Solution**

If you want to be able to connect as non-root user using unix sockets,
configure following options in '/etc/libvirt/libvirtd.conf' accordingly:

::

   unix_sock_group = <group>
   unix_sock_ro_perms = <perms>
   unix_sock_rw_perms = <perms>

Other errors
~~~~~~~~~~~~

These other errors are even simpler to solve than those mentioned
before, so here is a list of error/solutions:

**unable to connect to server at 'server:port': Connection refused**

The daemon is not running on the server or it's configured not to listen
(configuration option 'listen_tcp' or 'listen_tls').

**End of file while reading data: nc: using stream socket: Input/output
error**

If you specified 'ssh' transport, the daemon is probably not running on
the server.

**End of file while reading data: : Input/output error**

If you are using ssh transport, for example, by executing

virsh --connect qemu+\ ssh://username@remove.host.com/system list

Probably the user you are using to access the server does not belong to
the proper group, such as 'libvirtd' for Ubuntu servers. Try adding the
user to the proper group on server and connect again. For example, below
is to be run on Ubuntu servers.

sudo usermod -G libvirtd -a username

Refer to `SSHSetup <SSHSetup.html>`__ for setup about other
distributions.
