#!/bin/bash

UPSTREAM_URL="https://gitlab.com/libvirt/libvirt/-/raw/master/docs/"

DOCS_ASSETS=(
    "fonts/overpass-regular.woff"
    "fonts/LICENSE.rst"
    "fonts/overpass-bold.woff"
    "fonts/overpass-mono-regular.woff"
    "fonts/overpass-mono-light.woff"
    "fonts/overpass-light.woff"
    "fonts/overpass-italic.woff"
    "fonts/overpass-mono-semibold.woff"
    "fonts/overpass-mono-bold.woff"
    "fonts/overpass-bold-italic.woff"
    "fonts/overpass-light-italic.woff"
    "css/generic.css"
    "css/mobile-template.css"
    "css/libvirt-template.css"
    "css/fonts.css"
    "js/main.js"
    "logos/logo-banner-dark-800.png"
    "logos/logo-banner-dark-256.png"
    "logos/logo-banner-light-256.png"
    "android-chrome-192x192.png"
    "android-chrome-256x256.png"
    "apple-touch-icon.png"
    "browserconfig.xml"
    "favicon-16x16.png"
    "favicon-32x32.png"
    "favicon.ico"
    "manifest.json"
    "mstile-150x150.png"
)

BUILD_ASSETS=(
    "404.rst"
    "page.xsl"
)

rm -rf libvirt-assets
mkdir libvirt-assets

for asset in ${DOCS_ASSETS[@]}; do
    d=$(dirname "${asset}")

    echo "Fetching asset $UPSTREAM_URL$asset to libvirt-assets/$asset"

    curl --silent --show-error "$UPSTREAM_URL$asset" --output-dir "libvirt-assets/$d" --create-dirs -O
done

for asset in ${BUILD_ASSETS[@]}; do
    d=$(dirname "${asset}")

    echo "Fetching asset $UPSTREAM_URL$asset to $asset"

    curl --silent --show-error "$UPSTREAM_URL$asset" --output-dir "$d" -O
done
