.. contents::

Further information
===================

These pages have covered setting up TLS on your virtualisation hosts.

Further information is available on several of the major items covered:

**VNC Client configuration for TLS** - Instructions for setting up
several well known VNC client packages are on the `VNC Client TLS
Setup <VNCTLSSetup.html>`__ page.

**libvirtd.conf** - The libvirt daemon configuration file has more
options than described in these pages. They are all shown and briefly
described in `the libvirt.org reference
page <http://libvirt.org/remote.html#Remote_libvirtd_configuration>`__.

**certtool** - The utility used to generate private keys and
certificates, has its `full manual page
online <http://www.gnu.org/software/gnutls/manual/html_node/The-certtool-application.html>`__.
This includes both its command line options, and the options usable in
the template file.

**The X509 Trust Model** - The GnuTLS pages have useful information
describing `the X509 certificate trust
model <http://www.gnu.org/software/gnutls/manual/html_node/The-X_002e509-trust-model.html#The-X_002e509-trust-model>`__.


Full list of steps
------------------

#. `TLS Concepts in libvirt <TLSSetup.html>`__
#. `Create the Certificate Authority Certificate <TLSCreateCACert.html>`__
#. `Create the Server Certificates <TLSCreateServerCerts.html>`__
#. `Create the Client Certificates <TLSCreateClientCerts.html>`__
#. `Configure the libvirt daemon <TLSDaemonConfiguration.html>`__
#. Further References - **this page**
