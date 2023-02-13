.. contents::

Google Summer of Code 2021
==========================

Introduction
------------

Like in the previous years, libvirt applied for `Google Summer of Code
2021 <http://g.co/gsoc>`__. The program timeline can be found
`here <https://summerofcode.withgoogle.com/how-it-works/#timeline>`__.
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

`Google Summer of Code FAQ <Google_Summer_of_Code_FAQ.html>`__

Project ideas
-------------

The list of project ideas can be found
`here <Google_Summer_of_Code_Ideas.html>`__.

Accepted projects
-----------------

libnbd / nbdcopy accleration using io_uring
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Add io_uring support to libnbd and use it to accelerate
nbdcopy

libnbd is a client library for accessing NBD servers. io_uring is a new
set of kernel APIs for efficient asynchronous I/O. nbdcopy is a tool for
copying between NBD servers which aims to be as fast and efficient as
possible. This project would investigate extending libnbd to support
io_uring (as an alternative to non-blocking send/recv), and then how to
use that to make nbdcopy work as fast as possible under Linux.

**Links:**

-  https://github.com/libguestfs/libnbd
-  https://libguestfs.org/nbdcopy.1.html
-  `io_uring introduction on LWN <https://lwn.net/Articles/776703/>`__

**Details:**

-  Skill level: advanced
-  Language: C
-  Suggested by: Richard W.M. Jones <rjones@redhat.com>
-  Mentor: Richard W.M. Jones <rjones@redhat.com>, Eric Blake
   <eblake@rehdat.com>

Test driver API coverage
~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Expand API coverage in the test driver

The test driver (as accessed via the test:/// URI scheme) is a fake virt
driver designed to let applications test against libvirt with fake data
and not have any effect on the host. As can be seen from the API
coverage report http://libvirt.org/hvsupport.html there are quite a few
APIs not yet implemented in the test driver. Ideally the test driver
would have 100% API coverage, and so the goal of the project is to
address gaps in the API coverage. The work is incremental, so does not
matter if not all APIs are implemented as part of the project - any
amount of expanded coverage is sufficient and useful.

**Links:**

-  API coverage http://libvirt.org/hvsupport.html
-  Test driver http://libvirt.org/drvtest.html

**Details:**

-  Skill level: beginner
-  Language: C
-  Suggested by: Daniel Berrange
-  Mentor: Michal Privoznik <mprivozn@redhat.com>, Martin Kletzander
   <mkletzan@redhat.com>
