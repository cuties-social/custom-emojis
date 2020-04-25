#!/bin/bash

quiet=false
force=false
runtest=true
error=false

usage() {
	echo "Pack all custom emojis to .tar.gz files for mastodon import"
	echo ""
	echo "usage: $0 [-q][-f][-u][-h]"
	echo ""
	echo -e "\t-q\tQuiet, no output"
	echo -e "\t-f\tForce, ignore failed test"
	echo -e "\tprintf't run tests"
	echo -e "\t-u\tPrint usage (this) and exit"
	echo -e "\t-h\tPrint usage (this) and exit"
	echo -e ""
	echo -e "The Source code is available at https://github.com/cuties-social/custom-emojis"
	echo
}

while getopts 'qfnuh' option; do
	case $option in
		q)
			quiet=true;;
		f)
			force=true;;
		n)
			runtest=false;;
		h)
			usage
			exit 0;;
		u)
			usage
			exit 0;;
	esac
done

if [ $runtest ]
then
	output="$(bash ./test.sh)"
	if [ $? != 0 ]
	then
		if [ $quiet != true ]
		then
			echo "Tests failed:"
			printf "${output}"
			echo ""
		fi

		if [ $force != true ]
		then
			exit 1
		else
			if [ $quiet != true ]
			then
				echo "Forced to continue"
			fi
		fi

	fi
fi

mkdir -p build/

for d in */ ; do
d=${d%/}
if [ "$d" != "build" -a "$d" != "import" ]
then
	cd $d

	if [ $quiet != true ]
	then
		printf "Packing $d.tar.gz... "
	fi

	tarout="$(tar cfz ../build/$d.tar.gz * 2>&1)"
	if [ $? != 0 ]
	then
		error=true
	fi
	cd ..

	if [ $error != true ]
	then
		if [ $quiet != true ]
		then
			printf "OK\n"
		fi
	else
		if [ $quiet != true ]
		then
			printf "Failed\t\t\t\t!!!\n"
			if [ $force != true -a $quiet != true ]
			then
				printf "$tarout"
			fi
		fi

		if [ $force != true ]
		then
			exit 1
		fi
	fi
	error=false
fi
done

exit 0
