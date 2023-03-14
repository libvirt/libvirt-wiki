.. contents::

Google Summer of Code 2016
==========================

Introduction
------------

Like in the previous years, libvirt is willing to apply for `Google
Summer of Code 2016 <http://g.co/gsoc>`__. This page serves to collect
ideas and informations for both students and mentors. But this year we
have decided to try applying as a separate organization, because the
number of libvirt applicants simply grew higher than qemu or kvm
combined. So it wouldn't be fair if we continued outsourcing program
management onto qemu project. Hopefully, this has no effect on students
nor mentors.

*NOTE*: The mentoring organizations have NOT been chosen yet, so please
take this list as non guaranteed yet.

Process
-------

Firstly, there were some important changes in
`rules <https://developers.google.com/open-source/gsoc/rules>`__. Be
sure to read them first. On the top of those we have some additional
guidelines as follows.

Each student can sign up for as many ideas listed here as they want.
With each candidate respective mentor will do an interview (usually
through IRC) consisting of a coding exercise and some follow up
questions to evaluate their ability to code. Some examples of exercises
from previous years can be found
`here <http://qemu-project.org/Google_Summer_of_Code_2016#Example_coding_exercise>`__.

Additional information
----------------------

This page is meant to extend qemu page dedicated to GSoC:
`[1] <http://qemu-project.org/Google_Summer_of_Code_2016>`__.

Contacts
--------

-  IRC (GSoC specific): #qemu-gsoc on irc.oftc.net
-  IRC (development and general): #virt on irc.oftc.net
-  `libvir-list <https://www.redhat.com/mailman/listinfo/libvir-list>`__

Please contact the respective mentor for the idea you are interested in.
For general questions feel free to contact me: Michal Prívozník (IRC
nick: mprivozn).

Project ideas
-------------

Here is the list of libvirt ideas. If an idea involving work in both
libvirt and qemu appears it should be listed here and on `qemu
list <http://qemu-project.org/Google_Summer_of_Code_2016>`__ too.

Introducing job control to the storage driver
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Implement abstract job control and use it to improve
storage driver.

Currently, libvirt support job cancellation and progress reporting on
domains. That is, if there's a long running job on a domain, e.g.
migration, libvirt reports how much data has already been transferred to
the destination and how much still needs to be transferred. However,
libvirt lacks such information reporting in storage area, to which
libvirt developers refer to as the storage driver. The aim is to report
progress on several storage tasks, like volume wiping, file allocation
an others.

-  Component: libvirt
-  Skill level: advanced
-  Language: C
-  Mentor: Pavel Hrdina <phrdina@redhat.com>, phrdina on IRC (#virt
   OFTC)
-  Suggested by: Michal Privoznik <mprivozn@redhat.com>

Making virsh more bash like
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** If you have ever used virsh, you certainly reached the
point where you stuggle with its user friendliness. Or unfriendliness I
should rather say. Virsh is missing a lot of bash functionality that
users consider natural: from automatic completion of object names,
through redirecting command outputs through piping commands together.
The aim would be to make these functions available in virsh and thus
make user experience better.

