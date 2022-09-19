#!/bin/bash

dir=/usr/share/reconmore/reports/$2
if [ ! -d $dir ]
then
mkdir $dir 
fi
echo -e "\e[32mStarting Module 4-Checking for database vulnerabilities...\e[0m" | tee -a $dir/report
python3 /usr/share/reconmore/sqlmap-dev/sqlmap.py -u $1 --crawl=3 --batch --level=3 --risk=1 --threads=3 --keep-alive --null-connection --random-agent | tee -a $dir/report
echo -e '\e[33mChecking for open ports associated with NoSQL databases\e[0m' | tee -a $dir/report
sudo nmap -p 27017,27018,27019,28017,5984,7473,7474,6379,8087,8098 $1 -oN $dir/nosql_ports.nmap | tee -a $dir/report
var=$(cat $dir/nosql_ports.nmap | grep "open")
if [ ! -z $var ];
then
echo -e '\e[31mPorts associated with NoSQL databases discovered.\e[0m' | tee -a $dir/report
fi