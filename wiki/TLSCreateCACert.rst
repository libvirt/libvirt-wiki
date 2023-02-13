.. contents::

Steps to create a TLS Certificate Authority file for libvirt
============================================================

The very first step in setting up libvirt for TLS is creating a central
**Certificate Authority Certificate**, used for signing every other
certificate we create.

Follow these instructions to create this Certificate Authority
Certificate, then continue on with the next pages for the rest of the
libvirt TLS set up.


Full list of steps
------------------

#. `TLS Concepts in libvirt <TLSSetup.html>`__
#. Create the Certificate Authority Certificate - **this page**
#. `Create the Server Certificates <TLSCreateServerCerts.html>`__
#. `Create the Client Certificates <TLSCreateClientCerts.html>`__
#. `Configure the libvirt daemon <TLSDaemonConfiguration.html>`__
#. `Further References <TLSFurtherReferences.html>`__


Create a Certificate Authority Template file using a text editor
----------------------------------------------------------------

.. image:: images/Tls_text_editor_creates_template_file.png

This is a plain text file, with the following fields:

::

    cn = Name of your organization
    ca
    cert_signing_key

The **Name of your organization** value should be adjusted to suit your
organisation.

For example:

::

    # cat certificate_authority_template.info
    cn = libvirt.org
    ca
    cert_signing_key

Note that by default, the CA certificate created is valid for only 1
year.

This can be changed by including the field "*expiration_days*" in the
template file before generating the certificate:

::

    cn = Name of your organization
    ca
    cert_signing_key
    expiration_days = 700


Create a Certificate Authority Private Key file using certtool
--------------------------------------------------------------

Generate a private key, to be used with the Certificate Authority
Certificate.

.. image:: images/Tls_certtool_creates_ca_key.png

This key is used create your Certificate Authority Certificate, and to
sign the individual client and server TLS certificates.

::

    # (umask 277 && certtool --generate-privkey > certificate_authority_key.pem)
    Generating a 2048 bit RSA private key...

::

    # ls -la certificate_authority_key.pem
    -r--------. 1 root root 1675 Aug 25 04:37 certificate_authority_key.pem

**NOTE - The security of this private key is extremely important.**

If an unauthorised person obtains this key, it can be used with the CA
certificate to sign **any** other certificate, including certificates
they generate. Such bogus certificates could potentially allow them to
perform administrative commands on your virtualized guests.


Combine the template file with the private key file to create the Certificate Authority Certificate file
--------------------------------------------------------------------------------------------------------

.. image:: images/Tls_certtool_creates_ca_cert.png

Generate the CA Certificate using the template file, along with the CA
private key:

::

    # certtool --generate-self-signed \
               --template certificate_authority_template.info \
               --load-privkey certificate_authority_key.pem \
               --outfile certificate_authority_certificate.pem
    Generating a self signed certificate...
    X.509 Certificate Information:
            Version: 3
            Serial Number (hex): 4c741265
            Validity:
                    Not Before: Tue Aug 24 18:41:41 UTC 2010
                    Not After: Wed Aug 24 18:41:41 UTC 2011
            Subject: CN=libvirt.org
            Subject Public Key Algorithm: RSA
                    Modulus (bits 2048):
                            d8:77:8b:59:97:7f:cc:cf:ff:71:4b:e6:ec:b2:0c:90
                            3d:42:5b:1c:fc:4a:44:b8:25:78:3b:e0:58:17:ae:7c
                            a7:5c:08:98:6b:47:57:ba:b5:b4:89:73:8a:41:ec:f4
                            6b:10:ed:ee:3f:41:b7:89:33:4f:a4:37:a7:ee:3b:73
                            2b:9f:6f:26:75:99:62:90:48:84:be:e1:de:61:25:bd
                            cc:7c:92:eb:c1:da:69:a7:9a:ae:38:95:e7:7c:64:a0
                            d5:9f:e3:3a:35:ae:1c:da:1e:87:a4:62:36:37:e1:11
                            96:e9:98:16:b8:72:82:30:dc:92:ac:16:e1:0a:af:da
                            34:d8:d0:aa:73:f7:7e:05:53:bc:ef:c6:d7:cb:a5:97
                            ec:b5:af:f9:7c:34:cb:cf:e7:b0:ce:fa:bf:ca:60:ea
                            4f:91:56:6c:a9:4f:f8:4a:45:20:c6:35:1b:68:02:9b
                            cc:9a:5f:d0:8a:62:de:ba:00:37:74:63:b2:a2:2c:e5
                            30:6b:69:ae:b2:30:be:39:09:1b:bb:6d:37:1c:a2:70
                            07:42:72:0e:35:5f:1e:c9:27:86:e8:b6:03:24:2c:e1
                            30:c3:94:60:6b:8b:ac:fa:fc:79:d8:40:88:1e:91:7f
                            30:e8:7e:2d:c1:23:41:97:02:57:33:02:30:4f:3d:a3
                    Exponent (bits 24):
                            01:00:01
            Extensions:
                    Basic Constraints (critical):
                            Certificate Authority (CA): TRUE
                    Key Usage (critical):
                            Certificate signing.
                    Subject Key Identifier (not critical):
                            9512006c97dbdedbb3232a22cfea6b1341d72d76
    Other Information:
            Public Key Id:
                    9512006c97dbdedbb3232a22cfea6b1341d72d76
    
    
    Signing certificate...

