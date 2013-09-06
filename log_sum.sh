#!/bin/bash

NROFRESULTS=
NROFHOURS=
NROFDAYS=
MOSTCONNECTATTEMPTS=
MOSTSUCCESSFULATTEMPTS=
FUNCTION=
FILENAME=

for last; do true; done
FILENAME=$last

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
		else
			exit $?;
		fi	
	;;
	d)
		if [[ "$@" != *-h* ]]
		then
			NROFDAYS=$OPTARG
		else
			exit $?;
		fi	
	;;
	c)
		if [[ $@ != *'-2'* && $@ != *'-r'* && $@ != *'-F'* && $@ != *'-t'* && $@ != *'-f'* ]]; then
			FUNCTION='c' >&2
		else
			exit $?;
		fi
	;;
	2)
		if [[ $@ != *'-c'* && $@ != *'-r'* && $@ != *'-F'* && $@ != *'-t'* && $@ != *'-f'* ]]; then
			FUNCTION='2' >&2
		else
			exit $?;
		fi
	;;
	r)
		if [[ $@ != *'-2'* && $@ != *'-c'* && $@ != *'-F'* && $@ != *'-t'* && $@ != *'-f'* ]]; then
			FUNCTION='r' >&2
		else
			exit $?;
		fi
	;;
	F)
		if [[ $@ != *'-2'* && $@ != *'-r'* && $@ != *'-c'* && $@ != *'-t'* && $@ != *'-f'* ]]; then
			FUNCTION='F' >&2
		else
			exit $?;
		fi
	;;
	t)
		if [[ $@ != *'-2'* && $@ != *'-r'* && $@ != *'-F'* && $@ != *'-c'* && $@ != *'-f'* ]]; then
			FUNCTION='t' >&2
		else
			exit $?;
		fi
	;;
	f)
		if [[ $@ != *'-2'* && $@ != *'-r'* && $@ != *'-F'* && $@ != *'-t'* && $@ != *'-c'* ]]; then
			FUNCTION='f' >&2
		else
			exit $?;
		fi
	;;
	esac
done

echo 'Number of results:' $NROFRESULTS
echo 'Number of hours:' $NROFHOURS
echo 'Number of days:' $NROFDAYS
echo 'Most connection attempts:' $MOSTCONNECTATTEMPTS
echo 'Most successful connection attempts:' $MOSTSUCCESSFULATTEMPTS
echo 'Function to run:' $FUNCTION
echo 'Filename:' $FILENAME
echo $?

getNumberOfConnectAttempts () {
	grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' $FILENAME | uniq -c | sort -rn | head -n $NROFRESULTS
}

getNumberOfConnectAttempts

