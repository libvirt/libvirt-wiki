.. contents::

libvirt-snmp
============

This is a subproject of libvirt. It provides SNMP functionality for
libvirt. Users can monitor domains as well as set domain attributes over
SNMP. All from one place.

Features
--------

Libvirt-snmp allows users to:

-  Request information about domain status
-  Control domain lifecycle
-  Be informed about any domain lifecycle event

Concepts
--------

To provide all functionality, we need a SNMP agent, which connects to a
running libvirt daemon and listens for incoming requests. When a request
arrives agent calls appropriate libvirt functions and sends the result
back in a typical request-response mechanism. In addition libvirt-snmp
monitors domains' activity and sends asynchronous traps to the network
management system. So, for instance when a domain unexpectedly crashes
the network management system is notified immediately. Following image
shows the difference:

.. image:: images/SNMP_RequestResponse_VS_Trap.png

Libvirt-snmp now provides a simple table of domains. Each row contains:

#. domain name
#. state of domain
#. cpu count defined for domain
#. current allocated memory
#. memory limit for domain
#. cpu time
#. row status

Currently, domain state and row status can be set from outside. Others
are read-only. Every time a request for a table is received, the agent
gathers all necessary info from libvirt daemon, fills in all cells and
sends table back. When user wants to set a row, appropriate libvirt
functions are called and the success of operation is reported.

All domains are referred via UUID, which only can be considered unique.

Download
--------

Sources can be downloaded via git:

::

   $ git clone https://gitlab.com/libvirt/libvirt-snmp.git

or viewed online:

::

   https://gitlab.com/libvirt/libvirt-snmp

Development Guide
-----------------

Since this is a sub-project, all rules from libvirt apply. For more read
libvirt `contributor guidelines <http://libvirt.org/hacking.html>`__.
Contributions to this project are **VERY** welcome.

Compilation & Install
---------------------

To compile and install libvirt-snmp, you will need a couple of packages
installed:

::

   $ sudo yum install net-snmp-perl net-snmp net-snmp-utils net-snmp-devel libvirt-devel

On some systems additional packages may be required like openssl-devel
and zlib-devel. Then just enter the directory containing the package's
source code and run:

::

   $ ./autobuild.sh

It will produce an executable binary in build/src subdirectory and also
an rpm package. By default, the rpm is located in
$HOME/rpmbuild/RPMS/<arch>/. To install the package enter that directory
and run:

::

   $ sudo yum --nogpgcheck localinstall libvirt-snmp-*.rpm

or use a more specific package name if you have several versions there.
After a successful installation you should be able to run:

::

   $ sudo libvirtMib_subagent -H -L

-H means to print the list of configuration file directives, -L prints
errors to stderr.

Also, there is another important file installed: LIBVIRT-MIB.txt. If you
are familiar with SNMP terminology this is the MIB which defines the
information base for libvirt-snmp. It is needed so snmp tools (snmpwalk,
snmptable, snmpset, etc.) knows what are they working with, what
variables, which are read-only and which can be set, etc.

Configuration
-------------

Before we run our fresh installed libvirt-snmp agent a little
configuration is needed. First of all, snmpd.conf needs to be changed.
Usually it is located in /etc/snmp/ directory. Whatever it contains, we
need it to contain these lines only:

::

   rwcommunity public
   master agentx
   trapcommunity public
   trap2sink  localhost

Any previous configuration (especially default) must be replaced. The
first defines read-write access community name, the second will enable
the AgentX functionality. The last two says where are traps send and
default community string to be used when sending traps.

The libvirt `connection uri <http://libvirt.org/uri.html>`__ can be set
via environment variable LIBVIRT_DEFAULT_URI. For instance:

::

   # LIBVIRT_DEFAULT_URI="qemu:///system" libvirtMib_subagent -f -L

Please note, that subagent needs to be run as root, or it will fail to
connect to snmp daemon running.

It might also be useful to configure your snmptrap daemon. But this is
not required and following configuration should be considered as an
example, because it will not cover needs of all users. Listing of
/etc/snmp/snmptrapd.conf:

::

   # Example configuration file for snmptrapd
   authCommunity log,execute,net public
   logOption f /var/log/snmptraps.log

The first option let traps with 'public' community string to be logged,
allowed to trigger associated executable actions and forward data to the
network. The second one specifies log destination.

It is also important to let snmptrap daemon load libvirt MIB module.
This can be done by adding '-m ALL' to snmptrapd startup options
(/etc/sysconfig/snmptrapd):

::

   OPTIONS="-m ALL -p /var/run/snmptrapd.pid"

Examples of use
---------------

Once we have a libvirt-snmp agent running, we can try some examples.

First try running snmpwalk:

::

   $ snmpwalk -m ALL -v 2c -c public -OX localhost libvirtMIB

it should print something like this:

