#!/bin/bash

dir=/usr/share/reconmore/reports/$2
if [ ! -d $dir ]
then
mkdir $dir 
fi
echo -e "\e[32mStarting Module 8-Network footprinting...\e[0m" | tee -a $dir/report
echo -e '\e[33mSearching for TCP ports\e[0m' | tee -a $dir/report
sudo nmap --script /usr/share/reconmore/protection_measures_tcp.nse -n -Pn -p- --defeat-rst-ratelimit -oN all-ports-tcp.nmap $1 | tee -a $dir/report
echo -e '\e[33mSearching for UDP ports\e[0m' | tee -a $dir/report
sudo nmap --script /usr/share/reconmore/protection_measures_udp.nse -n -Pn -sU -sV -p- --version-intensity 0 --max-rtt-timeout 300ms --max-retries 10 --max-scan-delay 1000ms --defeat-icmp-ratelimit -oN all-ports-udp.nmap $1 | tee -a $dir/report
all_tcp=$(cat all-ports-tcp.nmap | awk -F'[/]' 'BEGIN{ORS=","} /open/{print $1}')
all_udp=$(cat all-ports-udp.nmap | awk -F'[/]' 'BEGIN{ORS=","} /open/{print $1}')
echo -e '\e[33mUsing automated scripts to discover common security issues in TCP ports\e[0m' | tee -a $dir/report
if [ ! -z "$all_tcp" ]
then
sudo nmap --script "not dos and not broadcast and not external and not fuzzer" --script-timeout 10m -n -Pn -sV -p $all_tcp $1 | tee -a $dir/report
fi
echo -e '\e[33mUsing automated scripts to discover common security issues in UDP ports\e[0m' | tee -a $dir/report
if [ ! -z "$all_udp" ]
then
sudo nmap --script "not dos and not broadcast and not external and not fuzzer" --script-timeout 10m --version-intensity 0 --max-rtt-timeout 300ms --max-retries 10 --max-scan-delay 10 -n -Pn -sU -sV -p $all_udp $1 | tee -a $dir/report
fi
echo -e "\e[31mReport saved at $dir.\e[0m"