::

    # ls -la certificate_authority_certificate.pem
    -rw-r--r--. 1 root root 1070 Aug 25 04:41 certificate_authority_certificate.pem

The name of the CA Certificate file is
**certificate_authority_certificate.pem**.

This file is not as security sensitive as the private key file. It will
be copied to each virtualisation host and administrative computer later
in the TLS setup process.

Note the period of time the certificate is valid for, displayed by the
range **Not Before** to **Not After**. If you included the
"*expiration_days*" field in your template file, please ensure the range
displayed is what you want.


The template file is no longer needed, so can be discarded
----------------------------------------------------------

.. image:: images/Tls_template_file_in_trash.png

::

    # rm certificate_authority_template.info


Moving the Certificate into place
---------------------------------

Now the Certificate has been created, it needs to be copied to both
virtualisation hosts and the administration desktop.

.. image:: images/Tls_ca_cert_needing_transfer_to_all_three_computers.png

The default location for the Certificate file on each host is
*/etc/pki/CA/cacert.pem*.

**Note - The security of the Private Key file is very important. It
should NOT be copied to the other computers along with the
Certificate.**


Ownership and permissions
~~~~~~~~~~~~~~~~~~~~~~~~~

Reasonable ownership and permissions for the certificate are for it be
owned by root (root:root), be world readable (444), and have an SELinux
label of "system_u:object_r:cert_t:s0". The SELinux label is only
relevant if the computer the certificate is installed on has SELinux
enabled.

You should also take into account your site security practices and
requirements, as they may require things to be done differently.


Transferring the certificate and setting it up
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the example below, we use the utility **scp** to transfer the
certificate to each virtualisation client. We then log in directly to
each virtualisation client to move the certificate into place and set
its permissions accordingly.

Transferring to host1
^^^^^^^^^^^^^^^^^^^^^

.. image:: images/Tls_ca_cert_transfer_to_host1.png

**Notice the filename is being changed in the transfer**

::

    # scp -p certificate_authority_certificate.pem someuser@host1:cacert.pem
    someuser@host1's password:
    certificate_authority_certificate.pem  100% 1164     1.4KB/s   00:00


Logged into host1
^^^^^^^^^^^^^^^^^

We move the certificate into place and set its permissions:

::

    # mv cacert.pem /etc/pki/CA

::

    # chmod 444 /etc/pki/CA/cacert.pem

If the server has SELinux enabled, we also update the SELinux label:

::

    # restorecon /etc/pki/CA/cacert.pem


Transferring the certificate to host2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: images/Tls_ca_cert_transfer_to_host2.png

**Notice the filename is being changed in the transfer**

::

    # scp -p certificate_authority_certificate.pem someuser@host2:cacert.pem
    someuser@host2's password:
    certificate_authority_certificate.pem  100% 1164     1.5KB/s   00:00


Logged into host2
^^^^^^^^^^^^^^^^^

We move the certificate into place and set its permissions:

::

    # mv cacert.pem /etc/pki/CA

::

    # chmod 444 /etc/pki/CA/cacert.pem

If the server has SELinux enabled, we also update the SELinux label:

::

    # restorecon /etc/pki/CA/cacert.pem


Transferring the files to the administrative desktop
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: images/Tls_ca_cert_transfer_to_admin_desktop.png

**Notice the filename is being changed in the transfer**

::

    # scp -p certificate_authority_certificate.pem someuser@admindesktop:cacert.pem
    someuser@admindesktop's password:
    certificate_authority_certificate.pem  100% 1164     1.5KB/s   00:00


Logged into the administrative desktop
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We move the certificate into place and set its permissions:

::

    # mv cacert.pem /etc/pki/CA

::

    # chmod 444 /etc/pki/CA/cacert.pem

If the desktop has SELinux enabled, we also update the SELinux label:

::

    # restorecon /etc/pki/CA/cacert.pem


The Certificate Authority Certificate setup part is now complete
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: images/Tls_ca_cert_on_all_three_computers.png
