.. contents::

**As of polkit 0.106 the .pkla format is no more, and these
configuration files must be written in Javascript.**

**See** `Authorization rules in
polkit <http://davidz25.blogspot.com/2012/06/authorization-rules-in-polkit.html>`__
**for more info, and**
`[1] <http://goldmann.pl/blog/2012/12/03/configuring-polkit-in-fedora-18-to-access-virt-manager/>`__
**for an example.**


Configuring management access via PolicyKit
===========================================

Several Linux distributions now use PolicyKit to manage access to the
libvirt virtualisation layer:

-  Fedora 12 onwards
-  Red Hat Enterprise Linux (RHEL) 6 onwards
-  CentOS 6 onwards
-  openSUSE 11.2 onwards


Advantages of PolicyKit
-----------------------

PolicyKit allows for more flexible, fine grained access control than
just granting access to a named unix group.

Organisations with complex requirements can extend PolicyKit to meet
their needs. For example, to give access to certain users between 9am
and 5pm Monday to Friday.

Extending PolicyKit in this way is beyond the scope of this page. For
that, you'll need to `consult the PolicyKit
documentation <http://www.freedesktop.org/wiki/Software/PolicyKit>`__.

This page will cover common configurations:

-  Management access based upon unix groups
-  Management access for individual unix users
-  Management access for both unix groups and individual unix users


openSUSE note
-------------

openSUSE versions prior to 11.4 are `affected by a
bug <https://bugzilla.novell.com/show_bug.cgi?id=544579>`__ that stops
group access (through PolicyKit) from working.

If you only need individual user access, the bug won't affect you. The
instructions on this page work.

If you do need group access, and you're using a version of openSUSE
prior to 11.4, then you'll need to change the openSUSE specific file:

::

    /var/lib/polkit-1/localauthority/10-vendor.d/org.libvirt.unix.manage.pkla

The contents of this need to be removed, leaving the file in place, but
empty. With that done, you can configure group access using the
instructions on this page. It has been tested, and is known to work.

Configuration for group access
------------------------------

**The information in this section is obsolete; see the top of this page
for more information.**

To give management access to members of a unix group, we only need to
create a PolicyKit `Local
Authority <http://hal.freedesktop.org/docs/polkit/pklocalauthority.8.html>`__
file.

This is a plain text file, generally placed in this directory:

::

    /etc/polkit-1/localauthority/50-local.d/

The name of the file is up to you, but needs to start with a two digit
number and end with *.pkla*. For example:

::

    /etc/polkit-1/localauthority/50-local.d/50-org.example-libvirt-remote-access.pkla

It's contents should be:

::

    [Remote libvirt SSH access]
    Identity=unix-group:group_name
    Action=org.libvirt.unix.manage
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes

Replace the **group_name** value above with the name of the unix group
needing management access. The **Remote libvirt SSH access** heading is
free form text, and can be anything you want.

For example:

::

    $ sudo cat /etc/polkit-1/localauthority/50-local.d/50-org.example-libvirt-remote-access.pkla
    [libvirt Management Access]
    Identity=unix-group:libvirt
    Action=org.libvirt.unix.manage
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes

This will allow any member of the unix group **libvirt** to manage the
virtualisation layer, including remotely through SSH.


Connection example
~~~~~~~~~~~~~~~~~~

We have two users in the libvirt group, named **someuser** and
**anotheruser**. Using the PolicyKit Local Authority file above, they
should now both have access:

::

    (on a server named host1)
    $ groups someuser anotheruser
    someuser : someuser tty libvirt
    anotheruser : anotheruser libvirt

::

    (from a computer other than host1)
    $ virsh -c qemu+ssh://someuser@host1/system
    Welcome to virsh, the virtualization interactive terminal.
    
    Type:  'help' for help with commands
           'quit' to quit
    
    virsh # hostname
    host1.libvirt.org

::

    (from a computer other than host1)
    $ virsh -c qemu+ssh://anotheruser@host1/system
    Welcome to virsh, the virtualization interactive terminal.
    
    Type:  'help' for help with commands
           'quit' to quit
    
    virsh # hostname
    host1.libvirt.org


Multiple groups
~~~~~~~~~~~~~~~

Multiple entries can be given on the *Identity* line. They need to be
separated by a semi-colon "**;**".

For example:

::

    [Remote libvirt SSH access]
    Identity=unix-group:group_name1;unix-group:group_name2;unix-group:group_name3
    Action=org.libvirt.unix.manage
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes


Configuration for individual users
----------------------------------

Configuring PolicyKit for individual user access is almost identical to
the group approach above. The difference is the **Identity** line in the
PolicyKit Local Authority file.

"**unix-user**" is used instead of "**unix-group**".

::

    [Remote libvirt SSH access]
    Identity=unix-user:user_name
    Action=org.libvirt.unix.manage
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes

Multiple user names can be given. They need to be separated by a
semi-colon "**;**".

::

    [Remote libvirt SSH access]
    Identity=unix-user:user_name1;unix-user:user_name2;unix-user:user_name3
    Action=org.libvirt.unix.manage
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes


Configuration for both group and user access
--------------------------------------------

Access can be granted to both groups and individual users at the same
time. This is done by using multiple entries on the **Identity** line of
the PolicyKit Local Authority file:

::

    [Remote libvirt SSH access]
    Identity=unix-group:group_name1;unix-user:user_name1;unix-user:user_name2;unix-group:group_name2
    Action=org.libvirt.unix.manage
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes


Further Reading
---------------

These pages may also provide useful further information:

-  The `SSH Setup entry page <SSHSetup.html>`__ contains information to
   set up remote access for other Linux distributions.
-  The `PolicyKit
   website <http://www.freedesktop.org/wiki/Software/polkit>`__ is the
   primary reference site for PolicyKit information.
