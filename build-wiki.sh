#!/bin/bash

timestamp=$(date)

RST2HTML_PROGS=("rst2html5" "rst2html5.py" "rst2html5-3")

unset RST2HTML_BIN
for i in ${RST2HTML_PROGS[@]}; do
    # There are two versions of rst2html5 in the wild: one is the version
    # coming from the docutils package, and the other is the one coming
    # from the rst2html5 package. These versions are subtly different,
    # and the wiki can only be successfully generated using the docutils
    # version.
    #
    # The only reliable way to tell the two binaries apart seems to be
    # looking look at their version information: the docutils version
    # will report
    #
    #   rst2html5 (Docutils ..., Python ..., on ...)
    #
    # whereas the rst2html5 version will report
    #
    #   rst2html5 ... (Docutils ..., Python ..., on ...)
    #
    # with the additional bit of information being the version number for
    # the rst2html5 package itself.
    #
    # Use this knowledge to detect the version that we know doesn't work
    # for building the wiki and ignore it
    ver=$($i --version 2>/dev/null | awk '{print $2}')
    if test "$ver" = "(Docutils"; then
        RST2HTML_BIN=$i
        break;
    fi
done

if test -z ${RST2HTML_BIN+x}; then
    echo "rst2html5 not found, please install the docutils package" >&2
    exit 1
fi

rm -rf build
mkdir build
mkdir build/.tmp

cp -R libvirt-assets/* build
cp -R assets/* build
cp -R images/ build

for file in 404.rst wiki/*.rst; do
    article=$(basename -s .rst $file)
    href_base=""

    if [ "$file" = "404.rst" ]; then
        href_base="/"
    fi

    echo -n "building '$article'"

    ${RST2HTML_BIN} \
        --stylesheet= \
        --strict \
        "$file" > build/.tmp/$article.html.in  || exit 1

    xsltproc \
        --stringparam pagesrc "$file" \
        --stringparam timestamp "$timestamp" \
        --stringparam href_base "$href_base" \
        page.xsl \
        build/.tmp/$article.html.in > build/$article.html || exit 1

    echo " ... DONE"
done

rm -rf build/.tmp

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

