#!/bin/bash

#Variables that will be assigned by the different arguments.
NROFRESULTS=0
NROFHOURS=0
NROFDAYS=0
MOSTCONNECTATTEMPTS=
MOSTSUCCESSFULATTEMPTS=
FUNCTION=
FILENAME=

#Temporary files
touch final_output
touch temp_output
touch temp_output_boundaries
FINALOUTPUT=final_output
TEMPOUTPUT=temp_output
TEMPFILE=temp_output_boundaries

STARTDATE=
ENDDATE=

clean () {
	rm $FINALOUTPUT
	rm $TEMPOUTPUT
	#rm $TEMPFILE
}	

calcHours() {
    STARTDATE=$(tail -1 ${FILENAME} | awk '{print $4}' | sed 's/^\[//' | sed 's/\//\-/g' | sed 's/\:/ /')
    ENDDATE=$(date -d "$STARTDATE $NROFHOURS hours ago" +%s)
}

calcDays() {
	STARTDATE=$(tail -1 ${FILENAME} | awk '{print $4}' | sed 's/^\[//' | sed 's/\//\-/g' | sed 's/\:/ /')
	ENDDATE=$(date -d "$STARTDATE $NROFDAYS days ago" +%s)
}

setTimeLimit() {
	echo
	tac $FILENAME > $TEMPOUTPUT
	while read row
	do
		rowtime=$(echo $row | awk '{print $4}' | sed 's/^\[//' | sed 's/\//\-/g' | sed 's/\:/ /')
		rowtime=$(date -d "$rowtime" +%s)
	if [ $rowtime -ge $ENDDATE ]; then
    		echo $row >> ${TEMPFILE}
	else
		break
	fi
	done < $TEMPOUTPUT
	rm $TEMPOUTPUT
	TEMPOUTPUT=$TEMPFILE
}

#Function to limit how many rows that should be presented for the user, based on -n 
showResults() {
	if [ $NROFRESULTS -gt 0 ]; then
		head -n $NROFRESULTS $FINALOUTPUT
	else
		cat $FINALOUTPUT
	fi
}

#[-c|-2|-r|-F|-t] 
#The -c command, provides the user with a list over most connected ip-addresses.
connectAttempt () {
	awk '{print $1}' $TEMPOUTPUT | sort -rn | uniq -c | sort -rn | awk '{print $2 "\t" $1}' > $FINALOUTPUT
	showResults
}
succConnectAttempt () {
	grep "GET \/.* HTTP/1\.[01]\" 200" $TEMPOUTPUT | awk '{print $1}' | sort -rn | uniq -c | sort -rn | awk '{print $2 "\t" $1 }' > $FINALOUTPUT
	showResults
}
mostCommonResultCodes () {
	awk '{print $9, $1}' $TEMPOUTPUT | sort -rn | uniq -c | sort -rn | awk '{print $2, $3}' > $FINALOUTPUT
	showResults
}
mostCommonFailCodes () {
	grep -v "\/.* HTTP/[01]\.[01]\" 200" $TEMPOUTPUT | awk '{print $1, $9}' | sort -rn | uniq -c | sort -rn | awk '{print $3, $2}' > $FINALOUTPUT
	showResults
}
bytesTransfered () {	
	declare -A byteArray
	while read row
	do
		ip=$(echo $row | awk '{print $1}')
		nrOfBytes=$(echo $row | awk '{print $10}')
		if [  !  ${byteArray["$ip"]} ] 
			then
				byteArray[$ip]="0"
		fi
		byteArray["$ip"]=$(expr "${byteArray[$ip]}" + $nrOfBytes)
	done

	for i in "${!byteArray[@]}"
	do
		echo "$i ${byteArray[$i]}" >> ${FINALOUTPUT}
	done
	showResults | sort -rn -k2 | head -n 1
}

#Check if the file has a size >0
if [ ! -s $FILENAME ]
then
    echo "The file $FILENAME does not exist";
    exit 1;
fi

#Handles the arguments that's passed into the script.
while getopts “n:h:d:c2rFt” OPTION
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
	esac
done

#Shift the Option Index so that the filename gets on position $1
shift `expr $OPTIND - 1`
FILENAME=$1

if [[ -z "$FUNCTION" ]]
then
	echo 'No flags are set.'
	exit
else
	if [[ $NROFHOURS -gt 0 && $NROFHOURS -lt 24 ]]; then
		calcHours
		setTimeLimit	
	elif [[ $NROFDAYS -gt 0 ]]; then
		calcDays
		setTimeLimit
	else
		cat $FILENAME > $TEMPOUTPUT	
	fi
	case $FUNCTION in
	c)
		connectAttempt
	;;
 	2)
		succConnectAttempt
        ;;
        r)
		mostCommonResultCodes
        ;;
        F)
		mostCommonFailCodes
        ;;
        t)
		grep "GET \/.* HTTP/[01]\.[01]\" 200" $TEMPOUTPUT | bytesTransfered
	;;
	esac
fi

clean
