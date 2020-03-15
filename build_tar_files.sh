#!/bin/bash

mkdir -p build/

for d in */ ; do
d=${d%/}
if [ "$d" != "build" ]
then
	cd $d
	echo Packing $d.tar.gz
	tar cf ../build/$d.tar.gz *
	cd ..
fi
done

tar cf build/uncategorized.tar.gz *.{png,jpg,jpeg}

