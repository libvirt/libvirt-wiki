.. contents::

Creating Transport Layer Security Server Certificates for libvirt
=================================================================

In our **example scenario** we have two Virtualisation Servers being set
up for TLS communication. We also have the Certificate Authority
Certificate and its private key created in the `previous
step <TLSCreateCACert.html>`__.

.. image:: images/Tls_small_two_hosts.png

In this step we create the TLS **Server Certificates** our hosts need,
then move them into place on the hosts.

When these Server Certificates are in place, and with libvirt properly
configured, TLS clients will be able to communicate with them.


Create the Server Certificates
------------------------------

This can be done wherever you have both the **Certificate Authority
Certificate** file, and its private key.

We use the utility **certtool**, from the **gnutls-utils** package for
many parts of this.

.. image:: images/Tls_ca_certificate.png
.. image:: images/Tls_ca_private_key.png
.. image:: images/Tls_certtool.png


Create the Server Certificate Template files using a text editor
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: images/Tls_text_editor_creates_template_files.png

These are plain text files, one for each virtualisation host server,
containing the following fields:

::

    organization = Name of your organization
    cn = Host Name
    tls_www_server
    encryption_key
    signing_key

The **Name of your organization** field should be adjusted to suit your
organization, and the **Host Name** field must be changed to match the
host name of the virtualisation host the template is for.

For our example scenario, this gives:

::

    # cat host1_server_template.info
    organization = libvirt.org
    cn = host1
    tls_www_server
    encryption_key
    signing_key

::

    # cat host2_server_template.info 
    organization = libvirt.org
    cn = host2
    tls_www_server
    encryption_key
    signing_key

::

    # ls -al *server_template.info
    -rw-r--r--. 1 root root 82 Aug 25 13:26 host1_server_template.info
    -rw-r--r--. 1 root root 82 Aug 25 13:26 host2_server_template.info


Create the Server Certificate Private Key files using certtool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generate the private key files, to be used with the Server Certificates.

.. image:: images/Tls_certtool_creates_server_keys.png

These keys are used to create the TLS Server Certificates, and by each
virtualisation host when the virtualisation system starts up.

We create a unique private key per virtualisation host, also ensuring
the permissions only allow very restricted access to these files:

::

    # (umask 277 && certtool --generate-privkey > host1_server_key.pem)
    Generating a 2048 bit RSA private key...

::

    # (umask 277 && certtool --generate-privkey > host2_server_key.pem)
    Generating a 2048 bit RSA private key...

::

    # ls -al *_server_key.pem
    -r--------. 1 root root 1675 Aug 25 13:33 host1_server_key.pem
    -r--------. 1 root root 1675 Aug 25 13:33 host2_server_key.pem

**NOTE - The security of these private key files is very important.**

If an unauthorised person obtains a server private key file, they could
use it with a Server Certificate to impersonate one of your
virtualisation hosts. Use good unix security to restrict access to the
key files appropriately.


Combine the template files with the private key files, to create the Server Certificate files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: images/Tls_certtool_creates_server_certs.png

We generate the Server Certificates using the template files, along with
the corresponding private key files. Also, the **Certificate Authority
Certificate** file is added along with its private key, to ensure each
new server certificate is signed properly.

For our two virtualisation hosts, this means:

