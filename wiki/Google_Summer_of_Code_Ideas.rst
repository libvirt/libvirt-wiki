.. contents::

This page contains project ideas for upcoming Google Summer of Code.

FAQ
---

`Google Summer of Code FAQ <Google_Summer_of_Code_FAQ.html>`__

Yearly programs
---------------

*  `2024 <Google_Summer_of_Code_2024.html>`__
*  `2023 <Google_Summer_of_Code_2023.html>`__
*  `2022 <Google_Summer_of_Code_2022.html>`__
*  `2021 <Google_Summer_of_Code_2021.html>`__
*  `2020 <Google_Summer_of_Code_2020.html>`__
*  `2019 <Google_Summer_of_Code_2019.html>`__
*  `2018 <Google_Summer_of_Code_2018.html>`__
*  `2017 <Google_Summer_of_Code_2017.html>`__
*  `2016 <Google_Summer_of_Code_2016.html>`__

Template
--------

::

    TITLE
    ~~~~~
    
    **Summary:** Short description of the project
    
    Detailed description of the project.
    
    **Links:**
    -  Wiki links to relevant material
    -  External links to mailing lists or web sites
    
    **Details:**
    -  Skill level: beginner or intermediate or advanced
    -  Project size: 90/175/350 hours
    -  Language: C
    -  Suggested by: Person who suggested the idea

Suggested ideas
---------------

More extensive list of ideas can be found also as
`issues <https://gitlab.com/libvirt/libvirt/-/issues/?sort=created_date&state=opened&label_name[]=gsoc%3A%3Aideas>`__
on our gitlab.

QEMU command line generator XML fuzzing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Using fuzzing techniques to generate unusual XML to feed to
QEMU command line generator

There are a huge number of potential variants of XML documents that can
be fed into libvirt. Only a subset of these are valid for generating
QEMU command lines. It is likely that there are cases where omitting
certain attributes or XML elements will cause the QEMU command line
generator to crash. Using fuzzing techniques to generate unusual XML
documents which could then be fed through the test suite may identify
crashes.

**Details:**

-  Component: libvirt
-  Skill level: intermediate
-  Project size: 350 hours
-  Language: C
-  Mentor: Michal Prívozník <mprivozn@redhat.com>
-  Suggested by: Daniel Berrange


Metadata support for all object schemas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Extend the domain XML <metadata> concept to all object
schemas

The domain XML schema has support for storing arbitrary user/application
specified information in a <metadata> element. Beneath this element,
apps can add custom content isolated in a private XML namespace. Libvirt
will treat this data as a black-box and store it with no modifications.
e.g.

::

    <metadata>
      <lcp:consoles xmlns:lcp="http://libvirt.org/schemas/console-proxy/1.0">
        <lcp:console token="999f5742-2fb5-491c-832b-282b3afdfe0c" type="spice" port="0" insecure="yes"/>
        <lcp:console token="6a92ef00-6f54-4c18-820d-2a2eaf9ac309" type="serial" port="0" insecure="yes"/>
        <lcp:console token="2a7cbf19-079e-4599-923a-8496ceb7cf4b" type="serial" port="1" insecure="yes"/>
        <lcp:console token="3d7bbde9-b9eb-4548-a414-d17fa1968aae" type="console" port="0" insecure="yes"/>
        <lcp:console token="393c6fdd-dbf7-4da9-9ea7-472d2f5ad34c" type="console" port="1" insecure="yes"/>
        <lcp:console token="7b037f4e-10ab-4c1c-8a49-4e33146c693e" type="console" port="2" insecure="yes"/>
      </lcp:consoles>
    </metadata>

There is also a free form <title> and <description> element

There are also public APIs that let applications read/write this
metadata on the fly, without having to redefine the entire XML config.
Changes to this metadata triggered asynchronous event notifications.

The project idea is to extend this concept to all/most other object
types, networks, nwfilters, interfaces, storage pools, storage volumes,
node devices, secrets, etc. This involves

-  Extending the XML schema & corresponding parser/formatter to
   read/write the <title>, <description> and <metadata> elements
-  Add vir{OBJECT}SetMetadata & vir{OBJECT}GetMetadata public APIs for
   each object
-  Add async event callback for each object to notify of changes

For networks, nwfilters, storage pools and secrets this work is mostly a
matter of copying the existing code pattern used for domains. This part
of the project is suitable for total beginners / novices to libvirt.

Storage volumes, interfaces and node devices are more difficult, since
libvirt never stores the master XML anywhere itself - the XML is just
generated on the fly from another place. We could declare that metadata
for those objects is not supported. If we want to get adventurous
though, we could provide custom logic. For example, for storage volumes,
with file based volumes at least, we can use extended attributes on the
file to record metadata. This part of the project is more advanced and
so requires higher skill level. It should be considered optional. It
would be a successful project to simply complete the first part,
covering networks, nwfilters, storage pools and secrets.

**Links:**

**Details:**

-  Skill level: beginner
-  Project size: 175 hours
-  Language: C
-  Mentor: Michal Prívozník <mprivozn@redhat.com>
-  Suggested by: Daniel Berrange


Introducing job control to the storage driver
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Summary:** Implement abstract job control and use it to improve storage driver.

Currently, libvirt support job cancellation and progress reporting on domains.
That is, if there's a long running job on a domain, e.g. migration, libvirt
reports how much data has already been transferred to the destination and how
much still needs to be transferred. However, libvirt lacks such information
reporting in storage area, to which libvirt developers refer to as the storage
driver. The aim is to report progress on several storage tasks, like volume
wiping, file allocation an others.

**Links:**
-  `<https://gitlab.com/libvirt/libvirt/-/issues/18>`__

**Details:**

-  Component: libvirt
-  Skill level: advanced
-  Language: C
-  Expected size: 350 hours
-  Mentor: Michal Privoznik <mprivozn@redhat.com>, Pavel Hrdina <phrdina@redhat.com>
-  Suggested by: Michal Privoznik
