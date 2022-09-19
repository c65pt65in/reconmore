--HEAD--
description = [[This script displays the protection measures regarding the most common open tcp ports.]]
author = "S.C."
local shortport = require "shortport"
--RULE--
portrule = shortport.portnumber({80,443,23,21,22,25,465,587,110,143,3389,445,139,53,135,3306,8080,1723,111,5900,1433,49152},"tcp")
--ACTION--
action = function (host,port)
            if port.number == 80 then
               print("\27[31mPORT 80: It is advised that port 443 (SSL/TLS encryption) is used instead, the web server software is updated and the website or web application is examined for common vulnerabilities! \27[0m")
            elseif port.number == 443 then
               print("\27[31mPORT 443: It is advised that the web server software is updated and the website or web application is examined for common vulnerabilities!\27[0m")
            elseif port.number == 23 then
               print("\27[31mPORT 23: It is advised that this port should be closed!\27[0m")
            elseif port.number == 21 then
               print("\27[31mPORT 21: It is advised that this port should be closed and instead port 22 (SFTP) is used!\27[0m")
            elseif port.number == 22 then
               print("\27[31mPORT 22: It is advised to use strong cipher algorithms and disable root login!\27[0m")
            elseif port.number == 25 then
               print("\27[31mPORT 25: It is advised that this port is used only for communication between mail servers!\27[0m")
            elseif port.number == 465 then
               print("\27[31mPORT 465: It is advised that this port is not used.\27[0m")
            elseif port.number == 587 then
               print("\27[31mPORT 587: It is advised that this port is only used for communication between  mail clients and mail servers!\27[0m")
            elseif port.number == 110 then
               print("\27[31mPORT 110: It is advised that this port should be closed and port 995(POP3S) is used instead.\27[0m")
            elseif port.number == 143 then
               print("\27[31mPORT 143: It is advised that this port should be closed and port 993(IMAPS) is used instead!\27[0m")
            elseif port.number == 3389 then
               print("\27[31mPORT 3389: It is advised that access to this port is restricted by a firewall or VPN, strong user passwords are used and a lockout account policy is set!\27[0m")
            elseif port.number == 445 then
               print("\27[31mPORT 445: It is advised that access to this port is restricted by a firewall or VPN and SMB version 1 is disabled!\27[0m")
            elseif port.number == 139 then
               print("\27[31mPORT 139: It is advised that this port should be closed and SMB in port 445 is used instead!\27[0m")
            elseif port.number == 53 then
               print("\27[31mPORT 53: It is advised to examine DNS configuration with appropriate tools!\27[0m")
            elseif port.number == 135 then
               print("\27[31mPORT 135: It is advised that access is restricted to this port by a firewall, the latest protocol version is used and anonymous (Null Sessions) are disallowed!\27[0m")
            elseif port.number == 3306 then
               print("\27[31mPORT 3306: It is advised that MySQL server version is updated and properly configured regarding granting privileges to users, requiring strong passwords and avoiding empty password for root or anonymous!\27[0m")
            elseif port.number == 8080 then
               print("\27[31mPORT 8080: It is advised that port 443(SSL/TLS encryption) is used instead!\27[0m")
            elseif port.number == 1723 then
               print("\27[31mPORT 1723: It is advised that this port should be closed and not used for VPN implementation!\27[0m")
            elseif port.number == 111 then
               print("\27[31mPORT 111: It is advised that this port should be closed otherwise access should be restricted!\27[0m")
            elseif port.number == 5900 then
               print("\27[31mPORT 5900: It is advised to tunnel VNC over an SSH or VPN connection and be careful which VNC appliction is used!\27[0m")
            elseif port.number == 1433 then
               print("\27[31mPORT 1433: It is advised that access to this port is protected by setting strong passwords for users and administrators, avoiding empty passwords and implementing account lockout policy. Also, for authentication it is advised to use the mode that leverages Active Directory (AD) capabilities!\27[0m")
            elseif port.number >= 49152 and port.number <= 65535 then
               print("\27[31mPORT ".. port.number ..":".."It is advised that traffic in this port is limited with a firewall!\27[0m")
            end
         end