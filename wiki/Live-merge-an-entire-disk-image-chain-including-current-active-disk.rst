.. contents::

!NOTE! This document has moved here:
====================================

Merge an entire chain (including current active image) into its base image
==========================================================================

Purpose: Reduce backing chain by merging all the disk image contents
into the base image.

Procedure
---------

With an intention to create a disk image chain as below:

::

   [base] <-- [sn1] <-- [sn2] <-- [cur] (live QEMU)

Perform live active commit opertaion to shorten the disk image chain as
below.

List the current active disk image in use:

::

   $ virsh domblklist vm1
   Target     Source
   ------------------------------------------------
   vda        /export/images/base.qcow2

Create external snapshots (and add contents in between in each disk
image to differentiate each image):

::

   $ virsh snapshot-create-as --domain vm1 snap1 \
       --diskspec vda,file=/export/images/sn1.qcow2 \
       --disk-only --atomic --no-metadata
   $ virsh snapshot-create-as --domain vm1 snap2 \
       --diskspec vda,file=/export/images/sn2.qcow2 \
       --disk-only --atomic --no-metadata
   $ virsh snapshot-create-as --domain vm1 snap3 \
       --diskspec vda,file=/export/images/cur.qcow2 \
       --disk-only --atomic --no-metadata

Enumerate the backing file chain:

::

   $ qemu-img info --backing-chain \
       /export/images/cur.qcow2 
   [. . .]

List the current active disk image in use:, again:

::

   $ virsh domblklist vm1
   Target     Source
   ------------------------------------------------
   vda        /export/images/cur.qcow2

Live active commit an entire chain, including pivot:

::

   $ virsh blockcommit vm1 vda --verbose --pivot --active
   Block Commit: [100 %]
   Successfully pivoted

Again, check the current active block device in use:

::

   $ virsh domblklist vm1
   Target     Source
   ------------------------------------------------
   vda        /export/images/base.qcow2

Enumerate the backing file chain:

::

   $ qemu-img info --backing-chain /export/images/base.qcow2
   [. . .]

Final resulting disk image chain:

::

   [base] (which is the current active disk image in use)

Explanation of result:

-  --active: It performs a two stage operation: first stage – it commits
   the contents from top images into base (i.e. sn1, sn2, current into
   base); in the second stage, the block operation remains awake to
   synchronize any further changes (from top images into base), here the
   user can take two actions: cancel the job, or pivot the job, i.e.
   adjust the base image as the current active image.
-  --pivot: Once data is committed from sn1, sn2 and current into base,
   it pivots the live QEMU to use base as the active image.
-  --verbose: Displays a progress of block operation.
-  Finally, the disk image backing chain is shortened to a single disk
   image.

Additional explanation (by Eric Blake)
--------------------------------------

'cur' is still valid but 'sn1' and 'sn2' are no longer valid in
isolation; and when the pivot completes, 'cur' is also no longer valid.
Any commit operation that changes the content of a backing file has the
potential to invalidate other files that were using it as a backing
file; but the particular algorithm we use guarantees that the
invalidation of 'cur' does not happen until we break sync, so the
current guest is not impacted by anything done during the operation.

Or, in graphical terms, let us suppose we have the following chain,
where '-' represents a hole in the current layer (read from the backing
file, or read all zeros if there is no backing file):

::

               contents:          what you would see:
   base:       AAAA--------       AAAA--------
   sn1:        --BBBB------       AABBBB------
   sn2:        -----CCCC---       AABBBCCCC---
   cur:        D-------DD--       DABBBCCCDD--
   guest sees: DABBBCCCDD--       DABBBCCCDD--

start the block copy, and we eventually reach this state at the end of
phase 1:

::

               contents:          what you would see:
   base:       DABBBCCCDD--       DABBBCCCDD--
   sn1:        --BBBB------       DABBBBCCDD--
   sn2:        -----CCCC---       DABBBCCCCD--
   cur:        D-------DD--       DABBBCCCDD--
   guest sees: DABBBCCCDD--       DABBBCCCDD--

that is, the guest does not see any difference, and the current image
does not see any difference, BUT sn1 and sn2 are completely different
than what they were pre-commit. Then, once you break sync and make
modification E in the guest, you might have:

::

               contents:          what you would see:
   base:       EABBBCCCDDE-       EABBBCCCDDE-
   guest sees: EABBBCCCDDE-       EABBBCCCDDE-
   sn1:        --BBBB------       EABBBBCCDDE-
   sn2:        -----CCCC---       EABBBCCCCDE-
   cur:        D-------DD--       DABBBCCCDDE-

which is again proof that sn1, sn2, and now cur have all been
invalidated.
