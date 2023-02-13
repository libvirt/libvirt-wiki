.. contents::

External Snapshot management
----------------------------

Symptom
~~~~~~~

As of at least libvirt 1.1.1, external snapshot support is incomplete.
For example, with 1.0.5 or later, an external snapshot can be created of
an offline domain:

::

   $ virsh snapshot-create-as mydom snap --disk-only
   Domain snapshot snap created

but cannot be directly reverted to or deleted:

::

   $ virsh snapshot-revert mydom snap
   error: internal error: Child process (/usr/bin/qemu-img snapshot -a snap2 /mnt/backup/opt/libvirt/images/nested.snap) unexpected exit status 1: qemu-img: Could not apply snapshot 'snap2': -2 (No such file or directory)
     
   $ virsh snapshot-delete fedora_13 snap2
   error: Failed to delete snapshot snap2
   error: unsupported configuration: deletion of 1 external disk snapshots not supported yet

One solution would be to upgrade to a version of libvirt that supports
these fundamental operations - but as that could be an indefinite wait,
we'll have to do it by hand.

Background
~~~~~~~~~~

There are two classes of snapshots for qemu guests. Internal snapshots
(libvirt's default, if you used no option when creating the snapshot)
are contained completely within a qcow2 file, and fully supported by
libvirt (creation, revert, and deletion); but have the drawback of slow
creation times, less maintenance by upstream qemu, and the requirement
to use qcow2 disks.

External snapshots are nicer, because they work with any type of
original disk image, can be taken with no guest downtime, and are
receiving active improvements in upstream qemu development. In libvirt,
they are created when using the --disk-only or --memspec option to
snapshot-create-as (or when specifying an explicit XML file to
snapshot-create that does the same). But until libvirt improves,
snapshots are a one-way operation - libvirt can create them but can't do
anything further with them.

When taking an external snapshot, libvirt does so by creating a qcow2
backing chain. In the examples below, I show the active image with '^',
an image with modified contents with '\*', an image where backing file
metadata was modified by '+', and the backing relationship by '<-'. The
act of creating a snapshot creates a longer chain, as follows:

Originally, the guest is operating with a single file disk image, which
is where writes take place:

::

   original*

after a snapshot is created, a new qcow2 file is created with original
as its backing file, where original is now frozen as a read-only file at
the point where the snapshot was taken, and where the new snap file
contains writes that occur beyond there:

::

   original <- snap*

Taking several snapshots in a row, without any cleanup, can result in
less efficient operation as qemu has to trawl through ever more open
file descriptors for contents that have not changed since the original
file:

::

   original <- snap1 <- snap2 <- snap3*

Therefore, it is important to be able to reduce the length of a backing
chain. Qemu exposes at least three options for shortening a backing
chain; also, be aware that the options for manipulating a chain while a
guest is running differ from the options for manipulating a chain when
no guest is using the disk. When shortening a backing chain, the idea is
that the guest must continue to see the same information, but that it
takes fewer files to represent the information. Qemu's 3 options are:

-  ``virsh blockpull``: Remove one (or more) backing files, by pulling
   the content from the backing file into the active file. Limitation:
   as of qemu 1.6, you can only pull into the active image of an online
   guest (for offline images, qemu-img you can pull into any image with
   a rebase command). With this, it is possible to go from:

   ::

      base <- snap1 <- snap2*

   to:

   ::

      base <- snap2*+^

   where the contents of snap1 are now contained in snap2, and where
   snap2 had metadata rewritten to point to base.

-  ``virsh blockcommit``: Modify a deep backing file so that one (or
   more) intermediate backing files are committed into the base.
   Limitation: as of qemu 1.6, you cannot commit from the active image
   of an online guest (for offline images, the qemu-img commit operation
   can commit, but only through one base file at a time). Also, if you
   commit into a backing file, you invalidate any other qcow2 file that
   has been based off the same backing file. With this, it is possible
   to go from:

   ::

      base <- snap1 <- snap2*

   to:

   ::

      base^ <- snap2*+

where the contents of snap1 are now contained in base, and where snap2
had metadata rewritten to point to base.

-  ``virsh blockcopy``: Create a copy of the contents into any other
   format, and optionally pivot into the copy rather than the original.
   Limitation: as of qemu 1.6, this operation cannot be restarted, so
   libvirt 1.1.1 refuses to support this operation for anything except
   transient domains. With this, it is possible to go from:

   ::

      base <- snap1 <- snap2*

   to:

   ::

      new^*

where the contents of the entire old chain is now in new. Other
destination configurations are also possible, and with a sequence of
several operations combined, a user can get back to the original file
name with a minimum of data movement between temporary snapshot qcow2
files.

Note that which of the options is fastest will depend on how much the
live image has diverged from the point in time where the snapshot was
taken. Also note that the resulting file name of w (although qemu is
still working on ways to decently expose that information to the user,
so your best guess may be based on file sizes or relative length of time
between a snapshot creation and your merge operation).

Solution
~~~~~~~~

Notes below here are ramblings collected from various emails; I hope to
organize it into a more coherent fashion. Some of this information has
also been sent on the libvirt-users mailing list; searching the archives
of that list may turn up a treasure trove of ideas (again, which need to
be consolidated into this page...)

Given a chain:

::

   base <- a <- b <- top

the following operations are possible while live (with the \* marking
the image that was modified in contents, and the + marking the image
where metadata was updated to point to a new backing file):

::

   virDomainBlockCommit(dom, "vda", NULL, "a", 0, 0) ==
   virDomainBlockCommit(dom, "vda", "base", "a", 0, 0):
   base* <- b+ <- top

   virDomainBlockCommit(dom, "vda", NULL, "b", 0, 0) ==
   virDomainBlockCommit(dom, "vda", "a", "b", 0, 0)
   base <- a* <- top+

   virDomainBlockCommit(dom, "vda", "base", "b", 0, 0)
   base* <- top+

   virDomainBlockRebase(dom, "vda", NULL, 0, 0):
   top*+

   virDomainBlockRebase(dom, "vda", "base", 0, 0):
   base <- top*+

   virDomainBlockRebase(dom, "vda", "a", 0, 0):
   base <- a <- top*+

Not possible is to commit top into any of its backing files (but again,
there are patches being hammered out on the upstream qemu list to add
that) or to pull into anything but the top (I don't think patches have
been proposed for that yet).

::

   > This tells me that I might get all of the operations I want by: 1.
   > Using blockpull if merging the top-most snap into the top active
   > disk when deleting the top-most snapshot

Correct.

::

   >   2. Using blockcommit to merge a snapshot into a different
   >   (adjacent) snapshot when deleting any other snapshot

Correct, doesn't even have to be adjacent (although deleting only one
snapshot at a time implies that adjacent will be most common).

