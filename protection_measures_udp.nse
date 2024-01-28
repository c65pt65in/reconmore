--HEAD--
description = [[This script displays the protection measures regarding the most common open udp ports.]]
author = "S.C."
local shortport = require "shortport"
--RULE--
portrule = shortport.portnumber({137,138,631,161,123,1434,67,500,68,520,1900,4500,514,49152,162,69},"udp")
--ACTION--
action = function (host,port)
            if port.number == 137 then
               print("\27[31mPORT 137: It is advised that this port should be closed and SMB in port 445 is used instead!\27[0m")
            elseif port.number == 138 then
               print("\27[31mPORT 138: It is advised that this port should be closed and SMB in port 445 is used instead!\27[0m")
            elseif port.number == 631 then
               print("\27[31mPORT 631: It is advised that this port is not exposed to the internet!\27[0m")
            elseif port.number == 161 then
               print("\27[31mPORT 161: It is advised that this port uses SNMPv3 with the highest level of security!\27[0m")
            elseif port.number == 123 then
               print("\27[31mPORT 123: It is advised that this port should be closed if time synchronization is not required otherwise access should be restricted!\27[0m")
            elseif port.number == 1434 then
               print("\27[31mPORT 1434: It is advised that this port should be closed if not needed for discovering SQL Server instances!\27[0m")
            elseif port.number == 67 then
               print("\27[31mPORT 67: It is advised to that DHCP MAC address filtering and MAC address check are enabled!\27[0m")
            elseif port.number == 500 then
               print("\27[31mPORT 500: It is advised that access to this port is limited, the default settings are removed and certificates are used for authentication!\27[0m")
            elseif port.number == 68 then
               print("\27[31mPORT 68: It is advised that DHCP MAC address filtering and MAC address check are enabled in the DHCP server!\27[0m")
            elseif port.number == 520 then
               print("\27[31mPORT 520: It is advised that this port should be closed!\27[0m")
            elseif port.number == 1900 then
               print("\27[31mPORT 1900: It is advised that this port should be closed!\27[0m")
            elseif port.number == 4500 then
               print("\27[31mPORT 4500: It is advised that access to this port is limited, the default settings are removed and certificates are used for authentication!\27[0m") 
            elseif port.number == 514 then
               print("\27[31mPORT 514: It is advised that this port is open only in a controlled local network environment!\27[0m")
            elseif port.number >= 49152 and port.number <= 65535 then
               print("\27[31mPORT ".. port.number ..":".."It is advised that traffic in this port is limited with a firewall!\27[0m")
            elseif port.number == 162 then
               print("\27[31mPORT 162: It is advised that this port uses SNMPv3 with the highest level of security and also strong credentials and secure configuration of users, groups and privileges are required!\27[0m")
            elseif port.number == 69 then
               print("\27[31mPORT 69: It is advised that this port should be closed!\27[0m")             
            end
         end
