============
libvirt Wiki
============

This is the libvirt Wiki for user contributed content.

To edit the pages either use the gitlab integrated editor (e.g. by following
the 'Edit this page' link in the footer of pages) or clone the
https://gitlab.com/libvirt/libvirt-wiki repository and then submit a merge
request with your changes.

Note that for linking within this wiki the link in the ``.rst`` file must
use ``.html`` suffix instead to link to the proper output file.

.. contents::

General project documentation
=============================

-  `Libvirt FAQ <FAQ.html>`__
-  `General hints and tips <Tips.html>`__
-  `Troubleshooting Guide <Troubleshooting.html>`__
-  `Switching over from running standalone QEMU to libvirt managed
   QEMU <QEMUSwitchToLibvirt.html>`__

Books
=====

-  Chirammal, Mukhedkar, et al., "Mastering KVM Virtualization", 2016,
   PACKT Publishing,
   `[1] <https://www.packtpub.com/eu/networking-and-servers/mastering-kvm-virtualization>`__

Guest Management
================

Guest Management Concepts
~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Guest (VM) Lifecycle <VM_lifecycle.html>`__ : **Read This First** -
   Introduces the concepts used with guests / virtual machines. Includes
   things like persistent vs transient domains, creating, starting,
   stopping domains, saving, restoring, snapshots, and secure wiping of
   disk images.

Virtio
~~~~~~

-  `Setting up virtio <Virtio.html>`__

Host SCSI device
~~~~~~~~~~~~~~~~

-  `vhost-scsi target <Vhost-scsi_target.html>`__

NPIV
~~~~

-  `NPIV in libvirt <NPIV_in_libvirt.html>`__

Networking
==========


Networking Concepts
~~~~~~~~~~~~~~~~~~~

-  `Virtual Networking <VirtualNetworking.html>`__ : **Read This First**
   - Introduces the concepts and ideas used in libvirts' networking for
   guests

Detailed networking pieces
~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Libvirtd_and_dnsmasq <Libvirtd_and_dnsmasq.html>`__ - Additional
   configuration settings needed for running a global dnsmasq in
   addition to a libvirt controlled one
-  `Networking hints and tips <Networking.html>`__
-  `OVS_and_PVLANS <OVS_and_PVLANS.html>`__ - Setup OpenvSwitch Flows to
   emulate PVLANs

Security
========

SSH
~~~

-  `How to set up access to libvirt via SSH <SSHSetup.html>`__
-  `How to configure PolicyKit access to libvirt through
   SSH <SSHPolicyKitSetup.html>`__

Transport Layer Security (TLS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `In depth guide to configuring TLS in libvirt <TLSSetup.html>`__
   *(with many pictures)*
-  `How to set up your VNC client software to use
   TLS <VNCTLSSetup.html>`__

Storage
=======

Disk and Memory Snapshots
~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Snapshot API Development <Snapshots.html>`__

Examples of live block operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Live disk backup with active blockcommit <https://libvirt.org/kbase/live_full_disk_backup.html>`__
-  `Live merge an entire disk image chain including current active disk <https://libvirt.org/kbase/merging_disk_image_chains.html>`__

Other
=====

 - `April Fools patch submissions' <AprilFools.html>`__
 - `How to populate libosinfo database <HowToPopulateLibosinfoDB.html>`__
 - `libvirt gconfig <Libvirt-gconfig.html>`__
 - `libvirt SNMP <Libvirt-snmp.html>`__
 - `managing text consoles <LibvirtConsoleManagement.html>`__
 - `using the qemu guest agent <Qemu_guest_agent.html>`__
 - `migrating VMs with storage hosted on local filesystems <NBD_storage_migration.html>`__
 - `list of old maintenance releases with backports <Maintenance_Releases.html>`__
 - `sysctl setup for bridging <Net.bridge.bridge-nf-call_and_sysctl.conf.html>`__

Images
~~~~~~

The images in this wiki, along with their Inkscape SVG source, are on
this page in one place in case you'd like to use or modify them for your
own project:

-  `SVGImages <SVGImages.html>`__

Debugging
~~~~~~~~~

In case you want to turn on debuging in libvirt follow:

-  `DebugLogs <https://libvirt.org/kbase/debuglogs.html>`__

For other (partially automated) debugging techniques, check

-  `Debugging <Debugging.html>`__

Getting started with libvirt development
========================================

Here is the `list of small tasks <BiteSizedTasks.html>`__ that should
enable you to start digging into libvirt source code base

Google Summer of Code
=====================

There is a separate page dedicated to `Google Summer of Code
2023 <Google_Summer_of_Code_2023.html>`__.

Also, the list for future ideas for projects can be found here `Google
Summer of Code Ideas <Google_Summer_of_Code_Ideas.html>`__.

The previous years can be found here:
`2022 <Google_Summer_of_Code_2022.html>`__,
`2021 <Google_Summer_of_Code_2021.html>`__,
`2020 <Google_Summer_of_Code_2020.html>`__,
`2019 <Google_Summer_of_Code_2019.html>`__,
`2018 <Google_Summer_of_Code_2018.html>`__,
`2017 <Google_Summer_of_Code_2017.html>`__ and
`2016 <Google_Summer_of_Code_2016.html>`__.

There is also a separate page for
`FAQ <Google_Summer_of_Code_FAQ.html>`__.