::

   >      2b. Maybe you can't merge/delete the lowest-level snapshot,
   >      since there isn't a lower one to commit into -- unless the
   >      chain is only that snap and the top image (enabling
   >      blockpull).

As currently limited, block commit is only useful for reducing a chain
of 3 or more elements down to a smaller chain of at least 2 elements.
Live commit is required before it can reduce down to 1 element. Block
pull can reduce a chain of any size down to 1 element.

And while you mentioned not wanting to use it yet, it is the idea of a
shallow block copy that can be used to rebase the top of a chain onto
any other arbitrary backing chain that has the same guest-visible
contents, where you are then free to use qemu-img for creating that
backing chain prior to completing the block copy.

Right now, libvirt snapshots and backing chains are independent
concepts. I'd *really* love for them to be integrated (where deleting a
snapshot does the right commit/pull actions, and where doing a blockpull
automatically adjusts or invalidates any snapshots that referred to the
name being eliminated, or else errors out to warn the user that
snapshots would be invalidated). But since they are fairly independent
at the moment, you are often stuck doing the equivalent of 'virsh
snapshot-delete --metadata' to tell libvirt to forget about the snapshot
that you just invalidated with a pull or commit, and/or using 'virsh
snapshot-create --no-metadata' in the first place for the side effects
of chain manipulation without any snapshot tracking.

