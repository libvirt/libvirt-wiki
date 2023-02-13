.. contents::

Libvirt maintenance releases
============================

3.2 series
----------

3.2.1 (May 10 2017)
~~~~~~~~~~~~~~~~~~~

`Download
libvirt-3.2.1 <http://libvirt.org/sources/stable_updates/libvirt-3.2.1.tar.xz>`__

Changes in this version:

-  spec: Update version check for maint Source URL
-  mdev: Cleanup code after commits @daf5081b and @2739a983
-  Don't use ceph-devel on Fedora
-  mdev: Fix mingw build by adding a check for non-NULL pointer
-  client: Report proper close reason
-  qemu: Fix persistent migration of transient domains
-  Fix padding of encrypted data
-  network: better log message when network is inactive during reconnect
-  qemu: don't kill qemu process on restart if networkNotify fails
-  conf: format only relevant attributes for graphics based on listen
   type
-  qemu: Move freeing of PCI address list to qemuProcessStop
-  qemu: process: Clean up priv->migTLSAlias
-  qemu: process: Don't leak priv->usbaddrs after VM restart
-  qemu: process: Clean automatic NUMA/cpu pinning information on
   shutdown
-  qemu: Remove extra messages for vhost-scsi hotplug
-  qemu: Remove extra messages from virtio-scsi hotplug
-  qemu: Check return code from qemuHostdevPrepareSCSIDevices
-  qemu: numa: Don't return automatic nodeset for inactive domain
-  qemu: Ignore missing query-migrate-parameters
-  daemon: Fix domain name leak in error path
-  qemu: fix argument of virDomainNetGetActualDirectMode
-  rpc: fix keep alive timer segfault
-  util: allow ignoring SIOCSIFHWADDR when errno is EPERM
-  util: check ifa_addr pointer before accessing its elements
-  Increase default task limit for libvirtd
-  Fix error reporting when poll returns POLLHUP/POLLERR
-  spec: Avoid RPM verification errors on nwfilter XMLs
-  xenconfig: avoid double free on OOM testing
-  xenFormatXLDomainDisks: avoid double free on OOM testing
-  virConfSaveValue: protect against a NULL pointer reference
-  conf: Add check for non scsi_host parent during vport delete
-  util: Fix resource leak
-  test: Remove unused variate @maxcpu in testDomainGetVcpus
-  esx: Fix memory leak
-  esx: Fix incorrect memory compare size in esxStoragePoolLookupByUUID
-  qemu: snapshot: Skip empty drives with internal snapshots
-  qemu: do not crash on USB address with no port and invalid bus
-  man: Align vol-resize arguments with the output of help
-  qemu: conf: Don't leak snapshot image format conf variable
-  qemu: Fix mdev checking for VFIO support
-  util: systemd: Don't strlen a possibly NULL string
-  interface: Fix resource leak in netcfConnectListAllInterfaces error
   path
-  virsh: don't leak @cpumap in virshVcpuPinQuery
-  tests: fix some resource leaks
-  rpc: fix resource leak
-  src: fix multiple resource leaks in loops
-  conf/domain_capabilities: fix resource leak
-  qemu: Fix two use-after-free situations
-  disk: Force usage of parted when checking disk format for "bsd"
-  disk: Resolve issues with disk partition build/start checks
-  conf: create new RemovalFailed event using correct class
-  qemu: fix memory leak and check mdevPath
-  qemu: Properly reset TLS in qemuProcessRecoverMigrationIn
-  Properly ignore files in build-aux directory
-  conf: Fix possible memleak in capabilities
-  Split out -Wframe-larger-than warning from WARN_CLFAGS
-  virISCSIGetSession: Don't leak memory
-  virStorageSourceClear: Don't leave dangling pointers behind
-  qemu: Break endless loop if qemuMigrationResetTLS fails
-  storage: gluster: Implement 'checkPool' method so that state is
   restored
-  docs: Document limitation of maximum vcpu count used with <topology>
-  qemu: Fix resource leak in qemuDomainAddChardevTLSObjects error path
-  qemu: Initialize 'data' argument
-  storage: util: Pass pool type to
   virStorageBackendFindGlusterPoolSources
-  util: ignore -Wcast-align in virNetlinkDumpCommand
-  qemu: hotplug: Clear vcpu ordering for coldplug of vcpus
-  qemu: hotplug: Fix formatting strings in
   qemuDomainFilterHotplugVcpuEntities
-  qemu: hotplug: Iterate over vcpu 0 in individual vcpu hotplug code
-  qemu: Add device id for mediated devices on qemu command line
-  storage: Fix capacity value for LUKS encrypted volumes
-  virNetDevIPCheckIPv6ForwardingCallback fixes
-  storage: driver: Remove unavailable transient pools after restart
-  storage: driver: Split out code fixing pool state after deactivation
-  storage: backend: Use correct stringifier for pool type
-  mdev: Fix daemon crash on domain shutdown after reconnect
-  util: mdev: Use a local variable instead of a direct pointer access
-  qemu: Fix regression when hyperv/vendor_id feature is used
-  vz: fix typo that breaks build



2.2 series
----------


2.2.1 (May 10 2017)
~~~~~~~~~~~~~~~~~~~

`Download
libvirt-2.2.1 <http://libvirt.org/sources/stable_updates/libvirt-2.2.1.tar.xz>`__

Changes in this version:

-  spec: Avoid RPM verification errors on nwfilter XMLs
-  qemu_process: spice: don't release used port
-  qemu: Fix crash during qemuStateCleanup
-  daemon: Fix crash during daemon cleanup
-  Fix crash on usb-serial hotplug
-  qemuBuildMemoryBackendStr: Don't crash if no hugetlbfs is mounted
-  util: fix crash in virClassIsDerivedFrom for CloseCallbacks objects
-  storage: driver: Remove unavailable transient pools after restart
-  storage: driver: Split out code fixing pool state after deactivation
-  qemu: Don't assume secret provided for LUKS encryption
-  conf: do not steal pointers from the pool source
-  schema: do not require name for certain pool types
-  virtlogd: Don't stop or restart along with libvirtd
-  virtlogd.socket: Tie lifecycle to libvirtd.service
-  spec: Update version check for maint Source URL
-  qemu: capabilities: Don't partially reprope caps on process reconnect
-  network: fix endless loop when starting network with multiple IPs and
   no dhcp
-  qemu: allow 32 slots on pcie-expander-bus, not just 1
-  qemu: Only use memory-backend-file with NUMA if needed



1.3.3 series
------------


1.3.3.3 (May 10 2017)
~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.3.3.3 <http://libvirt.org/sources/stable_updates/libvirt-1.3.3.3.tar.gz>`__

Changes in this version:

-  virtlogd: Don't stop or restart along with libvirtd
-  virtlogd.socket: Tie lifecycle to libvirtd.service
-  schema: Don't validate paths
-  maint: fix syntax-check sc_prohibit_int_ijk exclude rule
-  util: bitmap: clarify virBitmapLastSetBit() behavior for empty
   bitmaps
-  Fix building with -Og
-  qemu: Only use memory-backend-file with NUMA if needed

1.3.3.2 (July 18 2016)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.3.3.2 <http://libvirt.org/sources/stable_updates/libvirt-1.3.3.2.tar.gz>`__

Changes in this version:

-  spec: Fix indentation
-  conf: Allow disks with identical WWN or serial
-  libvirt.spec.in: require systemd-container on >= f24
-  qemu: SCSI hostdev hot-plug: Fix automatic creation of SCSI
   controllers
-  qemu: hot-plug: Fix broken SCSI disk hot-plug
-  qemu: Let empty default VNC password work as documented
-  virCgroupValidateMachineGroup: Reflect change in CGroup struct naming
-  spec: Advertise nvram paths of official fedora edk2 builds
-  qemu: hotplug: wait for the tray to eject only for drives with a tray
-  qemu: hotplug: Fix error reported when cdrom tray is locked
-  qemu: hotplug: Extract code for waiting for tray eject
-  qemu: hotplug: Report error if we hit tray status timeout
-  qemu: hotplug: Skip waiting for tray opening if qemu doesn't notify
   us
-  qemu: process: Fix and improve disk data extraction
-  qemu: Move and rename qemuDomainCheckEjectableMedia to
   qemuProcessRefreshDisks
-  qemu: Extract more information about qemu drives
-  qemu: Move struct qemuDomainDiskInfo to qemu_domain.h
-  qemu: process: Refresh ejectable media tray state on VM start
-  iscsi: Remove initiatoriqn from virISCSIScanTargets
-  util: Remove disabling of autologin for iscsi-targets
-  iscsi: Add exit status checking for virISCSIGetSession
-  util: Add exitstatus parameter to virCommandRunRegex
-  xlconfigtests: use qemu-xen in all test data files
-  libxl: don't attempt to probe a non-existent emulator
-  Fix tests to include video ram size
-  Fill out default vram in DeviceDefPostParse
-  Call per-device post-parse callback even on implicit video
-  Move virDomainDefPostParseInternal after virDomainDeviceDefPostParse
-  conf: use VIR_APPEND_ELEMENT in virDomainDefAddImplicitVideo
-  conf: reduce indentation in virDomainDefAddImplicitVideo
-  domain_conf: fix migration/managedsave with usb keyboard

1.3.3.1 (May 04 2016)
~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.3.3.1 <http://libvirt.org/sources/stable_updates/libvirt-1.3.3.1.tar.gz>`__

Changes in this version:

-  spec: Use proper indentation
-  libvirt.spec: remove duplicate files from -docs package
-  network: Fix segfault on daemon reload
-  send default USB controller in xml to destination during migration
-  virsh: Fix support for 64 migration options
-  qemu: Regenerate VNC socket paths
-  qemu: conf: Set default logging approach in virQEMUDriverConfigNew
-  qemu: Unref cfg in qemuDomainDefPostParse
-  spec: If installing default network, restart libvirtd
-  qemu: fix error log in qemuAssignPCIAddresses()
-  virsh: host: Use bitmap size in bytes rather than bit count
-  qemu: Fix off-by-one error in block I/O throttle messages
-  conf: Drop restrictions on rng backend path
-  vbox: VIR_WARN if we don't support the API version
-  qemu: Limit maximum block device I/O tune values
-  virconf: Handle conf file without ending newline
-  network: fix DHCPv6 on networks with prefix != 64
-  rpc: Don't leak fd via CreateXMLWithFiles
-  libvirt: Fix crash on URI without scheme
-  tests: fix xen-related tests
-  man: Clarify virsh vol-clone works within a single pool
-  network: Don't use ERR_NO_SUPPORT for invalid net-update requests
-  Revert "daemon: use socket activation with systemd"
-  Explicitly error on uri=qemu://system
-  lxc: explicitly error on interface type=ethernet
-  tests: Fix syntax in iSCSI auth/secret tests
-  Libvirt: virTypedParamsValidate: Fix detection of multiple parameters
-  Resolve a couple of memory leaks
-  libxl: use LIBXL_API_VERSION 0x040200
-  Add functions for handling exponential backoff loops.
-  spec: Only pull in API docs with -devel package
-  util: Add virGettextInitialize, convert the code
-  man: virsh: Document lxc-enter-namespace --noseclabel
-  storage: mpath: Don't error on target_type=NULL
-  qemu: command: don't overwrite watchdog dump action
-  rpc: daemon: Fix virtlog/virtlock daemon reload
-  conf: also mark the implicit video as primary
-  conf: move default video addition after XML parsing
-  virtlogd: Fix a couple minor memory leaks
-  qemu: Free priv->machineName
-  configure: Fix check for --with-login-shell on Windows
-  util: move ENODATA redefine to internal.h
-  libxl: libxl_domain_create_restore has an extra argument
-  qemu: perf: Fix crash/memory corruption on failed VM start
-  qemu: alias: Fix calculation of memory device aliases
-  Link libvirt_xenconfig instead of libvirt against libxl
-  virt-admin: get rid of LIBVIRT_DEFAULT_ADMIN_URI env var
-  libvirt-admin: do not crash on URI without a scheme
-  virsh: read default connection uri from env later
-  build: add GCC 6.0 -Wlogical-op workaround
-  build: cleanup GCC < 4.6 -Wlogical-op workaround
-  qemu: support virt-2.6 machine type on arm



