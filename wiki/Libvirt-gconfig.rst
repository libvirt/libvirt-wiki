.. contents::

Introduction
------------

Overview
~~~~~~~~

Libvirt-gconfig is part of libvirt-glib which wraps libvirt to provide a
high-level object-oriented API better suited for glib-based applications
via three libraries:

libvirt-glib
   GLib main loop integration & misc helper APIs
libvirt-gconfig
   GObjects for manipulating libvirt XML documents
libvirt-gobject
   GObjects for mangling libvirt object

It's distributed under LGPLv2+. The latest official releases can be
found at https://download.libvirt.org/glib

Architecture
------------

Libvirt-gconfig is designed to be perfectly usable even without whole
GLib. Hence, you can create an application using libvirt-gconfig without
need to run GMainLoop.

With libvirt-gconfig you can create any type of object known to bare
libvirt: domain, storage pool, storage volume, etc. Each object has its
own handle assigned with special type: ``GVirConfigDomain`` for domain,
``GVirConfigNetwork`` for network, ``GVirConfigStorageVol`` for storage
volume and so on. Each of these types are derived from GVirConfigObject.
We will meet this fact later, though.

Each object must be created firstly in order to work with it. This can
be done in two ways:

#. creating simple empty object:
   ``GVirConfigDomain *domain = gvir_config_domain_new();``
#. creating object from XML:
   ``GError *error = NULL;``
   ``char *xml = get_xml();``
   ``GVirConfigDomain *domain = gvir_config_domain_new_from_xml(xml, &error);``

Then we can use set/get method over each object attribute we want:

``gvir_config_domain_set_name(domain, "foo");``

``gvir_config_domain_set_virt_type(domain, GVIR_CONFIG_DOMAIN_VIRT_KVM);``

``gvir_config_domain_set_vcpus(domain, 2);``

``gvir_config_domain_set_memory(domain, 2048);``

What each method does can be derived simple from its name. The complete
list of these methods can be seen in libvirt-gconfig GTK documentation.
To generate this documentation pass ``--enable-gtk-doc`` to configure
script.

Some parts of object configuration can be, however, again objects. For
example, ``os`` element in domain XML is represented as
``GVirConfigDomainOs``, domain device is represented by
``GVirConfigDomainDevice`` and so on. However, when creating an
interface it is a type of ``GVirConfigDomainInterface``. So how to
convert it to ``GVirConfigDomainDevice``? There are macros for that:

``GVirConfigDomainInterface interface = GVIR_CONFIG_DOMAIN_INTERFACE(gvir_config_domain_interface_network_new());``

``gvir_config_domain_interface_set_mac(interface, "00:11:22:33:44:55");``

``gvir_config_domain_interface_network_set_source(GVIR_CONFIG_DOMAIN_INTERFACE_NETWORK(interface), "default")``

``gvir_config_domain_add_device(domain, GVIR_CONFIG_DOMAIN_DEVICE(interface))``

Once we have objects created and all attributes set, nothing hold us
from generating a XML for the object:

``xml = gvir_config_object_to_xml(GVIR_CONFIG_OBJECT(domain));``

``printf("%s\n", xml);``

``free(xml);``

It's worth noticing that it's caller responsibility to free returned
string as soon as it's no longer needed.
