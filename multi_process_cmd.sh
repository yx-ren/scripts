#/bin/bash

if [ $# -lt 2 ]; then
    echo "usage:[$0] [process_numbers] [exec_cmd]"
    exit -1
fi

process_numbers=$1
cmd=$(echo $@ | sed "s/$process_numbers//g" )

echo "process numbers:[ $process_numbers ]"
echo "exec cmds:[ $cmd ]"

is_number()
{
    number=$1
    expr $number + 1 >/dev/null 2>&1
    [ $? -ne 0 ] && return -1 || return 0
}

is_number $process_numbers
if [ $? -ne 0 ]; then
    echo "process numbers(arg1):[$1] not as a number"
    exit -1
fi

for (( i = 0; i != $process_numbers; i++))
do
    echo "process [$i] exec......"
    $cmd &
done
