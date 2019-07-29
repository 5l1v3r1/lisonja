#!/bin/bash
SCRIPT="./main.sh"
DMY=`date +%F`
echo 'Select attacK:'
echo ''
echo '1 = Cameras'
echo '2 = File hosting'
echo '3 = Empty index'
echo '4 = 401 check'
echo '5 = Port scan check'
echo ''
echo 'All = 999'


read -p '>> ' SELECTION
if [[ $SELECTION == '999' ]]; then
	SCRIPT="./alt.sh"
	cat $1 | xargs -P $2 -I XX $SCRIPT XX $SELECTION
elif [[ $SELECTION == '5' ]]; then

	read -p 'File: ' FILENAME
	read -p 'Port: ' SELPORT
	masscan -e eth0 -oL scanz/$DMY_$SELPORT.txt --rate=151515 -iL $FILENAME -p $SELPORT
	echo "Saved to: sscanz/$DMY_$SELPORT.txt"
else
	cat $1 | xargs -P $2 -I XX $SCRIPT XX $SELECTION
fi