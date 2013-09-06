#!/bin/bash

while test $# -gt 0; do
	case "$1" in 
		--help)
			echo " "
			echo 'Usage: log_sum(.sh|.py) [-n N] [-h H|-d D][-c|-2|
-r|-F|-t|-f]<filename>'                        
                        echo " "
                        echo "options:"
                        echo "-n			Limit the number of results to N"
                        echo "-h			Limit the query to the last number of hours (< 24)"
			echo "-d			Limit the query to the last number of days (counting from midnight)"
			echo "-c			Which IP address makes the most number of connection attempts?"
			echo "-2			Which address makes the most number of successful attempts?"
			echo "-r			What are the most common results codes and where do they come from?"
			echo "-F			What are the most common result codes that indicate failure (no auth, not found etc) and where do they come from?"
			echo "-t			Which IP number get the most bytes sent to them?"
			echo "-f			Which IP number sends the most bytes to the server"
                        exit 0
			;;
	esac
done