The only SAFE way to have a new qcow2 file with the same active name as
the old one is the rather long sequence of:

-  create a snapshot that uses 'snap' as a new file, pointing to
   old_active as its backing, as in 'old_active <- snap'
-  blockpull old_active into snap
-  delete old_active, and recreate it as desired
-  do another snapshot that uses 'old_active' as the desired
   destination, as in 'snap <- old_snapshot'

or to use ``blockcopy``\ to take your copy for backup purposes without
impacting the live chain in the first place.

It sounds like you want to have a sequence of commands that will take
you from:

::

   base <- a <- live

to

::

   base <- a <- b <- live

while still allowing libvirt to know about the existence of 'b' in the
backing chain.

About the best I can come up with, for minimal block transfers (due to
the minimal time between the snapshot creation and the completion of the
mirroring), and while still keeping libvirt in the loop, is:

starting with:

::

   | base <- a <- live

create a snapshot:

::

   | base <- a <- live <- tmp1

use 'ln' to create another name for live:

::

   | base <- a <- live <- tmp1
   |           \- b

create tmp2 wrapping b:

::

   | base <- a <- live <- tmp1
   |           \- b <- tmp2

do a drive-mirror/pivot (block-copy) from tmp1 to tmp2:

::

   | base <- a <- b <- tmp2
   |           \- live <- tmp1

now that live is no longer in use, rm it, and recreate it to point to
tmp2 as its backing file (and discard tmp1):

::

   | base <- a <- b <- tmp2
   |                        \- live

create another snapshot, reusing live:

::

   | base <- a <- b <- tmp2 <- live

block-commit tmp2 into b, or blockpull tmp2 into live:

::

   | base <- a <- b <- live

But that still has the issue that you have a window of time where 'live'
is not the name of the live image, and an ill-timed crash could catch
your recovery off-guard.

::

   >
   > Deleting snapshots offline:
   > - We're deleting volume-<uuid>.<snap_id>
   > - If volume-<uuid>.<snap_id> is the active (top) image:
   >    - backing_file = qemu-img info volume-<uuid>.<snap_id> | grep
   > backing_file

qemu-img recently added a --output=json argument that makes the output
unambiguous and thus more suited for machine parsing; but whether you
use that or stick to scraping human output is just an implementation
detail; the concept of using qemu-img info (in whatever format) for
determining the backing file name is sane. (It helps that your design
places a restriction on creation of snapshots to stick to canned
volume-<uuid>.<snap_id> filenames; it is only when there is a
possibility of arbitrary backing file names that could include newlines
and other sequences, where grepping the human output potentially becomes
ambiguous.)

::

   >  - qemu-img commit volume-<uuid>.<snap_id>
   >  - rm volume-<uuid>.<snap_id>
   >  - Update our info to record that active disk image = backing_file

This is a commit direction (changes in top are folded into the backing
file); while it will always work, there is the question of whether it is
always the most efficient, or whether it may be more efficient to do the
pull direction (changes in the backing file are pulled into the top,
then the top is renamed to the backing file name) - but that
optimization can be saved for later. Also, we're still waiting for
upstream qemu to give us better visibility into how much of a qcow2 file
is allocated (Paolo Bonzini has proposed patches upstream, but I don't
know if they'll make qemu 1.6); knowing that will help decide whether a
pull or a commit is more efficient. Either way, you are correct that the
new active image exposes the same contents to the guest, and that the
snap has been removed from the chain.

deleting .2 from: volume-uuid <- volume-uuid.1 <- volume-uuid.2 <-
volume-uuid.3^ becomes: volume-uuid <- volume-uuid.1 <- volume-uuid.3^*+

::

   > - Else:
   >    - new_backing_file = qemu-img info volume-<uuid>.<snap_id> | grep
   > backing_file
   >    - Find file with volume-<uuid>.<snap_id> as its backing_file  (top)
   >    - Perform a qemu-img rebase -b <new_backing_file> <top>

This is a pull direction (changes in snap are pulled into top). Again,
it might be more efficient to instead commit the changes from top into
the snapshot being deleted, then rename the snapshot being deleted into
top, but again an optimization that could be done later. Either way, you
are correct that the goal is to move the contents from the snapshot
being deleted into the top image that was previously using that
snapshot, and updating the top image to point to what used to be the
snapshot's backing file.

deleting .1 from: volume-uuid <- volume-uuid.1 <- volume-uuid.2 <-
volume-uuid.3^ becomes: volume-uuid <- volume-uuid.2*+ <- volume-uuid.3^

   ::

      > Creating snapshots online:
      > - qemu-img create volume-<uuid>.<snap_id>   -> new_file
      >    ^ There was a safety concern around reading the old snap (active)
      > file here... still applies?  If I don't create w/ -obacking_file=, then
      > I need to provide a size here.  Can I determine size by running
      > "qemu-img info" on the backing file?

Determining the size can be done safely via libvirt; for example 'virsh
domblkinfo <math>dom </math>disk' (basically, whatever the python
binding is for the C virDomainBlockInfo); that's safer than using
qemu-img, because libvirt is at least coordinating with the running qemu
(and you will get the right answers even if someone did an online block
resize, which is not necessarily true for a parallel qemu-img info).
Also, libvirt should be able to report current block size even for
offline domains (although I'm not sure that you are using persistent
domains to worry about that aspect).

