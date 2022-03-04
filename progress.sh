#!/bin/bash
clear
printf "
#####################################################
#                                                   #
#       STRESS TEST - program stress-ng             #
#       Stress all CPU and RAM                      #
#                                                   #
#####################################################

"

sudo echo -n "How many MINUTES test should be perform: "

read mins

a=$((mins))
b=$((a*60))


czas=`date '+%F %T'`

echo "Start time     -  $czas"
czasplus=`date -d ''$a' minutes' '+%F %T' `
echo "Estimate time  -  $czasplus"
echo ""
# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:
# 1.2.1.1 Progress : [########################################] 100%
printf "\r`date '+%F %T'` -- Progress : [${_fill// /#}${_empty// /-}] ${_progress}%% "

}

# Variables
_start=1

# This accounts as the "totalState" variable for the ProgressBar function
_end=$b

# Proof of concept

loop() {
for number in $(seq ${_start} ${_end})
do

    ProgressBar ${number} ${_end}
    sleep 1

done

}


stress () {
	sudo stress-ng --cpu 0 --cpu-method all --vm 3 --vm-bytes 90% -t "$mins""m"

}

stress & loop


printf '\nFinished!\n'