1.2.18 series
-------------


1.2.18.4 (July 18 2016)
~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.2.18.4 <http://libvirt.org/sources/stable_updates/libvirt-1.2.18.4.tar.gz>`__

Changes in this version:

-  qemu: Let empty default VNC password work as documented
-  spec: Fix error in last backport
-  spec: Advertise nvram paths of official fedora edk2 builds


1.2.18.3 (May 04 2016)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.2.18.3 <http://libvirt.org/sources/stable_updates/libvirt-1.2.18.3.tar.gz>`__

Changes in this version:

-  spec: Use proper indentation
-  spec: If installing default network, restart libvirtd
-  rpc: Don't leak fd via CreateXMLWithFiles
-  libvirt.spec: remove duplicate files from -docs package
-  wireshark: Fix header of get_message_len()
-  wireshark: Replace WIRESHARK_COMPAT with actual version comparison
-  wireshark: s/tvb_length/tvb_captured_length/
-  wireshark: s/ep_alloc/wmem_alloc/
-  wireshark: s/proto_tree_add_text/proto_tree_add_item/
-  spec: Only pull in API docs with -devel package
-  build: accomodate selinux 2.5 header API change
-  build: add GCC 6.0 -Wlogical-op workaround
-  build: cleanup GCC < 4.6 -Wlogical-op workaround
-  lxc: don't try to hide parent cgroups inside container
-  driver: log missing modules as INFO, not WARN
-  rpc: wait longer for session daemon to start up
-  util: virfile: Only setuid for virFileRemove if on NFS
-  util: virfile: Clarify setuid usage for virFileRemove
-  lxc: fuse: Stub out Slab bits in /proc/meminfo
-  lxc: fuse: Fill in MemAvailable for /proc/meminfo
-  lxc: fuse: Fix /proc/meminfo size calculation
-  lxc: fuse: Unindent meminfo logic
-  virfile: Fix error path for forked virFileRemove
-  security: Do not restore kernel and initrd labels
-  rpc: socket: Don't repeatedly attempt to launch daemon
-  rpc: socket: Explicitly error if we exceed retry count
-  rpc: socket: Minor cleanups
-  build: predictably generate systemtap tapsets (bz 1173641)
-  leaseshelper: fix crash when no mac is specified
-  schema: interleave domain name and uuid with other elements

1.2.18.2 (December 23 2015)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.2.18.2 <http://libvirt.org/sources/stable_updates/libvirt-1.2.18.2.tar.gz>`__

Changes in this version:

-  Fix a trailing space in spec file
-  virsh: report errors for empty strings
-  bridge: check for invalid MAC in networkGetDHCPLeases
-  Enhance documentation of virDomainDetachDevice
-  apparmor: add missing qemu binaries
-  qemu: Use live autoNodeset when numatune placement is auto
-  Close the source fd if the destination qemu exits during tunnelled
   migration
-  storage: Fix incorrect format for <disk> <auth> XML
-  virt-host-validate: distinguish exists vs accessible for devices
-  spec: Delete .git after applying patches
-  apparmor: differentiate between error and unconfined profiles
-  storage: Adjust calculation of alloc/capacity for disk
-  qemu: Add conditions for qemu-kvm use on ppc64
-  rpc: libssh2: Fix regression in ssh host key verification
-  rpc: libssh2: Add more debugging info
-  Update pool allocation with new values on volume creation
-  Use daemon log facility for journald
-  virDomainCreateXML: Make domain definition transient
-  virDomainCreateXML: Don't remove persistent domains on error
-  qemu: Refresh memory size only on fresh starts
-  domain: Fix migratable XML with graphics/@listen
-  tpm: adapt sysfs cancel path for new TPM driver
-  libvirt-guests: Disable shutdown timeout
-  systemd: Escape only needed characters for machined
-  systemd: Escape machine name for machined
-  CVE-2015-5313: storage: don't allow '/' in filesystem volume names
-  docs: event impl. registration before hypervisor connection
-  spec: Fix some warnings with latest rpmbuild
-  qemu: Fix dynamic_ownership qemu.conf setting

1.2.18.1 (September 21 2015)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.2.18.1 <http://libvirt.org/sources/stable_updates/libvirt-1.2.18.1.tar.gz>`__

Changes in this version:

-  test driver: don't unlock pool after freeing it
-  libxl: fix AttachDeviceConfig on hostdev type
-  security_selinux: Take @privileged into account
-  selinux: fix compile errors
-  security_selinux: Add SetDirLabel support
-  security: Add virSecurityDomainSetDirLabel
-  security_selinux: Use proper structure to access socket data
-  security_selinux: Replace SELinuxSCSICallbackData with proper struct
-  virSecuritySELinuxSetSecurityAllLabel: drop useless
   virFileIsSharedFSType
-  virSecurityManager: Track if running as privileged
-  qemu: hotplug: Properly clean up drive backend if frontend hotplug
   fails
-  xen: fix race in refresh of config cache
-  libxl: don't end job for ephemeal domain on start failure
-  conf: fix crash when parsing a unordered NUMA <cell/>
-  qemu: Check virGetLastError return value for migration finish failure
-  libxl: don't overwrite error from virNetSocketNewConnectTCP()
-  domain-conf: escape string for socket attribute
-  src: Check for symbols ordering in ADMIN_SYM_FILES
-  src: Cleanup libvirt_admin.syms
-  src: Check libvirt_admin.syms for exported symbols
-  util: fallback to ioctl(SIOCBRDELBR) if netlink RTM_DELLINK fails
-  util: fallback to ioctl(SIOCBRADDBR) if netlink RTM_NEWLINK fails
-  libxl: acquire a job when receiving a migrating domain
-  libxl: don't attempt to resume domain when suspend fails
-  libxl: fix ref counting of libxlMigrationDstArgs
-  libvirt_lxc: Claim success for --help
-  virt-aa-helper: Improve valid_path
-  qemu: Emit correct audit message for memory hot unplug
-  qemu: Emit correct audit message for memory hot plug
-  hostdev: skip ACS check when using VFIO for device assignment
-  Start daemon only after filesystems are mounted
-  virt-aa-helper: add NVRAM store file for read/write
-  qemu: Update blkio.weight value after successful set
-  Eliminate incorrect and unnecessary check for changed IP address
-  virt-aa-helper: allow access to /usr/share/ovmf/
-  virt-aa-helper: Simplify restriction logic
-  virt-aa-helper: document --probing and --dry-run
-  Add generated libvirt_admin.syms into .gitignore
-  libvirt-admin: Generate symbols file
-  daemon: Use $(NULL) for libvird_admin's flags
-  qemu: Add check for invalid iothread_id in qemuDomainChgIOThread
-  virsh: Reset global error after successfull domain lookup
-  build: fix mingw build
-  Detect location of qemu-bridge-helper
-  Check if qemu-bridge-helper exists and is executable
-  qemu: Use numad information when getting pin information
-  qemu: Keep numad hint after daemon restart
-  conf: Pass private data to Parse function of XML options
-  qemu: Fix segfault when parsing private domain data
-  domain: Fix crash if trying to live update disk <serial>
-  virNetSocketCheckProtocols: handle EAI_NONAME as IPv6 unavailable
-  util: don't overwrite stack when getting ethtool gfeatures
-  conf: Don't try formating non-existing addresses
-  admin: Drop 'internal.h' include from libvirt-admin.h
-  qemu: fail on attempts to use <filterref> for non-tap network
   connections
-  network: validate network NAT range
-  virNetDevBandwidthParseRate: Reject negative values
-  network: verify proper address family in updates to <host> and
   <range>
-  conf: more useful error message when pci function is out of range
-  virDomainDefParseXML: Check for malicious cpu ids in <numa/>
-  numa_conf: Introduce virDomainNumaGetMaxCPUID
-  Allow vfio hotplug of a device to the domain which owns the iommu
-  qemu: Forbid image pre-creation for non-shared storage migration
-  virsh: fix domfsinfo output in quiet mode
-  tests: extend workaround for gnutls private key loading failure
-  qemu: fix some api cannot work when disable cpuset in conf
-  storage: only run safezero if allocation is > 0
-  qemu: command: Report stderr from qemu-bridge-helper
-  qemu: Fix reporting of physical capacity for block devices
-  remoteClientCloseFunc: Don't mangle connection object refcount
-  storage: Correct the 'mode' check
-  storage: Handle failure from refreshVol
-  virfile: Introduce virFileUnlink
-  Revert "LXC: show used memory as 0 when domain is not active"



1.2.13 series
-------------


1.2.13.2 (December 23 2015)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.2.13.2 <http://libvirt.org/sources/stable_updates/libvirt-1.2.13.2.tar.gz>`__

Changes in this version:

-  spec: Delete .git after applying patches
-  qemu: block-commit: Mark disk in block jobs only on successful
   command
-  qemu: Disallow concurrent block jobs on a single disk
-  qemu: event: Don't fiddle with disk backing trees without a job
-  qemu: process: Export qemuProcessFindDomainDiskByAlias
-  spec: Fix polkit dep on F23
-  domain: Fix migratable XML with graphics/@listen
-  qemu: hotplug: Properly clean up drive backend if frontend hotplug
   fails
-  tpm: adapt sysfs cancel path for new TPM driver
-  libvirt-guests: Disable shutdown timeout
-  systemd: Escape only needed characters for machined
-  systemd: Escape machine name for machined
-  cgroup: Drop resource partition from virSystemdMakeScopeName
-  CVE-2015-5313: storage: don't allow '/' in filesystem volume names
-  remoteClientCloseFunc: Don't mangle connection object refcount
-  Revert "LXC: show used memory as 0 when domain is not active"
-  lxc: Don't pass a local variable address randomly
-  lxc: set nosuid+nodev+noexec flags on /proc/sys mount
-  virnetdev: fix moving of 802.11 phys
-  interface: don't error out if a bond has no interfaces
-  lxc: don't up the veth interfaces unless explicitly asked to
-  tests: Add virnetdevtestdata to EXTRA_DIST
-  lxc: move wireless PHYs to a network namespace
-  Cleanup "/sys/class/net" usage
-  Introduce virnetdevtest
-  build: provide virNetDevSysfsFile on non-Linux

1.2.13.1 (April 28 2015)
~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.2.13.1 <http://libvirt.org/sources/stable_updates/libvirt-1.2.13.1.tar.gz>`__

Changes in this version:

-  Fix memory leak in virNetSocketNewConnectUNIX
-  rng: fix port number range validation
-  qemu: Don't fail to reboot domains with unresponsive agent
-  vircommand: fix polling in virCommandProcessIO
-  util: storage: Fix possible crash when source path is NULL
-  qemu: set macvtap physdevs online when macvtap is set online
-  util: set MAC address for VF via netlink message to PF+VF# when
   possible
-  xend: Remove a couple of unused function prototypes.
-  qemuDomainShutdownFlags: Set fakeReboot more frequently
-  nwfilter: Partly initialize driver even for non-privileged users
-  virNetSocketNewConnectUNIX: Don't unlink(NULL)
-  sanlock: Use VIR_ERR_RESOURCE_BUSY if sanlock_acquire fails
-  qemuMigrationPrecreateStorage: Fix debug message
-  qemu_migration.c: sleep first before checking for migration status.
-  qemu_driver: check caps after starting block job
-  qemu_migrate: use nested job when adding NBD to cookie
-  util: fix removal of callbacks in virCloseCallbacksRun
-  qemu: fix race between disk mirror fail and cancel
-  qemu: fix error propagation in qemuMigrationBegin
-  qemu: fix crash in qemuProcessAutoDestroy
-  qemu: blockCopy: Pass adjusted bandwidth when called via blockRebase
-  virsh: blockCopy: Add missing jump on error path
-  qemu: end the job when try to blockcopy to non-file destination
-  nodeinfo: Increase the num of CPU thread siblings to a larger value
-  relaxng: allow : in /dev/disk/by-path names
-  qemu: Give hint about -noTSX CPU model
-  build: fix race when creating the cpu_map.xml symlink
-  Don't validata filesystem target type
-  Document behavior of compat when creating qcow2 volumes
-  Fix typo in error message
-  qemu: change accidental VIR_WARNING back to VIR_DEBUG
-  conf: fix parsing of NUMA settings in VM status XML
-  qemu: skip precreation of network disks
-  qemu: do not overwrite the error in qemuDomainObjExitMonitor
-  libxl: Don't overwrite errors from xenconfig
-  util: more verbose error when failing to create macvtap device
-  qemu: hotplug: Use checker function to check if disk is empty
-  qemu: driver: Fix cold-update of removable storage devices
-  qemu: Check for negative port values in network drive configuration
-  virsh: fix report of non-active commit completion
-  util: don't fail if no PortData is found while getting migrateData
-  Clarify the meaning of version in redirdev filters
-  xenapi: Resolve Coverity REVERSE_INULL
-  xenapi: Resolve Coverity REVERSE_INULL
-  xenapi: Resolve Coverity NULL_RETURNS
-  xenapi: Resolve Coverity NO_EFFECT
-  xenapi: Resolve Coverity FORWARD_NULL
-  RNG: Allow multiple parameters to be passed to an interface filter
-  domain_conf: fix crash in virDomainObjListFindByUUIDInternal
-  {domain, network}_conf: disable autostart when deleting config
-  qemu: Remove unnecessary virReportError on networkGetNetworkAddress
   return
