.. contents::

Google Summer of Code 2019
==========================

Introduction
------------

Like in the previous years, libvirt applied for `Google Summer of Code
2019 <http://g.co/gsoc>`__. The program timeline can be found
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

Some of the frequently asked questions among with answers can be found
`here <Google_Summer_of_Code_FAQ.html>`__.

Project ideas
-------------

The list of project ideas can be found
`here <Google_Summer_of_Code_Ideas.html>`__.

Accepted projects
-----------------

Rust bindings for libguestfs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Create Rust bindings for libguestfs

libguestfs is a library with tools to manipulate disk images. The C
library has already lots of bindings, such as Python, Perl, Ruby, OCaml,
etc.

The goal of this project is to add also bindings for Rust, extending the
internal OCaml tool that generates most of the code needed for each
binding, adding the manual bits needed for the Rust binding, and adding
tests modelled after the ones already available for other bindings.

**Links:**

-  http://libguestfs.org
-  https://github.com/libguestfs/libguestfs

**Details:**

-  Skill level: advanced
-  Language: C, OCaml, Rust
-  Mentor: Pino Toscano <ptoscano@redhat.com>
-  Suggested by: Pino Toscano <ptoscano@redhat.com>