::

   >
   > - qemu-img rebase -u -b volume-<uuid>[.<old_snap>] <new_file>
   >    ^ Need to preserve relative path -- libvirt won't rewrite it w/ an
   > absolute path, right?

Libvirt won't rewrite the backing file name; when reusing an existing
file, it should honor whatever you put in, whether absolute or relative.
Again, use -F qcow2/raw so that the metadata records what format the
backing image will have.

::

   >
   > - Determine old_file for the disk we are interested in by scanning
   > libvirt domain XML
   >
   > - Call libvirt createSnapshotXML w/
   >    <disk name='<old_file>' snapshot='external'>
   >      <source file='<new_file>'
   >    </disk>
   >   using args DISK_ONLY | NO_METADATA | REUSE_EXT | QUIESCE
   >
   > - Now we have volume-<uuid>.<snap_id> as the active image
   >    - which has volume-<uuid>[.<old_snap>] as its backing file.

Correct. Going from

::

   volume-uuid^

to:

::

   volume-uuid <- volume-uuid.1^

to:

::

   volume-uuid <- volume-uuid.1 <- volume-uuid.2^

   >
   > Deleting snapshots online:
   > - Find the file we want to remove from the qcow2 chain by scanning
   > libvirt domain XML  (<snap_file> is the absolute path)
   >
   > - If <snap_file> is the active image for the VM:

<snap_file> will never be the active image for the VM - remember, you
created snapshots by renaming the active image, because the active image
is the one file in the chain that is not tied to a point in time, but
all snapshots are tied to a point in time. Rather, this condition is "If
<snap_file> is the backing file for the active image"

::

   >    - Call dom.blockPull(snap_file, bandwidth=0, flags=0)

dom.blockRebase(active_name, base=parent_of_snap_file, bandwidth=0,
flags=0)

::

   >    - I think we have to watch the above w/ blockJobInfo()

Yes, blockRebase starts a long-running job, you then have to poll or
register for an event to determine when it is complete.

::

   >    - Then rm the file that was pulled from?

Yes, after the event completes, you can safely delete the .snap file
that is no longer referenced. Thus, for deleting the most recent
snapshot .2 with an active file of .3, you are changing from:

volume-uuid <- volume-uuid.1 <- volume-uuid.2 <- volume-uuid.3^ to:
volume-uuid <- volume-uuid.1 <- volume-uuid.3^*+

::

   > - Else:
   >    - Get backing_file for snap_file
   >    - Call dom.blockCommit('vdb', backing_file, snap_file, bandwidth=0,
   > flags=...)
   >    - ^ With BLOCK_COMMIT_DELETE?  Seems to fit our use case.

It would fit, except I haven't wired it up for qemu yet (another case of
deleting being harder than planned, so we have documented API but not
yet implementation).

