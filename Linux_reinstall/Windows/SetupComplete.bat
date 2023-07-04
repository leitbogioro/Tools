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

echo;%setmode%|find "on"&&goto:enable||goto:disable
:enable
wmic nicconfig where ipenabled=true call enablestatic(%staticip%),(%subnetmask%)
wmic nicconfig where ipenabled=true call setgateways(%gateways%)
wmic nicconfig where ipenabled=true call setdnsserversearchorder(%dnsserver1%,%dnsserver2%)
del %0
:disable