::

    # certtool --generate-certificate \
               --template host1_server_template.info \
               --load-privkey host1_server_key.pem \
               --load-ca-certificate certificate_authority_certificate.pem \
               --load-ca-privkey certificate_authority_key.pem \
               --outfile host1_server_certificate.pem
    Generating a signed certificate...
    X.509 Certificate Information:
            Version: 3
            Serial Number (hex): 4c749699
            Validity:
                    Not Before: Wed Aug 25 04:05:45 UTC 2010
                    Not After: Thu Aug 25 04:05:45 UTC 2011
            Subject: O=libvirt.org,CN=host1
            Subject Public Key Algorithm: RSA
                    Modulus (bits 2048):
                            da:75:bd:37:ac:30:4a:6c:fe:8c:8b:d9:d8:f4:94:80
                            5e:48:68:31:e7:de:85:d3:d7:54:13:da:8d:d1:f1:21
                            3b:d9:f1:eb:86:0a:4e:59:39:2c:53:ee:3e:81:29:7d
                            e5:83:6b:bd:e9:86:93:7c:ce:a4:5b:37:b3:b6:6d:7a
                            7e:60:14:99:4a:23:18:e3:0f:ff:58:68:09:08:f3:0f
                            ca:76:0d:bc:76:e0:8b:38:93:42:f6:8f:b9:d6:4c:21
                            2a:0e:d9:cd:1c:33:04:36:a3:eb:97:6b:84:bc:88:16
                            8e:0b:80:46:ed:ce:c5:56:fe:3b:f7:32:a7:91:c3:1f
                            86:b7:49:77:7b:35:e7:f4:a6:7a:3c:c9:0d:60:fd:b2
                            b7:e7:d9:02:02:a5:ef:e9:0c:43:14:15:3b:ef:96:52
                            a6:f9:ca:d5:fc:c0:fb:a0:5a:1f:69:6f:ce:66:0c:fc
                            d5:42:86:85:7e:ab:24:15:3e:5b:a3:85:a1:3b:41:ec
                            11:7c:6c:3d:14:8b:a5:14:7a:7b:79:15:a0:f6:79:2f
                            30:a9:a1:6e:8c:5e:3a:97:af:8e:7c:c0:a4:1f:2a:32
                            8b:4f:6b:53:e4:f0:28:48:db:2b:4c:0d:94:95:56:f0
                            53:e8:0f:ad:1a:a5:cf:35:e4:e3:0c:a6:ba:85:8a:33
                    Exponent (bits 24):
                            01:00:01
            Extensions:
                    Basic Constraints (critical):
                            Certificate Authority (CA): FALSE
                    Key Purpose (not critical):
                            TLS WWW Server.
                    Key Usage (critical):
                            Digital signature.
                            Key encipherment.
                    Subject Key Identifier (not critical):
                            6ddcfcc00a5ffe064a756d2623ea90fa20ff782c
                    Authority Key Identifier (not critical):
                            9512006c97dbdedbb3232a22cfea6b1341d72d76
    Other Information:
            Public Key Id:
                    6ddcfcc00a5ffe064a756d2623ea90fa20ff782c
    
    
    
    Signing certificate...

This will have created the TLS Server Certificate file,
**host1_server_certificate.pem**, for host1:

::

    # ls -la host1_server_certificate.pem
    -rw-r--r--. 1 root root 1164 Aug 25 14:05 host1_server_certificate.pem

We do the same thing for host2, after adjusting the input and output
files names:

::

    # certtool --generate-certificate \
               --template host2_server_template.info \
               --load-privkey host2_server_key.pem \
               --load-ca-certificate certificate_authority_certificate.pem \
               --load-ca-privkey certificate_authority_key.pem \
               --outfile host2_server_certificate.pem
    Generating a signed certificate...
    X.509 Certificate Information:
            Version: 3
            Serial Number (hex): 4c7496d0
            Validity:
                    Not Before: Wed Aug 25 04:06:40 UTC 2010
                    Not After: Thu Aug 25 04:06:40 UTC 2011
            Subject: O=libvirt.org,CN=host2
            Subject Public Key Algorithm: RSA
                    Modulus (bits 2048):
                            d3:5d:8f:b6:6f:12:22:ac:4a:e8:d8:37:f6:f7:63:3d
                            47:26:c6:0d:10:be:ad:12:52:22:26:9f:2f:12:29:57
                            b8:bf:2b:97:70:88:1d:12:e5:df:05:65:8b:ee:a6:18
                            30:60:2d:70:bc:dd:99:bf:61:42:9e:55:9c:a1:a7:75
                            b1:02:68:52:22:57:e0:d6:e4:8b:4b:26:77:56:36:b8
                            9f:b8:fe:d8:cd:af:04:c2:17:76:9c:f3:48:19:45:63
                            b5:8d:21:a3:8e:3d:d5:5b:63:9e:3e:e9:86:51:2a:ad
                            18:27:a1:e5:09:73:7a:c5:34:14:8a:d7:c6:c6:a2:d8
                            91:96:36:c3:87:3e:45:56:a5:bb:77:d4:10:04:d0:68
                            68:f8:60:e2:d4:4f:c6:27:cf:e5:e9:47:79:11:c3:95
                            6d:53:f2:dd:43:c1:ec:80:ac:ac:0c:d9:3d:94:54:41
                            60:03:01:07:b2:e8:c7:4c:6b:52:c1:38:d1:6d:0a:70
                            86:e9:be:64:21:73:b8:51:a3:2e:01:9b:7e:fd:9d:37
                            5c:ad:47:8e:c3:bc:1f:a2:35:bb:84:f3:98:d3:9c:c2
                            9a:57:1c:c2:be:84:fe:3e:d1:af:25:21:6e:67:60:bb
                            e3:29:0f:d0:70:d7:b0:f7:8e:ed:7d:e1:b3:ad:1d:3b
                    Exponent (bits 24):
                            01:00:01
            Extensions:
                    Basic Constraints (critical):
                            Certificate Authority (CA): FALSE
                    Key Purpose (not critical):
                            TLS WWW Server.
                    Key Usage (critical):
                            Digital signature.
                            Key encipherment.
                    Subject Key Identifier (not critical):
                            3df1e4ef69e23976a829700f28f5cbb1685364d9
                    Authority Key Identifier (not critical):
                            9512006c97dbdedbb3232a22cfea6b1341d72d76
    Other Information:
            Public Key Id:
                    3df1e4ef69e23976a829700f28f5cbb1685364d9
    
    
    
    Signing certificate...