-  virQEMUCapsInitQMP: Don't dispose locked @vm
-  qemu: fix memory leak in qemuAgentGetFSInfo
-  docs: add a note that spice channel is usable only with spice
   graphics
-  locking: Fix flags in virLockManagerLockDaemonNew
-  tests: fix qemuxml2argvtest to be arch independent
-  tests: Add test for virtio-mmio address type
-  qemu: Allow spaces in disk serial
-  storage: tweak condition to properly test lseek
-  virsh: tweak domif-getlink link state reporting message
-  qemu: snapshot: Don't skip check for qcow2 format with network disks
-  networkLookupByUUID: Improve error message
-  qemuProcessReconnect: Fill in pid file path
-  tests : Add test for 'ppc64le' architecture.
-  RNG: Add 'ppc64le' arch and newer pseries-2.\* machine types
-  schema: Fix interface link state schema
-  conf: De-duplicate scheduling policy enums
-  qemu: Don't crash in qemuDomainOpenChannel()
-  virsh.pod: Update find-storage-pool-sources[-as] man page
-  iscsi: Adjust error message for findStorageSources backend
-  virsh.pod: Add information regarding LXC for setmem, memtune, and
   dominfo
-  docs: add a note that attr 'managed' is only used by PCI devices
-  Check if domain is running in qemuDomainAgentIsAvailable
-  Pass virDomainObjPtr to qemuDomainAgentAvailable
-  Check for qemu guest agent availability after getting the job
-  storage: fs: Ignore volumes that fail to open with EACCESS/EPERM
-  domain: conf: Don't validate VM ostype/arch at daemon startup
-  domain: conf: Better errors on bad os <type> values
-  spec: Point fedora --with-loader-nvram at nightly firmware repo
-  configure: Report --with-loader-nvram value in summary
-  configure: Fix --loader-nvram typo
-  cpu: Add {Haswell,Broadwell}-noTSX CPU models
-  domcaps: Check for architecture more wisely
-  daemon: Clear fake domain def object that is used to check ACL prior
   to use
-  util: identity: Harden virIdentitySetCurrent()
-  qemu: Always refresh capabilities if no <guests> found
-  qemu: Build nvram directory at driver startup
-  qemu: Build channel autosocket directory at driver startup
-  virQEMUDriverGetConfig: Fix memleak
-  qemu: chown autoDumpPath on driver startup
-  qemu: conf: Clarify paths that are relative to libDir
-  Strip control codes in virBufferEscapeString
-  util: buffer: Add support for adding text blocks with indentation
-  Ignore storage volumes with control codes in their names
-  Strip control characters from sysfs attributes
-  Add functions dealing with control characters in strings
-  tests: rename testStripIPv6BracketsData to testStripData
-  lxc: fix starting a domain with non-strict numa memory mode
-  lxc: fix starting a domain with a cpuset but no numatune
-  virsh: fix regression in 'virsh event' by domain
-  virsh: Improve change-media success message
-  virNetSocketNewConnectUNIX: Use flocks when spawning a daemon
-  rpc: Don't unref identity object while callbacks still can be
   executed
-  lxc: create the required directories upon driver start
-  qemu: read backing chain names from qemu
-  daemon: avoid memleak when ListAll returns nothing
-  qemu: don't fill in nicindexes for session mode libvirtd



1.2.9 series
------------


1.2.9.3 (April 28 2015)
~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.2.9.3 <http://libvirt.org/sources/stable_updates/libvirt-1.2.9.3.tar.gz>`__

Changes in this version:

-  storage: fs: Ignore volumes that fail to open with EACCESS/EPERM
-  domain: conf: Don't validate VM ostype/arch at daemon startup
-  domain: conf: Better errors on bad os <type> values
-  Report original error when QMP probing fails with new QEMU
-  cpu: Add {Haswell,Broadwell}-noTSX CPU models
-  storage: qemu: Fix security labelling of new image chain elements
-  Ignore CPU features without a model for host-passthrough
-  Do not format CPU features without a model
-  domcaps: Check for architecture more wisely
-  daemon: Clear fake domain def object that is used to check ACL prior
   to use
-  util: identity: Harden virIdentitySetCurrent()
-  qemu: Build nvram directory at driver startup
-  qemu: Build channel autosocket directory at driver startup
-  qemu: chown autoDumpPath on driver startup
-  qemu: conf: Clarify paths that are relative to libDir
-  avoid using deprecated udev logging functions
-  qemu: Always refresh capabilities if no <guests> found
-  qemu: move setting emulatorpin ahead of monitor showing up
-  rpc: Don't unref identity object while callbacks still can be
   executed
-  conf: tests: fix virDomainNetDefFormat for vhost-user in client mode
-  Document that USB hostdevs do not need nodeDettach
-  Document behavior of compat when creating qcow2 volumes
-  Clarify the meaning of version in redirdev filters
-  Strip control codes in virBufferEscapeString
-  Ignore storage volumes with control codes in their names
-  Strip control characters from sysfs attributes
-  Add functions dealing with control characters in strings
-  virNetworkDefUpdateIPDHCPHost: Don't crash when updating network
-  daemon: avoid memleak when ListAll returns nothing
-  conf: error out on missing dhcp host attributes
-  conf: error out on invalid host id
-  conf: Don't format actual network definition in migratable XML
-  conf: Fix libvirtd crash and memory leak caused by
   virDomainVcpuPinDel()

1.2.9.2 (February 07 2015)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.2.9.2 <http://libvirt.org/sources/stable_updates/libvirt-1.2.9.2.tar.gz>`__

Changes in this version:

-  util: storage: Fix parsing of nbd:// URI without path
-  qemu: fix domain startup failing with 'strict' mode in numatune
-  storage: Need to clear pool prior to refreshPool during Autostart
-  xend: Don't crash in virDomainXMLDevID
-  CVE-2015-0236: qemu: Check ACLs when dumping security info from
   snapshots
-  CVE-2015-0236: qemu: Check ACLs when dumping security info from save
   image
-  conf: goto error when value of max_sectors is too large
-  Fix hotplugging of block device-backed usb disks
-  conf: fix crash when hotplug a channel chr device with no target
-  qemu: migration: Unlock vm on failed ACL check in protocol v2 APIs
-  storage: fix crash caused by no check return before set close
-  qemu: bulk stats: Fix logic in monitor handling
-  CVE-2014-8131: Fix possible deadlock and segfault in
   qemuConnectGetAllDomainStats()
-  qemu: Drop OVMF whitelist
-  qemu: Support OVMF on armv7l aarch64 guests

1.2.9.1 (November 15 2014)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.2.9.1 <http://libvirt.org/sources/stable_updates/libvirt-1.2.9.1.tar.gz>`__

Changes in this version:

-  qemu: Don't try to parse -help for new QEMU
-  qemu: Always set migration capabilities
-  nwfilter: fix deadlock caused updating network device and nwfilter
-  qemuPrepareNVRAM: Save domain conf only if domain's persistent
-  Do not crash on gluster snapshots with no host name
-  Display nicer error message for unsupported chardev hotplug
-  Fix virDomainChrEquals for spicevmc
-  qemu: Update fsfreeze status on domain state transitions
-  network: fix call virNetworkEventLifecycleNew when
   networkStartNetwork fail
-  Require at least one console for LXC domain
-  Do not probe for power mgmt capabilities in lxc emulator
-  util: fix releasing pidfile in cleanup
-  qemu: stop NBD server after successful migration
-  qemu: make sure capability probing process can start
-  util: Introduce virPidFileForceCleanupPath
-  qemu: make advice from numad available when building commandline
-  qemu: Release nbd port from migrationPorts instead of remotePorts
-  qemu: better error message when block job can't succeed
-  test: Add test to verify helpers used for backing file name parsing
-  storage: Fix crash when parsing backing store URI with schema
-  remote: fix jump depends on uninitialised value
-  qemu_agent: Produce more readable error messages
-  qemu: forbid snapshot-delete --children-only on external snapshot
-  tests: Add SELINUX_LIBS to fix viridentitytest linker bug
-  qemu: migration: Make check for empty hook XML robust
-  qemu: restore: Fix restoring of VM when the restore hook returns
   empty XML
-  util: string: Add helper to check whether string is empty
-  virsh: domain: Use global constant for XML file size limit
-  qemu: Fix hot unplug of SCSI_HOST device
-  qemu: unref cfg after TerminateMachine has been called
-  Add virCgroupTerminateMachine stub
-  qemu: use systemd's TerminateMachine to kill all processes
-  util: Prepare URI formatting for libxml2 >= 2.9.2
-  security_selinux: Don't relabel /dev/net/tun
-  util: eliminate "use after free" in callers of virNetDevLinkDump
-  CVE-2014-7823: dumpxml: security hole with migratable flag
-  qemu: x86_64 is good enough for i686
-  qemu: Don't compare CPU against host for TCG
-  qemu_command: Split qemuBuildCpuArgStr



1.1.3 series
------------


1.1.3.9 (February 07 2015)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.1.3.9 <http://libvirt.org/sources/stable_updates/libvirt-1.1.3.9.tar.gz>`__

Changes in this version:

-  CVE-2015-0236: qemu: Check ACLs when dumping security info from
   snapshots
-  CVE-2015-0236: qemu: Check ACLs when dumping security info from save
   image
-  qemu: migration: Unlock vm on failed ACL check in protocol v2 APIs


1.1.3.8 (November 15 2014)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.1.3.8 <http://libvirt.org/sources/stable_updates/libvirt-1.1.3.8.tar.gz>`__

Changes in this version:

-  tests: Fix compilation


1.1.3.7 (November 15 2014)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.1.3.7 <http://libvirt.org/sources/stable_updates/libvirt-1.1.3.7.tar.gz>`__

Changes in this version:

-  CVE-2014-7823: dumpxml: security hole with migratable flag
-  node_device_udev: Try harder to get human readable vendor:product
-  tests: don't fail with newer gnutls
-  Fix crash in virsystemdtest with dbus 1.7.6
-  domain_conf: fix domain deadlock
-  CVE-2014-3633: qemu: blkiotune: Use correct definition when looking
   up disk

1.1.3.6 (September 08 2014)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.1.3.6 <http://libvirt.org/sources/stable_updates/libvirt-1.1.3.6.tar.gz>`__

Changes in this version:

-  fix api changes in xen restore
-  maint: fix typo in previous patch
-  maint: cleanup detection of const'ness of selinux ctx
-  build: fix build with libselinux 2.3
-  virerror: Fix an error message typo
-  storage: Report error from VolOpen by default
-  storage: Rename VolOpenCheckMode to VolOpen
-  storage: move block format lookup to shared UpdateVolInfo
-  storage: Rename UpdateVolInfoFlags to UpdateVolInfo
-  LXC: fix the problem that libvirt lxc fail to start on latest kernel
-  Fix pci bus naming for PPC
-  libxl: Check for control_d string to decide about dom0
-  Free ifname in testDomainGenerateIfnames
-  Don't include @LIBS@ in libvirt.pc.in file
-  qemu: copy: Accept 'format' parameter when copying to a non-existing
   img
