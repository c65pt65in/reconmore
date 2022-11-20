#!/usr/bin/env python3

import requests
import sys
import subprocess
import re
import random
from lxml import html
import time

def documents_func(input_domain,filename):
    download_dir="/usr/share/reconmore/reports/"+filename+"/downloads"
    url = "https://html.duckduckgo.com/html/?"
    user_agent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:104.0) Gecko/20100101 Firefox/104.0"
    headers = {"user-agent": user_agent, "Accept-Language":"el-GR,el;q=0.8,en-US;q=0.5,en;q=0.3","Connection":"keep-alive", \
              "Content-Type":"application/x-www-form-urlencoded","DNT":"1","Sec-Fetch-Dest":"document","Sec-Fetch-Mode":"navigate","Sec-Fetch-Site":"same-origin", \
              "Sec-Fetch-User":"?1","TE":"trailers","Upgrade-Insecure-Requests":"1", "Host" : "html.duckduckgo.com", "Origin" : "https://html.duckduckgo.com", \
              "Referer" : "https://html.duckduckgo.com/"}
    links=[]
    for x in ['pdf','docx','xlsx','pptx']:
        params = { "q": "filetype:" + x + " site:" + input_domain, "b" : "", "kl" : "", "df":""}
        response = requests.post(url, params=params, headers = headers)
        tree = html.fromstring(response.content)
        result_snippet = tree.xpath('//a[@class="result__snippet"]')
        if len(result_snippet) > 0:
            results = tree.xpath('//a[@class="result__snippet"]/@href')
            links += results
        time.sleep(2)

    if len(links)>0:
        print("Documents found!", flush=True)		
        print("Downloading files in " + download_dir, flush=True)
        i=0
        for link in links:
            print("Downloading file from " + link, flush=True)
            command='wget -P {} {}'.format(download_dir,link)
            subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
            i+=1
        print('Downloaded files:' + str(i), flush=True)			
    else:
        print('No documents found!')

if __name__=="__main__":
    documents_func(sys.argv[1],sys.argv[2])