This will have created the TLS Server Certificate file,
**host2_server_certificate.pem**, for host2:

::

    # ls -la *server_certificate.pem
    -rw-r--r--. 1 root root 1164 Aug 25 14:05 host1_server_certificate.pem
    -rw-r--r--. 1 root root 1164 Aug 25 14:06 host2_server_certificate.pem


The template files are no longer needed, so can be discarded
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: images/Tls_template_files_in_trash.png

::

   # rm host1_server_template.info host2_server_template.info


Moving the Certificates into place
----------------------------------

Now the Server Certificates have been created, it is time to move them
into place on the hosts.

.. image:: images/Tls_server_certs_needing_transfer.png

The default location the libvirt daemon looks for the Server Certificate
file is */etc/pki/libvirt/servercert.pem*. The private key to match this
needs to be in */etc/pki/libvirt/private/serverkey.pem*. You will likely
have to create the directories to hold these files.

The private key file should be kept secure, with only the root user able
to access it in any way. The server certificate file is not as
sensitive.

Ownership, Permissions, and SELinux labels
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reasonable ownership and permissions for these two files, and the
directories containing them, are:

::

    Directory: /etc/pki/libvirt/
    Ownership: root:qemu
    Permissions: u=rwx,g=rx,o=rx (755)
    SELinux label: system_u:object_r:cert_t:s0

::

    Server Certificate path: /etc/pki/libvirt/servercert.pem
    Ownership: root:qemu
    Permissions: u=r,g=r,o= (440)
    SELinux label: system_u:object_r:cert_t:s0

::

    Directory: /etc/pki/libvirt/private/
    Ownership: root:qemu
    Permissions: u=rwx,g=rx,o= (750)
    SELinux label: system_u:object_r:cert_t:s0

::

    Private Key for Server Certificate: /etc/pki/libvirt/private/serverkey.pem
    Ownership: root:qemu
    Permissions: u=r,g=r,o= (440)
    SELinux label: system_u:object_r:cert_t:s0

The SELinux labels are only relevant if your servers have SELinux
enabled. They can be ignored if SELinux is disabled.

Also take into account your site security practices and requirements, as
they may require things to be done differently.


Transferring the files and setting them up
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the example below, we use the utility **scp** to transfer the
certificate and key to each host. We then log in directly to each host
to move the files into place and set their permissions accordingly.

Transferring the files to host1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: images/Tls_server_cert_transfer_to_host1.png

**Notice the filenames are being changed in the transfer**

::

    # scp -p host1_server_certificate.pem someuser@host1:servercert.pem
    someuser@host1's password:
    host1_server_certificate.pem           100% 1164     1.1KB/s   00:00

::

    # scp -p host1_server_key.pem someuser@host1:serverkey.pem
    someuser@host1's password:
    host1_server_key.pem                   100% 1675     1.6KB/s   00:00


Logged into host1
^^^^^^^^^^^^^^^^^

First we create the directories and set their permissions:

::

    # mkdir -p /etc/pki/libvirt/private

::

    # chmod 755 /etc/pki/libvirt

::

    # chmod 750 /etc/pki/libvirt/private

Then we move the files into place and set their permissions:

::

    # mv servercert.pem /etc/pki/libvirt

::

    # mv serverkey.pem /etc/pki/libvirt/private

::

    # chgrp qemu /etc/pki/libvirt \
                 /etc/pki/libvirt/servercert.pem \
                 /etc/pki/libvirt/private \
                 /etc/pki/libvirt/private/serverkey.pem

::

    # chmod 440 /etc/pki/libvirt/servercert.pem \
                /etc/pki/libvirt/private/serverkey.pem