-  build: fix 'make check' with newer git
-  docs: publish correct enum values
-  qemu: blockcopy: Don't remove existing disk mirror info
-  LSN-2014-0003: Don't expand entities when parsing XML
-  libxl: fix framebuffer port setting for HVM domains

1.1.3.5 (May 03 2014)
~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.1.3.5 <http://libvirt.org/sources/stable_updates/libvirt-1.1.3.5.tar.gz>`__

Changes in this version:

-  qemu: Introduce qemuDomainDefCheckABIStability
-  interface: dump inactive xml when interface isn't active
-  interface: Introduce netcfInterfaceObjIsActive
-  Ignore additional fields in iscsiadm output
-  qemu: fix crash when removing <filterref> from interface with
   update-device
-  Only set QEMU_CAPS_NO_HPET on x86
-  Fix journald PRIORITY values
-  qemu: make sure agent returns error when required data are missing
-  qemu: remove unneeded forward declaration
-  qemu: cleanup error checking on agent replies
-  Ignore char devices in storage pools by default
-  Ignore missing files on pool refresh
-  storage: reduce number of stat calls
-  Fix explicit usage of default video PCI slots
-  virNetClientSetTLSSession: Restore original signal mask
-  storage: use valid XML for awkward volume names
-  maint: fix comma style issues: conf
-  virNetServerRun: Notify systemd that we're accepting clients
-  libvirt-guests: Wait for libvirtd to initialize
-  virSystemdCreateMachine: Set dependencies for slices
-  Add Documentation fields to systemd service files
-  Add a mutex to serialize updates to firewall
-  virt-login-shell: also build virAtomic.h
-  Fix conflicting types of virInitctlSetRunLevel

1.1.3.4 (February 18 2014)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.1.3.4 <http://libvirt.org/sources/stable_updates/libvirt-1.1.3.4.tar.gz>`__

Changes in this version:

-  CVE-2013-6456: Avoid unsafe use of /proc/$PID/root in LXC hotunplug
   code
-  CVE-2013-6456: Avoid unsafe use of /proc/$PID/root in LXC chardev
   hostdev hotplug
-  CVE-2013-6456: Avoid unsafe use of /proc/$PID/root in LXC block
   hostdev hotplug
-  CVE-2013-6456: Avoid unsafe use of /proc/$PID/root in LXC USB hotplug
-  CVE-2013-6456: Avoid unsafe use of /proc/$PID/root in LXC disk
   hotplug
-  CVE-2013-6456: Avoid unsafe use of /proc/$PID/root in LXC
   shutdown/reboot code
-  Add helper for running code in separate namespaces
-  Add virFileMakeParentPath helper function
-  Move check for cgroup devices ACL upfront in LXC hotplug
-  Disks are always block devices, never character devices
-  Fix reset of cgroup when detaching USB device from LXC guests
-  Record hotplugged USB device in LXC live guest config
-  Fix path used for USB device attach with LXC
-  Don't block use of USB with containers
-  storage: avoid short reads while chasing backing chain
-  event: move event filtering to daemon (regression fix)
-  Push nwfilter update locking up to top level
-  Add a read/write lock implementation
-  tests: Add more tests for virConnectBaselineCPU
-  cpu: Try to use source CPU model in virConnectBaselineCPU
-  cpu: Fix VIR_CONNECT_BASELINE_CPU_EXPAND_FEATURES
-  tests: Better support for VIR_CONNECT_BASELINE_CPU_EXPAND_FEATURES
-  qemu: Change the default unix monitor timeout

1.1.3.3 (January 16 2014)
~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.1.3.3 <http://libvirt.org/sources/stable_updates/libvirt-1.1.3.3.tar.gz>`__

Changes in this version:

-  virt-login-shell: fix regressions in behavior
-  Fix race leading to crash when setting up dbus watches
-  event: filter global events by domain:getattr ACL [CVE-2014-0028]
-  Fix memory leak in virObjectEventCallbackListRemoveID()
-  virDomainEventCallbackListFree: Don't leak @list->callbacks
-  Really don't crash if a connection closes early
-  Don't crash if a connection closes early
-  qemu: Fix job usage in virDomainGetBlockIoTune
-  qemu: Fix job usage in qemuDomainBlockCopy
-  qemu: Fix job usage in qemuDomainBlockJobImpl
-  qemu: Avoid using stale data in virDomainGetBlockInfo
-  qemu: Do not access stale data in virDomainBlockStats
-  qemu: clean up migration ports when migration cancelled
-  qemu: Fix augeas support for migration ports
-  qemu: Make migration port range configurable
-  qemu: Avoid assigning unavailable migration ports
-  libxl: avoid crashing if calling \`virsh numatune' on inactive domain
-  Fix crash in lxcDomainSetMemoryParameters
-  CVE-2013-6436: fix crash in lxcDomainGetMemoryParameters

1.1.3.2 (December 14 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.1.3.2 <http://libvirt.org/sources/stable_updates/libvirt-1.1.3.2.tar.gz>`__

Changes in this version:

-  Tie SASL callbacks lifecycle to virNetSessionSASLContext
-  spec: Don't save/restore running VMs on libvirt-client update
-  Return right error code for baselineCPU
-  qemu: hotplug: Fix adding USB devices to the driver list
-  qemu: hotplug: Fix double free on USB collision
-  qemu: hotplug: Only label hostdev after checking device conflicts
-  qemu: hotplug: Mark 2 private functions as static
-  qemu: Call qemuSetupHostdevCGroup later during hotplug
-  qemu: hostdev: Refactor PCI passhrough handling
-  qemu: snapshot: Detect internal snapshots also for sheepdog and RBD
-  spec: Don't save/restore running VMs on libvirt-client update
-  Fix busy wait loop in LXC container I/O handling
-  libvirt-guests: Run only after libvirtd
-  Don't depend on syslog.service
-  Fix migration with QEMU 1.6
-  libxl: fix dubious cpumask handling in libxlDomainSetVcpuAffinities
-  util: recognize SMB/CIFS filesystems as shared
-  Disable nwfilter driver when running unprivileged
-  qemu: don't use deprecated -no-kvm-pit-reinjection
-  qemu: Don't access vm->priv on unlocked domain
-  virpci: Don't error on unbinded devices
-  virSecurityLabelDefParseXML: Don't parse label on model='none'

