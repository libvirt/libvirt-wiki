.. contents::

NBD Storage Migration
=====================

Since the ``1.0.3`` release, libvirt is using the new NBD way of
migrating non-shared storage. Previously, the storage was migrated in
the same data stream as domain's RAM and qemu's internal state. This
carried some notable disadvantages, e.g. under heavy workload the guest
was nearly unable to migrate. For more info see `Fedora Feature
Page <http://fedoraproject.org/wiki/Features/Virt_Storage_Migration>`__.
Since the qemu ``1.3.0`` release, bunch of new features were added,
notably NBD Storage migration. That is, qemu is able to send a disk over
a stream either to local file or remote host. And this is what libvirt's
adapted and refer to as *NBD migration*

How it works
~~~~~~~~~~~~

#. **``Destination``**: In the ``PREPARE`` phase, NBD server is started.
   This will handle incoming NBD requests and multiplex data from the
   stream into several disks (There's just one stream used for
   transferring all disks). Then, all disks in domain XML besides
   {shared, readonly, source-less} are marked to transfer. In other
   words, NBD server is told which disks are to be transfered.
#. **``Source``**: In the ``PERFORM`` phase, the migration source
   initializes the NBD stream to the destination. The mirroring phase
   can take very long which kind of hurts performance, because we can't
   start the migrated guest on the destination until all disks are
   transferred. With current implementation, libvirt tells qemu to start
   NBD transfer to the destination and waits for it to quiesce. Since
   guest may be running during migration and hence write something onto
   any of transferred disk such write must be mirrored to the
   destination. Then, after qemu told libvirt NBD is quiesced, the real
   migration starts (domain's RAM + qemu's internal state)
#. **``Destination``**: In the ``FINISH`` phase, the destination resumes
   the freshly migrated domain and kills the NBD server, as it is no
   longer needed.

Why/How should I use it?
~~~~~~~~~~~~~~~~~~~~~~~~

The cool thing about all this is: none of this is visible to users and
hence, no API/virsh command change was made. Users can still use
``virsh migrate --copy-storage-all ...`` or
``virsh migrate --copy-storage-inc ...`` and benefit from NBD without
any change needed to be done to their code. Moreover, if one of the
migration sides doesn't understand NBD, then libvirt takes fall back
path and use the old style of migrating the storage. Cool, isn't it?
