.. contents::

Snapshots
=========

**APIs for managing live snapshots**

Right now, this page serves as a discussion point to stabilize the
design of new libvirt APIs needed to more fully manage snapshot
operations.

`QEMU migration
wiki <http://wiki.qemu.org/Features/LiveBlockMigration>`__

Existing API
------------

virDomainSave(domain, file) - saves \_just\_ the domain's memory state
to user-specified file, requires running domain

virDomainRestore(domain, file) - restores domain memory from
user-specified file; attached disks must be in same state as
virDomainSave or guest will likely have corrupted disks

virDomainManagedSave(domain, flags) - saves \_just\_ the domain's memory
state to libvirt-managed file, flags must be 0 for now, requires running
domain

virDomainCreate(domain)/virDomainCreateWithFlags(domain,flags)/autostarted
domains - if libvirt-managed file exists, load from that instead of
starting from scratch, and delete managed file

virDomainHasManagedSaveImage(domain, flags) - checks if inactive domain
has saved image, flags must be 0 for now

virDomainManagedSaveRemove(domain, flags) - removes libvirt-managed file

virDomainSnapshotCreateXML(domain, xml, flags) - snapshots disk and RAM
state of online guest, flags must be 0 for now, and currently relies on
qemu to do the snapshot which only works if all disks are qcow2 and
guest is paused during duration but resumes after; also works for
offline guest to use qemu-img to just image snapshot all guest disk
images

virDomainHasCurrentSnapshot(domain, flags) - probe if domain has a
snapshot; flags must be 0

virDomainRevertToSnapsot(snapshot, flags) - restore state from a
snapshot; flags must be 0

virDomainSnapshotCurrent(domain, flags) - return current snapshot, if
any; flags must be 0

virDomainSnapshotDelete(snapshot, flags) - delete storage used by
snapshot, flags controls whether children are rebased or deleted

virDomainSnapshotFree(snapshot) - free object returned by
virDomainSnapshotCurrent, virDomainSnapshotCreateXML, or
virDomainSnapshotLookupByName (the snapshot still exists in storage)

virDomainSnapshotGetXMLDesc(snapshot, flags) - return XML details about
a snapshot; flags must be 0

virDomainSnapshotListNames(domain, names, len, flags) - populate an
array of len names with the snapshots belonging to domain; flags must be
0

virDomainSnapshotLookupByName(domain, name, flags) - get snapshot by
name; flags must be 0

virDomainSnapshotNum(domain, flags) - tell how many snapshot names
exist; flags must be 0

Proposed new API
----------------

virDomainSaveFlags(domain, file, flags)

Desired functionality
---------------------

::

   Right now, libvirt can save domain memory ('virsh save', which boils
   down to an outgoing migration command to qemu), or save domain disk
   state ('virsh snapshot', which requires all disk images to be qcow2, and
   boils down to the savevm monitor command [qemu does the work] if a guest
   is running or img snapshot -c if the guest is offline), but not both.

Misunderstanding on my part - the qemu 'savevm' monitor command \_also\_
saves RAM state, but currently by pausing the guest for several seconds
during the duration of the snapshot. The memory state is thus crammed
somewhere in one of the qcow2 images.

