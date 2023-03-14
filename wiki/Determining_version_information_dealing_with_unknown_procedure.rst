.. contents::

Determining version information
-------------------------------

Symptom
~~~~~~~

When diagnosing other issues, it can be important to know if a problem
is due to using an older version of software. For local access to
hypervisors that maintain no state in libvirt (such as ESX), there is
only one version to worry about - the version of libvirt.so being used
by the client software to communicate to the hypervisor. But for
hypervisors that maintain state (such as Qemu or LXC), as well as for
remote access, there are several versions to be aware of, the client
making the connection and the server acting on the commands.

Libvirt's remote protocol is designed to be robust and
backwards-compatible, so any action that an older client knows how to
request should continue to work no matter how much newer the server is.
Conversely, if the client is newer than the server, the protocol
guarantees that newly-added requests from the client that are not
recognized by the server will safely generate an error. This also
applies if both client and server are new enough to recognize a
particular API, but the given hypervisor driver has not yet mapped it
into use. Remember that many API have a flags parameter, and that
well-written hypervisors will return an error if a flag bit is
unrecognized.

One more point of confusion stems from the fact that since libvirt.so is
a shared library, a client can be compiled against an older set of
headers than what is in use by the currently-installed libvirt.so.

A common symptom of unimplemented functionality is this error message:

::

   $ virsh -c qemu:///system dompmsuspend dom hybrid
   error: Domain dom could not be suspended
   error: unknown procedure: 261
   $ echo $?
   1

Investigation
~~~~~~~~~~~~~

On the server side, the libvirtd log will always start with version
information; if you need to file a bug report, this information is a
vital clue in deciphering if the real problem is due to unimplemented
features in the particular version being run. For example,

::

   $ head -n1 /var/log/libvirt/libvirtd.log
   2012-02-13 04:26:44.642+0000: 1494: info : libvirt version: 0.9.9, package: 2.fc16 (Unknown, 2012-01-20-16:00:45, fedora64.linuxtx.org)

shows that a server was running a pre-built binary for Fedora 16, with a
designation of libvirt-0.9.9-2.fc16 (this particular server was from the
fedora-virt-preview repo), and which understands the 0.9.6 API.

Meanwhile, the client side can report several versions:

::

   $ tools/virsh version # just the client side
   0.9.10
   $ virsh --version=long # more details
   Virsh command line tool of libvirt 0.9.10
   See web site at https://libvirt.org/

   Compiled with support for:
    Hypervisors: Xen QEmu/KVM UML OpenVZ VirtualBox LXC ESX PHYP Test
    Networking: Remote Daemon Network Bridging Netcf Nwfilter VirtualPort
    Storage: Dir Disk Filesystem SCSI Multipath iSCSI LVM
    Miscellaneous: SELinux Secrets Debug DTrace Readline
   $ virsh -c qemu:///system version --daemon # get server details, too
   Compiled against library: libvir 0.9.10
   Using library: libvir 0.9.10
   Using API: QEMU 0.9.10
   Running hypervisor: QEMU 1.0.0
   Running against daemon: 0.9.9

`The Hypervisor Support <https://libvirt.org/hvsupport.html>`__ page is
useful for tracking down situations where the client knows how to use a
particular API, but where the hypervisor driver did not support the
call. However, this page does not (yet) detail when support for
particular flags was added, if the flags were implemented later than the
original API.

For the particular example above, it turns out that
virDomainPMSuspendForDuration was implemented in 0.9.10, but while virsh
is new enough to know how to use the API, the running server at 0.9.9
doesn't know how to react to it.

Solution
~~~~~~~~

In cases of version mismatch, it may be sufficient to upgrade libvirtd
to a newer version. It is safe to restart libvirtd to the upgraded
version, even while guests continue to run.

Other solutions include writing code to try several fallback mechanisms.
virsh is a prime example of this; studying the virsh source code shows
several places where the code tries to accommodate older servers. For
example, 'virsh undefine --managed-save dom' will start by trying
virDomainUndefineFlags(), but if that fails, it will fall back to a
two-step sequence of virDomainManagedSaveRemove() before
virDomainUndefine().
