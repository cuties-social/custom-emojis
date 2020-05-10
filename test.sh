#!/bin/bash

error=false
limit=50k
quiet=false

usage() {
	echo "Test for emojies >= 50K"
	echo ""
	echo "usage: $0 [-q][-u][-h]"
	echo ""
	echo -e "\t-q\tQuiet, no output"
	echo -e "\t-u\tPrint usage (this) and exit"
	echo -e "\t-h\tPrint usage (this) and exit"
	echo -e ""
	echo -e "The Source code is available at https://github.com/cuties-social/custom-emojis"
	echo
}

while getopts 'quh' option; do
	case $option in
		q)
			quiet=true;;
		h)
			usage
			exit 0;;
		u)
			usage
			exit 0;;
	esac
done

if [ $quiet != true ]
then
	echo Listening to large files
fi

for d in */ ; do
d=${d%/}
if [ "$d" != "build" -a "$d" != "import" ]
then
	files="$(find "$d/" -type f -size +$limit -iregex '.*\.\(png\|jpg\|jpeg\)')"
	echo $files | grep -q .
	if [ $? -ne 0 ]
	then
		if [ $quiet != true ]
		then
			echo $d is okay
		fi
	else
		if [ $quiet != true ]
		then
			printf "${d} is faulty\t\t\t!!!!!\n"
			echo Offending Files:
			printf "${files}"
			echo
		fi
		error=true
	fi
fi
done

if [ $error == true ]
then
	exit 1
fi

