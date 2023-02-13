.. contents::

Creating VMWare ESXi domain failed with error "this function is not supported by the connection driver: virDomainCreateXML"
---------------------------------------------------------------------------------------------------------------------------

Symptom
~~~~~~~

When creating a VMWare ESXi domain using "virsh create", it fails with
error "this function is not supported by connection driver:
virDomainCreateXML".

% virsh create --file /work/dom1.x

error: Failed to create domain from /work/dom1.xml

error: this function is not supported by the connection driver:
virDomainCreateXML

Investigation
~~~~~~~~~~~~~

virDomainCreateXML creates a transient domain and starts it, however,
ESX(i) doesn't have transient senmatic for domains, so API
virDomainCreateXML doesn't have an implementation in ESX driver.

Solution
~~~~~~~~

To create a ESX(i) domain, one needs to define the domain first, (e.g.
uses "virsh define"), and then starts it (e.g. "virsh start").

% virsh define esx_dom.xml

% virsh start esx_dom
