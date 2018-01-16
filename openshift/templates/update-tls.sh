#!/bin/sh

function die() {
    echo $*
    exit 1
}

test -f "tls-cert.pem" || die "Missing tls-cert.pem"
test -f "tls-key.pem" || die "Missing tls-key.pem"

TLS_CERT=`cat tls-cert.pem`
TLS_KEY=`cat tls-key.pem`

oc process -f libvirt-wiki-tls.json | oc delete -f -
oc process -p TLS_CERT="$TLS_CERT" -p TLS_KEY="$TLS_KEY" -f libvirt-wiki-tls.json | oc create -f -

