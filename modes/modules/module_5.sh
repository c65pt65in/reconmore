#!/bin/bash

dir=/usr/share/reconmore/reports/$2
if [ ! -d $dir ]
then
mkdir $dir 
fi
echo -e "\e[32mStarting Module 5-Checking for firewall...\e[0m" | tee -a $dir/report
url="https://${1}"
if ! curl -s -m 5 $url >/dev/null
then
url="http://${1}" 
fi
wafw00f $url | tee -a $dir/report
echo -e "\e[31mReport saved at $dir.\e[0m"
