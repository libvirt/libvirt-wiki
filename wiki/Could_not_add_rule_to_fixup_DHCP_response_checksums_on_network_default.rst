.. contents::

Could not add rule to fixup DHCP response checksums on network 'default'
========================================================================

This is a **warning** message, and is almost always harmless/innocuous,
but is so often erroneously pointed to as "evidence" of a problem that
it warrants a separate entry here.

It is more fully explained in `PXE boot (or dhcp) on guest
failed <PXE_boot_or_dhcp_on_guest_failed.html>`__, but in short - this
is almost always a classic "red herring"; unless the problem you're
experiencing is guests that are unable to acquire IP addresses via DHCP,
this message can and should be completely ignored.
