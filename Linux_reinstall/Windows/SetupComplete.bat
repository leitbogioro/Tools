@echo off

set setmode=on
::Static IP
set staticip=IPv4
::Subnet
set subnetmask=actualIp4Subnet
::Gateway
set gateways=GATE
::Dns
set dnsserver1=ipDNS1
set dnsserver2=ipDNS2
::Expand system partition
set systemDisk=%SystemDrive:~0,1%
for /f "tokens=2" %%a in ('echo list vol ^| diskpart ^| findstr "\<%systemDisk%\>"') do (echo select disk 0 & echo select vol %%a & echo extend) | diskpart

echo;%setmode%|find "on"&&goto:enable||goto:disable
:enable
wmic nicconfig where ipenabled=true call enablestatic(%staticip%),(%subnetmask%)
::Using IPv4 of local server as a temporary "gateway" to make sure all of static IPv4 configs can be recognized by network service.
wmic nicconfig where ipenabled=true call setgateways(%staticip%)
::Replace temporary gateway to an actual one.
wmic nicconfig where ipenabled=true call setgateways(%gateways%)
wmic nicconfig where ipenabled=true call setdnsserversearchorder(%dnsserver1%,%dnsserver2%)
del %0
pause
:disable
del %0
pause
