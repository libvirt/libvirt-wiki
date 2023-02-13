.. contents::

Error "internal error cannot find character device" when trying to connect a domain's console
---------------------------------------------------------------------------------------------

Symptom
~~~~~~~

% virsh console test2 Connected to domain test2 Escape character is ^]
error: internal error cannot find character device (null)


Investigation
~~~~~~~~~~~~~

The error tells there is no serial console configured for the domain.

Solution
~~~~~~~~

Setup serial console in the domain's XML.

1) Add the following XML in domain's XML (using "virsh edit") NOTE: It's
necessary to write this in the <devices>-Section.

::

    <serial type='pty'>
      <target port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>

2) Setup console in guest kernel command line, you can login into the
guest to edit /boot/grub/grub.conf directly, or using tool "virt-edit".
Append following to the guest kernel command line:

::

    console=ttyS0,115200

3) % virsh start vm --console
