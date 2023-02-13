.. contents::

Setting up libvirt for TLS (Encryption & Authentication)
========================================================

Setting up your virtualisation infrastructure for Transport Layer
Security (TLS) isn't very difficult. However, it can be a bit involved
for someone not already familiar with the details.

These next pages take you through the four main steps involved with
setting up TLS for libvirt, from the high level concepts, through to the
exact steps with examples.

You should be able to follow through, adapting the examples directly for
your own virtualisation infrastructure.


Full list of steps
------------------

#. TLS Concepts in libvirt - **this page**
#. `Create the Certificate Authority Certificate <TLSCreateCACert.html>`__
#. `Create the Server Certificates <TLSCreateServerCerts.html>`__
#. `Create the Client Certificates <TLSCreateClientCerts.html>`__
#. `Configure the libvirt daemon <TLSDaemonConfiguration.html>`__
#. `Further References <TLSFurtherReferences.html>`__


The central concept
-------------------

| At its heart, Transport Layer Security is a way of encrypting
  communication between two computers. The encryption is done using an
  approach called PKI, which stands for Public Key Infrastructure.

| It is fairly simple in concept, always involving one computer, "*the
  client*", establishing a connection with a receiving computer, "*the
  server*".

.. image:: images/Tls_concepts_basic_client_to_server.png

| TLS uses files called *Certificates* for this communication, with the
  client computer starting the connection **always** having a *Client
  Certificate*, and the receiving computer **always** having a *Server
  Certificate*.

.. image:: images/Tls_concepts_basic_client_cert_to_server_cert.png

| If you have the situation where two computers need to communicate with
  each other using TLS, then they **both** need a *Client Certificate*
  and a *Server Certificate*.

.. image:: images/Tls_concepts_basic_client_and_server_with_both_certs.png

| This is also the example scenario we'll be using in these pages.

Our example scenario
--------------------

| In our example scenario, we have two virtualisation host servers. The
  first, *Host System 1*, is named **host1**. The second, *Host System
  2*, is named **host2**.

.. image:: images/Tls_small_two_hosts.png

| In our example environment, these host servers will occasionally need
  to communicate with each other. For example, when moving a virtualised
  guest from host1 to host2, or vice versa. For this to work, they both
  need their own Client Certificate, and Server Certificate.

.. image:: images/Tls_concepts_host1_and_host2_with_both_certs.png

| In our example scenario, we also have an administrative desktop used
  to manage the virtualisation hosts. With it we can connect to either
  of the virtualisation hosts and perform administrative functions like
  creating new guests, moving guests between the hosts, and
  reconfiguring or deleting guests.

| This administrative desktop is named **admindesktop**. It will
  exclusively connect **to** the virtualisation hosts, never receiving
  new connections **from** them. This means it only needs a Client
  Certificate, and does not need it's own Server Certificate.

.. image:: images/Tls_concepts_admin_client_and_both_servers.png

Private Key files
-----------------

Part of the PKI approach used in TLS, means that for every Certificate
file a computer wants to use fully, it must also have a matching
**Private Key** file.

.. image:: images/Tls_concepts_host1_with_both_certs_and_keys.png

| Private Key files are **critically important**, and must be kept very
  secure. They allow any computer with a matching certificate to
  represent itself as **what is in the certificate**.

| For example, Host System 1 has both Client and Server Certificates.
  These certificates contain information stating they are for the system
  *host1*.

| Because only Host System 1 has the private key files for these
  certificates, it is the only one that can say "**I** **am**
  **host1**".

| If an unauthorised person was to obtain one of these key files, they
  could make their own certificates claiming one of their systems is
  *host1* **instead**. This could potentially give them access to your
  virtualisation servers, which is not what you want.

Signing other Certificates
--------------------------

Possessing both a Certificate and its Private Key also gives an
additional benefit, being able to sign other Certificates. This adds a
small, cryptographically secure piece of information to the certificate
file being signed, indicating it is authentic.

This is important, because it allows us to establish a *web of trust*,
where we have all of our certificates signed either by each other, or by
a central certificate we know to be good.


Certificate Authority
---------------------

This approach, of having a central certificate to sign many others is
regarded as good security practice. It also allows for reasonably simple
certificate management when compared to other alternatives, and is the
approach used in libvirt.

This central Certificate is referred to as a **Certificate Authority**
Certificate. We create one in the very first step of our TLS set up on
the next page, then use it for signing every Client and Server
Certificate we create.

.. image:: images/Tls_concepts_ca_cert_signs_other_certs.png
