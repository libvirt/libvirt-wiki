.. contents::

Description
===========

This page gives the instructions for setting up VNC to communicate over
TLS.

The paths given are from Fedora 13 & RHEL 6, so any system paths may be
different on other Linux distributions. The per-user paths will likely
be the same regardless of distribution.

TLS should be set up on the servers first
=========================================

Before using TLS to connect to virtual machines, their host servers must
be configured for TLS.

The steps for doing this are fully documented on the `TLS Setup
page <TLSSetup.html>`__


What you will need
==================

Once the host servers are set up for TLS (and verified), the client set
up is fairly straightforward.

You will need:

#. A Certificate Authority "Certificate" file
#. A "Client" Certificate file, signed with the above Certificate
   Authority Certificate
#. The private key for this Client Certificate file

Creating these files isn't too difficult. The steps to follow are listed
on the previously mentioned `TLS Setup page <TLSSetup.html>`__

The paths to install the files at are listed below. In addition, all of
the working VNC clients can accept an optional Certificate Revocation
List (CRL) file. This can be either in a system wide path, or in a
per-user location:

-  System wide location: /etc/pki/CA/cacrl.pem
-  Per-user location: $HOME/.pki/CA/cacrl.pem


Security
========

Be careful when using *system wide* client certificates. Any user with
read access to a client certificate + private key can use it to
authenticate to your (configured) virtualisation servers. So, if you
have permissions allowing wide read access (ie 644) to those files on a
client system, any user with login access to that client system can then
perform admin commands on your virtualisation servers. That *may not* be
what you want. Use good unix security (groups, permissions, acls, roles,
etc) to manage access to the certificate + private key.


Changes to be made on the virtualisation host server
====================================================

(please note these are Fedora 13 & RHEL 6 specific paths, other
distributions may vary)

1. You need to enable some settings in */etc/libvirt/qemu.conf* on the
   host server.

   a) Instruct QEMU virtual machines to listen for incoming connections

      ::

          vnc_listen = "0.0.0.0"

      **0.0.0.0** instructs QEMU to listen on all network interfaces. You can
      give a specific IP address instead if required.

   b) Enable TLS for connections

      ::

          vnc_tls = 1

   c) Enable use of X509 certificates for authentication

      ::

          vnc_tls_x509_verify = 1

2. Place the TLS Server Certificate and matching private key files
   where your QEMU user can access them.

   The QEMU process needs read access to a TLS Certificate Authority
   Certificate, a Server Certificate signed by it, and the private key for
   the Server Certificate. These must be placed in:

   -  **Certificate Authority Certificate:**
      /etc/pki/libvirt-vnc/ca-cert.pem
   -  **Server Certificate:** /etc/pki/libvirt-vnc/server-cert.pem
   -  **Private Key for the Server Certificate:**
      /etc/pki/libvirt-vnc/server-key.pem

   Soft links to the certificates and keys for the main libvirt
   configuration can be used:

   ::

       $ sudo mkdir -m 750 /etc/pki/libvirt-vnc
       $ sudo ln -s /etc/pki/CA/cacert.pem /etc/pki/libvirt-vnc/ca-cert.pem
       $ sudo ln -s /etc/pki/libvirt/servercert.pem /etc/pki/libvirt-vnc/server-cert.pem
       $ sudo ln -s /etc/pki/libvirt/private/serverkey.pem /etc/pki/libvirt-vnc/server-key.pem

   By default on RHEL 6 and Fedora 13+ (older is untested), QEMU
   processes are launched using *qemu*:*qemu* ownership.

   You mush ensure it can read the TLS certificate files. If you used soft
   links as in the example above, one way to achieve this is:

   ::

       $ sudo chgrp qemu /etc/pki/libvirt \
                         /etc/pki/libvirt-vnc \
                         /etc/pki/libvirt/private \
                         /etc/pki/libvirt/servercert.pem \
                         /etc/pki/libvirt/private/serverkey.pem

       $ sudo chmod 750 /etc/pki/libvirt \
                        /etc/pki/libvirt-vnc \
                        /etc/pki/libvirt/private

       $ sudo chmod 440 /etc/pki/libvirt/servercert.pem \
                        /etc/pki/libvirt/private/serverkey.pem

