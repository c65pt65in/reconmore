#!/bin/bash

dir=/usr/share/reconmore/reports/$2
if [ ! -d $dir ]
then
mkdir $dir 
fi
echo -e "\e[32mStarting Module 2-Gathering emails and documents...\e[0m" | tee -a $dir/report
mkdir -m 777 $dir/downloads 2>/dev/null
echo -e '\e[33mEmails\e[0m' | tee -a $dir/report
python3 /usr/share/reconmore/modes/modules/emails.py $1 | tee -a $dir/report
echo -e '\e[33mDocuments\e[0m' | tee -a $dir/report
python3 /usr/share/reconmore/modes/modules/documents.py $1 $2 | tee -a $dir/report
if [ ! -z "$(ls -A $dir/downloads)" ]
then
echo -e '\e[33mAnalysing downloaded files...\e[0m' | tee -a $dir/report
exiftool $dir/downloads | tee -a $dir/report
echo -e '\e[31mDocuments metadata should be inspected for sensitive information!\e[0m' | tee -a $dir/report
fi