::

   My understanding (and correct me if I'm off-base) is that you are
   implementing a new monitor command to let libvirt be the entity that
   does the snapshot, rather than qemu; thus libvirt can expand in its
   power to do true snapshots using qemu-img for qcow2, using lvm snapshots
   for any disk backed by an lvm partition, using btrfs copy-on-write
   cloning for any disk backed by btrfs, or worst case falling back to
   manual copying.  Except for the qcow2 'savevm' case (where qemu already
   does the work), this means that libvirt needs to know how to snapshot
   various disk images; and in some cases, creating a snapshot means that
   libvirt will want qemu to associate a different (but identical content)
   file; that is, the guest's /dev/vda is originally backed by the host's
   file1.img, but the snapshot process means that file1.img is now made the
   snapshot and file2.img is the new file that qemu should seamlessly use
   as the backing image for the guest.

   What are the new monitor commands that I need to be aware of?

   If I'm correct, the sequence for a libvirt-controlled live snapshot
   would thus be:

   optionally - use the guest-agent to tell the guest OS to quiesce I/O
   for each disk to be saved:
     tell qemu to pause disk image modifications for that disk
   for each disk image to be saved:
     libvirt creates the snapshot
     if the snapshot involves updating the backing image used by qemu:
       pass qemu the new fd to replace the existing fd for the disk image
   for each disk to be saved:
     tell qemu to resume disk I/O for that disk

Here, we can also pass name of file (if qemu can open() it), especially
since passing fd: of file for when qemu cannot open() it is still a qemu
feature under active development.

::

   at which point, I have a crash-consistent view of each disk that I chose
   to snapshot, and the guest was able to do useful non-I/O during the
   window where the snapshots were being created (the window should be slow
   if all disks being saved were qcow2, lvm, or btrfs).  For live
   snapshots, where all we care about is crash-consistent disk state, it is
   conceivable that some users only care about grabbing a subset of the
   disks associated with a guest; so this sequence implies that libvirt
   needs some way to tell qemu which disks to save (the savevm monitor
   command does not fit the bill - it is an all or nothing command, where
   all disk images must be qcow2).  Is the command to tell qemu to pause
   disk modification a global command, or is it a per-disk command?  I
   wrote the above algorithm assuming it was per-disk (if it is global,
   then loops 1 and 3 are instead a single monitor command; if it is
   per-disk, then the qemu resume command in loop 3 could actually be
   folded into loop 2).  That is, all disk I/O has to be paused before any
   snapshots are started (so that the snapshot set is consistent between
   disks), but disks can be resumed as soon as possible rather than waiting
   for all snapshots to finish before resuming the first disk I/O.

   In the above algorithm, the snapshot images are only crash-consistent
   (as if power had been pulled, requires fsck from a guest to guarantee
   sane state when restoring a disk from that point) unless the optional
   guest-agent quiesce action was able to guarantee sane disk state prior
   to the qemu I/O freeze.

   Additionally, right now I can create a complete system restore point
   using this sequence:

'virsh snapshot' already creates a complete system restore point, but
under qemu control. So this details how to do it under libvirt control.

::

   tell qemu to migrate guest memory to file; qemu pauses the guest
   libvirt then halts guest
   for each disk:
     manually create a snapshot of each underlying disk image

   and to restore:

   for each disk:
     manually revert back to disk snapshot point
   tell qemu to do incoming migration from file

   But that involves multiple qemu processes, and the guest is down for the
   entire snapshot and restore process.  It seems like a nicer live system
   restore point creation is not too far away:

   optionally - use the guest-agent to tell the guest OS to quiesce I/O
   tell qemu to migrate guest memory to file; qemu pauses guest
   for each disk:
     tell qemu to pause disk image modifications for that disk
   libvirt resumes qemu (but I/O is still frozen)
   for each disk:
     libvirt creates the snapshot
     if the snapshot involves updating the backing image used by qemu:
       pass qemu the new fd for the disk image
     tell qemu to resume disk I/O on that disk

   where once again, reverting to a system restore point is:

   for each disk:
     revert back to disk snapshot point
   tell qemu to do incoming migration from file

   That is, for the creation of the restore point, I've avoided the need to
   create a second qemu process, and have reduced the downtime (the guest
   can still do useful non-I/O work while I'm taking the system
   restore-point disk snapshots).

   With a system restore point, crash-consistency in the disks is not
   important, since we have the memory state that tracks all in-flight I/O
   that had not yet been flushed to disk; but whereas disk snapshots might
   make sense with a subset of disks, a system restore point must snapshot
   all disks.

   My above discussion also points out the need for libvirt to be able to
   manage system restore points as a native libvirt object, where it tracks
   both the memory image ('virsh save') and disk snapshots ('virsh
   snapshot') as a single unit.  virDomainSave is missing a flags argument,
   so I'll have to add a new virDomainSaveFlags, but I think a single flags
   argument is sufficient for the task:

   virDomainSaveFlags(,0) - save just memory, halt guest
   virDomainSaveFlags(,LIVE) - save just memory, then resume guest
   virDomainSaveFlags(,SYSTEM_RESTORE_POINT) - save memory, halt guest,
   then off-line disk snapshot
   virDomainSaveFlags(,SYSTEM_RESTORE_POINT|LIVE) - save memory, try online
   disk snapshot but fall back to offline disk snapshot and incoming migration
   virDomainSaveFlags(,SYSTEM_RESTORE_POINT|LIVE|NO_OFFLINE) - save memory,
   require online disk snapshot and fail if qemu is too old
   virDomainSaveFlags(,SYSTEM_RESTORE_POINT|LIVE|NO_OFFLINE|QUIESCE) -
   likewise, and request the guest-agent quiesce

Given what I've additionally learned about 'savevm', adding a
SYSTEM_RESTORE_POINT flag would just be syntactic sugar for having
virDomainSaveFlags call virDomainSnapshotCreateXML with a NULL xml
argument.

::

   It also means that libvirt needs to enhance storage pool APIs to manage
   disk snapshots for more supported backing types (qcow2, lvm, btrfs,
   raw), and to either rewire virDomainSnapshotCreateXML to have libvirt
   rather than qemu be the entity doing the snapshots, or add a new API
   there.  Here, I'm thinking a new API that takes an array of guest disks
   to save (or a NULL array to save all guest disks at once).  Plus I need
   new counterpart APIs for virStoragePool management to easily take
   offline snapshots of various disk image types.

   I need to make sure we have all new libvirt APIs in place before the end
   of June, even if the APIs are not fully-featured at that point, so long
   as the APIs are extensible enough for everyone's needs.  That is, it's
   okay if we don't have the complete feature working by the end of June
   (if we can just live snapshot a single qcow2 disk guest via libvirt
   rather than qemu to prove the API works, that's good enough for libvirt
   0.9.3), as long as incremental additions for other disk formats (lvm,
   btrfs, raw file copying snapshots) can be added later without adding new
   APIs.

QEMU wiki page
--------------

The QEMU wiki has a page that discusses snapshots as well as live block
copy:

http://wiki.qemu.org/Features/LiveBlockMigration