3. If you're using Virt Manager or Virt Viewer, you also need to
   enable a setting in */etc/sysconfig/libvirtd* on the host server.

   ::

       LIBVIRTD_ARGS="--listen"

4. Restart the libvirt daemon

   ::

       $ sudo service libvirtd restart
       Stopping libvirtd daemon:                                  [  OK  ]
       Starting libvirtd daemon:                                  [  OK  ]

5. The VNC TLS setting is only recognised at guest start time, so if
   you have guests running from before you made these changes, you'll
   need to restart them for it to be effective.

6. Verify things are correct by connecting to a virtualized guest
   using one of the VNC clients known to work.


VNC clients known to work
=========================

Vinagre
-------

Home page: http://projects.gnome.org/vinagre

Command line usage example:

::

    $ vinagre hostserver:0

Certificate Authority Certificate (vinagre)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  System wide: /etc/pki/CA/cacert.pem
-  Per-user: $HOME/.pki/CA/cacert.pem

Client Certificate (vinagre)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  System wide: /etc/pki/vinagre/clientcert.pem
-  Per-user: $HOME/.pki/vinagre/clientcert.pem

Private key for the Client Certificate (vinagre)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  System wide: /etc/pki/vinagre/private/clientkey.pem
-  Per-user: $HOME/.pki/vinagre/private/clientkey.pem


Virtual Machine Manager (virt-manager)
--------------------------------------

Home page: http://virt-manager.org

Virtual Machine manager is a bit special, as it uses two sets of TLS
Certificates for its operation. It uses one set of system wide
certificates for general (non VNC) communication to a virtualisation
host server. It uses another **separate** set of client certificates for
VNC communication. You will need both sets in place for it to all work
nicely.

You can reuse the same certificates for both purposes, and even just use
one set linked (ln -s) to the other.

Command line usage example:

::

    $ virt-manager -c qemu+tls://root@hostserver/system --show-domain-console=4ce376a6-db4a-9382-4f06-03ea4d2f6d0b

With the above example, the *4ce376a6-db4a-9382-4f06-03ea4d2f6d0b* is
the UUID of a virtual machine, separately retrieved using the virsh
*domuuid* command. Virt Manager (at this stage) doesn't appear to allow
using a plain guest name here.

Non-VNC TLS Certificates
^^^^^^^^^^^^^^^^^^^^^^^^

-  Certificate Authority Certificate: /etc/pki/CA/cacert.pem
-  Client Certificate: /etc/pki/libvirt/clientcert.pem
-  Client Private Key: /etc/pki/libvirt/private/clientkey.pem

VNC specific certificates
^^^^^^^^^^^^^^^^^^^^^^^^^

The client certificate and key can either be provided in a system wide
location for use by anyone on the client machine (with appropriate
access), or they can be provided by the user in their own home directory
structure:

VNC Certificate Authority Certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  System wide: /etc/pki/CA/cacert.pem

VNC Client Certificate
^^^^^^^^^^^^^^^^^^^^^^

-  System wide: /etc/pki/libvirt-vnc/clientcert.pem
-  Per-user: $HOME/.pki/libvirt-vnc/clientcert.pem

Private key for the VNC Client Certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  System wide: /etc/pki/libvirt-vnc/private/clientkey.pem
-  Per-user: $HOME/.pki/libvirt-vnc/private/clientkey.pem


Virt Viewer (virt-viewer)
-------------------------

Home page: http://virt-manager.org

Command line usage example:

::

    $ virt-viewer -c qemu+tls://root@hostserver/system guestname

