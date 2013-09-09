#!/bin/bash

NROFRESULTS=
NROFHOURS=
NROFDAYS=
MOSTCONNECTATTEMPTS=
MOSTSUCCESSFULATTEMPTS=
FUNCTION=
FILENAME=

LASTDATE=

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

#Shift the Option Index so that the Filename gets on position $1
shift `expr $OPTIND - 1`
FILENAME=$1

getDate () {
	LASTDATE=$(grep -P -o '(([0-9][0-9])|([3][0-1])).(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec).\d{4}' $FILENAME | tail -1)
	LASTDATE=$(echo $LASTDATE | sed -r 's/[/]+/-/g')
	echo $LASTDATE
}

setDate () {
	STARTDATE=$(date --date "$LASTDATE -$NROFDAYS days" "+%d-%b-%Y")
	echo $STARTDATE
}

connAtt () {
if [[ -z "$NROFRESULTS" ]]; then
	awk '{print $1}' $FILENAME | sort -rn | uniq -c | sort -rn | awk '{print $2 "\t" $1}'
else
	awk '{print $1}' $FILENAME | sort -rn | uniq -c | sort -rn | head -n $NROFRESULTS | awk '{print $2 "\t" $1}'
fi
}

#Check if the file has a size >0
if [ ! -s $FILENAME ]
then
    echo "The file $FILENAME does not exist";
    exit 1;
fi
if [[ "$FUNCTION" == 'c' ]]; then
	connAtt
fi
