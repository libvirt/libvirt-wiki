#!/bin/sh

VERSION=$1

if test -z "$VERSION"
then
    echo "syntax: $0 VERSION"
    exit 1
fi

VERDIR=`echo $VERSION | sed -e 's/\.[0-9]*$//'`

DIR=mediawiki-$VERSION
FILE=$DIR.tar.gz
LINK=https://releases.wikimedia.org/mediawiki/$VERDIR/$FILE

if ! test -f "$FILE"
then
    wget $LINK
fi

if ! test -d "$DIR"
then
    tar zxvf $FILE | sed -e "s,^$DIR/,," > new-files.txt
fi

(cd ../mediawiki && find -type f -o -type l | sort) > old-files.txt

for i in `diff old-files.txt local-files.txt | grep '^<' | awk '{print $2}'`
do
    (
	cd ../mediawiki
	test -f $i && git rm $i
    )
done

cp -a $DIR/* ../mediawiki/
cp -a $DIR/.???* ../mediawiki/

for i in `cat new-files.txt`
do
    (
	cd ../mediawiki
	git add $i
    )
done