Virt Viewer doesn't make use of client provided certificates, with the
exception of the optional Certificate Revocation List. The CA
Certificate, and both Client Certificate + its private key must be in
the system wide locations.

-  Certificate Authority Certificate: /etc/pki/CA/cacert.pem
-  Client Certificate: /etc/pki/libvirt/clientcert.pem
-  Private key for the Client Certificate:
   /etc/pki/libvirt/private/clientkey.pem


GTK-VNC (gtk-vnc)
-----------------

Home page: http://live.gnome.org/gtk-vnc

Command line usage example:

::

    $ python /usr/share/doc/gtk-vnc-python-0.3.10/gvncviewer.py hostserver:0


Certificate Authority Certificate (gtk-vnc)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  System wide: /etc/pki/CA/cacert.pem
-  Per-user: $HOME/.pki/CA/cacert.pem


Client Certificate (gtk-vnc)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  System wide: /etc/pki/gvncviewer/clientcert.pem
-  Per-user: $HOME/.pki/gvncviewer/clientcert.pem


Private key for the Client Certificate (gtk-vnc)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  System wide: /etc/pki/gvncviewer/private/clientkey.pem
-  Per-user: $HOME/.pki/gvncviewer/private/clientkey.pem


VNC clients known to NOT work with TLS (yet)
============================================

tigervnc
--------

-  tigervnc-1.0.90-0.12.20100420svn4030 as on my Fedora 13 x86_64
   workstation, doesn't support TLS with X509 Certificates

   -  There appears to be development happening along the right
      direction in the `tigervnc project
      itself <http://article.gmane.org/gmane.network.vnc.tigervnc.devel/588/match=tls>`__.
      Unsure when this will develop into TLS authentication (X509) +
      encryption though.


Items to check if things don't work
-----------------------------------

Was the QEMU virtual machine started with TLS + X509 enabled?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Make sure the QEMU virtual machine you're trying to connect to is
running with TLS and X509 Certificates enabled.

Look for the qemu process running on the host server. For example:

::

    $ ps -ef | grep qemu
    qemu     16048     1 18 14:09 ?        00:00:24 /usr/libexec/qemu-kvm -S -M rhel6.0.0
    -cpu Nehalem,+x2apic -enable-kvm -m 1024 -smp 2,sockets=2,cores=1,threads=1
    -name guest1 -uuid 4ce376a6-db4a-9382-4f06-03ea4d2f8d0b -nodefconfig
    -nodefaults -chardev socket,id=monitor,path=/var/lib/libvirt/qemu/guest1.monitor,server,nowait
    -mon chardev=monitor,mode=control -rtc base=utc -boot c
    -drive file=/nas/guest1.img,if=none,id=drive-virtio-disk0,boot=on,format=qcow2
    -chardev pty,id=serial0 -device isa-serial,chardev=serial0 -usb
    -vnc 0.0.0.0:0,tls,x509verify=/etc/pki/libvirt-vnc
    -k en-us -vga cirrus

This should show the command line arguments used to launch the qemu
process. There should be a "-vnc" argument in the list, with a value
similar to "0.0.0.0:0,tls,x509verify=/etc/pki/libvirt-vnc".

If the **tls** or **x509verify** parts are missing, then QEMU wasn't
started with TLS and X509 enabled. You may need to restart the virtual
machine if you've only just set TLS up. Otherwise, you will likely need
to investigate further.


You receive an error about not being able to send a monitor command
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you receive an error like this when trying to start a virtual
machine, this can mean QEMU was not able to read the TLS certificate or
private key files.

::

    # virsh start guest1
    error: Failed to start domain guest1
    error: cannot send monitor command '{"execute":"qmp_capabilities"}': Connection reset by peer

If you have QEMU configured to run as a non-root user, this user may not
have the access it needs to the server certificate and matching private
key.

Verify your QEMU user has access to these files, using the setup
instructions on this page.

Verify none of the systems are trying to restore, and that the snapshot
of suspend machine saved by libvirtd is not corrupted.
