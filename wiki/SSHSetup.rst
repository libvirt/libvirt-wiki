.. contents::

How to configure management access to libvirt through SSH
=========================================================

Setting up user access, to manage virtualisation servers via SSH, is
fairly simple.

The first part to configure, "**1**" in the diagram below, is SSH access
for the user. SSH access is enabled by default, or very simple to
enable, for all major Linux distributions, so we won't cover it here.

The second part, "**2**" in the diagram, is configuring access control
to the libvirt daemon management socket
(*/var/run/libvirt/libvirt-sock*). This is done a bit differently by
each Linux distribution.

.. image:: images/Ssh_libvirt_socket_access_control.png


Fedora 12 onwards, and RHEL/CentOS 6 onwards
--------------------------------------------

Fedora 12 and RHEL/CentOS 6 onwards use PolicyKit for management access
to libvirt.

This is covered in depth in `another page
here <SSHPolicyKitSetup.html>`__.


Previous Fedora and RHEL/CentOS releases
----------------------------------------

For Fedora versions prior to 12, and RHEL/CentOS versions prior to 6,
management access to libvirt is controlled through membership to a unix
group.

This can be any unix group on the host system, but is generally called
"**libvirt**".

The steps are reasonably easy, and need to be performed on the
virtualisation host:

1. Create the unix group
^^^^^^^^^^^^^^^^^^^^^^^^

::

    $ sudo groupadd libvirt

2. Update the libvirt configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the **/etc/libvirt/libvirtd.conf** file, uncomment these two lines:

::

    #unix_sock_group = "libvirt"

::

    #unix_sock_rw_perms = "0770"

so they read:

::

    unix_sock_group = "libvirt"

::

    unix_sock_rw_perms = "0770"

then restart the libvirt daemon:

::

    $ sudo service libvirtd restart
    Stopping libvirtd daemon:                                  [  OK  ]
    Starting libvirtd daemon:                                  [  OK  ]

3. Manage group membership
^^^^^^^^^^^^^^^^^^^^^^^^^^

Add the desired users to this unix group:

::

    $ sudo usermod -G libvirt -a username1

::

    $ sudo usermod -G libvirt -a username2

They now have management access to libvirt.

Follow the steps at the bottom of this page to verify it works.


Ubuntu 10.04 Server and Desktop
-------------------------------

In Ubuntu, access to the management layer is controlled through
membership to the **libvirtd** unix group.

To enable libvirt management access for a user, add them to this group
on the virtualisation host server:

::

    $ sudo usermod -G libvirtd -a username

They will then have access to manage libvirt remotely.

Follow the steps at the bottom of this page to verify it works.


openSUSE 11.2 onwards
---------------------

openSUSE 11.2 onwards uses PolicyKit for management access to libvirt.

This is covered in depth in `another page
here <SSHPolicyKitSetup.html>`__.


Slackware
---------

Slackware has PolicyKit package, however its use is unverified so far.

Group access is pretty much straightforward under Slackware.

Add group 'libvirt' as a system group:

::

    # groupadd -r libvirt

Then edit '/etc/libvirt/libvirtd.conf' and uncomment following lines:

::

    unix_sock_group = "libvirt"

::

    unix_sock_rw_perms = "0770"

Modify user(s) which should have permission to manage libvirt and
Guests:

::

    # usermod -G libvirtd -a username

Don't forget to restart libvirtd and test connection.


Verify it works
---------------

To verify the configuration is correct, use a connection string with the
following format to test it. Replace **username** with the name of the
user account you want to connect as:

::

    $ virsh -c qemu+ssh://username@host1.example.org/system
    Welcome to virsh, the virtualization interactive terminal.
    
    Type:  'help' for help with commands
           'quit' to quit
    
    virsh # hostname
    host1.libvirt.org

This may prompt for a password, depending upon the SSH configuration in
place. (ie whether public keys are set up, etc)


Further References
------------------

These pages may also provide useful further information:

-  `The PolicyKit
   website <http://www.freedesktop.org/wiki/Software/polkit>`__
-  `The Ubuntu 10.04 Server Guide entry for
   libvirt <https://help.ubuntu.com/10.04/serverguide/C/libvirt.html>`__
