#!/bin/bash

dir=/usr/share/reconmore/reports/$2
mkdir $dir
echo -e "\e[32mStarting Module 1-Gathering network information...\e[0m" | tee -a $dir/report
echo -e '\e[33m## BASIC NETWORK INFORMATION ##\e[0m' | tee -a $dir/report 
domain_ip=$(dig +short $1) 
echo -e '\e[33mIP Address\e[0m' | tee -a $dir/report 
echo $domain_ip | tee -a $dir/report 
echo -e '\e[33mGeneral Information\e[0m' | tee -a $dir/report
whois $domain_ip | tee -a $dir/report
echo -e '\e[33mIP Range\e[0m' | tee -a $dir/report
ip_range=$(whois -h asn.shadowserver.org origin $domain_ip | awk '{print $3}') 
echo $ip_range | tee -a $dir/report
echo -e '\e[33mAutonomous System Number (ASN)\e[0m' | tee -a $dir/report
asn=$(whois -h asn.shadowserver.org origin $domain_ip | awk '{print $5}')
echo $asn | tee -a $dir/report
associated_ips=$(whois -h whois.radb.net -- "-i origin $asn" | grep -Eo "([0-9.]+){4}/[0-9]+" | head)
echo -e '\e[33mAssociated IPs\e[0m' | tee -a $dir/report
echo $associated_ips | tee -a $dir/report
echo -e '\e[33mHighly related IPs\e[0m' | tee -a $dir/report
name=$(echo $1 | cut -d '.' -f1)
for n in $(whois -h whois.radb.net -- "-i origin $asn" | grep -Eo "([0-9.]+){4}/[0-9]+" | head)
do
if [ ! -z "$(whois $n | grep $name)" ]
then
echo $n | tee -a $dir/report
fi
done
echo -e '\e[33m## DNS Information ##\e[0m' | tee -a $dir/report
if [ ! -z "$(dig $1 | grep 'rd ra')" ]
then
echo -e '\e[31mRecursion Allowed!\e[0m' | tee -a $dir/report
fi
dnsrecon -d $1 | tee -a $dir/report
if [ -z "$(cat $dir/report | grep -i 'v=spf')" ]
then
echo -e '\e[31mSender Policy Framework (SPF) protection is not implemented!\e[0m' | tee -a $dir/report
fi
if [ -z "$(cat $dir/report | grep -i 'v=dmarc')" ]
then
echo -e '\e[31mDomain-based Message Authentication, Reporting and Conformance (DMARC) protection is not implemented!\e[0m' | tee -a $dir/report
fi
echo -e '\e[33mChecking for DNS zone transfers\e[0m' | tee -a $dir/report
dnsrecon -d $1 -a | tee -a $dir/report
if cat $dir/report | grep -i 'zone transfer was successful'
then
echo -e '\e[31mZone transfers should be allowed only between name servers that are contained within each zone!\e[0m' | tee -a $dir/report
fi
echo -e '\e[33mPerforming reverse lookup brute force\e[0m' | tee -a $dir/report
dnsrecon -r $ip_range --threads 32 | tee -a $dir/report 
echo -e '\e[33mSearching for subdomains\e[0m' | tee -a $dir/report
gobuster -m dns -u $1 -w /usr/share/reconmore/subdomains-top1mil-5000.txt -t 50 | tee -a $dir/report
echo -e '\e[33mTrying zonewalking\e[0m' | tee -a $dir/report
dnsrecon -d $1 -t zonewalk | tee -a $dir/report
if cat $dir/report | grep -i 'failed to answer the DNSSEC query'
then
echo -e '\e[31mConsider implementing DNSSEC protocol for more protection!\e[0m' | tee -a $dir/report
fi     
echo -e '\e[33mPerforming cache snooping against all nameservers\e[0m' | tee -a $dir/report
for nameserver in $(dig -t ns $1 +noall +answer | awk '{print $5}')
do
nameserver_ip=$(dig +short $nameserver)
timeout -s 9 35s dnsrecon -t snoop --tcp -n $nameserver_ip -D /usr/share/reconmore/subdomains-300.txt 2>/dev/null | tee -a $dir/report
done