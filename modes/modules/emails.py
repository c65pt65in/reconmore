#!/usr/bin/env python3

import requests
import sys
import re
import random
from lxml import html
import time

def emails_func(input_domain):
    url = "https://html.duckduckgo.com/html/?"
    url_pgp = "http://keyserver.ubuntu.com/pks/lookup?"
    user_agent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:104.0) Gecko/20100101 Firefox/104.0"
    headers = {"user-agent": user_agent, "Accept-Language":"el-GR,el;q=0.8,en-US;q=0.5,en;q=0.3","Connection":"keep-alive", \
              "Content-Type":"application/x-www-form-urlencoded","DNT":"1","Sec-Fetch-Dest":"document","Sec-Fetch-Mode":"navigate","Sec-Fetch-Site":"same-origin", \
              "Sec-Fetch-User":"?1","TE":"trailers","Upgrade-Insecure-Requests":"1", "Host" : "html.duckduckgo.com", "Origin" : "https://html.duckduckgo.com", \
              "Referer" : "https://html.duckduckgo.com/"}
    params = { "q": "@"+input_domain , "b" : "", "kl" : "", "df":""}
    response = requests.post(url, params=params, headers = headers)
    tree = html.fromstring(response.content)
    result_snippet = tree.xpath('//a[@class="result__snippet"]')
    emails = []
    i = 0
    while i <= 4:
        if len(result_snippet) > 0:
            results = tree.xpath('//a[@class="result__snippet"]')
            for r in results:
                results_text = r.text_content()
                regex = re.compile( '[a-zA-Z0-9.\-_+#~!$&\',;=:]+' + '@' + '[a-zA-Z0-9.-]*' + input_domain)
                emails += regex.findall(results_text)
            form_check = tree.xpath('//div[@class="nav-link"]/form/input/@value')
            if "Previous" in form_check:
                form_names = tree.xpath('(//div[@class="nav-link"]/form)[2]/input/@name')
                form_values = tree.xpath('(//div[@class="nav-link"]/form)[2]/input/@value')
                form_values.pop(0)
            else:
                form_names = tree.xpath('//div[@class="nav-link"]/form/input/@name')
                form_values = tree.xpath('//div[@class="nav-link"]/form/input/@value')
                form_values.pop(0)
            if len(form_names) > 0:
                params = {}
                for j in range(len(form_names)):
                    params.update({form_names[j]:form_values[j]})
                time.sleep(2)
                response = requests.post(url, params=params, headers = headers)
                tree = html.fromstring(response.content)
                result_snippet = tree.xpath('//a[@class="result__snippet"]')
            else:
                break
        i+=1

    params_pgp = { "op": "index", "search": "@"+input_domain }
    response_pgp = requests.get(url_pgp, params=params_pgp)
    tree_pgp = html.fromstring(response_pgp.content)
    results_pgp = tree_pgp.xpath('//span[@class="uid"]')
    if len(results_pgp) > 0:
        for r in results_pgp:
            results_text = r.text_content()
            regex = re.compile( '[a-zA-Z0-9.\-_+#~!$&\',;=:]+' + '@' + '[a-zA-Z0-9.-]*' + input_domain)
            emails += regex.findall(results_text)
    if len(emails) > 0:
        for e in emails:
            print(e)
    else:
        print("No emails found!")
if __name__=="__main__":
    emails_func(sys.argv[1])