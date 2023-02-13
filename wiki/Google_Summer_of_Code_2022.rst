.. contents::

Google Summer of Code 2022
==========================

Introduction
------------

Like in the previous years, libvirt applied for `Google Summer of Code
2022 <http://g.co/gsoc>`__. The program timeline can be found
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

Extend reported statistics on given guests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Extend reported statistics

QEMU is gaining introspectable statistics. This is an RFE for follow up
work/integration in libvirt. The expected output is more statistics
reported, for instance virConnectGetAllDomainStats() and
virDomainListGetStats() would report more statistics on given guests.

**Details:**

-  Component: libvirt, QEMU
-  Skill level: intermediate
-  Expected size: 350 hours
-  Language: C
-  Mentor: Martin Kletzander <mkletzan@redhat.com>, Paolo Bonzini
   <pbonzini@redhat.com>
-  Suggested by: Paolo Bonzini <pbonzini@redhat.com>

libvirt-CI: Support for container executions in libvirt's lcitool using a container library binding
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Libvirt has a tool called lcitool which is used for managing the CI need
for libvirt and related projects. Improvements will be made to the
system toward extending the container functionality to build a container
locally, and execute workloads in the container. This will give libvirt
developers and maintainers the ability to debug in a project specific
manner among other use cases. The goal of the project is to use
podman-py, a python binding for the RESTful API of podman services , to
implement this feature.

**Details:**

-  Skill level: beginner
-  Language: Python
-  Suggested by: Erik Skultety <eskultet@redhat.com>
-  Mentor: Erik Skultety <eskultet@redhat.com>
