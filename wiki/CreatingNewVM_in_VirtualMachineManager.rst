.. contents::

Creating a new virtual machine in Virtual Machine Manager
=========================================================

This page takes you through process of creating a new virtual machine
(VM) in Virtual Machine Manager.


Step one: Running Virtual Machine Manager
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Virtual Machine Manager tool is available under **virt-manager**
command. It can be run from console, or desktop window manager
application launcher. Once you have started it, you should see a window
like this:

.. image:: images/Create_new_VM_1.png


Step two: New Virtual Machine dialog
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This dialog can be brought up by hitting the leftmost button in the top
toolbar. This button is also highlighted in the picture above. After you
should see this dialog:

.. image:: images/Create_new_VM_2.png

Here you need first to enter the name of the new VM and choose way how
you want to install the operating system.


Step three: Choposing the location of instalation media
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this step you choose location of instalation media and also the
operating system type and version.

.. image:: images/Create_new_VM_3.png

Please choose the right options in this step, so libvirt choose the
right hypervisor settings.


Step four: Memory and CPU settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now you need to decide how much of your physical RAM can be alocated by
VM and how many processors can be used by it.

.. image:: images/Create_new_VM_4.png


Step five: Storage
~~~~~~~~~~~~~~~~~~

Although you may create a diskless machine, you may also create a new
virtual disk or attach existing one. You may decide how big should the
new virtual disk (also referenced as volume) be.

.. image:: images/Create_new_VM_5.png

You may also choose wheter to allocate entire disk now or use so called
sparse one. Fully allocating storage may take a longer now, but the
operating system instalation phase will be quicker. Skipping allocation
can also cause space issues on the host machine, it the maximum image
size exceeds available storage space.

**Note:** If you choose creating a image on the computer's hard drive,
by default a raw format will be used. If you want to use any other,
choose "**Select managed or other existing storage**". A file dialog
will come up where you can create a new volume by hitting the "**New
Volume**" button.

Step six: Network and summarization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this step you can see the summarization and choose the network VM
should be connected to.

.. image:: images/Create_new_VM_6.png

You can also specify a MAC address for newtork device and/or customize
configuration before install.

Last step: Running a new Virtual Machine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The last step is actually running your fresh new VM.

.. image:: images/Create_new_VM_7.png
