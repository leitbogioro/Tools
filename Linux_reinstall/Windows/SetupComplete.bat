@echo off

set setipv4mode=on
set setipv6mode=on

::IPv4 Static
set staticip=IPv4
::IPv4 Subnet
set subnetmask=actualIp4Subnet
::IPv4 Gateway
set gateways=GATE
::IPv4 Dns
set dnsserver1=ipDNS1
set dnsserver2=ipDNS2

::IPv6 Static
set staticip6=ip6Addr
::IPv6 Subnet
set subnetmask6=actualIp6Prefix
::IPv6 Gateway
set gateways6=ip6Gate
::IPv6 Dns
set dns6server1=ip6DNS1
set dns6server2=ip6DNS2

::Find Network Adapter Name
for /f "tokens=6-8" %%i in ('netsh interface ip show int ^| findstr /v /i "disconnected loopback vmware" ^| findstr /n ^^^^ ^| findstr "^[4]"') do set interfaceName=%%i %%j %%k

::Expand system partition
set systemDisk=%SystemDrive:~0,1%
for /f "tokens=2" %%a in ('echo list vol ^| diskpart ^| findstr "\<%systemDisk%\>"') do (echo select disk 0 & echo select vol %%a & echo extend) | diskpart

:: Write IPv4 static configs
echo; %setipv4mode% | find "on" && goto:enable || goto:disable
:enable
wmic nicconfig where ipenabled=true call enablestatic(%staticip%),(%subnetmask%)
::Using IPv4 of local server as a temporary "gateway" to make sure all of static IPv4 configs can be recognized by network service.
wmic nicconfig where ipenabled=true call setgateways(%staticip%)
::Replace temporary gateway to an actual one.
wmic nicconfig where ipenabled=true call setgateways(%gateways%)
wmic nicconfig where ipenabled=true call setdnsserversearchorder(%dnsserver1%,%dnsserver2%)
:disable

:: Write IPv6 static configs
echo; %setipv6mode% | find "on" && goto:enable || goto:disable
:enable
netsh interface ipv6 add address "%interfaceName%" %staticip6%/%subnetmask6%
netsh interface ipv6 add route "::/0" "%interfaceName%" %gateways6%
netsh interface ipv6 add dnsservers "%interfaceName%" %dns6server1%
netsh interface ipv6 add dnsservers "%interfaceName%" %dns6server2%
netsh interface set interface "%interfaceName%" disabled
netsh interface set interface "%interfaceName%" enabled
del %0
pause
:disable
del %0
pause
