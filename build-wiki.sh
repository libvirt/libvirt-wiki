#!/bin/bash

timestamp=$(date)

rm -rf build
mkdir build
mkdir build/.tmp

cp -R assets/* build
cp -R images/ build

for file in wiki/*.rst; do
    article=$(basename -s .rst $file)

    echo -n "building '$article'"

    rst2html5 \
        --stylesheet= \
        --strict \
        "$file" > build/.tmp/$article.html.in  || exit 1

    xsltproc \
        --stringparam pagesrc "wiki/$article.rst" \
        --stringparam timestamp "$timestamp" \
        --stringparam href_base "" \
        page.xsl \
        build/.tmp/$article.html.in > build/$article.html || exit 1

    echo " ... DONE"
done

rm -rf build/.tmp

xsltproc \
    --stringparam pagesrc "" \
    --stringparam timestamp "$timestamp" \
    --stringparam href_base "/" \
    page.xsl \
    404.html.in > build/404.html || exit 1

echo "checking linking:"

scripts/check-html-references.py --webroot=$(pwd)/build \
    --ignore-image logos/logo-banner-dark-256.png \
    --ignore-image logos/logo-banner-dark-800.png \
    --ignore-image logos/logo-banner-light-256.png || exit 1

echo " [DONE] "

echo "checking for non-relative internal links:"

if scripts/check-html-references.py --webroot=$(pwd)/build --external | grep wiki.libvirt.org; then
    echo " [ERROR] Please use relative links inside the wiki"
    exit 1
else
    echo " [DONE] "
fi

