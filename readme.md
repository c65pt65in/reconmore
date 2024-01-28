## INSTALL  
```
Download Dockerfile
Build with sudo docker build -t reconmore . 
Run with sudo docker run -it reconmore /bin/bash
```
## USAGE  
```
reconmore [-h] [--advanced | --aggressive | -1 | -2 | -3 | -4 | -5 | -6 | -7 | -8 | -9] <target domain name>

Reconmore measures the attack surface of a given domain. There are three modes of operation:
Normal, Advanced and Aggressive mode as shown in the arguments. By default is used Normal mode with modules no. 1,2,3,5,6. 
Alternatively,every module can be used separately. All scan reports are saved in /usr/share/reconmore/reports.  

positional arguments:  
  <target domain name>  The domain to target (e.g. example.com). Performs simple passive reconnaissance.  

optional arguments:  
  -h, --help        Show help message and exit.  
  --advanced        Use advanced mode. Performs advanced passive and active reconnaissance. Using modules no. 1,2,3,4,5,7,9. 
  --aggressive      Use aggressive mode. Performs extended passive and active reconnaissance (very slow). Using modules no. 1,2,3,4,5,8,9.
  -1 --module1      Gather basic domain information.
  -2 --module2      Gather emails and documents.
  -3 --module3      Gather website technologies.
  -4 --module4      Check for database vulnerabilities.
  -5 --module5      Gather firewall informations.
  -6 --module6      Perform normal network footprinting. Checks 99% of the TCP and 32% of the udp most commonly open ports.
  -7 --module7      Perform advanced network footprinting. Similar to normal but more stealthy.
  -8 --module8      Perform aggressive network footprinting. Uses automated scripts for vulnerability scanning (very slow).
  -9 --module9      Perform web application tests.    
```
###### EXAMPLES  
reconmore example.com  
reconmore example.com --advanced  
reconmore example.com -1  
reconmore example.com --module2
