#!/bin/bash

dir=/usr/share/reconmore/reports/$2
if [ ! -d $dir ]
then
mkdir $dir 
fi
echo -e "\e[32mStarting Module 5-Checking for firewall...\e[0m" | tee -a $dir/report
url="https://${1}"
if ! curl -s $url >/dev/null
then
url="http://${1}" 
fi
wafw00f $url | tee -a $dir/report