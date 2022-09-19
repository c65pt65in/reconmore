#!/usr/bin/env python3

import os
import sys
import argparse
import re
import subprocess
from datetime import datetime as dt
import modes.normal 
import modes.advanced
import modes.aggressive

if not os.geteuid()==0:
    sys.exit('This script must be run as root')
if sys.version_info[0]==3:
    if sys.version_info[1]==8 or sys.version_info[1]==9 or sys.version_info[1]==10:
        pass
else:
    sys.exit('This script must be run with python3.8+')
	
parser = argparse.ArgumentParser(description = '''Reconmore measures the attack surface of a given domain. There are three modes of operation:
											Normal, Advanced and Aggressive mode as shown in the arguments. By default is used Normal mode with modules no. 1,2,3,5,6. Alternatively,
											every module can be used separately. All scan reports are saved in /usr/share/reconmore/reports.''')								
group = parser.add_mutually_exclusive_group(required=False)
parser.add_argument('domain', metavar = '<target domain name>', help = 'The domain to target (e.g. example.com). Performs simple passive reconnaissance.')
group.add_argument('--advanced', action='store_true', help = 'Use advanced mode. Performs advanced passive and active reconnaissance. Using modules no. 1,2,3,4,5,7,9.')
group.add_argument('--aggressive', action='store_true', help = 'Use aggressive mode. Performs extended passive and active reconnaissance (very slow). Using modules no. 1,2,3,4,5,8,9.')
group.add_argument('-1','--module1', action='store_true', help = 'Gather basic network information.')
group.add_argument('-2','--module2', action='store_true', help = 'Gather emails and documents.')
group.add_argument('-3','--module3', action='store_true', help = 'Gather website technologies.')
group.add_argument('-4','--module4', action='store_true', help = 'Check for database vulnerabilities.')
group.add_argument('-5','--module5', action='store_true', help = 'Gather firewall informations.')
group.add_argument('-6','--module6', action='store_true', help = 'Perform normal network footprinting. Checks 99%% of the TCP and 32%% of the udp most commonly open ports.')
group.add_argument('-7','--module7', action='store_true', help = 'Perform advanced network footprinting. Similar to normal but more stealthy.')
group.add_argument('-8','--module8', action='store_true', help = 'Perform aggressive network footprinting. Uses automated scripts for vulnerability scanning (very slow).')
group.add_argument('-9','--module9', action='store_true', help = 'Perform web application tests.')
args = parser.parse_args()

input_domain = args.domain
def operation():
    now = dt.now()
    recondatetime = dt.isoformat(now)
    filename = input_domain + recondatetime
    if args.advanced==True:
        modes.advanced.advanced_func(input_domain,filename)       
    elif args.aggressive==True:
        modes.aggressive.aggressive_func(input_domain,filename)
    elif args.module1==True:
        subprocess.run(['/usr/share/reconmore/modes/modules/module_1.sh', input_domain, filename])		
    elif args.module2==True:
        subprocess.run(['/usr/share/reconmore/modes/modules/module_2.sh', input_domain, filename])		
    elif args.module3==True:
        subprocess.run(['/usr/share/reconmore/modes/modules/module_3.sh', input_domain, filename])		
    elif args.module4==True:
        subprocess.run(['/usr/share/reconmore/modes/modules/module_4.sh', input_domain, filename])		
    elif args.module5==True:
        subprocess.run(['/usr/share/reconmore/modes/modules/module_5.sh', input_domain, filename])		
    elif args.module6==True:
        subprocess.run(['/usr/share/reconmore/modes/modules/module_6.sh', input_domain, filename])		
    elif args.module7==True:
        subprocess.run(['/usr/share/reconmore/modes/modules/module_7.sh', input_domain, filename])		
    elif args.module8==True:
        subprocess.run(['/usr/share/reconmore/modes/modules/module_8.sh', input_domain, filename])		
    elif args.module9==True:
        subprocess.run(['/usr/share/reconmore/modes/modules/module_9.sh', input_domain, filename])		
    else:        
        modes.normal.normal_func(input_domain,filename)
def domain_validation(input_domain): 
    regex = "^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\\.)+[A-Za-z]{2,6}"
    pattern = re.compile(regex)    
    if(re.search(pattern, input_domain)):
        command = 'host {}'.format(input_domain)
        whois_completed_process = subprocess.run(command,stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        if (whois_completed_process.returncode==0):
            operation()
        else:
            sys.exit('Domain doesn\'t exist.')
    else:
        sys.exit('Not valid domain.')

domain_validation(input_domain)	

  