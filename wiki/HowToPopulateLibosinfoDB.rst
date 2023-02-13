.. contents::

How to populate Libosinfo DataBase
==================================

Example of usage
~~~~~~~~~~~~~~~~

First of all we need to get a picture what are the basic data types used
in the `libosinfo <http://fedorahosted.org/libosinfo>`__ and how are
they used. Liboisnfo aim is to have APIs to manage info about various
operating systems, hypervisors ('platform' in libosinfo terminology) and
devices they or their combination support. For example:

::

   #!/usr/bin/python
   from gi.repository import Libosinfo as osinfo;
   loader = osinfo.Loader()
   loader.process_default_path()
   db = loader.get_db()

We create a loader and let it process the default paths. This includes
``/usr/share/libosinfo``, ``/etc/libosinfo/db`` and
``~/.config/libosinfo/db``. Moreover, various paths can be supplied via
``OSINFO_DATA_DIR`` environment variable. In this process, the XML files
(the acutal database) are read in and parsed. Each object in the DB has
its own ID. For some reason, libosinfo coders have decided to use
(nonexistent) URIs for that:
```http://qemu.org/qemu-kvm-0.11.0`` <http://qemu.org/qemu-kvm-0.11.0>`__
or
```http://fedoraproject.org/fedora-10`` <http://fedoraproject.org/fedora-10>`__.
These are referred to as long IDs. If you want, you can use short IDs
(``kvm-0.11.0`` and ``fedora10`` in this case) but you have to be sure
they are unique and don't address more than one long ID.

::

   os = db.get_os("http://fedoraproject.org/fedora-11")
   hv = db.get_platform("http://qemu.org/qemu-kvm-0.11.0")

So now we've actually searched the DB for specific OS and platform.
Simple so far, isn't it?

::

   dep = db.find_deployment(os, hv)
   fltr = osinfo.Filter()
   fltr.add_constraint("class", "net")
   link = dep.get_preferred_device_link(osinfo.DeviceLinkFilter(target_filter = fltr))
   dev = link.get_target()
   print "Device: '" + dev.get_name() + "' Driver: '" + link.get_driver() + "'"

The next thing we need to do once we've obtained OS and platform from
the DB is find so called deployments. This actually combines the two and
tells what devices are supported (okay, the OS and Platform can contain
list of supported devices as well, but don't overtake). This is the part
which needs populating the most. Once we have the deployment, we create
a filter - in this case we want device with 'network' class = NIC and
ask what is the preferred device. We obtain a link which contains
interesting data.

Example of DB
~~~~~~~~~~~~~

::

   <libosinfo version="0.0.1">

   <device id="http://pci-ids.ucw.cz/read/PC/1002/4382">
     <class>audio</class>
     <bus-type>pci</bus-type>
     <vendor>0x1002</vendor>
     <product>0x4382</product>
     <name>SB600 AC97 Audio</name>
   </device>

   <device id="http://pci-ids.ucw.cz/read/PC/1274/5000">
     <class>audio</class>
     <bus-type>pci</bus-type>
     <vendor>0x1274</vendor>
     <product>0x5000</product>
     <name>ES1370</name>
   </device>

   <device id="http://pci-ids.ucw.cz/read/PC/a727/0013">
     <class>net</class>
     <bus-type>pci</bus-type>
     <vendor>0xa727</vendor>
     <product>0x0013</product>
     <name>3CRPAG175 Wireless PC Card</name>
   </device>

   <os id="http://fedoraproject.org/fedora-10">
     <short-id>fedora10</short-id>
     <name>Fedora 10</name>
     <vendor>Fedora Project</vendor>

     <devices>
       <device id="http://pci-ids.ucw.cz/read/PC/1274/5000">
         <driver>ac97</driver>
       </device>
     </devices>

     <resources arch="all">
       <minimum>
         <n-cpus>1</n-cpus>
         <ram>402653184</ram>
       </minimum>

       <recommended>
         <cpu>400000000</cpu>
         <ram>536870912</ram>
         <storage>9663676416</storage>
       </recommended>
     </resources>
   </os>

   <platform id="http://qemu.org/qemu-kvm-0.11.0">
     <upgrades id="http://qemu.org/qemu-kvm-0.10.0" />
     <short-id>kvm-0.11.0</short-id>
     <name>KVM 0.11.0</name>
     <version>0.11.0</version>
     <vendor>qemu</vendor>
     <devices>
       <device id="http://pci-ids.ucw.cz/read/PC/1002/4382" />
       <device id="http://pci-ids.ucw.cz/read/PC/1274/5000" />
       <device id="http://pci-ids.ucw.cz/read/PC/a727/0013" />
     </devices>
   </platform>

   <deployment id="http://fedoraproject.org/fedora-10?kvm-0.11.0">
     <platform id="http://qemu.org/qemu-kvm-0.11.0" />
     <os id="http://fedoraproject.org/fedora-10" />

     <devices>
       <device id="http://pci-ids.ucw.cz/read/PC/1002/4382">
         <driver>ac97</driver>
       </device>
       <device id="http://pci-ids.ucw.cz/read/PC/a727/0013">
         <driver>3com</driver>
       </device>
     </devices>
   </deployment>
   </libosinfo>

Okay, this is rather long, but I think it's selfexplanatory. The RNG
schema is
`here <http://git.fedorahosted.org/cgit/libosinfo.git/tree/data/schemas/libosinfo.rng>`__
(may be outdated a little bit -
`patch <http://www.redhat.com/archives/virt-tools-list/2012-September/msg00009.html>`__
sent upstream).

BTW, running the above example against this DB will throw this output:

::

   Device: '3CRPAG175 Wireless PC Card' Driver: '3com'

Steps to create deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~

As you may already have noticed, ``<os/>`` addresses OS class,
``<platform/>`` addresses Platform and so on. The most crucial part is
the deployment becasue that's what actually make libosinfo usable for
purposes like virt-install: "*Hey, I want to run OS X on hypervisor Y.
What model of NIC should I use? What is the recommended amount of RAM?*"

So what are the steps if I want to participate? Well, just create a new
file under ``data/deployments/`` and fill it with data. Then just send
patch to ``virt-tools-list@redhat.com``.

Optionally, you may need to add new devices to ``data/devices/*.xml``
and/or OS to ``data/oses/*.xml`` or platform to ``data/hypervisors/*``.

**Please note that you should only add those devices which drivers are
there at the time of installation** as this DB is used just at that
time. I know Windows can support virtio if one install the drivers on
already installed system. But that is not what we are looking for in
here, right?
