.. contents::

Google Summer of Code 2020
==========================

Introduction
------------

Like in the previous years, libvirt applied for `Google Summer of Code
2020 <http://g.co/gsoc>`__. The program timeline can be found
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

**Links:**

-  `GSoC project
   archive <https://summerofcode.withgoogle.com/archive/2020/projects/6612599065542656/>`__

**Details:**

-  Component: libvirt
-  Skill level: advanced
-  Language: C
-  Mentor: Pavel Hrdina <phrdina@redhat.com>, phrdina on IRC (#virt
   OFTC)


Libvirt driver for Jailhouse
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Add support for Jailhouse hypervisor to libvirt.

Jailhouse is a Linux-based partitioning hypervisor designed to run
bare-metal applications and (adapted) operating systems alongside Linux.
Compared to other hypervisors such as KVM or Xen, Jailhouse is optimized
for simplicity rather than features and targets real-time and security
workloads.

The project's goal is to develop libvirt driver for Jailhouse. The
current vision is to implement lifecycle management (VM aka cell
start/stop), status and virtual console support. The latter relies on
work-in-progress which would hopefully be merged mainline before the
project starts.

There are some initial attempts which could be used as a starting point.
However, we should refrain from calling jailhouse tool (a native
Jailhouse command-line interface) and rather use direct kernel API
(ioctls issued to /dev/jailhouse) or abstract it into a library.

**Links:**

-  Jailhouse project page: https://github.com/siemens/jailhouse
-  Initial attempt on Jailhouse driver:
   https://www.redhat.com/archives/libvir-list/2015-November/msg00302.html
-  `GSoC project
   archive <https://summerofcode.withgoogle.com/archive/2020/projects/5436033845428224/>`__

**Details:**

-  Skill level: intermediate
-  Language: C


Expose cpu, memory, numa tuning in Salt virt states
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Salt
`virt.running <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.virt.html#salt.states.virt.pool_running>`__
and virt.defined states help users define VMs using libvirt. In order to
allow more fine tuning of the created or updated virtual machines, this
project aims at exposing the CPU and memory tuning options in these
states.

**Links:**

-  `Salt states
   tutorial <https://docs.saltstack.com/en/latest/topics/tutorials/states_pt1.html>`__
-  `virt module's
   code <https://github.com/saltstack/salt/blob/master/salt/modules/virt.py>`__
-  `virt state's
   code <https://github.com/saltstack/salt/blob/master/salt/states/virt.py>`__
-  `GSoC project
   archive <https://summerofcode.withgoogle.com/archive/2020/projects/6094282445815808/>`__

**Details:**

-  Skill level: intermediate
-  Language: Python.
-  Mentor: Cédric Bosdonnat <cbosdonnat@suse.com>


Take migration in Salt virt module to the next level
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Salt
`virt.migrate <https://docs.saltstack.com/en/develop/ref/modules/all/salt.modules.virt.html#salt.modules.virt.migrate>`__
needs to be reworked to better cover the libvirt API

Salt offers a nice wrapper around libvirt. However the migration
functions are calling virsh and not exposing all options. This project
is about rewriting the salt migration functions to use the
python-libvirt API, but also to expose as much as possible of the
libvirt migration options.

Salt also allows users to describe the guests using a state. Once the
migration functions are exposed, the
`virt.running <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.virt.html#salt.states.virt.running>`__
state would need to be modified to handle migrating the guest to another
host.

**Links:**

-  `Salt states
   tutorial <https://docs.saltstack.com/en/latest/topics/tutorials/states_pt1.html>`__
-  `virt module's
   code <https://github.com/saltstack/salt/blob/master/salt/modules/virt.py>`__
-  `virt state's
   code <https://github.com/saltstack/salt/blob/master/salt/states/virt.py>`__
-  `GSoC project
   archive <https://summerofcode.withgoogle.com/archive/2020/projects/4913175331340288/>`__

**Details:**

-  Skill level: intermediate
-  Language: Python.
-  Mentor: Cédric Bosdonnat <cbosdonnat@suse.com>
-  Suggested by: Cédric Bosdonnat
