#!/bin/bash

dir=/usr/share/reconmore/reports/$2
if [ ! -d $dir ]
then
mkdir $dir 
fi
echo -e "\e[32mStarting Module 7-Network footprinting...\e[0m" | tee -a $dir/report
echo -e '\e[33mSearching for TCP ports\e[0m' | tee -a $dir/report
sudo nmap --mtu 16 --data-length 30 -n -Pn --top-ports 3328 -oN $dir/ports-tcp-3328.nmap $1 | tee -a $dir/report
echo -e '\e[33mSearching for UDP ports\e[0m' | tee -a $dir/report
sudo nmap --mtu 16 --data-length 30 -n -Pn -sU -sV --top-ports 50 -oN $dir/ports-udp-50.nmap $1 | tee -a $dir/report
all_tcp=$(cat $dir/ports-tcp-3328.nmap | awk -F'[/]' 'BEGIN{ORS=","} /open/{print $1}')
all_udp=$(cat $dir/ports-udp-50.nmap | awk -F'[/]' 'BEGIN{ORS=","} /open/{print $1}')
echo -e '\e[33mUsing automated scripts to discover common security issues in tcp ports\e[0m' | tee -a $dir/report
if [ ! -z "$all_tcp" ]
then
sudo nmap -n -Pn --script default,/usr/share/reconmore/protection_measures_tcp.nse -sV -p $all_tcp $1 | tee -a $dir/report 
fi
echo -e '\e[33mUsing automated scripts to discover common security issues in udp ports\e[0m' | tee -a $dir/report
if [ ! -z "$all_udp" ]
then
sudo nmap -n -Pn -sU --script default,/usr/share/reconmore/protection_measures_udp.nse -sV -p $all_udp $1 | tee -a $dir/report
fi
echo -e "\e[31mReport saved at $dir.\e[0m"
