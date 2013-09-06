#!/bin/bash

NROFRESULTS=
NROFHOURS=
NROFDAYS=
MOSTCONNECTATTEMPTS=
MOSTSUCCESSFULATTEMPTS=
FUNCTION=

while getopts “h:n:d:c2rFtf” OPTION
do
	case $OPTION in
	n)
		NROFRESULTS=$OPTARG
	;;
	h)
		if [[ "$@" != *-d* ]]
		then
			NROFHOURS=$OPTARG
			echo $NROFHOURS
		else
			exit 1;
		fi	
	;;
	d)
		if [[ "$@" != *-h* ]]
		then
			NROFDAYS=$OPTARG
		else
			exit 1;
		fi	
	;;
	c)
		if [[ $@ != *'-2'* && $@ != *'-r'* && $@ != *'-F'* && $@ != *'-t'* && $@ != *'-f'* ]]; then
			FUNCTION='c' >&2
		else
			exit 1;
		fi
	;;
	2)
		if [[ $@ != *'-c'* && $@ != *'-r'* && $@ != *'-F'* && $@ != *'-t'* && $@ != *'-f'* ]]; then
			FUNCTION='2' >&2
		else
			exit 1;
		fi
	;;
	r)
		if [[ $@ != *'-2'* && $@ != *'-c'* && $@ != *'-F'* && $@ != *'-t'* && $@ != *'-f'* ]]; then
			FUNCTION='r' >&2
		else
			exit 1;
		fi
	;;
	F)
		if [[ $@ != *'-2'* && $@ != *'-r'* && $@ != *'-c'* && $@ != *'-t'* && $@ != *'-f'* ]]; then
			FUNCTION='F' >&2
		else
			exit 1;
		fi
	;;
	t)
		if [[ $@ != *'-2'* && $@ != *'-r'* && $@ != *'-F'* && $@ != *'-c'* && $@ != *'-f'* ]]; then
			FUNCTION='t' >&2
		else
			exit 1;
		fi
	;;
	f)
		if [[ $@ != *'-2'* && $@ != *'-r'* && $@ != *'-F'* && $@ != *'-t'* && $@ != *'-c'* ]]; then
			FUNCTION='f' >&2
		else
			exit 1;
		fi
	;;
	esac
done

echo $FUNCTION
