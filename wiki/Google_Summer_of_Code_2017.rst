.. contents::

Google Summer of Code 2017
==========================

Introduction
------------

Like in the previous years, libvirt is willing to apply for `Google
Summer of Code 2017 <http://g.co/gsoc>`__. The program has been
`announced <http://opensource.googleblog.com/2016/10/announcing-google-code-in-2016-and.html>`__.
This page lists accepted projects only. For the list of ideas go
`here <Google_Summer_of_Code_Ideas.html>`__.

Contacts
--------

-  IRC (GSoC specific): #qemu-gsoc on irc.oftc.net
-  IRC (development and general): #virt on irc.oftc.net
-  `libvir-list <https://www.redhat.com/mailman/listinfo/libvir-list>`__

Please contact the respective mentor for the idea you are interested in.
For general questions feel free to contact me: Michal Prívozník (IRC
nick: mprivozn).

FAQ
---

Some of the frequently asked questions among with answers can be found
`here <Google_Summer_of_Code_FAQ.html>`__.

Project ideas
-------------

The list of project ideas can be found
`here <Google_Summer_of_Code_Ideas.html>`__.

Accepted projects
-----------------

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
-  Mentor:
-  Suggested by: Daniel Berrange

**Unfinished**

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

-  ``src/lxc/lxc_native.c``
   is the place where the lxc import is implemented.
-  The starting point in the lxc driver is the ``connectDomainXMLFromNative``
   function pointer.
-  To add export capabilities, the
   ``connectDomainXMLToNative``
   will have to be defined.

Note that there may be tricky things to handle, like disk images
conversion to a rootfs, but this project aims at implementing the simple
cases first. If time permits, the corner cases could be handled as well.

**Details:**

-  Component: libvirt
-  Skill level: intermediate
-  Language: C
-  Mentor: Cédric Bosdonnat <cbosdonnat@suse.com>
-  Suggested by: Cédric Bosdonnat

**Unfinished**

Ease creation of containers
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Creating containers for libvirt LXC driver is a pain since
there is no simple way to setup the root file system. A new workflow
around container images is presented in
http://bosdonnat.fr/system-container-images.html. This project is about
moving the *virt-bootstrap* tool further, that is add more features to
it and integrate it with *virt-manager* and *virt-install* for a smooth
user experience.

So far the virt-bootstrap tool is in a rather primitive state. It's
sources should be cleaned up to be ready for merge in virt-manager
sources. The virt-manager UI will have to be modified to fully use this
new tool.

The virt-bootstrap tool would need the following features to be added:

-  Handle more sources format (virt-builder, Live DVD isos...)
-  Provide several output formats: folder (done), qcow2 with backing
   chains

The project will also study how to produce a user-namespace-ready root
file system.

**Links:**

-  virt-bootstrap current code: https://github.com/cbosdo/virt-bootstrap
-  virt-manager git repository:
   https://github.com/virt-manager/virt-manager

**Details:**

-  Skill level: beginner
-  Language: Python
-  Mentor: Cédric Bosdonnat <cbosdonnat@suse.com>, cbosdonnat on IRC
   (#virt OFTC)
-  Suggested by: Cédric Bosdonnat <cbosdonnat@suse.com>

**Succeeded**
