#!/bin/bash

mkdir -p build/

for d in */ ; do
d=${d%/}
if [ "$d" != "build" ]
then
	cd $d
	echo Packing $d.tar.gz
	tar cfz ../build/$d.tar.gz *
	cd ..
fi
done