-  Component: libvirt
-  Skill level: Advanced
-  Language: C
-  Mentor: Michal Privoznik <mprivozn@redhat.com>, mprivozn on IRC
   (#virt OFTC)
-  Suggested by: Michal Privoznik <mprivozn@redhat.com>

Abstracting device address allocation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** There are many types of addresses that devices can have in
libvirt's XML description. Not all address types are properly assigned
and checked for duplicates. The goal of this is to have an abstract data
structure that would handle assigning all kinds of addresses, handle
duplicates, etc.

-  Component: libvirt
-  Skill level: intermediate
-  Language: C
-  Mentor: Martin Kletzander <mkletzan@redhat.com>
-  Suggested by: Martin Kletzander <mkletzan@redhat.com>

libvirt bindings for node.js
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** There are few libvirt bindings for node.js available via
npm. However none of them expose all libvirt APIs. That is mainly
because they are manually written and not automatically generated. The
aim is to utilize same information that python bindings do and
automatically generate node libvirt bindings based on that information
so that they don't need to be modified for every new API.

-  Component: libvirt
-  Skill level: advanced
-  Language: C, C++, node-gyp, scripting language of your choice
-  Mentor: Martin Kletzander <mkletzan@redhat.com>
-  Suggested by: Martin Kletzander <mkletzan@redhat.com>

**Links:**

-  node-gyp: https://github.com/nodejs/node-gyp

QEMU command line generator XML fuzzing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Using fuzzing techniques to generate unusual XML to feed to
QEMU command line generator

There are a huge number of potential variants of XML documents that can
be fed into libvirt. Only a subset of these are valid for generating
QEMU command lines. It is likely that there are cases where omitting
certain attributes or XML elements will cause the QEMU command line
generator to crash. Using fuzzing techniques to generate unusual XML
documents which could then be fed through the test suite may identify
crashes.

**Details:**

-  Component: libvirt
-  Skill level: intermediate
-  Language: C
-  Mentor: Martin Kletzander <mkletzan@redhat.com>
-  Suggested by: Daniel Berrange

Asynchronous lifecycle events for storage objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Implement asynchronous lifecycle events for libvirt's
storage APIs. Lifecycle events allow apps to get notifications about
object creation, deletion, and state change with out having to poll
libvirt at regular intervals.

There are already lifecycle event APIs for domains/VMs and network
objects, and generic infrastructure handling a lot of the heavy lifting,
so there's plenty of examples to follow to implement much of this.

Time permitting, there's lots of additional work that can be done:

-  Add support for these events in virt-manager UI tool. In fact this is
   probably the best way to actually test the APIs
-  Extend libvirt (and virt-manager) with async events support for
   nodedev objects (physical host devices). This will likely be a simple
   task after the storage APIs are added.
-  Investigate adding event support for interface objects (host network
   devices). Implementing this for libvirt's udev driver is probably
   straightforward, but the netcf driver may be more complicated.

**Links:**

-  Upstream RFE bug: https://bugzilla.redhat.com/show_bug.cgi?id=636027
-  Mailing list posting for the network events support:
   https://www.redhat.com/archives/libvir-list/2013-December/msg00085.html

**Details:**

-  Skill level: intermediate
-  Language: C, python
-  Mentor: Cole Robinson <crobinso@redhat.com>
-  Suggested by: Cole Robinson <crobinso@redhat.com>

Conversion to and from OCI-formatted containers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Container formats is being standardized by `Open Container
Initiative <https://www.opencontainers.org>`__. libvirt-lxc support for
them would be awesome.

virsh has domxml-from-native and domxml-to-native to help converting
between libvirt configuration and another one. In the libvirt-lxc driver
the domxml-from-native command already supports converting from
`lxc <https://linuxcontainers.org/>`__ (yes, naming is confusing). The
goal is not only to implement it also for `OCI
format <https://github.com/opencontainers/specs>`__ but also to
implement export to OCI format.

Some code pointers to get started:

-  ``src/lxc/lxc_native.c``  is the place where the lxc import is implemented.
-  The starting point in the lxc driver is the  ``connectDomainXMLFromNative``
   function pointer.
-  To add export capabilities, the  ``connectDomainXMLToNative`` will have to
   be defined.

Note that there may be tricky things to handle, like disk images
conversion to a rootfs, but this project aims at implementing the simple
cases first. If time permits, the corner cases could be handled as well.

**Details:**

-  Component: libvirt
-  Skill level: intermediate
-  Language: C
-  Mentor: Cédric Bosdonnat <cbosdonnat@suse.com>
-  Suggested by: Cédric Bosdonnat

Introduce libiscsi pool
~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Currently there is an iSCSI storage pool in libvirt.
However, all the management communication is done by spawning iscsiadm
binary. The aim of this project would be to rework the storage driver
backend so that is uses libiscsi directly.

Libvirt has many drivers to address various parts of virtualization
infrastructure. For example, it has so called domain driver which is
responsible for managing virtual machines, network driver for providing
connectivity to virtual machines and it has storage driver for managing
storage pools and volumes. The enumeration is not complete, of course.
The aim of the storage driver is to provide units of storage to virtual
machines. In order to achieve that goal, the storage driver offers
several APIs for management applications to use, e.g. creating a pool of
volumes, creating a single volume within that pool and so on. Because of
the nature of storage world, the driver has many backends which
implement the APIs based on underlying storage technology used. Thus
there's an LVM backend for managing LVs, FS backend for working with
files and directories, and there's iSCSI backend too. This backend,
however, uses iscsiadm binary to execute the desired operation. The
binary can be spawned multiple times during single execution of an API.
This is suboptimal esp. if there exists a better solution - libiscsi.
This should be 1:1 replacement, but that's only an uneducated guess.
Student working on this project should explore the possibilities of
doing the replacement and implement it as well.

**Links:**

-  http://libvirt.org/storage.html
-  https://github.com/sahlberg/libiscsi

**Details:**

-  Skill level: intermediate
-  Language: C
-  Mentor: Pavel Hrdina <phrdina@redhat.com>
-  Suggested by: Jiri Denemark <jdenemar@redhat.com>

Enhancing libvirt-designer
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** The project is in its very early stage of life. The
libvirt-designer tries to ease generation of libvirt XML with coworking
with libosinfo project. See
https://www.redhat.com/archives/libvir-list/2012-September/msg00325.html
for a more detailed description.

During Summer of Code 2015, new API was added to make it possible to
configure more VM details. This project would be a follow-up on that
work, this could be :

-  switch GNOME Boxes to using libvirt-designer instead of its own code
   when creating a VM. This involves work in Vala for the Boxes side,
   and in C on the libvirt-designer side
-  improve libvirt-designer to make it appropriate for use by
   virt-manager/virt-install (written in Python)
-  work on both libvirt-designer and libvirt-builder, with the aim of
   creating a command-line tool to automatically create and install a VM
   (through libosinfo).

Contact me and we can refine these potential tasks and find something
suitable.

**Details:**

-  Skill level: beginner
-  Language: C, (potentially Python, Vala)
-  Mentor: Christophe Fergeau <cfergeau@redhat.com>, teuf on IRC
   (#qemu-gsoc OFTC)
-  Suggested by: Christophe Fergeau <cfergeau@redhat.com>

Integrate secrets driver with DEO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Provide encryption of secrets stored by libvirt, optionally
using DEO to unlock the master key

The libvirt secrets driver currently stores secrets in base64 plain text
files with the recommendation that the filesystem be backed by a LUKS
encrypted block volume. This provides protection against offline
compromise, but is far from ideal. Libvirt should have its own master
AES key that it uses to encrypt the individual secrets files, instead of
storing them in base64.

Of course there is a chicken & egg problem of how to store the master
AES key itself. For this we should have the ability to integrate with
DEO to allow the master key to be password protected on local node,
having DEO decrypt it at libvirtd startup.

**Links:**

-  https://blog-ftweedal.rhcloud.com/2015/09/automatic-decryption-of-tls-private-keys-with-deo/
-  https://github.com/npmccallum/deo

**Details:**

-  Skill level: intermediate
-  Language: C
-  Mentor: Email address and IRC nick
-  Suggested by: Daniel Berrange

Template
--------

::

   === TITLE ===
    
    '''Summary:''' Short description of the project
    
    Detailed description of the project.
    
    '''Links:'''
    * Wiki links to relevant material
    * External links to mailing lists or web sites
    
    '''Details:'''
    * Skill level: beginner or intermediate or advanced
    * Language: C
    * Mentor: Email address and IRC nick
    * Suggested by: Person who suggested the idea