1.1.3.1 (November 06 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.1.3.1 <http://libvirt.org/sources/stable_updates/libvirt-1.1.3.1.tar.gz>`__

Changes in this version:

-  Push RPM deps down into libvirt-daemon-driver-XXXX sub-RPMs
-  Fix race condition reconnecting to vms & loading configs
-  Fix leak of objects when reconnecting to QEMU instances
-  Don't update dom->persistent without lock held
-  Block all use of libvirt.so in setuid programs
-  Remove (nearly) all use of getuid()/getgid()
-  Add stub getegid impl for platforms lacking it
-  Don't allow remote driver daemon autostart when running setuid
-  Only allow the UNIX transport in remote driver when setuid
-  Block all use of getenv with syntax-check
-  Remove all direct use of getenv
-  Make virCommand env handling robust in setuid env
-  Initialize threading & error layer in LXC controller
-  Fix flaw in detecting log format
-  Move virt-login-shell into libvirt-login-shell sub-RPM
-  Set a sane $PATH for virt-login-shell
-  remote: fix regression in event deregistration
-  python: Fix Create*WithFiles filefd passing
-  build: fix build of virt-login-shell on systems with older gnutls
-  build: fix linking virt-login-shell
-  Don't link virt-login-shell against libvirt.so (CVE-2013-4400)
-  Close all non-stdio FDs in virt-login-shell (CVE-2013-4400)
-  Only allow 'stderr' log output when running setuid (CVE-2013-4400)
-  Add helpers for getting env vars in a setuid environment
-  Fix perms for virConnectDomainXML{To,From}Native (CVE-2013-4401)
-  build: Add lxc testcase to dist list
-  Convert uuid to a string before printing it
-  LXC: Fix handling of RAM filesystem size units
-  qemuMonitorJSONSendKey: Avoid double free
-  rpc: fix getsockopt for LOCAL_PEERCRED on Mac OS X
-  Remove use of virConnectPtr from all remaining nwfilter code
-  Don't pass virConnectPtr in nwfilter 'struct domUpdateCBStruct'
-  Remove virConnectPtr arg from virNWFilterDefParse
-  qemu: cgroup: Fix crash if starting nographics guest
-  virNetDevBandwidthEqual: Make it more robust
-  qemu_hotplug: Allow QoS update in qemuDomainChangeNet
-  Adjust legacy max payload size to account for header information


1.0.5 series
------------


1.0.5.9 (January 16 2014)
~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.0.5.9 <http://libvirt.org/sources/stable_updates/libvirt-1.0.5.9.tar.gz>`__

Changes in this version:

-  Fix race leading to crash when setting up dbus watches
-  Really don't crash if a connection closes early
-  Don't crash if a connection closes early
-  qemu: Fix job usage in virDomainGetBlockIoTune
-  qemu: Fix job usage in qemuDomainBlockCopy
-  qemu: Fix job usage in qemuDomainBlockJobImpl
-  qemu: Avoid using stale data in virDomainGetBlockInfo
-  qemu: Do not access stale data in virDomainBlockStats
-  tests: be more explicit on qcow2 versions in virstoragetest
-  qemu: clean up migration ports when migration cancelled
-  qemu: Fix augeas support for migration ports
-  qemu: Make migration port range configurable
-  qemu: Avoid assigning unavailable migration ports
-  Don't spam logs with "port 0 must be in range" errors
-  Fix crash in lxcDomainSetMemoryParameters
-  CVE-2013-6436: fix crash in lxcDomainGetMemoryParameters


1.0.5.8 (December 14 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.0.5.8 <http://libvirt.org/sources/stable_updates/libvirt-1.0.5.8.tar.gz>`__

Changes in this version:

-  Tie SASL callbacks lifecycle to virNetSessionSASLContext
-  spec: Don't save/restore running VMs on libvirt-client update
-  Return right error code for baselineCPU
-  spec: Don't save/restore running VMs on libvirt-client update
-  Fix busy wait loop in LXC container I/O handling
-  libvirt-guests: Run only after libvirtd
-  Don't depend on syslog.service
-  libxl: fix dubious cpumask handling in libxlDomainSetVcpuAffinities
-  util: recognize SMB/CIFS filesystems as shared
-  Disable nwfilter driver when running unprivileged
-  spec: Explicitly require libgcrypt-devel


1.0.5.7 (November 06 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.0.5.7 <http://libvirt.org/sources/stable_updates/libvirt-1.0.5.7.tar.gz>`__

Changes in this version:

-  qemuSetupMemoryCgroup: Handle hard_limit properly
-  qemu: Drop qemuDomainMemoryLimit
-  remote: fix regression in event deregistration
-  virsh: Fix debugging
-  Fix URI connect precedence
-  virDomainDefParseXML: set the argument of virBitmapFree to NULL after
   calling virBitmapFree
-  build: Add lxc testcase to dist list
-  LXC: Fix handling of RAM filesystem size units
-  qemuMonitorJSONSendKey: Avoid double free
-  virsh domjobinfo: Do not return 1 if job is NONE
-  Remove use of virConnectPtr from all remaining nwfilter code
-  Don't pass virConnectPtr in nwfilter 'struct domUpdateCBStruct'
-  Remove virConnectPtr arg from virNWFilterDefParse
-  virNetDevBandwidthEqual: Make it more robust
-  qemu_hotplug: Allow QoS update in qemuDomainChangeNet
-  qemu: Use "migratable" XML definition when doing external checkpoints
-  qemu: Fix checking of ABI stability when restoring external
   checkpoints
-  virsh: Fix regression of vol-resize

1.0.5.6 (September 20 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.0.5.6 <http://libvirt.org/sources/stable_updates/libvirt-1.0.5.6.tar.gz>`__

Changes in this version:

-  virsh: fix change-media bug on disk block type
-  Fix crash in remoteDispatchDomainMemoryStats (CVE-2013-4296)
-  Add support for using 3-arg pkcheck syntax for process
   (CVE-2013-4311)
-  Include process start time when doing polkit checks
-  qemuDomainChangeGraphics: Check listen address change by listen type
-  security: provide supplemental groups even when parsing label
   (CVE-2013-4291)
-  python: return dictionary without value in case of no blockjob
-  virbitmap: Refactor virBitmapParse to avoid access beyond bounds of
   array


1.0.5.5 (August 01 2013)
~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.0.5.5 <http://libvirt.org/sources/stable_updates/libvirt-1.0.5.5.tar.gz>`__

Changes in this version:

-  Set the number of elements 0 in virNetwork*Clear
-  Don't check validity of missing attributes in DNS SRV XML
-  cgroup: reuse buffer for getline
-  rbd: Do not free the secret if it is not set
-  caps: use -device for primary video when qemu >=1.6
-  examples: fix mingw build vs. printf
-  build: fix virutil build on mingw
-  build: work around mingw header pollution
-  build: configure must not affect tarball contents
-  build: avoid build failure without gnutls
-  Fix build with clang
-  maint: update to latest gnulib
-  maint: update to latest gnulib
-  build: honor autogen.sh --no-git
-  maint: update to latest gnulib
-  FreeBSD: disable buggy -fstack-protector-all
-  build: update to latest gnulib, for syntax-check
-  maint: update to latest gnulib
-  lxc: correctly backport /dev/tty fix
-  security: fix deadlock with prefork
-  security_dac: compute supplemental groups before fork
-  security: framework for driver PreFork handler
-  util: make virSetUIDGID async-signal-safe
-  util: add virGetGroupList
-  util: improve user lookup helper


1.0.5.4 (July 12 2013)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.0.5.4 <http://libvirt.org/sources/stable_updates/libvirt-1.0.5.4.tar.gz>`__

Changes in this version:

-  qemu: fix double free in qemuMigrationPrepareDirect


1.0.5.3 (July 11 2013)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.0.5.3 <http://libvirt.org/sources/stable_updates/libvirt-1.0.5.3.tar.gz>`__

Changes in this version:

-  pci: initialize virtual_functions array pointer to avoid segfault
-  qemu: check if block I/O limits fit into long long
-  network: increase max number of routes
-  qemu: allow restore with non-migratable XML input
-  qemu_migrate: Dispose listen address if set from config
-  iscsi: pass hostnames to iscsiadm instead of resolving them
-  qemu: Report the offset from host UTC for RTC_CHANGE event
-  storage: Provide better error message if metadata pre-alloc is
   unsupported
-  usb: don't spoil decimal addresses
-  Check for existence of interface prior to setting terminate flag
-  qemu: snapshot: Don't kill access to disk if snapshot creation fails
-  Fix blkdeviotune for shutoff domain
-  Ensure non-root can read /proc/meminfo file in LXC containers
-  LXC: Create /dev/tty within a container
-  qemu: Implement new QMP command for cpu hotplug
-  udev: fix crash in libudev logging
-  Don't mount selinux fs in LXC if selinux is disabled
-  Re-add selinux/selinux.h to lxc_container.c
-  Fix failure to detect missing cgroup partitions
-  Fix starting domains when kernel has no cgroups support
-  Escaping leading '.' in cgroup names
-  Add docs about cgroups layout and usage
-  Cope with missing swap cgroup controls
-  libxl: fix build with Xen4.3
-  qemu: fix return value of qemuDomainBlockPivot on errors
-  storage: return -1 when fs pool can't be mounted
-  Fix vPort management: FC vHBA creation
-  bridge: don't crash on bandwidth unplug with no bandwidth
-  Fix invalid read in virCgroupGetValueStr
-  virsh: edit: don't leak XML string on reedit or redefine
-  lxc: Resolve issue with GetScheduler APIs for non running domain
-  qemu: Resolve issue with GetScheduler APIs for non running domain
-  conf: fix use after free in virChrdevOpen
-  qemu: Avoid leaking uri in qemuMigrationPrepareDirect
-  virtlockd: fix socket path
-  nodedev: fix vport detection for FC HBA


1.0.5.2 (June 12 2013)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.0.5.2 <http://libvirt.org/sources/stable_updates/libvirt-1.0.5.2.tar.gz>`__

Changes in this version:

-  virsh: migrate: Don't disallow --p2p and --migrateuri
-  qemu: migration: error if tunnelled + storage specified
-  qemu: migration: Improve p2p error if we can't open conn
-  Add a virGetLastErrorMessage() function
-  qemu: Don't report error on successful media eject
-  qemuDomainChangeEjectableMedia: Unlock domain while waiting for event
-  storage: Ensure 'qemu-img resize' size arg is a 512 multiple
-  nwfilter: grab driver lock earlier during init (bz96649)
-  Fix use of VIR_STRDUP vs strdup
-  qemu: Fix crash in migration of graphics-less guests.
-  qemu: prevent termination of guests w/hostdev on driver reconnect
-  qemu: escape literal IPv6 address in NBD migration
-  build: fix build with older gcc
-  qemu: fix NBD migration to hosts with IPv6 enabled
-  cgroup: be robust against cgroup movement races


1.0.5.1 (May 19 2013)
~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-1.0.5.1 <http://libvirt.org/sources/stable_updates/libvirt-1.0.5.1.tar.gz>`__

Changes in this version:

-  tests: use portable shell code
-  qemu: Fix cgroup handling when setting VCPU BW
-  daemon: fix leak after listing all volumes
-  Fix iohelper usage with streams opened for read
-  util: fix virFileOpenAs return value and resulting error logs
-  iscsi: don't leak portal string when starting a pool
-  don't mention disk controllers in generic controller errors
-  conf: don't crash on a tpm device with no backends
-  tests: files named '.\*-invalid.xml' should fail validation
-  qemu: allocate network connections sooner during domain startup
-  Make detect_scsi_host_caps a function on all architectures
-  Fixup rpcgen code on kFreeBSD too
-  Fix release of resources with lockd plugin
-  build: avoid non-portable cast of pthread_t
-  Fix potential use of undefined variable in remote dispatch code
-  build: fix mingw build of virprocess.c
-  Fix F_DUPFD_CLOEXEC operation args
-  spec: proper soft static allocation of qemu uid
-  build: clean up stray files found by 'make distcheck'
-  build: always include libvirt_lxc.syms in tarball
-  qemu: fix stupid typos in VFIO cgroup setup/teardown
-  build: always include sanitytest in tarball
-  virInitctlRequest: unbreak make syntax check
-  virInitctlRequest: unbreak make syntax check
-  network: fix network driver startup for qemu:///session



0.10.2 series
-------------


0.10.2.8 (September 20 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.10.2.8 <http://libvirt.org/sources/stable_updates/libvirt-0.10.2.8.tar.gz>`__

Changes in this version:

-  virsh: fix change-media bug on disk block type
-  libvirt: lxc: don't mkdir when selinux is disabled
-  Fix crash in remoteDispatchDomainMemoryStats (CVE-2013-4296)
-  Add support for using 3-arg pkcheck syntax for process
   (CVE-2013-4311)
-  Include process start time when doing polkit checks
-  win32: Pretend that close-on-exec works
-  virDomainDefParseXML: set the argument of virBitmapFree to NULL after
   calling virBitmapFree
-  security: provide supplemental groups even when parsing label
   (CVE-2013-4291)
-  virbitmap: Refactor virBitmapParse to avoid access beyond bounds of
   array
-  bitmap: add virBitmapCountBits


0.10.2.7 (August 01 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.10.2.7 <http://libvirt.org/sources/stable_updates/libvirt-0.10.2.7.tar.gz>`__

Changes in this version:

-  udev: fix crash in libudev logging
-  security: fix deadlock with prefork
-  security_dac: compute supplemental groups before fork
-  security: framework for driver PreFork handler
-  Fix potential deadlock across fork() in QEMU driver
-  util: make virSetUIDGID async-signal-safe
-  util: add virGetGroupList
-  util: improve user lookup helper
-  storage: return -1 when fs pool can't be mounted
-  Fix invalid read in virCgroupGetValueStr
-  virsh: edit: don't leak XML string on reedit or redefine



0.10.2.6 (June 12 2013)
~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.10.2.6 <http://libvirt.org/sources/stable_updates/libvirt-0.10.2.6.tar.gz>`__

Changes in this version:

-  qemu: Don't report error on successful media eject
-  qemuDomainChangeEjectableMedia: Unlock domain while waiting for event
-  qemu_hotplug: Rework media changing process
-  nwfilter: grab driver lock earlier during init (bz96649)
-  storage: Ensure 'qemu-img resize' size arg is a 512 multiple
-  Tweak EOF handling of streams
-  smartcard: spell ccid-card-emulated qemu property correctly
-  cgroup: be robust against cgroup movement races, part 2
-  cgroup: be robust against cgroup movement races
-  Avoid spamming logs with cgroups warnings
-  Don't try to add non-existant devices to ACL



0.10.2.5 (May 19 2013)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.10.2.5 <http://libvirt.org/sources/stable_updates/libvirt-0.10.2.5.tar.gz>`__

Changes in this version:

-  Fix TLS tests with gnutls 3
-  daemon: fix leak after listing all volumes
-  spec: proper soft static allocation of qemu uid
-  spec: Fix minor changelog issues
-  spec: Avoid using makeinstall relic
-  audit: properly encode device path in cgroup audit
-  storage: Fix lvcreate parameter for backingStore.

0.10.2.4 (April 01 2013)
~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.10.2.4 <http://libvirt.org/sources/stable_updates/libvirt-0.10.2.4.tar.gz>`__

Changes in this version:

-  esx: Fix and improve esxListAllDomains function
-  Fix parsing of SELinux ranges without a category
-  Separate MCS range parsing from MCS range checking
-  Fix memory leak on OOM in virSecuritySELinuxMCSFind
-  qemu: Set migration FD blocking
-  build: further fixes for broken if_bridge.h
-  build: work around broken kernel header
-  Fix SELinux security label test
-  libxl: Fix setting of disk backend
-  util: Fix mask for 172.16.0.0 private address range
-  conf: don't fail to parse <boot> when parsing a single device
-  Support custom 'svirt_tcg_t' context for TCG based guests
-  uml: Report error if inotify fails on driver startup (cherry picked
   from commit 7b97030ad430eb76fcc333652411208fb702e962)
-  daemon: Preface polkit error output with 'polkit:'
-  spec: Fix script warning when uninstalling libvirt-client


0.10.2.3 (January 28 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.10.2.3 <http://libvirt.org/sources/stable_updates/libvirt-0.10.2.3.tar.gz>`__

Changes in this version:

-  selinux: Only create the selabel_handle once.
-  Skip bulk relabelling of resources in SELinux driver when used with
   LXC
-  selinux: Resolve resource leak using the default disk label
-  rpc: Fix crash on error paths of message dispatching
-  nwfilter: Remove unprivileged code path to set base
-  Fix nwfilter driver reload/shutdown handling when unprivileged
-  call virstateCleanup to do the cleanup before libvirtd exits
-  Fix race condition when destroying guests
-  build: move file deleting action from %files list to %install
-  build: libvirt-guests files misplaced in specfile
-  qemu: Relax hard RSS limit
-  util: fix botched check for new netlink request filters
-  util: add missing error log messages when failing to get netlink
   VFINFO
-  util: fix functions that retrieve SRIOV VF info
-  virsh: Fix POD syntax
-  build: install libvirt sysctl file correctly
-  build: .service files don't need to be executable
-  build: use common .in replacement mechanism
-  tools: Only install guests init script if --with-init=script=redhat
-  build: fix syntax-check tab violation
-  build: check for pod errors
-  daemon: Use $(AM_V_GEN) in a few more places
-  build: Add libxenctrl to LIBXL_LIBS
-  Convert libxl driver to Xen 4.2
-  Introduce APIs for splitting/joining strings
-  network: prevent dnsmasq from listening on localhost


0.10.2.2 (December 09 2012)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.10.2.2 <http://libvirt.org/sources/stable_updates/libvirt-0.10.2.2.tar.gz>`__

Changes in this version:

-  dnsmasq: Fix parsing of the version number
-  dnsmasq: Fix parsing of the version number
-  storage: Error out earlier if the volume target path already exists
-  remote: Avoid the thread race condition
-  qemu: Don't free PCI device if adding it to activePciHostdevs fails
-  build: fix incremental autogen.sh when no AUTHORS is present
-  conf: prevent crash with no uuid in cephx auth secret
-  Allow duration=0 for virsh nodesuspend
-  Quote client identity in SASL whitelist log message
-  Fix uninitialized variables
-  nwfilter: report an error on OOM
-  virsh: check the return value of virStoragePoolGetAutostart
-  conf: fix uninitialized variable in virDomainListSnapshots
-  rpc: don't destroy xdr before creating it in
   virNetMessageEncodeHeader
-  virsh: do timing even for unusable connections
-  virsh: use correct sizeof when allocating cpumap
-  util: fix virBitmap allocation in virProcessInfoGetAffinity
-  network: fix crash when portgroup has no name
-  Fix leak of virNetworkPtr in LXC startup failure path
-  Fix error reporting in virNetDevVethDelete
-  Ensure transient def is removed if LXC start fails
-  Ensure failure to create macvtap device aborts LXC start
-  Avoid crash when LXC start fails with no interface target
-  Specify name of target interface with macvlan error
-  Treat missing driver cgroup as fatal in LXC driver
-  Ensure LXC container exits if cgroups setup fails
-  lxc: Don't crash if no security driver is specified in libvirt_lxc
-  lxc: Avoid segfault of libvirt_lxc helper on early cleanup paths
-  storage: fix logical volume cloning
-  Skip deleted timers when calculting next timeout
-  Warn if requesting update to non-existent timer/handle watch
-  Fix virDiskNameToIndex to actually ignore partition numbers
-  conf: Report sensible error for invalid disk name
-  Use virNetServerRun instead of custom main loop
-  storage: Fix bug of fs pool destroying
-  conf: add support for booting from redirected USB devices
-  qemu: allow larger discrepency between memory & currentMemory in
   domain xml
-  nodeinfo: support kernels that lack socket information
-  virsh: save: report an error if XML file can't be read
-  Doug Goldstein gained commit capability (cherry picked from commit
   bf60b6b33fd8e989b56c5a5cd4ea9660cbd0e556)
-  build: rerun bootstrap if AUTHORS is missing
-  Fix uninitialized variable in virLXCControllerSetupDevPTS
-  qemu: Don't force port=0 for SPICE
-  Fix "virsh create" example
-  esx: Yet another connection fix for 5.1
-  qemu: Add controllers in specified order
-  qemu: Wrap controllers code into dummy loop
-  spec: replace scriptlets with new systemd macros
-  iohelper: Don't report errors on special FDs
-  qemu: Fix possible race when pausing guest
-  net: Remove dnsmasq and radvd files also when destroying transient
   nets
-  net: Move creation of dnsmasq hosts file to function starting dnsmasq
-  conf: net: Fix deadlock if assignment of network def fails
-  conf: net: Fix helper for applying new network definition
-  Linux Containers are not allowed to create device nodes.
-  net-update docs: s/domain/network/
-  iohelper: fdatasync() at the end
-  qemu: Fix EmulatorPinInfo without emulatorpin
-  bugfix: ip6tables rule removal
-  Create temporary dir for socket
-  util: do a better job of matching up pids with their binaries
-  qemu: pass -usb and usb hubs earlier, so USB disks with static
   address are handled properly (cherry picked from commit
   81af5336acf4c765ef1201e7762d003ae0b0011e)
-  qemu: Do not ignore address for USB disks (cherry picked from commit
   8f708761c0d0e4eaf36bcb274d4f49fc3e0c3874)
-  esx: Fix connection to ESX 5.1
-  conf: fix virDomainNetGetActualDirect*() and BridgeName()
-  network: use dnsmasq --bind-dynamic when available
-  util: new virSocketAddrIsPrivate function
-  util: capabilities detection for dnsmasq
-  add ppc64 and s390x to arches where qemu-kvm exists
-  qemu: Always format CPU topology
-  spec: don't enable cgconfig under systemd
-  qemu: Fix name comparison in qemuMonitorJSONBlockIoThrottleInfo()
-  qemu: Keep QEMU host drive prefix in BlkIoTune


0.10.2.1 (October 27 2012)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.10.2.1 <http://libvirt.org/sources/stable_updates/libvirt-0.10.2.1.tar.gz>`__

Changes in this version:

-  qemu: Fix domxml-to-native network model conversion
-  parallels: fix build for some older compilers
-  documentation: HTML tag fix
-  network: fix networkValidate check for default portgroup and vlan
-  esx: Update version checks for vSphere 5.1
-  Fix detection of Xen sysctl version 9
-  selinux: Don't fail RestoreAll if file doesn't have a default label
-  storage: don't shadow global 'wait' declaration
-  Remove a couple duplicates from AUTHORS.in (cherry picked from commit
   2e99fa0385eea0084c520b4a3798a8663fb11b7a)
-  storage: Don't do wait loops from VolLookupByPath
-  storage: Add timeout for iscsi volume's stable path discovery
-  spec: Fix multilib issue with systemtap tapsets
-  docs: Fix installation of internals/\*.html
-  virsh: Fix segfault of snapshot-list
-  docs: virsh: clarify behavior of send-key
-  daemon: Avoid 'Could not find keytab file' in syslog
-  network: don't allow multiple default portgroups
-  network: always create dnsmasq hosts and addnhosts files, even if
   empty
-  network: free/null newDef if network fails to start
-  Autogenerate AUTHORS
-  build: avoid infinite autogen loop
-  selinux: relabel tapfd in qemuPhysIfaceConnect
-  network: Set to NULL after virNetworkDefFree()
-  selinux: remove unused variables in socket labelling (cherry picked
   from commit d37a3a1d6c6508f235965185453602ba310cc66e)
-  selinux: fix wrong tapfd relablling
-  selinux: Use raw contexts 2
-  selinux: add security selinux function to label tapfd
-  selinux: Use raw contexts
-  network: fix dnsmasq/radvd binding to IPv6 on recent kernels
-  qemu: Clear async job when p2p migration fails early
-  storage: lvm: lvcreate fails with allocation=0, don't do that
-  storage: lvm: Don't overwrite lvcreate errors
-  spec: Add runtime requirement for libssh2
-  spec: Add support for libssh2 transport
-  conf: Fix crash with cleanup
-  Properly parse (unsigned) long long
-  Correct name of domain/pm/suspend-to-mem in docs (cherry picked from
   commit 0ec6aebb6461b3d6ef71322114cf160ae2d3de19)
-  storage: Report UUID/name consistently in driver errors
-  Change qemuSetSchedularParameters to use AFFECT_CURRENT
-  nodeinfo: Fully convert to new virReportError
-  Call curl_global_init from virInitialize to avoid thread-safety
   issues
-  fix kvm_pv_eoi with kvmclock
-  esx: Disable libcurl's use of signals to fix a segfault
-  S390: Buffer too small for large CPU numbers.
-  spec: prefer canonical name of util-linux
-  docs: fix links in migration.html TOC
-  Correct checking of virStrcpyStatic() return value
-  build: avoid -Wno-format on new-enough gcc
-  qemu: Use proper agent entering function when freezing filesystems
-  lxc: Correctly report active cgroups
-  build: fix bitmap conversion when !CPU_ALLOC
-  Add note about numeric domain names to manpage
-  build: default selinuxfs mount point to /sys/fs/selinux
-  ARMHF: implement /proc/cpuinfo parsing
-  python: return error if PyObject obj is NULL for unwrapper helper
   functions
-  Fix compilation of legacy xen driver with Xen 4.2
-  Fix handling of itanium arch name in QEMU driver
-  Fix potential deadlock when agent is closed
-  Fix (rare) deadlock in QEMU monitor callbacks
-  Don't skip over socket label cleanup
-  Don't ignore return value of qemuProcessKill
-  Fix deadlock in handling EOF in LXC monitor
-  Support Xen sysctl version 9 in Xen 4.2
-  build: avoid older gcc warning
-  parallels: don't give null pointers to virBitmapEqual
-  parallels: fix memory allocation
-  Don't use O_TRUNC when opening QEMU logfiles
-  Simplify some redundant locking while unref'ing objects
-  Remove pointless virLXCProcessMonitorDestroy method
-  Convert virLXCMonitor to use virObject
-  Move virProcess{Kill,Abort,TranslateStatus} into virprocess.{c,h}
-  Move virProcessKill into virprocess.{h,c}
-  Rename virCommandTranslateStatus to virProcessTranslateStatus
-  Rename virPid{Abort,Wait} to virProcess{Abort,Wait}
-  Rename virKillProcess to virProcessKill
-  Fix start of containers with custom root filesystem
-  Update how to compile with -Werror
-  build: fix detection of netcf linked with libnl1
-  command: Change virCommandAddEnv so it replaces existing environment
   variables. (cherry picked from commit
   2b32735af480055e27400068d27364d521071117)
-  command: Move environ-adding code to common function
   virCommandAddEnv.



0.9.12 series
-------------

0.9.12.3 (Jan 16 2014)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.12.3 <http://libvirt.org/sources/stable_updates/libvirt-0.9.12.3.tar.gz>`__

Changes in this version:

-  Prepare for 0.9.12.3
-  Really don't crash if a connection closes early
-  Don't crash if a connection closes early
-  qemu: Fix job usage in virDomainGetBlockIoTune
-  qemu: Fix job usage in qemuDomainBlockJobImpl
-  qemu: Avoid using stale data in virDomainGetBlockInfo
-  qemu: Do not access stale data in virDomainBlockStats
-  Introduce virReportError macro for general error reporting
-  string: test VIR_STRDUP
-  string: make VIR_STRDUP easier to use
-  virstring: Introduce VIR_STRDUP and VIR_STRNDUP
-  remote: fix regression in event deregistration

0.9.12.2 (Oct 1 2013)
~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.12.2 <http://libvirt.org/sources/stable_updates/libvirt-0.9.12.2.tar.gz>`__

-  Prepare for 0.9.12.2
-  Distribute viratomic.h
-  Fix crash in remoteDispatchDomainMemoryStats (CVE-2013-4296)
-  Add support for using 3-arg pkcheck syntax for process
   (CVE-2013-4311)
-  Include process start time when doing polkit checks
-  Move virProcess{Kill, Abort, TranslateStatus} into virprocess.{c, h}
-  Move virProcessKill into virprocess.{h, c}
-  Rename virCommandTranslateStatus to virProcessTranslateStatus
-  Rename virPid{Abort, Wait} to virProcess{Abort, Wait}
-  Rename virKillProcess to virProcessKill
-  Introduce APIs for splitting/joining strings


0.9.12.1 (Oct 1 2013)
~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.12.1 <http://libvirt.org/sources/stable_updates/libvirt-0.9.12.1.tar.gz>`__

Changes in this version:

-  Prepare 0.9.12.1
-  Fix TLS tests with gnutls 3
-  build: avoid confusing make with raw name 'undefine'
-  virsh: Fix POD syntax
-  build: more workarounds for if_bridge.h
-  build: allow building with newer glibc-headers and -O0
-  Fix race condition when destroying guests
-  Don't ignore return value of qemuProcessKill
-  conf: Remove console stream callback only when freeing console helper
-  conf: Remove callback from stream when freeing entries in console
   hash
-  storage: Need to also VIR_FREE(reg)
-  qemu: Add support for -no-user-config
-  rpc: Fix crash on error paths of message dispatching
-  qemu: Fix off-by-one error while unescaping monitor strings
-  Revert "rpc: Discard non-blocking calls only when necessary"
-  build: fix virnetlink on glibc 2.11
-  security: Fix libvirtd crash possibility
-  daemon: Fix crash in virTypedParameterArrayClear


0.9.11 series
-------------


0.9.11.10 (June 12 2013)
~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.10 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.10.tar.gz>`__

Changes in this version:

-  storage: Ensure 'qemu-img resize' size arg is a 512 multiple
-  smartcard: spell ccid-card-emulated qemu property correctly
-  Revert "build: work around broken kernel header"
-  Revert "build: further fixes for broken if_bridge.h"
-  build: further fixes for broken if_bridge.h
-  build: work around broken kernel header
-  build: avoid infinite autogen loop
-  netlink: Fix build with libnl-3
-  build: fix detection of netcf linked with libnl1
-  build: force libnl1 if netcf also used libnl1
-  build: support libnl-3
-  Skip libxl driver on Xen 4.2
-  Fix compilation of legacy xen driver with Xen 4.2
-  qemu: Set migration FD blocking
-  build: further fixes for broken if_bridge.h
-  build: work around broken kernel header



0.9.11.9 (January 28 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.9 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.9.tar.gz>`__

Changes in this version:

-  Fix race condition when destroying guests
-  rpc: Fix crash on error paths of message dispatching
-  util: fix botched check for new netlink request filters
-  util: add missing error log messages when failing to get netlink
   VFINFO
-  util: fix functions that retrieve SRIOV VF info
-  network: prevent dnsmasq from listening on localhost



0.9.11.8 (December 09 2012)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.8 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.8.tar.gz>`__

Changes in this version:

-  qemu: pass -usb and usb hubs earlier, so USB disks with static
   address are handled properly (cherry picked from commit
   81af5336acf4c765ef1201e7762d003ae0b0011e)
-  qemu: Do not ignore address for USB disks (cherry picked from commit
   8f708761c0d0e4eaf36bcb274d4f49fc3e0c3874)
-  qemu: Fix name comparison in qemuMonitorJSONBlockIoThrottleInfo()
-  qemu: Keep QEMU host drive prefix in BlkIoTune
-  dnsmasq: Fix parsing of the version number
-  dnsmasq: Fix parsing of the version number
-  conf: fix virDomainNetGetActualDirect*() and BridgeName()
-  network: use dnsmasq --bind-dynamic when available
-  util: new virSocketAddrIsPrivate function
-  util: capabilities detection for dnsmasq
-  spec: don't enable cgconfig under systemd



0.9.11.7 (October 27 2012)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.7 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.7.tar.gz>`__

Changes in this version:

-  qemu: Fix domxml-to-native network model conversion
-  selinux: Don't fail RestoreAll if file doesn't have a default label
-  spec: Fix multilib issue with systemtap tapsets
-  docs: Fix installation of internals/\*.html
-  docs: virsh: clarify behavior of send-key
-  daemon: Avoid 'Could not find keytab file' in syslog
-  storage: lvm: Don't overwrite lvcreate errors
-  qemu: Clear async job when p2p migration fails early
-  Revert "build: fix compilation without struct ifreq"


0.9.11.6 (October 07 2012)
~~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.6 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.6.tar.gz>`__

Changes in this version:

-  Prep for release 0.9.11.6
-  remove dnsmasq command line parameter "--filterwin2k"
-  dnsmasq: avoid forwarding queries without a domain
-  security: Fix libvirtd crash possibility


0.9.11.5 (August 13 2012)
~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.5 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.5.tar.gz>`__

Changes in this version:

-  Prep for release 0.9.11.5
-  tests: avoid seclabeltest crash
-  client rpc: Fix error checking after poll()
-  client rpc: Send keepalive requests from IO event loop
-  server rpc: Remove APIs for manipulating filters on locked client
-  rpc: Remove unused parameter in virKeepAliveStopInternal
-  rpc: Do not use timer for sending keepalive responses
-  client rpc: Separate call creation from running IO loop
-  rpc: Add APIs for direct triggering of keepalive timer
-  rpc: Refactor keepalive timer code
-  client rpc: Drop unused return value of virNetClientSendNonBlock
-  client rpc: Just queue non-blocking call if another thread has the
   buck
-  client rpc: Don't drop non-blocking calls
-  client rpc: Use event loop for writing
-  client rpc: Improve debug messages in virNetClientIO
-  keepalive: Add ability to disable keepalive messages
-  conf: Remove console stream callback only when freeing console helper
-  Fix typo s/AM_CLFAGS/AM_CFLAGS/ in sanlock link (cherry picked from
   commit 7de158cf68cae7ab55d3cae1a01744b374810840)
-  virsh: console: Avoid using stream after being freed.
-  qemu: syntax fix
-  qemu: fix use after free
-  conf: Remove callback from stream when freeing entries in console
   hash
-  security: Skip labeling resources when seclabel defaults to none
-  fixed SegFault in virauth
-  adding handling EINTR to poll to make it more robust
-  doc: Fix time keeping example for the guest clock
-  Fix test failure when no IPv6 is avail
-  Ensure failure to talk to Xen hypervisor is fatal when privileged
-  Don't autostart domains when reloading config
-  build: fix compilation without struct ifreq
-  remote: Fix locking in stream APIs
-  qemu: Do not fail virConnectCompareCPU if host CPU is not known
-  Clarify direct migration
-  Fix daemon auto-spawning
-  openvz: Handle domain obj hash map errors
-  Fix /domain/features setting in qemuParseCommandLine
-  systemd: start libvirtd after network
-  Fix a string format bug in qemu_cgroup.c
-  virsh: Clarify documentation for virsh dompmsuspend command
-  storage_backend_fs: Don't free a part of a structure on error
-  Fix one test regression on auth Ceph support
-  qemu: Always set auth_supported for Ceph disks.
-  qemu: add rbd to whitelist of migration-safe formats
-  maint: use full author name for previous commit
-  fix key error for qemuMonitorGetBlockStatsInfo
-  virsh: Cleanup virsh -V output
-  nwfilter: Fix memory leak
-  Fix vm's outbound traffic control problem
-  network_conf: Don't free uninitialized pointers while parsing DNS SRV
-  storage: Error out if the target is already mounted for netfs pool
-  configure: show correct default argument in help
-  events: Don't fail on registering events for two different domains
-  doc: fix typo in virDomainDestroy API doc (cherry picked from commit
   0b7ad22ba6aaefaaa1d9792f3c236322aafe93c7)
-  Add /tools/libvirt-guests.service to .gitignore
-  Don't install systemd service files executable
-  S390: Fixed Parser for /proc/cpuinfo needs to be adapted for your
   architecture
-  S390: Override QEMU_CAPS_NO_ACPI for s390x
-  qemu: Improve error if setmem fails for lacking of balloon support
-  virsh: Improve error when trying to change vm's cpu count 0
-  Initialize random generator in lxc controller
-  openvz: check pointer size instead of int
-  Fix default USB controller for ppc64
-  virsh: fix few typos on desc command
-  domain_conf: fix possible memory leak
-  virsh: make domiftune interface help string consistent
-  openvz: Fix wordsize on 64 bit architectures
-  LXC: fix memory leak in lxcContainerMountFSBlockHelper
-  qemu_agent: Wait for events instead of agent response
-  build: hoist qemu dependence on yajl to configure
-  autogen: Always abide --system
-  Check for errors when parsing bridge interface XML
-  schema: Update domain XML schema
-  qemu: fix potential dead lock
-  virsh: Null terminated the string memcpy from buffer explicitly
-  docs: small typo in formatdomain.html (cherry picked from commit
   8b36e32c16641f09c484a32920bb9da255ea4df9)
-  Remove bogus xen-devel dep from libvirt-devel RPM
-  Revert "qemu: fix build when !HAVE_NUMACTL"
-  daemon: Fix crash in virTypedParameterArrayClear
-  libvirt-guests: systemd host shutdown does not work
-  build: update to latest gnulib, for secure tarball
-  Update to latest GNULIB to fix compat with Mingw64 toolchain
-  build: update to latest gnulib


0.9.11.4 (June 15 2012)
~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.4 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.4.tar.gz>`__

Changes since 0.9.11.3:

-  Stable release 0.9.11.4
-  build: fix build of fresh checkout
-  build: fix 'make distcheck' issues
-  build: fix 'make dist' on virgin checkout
-  Improve error message diagnosing incorrect XML CPU mode
-  qemu: Enable disconnecting SPICE clients without changing password
-  qemu: Fix off-by-one error while unescaping monitor strings
-  virsh: Don't generate invalid XML in attach-disk command
-  Fix typo in RPM specfile
-  python: fix snapshot listing bugs
-  python: use simpler methods
-  qemu: Don't overwrite security labels
-  qemuProcessStop: Switch to flags
-  docs: minor fixes to domain interface documentation
-  docs: link to FLOSS Weekly podcast, virt blogs
-  Two RPM conditional fixes for RHEL-7
-  snapshot: avoid virsh crash with older servers
-  Update AUTHORS
-  LXC: fix memory leak in lxcContainerMountFSBlockAuto
-  LXC: fix incorrect parameter of mount in lxcContainerMountFSBind
-  Only check for cluster fs if we're using a filesystem
-  Fix missing ) in 2 strings
-  Assign correct address type to spapr-vlan and spapr-vty.
-  maint: make it easier to copy FORTIFY_SOURCE snippet
-  command: avoid potential deadlock on handshake
-  spec: Build against systemd for udev
-  virsh: Back out if the argument for vol-create-as is malformed
   (cherry picked from commit ee58b581c4b275f06904253285b7ad562dc09745)
-  virsh: Accept UUID as an argument for net-info and net-start (cherry
   picked from commit 68fcfdb8bd33ef323c6c4c5b9a92b1a44829eb6a)
-  virsh: Accept UUID as an argument for storage commands
-  Fix for parallel port passthrough for QEMU
-  maint: command.c whitespace cleanups
-  command: avoid deadlock on EPIPE situation
-  build: allow building with newer glibc-headers and -O0
-  command: Fix debug message during handshake
-  Fix sync issue in virNetClientStreamEventRemoveCallback
-  qemu: fix netdev alias name assignment wrt type='hostdev'
-  tools: make virt-pki-validate work with acls and xattrs
-  qemu: avoid closing fd more than once
-  command: check for fork error before closing fd
-  fdstream: avoid double close bug
-  command: avoid double close bugs
-  avoid fd leak
-  avoid closing uninitialized fd
-  build: silence warning from autoconf
-  virCommand: Extend debug message for handshake
-  lxc: return correct number of CPUs
-  examples: add consolecallback example python script
-  leak_fix.diff
-  docs: typo in acceleration element
-  Re-order config options in qemu driver augeas lens
-  Fix mistakes in augeas lens
-  Standardize whitespace used in example config files
-  Fix check for socket existance / daemon spawn
-  Remove last usage of PATH_MAX and ban its future use
-  maint: avoid new automake warning about AM_PROG_CC_STDC
-  Improve docs about compiling libvirt from GIT
-  tests: run valgrind on real executables, not libtool wrappers
-  qemu augeas: Add spice_tls/spice_tls_x509_cert_dir
-  tests: back to short test names
-  Add parsing for VIR_ENUM_IMPL & VIR_ENUM_DECL in apibuild.py
-  Add stub impl of virNetlinkEventServiceLocalPid for Win32
-  Fix dep from libvirt-lock-sanlock RPM
-  Remove more bogus systemd service dependencies
-  Revert "rpc: Discard non-blocking calls only when necessary"
-  qemu_hotplug: Don't free the PCI device structure after hot-unplug
-  build: fix unused variable after last patch
-  Fix potential events deadlock when unref'ing virConnectPtr
-  Fix build when configuring with polkit0
-  build: fix virnetlink on glibc 2.11
-  qemu: Don't delete USB device on failed qemuPrepareHostdevUSBDevices
-  qemu: Rollback on used USB devices
-  Reject any non-option command line arguments
-  Remove bogus udev.target dep from libvirtd unit
-  Set a sensible default master start port for ehci companion
   controllers
-  Fix logic for assigning PCI addresses to USB2 companion controllers
-  Fix virDomainDeviceInfoIsSet() to check all struct fields
-  Allow stack traces to be included with log messages
-  Add bundled(gnulib) to RPM specfile
-  libvirt-guests: Remove LISTFILE if it's empty when stopping service
-  qemu: Use the CPU index in capabilities to map NUMA node to cpu list.
-  Assign spapr-vio bus address to ibmvscsi controller
-  esx: Fix memory leaks in error paths related to transferred ownership
-  qemu: Don't skip detection of virtual cpu's on non KVM targets
-  qemu: Re-detect virtual cpu threads after cpu hot (un)plug.
-  qemu: Refactor qemuDomainSetVcpusFlags
-  usb: fix crash when failing to attach a second usb device
-  docs: mention migration issue of which credentials are used
-  build: Fix the typo in configure.ac
-  qemu: fix build when !HAVE_NUMACTL
-  Report error when parsing character device target type
-  numad: Update comments in libvirt.spec.in
-  numad: Check numactl-devel if compiled with numad support
-  snapshot: allow block devices past cgroup
-  tests: add some self-documentation to tests
-  build: avoid link failure on Windows
-  virsh: avoid heap corruption leading to virsh abort
-  util: set src_pid for virNetlinkCommand when appropriate
-  util: function to get local nl_pid used by netlink event socket
-  util: allow specifying both src and dst pid in virNetlinkCommand
-  util: fix libvirtd startup failure due to netlink error
-  qemu: call usb search function for hostdev initialization and hotplug
-  usb: create functions to search usb device accurately
-  rpm: Handle different source URLs for maint releases (cherry picked
   from commit f4345ac21fead319a22a5761e86a46752df23402)
-  qemu: Emit compatible XML when migrating a domain
-  qemu: Don't use virDomainDefFormat\* directly
-  qemu: reject blockiotune if qemu too old
-  qemu: don't modify domain on failed blockiotune
-  util: remove error log from stubs of virNetlinkEventServiceStart|Stop
-  node_device: fix possible non-terminated string
-  uuid: fix possible non-terminated string
-  tests: fix resource leak
-  qemu: fix resource leak
-  vmx: fix resource leak
-  Coverity: Fix resource leak in virnetlink.c (cherry picked from
   commit fd2b41574e05510ddeffbf9acbf06584acb3c2b2)
-  Coverity: Fix resource leak in nodeinfo.c
-  Coverity: Fix resource leak in test driver
-  Coverity: Fix resource leak in xen driver
-  Coverity: Fix resource leaks in phyp driver
-  Coverity: Fix the forward_null error in Python binding codes
-  build: fix build on cygwin
-  Correct indent errors in the function qemuDomainNetsRestart
-  build: update pid_t type static check
-  build: fix output of pid values
-  virsh: make -h always give help
-  build: make ATTRIBUTE_NONNULL() a NOP unless STATIC_ANALYSIS is on
-  Make lxcContainerSetStdio the last thing to be called in container
   startup
-  Ensure logging is initialized early in libvirt_lxc
-  Ensure LXC security driver is set unconditonally
-  Ensure libvirt_lxc process loads the live XML config
-  maint: avoid false positives on unmarked diagnostics
-  qemu: allow snapshotting of sheepdog and rbd disks
-  qemu: change rbd auth_supported separation character to ;
-  util: Avoid libvirtd crash in virNetDevTapCreate
-  storage: Break out the loop if duplicate pool is found
-  qemu: Make sure qemu can access its directory in hugetlbfs
-  qemu_agent: Report error class at least
-  More coverity findings addressed
-  lxc: Fix coverity findings
-  build: fix stamp file name
-  Revert "building: remove libvirt_dbus.syms from EXTRA_DIST"


0.9.11.3 (Apr 27 2012)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.3 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.3.tar.gz>`__

Changes since 0.9.11.2:

-  Stable release 0.9.11.3
-  python: Fix doc directory name for stable releases
-  docs: Serialize running apibuild.py
-  configure: Use ustar format for dist tarball
-  qemu: improve errors related to offline domains
-  nwfilter: address more coverity findings
-  nwfilter: address coverity findings
-  util: fix error messages in virNetlinkEventServiceStart


0.9.11.2 (Apr 26 2012)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.2 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.2.tar.gz>`__

Only change from 0.9.11.1 is a version bump and a dist rebuild: the old
tarball was generated with some busted autoconf bits.



0.9.11.1 (Apr 26 2012)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.11.1 <http://libvirt.org/sources/stable_updates/libvirt-0.9.11.1.tar.gz>`__

Changes since 0.9.11 GA:

-  Release of 0.9.11.1 stable
-  qemu: Avoid bogus error at the end of tunnelled migration
-  qemu: Fix detection of failed migration
-  rpc: Discard non-blocking calls only when necessary
-  qemu: Preserve original error during migration
-  util: fix crash when starting macvtap interfaces
-  build: fix bootstrap on RHEL
-  fix memleak in linuxParseCPUmap
-  build: Fix version of gettext macros
-  vbox: Fix passing an empty IMedium\* array to IMachine::Delete
-  building: remove libvirt_dbus.syms from EXTRA_DIST
-  win32: Properly handle TlsGetValue returning NULL
-  esx: Fix segfault in esxConnectToHost
-  openvz: wire up getHostname
-  virnetserver: handle sigaction correctly
-  conf: tighten up XML integer parsing
-  build: avoid type-punning in vbox
-  build: fix fresh checkout on RHEL5
-  util: only register callbacks for CREATE operations in
   virnetdevmacvlan.c
-  Fix a memory leak
-  vbox: avoid provoking assertions in VBoxSVC
-  conf: Do not parse cpuset only if the placement is auto
-  Do not enforce source type of console[0]
-  xen: do not use ioemu type for any emulated NIC
-  docs: fix 'omitted' typo in <cputune> doc
-  docs: add missing in <vcpu placement> doc
-  docs: fix path to openvz network configuration file
-  storage: lvm: use correct lv\* command parameters
-  numad: Ignore cpuset if placement is auto
-  numad: Convert node list to cpumap before setting affinity
-  Fix macvtap detection by also checking for IFLA_VF_MAX
-  virnetdev: Check for defined IFLA_VF\_\*
-  conf: Avoid double assignment in virDomainDiskRemove
-  qemu: Fix mem leak in qemuProcessInitCpuAffinity
-  xend_internal: Use domain/status for shutdown check
-  qemu,util: fix netlink callback registration for migration
-  qemuOpenFile: Don't force chown on NFS
-  daemon: Plug memory leaks
-  qemu: Fix deadlock when qemuDomainOpenConsole cleans up a connection
-  build: avoid s390 compiler warnings
-  virsh: Clarify use of the --managed-save flag for the list command
-  Fix comment about GNUTLS initialization/cleanup (cherry picked from
   commit 20171c8dc0e3efec7437d8d00e32737d9909e4f7)
-  Fix compilation error on 32bit
-  UML: fix iteration over consoles
-  snapshot: fix memory leak on error
-  qemu_ga: Don't overwrite errors on FSThaw
-  xen config: No vfb in HVM guest configuration
-  tests: avoid compiler warnings
-  test: fix build errors with gcc 4.7.0 and -O0
-  virURIParse: don't forget to copy the user part
-  test: fix segfault in networkxml2argvtest
-  conf: Plug memory leaks on virDomainDiskDefParseXML
-  openvz: support vzctl 3.1
-  Don't install sysctl file on non-Linux hosts
-  Fix parallel build in docs/ directory
-  Pull in GNULIB regex module for benefit of test suite on Win32
   (cherry picked from commit f94d9c5793cc57b5228c7f1915bdc76c84f0a923)
-  Add linuxNodeInfoCPUPopulate to src/libvirt_linux.syms
-  Fix format specifiers in test cases on Win32
-  qemu: Build activeUsbHostdevs list on process reconnect
-  qemu: Delete USB devices used by domain on stop
-  qemu: Don't leak temporary list of USB devices
-  docs: fix typo in previous patch
-  news.html.in: Fix
   void tag
-  virsh: Clarify escape sequence


0.9.6 series
------------


0.9.6.4 (January 28 2013)
~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.6.4 <http://libvirt.org/sources/stable_updates/libvirt-0.9.6.4.tar.gz>`__

Changes in this version:

-  rpc: Fix crash on error paths of message dispatching
-  qemu: Clear async job when p2p migration fails early



0.9.6.3 (October 07 2012)
~~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.6.3 <http://libvirt.org/sources/stable_updates/libvirt-0.9.6.3.tar.gz>`__

Changes in this version:

-  Prep for release 0.9.6.3
-  security: Fix libvirtd crash possibility



0.9.6.2 (August 13 2012)
~~~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.6.2 <http://libvirt.org/sources/stable_updates/libvirt-0.9.6.2.tar.gz>`__

Changes in this version:

-  Prep for release 0.9.6.2
-  build: drop check for ANSI compiler
-  tests: avoid seclabeltest crash
-  Remove unused <dirent.h> imports to appease syntax-check
-  Appease gnulib sc_makefile_at_at_check
-  test: fix segfault in networkxml2argvtest
-  tests: dynamically replace dnsmasq path
-  daemon: Fix crash in virTypedParameterArrayClear
-  build: update to latest gnulib, for secure tarball
-  build: update to latest gnulib
-  build: update to latest gnulib



0.9.6.1 (June 15 2012)
~~~~~~~~~~~~~~~~~~~~~~

`Download
libvirt-0.9.6.1 <http://libvirt.org/sources/stable_updates/libvirt-0.9.6.1.tar.gz>`__

Changes in this version:

-  Stable release 0.9.6.1
-  Pull in GNULIB regex module for benefit of test suite on Win32
   (cherry picked from commit f94d9c5793cc57b5228c7f1915bdc76c84f0a923)
-  Fix typos in API XML file paths
-  qemu: avoid closing fd more than once
-  command: check for fork error before closing fd
-  fdstream: avoid double close bug
-  command: avoid double close bugs
-  avoid fd leak
-  avoid closing uninitialized fd
-  Set a sensible default master start port for ehci companion
   controllers
-  Fix logic for assigning PCI addresses to USB2 companion controllers
-  Fix virDomainDeviceInfoIsSet() to check all struct fields
-  lxc: use hand-rolled code in place of unlockpt and grantpt
-  xen: do not use ioemu type for any emulated NIC
-  xend_internal: Use domain/status for shutdown check
-  xen-xm: SIGSEGV in xenXMDomainDefineXML: filename
-  xen_xm: Fix SIGSEGV in xenXMDomainDefineXML
-  xen: Don't add <console> to xml for dom0
-  xen_xs: Guard against set but empty kernel argument
-  xen: add error handling to UUID parsing
-  xenParseXM: don't dereference NULL pointer when script is empty
   (cherry picked from commit 6dd8532d96b0512ddb3b10cae8f51e16389d9cc7)
-  Fix sync issue in virNetClientStreamEventRemoveCallback
-  fdstream: Add internal callback on stream close
-  fdstream: Emit stream abort callback even if poll() doesnt.
-  Don't return a fatal error if receiving unexpected stream data
-  Fix handling of stream EOF
-  If receiving a stream error, mark EOF on the stream
-  Set to NULL members that have been freed to prevent crashes
-  Fix synchronous reading of stream data
-  build: fix stamp file name
-  Install API XML desc to a standard location
-  tests: work around pdwtags 1.9 failure
-  xenapi: remove unused variable
-  build: fix 'make distcheck'
-  build: fix 'make distcheck' with pdwtags installed
-  python: Fix doc directory name for stable releases
-  docs: Serialize running apibuild.py
-  configure: Use ustar format for dist tarball
-  Fix parallel build in docs/ directory
-  tests: avoid test failure on rawhide gnutls
-  storage: Fix any VolLookupByPath if we have an empty logical pool
-  daemon: Remove deprecated HAL from init script dependencies
-  virCommand: Properly handle POLLHUP
-  qemu: Check for domain being active on successful job acquire
-  Avoid crash in shunloadtest
-  spec: make it easier to autoreconf when building rpm
-  test: replace deprecated "fedora-13" machine with "pc-0.13"
-  network: don't add iptables rules for externally managed networks
-  spec: fix logic bug in deciding to turn on cgconfig
-  spec: don't use chkconfig --list
-  spec: add dmidecode as prereq
-  Fix incorrect symbols for virtime.h module breaking Mingw32
-  spec: mark directories in /var/run as ghosts
-  Remove time APIs from src/util/util.h
-  Make logging async signal safe wrt time stamp generation
-  Add internal APIs for dealing with time
-  logging: Add date to log timestamp (cherry picked from commit
   11c6e094e4e8789174502bd52c1441caa5865276)
-  logging: Do not log timestamp through syslog
-  qemu: make PCI multifunction support more manual
-  conf: remove unused VIR_ENUM_DECL
-  spec: F15 still uses cgconfig, RHEL lacks hyperv
