.. contents::

QEMU Guest Agent
================

It is a daemon program running inside the domain which is supposed to
help management applications with executing functions which need
assistance of the guest OS. For example, freezing and thawing
filesystems, entering suspend. However, guest agent (GA) is not bullet
proof, and hostile guest OS can send spurious replies.

Setting QEMU GA up
------------------

Currently, QEMU exposes GA via virtio serial port. There are some
attempts to allow applications to use qemu monitor for communication
with GA, but virtio serial port should remain supported. These are
internals, though.

To be able to use GA users needs to create virtio serial port with
special name ``org.qemu.guest_agent.0``. In other words, one needs to
add this to his/her domain XML under ``<devices>``:

::

   <channel type='unix'>
      <source mode='bind' path='/var/lib/libvirt/qemu/f16x86_64.agent'/>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
   </channel>

If you use libvirt 1.0.6 or newer, you can omit the path='...' attribute
of the <source> element, and libvirt will manage things automatically on
your behalf.

Usage
-----

Libvirt does not guarantee any support of direct use of the guest agent.
If you don't mind using libvirt-qemu.so, you can use the
``virDomainQemuAgentCommand`` API (exposed by
``virsh qemu-agent-command``); but be aware that this is unsupported,
and any changes you make to the agent that change state behind libvirt's
back may cause libvirt to misbehave. Meanwhile, the guest agent may be
used internally by several supported libvirt APIs, often by passing
flags to request its use. For example, ``virDomainShutdownFlags``
supports:

::

   VIR_DOMAIN_SHUTDOWN_DEFAULT        = 0,
   VIR_DOMAIN_SHUTDOWN_ACPI_POWER_BTN = (1 << 0),
   VIR_DOMAIN_SHUTDOWN_GUEST_AGENT    = (1 << 1),

Simmilar applies for the reboot API:

::

   VIR_DOMAIN_REBOOT_DEFAULT        = 0,
   VIR_DOMAIN_REBOOT_ACPI_POWER_BTN = (1 << 0),
   VIR_DOMAIN_REBOOT_GUEST_AGENT    = (1 << 1),

In virsh, users can select shutdown/reboot method via
``--mode acpi|agent``:

::

   virsh reboot --mode agent $DOMAIN
   virsh shutdown --mode agent $DOMAIN

If users is creating snapshots he/she might want to freeze before and
thaw filesystems after. This can be done by specifying
VIR_DOMAIN_SNAPSHOT_CREATE_QUIESCE flag to virDomainSnapshotCreate API
or:

::

   virsh snapshot-create --quiesce $DOMAIN
   virsh snapshot-create-as --quiesce $DOMAIN

in virsh.

**Warning:** Like any monitor command, GA commands can block
indefinitely [STRIKEOUT:esp. when GA is not running. Currently, there is
no reliable method/API to tell if GA is running]. Libvirt implements
some basic check to determine if there is a qemu-ga instance running or
not. Basically a ``guest-sync`` command is issued prior every useful
command. If it returns, then libvirt considers guest agent up and
running and issues the real command. However, guest agent can die or be
terminated meanwhile. The ``guest-sync`` command is issued with a
timeout which if hit guest agent is considered as not present.

Configure guest agent without libvirt interference
--------------------------------------------------

In some cases, users might want to configure a guest agent in their
domain XML but don't want libvirt to connect to guest agent socket at
all. Because libvirt connects to a guest agent channel if and only if it
is a virtio channel with ``org.qemu.guest_agent.0`` name, all one need
to do is void at least one of these conditions. However, the most
feasible way is to change the target's name:

::

   <channel type='unix'>
      <source mode='bind' path='/var/lib/libvirt/qemu/f16x86_64.agent'/>
      <target type='virtio' name='org.qemu.guest_agent.1'/>
   </channel>

If you do change name, you'll need to tell it to qemu GA as well:

::

    # qemu-ga -p /dev/virtio-ports/$name

Guest requirements
------------------

One thing has been already mentioned - the domain configuration for
virtio serial port. However, guest **must** have the GA installed.
Fortunately, it is already distributed as rpm, so all one needs to do
is:

::

   yum install qemu-guest-agent

Related links
-------------

If you want to read further:

-  https://wiki.qemu.org/Features/GuestAgent
