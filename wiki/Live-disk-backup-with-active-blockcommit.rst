.. contents::

!NOTE! This document has moved here:
====================================

Efficient live disk backup with active blockcommit
==================================================

Purpose: Perform efficient live disk backups using "active blockcommit".

"Active blockcommit" is a two phase operation: (1) once an external
snapshot (which results in a qcow2 overlay that tracks the new writes
from then on) is taken, the content from the overlay can be copied into
its backing file (e.g. 'base'); then (2) pivot live QEMU to 'base'. All
of this while the guest is running.

This is possible with versions: QEMU 2.1 (and above), libvirt-1.2.9 (and
above).

Procedure
---------

Start with a single disk image, with any format:

::

   [base] (live QEMU)

List the current block device in use:

::

   $ virsh domblklist vm1
   Target     Source
   ------------------------------------------------
   vda        /export/images/base.img 

Create an external disk snapshot:

::

   $ virsh snapshot-create-as --domain vm1 guest-state1 \
       --diskspec vda,file=/export/images/overlay1.qcow2 \
       --disk-only --atomic 

Now, the disk image chain is:

::

   [base.img] <-- [overlay1.qcow2] (live QEMU)

**NOTE-1**: Above, if you have QEMU guest agent installed in your
virtual machine, try '--quiesce' option with
``virsh snapshot-create-as[. . .]`` to ensure you have a consistent disk
state.

**NOTE-2**: Optionally, you can also supply '--no-metadata' option to
tell libvirt to not track the snapshot metadata -- this is useful
currently, as otherwise at a later point when you decide to merge
snapshot files, you have to explicitly clean the libvirt metadata (by
invoking: ``virsh snapshot-delete vm1 --metadata [name|--current]`` --
repeat this as needed.)

Take a backup of the original disk in background using your favourite
tool:

::

   $ cp /export/images/base.img /export/images/copy.img

   [or]

   $ rsync -avhW --progress /export/images/base.img \
           /export/images/copy.img

List the current block device in use, again. It can be noticed,
'overlay1.qcow2' is the current disk in use:

::

   $ virsh domblklist vm1
   Target     Source
   ------------------------------------------------
   vda        /export/images/overlay1.qcow2

Now that the backup is finished, perform active blockcommit by live
merging contents of 'overlay1.qcow2' into 'base.img':

::

   $ virsh blockcommit vm1 vda --active --verbose --pivot

List the current block device in use, again. It can be noticed, once the
blockcommit operation is completed, the live QEMU is *pivoted* to the
base image:

::

   $ virsh domblklist vm1
   Target     Source
   ------------------------------------------------
   vda        /export/images/base.img

The final resulting disk image chain (a single consolidated disk image):

::

   [base.img] (live QEMU)