::

   LIBVIRT-MIB::libvirtGuestName[STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8] = STRING: "test1"
   LIBVIRT-MIB::libvirtGuestState[STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8] = INTEGER: running(1)
   LIBVIRT-MIB::libvirtGuestCpuCount[STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8] = Gauge32: 1
   LIBVIRT-MIB::libvirtGuestMemoryCurrent[STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8] = Gauge32: 512
   LIBVIRT-MIB::libvirtGuestMemoryLimit[STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8] = Gauge32: 512
   LIBVIRT-MIB::libvirtGuestCpuTime[STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8] = Counter64: 1836840000000
   LIBVIRT-MIB::libvirtGuestRowStatus[STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8] = INTEGER: active(1)

Here we can see a one domain running, with name test1, 512MB both memory
usage and limit, 1 CPU and 1836840000000 nanoseconds of CPU time used by
domain. Then we have it's UUID (7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8) so
we can refer to a domain without ambiguity.

If you don't see such output you might have no domain running. Please
note, that we show only not-shutdown domains.

We can actually show snmp table:

::

   $ snmptable -m ALL -v 2c -c public -Cb localhost libvirtGuestTable

which will produce a nice looking output:

::

   SNMP table: LIBVIRT-MIB::libvirtGuestTable
      Name   State CpuCount MemoryCurrent MemoryLimit       CpuTime RowStatus
   "test1" running        1           512         512 1889430000000    active

| Now we can set the state of a domain (running->paused,
  paused->running, running->shutdown):

::

   $ snmpset -m ALL -v 2c -c public localhost libvirtGuestState.\'7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8\' = paused

::

   $ snmpset -m ALL -v 2c -c public localhost libvirtGuestState.\'7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8\' = running

::

   $ snmpset -m ALL -v 2c -c public localhost libvirtGuestState.\'7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8\' = shutdown

However, it is possible to start a machine, but we need to know it's
UUID:

::

   $ snmpset -m ALL -v 2c -c public localhost libvirtGuestRowStatus.\'7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8\' = createAndGo

or destroy it:

::

   $ snmpset -m ALL -v 2c -c public localhost libvirtGuestRowStatus.\'7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8\' = destroy

Moreover, when you have your snmptrapd configured, you can see an traps
captured in /var/log/messages:

::

   ps-ad2k8.brq.redhat.com [UDP: [127.0.0.1]:53568->[127.0.0.1]]: Trap , DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (636682) 1:46:06.82,
    SNMPv2-MIB::snmpTrapOID.0 = OID: LIBVIRT-MIB::libvirtGuestNotif,
    LIBVIRT-MIB::libvirtGuestName.0 = STRING: "test1",
    LIBVIRT-MIB::libvirtGuestUUID.1 = STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8,
    LIBVIRT-MIB::libvirtGuestState.2 = INTEGER: running(1),
    LIBVIRT-MIB::libvirtGuestRowStatus.3 = INTEGER: active(1)
   ps-ad2k8.brq.redhat.com [UDP: [127.0.0.1]:53568->[127.0.0.1]]: Trap , DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (639013) 1:46:30.13,
    SNMPv2-MIB::snmpTrapOID.0 = OID: LIBVIRT-MIB::libvirtGuestNotif,
    LIBVIRT-MIB::libvirtGuestName.0 = STRING: "test1",
    LIBVIRT-MIB::libvirtGuestUUID.1 = STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8,
    LIBVIRT-MIB::libvirtGuestState.2 = INTEGER: paused(3),
    LIBVIRT-MIB::libvirtGuestRowStatus.3 = INTEGER: active(1)
   ps-ad2k8.brq.redhat.com [UDP: [127.0.0.1]:53568->[127.0.0.1]]: Trap , DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (640124) 1:46:41.24,
    SNMPv2-MIB::snmpTrapOID.0 = OID: LIBVIRT-MIB::libvirtGuestNotif,
    LIBVIRT-MIB::libvirtGuestName.0 = STRING: "test1",
    LIBVIRT-MIB::libvirtGuestUUID.1 = STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8,
    LIBVIRT-MIB::libvirtGuestState.2 = INTEGER: running(1),
    LIBVIRT-MIB::libvirtGuestRowStatus.3 = INTEGER: active(1)
   ps-ad2k8.brq.redhat.com [UDP: [127.0.0.1]:53568->[127.0.0.1]]: Trap , DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (641601) 1:46:56.01,
    SNMPv2-MIB::snmpTrapOID.0 = OID: LIBVIRT-MIB::libvirtGuestNotif,
    LIBVIRT-MIB::libvirtGuestName.0 = STRING: "test1",
    LIBVIRT-MIB::libvirtGuestUUID.1 = STRING: 7ad4bc2a-16db-d8c0-1f5a-6cb777e17cd8,
    LIBVIRT-MIB::libvirtGuestState.2 = INTEGER: shutoff(5),
    LIBVIRT-MIB::libvirtGuestRowStatus.3 = INTEGER: notInService(2)
