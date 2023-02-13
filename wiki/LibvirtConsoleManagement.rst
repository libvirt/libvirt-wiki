.. contents::

Libvirt Console Management
==========================

This page describes an approach to managing virtual machine text
consoles, which leverages the conserver daemon

Background information
----------------------

With Xen, LXC, KVM, etc hypervisors there is typically a serial console
or a paravirtualized log for each virtual machine. Typically this is
exposed on the host as a dynamically allocated psuedo TTY, but they can
also be configured to use a UNIX or TCP socket, a FIFO pipe or (output
only) to a plain file.

The consoles are typically used as a text-mode interactive shell, or to
log all guest console messages, or both. There are a number of
limitations with the console functionality that is exposed natively by
the hypervisors

-  It is impossible to configure a console to both provide an
   interactive pTTY, and log all data to a file concurrently.
-  If configured to log to a file, the file will grow without any bounds
-  The console TTY names are unstable across restarts of the virtual
   machine, since they are dynamically allocated by the host kernel
-  The console TTYs only exist while the VM is running
-  There is typically no native, secure, remote TCP access

Architecture design
-------------------

The problems described with the native hypervisor console configuration
can broadly be addressed by leveraging the conserver daemon, which is
distributed as a standard part of most Linux distributions. The main
integration pain point is that the conserver daemon uses a static
configuration file, while virtual machines can come & go at any moment.

There is a need, therefore, to have a way of automatically
generating/updating the conserver configuration file on the fly to deal
with dynamic virtual machines. This can be achieved by having a process
which listens out for libvirt domain lifecycle events and triggers an
update of the conserver configuration file at appropriate times.
