#!/bin/bash

timestamp=$(date)

RST2HTML_PROGS=("rst2html5" "rst2html5.py" "rst2html5-3")

unset RST2HTML_BIN
for i in ${RST2HTML_PROGS[@]}; do
    ver=$($i --version 2>/dev/null | grep "Docutils");
    if test "x$ver" != "x"; then
        RST2HTML_BIN=$i
        break;
    fi
done

if test -z ${RST2HTML_BIN+x}; then
    echo "Please uninstall the rst2html5 package and install the docutils package" >&2
    exit 1
fi

rm -rf build
mkdir build
mkdir build/.tmp

cp -R assets/* build
cp -R images/ build

for file in wiki/*.rst; do
    article=$(basename -s .rst $file)

    echo -n "building '$article'"

    ${RST2HTML_BIN} \
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

