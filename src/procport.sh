#!/bin/bash

C='\033['
NC='\033[0m'

if [[ $1 = "kill" ]] 
then
echo procport: Command not yet implemented
exit 1
elif [[ $1 = "find" ]]
then
if [[ $# > 1 ]]
then
    declare -a array
    array=($(netstat -anv -p tcp | grep -E "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\.$2\s"))
    pid=${array[9]}
    declare -a command
    declare -a time
    declare -a stime
    command=($(ps -p $pid -o ucomm))
    stime=($(ps -p $pid -o start))
    start=$(date -jf "%d%b%y" ${stime[1]} "+%B %d, %Y" 2>/dev/null || date -jf "%I:%M%p" ${stime[1]} "+%B %d, %Y at %H:%M %p")
    echo "Application/Command: ${command[1]}"
    echo "PID: ${pid}"
    echo "Started at ${start}"
    echo "Time Elapsed: $(ps -p $pid -o etime | grep \:)"
else
    echo "procport: Syntax Error"
    exit 2
fi

elif [[ $1 = "help" ]]
then
    echo -e "Syntax:

    procport [${C}1;34mfind$NC|${C}0;31mkill$NC|${C}1;34mhelp$NC] [${C}1;35mport$NC]
    
    find: Finds the process bound to a port
    kill: Kills the process bound to a port
    help: Displays this menu"
else
    echo "procport: Invalid command '$1'"
    exit 127
fi

if [[ $([[ \"$(echo $@ | python3 -c "from re import search;[print(search(r'\s-(-debug|v|d)($|\s)', $(echo \"$@\")))]")\" =~ 1 ]] && echo \"true\" || echo \"false\") == \"true\" ]]
then
    echo "\nDebug Info:"
    echo "Arguments passed: $@"
fi