::

   >    - Or we might want blockCommit('vdb', None, snap_file,
   > flags=BLOCK_COMMIT_SHALLOW) which also seems to fit here and saves a
   > little work.

Yes, BLOCK_COMMIT_SHALLOW is rather convenient.

Hmm, I'm a bit worried that this doesn't do what you want. blockCommit
changes the contents of the file below the snapshot - but if the file
below the snapshot is another snapshot, then changing its contents means
it is no longer the point in time that you had originally done a
snapshot of. That is, if you commit .1 from: volume-uuid <-
volume-uuid.1 <- volume-uuid.2 <- volume-uuid.3^ then you have modified
volume-uuid, which means snapshot 0 was corrupted: volume-uuid\* <-
volume-uuid.2+ <- volume-uuid.3^

Do you have a notion of which volume-<uuid>.<snap> was associated with a
particular snapshot? And do you have a way to update that pairing, if
filenames in the chain change based on where the content was moved? That
is, you would track:

::

   chain: "volume-uuid"; active: "volume-uuid", snapshots: []

to:

::

   chain: "volume-uuid <- volume-uuid.1"; active: "volume-uuid.1",
   snapshots: ["volume-uuid"]

to:

::

   chain: "volume-uuid <- volume-uuid.1 <- volume-uuid.2"; active:
   "volume-uuid.2", snapshots: ["volume-uuid", "volume-uuid.1"]

In particular, note that the first snapshot created (snapshots[0]) is
tied to volume-uuid without suffix, and that the second snapshot
(snapshots[1]) is initially tied to volume-uuid.1.

Then, when it is time to delete the FIRST snapshot (snapshots[0]), you
issue a dom.blockCommit(disk, top="volume-uuid.1",
flags=BLOCK_COMMIT_SHALLOW), and update your metadata:

::

   chain: "volume-uuid* <- volume-uuid.2+"; active: "volume-uuid.2",
   snapshots: [deleted, "volume-uuid"]

Note that the SECOND snapshot (snapshots[1]) is now tied to a new
filename (volume-uuid rather than volume-uuid.1), because you commit the
wrapping file of the snapshot being deleted, and not the snapshot file
itself.

Reiterating with a longer chain, if you want to delete the second
snapshot, while leaving the first and third snapshots intact, starting
from:

::

   chain: "volume-uuid <- volume-uuid.1 <- volume-uuid.2 <- volume-uuid.3";
   active: "volume-uuid.3", snapshots: ["volume-uuid", "volume-uuid.1",
   "volume-uuid.2"]

then you do a shallow block-commit of volume-uuid.2 onto volume-uuid.1,
leaving you with:

::

   chain: "volume-uuid <- volume-uuid.1* <- volume-uuid.3+"; active:
   "volume-uuid.3", snapshots: ["volume-uuid", deleted, "volume-uuid.1"]

so even though the point in time of the second snapshot is deleted, the
filename from the third snapshot is what disappeared because we
committed the third snapshot into the filename originally used by the
second snapshot.

I guess this means you have to track a bit more than just the active
filename, but you also have to track which files are tied to each
snapshot, as a deletion operation may change those file names.

References/Notes
~~~~~~~~~~~~~~~~

-  `Discussion of deleting/shortening disk image chains, online/offline
   on libvirt-users list
   (27FEB2013) <https://www.redhat.com/archives/libvirt-users/2013-February/msg00095.html>`__
-  `Discussion of disk image merging techniques using
   tool <https://www.redhat.com/archives/libvirt-users/2014-January/msg00124.html>`__
-  `Discussion of different snapshots and disk image merging operations,
   discussed at LinuxCon
   Eu-2012 <http://kashyapc.fedorapeople.org/virt/lc-2012/snapshots-handout.html>`__
   -- Update to this in progress, but provides mores than enough clues
   to get started.
-  `Snapshot chains discussion/presentation at CloudOpen Europe
   2014 <https://kashyapc.fedorapeople.org/virt/lcco-2014/Update-on-QEMU-and-libvirt-snapshots-disk-image-chains-CloudOpen-Eu-2014.pdf>`__
