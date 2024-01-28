#!/bin/bash

if [ "$EUID" -ne 0 ]
then echo "This script must be run as root"
exit
fi
install_dir=/usr/share/reconmore
reports_dir=/usr/share/reconmore/reports 
mkdir -p $install_dir 2> /dev/null
mkdir -p $reports_dir 2> /dev/null
chmod 755 -Rf $install_dir 2> /dev/null
cp -Rf * $install_dir 2> /dev/null
cd $install_dir
apt-get update -y
apt-get install git -y
pyversion=$(python3 --version)
if [[ ! "$pyversion" == *3.8* ]] || [[ ! "$pyversion" == *3.9* ]] || [[ ! "$pyversion" == *3.10* ]];
then
apt-get install python3.10 -y
fi 
apt install python3-pip -y
apt install curl -y
apt-get install dnsutils -y
apt-get install gawk -y
apt-get install whois -y
pip3 install lxml
apt-get install python3-setuptools -y
apt install -y dnsrecon
apt install libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev -y
sudo apt-get install libasound2 -y
apt-get install -y wget
apt install gobuster -y
apt install libimage-exiftool-perl -y
apt install ruby ruby-dev -y
gem install bundler
git clone https://github.com/urbanadventurer/WhatWeb.git
cd WhatWeb
make install
cd ..
git clone https://github.com/jordanpotti/CloudScraper.git
cd CloudScraper
pip3 install -r requirements.txt
cd ..
sed -i 's/url not in base_urls:/url not in base_urls and len(base_urls) <= 100:/' /usr/share/reconmore/CloudScraper/CloudScraper.py
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
git clone https://github.com/EnableSecurity/wafw00f.git
cd wafw00f
python3 setup.py install
cd ..
apt-get install nmap -y
wget https://github.com/Arachni/arachni/releases/download/v1.6.1.3/arachni-1.6.1.3-0.6.1.1-linux-x86_64.tar.gz
tar -xzvf arachni-1.6.1.3-0.6.1.1-linux-x86_64.tar.gz
chmod 777 -Rf /usr/share/reconmore/arachni-1.6.1.3-0.6.1.1 2>/dev/null
pip3 install --upgrade requests
chmod -R +x /usr/share/reconmore/*
ln -s /usr/share/reconmore/reconmore.py /usr/bin/reconmore