If the server has SELinux enabled, we also update the SELinux labels:

::

    # restorecon -R /etc/pki/libvirt \
                    /etc/pki/libvirt/private

::

    $ ls -laZ /etc/pki/libvirt
    /etc/pki/libvirt:
    total 20
    drwxr-xr-x  3 root qemu system_u:object_r:cert_t:s0 .
    drwxr-xr-x. 8 root root system_u:object_r:cert_t:s0 ..
    drwxr-x---  2 root qemu system_u:object_r:cert_t:s0 private
    -r--r-----. 1 root qemu system_u:object_r:cert_t:s0 servercert.pem

::

    $ ls -laZ /etc/pki/libvirt/private/  
    /etc/pki/libvirt/private/:
    total 16
    drwxr-x---  2 root qemu system_u:object_r:cert_t:s0
    drwxr-xr-x  3 root qemu system_u:object_r:cert_t:s0 ..
    -r--r-----. 1 root qemu system_u:object_r:cert_t:s0 serverkey.pem


Transferring the files to host2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: images/Tls_server_cert_transfer_to_host2.png

**Notice the filenames are being changed in the transfer**

::

    # scp -p host2_server_certificate.pem someuser@host2:servercert.pem
    someuser@host2's password:
    host2_server_certificate.pem           100% 1164     1.2KB/s   00:00

::

    # scp -p host2_server_key.pem someuser@host2:serverkey.pem
    someuser@host2's password:
    host2_server_key.pem                   100% 1675     1.8KB/s   00:00


Logged into host2
^^^^^^^^^^^^^^^^^

First we create the directories and set their permissions:

::

    $ sudo mkdir -p /etc/pki/libvirt/private

::

    $ sudo chmod 755 /etc/pki/libvirt

::

    $ sudo chmod 750 /etc/pki/libvirt/private

Then we move the files into place and set their permissions:

::

    # mv servercert.pem /etc/pki/libvirt

::

    # mv serverkey.pem /etc/pki/libvirt/private

::

    # chgrp qemu /etc/pki/libvirt \
                 /etc/pki/libvirt/servercert.pem \
                 /etc/pki/libvirt/private \
                 /etc/pki/libvirt/private/serverkey.pem

::

    # chmod 440 /etc/pki/libvirt/servercert.pem \
                /etc/pki/libvirt/private/serverkey.pem

If the server has SELinux enabled, we also update the SELinux labels:

::

    # restorecon -R /etc/pki/libvirt \
                    /etc/pki/libvirt/private

::

    $ ls -laZ /etc/pki/libvirt
    /etc/pki/libvirt:
    total 20
    drwxr-xr-x  3 root qemu system_u:object_r:cert_t:s0 .
    drwxr-xr-x. 8 root root system_u:object_r:cert_t:s0 ..
    drwxr-x---  2 root qemu system_u:object_r:cert_t:s0 private
    -r--r-----. 1 root qemu system_u:object_r:cert_t:s0 servercert.pem

::

    $ ls -laZ /etc/pki/libvirt/private/  
    /etc/pki/libvirt/private/:
    total 16
    drwxr-x---  2 root qemu system_u:object_r:cert_t:s0 .
    drwxr-xr-x  3 root qemu system_u:object_r:cert_t:s0 ..
    -r--r-----. 1 root qemu system_u:object_r:cert_t:s0 serverkey.pem


The Server Certificate setup step is now complete
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: images/Tls_server_cert_on_both_hosts.png

Overriding the default locations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you need the Server Certificate file and its public key to be in a
different location on the host, you can configure this in the
*/etc/libvirt/libvirtd.conf* configuration file.

The two settings are:

::

    cert_file = "Full path to new Server Certificate location"
    key_file = "Full path to new Server Certificate Private Key location"

The paths should be enclosed in double quotes.

For example:

::

    cert_file = "/opt/libvirt/etc/pki/libvirt/servercert.pem"
    key_file = "/opt/libvirt/etc/pki/libvirt/private/serverkey.pem"


Full list of steps
------------------

#. `TLS Concepts in libvirt <TLSSetup.html>`__
#. `Create the Certificate Authority Certificate <TLSCreateCACert.html>`__
#. Create the Server Certificates - **this page**
#. `Create the Client Certificates <TLSCreateClientCerts.html>`__
#. `Configure the libvirt daemon <TLSDaemonConfiguration.html>`__
#. `Further References <TLSFurtherReferences.html>`__
