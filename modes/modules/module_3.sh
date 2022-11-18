#!/bin/bash

dir=/usr/share/reconmore/reports/$2
if [ ! -d $dir ]
then
mkdir $dir 
fi
echo -e "\e[32mStarting Module 3-Gathering website tehcnologies...\e[0m" | tee -a $dir/report
whatweb -a 3 -v $1 | tee -a $dir/report
echo -e '\e[31mSoftware versions should always be checked for newer!\e[0m' | tee -a $dir/report
allheaders=('HTTP-Strict-Transport-Security' 'Content-Security-Policy' 'Cross-Origin-Resource-Policy' 'X-Frame-Options' 'X-Content-Type-Options' 'Cross-Origin-Embedder-Policy' 'Cross-Origin-Opener-Policy' 'Referrer-Policy' 'Cache-Control' 'Clear-Site-Data')
echo -e '\e[33mGetting HTTP headers...\e[0m' | tee -a $dir/report
curl -s -L -I $1 | tee -a $dir/headers $dir/report
echo -e '\e[33mHTTP Headers not set:\e[0m' | tee -a $dir/report
for header in ${allheaders[@]}
do
if ! grep -iE $header $dir/headers >/dev/null
then
echo -e "\e[31m$header\e[0m" | tee -a $dir/report
fi
done
echo -e '\e[33mSearching for cloud resources...\e[0m' | tee -a $dir/report
url="https://${1}"
if ! curl -s -m 5 $url >/dev/null
then
url="http://${1}" 
fi
python3 /usr/share/reconmore/CloudScraper/CloudScraper.py -u $url -v -p 4 --no-verify 2>/dev/null | tee -a $dir/report 