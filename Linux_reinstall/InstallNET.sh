#!/bin/bash
##
## License: GPL
## It can reinstall Debian, Ubuntu, Kali, AlpineLinux, CentOS, AlmaLinux, RockyLinux, Fedora and Windows OS via network automatically without any other external measures and manual operations.
## Default root password: LeitboGi0ro
## Written By MoeClub.org
## Blog: https://moeclub.org
## Modified By 秋水逸冰
## Blog: https://teddysun.com/
## Modified By VPS收割者
## Blog: https://www.idcoffer.com/
## Modified By airium
## Blog: https://github.com/airium
## Modified By 王煎饼
## Github: https://github.com/bin456789/
## Modified By nat.ee
## Forum: https://hostloc.com/space-uid-49984.html
## Modified By Leitbogioro
## Blog: https://www.zhihu.com/column/originaltechnic

# color
underLine='\033[4m'
aoiBlue='\033[36m'
blue='\033[34m'
yellow='\033[33m'
green='\033[32m'
red='\033[31m'
plain='\033[0m'

export tmpVER=''
export tmpDIST=''
export tmpURL=''
export tmpWORD=''
export tmpMirror=''
export tmpDHCP=''
export targetRelese=''
export targetLang='cn'
export TimeZone=''
export ipAddr=''
export ipMask=''
export ipGate=''
export ipDNS='1.0.0.1 8.8.4.4'
export ip6Addr=''
export ip6Mask=''
export ip6Gate=''
export ip6DNS='2606:4700:4700::1001 2001:4860:4860::8844'
export IncDisk=''
export interface=''
export interfaceSelect=''
export setInterfaceName='0'
export autoPlugAdapter='0'
export IsCN=''
export Relese=''
export sshPORT=''
export ddMode='0'
export setNet='0'
export setNetbootXyz='0'
export setRDP='0'
export tmpSetIPv6=''
export setIPv6='1'
export setRaid=''
export setDisk='0'
export setMemCheck='1'
export isMirror='0'
export FindDists='0'
export setFileType=''
export loaderMode='0'
export LANG="en_US.UTF-8"
export IncFirmware='0'
export SpikCheckDIST='0'
export UNKNOWHW='0'
export UNVER='6.4'
export GRUBDIR=''
export GRUBFILE=''
export GRUBVER=''
export VER=''
export setCMD=""
export setConsole=''
export setAutoConfig='1'
export FirmwareImage=''
export AddNum='1'
export DebianModifiedProcession='echo "";'

while [[ $# -ge 1 ]]; do
  case $1 in
    -version)
      shift
      tmpVER="$1"
      shift
      ;;
    -debian|-Debian)
      shift
      Relese='Debian'
      tmpDIST="$1"
      shift
      ;;
    -ubuntu|-Ubuntu)
      shift
      ddMode='1'
      finalDIST="$1"
      targetRelese='Ubuntu'
      shift
      ;;
    -kali|-Kali)
      shift
      Relese='Kali'
      tmpDIST="$1"
      shift
      ;;
    -centos|-CentOS|-cent|-Cent)
      shift
      Relese='CentOS'
      tmpDIST="$1"
      shift
      ;;
    -rocky|-rockylinux|-RockyLinux)
      shift
      Relese='RockyLinux'
      tmpDIST="$1"
      shift
      ;;
    -alma|-almalinux|-AlmaLinux)
      shift
      Relese='AlmaLinux'
      tmpDIST="$1"
      shift
      ;;
    -fedora|-Fedora)
      shift
      Relese='Fedora'
      tmpDIST="$1"
      shift
      ;;
    -alpine|-alpinelinux|-AlpineLinux|-alpineLinux)
      shift
      Relese='AlpineLinux'
      tmpDIST="$1"
      shift
      ;;
    -win|-windows)
      shift
      ddMode='1'
      finalDIST="$1"
      targetRelese='Windows'
      shift
      ;;
    -lang|-language)
      shift
      targetLang="$1"
      shift
      ;;
    -dd|--image)
      shift
      ddMode='1'
      tmpURL="$1"
      shift
      ;;
    --ip-addr)
      shift
      ipAddr="$1"
      shift
      ;;
    --ip-mask)
      shift
      ipMask="$1"
      shift
      ;;
    --ip-gate)
      shift
      ipGate="$1"
      shift
      ;;
    --ip-dns)
      shift
      ipDNS="$1"
      shift
      ;;
    --ip6-addr)
      shift
      ip6Addr="$1"
      shift
      ;;
    --ip6-mask)
      shift
      ip6Mask="$1"
      shift
      ;;
    --ip6-gate)
      shift
      ip6Gate="$1"
      shift
      ;;
    --ip6-dns)
      shift
      ip6DNS="$1"
      shift
      ;;
    --network)
      shift
      tmpDHCP="$1"
      shift
      ;;
    --adapter)
      shift
      interfaceSelect="$1"
      shift
      ;;
    --netdevice-unite)
      shift
      setInterfaceName='1'
      ;;
    --autoplugadapter)
      shift
      autoPlugAdapter='1'
      ;;
    --loader)
      shift
      loaderMode='1'
      ;;
    -mirror)
      shift
      isMirror='1'
      tmpMirror="$1"
      shift
      ;;
    -rdp)
      shift
      setRDP='1'
      WinRemote="$1"
      shift
      ;;
    -raid)
      shift
      setRaid="$1"
      shift
      ;;
    -timezone)
      shift
      TimeZone="$1"
      shift
      ;;
    -cmd)
      shift
      setCMD="$1"
      shift
      ;;
    -console)
      shift
      setConsole="$1"
      shift
      ;;
    -firmware)
      shift
      IncFirmware="1"
      shift
      ;;
    -filetype)
      shift
      setFileType="$1"
      shift
      ;;
    -port)
      shift
      sshPORT="$1"
      shift
      ;;
    -pwd)
      shift
      tmpWORD="$1"
      shift
      ;;
    -setdisk)
      shift
      setDisk="$1"
      shift
      ;;
    --setipv6)
      shift
      tmpSetIPv6="$1"
      shift
      ;;
    --allbymyself)
      shift
      setAutoConfig='0'
      ;;
    --nomemcheck)
      shift
      setMemCheck='0'
      ;;
    -netbootxyz)
      shift
      setNetbootXyz='1'
      shift
      ;;
    *)
      if [[ "$1" != 'error' ]]; then echo -ne "\nInvaild option: '$1'\n\n"; fi
      echo -ne " Usage:\n\tbash $(basename $0)\t-debian       [${underLine}${yellow}dists-name${plain}]\n\t\t\t\t-ubuntu       [${underLine}dists-name${plain}]\n\t\t\t\t-kali         [${underLine}dists-name${plain}]\n\t\t\t\t-alpine         [${underLine}dists-name${plain}]\n\t\t\t\t-centos       [${underLine}dists-name${plain}]\n\t\t\t\t-rockylinux   [${underLine}dists-name${plain}]\n\t\t\t\t-almalinux    [${underLine}dists-name${plain}]\n\t\t\t\t-fedora       [${underLine}dists-name${plain}]\n\t\t\t\t-version      [32/i386|64/${underLine}${yellow}amd64${plain}|arm/${underLine}${yellow}arm64${plain}] [${underLine}${yellow}dists-verison${plain}]\n\t\t\t\t--ip-addr/--ip-gate/--ip-mask\n\t\t\t\t-apt/-yum/-mirror\n\t\t\t\t-dd/--image\n\t\t\t\t-pwd          [linux password]\n\t\t\t\t-port         [linux ssh port]\n"
      exit 1
      ;;
    esac
  done

# Check Root
[[ "$EUID" -ne '0' || $(id -u) != '0' ]] && echo -ne "\n[${red}Error${plain}] This script must be executed as root!\n\nTry to type:\n${yellow}sudo -s\n${plain}\nAfter entering the password, switch to root dir to execute this script:\n${yellow}cd ~${plain}\n\n" && exit 1

# Ping delay to YouTube($1) and Instagram($2) and Wikipedia($3), support both ipv4 and ipv6, $4 is $IPStackType
function checkCN() {
  for TestUrl in "$1" "$2" "$3"; do
# "rtt" result of ping command of Alpine Linux is "round-trip" and it can't handle "sed -n" well.
    IPv4PingDelay=`ping -4 -c 2 -w 2 "$TestUrl" | grep "rtt\|round-trip" | cut -d'/' -f5 | awk -F'.' '{print $NF}' | sed -E '/^[0-9]\+\(\.[0-9]\+\)\?$/p'`
    IPv6PingDelay=`ping -6 -c 2 -w 2 "$TestUrl" | grep "rtt\|round-trip" | cut -d'/' -f5 | awk -F'.' '{print $NF}' | sed -E '/^[0-9]\+\(\.[0-9]\+\)\?$/p'`
    if [[ "$4"="BiStack" ]]; then
      if [[ "$IPv4PingDelay" != "" ]] || [[ "$IPv6PingDelay" != "" ]]; then
        IsCN=""
        IsCN=`echo -e "$IsCN"`"$IsCN"
      else
        IsCN="cn"
      fi
    elif [[ "$4"="IPv4Stack" ]]; then
      if [[ "$IPv4PingDelay" != "" ]]; then
        IsCN=""
        IsCN=`echo -e "$IsCN"`"$IsCN"
      else
        IsCN="cn"
        IsCN=`echo -e "$IsCN"`"$IsCN"
      fi
    elif [[ "$4"="IPv6Stack" ]]; then
      if [[ "$IPv6PingDelay" != "" ]]; then
        IsCN=""
        IsCN=`echo -e "$IsCN"`"$IsCN"
      else
        IsCN="cn"
        IsCN=`echo -e "$IsCN"`"$IsCN"
      fi
    fi
  done
  [[ `echo "$IsCN" | grep "cn"` != "" ]] && IsCN="cn" || IsCN=""
  if [[ "$IsCN" == "cn" ]]; then
    ipDNS="119.29.29.29 223.6.6.6"
    ip6DNS="2402:4e00:: 2400:3200::1"
  fi
}

# "$1" is "$ipDNS" or "$ip6DNS"
# The delimiter of several dns settings in automatic response file of Debian is " "(space), for RedHat, it's ","(comma).
# Reference: https://lists.debian.org/debian-user/2009/10/msg00149.html
#            https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax
function checkDNS() {
  if [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then   
    tmpDNS=`echo $1 | sed 's/ /,/g'`
    echo "$tmpDNS"
  else
    echo "$1"
  fi
}

function dependence() {
  Full='0';
  for BIN_DEP in `echo "$1" |sed 's/,/\n/g'`
    do
      if [[ -n "$BIN_DEP" ]]; then
        Found='0';
        for BIN_PATH in `echo "$PATH" |sed 's/:/\n/g'`
          do
            ls $BIN_PATH/$BIN_DEP >/dev/null 2>&1;
            if [ $? == '0' ]; then
              Found='1';
              break;
            fi
          done
        if [ "$Found" == '1' ]; then
          echo -en "[${green}ok${plain}]\t";
        else
          Full='1';
          echo -en "[${red}Not Install${plain}]";
        fi
        echo -en "\t$BIN_DEP\n";
      fi
    done
  if [ "$Full" == '1' ]; then
    echo -ne "\n[${red}Error${plain}] Please use '${yellow}apt-get${plain}' or '${yellow}yum / dnf${plain}' install it. \n\n"
    exit 1;
  fi
}

function selectMirror() {
  [ $# -ge 3 ] || exit 1
  Relese=$(echo "$1" |sed -r 's/(.*)/\L\1/')
  DIST=$(echo "$2" |sed 's/\ //g' |sed -r 's/(.*)/\L\1/')
  VER=$(echo "$3" |sed 's/\ //g' |sed -r 's/(.*)/\L\1/')
  New=$(echo "$4" |sed 's/\ //g')
  [ -n "$Relese" ] && [ -n "$DIST" ] && [ -n "$VER" ] || exit 1
  if [ "$Relese" == "debian" ] || [ "$Relese" == "ubuntu" ] || [ "$Relese" == "kali" ]; then
    [ "$DIST" == "focal" ] && legacy="legacy-" || legacy=""
    TEMP="SUB_MIRROR/dists/${DIST}/main/installer-${VER}/current/${legacy}images/netboot/${Relese}-installer/${VER}/initrd.gz"
    [[ "$Relese" == "kali" ]] && TEMP="SUB_MIRROR/dists/${DIST}/main/installer-${VER}/current/images/netboot/debian-installer/${VER}/initrd.gz"
  elif [ "$Relese" == "centos" ] || [ "$Relese" == "rockylinux" ] || [ "$Relese" == "almalinux" ]; then
    if [ "$Relese" == "centos" ] && [[ "$RedHatSeries" -le "7" ]]; then
      TEMP="SUB_MIRROR/${DIST}/os/${VER}/images/pxeboot/initrd.img"
    else
      TEMP="SUB_MIRROR/${DIST}/BaseOS/${VER}/os/images/pxeboot/initrd.img"
    fi
  elif [ "$Relese" == "fedora" ]; then
    TEMP="SUB_MIRROR/releases/${DIST}/Server/${VER}/os/images/pxeboot/initrd.img"
  elif [ "$Relese" == "alpinelinux" ]; then
    TEMP="SUB_MIRROR/${DIST}/releases/${VER}/netboot/initramfs-lts"
  fi
  [ -n "$TEMP" ] || exit 1
  mirrorStatus=0
  declare -A MirrorBackup
  if [[ "$IsCN" == "cn" ]]; then
    MirrorBackup=(["debian0"]="" ["debian1"]="http://mirror.nju.edu.cn/debian" ["debian2"]="http://mirrors.hit.edu.cn/debian" ["debian3"]="https://mirrors.aliyun.com/debian-archive/debian" ["ubuntu0"]="" ["ubuntu1"]="https://mirrors.ustc.edu.cn/ubuntu" ["ubuntu2"]="http://mirrors.xjtu.edu.cn/ubuntu" ["kali0"]="" ["kali1"]="https://mirrors.tuna.tsinghua.edu.cn/kali" ["kali2"]="http://mirrors.zju.edu.cn/kali" ["alpinelinux0"]="" ["alpinelinux1"]="http://mirror.nju.edu.cn/alpine" ["alpinelinux2"]="http://mirrors.tuna.tsinghua.edu.cn/alpine" ["centos0"]="" ["centos1"]="https://mirrors.ustc.edu.cn/centos-stream" ["centos2"]="https://mirrors.tuna.tsinghua.edu.cn/centos" ["centos3"]="http://mirror.nju.edu.cn/centos-altarch" ["centos4"]="https://mirrors.tuna.tsinghua.edu.cn/centos-vault" ["fedora0"]="" ["fedora1"]="https://mirrors.tuna.tsinghua.edu.cn/fedora" ["fedora2"]="https://mirrors.bfsu.edu.cn/fedora" ["rockylinux0"]="" ["rockylinux1"]="http://mirror.nju.edu.cn/rocky" ["rockylinux2"]="http://mirrors.sdu.edu.cn/rocky" ["almalinux0"]="" ["almalinux1"]="https://mirror.sjtu.edu.cn/almalinux" ["almalinux2"]="http://mirrors.neusoft.edu.cn/almalinux")
  else
    MirrorBackup=(["debian0"]="" ["debian1"]="http://deb.debian.org/debian" ["debian2"]="http://ftp.yz.yamagata-u.ac.jp/pub/linux/debian" ["debian3"]="http://archive.debian.org/debian" ["ubuntu0"]="" ["ubuntu1"]="http://archive.ubuntu.com/ubuntu" ["ubuntu2"]="http://ports.ubuntu.com" ["kali0"]="" ["kali1"]="https://mirrors.ocf.berkeley.edu/kali" ["kali2"]="http://ftp.jaist.ac.jp/pub/Linux/kali" ["alpinelinux0"]="" ["alpinelinux1"]="http://dl-cdn.alpinelinux.org/alpine" ["alpinelinux2"]="http://ftp.udx.icscoe.jp/Linux/alpine" ["centos0"]="" ["centos1"]="http://mirror.centos.org/centos" ["centos2"]="http://mirror.stream.centos.org" ["centos3"]="http://mirror.centos.org/altarch" ["centos4"]="http://vault.centos.org" ["fedora0"]="" ["fedora1"]="https://download-ib01.fedoraproject.org/pub/fedora/linux" ["fedora2"]="https://download-cc-rdu01.fedoraproject.org/pub/fedora/linux" ["rockylinux0"]="" ["rockylinux1"]="http://download.rockylinux.org/pub/rocky" ["rockylinux2"]="http://ftp.udx.icscoe.jp/Linux/rocky" ["almalinux0"]="" ["almalinux1"]="http://repo.almalinux.org/almalinux" ["almalinux2"]="http://ftp.iij.ad.jp/pub/linux/almalinux")
  fi
  echo "$New" | grep -q '^http://\|^https://\|^ftp://' && MirrorBackup[${Relese}0]="${New%*/}"
  for mirror in $(echo "${!MirrorBackup[@]}" |sed 's/\ /\n/g' |sort -n |grep "^$Relese"); do
    Current="${MirrorBackup[$mirror]}"
    [ -n "$Current" ] || continue
    MirrorURL=`echo "$TEMP" |sed "s#SUB_MIRROR#${Current}#g"`
    wget --no-check-certificate --spider --timeout=3 -o /dev/null "$MirrorURL"
    [ $? -eq 0 ] && mirrorStatus=1 && break
  done
  [ $mirrorStatus -eq 1 ] && echo "$Current" || exit 1
}

function getIPv4Address() {
# Differences from scope link, scope host and scope global of IPv4, reference: https://qiita.com/testnin2/items/7490ff01a4fe1c7ad61f
  iAddr=`ip -4 addr show | grep -wA 5 "$interface" | grep -wv "lo\|host" | grep -w "inet" | grep -w "scope global*\|link*" | head -n 1 | awk -F " " '{for (i=2;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
  [[ -n "$interface4" && -n "$interface6" && "$interface4" != "$interface6" ]] && iAddr=`ip -4 addr show | grep -wA 5 "$interface4" | grep -wv "lo\|host" | grep -w "inet" | grep -w "scope global*\|link*" | head -n 1 | awk -F " " '{for (i=2;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
  ipAddr=`echo ${iAddr} | cut -d'/' -f1`
  ipPrefix=`echo ${iAddr} | cut -d'/' -f2`
  ipMask=`netmask "$ipPrefix"`
# Get real IPv4 subnet of current System
  ip4RouteScopeLink=`ip -4 route show scope link | grep -iv "warp\|wgcf\|wg[0-9]" | grep -w "$interface4" | grep -w "$ipAddr" | grep -m1 -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -n 1`
  actualIp4Prefix=`ip -4 route show scope link | grep -iv "warp\|wgcf\|wg[0-9]" | grep -w "$interface4" | grep -w "$ip4RouteScopeLink" | head -n 1 | awk '{print $1}' | cut -d'/' -f2`
  [[ -z "$actualIp4Prefix" ]] && actualIp4Prefix="$ipPrefix"
  actualIp4Subnet=`netmask "$actualIp4Prefix"`
# In most situation, at least 99.9% probability, the first hop of the network should be the same as the available gateway. 
# But in 0.1%, they are actually different. 
# Because one of the first hop of a tested machine is 5.45.72.1, I told Debian installer this router as a gateway 
# But installer said the correct gateway should be 5.45.76.1, in a typical network, for example, your home, 
# the default gateway is the same as the first route hop of the machine, it may be 192.168.0.1.
# If possible, we should configure out the real available gateway of the network.
  FirstRoute=`ip -4 route show default | grep -iv "warp\|wgcf\|wg[0-9]" | grep -w "via" | grep -w "dev $interface4*" | head -n 1 | awk -F " " '{for (i=3;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
# We should find it in ARP, the first hop IP and gateway IP is managed by the same device, use device mac address to configure it out.
  RouterMac=`arp -n | grep "$FirstRoute" | awk '{print$3}'`
  FrFirst=`echo "$FirstRoute" | cut -d'.' -f 1,2`
  FrThird=`echo "$FirstRoute" | cut -d'.' -f 3`
# Print all matched available gateway.
  ipGates=`ip -4 route show | grep -iv "warp\|wgcf\|wg[0-9]" | grep -v "via" | grep -w "dev $interface4*" | grep -w "proto*" | grep -w "scope global\|link src $ipAddr*" | awk '{print$1}'`
# Figure out the line of this list.
  ipGateLine=`echo "$ipGates" | wc -l`
# The line determines the cycling times.
  for ((i=1; i<="$ipGateLine"; i++)) do
# Current one gateway of the ip gateways. the formart is as of 10.0.0.0/22
    tmpIpGate=`echo "$ipGates" | sed -n ''$i'p'`
# Intercept a standard IPv4 address.
    tmpIgAddr=`echo $tmpIpGate | cut -d'/' -f1`
# Intercept the prefix of the gateway.
    tmpIgPrefix=`echo $tmpIpGate | cut -d'/' -f2`
# Calculate the first ip in all network segment, it should be the the same range with gateway in this network.
    minIpGate=`ipv4Calc "$tmpIgAddr" "$tmpIgPrefix" | grep "FirstIP:" | awk '{print$2}'`
# Intercept the A and B class of the current ip address of gateway.
    tmpIpGateFirst=`echo "$minIpGate" | cut -d'.' -f 1,2`
    tmpIpGateThird=`echo "$minIpGate" | cut -d'.' -f 3`
# If the class A and B class of the current local ip address is as same as current gateway, this gateway may a valid one.
    [[ "$FrFirst" == "$tmpIpGateFirst" ]] && {
      if [[ "$FrThird" == "$tmpIpGateThird" ]]; then
        ipGate="$FirstRoute"
        break
      elif [[ "$FrThird" != "$tmpIpGateThird" ]]; then
# The A, B and C class address of min ip gate. 
        tmpMigFirst=`echo $minIpGate | cut -d'.' -f 1,2,3`
# Search it in ARP, it's belonged to the same network device which has been distinguished by mac address of first hop of the IP.
        ipGate=`arp -n | grep "$tmpMigFirst" | grep "$RouterMac" | awk '{print$1}'`
        break
      fi	  
    }
  done
# If there is no one of other gateway in this current network, use if access the public internet, the first hop route of this machine as the gateway.
  [[ "$ipGates" == "" || "$ipGate" == "" ]] && ipGate="$FirstRoute"
 
# Some cloud providers like Godaddy, Arkecx, Hetzner(include DHCP) etc, the subnet mask of IPv4 static network configuration of their original template OS is incorrect.
# The following is the sample:
#
# auto eth0
#   iface eth0 inet static
#     address 190.168.23.175
#     netmask 255.255.255.240
#     dns-nameservers 8.8.8.8 8.8.4.4
#     up ip -4 route add default via 169.254.0.1 dev eth0 onlink
#
# The netmask tells the total number of IP in the network is only 15(240 - 255),
# but we obsessed that there are more than 15 IPv4 addresses between 169.254.0.1 and 190.168.23.175 clearly.
# So if netmask is 255.255.255.240(prefix is 28), the computer only find IP between 190.168.23.160 and 190.168.23.175,
# the gateway 169.254.0.1 is obviously not be included in this range.
# So we need to expand the range of the netmask(reduce the value number of the prefix) to make sure the IPv4 gateway can be contained.
# If this mistake has not be repaired, Debian installer will return error "untouchable gateway".
# DHCP IPv4 network(even IPv4 netmask is "32") may not be effected by this situation.
# The following consulted calculations are calculated by Vultr IPv4 subnet calculator, reference: https://www.vultr.com/resources/subnet-calculator/
  [[ "$Network4Config" == "isStatic" ]] && {
    ipv4SubnetCertificate "$ipAddr" "$ipGate"
    ipPrefix="$tmpIpMask"
    ipMask=`netmask "$tmpIpMask"`
# Some servers' provided by Hetzner are so confused because the IPv4 configurations of them are static but they are not fitted with standard, here is a sample:
#
# auto ens3
# iface ens3 inet static
#     address: 89.163.208.5
#     netmask: 255.255.255.0
#     broadcast +
#     up ip -f inet route add 169.254.0.1 dev ens3
#     up ip -f inet route add default via 169.254.0.1 dev ens3
#
# The A class of address and gateway are entirely different, although we should make sure the value of the suggested subnet mask is "128.0.0.1"(prefix "1")
# to expand IPv4 range as large as possible, but in above situation, the largest IPv4 range is from 0.0.0.0 to 127.255.255.255, the IPv4 gate "169.254.0.1"
# can't be included, so the reserve approach is to get the result of "ip -4 route show scope link"(89.163.208.0/24) to ensure the correct subnet and gateway,
# then we can fix these weird settings from incorrect network router.
# IPv4 network from Hetzner support dhcp even though it's configurated by static in "/etc/network/interfaces".
    ip4RangeFirst=`ipv4Calc "$ipAddr" "$actualIp4Prefix" | grep "FirstIP:" | awk '{print$2}' | cut -d'.' -f1`
    ip4RangeLast=`ipv4Calc "$ipAddr" "$actualIp4Prefix" | grep "LastIP:" | awk '{print$2}' | cut -d'.' -f1`
    ip4GateFirst=`echo $ipGate | cut -d'.' -f1`
    ip4GateSecond=`echo $ipGate | cut -d'.' -f2`
# Common ranges of IPv4 intranet:
# Reference: https://hczhang.cn/network/reserved-ip-addresses.html
    [[ "$ip4GateFirst" -gt "$ip4RangeLast" || "$ip4GateFirst" -lt "$ip4RangeFirst" ]] && {
      [[ "$ip4GateFirst" == "169" && "$ip4GateSecond" == "254" ]] || [[ "$ip4GateFirst" == "172" && "$ip4GateSecond" -ge "16" && "$ip4GateSecond" -le "31" ]] || [[ "$ip4GateFirst" == "10" && "$ip4GateSecond" -ge "0" && "$ip4GateSecond" -le "255" ]] || [[ "$ip4GateFirst" == "192" && "$ip4GateSecond" == "168" ]] || [[ "$ip4GateFirst" == "127" && "$ip4GateSecond" -ge "0" && "$ip4GateSecond" -le "255" ]] || [[ "$ip4GateFirst" == "198" && "$ip4GateSecond" -ge "18" && "$ip4GateSecond" -le "19" ]] || [[ "$ip4GateFirst" == "100" && "$ip4GateSecond" -ge "64" && "$ip4GateSecond" -le "127" ]] && {
        ipPrefix="$actualIp4Prefix"
        ipMask="$actualIp4Subnet"
# When IPv4 is public, IPv4 gateway is private, subnet prefix is 32, the result of "ip -4 route show scope link" is empty, the actual gateway maybe itself.
        [[ -z "$ip4RouteScopeLink" ]] && ipGate=`ipv4Calc "$ipAddr" "$ipPrefix" | grep "FirstIP:" | awk '{print$2}'` || ipGate=`ipv4Calc "$ip4RouteScopeLink" "$ipPrefix" | grep "FirstIP:" | awk '{print$2}'`
      }
    }
  }
}

function netmask() {
  n="${1:-32}"
  b=""
  m=""
  for((i=0;i<32;i++)){
    [ $i -lt $n ] && b="${b}1" || b="${b}0"
  }
  for((i=0;i<4;i++)){
    s=`echo "$b"|cut -c$[$[$i*8]+1]-$[$[$i+1]*8]`
    [ "$m" == "" ] && m="$((2#${s}))" || m="${m}.$((2#${s}))"
  }
  echo "$m"
}

# $1 is IPv4 address, $2 is IPv4 subnet.
function ipv4Calc() {
  tmpIp4="$1"
  tmpIp4Mask=`netmask "$2"`

  IFS=. read -r i1 i2 i3 i4 <<< "$tmpIp4"
  IFS=. read -r m1 m2 m3 m4 <<< "$tmpIp4Mask"

  tmpNetwork="$((i1 & m1)).$((i2 & m2)).$((i3 & m3)).$((i4 & m4))"
  tmpBroadcast="$((i1 & m1 | 255-m1)).$((i2 & m2 | 255-m2)).$((i3 & m3 | 255-m3)).$((i4 & m4 | 255-m4))"
  tmpFirstIP="$((i1 & m1)).$((i2 & m2)).$((i3 & m3)).$(((i4 & m4)+1))"
  tmpFiLast="$(echo "$tmpFirstIP" | cut -d'.' -f 4)"
  FirstIP="$tmpFirstIP"
  tmpLastIP="$((i1 & m1 | 255-m1)).$((i2 & m2 | 255-m2)).$((i3 & m3 | 255-m3)).$(((i4 & m4 | 255-m4)-1))"
  tmpLiLast="$(echo "$tmpLastIP" | cut -d'.' -f 4)"
  LastIP="$tmpLastIP"
  [[ "$tmpFiLast" > "$tmpLiLast" ]] && {
    FirstIP="$tmpLastIP"
    LastIP="$tmpFirstIP"
  }
  [[ "$2" > "31" ]] && {
    FirstIP="$tmpNetwork"
    LastIP="$tmpNetwork"
  }
  echo -e "Network:   $tmpNetwork\nBroadcast: $tmpBroadcast\nFirstIP:   $FirstIP\nLastIP:    $LastIP\n"
}

# $1 is "$ipAddr", $2 is "$ipGate"
function ipv4SubnetCertificate() {
  # If the IP and gateway are not in the same IPv4 A class, the prefix of netmask should be "1", transfer to whole IPv4 address is 128.0.0.1
# The range of 190.168.23.175/1 is 128.0.0.0 - 255.255.255.255, the gateway 169.254.0.1 can be included.
  [[ `echo $1 | cut -d'.' -f 1` != `echo $2 | cut -d'.' -f 1` ]] && tmpIpMask="1"
# If the IP and gateway are in the same IPv4 A class, not in the same IPv4 B class, the prefix of netmask should less equal than "8", transfer to whole IPv4 address is 255.0.0.0
# The range of 190.168.23.175/8 is 190.0.0.0 - 190.255.255.255, the gateway 169... can't be included.
  [[ `echo $1 | cut -d'.' -f 1` == `echo $2 | cut -d'.' -f 1` ]] && tmpIpMask="8"
# If the IP and gateway are in the same IPv4 A B class, not in the same IPv4 C class, the prefix of netmask should less equal than "16", transfer to whole IPv4 address is 255.255.0.0
# The range of 190.168.23.175/16 is 190.168.0.0 - 190.168.255.255, the gateway 169... can't be included.
  [[ `echo $1 | cut -d'.' -f 1,2` == `echo $2 | cut -d'.' -f 1,2` ]] && tmpIpMask="16"
# If the IP and gateway are in the same IPv4 A B C class, not in the same IPv4 D class, the prefix of netmask should less equal than "24", transfer to whole IPv4 address is 255.255.255.0
# The range of 190.168.23.175/24 is 190.168.23.0 - 190.168.23.255, the gateway 169... can't be included.
  [[ `echo $1 | cut -d'.' -f 1,2,3` == `echo $2 | cut -d'.' -f 1,2,3` ]] && tmpIpMask="24"
# So in summary of the IPv4 sample in above, we should assign subnet mask "128.0.0.1"(prefix "1") for it.
}

function getDisk() {
# $disks is definited as the default disk, if server has 2 and more disks, the first disk will be responsible of the grub booting.
  rootPart=`lsblk -ip | grep -v "fd[0-9]*\|sr[0-9]*\|ram[0-9]*\|loop[0-9]*" | sed 's/[[:space:]]*$//g' | grep -w "part /\|part /boot" | head -n 1 | cut -d' ' -f1 | sed 's/..//'`
  majorMin=`lsblk -ip | grep -w "$rootPart" | head -n 1 | awk '{print $2}' | sed -r 's/:(.*)/:0/g'`
  disks=`lsblk -ip | grep -w "$majorMin" | head -n 1 | awk '{print $1}'`
  [[ -z "$disks" ]] && disks=`lsblk -ip | grep -v "fd[0-9]*\|sr[0-9]*\|ram[0-9]*\|loop[0-9]*" | sed 's/[[:space:]]*$//g' | grep -w "disk /\|disk /boot" | head -n 1 | cut -d' ' -f1`
  [[ -z "$disks" ]] && disks=`lsblk -ip | grep -v "fd[0-9]*\|sr[0-9]*\|ram[0-9]*\|loop[0-9]*" | sed 's/[[:space:]]*$//g' | grep -w "disk" | grep -i "[0-9]g\|[0-9]t\|[0-9]p\|[0-9]e\|[0-9]z\|[0-9]y" | head -n 1 | cut -d' ' -f1`
  [ -n "$disks" ] || echo ""
  echo "$disks" | grep -q "/dev"
  [ $? -eq 0 ] && IncDisk="$disks" || IncDisk="/dev/$disks"
  AllDisks=""
# Find all disks on this server.
  for Count in `lsblk -ipd | grep -v "fd[0-9]*\|sr[0-9]*\|ram[0-9]*\|loop[0-9]*" | sed 's/[[:space:]]*$//g' | grep -w "disk" | grep -i "[0-9]g\|[0-9]t\|[0-9]p\|[0-9]e\|[0-9]z\|[0-9]y" | cut -d' ' -f1`; do
    AllDisks+="$Count "
  done
# All numbers of disks' statistic of this server.
  disksNum=$(echo $AllDisks | grep -o "/dev/*" | wc -l)
}

function diskType() {
  echo `udevadm info --query all "$1" 2>/dev/null |grep 'ID_PART_TABLE_TYPE' |cut -d'=' -f2`
}

# $1 is timezone checkfile direction, $2 $3 $4 are api keys.
function getUserTimeZone() {
  if [[ ! "$TimeZone" =~ ^[a-zA-Z] ]]; then
    loginUser=`who am i | awk '{print $1}' | sed 's/(//g' | sed 's/)//g'`
    [[ -z "$loginUser" ]] && loginUser="root"
# Alpine Linux doesn't support "who am i".
    GuestIP=`netstat -anpW | grep -i 'established' | grep -i 'sshd: '$loginUser'' | grep -iw 'tcp' | awk '{print $5}' | head -n 1 | cut -d':' -f'1'`
    [[ "$GuestIP" == "" ]] && GuestIP=`netstat -anpW | grep -i 'established' | grep -i 'sshd: '$loginUser'' | grep -iw 'tcp6' | awk '{print $5}' | head -n 1 | awk -F':' '{for (i=1;i<=NF-1;i++)printf("%s:", $i);print ""}' | sed 's/.$//'`
    for Count in "$2" "$3" "$4"; do
      [[ "$TimeZone" == "Asia/Shanghai" ]] && break
      tmpApi=`echo -n "$Count" | base64 -d`
      TimeZone=`curl -s "https://api.ipgeolocation.io/timezone?apiKey=$tmpApi&ip=$GuestIP" | jq '.timezone' | tr -d '"'`
      checkTz=`echo $TimeZone | cut -d'/' -f 1`
      [[ -n "$checkTz" && "$checkTz" =~ ^[a-zA-Z] ]] && break
    done
  else
    echo `timedatectl list-timezones` >> "$1"
    [[ `grep -c "$TimeZone" "$1"` == "0" || ! "/usr/share/zoneinfo/$1" ]] && TimeZone="Asia/Tokyo"
    rm -rf "$1"
  fi
}

function checkEfi() {
  EfiStatus=`efibootmgr l`
  EfiVars=""
  for Count in "$1" "$2" "$3" "$4"; do
    EfiVars=`ls -Sa $Count | wc -l`
    [[ "$EfiVars" -ge "1" ]] && break
  done
  if [[ "$EfiStatus" == "" ]] || [[ "$EfiVars" == "0" ]]; then
    EfiSupport="disabled"
  elif [[ -n `echo "$EfiStatus" | grep -i "bootcurrent" | awk '{print $2}' | sed -n '/^[[:xdigit:]]*$/p' | head -n 1` || -n `echo "$EfiStatus" | grep -i "bootorder" | awk '{print $2}' | awk -F ',' '{print $NF}' | sed -n '/^[[:xdigit:]]*$/p' | head -n 1` ]] && [[ "$EfiVars" != "0" ]]; then
    EfiSupport="enabled"
  else
    echo -ne "\n[${red}Error${plain}] UEFI boot firmware of your system could not be confirmed!\n"
    exit 1
  fi
}

# "/boot/grub/" "/boot/grub2/" "/etc/" "grub.cfg" "grub.conf" "/boot/efi/EFI/"
function checkGrub() {
  GRUBDIR=""
  GRUBFILE=""
  for Count in "$1" "$2" "$3"; do
# Don't support grub1 of CentOS/Redhat Enterprise Linux/Oracle Linux 6.x
    if [[ -f "$Count""$4" ]] && [[ `grep -c "insmod*" $Count$4` -ge "1" ]]; then
      GRUBDIR="$Count"
      GRUBFILE="$4"
    elif [[ -f "$Count""$5" ]] && [[ `grep -c "insmod*" $Count$5` -ge "1" ]]; then
      GRUBDIR="$Count"
      GRUBFILE="$5"
    fi
  done
  if [[ -z "$GRUBFILE" ]] || [[ `grep -c "insmod*" $GRUBDIR$GRUBFILE` == "0" ]]; then
    for Count in "$4" "$5"; do
      GRUBFILE=`find "$6" -name "$Count"`
      if [[ -n "$GRUBFILE" ]]; then
        GRUBDIR=`echo "$GRUBFILE" | sed "s/$Count//g"`
        GRUBFILE="$Count"
        break
      fi
    done
  fi
  GRUBDIR=`echo ${GRUBDIR%?}`
  if [[ `awk '/menuentry*/{print NF}' $GRUBDIR/$GRUBFILE | head -n 1` -ge "1" ]] || [[ `awk '/feature*/{print $a}' $GRUBDIR/$GRUBFILE | head -n 1` != "" ]]; then
    if [[ -n `grep -w "grub2-mkconfig" $GRUBDIR/$GRUBFILE` ]] || [[ `type grub2-mkconfig` != "" ]]; then
      GRUBTYPE="isGrub2"
    elif [[ -n `grep -w "grub-mkconfig" $GRUBDIR/$GRUBFILE` ]] || [[ `type grub-mkconfig` != "" ]]; then
      GRUBTYPE="isGrub1"
    elif [[ "$CurrentOS" == "CentOS" || "$CurrentOS" == "OracleLinux" ]] && [[ "$CurrentOSVer" -le "6" ]]; then
      GRUBTYPE="isGrub1"
    fi
  fi
}

# $1 is $linux_relese, $2 is $RedHatSeries, $3 is $targetRelese
function checkMem() {
  TotalMem1=$(cat /proc/meminfo | grep "^MemTotal:" | sed 's/kb//i' | grep -o "[0-9]*" | awk -F' ' '{print $NF}')
  TotalMem2=$(free -k | grep -wi "mem*" | awk '{printf $2}')
# In any servers that total memory below 2.5GB to install debian, the low memory installation will be force enabled, "lowmem=+0, 1 or 2" is only for Debian like, 0 is lowest, 1 is medium, 2 is the highest.
  [[ "$1" == 'debian' ]] || [[ "$1" == 'ubuntu' ]] || [[ "$1" == 'kali' ]] && {
    [[ "$TotalMem1" -ge "2558072" || "$TotalMem2" -ge "2558072" ]] && lowmemLevel="" || lowmemLevel="lowmem=+1"
    [[ "$setMemCheck" == '1' ]] && {
      [[ "$TotalMem1" -le "329760" || "$TotalMem2" -le "329760" ]] && {
        echo -ne "\n[${red}Error${plain}] Minimum system memory requirement is 384MB!\n"
        exit 1
      }
    }
  }
# Without the function of OS re-installation templates in control panel which provided by cloud companies(many companies even have not).
# A independent VPS with only one hard drive is lack of the secondary hard drive to format and copy new OS file to main hard drive.
# So PXE installation need to use memory as a 'hard drive' temporary.
# For redhat series, the main OS installation file is 'squashfs.img', for example, this is the link of rockylinux 8 LiveOS iso file:
# http://dl.rockylinux.org/pub/rocky/8/Live/x86_64/Rocky-8-MATE-x86_64-latest.iso
# If you download and mount it, you will found that the size of '/LiveOS/squashfs.img' is 1.55GB!
# It means in first step of netboot installation, this 1.55GB file will be all downloaded and loaded in memory!
# So and consider other install programs if necessary, even 2GB memory is not enough, 2.5GB only just pass, it's so ridiculous!
# Debian 11 PXE installation will be able in low memory mode just 512M, why redhat loves swallow memory so much, is shame on you!
# Redhat 9 slightly improved the huge occupy of the memory, 2GB RAM machine can run it successfully, but CentOS 9-stream needs 2.5GB RAM more.
# Technology companies usually add useless functions and redundant code in new version of software increasingly.
# They never optimize or improve it, just tell users they need to pay more to expand their hardware performance and adjust to the endless demand of them. it's not a correct decision. 
  [[ "$setMemCheck" == '1' ]] && {
    [[ "$1" == 'fedora' || "$1" == 'rockylinux' || "$1" == 'almalinux' || "$1" == 'centos' ]] && {
      if [[ "$1" == 'rockylinux' || "$1" == 'almalinux' || "$1" == 'centos' ]]; then
        if [[ "$2" == "8" ]] || [[ "$1" == 'centos' && "$2" -ge "9" ]]; then
          [[ "$TotalMem1" -le "2198342" || "$TotalMem2" -le "2198342" ]] && {
            echo -ne "\n[${red}Error${plain}] Minimum system memory requirement is 2.5GB!\n"
            exit 1
          }
        elif [[ "$2" -ge "9" ]]; then
          [[ "$TotalMem1" -le "1740800" || "$TotalMem2" -le "1740800" ]] && {
            echo -ne "\n[${red}Error${plain}] Minimum system memory requirement is 2GB!\n"
            exit 1
          }
        elif [[ "$2" == "7" ]]; then
          [[ "$TotalMem1" -le "1319006" || "$TotalMem2" -le "1319006" ]] && {
            echo -ne "\n[${red}Error${plain}] Minimum system memory requirement is 1.5GB!\n"
            exit 1
          }
        fi
      elif [[ "$1" == 'fedora' ]]; then
        [[ "$TotalMem1" -le "1740800" || "$TotalMem2" -le "1740800" ]] && {
          echo -ne "\n[${red}Error${plain}] Minimum system memory requirement is 2GB!\n"
          exit 1
        }
      fi
    }
    [[ "$1" == 'alpinelinux' || "$3" == 'Ubuntu' ]] && {
      [[ "$TotalMem1" -le "895328" || "$TotalMem2" -le "895328" ]] && {
        echo -ne "\n[${red}Error${plain}] Minimum system memory requirement is 1GB!\n"
        exit 1
      }
    }
  }
}

function checkVirt() {
  virtType=""
  for Count in $(dmidecode -s system-manufacturer | awk '{print $1}' | sed 's/[A-Z]/\l&/g') $(systemd-detect-virt | sed 's/[A-Z]/\l&/g') $(lscpu | grep -i "hypervisor vendor" | cut -d ':' -f 2 | sed 's/^[ \t]*//g' | sed 's/[A-Z]/\l&/g'); do
    virtType+="$Count"
  done
}

function checkSys() {
  apt update -y
  apt install lsb-release -y
# Delete mirrors from elrepo.org because it will causes dnf/yum checking updates continuously(maybe some of the server mirror lists are in the downtime?)
  [[ `grep -wri "elrepo.org" /etc/yum.repos.d/` != "" ]] && {
    elrepoFile=`grep -wri "elrepo.org" /etc/yum.repos.d/ | head -n 1 | cut -d':' -f 1`
    mv "$elrepoFile" "$elrepoFile.bak"
  }
  yum install redhat-lsb -y
  apk update
  OsLsb=`lsb_release -d | awk '{print$2}'`
  
  CurrentOSVer=`cat /etc/os-release | grep -w "VERSION_ID=*" | awk -F '=' '{print $2}' | sed 's/\"//g' | cut -d'.' -f 1`
  
  RedHatRelease=""
  for Count in `cat /etc/redhat-release | awk '{print$1}'` `cat /etc/system-release | awk '{print$1}'` `cat /etc/os-release | grep -w "ID=*" | awk -F '=' '{print $2}' | sed 's/\"//g'` "$OsLsb"; do
    [[ -n "$Count" ]] && RedHatRelease=`echo -e "$Count"`"$RedHatRelease"
  done
  
  DebianRelease=""
  IsUbuntu=`uname -a | grep -i "ubuntu"`
  IsDebian=`uname -a | grep -i "debian"`
  IsKali=`uname -a | grep -i "kali"`
  for Count in `cat /etc/os-release | grep -w "ID=*" | awk -F '=' '{print $2}'` `cat /etc/issue | awk '{print $1}'` "$OsLsb"; do
    [[ -n "$Count" ]] && DebianRelease=`echo -e "$Count"`"$DebianRelease"
  done
  
  AlpineRelease=""
  for Count in `cat /etc/os-release | grep -w "ID=*" | awk -F '=' '{print $2}'` `cat /etc/issue | awk '{print $3}' | head -n 1` `uname -v | awk '{print $1}' | sed 's/[^a-zA-Z]//g'`; do
    [[ -n "$Count" ]] && AlpineRelease=`echo -e "$Count"`"$AlpineRelease"
  done
  
  if [[ `echo "$RedHatRelease" | grep -i 'centos'` != "" ]]; then
    CurrentOS="CentOS"
  elif [[ `echo "$RedHatRelease" | grep -i 'alma'` != "" ]]; then
    CurrentOS="AlmaLinux"
  elif [[ `echo "$RedHatRelease" | grep -i 'rocky'` != "" ]]; then
    CurrentOS="RockyLinux"
  elif [[ `echo "$RedHatRelease" | grep -i 'fedora'` != "" ]]; then
    CurrentOS="Fedora"
  elif [[ `echo "$RedHatRelease" | grep -i 'virtuozzo'` != "" ]]; then
    CurrentOS="Vzlinux"
  elif [[ `echo "$RedHatRelease" | grep -i 'ol\|oracle'` != "" ]]; then
    CurrentOS="OracleLinux"
  elif [[ `echo "$RedHatRelease" | grep -i 'opencloud'` != "" ]]; then
    CurrentOS="OpenCloudOS"
  elif [[ `echo "$RedHatRelease" | grep -i 'alibaba\|alinux\|aliyun'` != "" ]]; then
    CurrentOS="AlibabaCloudLinux"
  elif [[ `echo "$RedHatRelease" | grep -i 'amazon\|amzn'` != "" ]]; then
    CurrentOS="AmazonLinux"
    amazon-linux-extras install epel -y
  elif [[ `echo "$RedHatRelease" | grep -i 'red\|rhel'` != "" ]]; then
    CurrentOS="RedHatEnterpriseLinux"
  elif [[ `echo "$RedHatRelease" | grep -i 'anolis'` != "" ]]; then
    CurrentOS="OpenAnolis"
  elif [[ `echo "$RedHatRelease" | grep -i 'scientific'` != "" ]]; then
    CurrentOS="ScientificLinux"
  elif [[ `echo "$AlpineRelease" | grep -i 'alpine'` != "" ]]; then
    CurrentOS="AlpineLinux"
  elif [[ "$IsUbuntu" ]] || [[ `echo "$DebianRelease" | grep -i 'ubuntu'` != "" ]]; then
    CurrentOS="Ubuntu"
    CurrentOSVer=`lsb_release -r | awk '{print$2}' | cut -d'.' -f1`
  elif [[ "$IsDebian" ]] || [[ `echo "$DebianRelease" | grep -i 'debian'` != "" ]]; then
    CurrentOS="Debian"
    CurrentOSVer=`lsb_release -r | awk '{print$2}' | cut -d'.' -f1`
  elif [[ "$IsKali" ]] || [[ `echo "$DebianRelease" | grep -i 'kali'` != "" ]]; then
    CurrentOS="Kali"
    CurrentOSVer=`lsb_release -r | awk '{print$2}' | cut -d'.' -f1`
  else
    echo -ne "\n[${red}Error${plain}] Does't support your system!\n"
    exit 1
  fi
# Don't support Redhat like linux OS under 6 version.
  if [[ "$CurrentOS" == "CentOS" || "$CurrentOS" == "OracleLinux" ]] && [[ "$CurrentOSVer" -le "6" ]]; then
    echo -e "Does't support your system!\n"
    exit 1
  fi

# Debian like linux OS necessary components.
  apt install cpio curl dnsutils efibootmgr fdisk file gzip jq net-tools openssl subnetcalc tuned wget xz-utils -y

# Redhat like Linux OS prefer to use dnf instead of yum because former has a higher execute efficiency.
  yum install epel-release -y
  yum install dnf -y
  if [[ $? -eq 0 ]]; then
# To avoid "Failed loading plugin "osmsplugin": No module named 'librepo'"
# Reference: https://anatolinicolae.com/failed-loading-plugin-osmsplugin-no-module-named-librepo/
    [[ "$CurrentOS" == "CentOS" && "$CurrentOSVer" == "8" ]] && dnf install python3-librepo -y
# Redhat like linux OS necessary components.
    dnf install bind-utils cpio curl dnsutils efibootmgr file gzip ipcalc jq net-tools openssl redhat-lsb syslinux tuned util-linux wget xz --skip-broken -y
    # dnf update -y
  else
    yum install dnf -y > /root/yum_execute.log 2>&1
# In some versions of CentOS 8 which are not subsumed into CentOS-stream are end of supporting by CentOS official, so the source is failure.
# We need to change the source from http://mirror.centos.org to http://vault.centos.org to make repository is still available.
# Reference: https://techglimpse.com/solve-failed-synchronize-cache-repo-appstream/
#            https://qiita.com/yamada-hakase/items/cb1b6124e11ca65e2a2b
    if [[ `grep -i "failed to synchronize" /root/yum_execute.log` || `grep -i "no urls in mirrorlist" /root/yum_execute.log` ]]; then
      if [[ "$CurrentOS" == "CentOS" ]]; then
        cd /etc/yum.repos.d/
        sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
        sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
        [[ "$CurrentOSVer" == "8" ]] && dnf install python3-librepo -y
      fi
      yum install epel-release -y
      yum install dnf -y
# Run dnf update and install components.
# In official template of AlmaLinux 9 of Linode, "tuned" must be installed otherwise "grub2-mkconfig" can't work formally.
# Reference: https://phanes.silogroup.org/fips-disa-stig-hardening-on-centos9/
      dnf install bind-utils cpio curl dnsutils efibootmgr file gzip ipcalc jq net-tools openssl redhat-lsb syslinux tuned util-linux wget xz --skip-broken -y
      # dnf update -y
# Oracle Linux 7 doesn't support DNF.
    elif [[ `grep -i "no package" /root/yum_execute.log` ]]; then
      yum install bind-utils cpio curl dnsutils efibootmgr file gzip ipcalc jq net-tools openssl redhat-lsb syslinux tuned util-linux wget xz --skip-broken -y
      # yum update -y
    fi
    rm -rf /root/yum_execute.log
  fi

# Alpine Linux necessary components and configurations.
  [[ "$CurrentOS" == "AlpineLinux" ]] && {
# Get current version number of Alpine Linux
    CurrentAlpineVer=$(cut -d. -f1,2 </etc/alpine-release)
# Try to remove comments of any valid mirror.
    sed -i 's/#//' /etc/apk/repositories
# Add community mirror.
    [[ ! `grep -i "community" /etc/apk/repositories` ]] && sed -i '$a\http://ftp.udx.icscoe.jp/Linux/alpine/v'${CurrentAlpineVer}'/community' /etc/apk/repositories
# Add testing mirror.
    # [[ ! `grep -i "testing" /etc/apk/repositories` ]] && sed -i '$a\http://ftp.udx.icscoe.jp/Linux/alpine/edge/testing' /etc/apk/repositories
# Alpine Linux use "apk" as package management.
    apk update
    apk add bash bind-tools coreutils cpio curl efibootmgr file gawk grep gzip ipcalc jq net-tools openssl sed shadow tzdata util-linux wget xz
# Use bash to replace ash.
    sed -i 's/root:\/bin\/ash/root:\/bin\/bash/g' /etc/passwd
  }
}

# $1 is "$ipAddr", $2 is "$ip6Addr"
function checkIpv4OrIpv6() {
  for ((w=1; w<=2; w++)); do
    IPv4DNSLookup=`timeout 0.3s dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed 's/\"//g'`
    [[ "$IPv4DNSLookup" == "" ]] && IPv4DNSLookup=`timeout 0.3s dig -4 TXT CH +short whoami.cloudflare @1.0.0.1 | sed 's/\"//g'`
    [[ "$IPv4DNSLookup" != "" ]] && break
  done
  for ((x=1; x<=2; x++)); do
    IPv6DNSLookup=`timeout 0.3s dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed 's/\"//g'`
    [[ "$IPv6DNSLookup" == "" ]] && IPv6DNSLookup=`timeout 0.3s dig -6 TXT CH +short whoami.cloudflare @2606:4700:4700::1001 | sed 's/\"//g'`
    [[ "$IPv6DNSLookup" != "" ]] && break
  done
  for y in "$3" "$4" "$5" "$6"; do
    IPv4PingDNS=`timeout 0.3s ping -4 -c 1 "$y" | grep "rtt\|round-trip" | cut -d'/' -f5 | awk -F'.' '{print $NF}' | sed -E '/^[0-9]\+\(\.[0-9]\+\)\?$/p'`"$IPv4PingDNS"
    [[ "$IPv4PingDNS" != "" ]] && break
  done
  for z in "$7" "$8" "$9" "$10"; do
    IPv6PingDNS=`timeout 0.3s ping -6 -c 1 "$z" | grep "rtt\|round-trip" | cut -d'/' -f5 | awk -F'.' '{print $NF}' | sed -E '/^[0-9]\+\(\.[0-9]\+\)\?$/p'`"$IPv6PingDNS"
    [[ "$IPv6PingDNS" != "" ]] && break
  done

  [[ -n "$1" ]] && IP_Check="$1" || IP_Check="$IPv4DNSLookup"
  if expr "$IP_Check" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
    for i in 1 2 3 4; do
      if [ $(echo "$IP_Check" | cut -d. -f$i) -gt 255 ]; then
        echo "fail ($IP_Check)"
        exit 1
      fi
    done
    IP_Check="isIPv4"
  fi

  [[ -n "$2" ]] && IPv6_Check="$2" || IPv6_Check="$IPv6DNSLookup"
# If the last two strings of IPv6 is "::", we should replace ":" to "0" for the last string to make sure it's a valid IPv6(can't end with ":").
  [[ ${IPv6DNSLookup: -1} == ":" ]] && IPv6_Check=$(echo "$IPv6DNSLookup" | sed 's/.$/0/')
# If the first two strings of IPv6 is "::", we should replace ":" to "0" for the first string to make sure it's a valid IPv6(can't start with ":").
  [[ ${IPv6DNSLookup:0:1} == ":" ]] && IPv6_Check=$(echo "$IPv6DNSLookup" | sed 's/^./0/')
# Add ":" in the last of the IPv6 address for cut all items infront of the ":" by split by symbol ":".
  IP6_Check_Temp="$IPv6_Check"":"
# Total numbers of the hex blocks in IPv6 address includes with empty value(abbreviation of "0000").
  IP6_Hex_Num=`echo "$IP6_Check_Temp" | tr -cd ":" | wc -c`
# Default number of empty values of the hex block is "0".
  IP6_Hex_Abbr="0"
# The first filter plays a role of:
# 1. check if 0-9 or a-z and ":" in original IPv6;
# 2. the longest number of ":" in IPv6 is "7", because of variable "IP6_Check_Temp" one more ":" has been add,
# so the total number of ":" in variable "IP6_Check_Temp" should be less or equal "8".
  if [[ `echo "$IPv6_Check" | grep -i '[[:xdigit:]]' | grep ':'` ]] && [[ "$IP6_Hex_Num" -le "8" ]]; then
# Total cycles of the check(sequence of the current hex block).
    for ((i=1; i<="$IP6_Hex_Num"; i++)){
# Every IPv6 hex block of current cycle.
      IP6_Hex=$(echo "$IP6_Check_Temp" | cut -d: -f$i)
# Count "::" abbreviations for this IPv6.
      [[ "$IP6_Hex" == "" ]] && IP6_Hex_Abbr=`expr $IP6_Hex_Abbr + 1`
# String number of letters or numbers in one block should less or equal "4".
      [[ `echo "$IP6_Hex" | wc -c` -le "4" ]] && {
# The second filter plays a reversion role of the following to exclude an effective IPv6 hex block:
# 1. Except 0-9 and a-f;
# 2. Abbreviation of hex block should be appeared less than or equal one time in principle.
        if [[ `echo "$IP6_Hex" | grep -iE '[^0-9a-f]'` ]] || [[ "$IP6_Hex_Abbr" -gt "1" ]]; then
          echo "fail ($IP6_Check_Temp)"
          exit 1
        fi
      }
    }
    IP6_Check="isIPv6"
  fi

# Use ping -4/-6 to replace dig -4/-6 because some IPv4 network will callback IPv6 address from DNS even if we use "dig -4" to get DNS result.
  [[ -z "$ipAddr" && -z "$ip6Addr" ]] && {
    [[ "$IPv4PingDNS" =~ ^[0-9] && "$IPv6PingDNS" =~ ^[0-9] ]] && IPStackType="BiStack"
    [[ "$IPv4PingDNS" =~ ^[0-9] && ! "$IPv6PingDNS" =~ ^[0-9] ]] && IPStackType="IPv4Stack"
    [[ ! "$IPv4PingDNS" =~ ^[0-9] && "$IPv6PingDNS" =~ ^[0-9] ]] && IPStackType="IPv6Stack"
  }
  [[ -n "$ipAddr" || -n "$ip6Addr" ]] && {
    [[ "$IP_Check" == "isIPv4" && "$IP6_Check" == "isIPv6" ]] && IPStackType="BiStack"
    [[ "$IP_Check" == "isIPv4" && "$IP6_Check" != "isIPv6" ]] && IPStackType="IPv4Stack"
    [[ "$IP_Check" != "isIPv4" && "$IP6_Check" == "isIPv6" ]] && IPStackType="IPv6Stack"
  }
  # [[ "$IPStackType" == "IPv4Stack" ]] && setIPv6="0" || setIPv6="1"
  [[ "$tmpSetIPv6" == "0" ]] && setIPv6="0" || setIPv6="1"
}

# Some "BiStack" types are accomplished by Warp which provided by CloudFlare, so we need to distinguish whether IPv4 or IPv6 stack is enabled by Warp then exclude it.
# $1 is "warp*.conf", maybe "warp.conf" or "warp-profile.conf"; $2 is "wgcf*.conf", maybe "wgcf.conf" or "wgcf-profile.conf"; $3 is "wg[0-9]", maybe "wg0.conf" or etc.
# $4/$5/$6 are "warp*/wgcf*/wg[0-9]", $7/$8 are "PrivateKey/PublicKey".
function checkWarp() {
  warpConfFiles=$(find / -maxdepth 6 -name "$1" -print -or -name "$2" -print -or -name "$3" -print)
  sysctlWarpProcess=$(systemctl 2>&1 | grep -i "$4\|$5\|$6" | wc -l)
  rcWarpProcess=$(rc-status 2>&1 | grep -i "$4\|$5\|$6" | wc -l)
  [[ "$IPStackType" == "BiStack" ]] && {
    [[ -n "$warpConfFiles" ]] && {
      for warpConfFile in $(find / -maxdepth 6 -name "$1" -print -or -name "$2" -print -or -name "$3" -print); do
        if [[ $(grep -ic "$7" "$warpConfFile") -ge "1" || $(grep -ic "$8" "$warpConfFile") -ge "1" ]]; then
          warpStatic="1"
          break
        fi
      done
    }
    [[ "$sysctlWarpProcess" -gt "0" || "$rcWarpProcess" -gt "0" ]] && warpStatic="1"
  }  
  [[ "$warpStatic" == "1" ]] && {
    [[ -z "$ipGate" ]] && IPStackType="IPv6Stack"
    [[ -z "$ip6Gate" ]] && IPStackType="IPv4Stack"
  }
}

function getIPv6Address() {
# Differences from scope link, scope host and scope global of IPv6, reference: https://qiita.com/_dakc_/items/4eefa443306860bdcfde
  i6Addr=`ip -6 addr show | grep -wA 5 "$interface" | grep -wv "lo\|host" | grep -wv "link" | grep -w "inet6" | grep "scope" | grep "global" | head -n 1 | awk -F " " '{for (i=2;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
  [[ -n "$interface4" && -n "$interface6" && "$interface4" != "$interface6" ]] && i6Addr=`ip -6 addr show | grep -wA 5 "$interface6" | grep -wv "lo\|host" | grep -wv "link" | grep -w "inet6" | grep "scope" | grep "global" | head -n 1 | awk -F " " '{for (i=2;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
  ip6Addr=`echo ${i6Addr} |cut -d'/' -f1`
  ip6Mask=`echo ${i6Addr} |cut -d'/' -f2`
# Get real IPv6 subnet of current System
  actualIp6Prefix=`ip -6 route show | grep -iv "warp\|wgcf\|wg[0-9]" | grep -w "$interface6" | grep -v "default" | grep -v "multicast" | grep -P '../[0-9]{1,3}' | head -n 1 | awk '{print $1}' | cut -d'/' -f2`
  [[ -z "$actualIp6Prefix" ]] && actualIp6Prefix="$ip6Mask"
  ip6Gate=`ip -6 route show default | grep -iv "warp\|wgcf\|wg[0-9]" | grep -w "$interface" | grep -w "via" | grep "dev" | head -n 1 | awk -F " " '{for (i=3;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
  [[ -n "$interface4" && -n "$interface6" && "$interface4" != "$interface6" ]] && ip6Gate=`ip -6 route show default | grep -w "$interface6" | grep -w "via" | grep "dev" | head -n 1 | awk -F " " '{for (i=3;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
# IPv6 expansion algorithm code reference: https://blog.caoyu.info/expand-ipv6-by-shell.html
  ip6AddrWhole=`ultimateFormatOfIpv6 "$ip6Addr"`
  ip6GateWhole=`ultimateFormatOfIpv6 "$ip6Gate"`
# In some original template OS of cloud provider like Akile.io etc,
# if prefix of IPv6 mask is 128 in static network configuration, it means there is only one IPv6(current server itself) in the network.
# The following is the sample:
#
# auto eth0
#   iface eth0 inet6 static
#     address 2603:c020:8:a19b::ffff:e6da
#     gateway 2603:c020:8:a19b::ffff
#     netmask 128
#     dns-nameservers 2001:4860:4860::8888
#
# In this condition, if IPv6 gateway has a different address with IPv6 address, the Debian installer couldn't find the correct gateway.
# The installation will fail in the end. The reason is mostly the upstream wrongly configurated the current network of this system.
# So we try to revise this value for 8 levels to expand the range of the IPv6 network and help installer to find the correct gateway.
# DHCP IPv6 network(even IPv6 netmask is "128") may not be effected by this situation.
# The result of function ' ipv6SubnetCalc "$ip6Mask" ' is "$ip6Subnet"
# The following consulted calculations are calculated by Vultr IPv6 subnet calculator and IPv6 subnet range calculator which is provided by iP Jisuanqi.
# Reference: https://www.vultr.com/resources/subnet-calculator-ipv6/
#            https://ipjisuanqi.com/ipv6.html
  [[ "$Network6Config" == "isStatic" ]] && {
    tmpIp6AddrFirst=`echo $ip6AddrWhole | sed 's/\(.\{4\}\).*/\1/' | sed 's/[a-z]/\u&/g'`
    tmpIp6GateFirst=`echo $ip6GateWhole | sed 's/\(.\{4\}\).*/\1/' | sed 's/[a-z]/\u&/g'`
    if [[ "$tmpIp6AddrFirst" != "$tmpIp6GateFirst" ]]; then
# If some brave guys set --network "static" by force, IPv6 address, mask and gateway of IPv6 DHCP configurations like Oracle Cloud etc. are:
# a public IPv6 address, a "128" mask, a local IPv6 gateway(starts with "fe80" mostly, like "fe80::200:f1e9:dec3:4ab").
# The value of mask must be set as "128", not "1" which determined by first condition of above because the local IPv6 address is unique in its' network
# and plays the role of IPv6 network discovery and identical authentication to ensure that authenticated device is certificated by upstream. 
# Explanation of using local IPv6 address as gateway quoted from Scott Hogg:
#
# Link-local IPv6 addresses are on every interface of every IPv6-enabled host and router. They are essential for LAN-based Neighbor Discovery communication.
# After the host has gone through the Duplicate Address Detection (DAD) process ensuring that its link-local address (and associated IID) is unique on the LAN segment,
# it then proceeds to sending an ICMPv6 Router Solicitation (RS) message sourced from that address.
#
# There are total three IPv6 address ranges divided into local address: fe80::/10, fec0::/10, fc00::/7.
# "fe80::/10" is similar with "169.254.0.0/16" of IPv4 of February, 2006 according to RFC 4291, ranges from fe80:0000:0000:0000:0000:0000:0000:0000 to febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff.
# "fec0::/10" is similar with "192.168.0.0/16" of IPv4 which was deprecated and returned to public IPv6 address again of September, 2004 according to RFC 3879.
# The function of "fec0::/10" was replaced by "fc00::/7" of October, 2005 according to RFC 4193, ranges from fc00:0000:0000:0000:0000:0000:0000:0000 to fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff.
# So we need to calculate ranges of "fe80::/10" and "fc00::/7", if IPv6 address is public and IPv6 gateway belongs to local IPv6 address.
# English strings in hexadecimal must be converted as capital alphabets that comparison operations can be processed by shell.
# Reference: https://blogs.infoblox.com/ipv6-coe/fe80-1-is-a-perfectly-valid-ipv6-default-gateway-address/ chapter: Link-Local Address as Default Gateway
#            https://www.wdic.org/w/WDIC/IPv6%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9 chapter: アドレスの種類(Types of address) → エニキャストアドレス(Anycast address)
#            https://www.wdic.org/w/WDIC/IPv6%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9 chapter: サイトローカルアドレス(Site local address)
#            https://www.wdic.org/w/WDIC/%E3%83%A6%E3%83%8B%E3%83%BC%E3%82%AF%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E3%83%A6%E3%83%8B%E3%82%AD%E3%83%A3%E3%82%B9%E3%83%88%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9
#            https://www.ipentec.com/document/network-format-ipv6-local-adddress chapter: IPv6のリンクローカルアドレス(Link local address of IPv6)
#            https://www.rfc-editor.org/rfc/rfc4291.html#section-2.4 chapter: 2.4. Address Type Identification
      if [[ "$((16#$tmpIp6GateFirst))" -ge "$((16#FE80))" && "$((16#$tmpIp6GateFirst))" -le "$((16#FEBF))" ]] || [[ "$((16#$tmpIp6GateFirst))" -ge "$((16#FC00))" && "$((16#$tmpIp6GateFirst))" -le "$((16#FDFF))" ]]; then
        tmpIp6Mask="64"
      else
# If the IPv6 and IPv6 gateway are not in the same IPv6 A class, the prefix of netmask should be "1",
# transfer to whole IPv6 subnet address is 8000:0000:0000:0000:0000:0000:0000:0000.
# The range of 2603:c020:8:a19b::ffff:e6da/1 is 0000:0000:0000:0000:0000:0000:0000:0000 - 7fff:ffff:ffff:ffff:ffff:ffff:ffff:ffff, the gateway 2603:c020:0008:a19b:0000:0000:0000:ffff can be included.
        tmpIp6Mask="1"
      fi
    else
      ipv6SubnetCertificate "$ip6AddrWhole" "$ip6GateWhole"
    fi
    ip6Mask="$tmpIp6Mask"
# Because of function "ipv6SubnetCalc" includes self-increment,
# so we need to confirm the goal of IPv6 prefix and make function to operate only one time in the last to save performance and avoid all
# gears of IPv6 prefix which meets well with the conditions of above are transformed to whole IPv6 addresses in one variable.
# The same thought of moving function "netmask" to the last, only need to transform IPv4 prefix to whole IPv4 address for one time.
    ipv6SubnetCalc "$ip6Mask"
# So in summary of the IPv6 sample in above, we should assign subnet mask "ffff:ffff:ffff:ffff:ffff:ffff:0000:0000"(prefix is "96") for it.
  }
}

# Examples:
# input:    ::
# output:   0:0:0:0:0:0:0:0
# input:    2620:119:35::c4
# output:   2620:119:35:0:0:0:0:c4
function fillAbbrOfIpv6() {
  inputIpv6="$1"
# Static of how many delimiters of ":" are in one ipv6 address, only one abbreviation of "::" is allowed in one IPv6 address in principle.
  delimiterNum=$(echo $inputIpv6 | awk '{print gsub(/:/, "")}')
  replaceStr=""
# A standard of IPv6 should have 7 colons, the number "7" minus total numbers of colons in an abbreviated IPv6 address and add "0" after every ":" can help us to fulfill the whole IPv6 address.
  for ((i=0; i<=$((7-$delimiterNum)); i++)); do
    replaceStr="$replaceStr"":0"
  done
# Must add one ":" after the last of expanded "0" to separate with the following IPv6 block which is not been abbreviated.
  replaceStr="$replaceStr"":"
# Replace abbreviated IPv6 address "::" to expanded IPv6 address($replaceStr).
  ipv6Expanded=${inputIpv6/::/$replaceStr}
# If the last two strings of abbreviated IPv6 is "::", we should add a "0" for the last ":" to pledge the validation of this IPv6(can't end with ":").
  [[ "$ipv6Expanded" == *: ]] && ipv6Expanded="$ipv6Expanded""0"
# If the first two strings of abbreviated IPv6 is "::", we should add a "0" for the first ":" to pledge the validation of this IPv6(can't begin with ":").
  [[ "$ipv6Expanded" == :* ]] && ipv6Expanded="0""$ipv6Expanded"
# Return IPv6 which is filled with one "0" in every abbreviated block.
  echo "$ipv6Expanded"
}

# Examples:
# input:    0:0:0:0:0:0:0:0
# output:   0000:0000:0000:0000:0000:0000:0000:0000
# input:    2620:119:35:0:0:0:0:c4
# output:   2620:0119:0035:0000:0000:0000:0000:00c4
function ultimateFormatOfIpv6() {
  abbrExpandedOfIpv6=$(fillAbbrOfIpv6 "$1")
# To make a new array names "$ipv6Hex" to storage every hex block like "2620" "119e" of IPv6, this array should have 8 indices.
  ipv6Hex=(${abbrExpandedOfIpv6//:/ })
  for ((j=0; j<8; j++)); do
# Static number of strings in every hex block of IPv6.
    length="${#ipv6Hex[j]}"
# Use decrement cycle to count how many zeroes need to be fulfilled because there are most 4 strings in one hex block in theory.
    for ((k=4; k>$length; k--)); do
# Zeroes which must be added on the head if number of digits of a hexadecimal number in one hex block is less than 4.
      ipv6Hex[j]="0${ipv6Hex[j]}"
    done
  done
# Return all elements of array of "$ipv6Hex" which is filled with 4 digits in every hexadecimal block and use colon to stitch with hexes instead of space to achieve the recovery of an abbreviated IPv6 address.
  echo ${ipv6Hex[@]} | sed 's/ /\:/g'
}

# $1 is "$ip6AddrWhole", $2 is "$$ip6GateWhole".
function ipv6SubnetCertificate() {
# If the IP and gateway are in the same IPv6 A class, not in the same IPv6 B class, the prefix of netmask should less equal than "16",
# transfer to whole IPv6 subnet address is ffff:0000:0000:0000:0000:0000:0000:0000.
# The range of 2603:c020:8:a19b::ffff:e6da/16 is 2603:0000:0000:0000:0000:0000:0000:0000 - 2603:ffff:ffff:ffff:ffff:ffff:ffff:ffff, the gateway 2603:... can be included.
  [[ `echo $1 | cut -d':' -f 1` == `echo $2 | cut -d':' -f 1` ]] && tmpIp6Mask="16"
# If the IP and gateway are in the same IPv6 A B class, not in the same IPv6 C class, the prefix of netmask should less equal than "32",
# transfer to whole IPv6 subnet address is ffff:ffff:0000:0000:0000:0000:0000:0000.
# The range of 2603:c020:8:a19b::ffff:e6da/32 is 2603:c020:0000:0000:0000:0000:0000:0000 - 2603:c020:ffff:ffff:ffff:ffff:ffff:ffff, the gateway 2603:... can be included.
  [[ `echo $1 | cut -d':' -f 1,2` == `echo $2 | cut -d':' -f 1,2` ]] && tmpIp6Mask="32"
# If the IP and gateway are in the same IPv6 A B C class, not in the same IPv6 D class, the prefix of netmask should less equal than "48",
# transfer to whole IPv6 subnet address is ffff:ffff:ffff:0000:0000:0000:0000:0000.
# The range of 2603:c020:8:a19b::ffff:e6da/48 is 2603:c020:0008:0000:0000:0000:0000:0000 - 2603:c020:0008:ffff:ffff:ffff:ffff:ffff, the gateway 2603:... can be included.
  [[ `echo $1 | cut -d':' -f 1,2,3` == `echo $2 | cut -d':' -f 1,2,3` ]] && tmpIp6Mask="48"
# If the IP and gateway are in the same IPv6 A B C D class, not in the same IPv6 E class, the prefix of netmask should less equal than "64",
# transfer to whole IPv6 subnet address is ffff:ffff:ffff:ffff:0000:0000:0000:0000.
# The range of 2603:c020:8:a19b::ffff:e6da/64 is 2603:c020:0008:a19b:0000:0000:0000:0000 - 2603:c020:0008:a19b:ffff:ffff:ffff:ffff, the gateway 2603:... can be included.
  [[ `echo $1 | cut -d':' -f 1,2,3,4` == `echo $2 | cut -d':' -f 1,2,3,4` ]] && tmpIp6Mask="64"
# If the IP and gateway are in the same IPv6 A B C D E class, not in the same IPv6 F class, the prefix of netmask should less equal than "80",
# transfer to whole IPv6 subnet address is ffff:ffff:ffff:ffff:ffff:0000:0000:0000.
# The range of 2603:c020:8:a19b::ffff:e6da/80 is 2603:c020:0008:a19b:0000:0000:0000:0000 - 2603:c020:0008:a19b:0000:ffff:ffff:ffff, the gateway 2603:... can be included.
  [[ `echo $1 | cut -d':' -f 1,2,3,4,5` == `echo $2 | cut -d':' -f 1,2,3,4,5` ]] && tmpIp6Mask="80"
# If the IP and gateway are in the same IPv6 A B C D E F class, not in the same IPv6 G class, the prefix of netmask should less equal than "96",
# transfer to whole IPv6 subnet address is ffff:ffff:ffff:ffff:ffff:ffff:0000:0000.
# The range of 2603:c020:8:a19b::ffff:e6da/96 is 2603:c020:0008:a19b:0000:0000:0000:0000 - 2603:c020:0008:a19b:0000:0000:ffff:ffff, the gateway 2603:... can be included.
  [[ `echo $1 | cut -d':' -f 1,2,3,4,5,6` == `echo $2 | cut -d':' -f 1,2,3,4,5,6` ]] && tmpIp6Mask="96"
# If the IP and gateway are in the same IPv6 A B C D E F G class, not in the same IPv6 H class, the prefix of netmask should less equal than "112",
# transfer to whole IPv6 subnet address is ffff:ffff:ffff:ffff:ffff:ffff:ffff:0000.
# The range of 2603:c020:8:a19b::ffff:e6da/112 is 2603:c020:0008:a19b:0000:0000:ffff:0000 - 2603:c020:0008:a19b:0000:0000:ffff:ffff, the gateway 2603:c020:0008:a19b:0000:0000:0000:ffff can't be included.
  [[ `echo $1 | cut -d':' -f 1,2,3,4,5,6,7` == `echo $2 | cut -d':' -f 1,2,3,4,5,6,7` ]] && tmpIp6Mask="112"
}

# $1 is $ip6Mask
function ipv6SubnetCalc() {
  tmpIp6Subnet=""
  ip6Subnet=""
  ip6SubnetEleNum=`expr $1 / 4`
  ip6SubnetEleNumRemain=`expr $1 - $ip6SubnetEleNum \* 4`
  if [[ "$ip6SubnetEleNumRemain" == 0 ]]; then
    ip6SubnetHex="0"
  elif [[ "$ip6SubnetEleNumRemain" == 1 ]]; then
    ip6SubnetHex="8"
  elif [[ "$ip6SubnetEleNumRemain" == 2 ]]; then
    ip6SubnetHex="c"
  elif [[ "$ip6SubnetEleNumRemain" == 3 ]]; then
    ip6SubnetHex="e"
  fi
  for ((i=1; i<="$ip6SubnetEleNum"; i++)); do
    tmpIp6Subnet+="f"
  done
  tmpIp6Subnet=$tmpIp6Subnet$ip6SubnetHex
  for ((j=1; j<=`expr 32 - $ip6SubnetEleNum`; j++)); do
    tmpIp6Subnet+="0"
  done
  if [[ `echo $tmpIp6Subnet | wc -c` -ge "33" ]]; then
    tmpIp6Subnet=`echo $tmpIp6Subnet | sed 's/.$//'`
  fi
  for ((k=0; k<=7; k++)); do
    ip6Subnet+=$(echo ${tmpIp6Subnet:`expr $k \* 4`:4})":"
  done
  ip6Subnet=`echo ${ip6Subnet%?}`
}

# This function help us to sort sizes for different files from different directions.
# "$FilesDirArr" storages original absolute pathes of files.
# "$FilesLineArr" receives amount of alphabets and numbers etc. in one file from "$FilesDirNum"
# "$FilesDir" is the list of absolute files' pathes those are executed by command like "grep" etc.
# According to file size, "$tmpSizeArray" sorts "$FilesLineArr"'s numbers from smallest to largest(-sort h) or from largest to smallest(-sort hr).
# "$1" are direction of files, "$2" is sort method.
function sortFileSize() {
  FilesDirArr=()
  FilesLineArr=()
  FilesDir="$1"

  for Count in $FilesDir; do
    FilesDirArr+=($Count)
    FilesDirNum=`cat $Count | wc -c`
    FilesLineArr+=($FilesDirNum)
  done
  
  tmpSizeArray=(`echo ${FilesLineArr[*]} | tr ' ' '\n' | $2`)
}

# This function may help us to find the index order in one array if we provide a random data in this array.
# "$1" is one array like "${FilesLineArr[*]}", "$2" is one element which index of this array needs to be found like "${tmpSizeArray[0]}"
function getArrItemIdx() {
  arr=$1
  item=$2
  index=0

  for i in ${arr[*]}; do
    [[ $item == $i ]] && {
      echo $index >>/dev/null 2>&1
      return
    }
    index=$(( $index + 1 ))
  done
}

# "$1" is the absolute path of a file.
function splitDirAndFile() {
  FileName=`echo $1 | awk -F/ '{print $NF}'`
  FileDirection=`echo $1 | sed "s/$FileName//g"`
}

# In Debian 11 OS template of DigitalOcean, there are 5 directions deposing network configurations after filtered by command of "find" and "grep":
# /run/network/interfaces.d/eth0            31  bytes
# /run/network/interfaces.d/eth1            31  bytes
# /etc/network/interfaces                   755 bytes
# /etc/network/interfaces.d/50-cloud-init   716 bytes
# /etc/network/cloud-interfaces-template    39  bytes
# We should get help by some algorithms to select the largest size of the file, the correct network configuration, "/etc/network/interfaces" is just there.
#
# "$1" is an array which storages temp files. "$2" is sort method, "sort -hr" is largest, "sort -h" is smallest.
function getLargestOrSmallestFile() {
  for Count in "$1"; do
    sortFileSize "$Count" "$2"
    getArrItemIdx "${FilesLineArr[*]}" "${tmpSizeArray[0]}"
    fullFilePath="${FilesDirArr[$index]}"
    [[ "$fullFilePath" != "" ]] && {
      splitDirAndFile "$fullFilePath"
      break
    } 
  done
}

# A function about parsing "*.yaml" files by native bash.
# Reference: https://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script
function parseYaml() {
  prefix=$2
  s='[[:space:]]*' w='[a-zA-Z0-9_]*'
  fs=$(echo @|tr @ '\034')
  sed -ne "s|,$s\]$s\$|]|" \
      -e ":1;s|^\($s\)\($w\)$s:$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1\2: [\3]\n\1  - \4|;t1" \
      -e "s|^\($s\)\($w\)$s:$s\[$s\(.*\)$s\]|\1\2:\n\1  - \3|;p" $1 | \
  sed -ne "s|,$s}$s\$|}|" \
      -e ":1;s|^\($s\)-$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1- {\2}\n\1  \3: \4|;t1" \
      -e "s|^\($s\)-$s{$s\(.*\)$s}|\1-\n\1  \2|;p" | \
  sed -ne "s|^\($s\):|\1|" \
      -e "s|^\($s\)-$s[\"']\(.*\)[\"']$s\$|\1$fs$fs\2|p" \
      -e "s|^\($s\)-$s\(.*\)$s\$|\1$fs$fs\2|p" \
      -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" | \
  awk -F$fs '{
    indent=length($1)/2
    vname[indent]=$2
    for (i in vname) {if (i>indent) {delete vname[i]; idx[i]=0}}
    if (length($2)==0) {vname[indent]= ++idx[indent]}
    if (length($3)>0) {
      vn=""
      for (i=0;i<indent;i++) {vn=(vn)(vname[i])("_")}
      printf("%s%s%s=\"%s\"\n","'$prefix'",vn,vname[indent],$3)
    }
  }'
}

# $1 is $CurrentOS
function getInterface() {
# Network config file for Ubuntu 16.04 and former version, 
# Debian all version included the latest Debian 11 is deposited in /etc/network/interfaces, they managed by "ifupdown".
# Ubuntu 18.04 and later version, using netplan to replace legacy ifupdown, the network config file is in /etc/netplan/
  interface=""
  Interfaces=`cat /proc/net/dev |grep ':' | cut -d':' -f1 | sed 's/\s//g' | grep -iv '^lo\|^sit\|^stf\|^gif\|^dummy\|^vmnet\|^vir\|^gre\|^ipip\|^ppp\|^bond\|^tun\|^tap\|^ip6gre\|^ip6tnl\|^teql\|^ocserv\|^vpn'`
# Some server has two different network adapters and for example: eth0 is for IPv4, eth1 is for IPv6, so we need to distinguish whether they are the same.
  default4Route=`ip -4 route show default | grep "^default"`
# In Vultr server of 2.5$/mo plan, it has only IPv6 address, so the default route is via IPv6. 
  default6Route=`ip -6 route show default | grep "^default"`
  for item in `echo "$Interfaces"`; do
    [ -n "$item" ] || continue
    echo "$default4Route" | grep -q "$item"
    [ $? -eq 0 ] && interface4="$item" && break
  done
  for item in `echo "$Interfaces"`; do
    [ -n "$item" ] || continue
    echo "$default6Route" | grep -q "$item"
    [ $? -eq 0 ] && interface6="$item" && break
  done
  interface="$interface4 $interface6"
  [[ "$interface4" == "$interface6" ]] && interface=`echo "$interface" | cut -d' ' -f 1`
  [[ -z "$interface4" || -z "$interface6" ]] && {
    interface=`echo "$interface" | sed 's/[[:space:]]//g'`
    [[ -z "$interface4" ]] && interface4="$interface"
    [[ -z "$interface6" ]] && interface6="$interface"
  }
  echo "$interface" > /dev/null
# Some templates of cloud provider like Bandwagonhosts, Ubuntu 22.04, may modify parameters in " GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0" " in /etc/default/grub
# to make Linux kernel redirect names of network adapters from real name like ens18, ens3, enp0s4 to eth0, eth1, eth2...
# This setting may confuse program to get real adapter name from reading /proc/cat/dev
  GrubCmdLine=`grep "GRUB_CMDLINE_LINUX" /etc/default/grub | grep -v "#" | grep "net.ifnames=0\|biosdevname=0"`
# So we need to comfirm whether adapter name is renamed and whether we should inherit it into new system.
  if [[ -n "$GrubCmdLine" && -z "$interfaceSelect" ]] || [[ "$interface4" == "eth0" ]] || [[ "$interface6" == "eth0" ]]|| [[ "$linux_relese" == 'kali' ]] || [[ "$linux_relese" == 'alpinelinux' ]]; then
    setInterfaceName='1'
  fi
  if [[ "$1" == 'CentOS' || "$1" == 'AlmaLinux' || "$1" == 'RockyLinux' || "$1" == 'Fedora' || "$1" == 'Vzlinux' || "$1" == 'OracleLinux' || "$1" == 'OpenCloudOS' || "$1" == 'AlibabaCloudLinux' || "$1" == 'ScientificLinux' || "$1" == 'AmazonLinux' || "$1" == 'RedHatEnterpriseLinux' || "$1" == 'OpenAnolis' ]]; then
    [[ ! $(find / -maxdepth 5 -path /*network-scripts -type d -print -or -path /*system-connections -type d -print) ]] && {
      echo -ne "\n[${red}Error${plain}] Invalid network configuration!\n"
      exit 1
    }
    NetCfgWhole=()
    tmpNetCfgFiles=""
    for Count in $(find / -maxdepth 5 -path /*network-scripts -type d -print -or -path /*system-connections -type d -print); do
      NetCfgDir="$Count""/"
# If "NetworkManager" replaced "network-scripts", there is a file called "readme-ifcfg-rh.txt" in dir: /etc/sysconfig/network-scripts/
      # NetCfgFile=`ls -Sl $NetCfgDir 2>/dev/null | awk -F' ' '{print $NF}' | grep -iv 'lo\|sit\|stf\|gif\|dummy\|vmnet\|vir\|gre\|ipip\|ppp\|bond\|tun\|tap\|ip6gre\|ip6tnl\|teql\|ocserv\|vpn\|readme' | grep -s "$interface" | head -n 1`
# Condition of "grep -iv 'lo\|sit\|stf..." has been deperated because the config file name of "NetworkManager" which initiated by "cloud init" is like "cloud-init-eth0.nmconnection".
# Different from command "grep", command "ls" can only show file name but not full file direction.
# There are 3 files named "ifcfg-ens18  ifcfg-eth0  ifcfg-eth1" in dir "/etc/sysconfig/network-scripts/" of Almalinux 8 of Bandwagonhosts template.
# We should select the correct one by adjust whether includes interface name and file size.
# Files in "/etc/sysconfig/network-scripts/", reference: https://zetawiki.com/wiki/%EB%B6%84%EB%A5%98:/etc/sysconfig/network-scripts
      NetCfgFiles=`ls -Sl $NetCfgDir 2>/dev/null | awk -F' ' '{print $NF}' | grep -iv 'readme\|ifcfg-lo\|ifcfg-bond\|ifup\|ifdown\|vpn\|init.ipv6-global\|network-functions' | grep -s "ifcfg\|nmconnection"`
      for Files in $NetCfgFiles; do
        if [[ `grep -w "$interface4\|$interface6" "$NetCfgDir$Files"` != "" ]]; then
          tmpNetCfgFiles+=$(echo -e "\n""$NetCfgDir$Files")
        fi
      done
      getLargestOrSmallestFile "$tmpNetCfgFiles" "sort -hr"
      NetCfgFile="$FileName"
# In Google Cloud Platform, network configuration files of Redhat Enterprise 8+, CentOS-stream 8+, RockyLinux 8+ are all named " 'Wired connection 1.nmconnection' " in "/run/NetworkManager/system-connections/" direction.
# Yes, that's right, the name of this file includes spaces and two single quotes which are in the first and last.
# Only command "ls" can show the whole file name:
#
# [root@instance-2 ~]# ls -l /run/NetworkManager/system-connections/
# total 4
# -rw-------. 1 root root 270 May  4 22:15 'Wired connection 1.nmconnection'
#
# Many commands in linux can't handle these son of bitches because single quote is a strong reference so that the strings between two single quotes can't be any parameters.
# The most typical case is when you search these fuckin files by "grub", the result deleted two single quotes automatically like:
#
# [root@instance-2 ~]# grep -r "ipv4" /run/NetworkManager/system-connections/
# /run/NetworkManager/system-connections/Wired connection 1.nmconnection:[ipv4]
# 
# When we try to use command "head" and "tail" to be pipeline items after the first command "ls", the result is also the same:
#
# [root@instance-2 ~]# ls /run/NetworkManager/system-connections/ | head -n 1 | tail -n 1
# Wired connection 1.nmconnection
#
# A file name includes space is very dangerous in linux because the operating system will use a couple of single quotes to bundle it as a "not be referenced" file to prevent os identify them error.
# No matter what command you choice, unless attach its' absolute direction and execute it with other commands directly in the shell, it can work correctly, otherwise you wanna be cried when handle them by parameters transactions.
# We should use "grep" to extract which key words we need and print the result to another file.
# If this universe has hell, those jackass  who deployed these tortured settings of OS templates works on Google Cloud Platform will go to there when they died.
      if [[ ! -z "$NetCfgFile" && ! -f "$NetCfgDir$NetCfgFile" ]]; then
        tmpNetcfgDir="/root/tmp/installNetcfgCollections/"
        [[ ! -d "$tmpNetcfgDir" ]] && mkdir -p "$tmpNetcfgDir"
        if [[ "$NetCfgFile" =~ "nmconnection" ]]; then
          NetCfgFile="$interface.nmconnection"
          grep -wr "$interface\|\[ipv4\]\|\[ipv6\]\|\[connection\]\|\[ethernet\]\|id=*\|interface-name=*\|type=*\|method=*" "$NetCfgDir" | cut -d ':' -f 2 | tee -a "$tmpNetcfgDir$NetCfgFile"
          NetCfgDir="$tmpNetcfgDir"
        elif [[ "$NetCfgFile" =~ "ifcfg" ]]; then
          NetCfgFile="$ifcfg-$interface"
          grep -wr "$interface\|BOOTPROTO=*\|DEVICE=*\|ONBOOT=*\|TYPE=*\|HWADDR=*\|IPV6_AUTOCONF=*\|DHCPV6C=*" "$NetCfgDir" | cut -d ':' -f 2 | tee -a "$tmpNetcfgDir$NetCfgFile"
          NetCfgDir="$tmpNetcfgDir"
        fi
      fi
# The following conditions must appeared at least 3 times in a vaild network config file.
      [[ `grep -wcs "$interface4\|$interface6\|BOOTPROTO=*\|DEVICE=*\|ONBOOT=*\|TYPE=*\|HWADDR=*\|id=*\|\[connection\]\|interface-name=*\|type=*\|method=*" $NetCfgDir$NetCfgFile` -ge "3" ]] && {
# In AlmaLinux 9 template of DigitalOcean, network adapter name is "eth0", there are two network config files in the OS, and they all belong to "eth0".
# /etc/sysconfig/network-scripts/ifcfg-eth0
# /etc/NetworkManager/system-connections/eth0.nmconnection
# Which is the vaild one? We can storage them to one array first.
        NetCfgWhole+=("$NetCfgDir$NetCfgFile")
      }
    done
# If index "1"(starts in "0") is not empty, it means there at least two network config files in current OS.
    if [[ "${NetCfgWhole[1]}" != "" ]]; then
      for c in "${NetCfgWhole[@]}"; do
# Cloud providers usually use automatic tools like SolusVM or Cloud-init etc. to initial different Linux OS.
# The first row of the network config files is showed like the following example regularly:
# # Generated by SolusVM
# # Created by cloud-init on instance boot automatically, do not edit.
# So the "#" and preposition "(did something) by (who)" is a obvious hint to help us to distinguish:
        [[ `sed -e "4"p "$c" | grep " by " | grep -c "#"` -ge "1" ]] && {
          NetCfgWhole="$c"
          break
        }
      done
# If the array of "${NetCfgWhole}" doesn't be turned into a parameter, it means there are not any annotates generated by automatic tools.
# We need to import command "declare" to make an inspection to comfirm whether it's an array or a parameter,
# If it's still an arrary, we can only assume the index "0" in this array as the valid network config file.
      [[ `declare -p NetCfgWhole 2>/dev/null | grep -iw '^declare -a'` ]] && {
        NetCfgWhole="${NetCfgWhole[0]}"
      }
    fi
    splitDirAndFile "$NetCfgWhole"
    NetCfgFile="$FileName"
    NetCfgDir="$FileDirection"
  else
    readNetplan=$(find $(echo `find / -maxdepth 4 -path /*netplan`) -maxdepth 1 -name "*.yaml" -print)
    readIfupdown=$(find / -maxdepth 5 -path /*network -type d -print | grep -v "lib\|systemd")
    if [[ ! -z "$readNetplan" ]]; then
# Ubuntu 18+ network configuration
      networkManagerType="netplan"
      tmpNetCfgFiles=""
      for Count in $readNetplan; do
        tmpNetCfgFiles+=$(echo -e "\n"`grep -wrl "network" | grep -wrl "ethernets" | grep -wrl "$interface4\|$interface6" | grep -wrl "version" "$Count" 2>/dev/null`)
      done
      getLargestOrSmallestFile "$tmpNetCfgFiles" "sort -hr"
      NetCfgFile="$FileName"
      NetCfgDir="$FileDirection"
      NetCfgWhole="$NetCfgDir$NetCfgFile"
    elif [[ ! -z "$readIfupdown" ]]; then
# Debian/Kali/AlpineLinux network configuration
# Some versions of Ubuntu 18 like virmach template use ifupdown not netplan.
      networkManagerType="ifupdown"
# Collect all eligible config files by the several parent directions names "network".
# Reference: https://wiki.debian.org/NetworkConfiguration           
#            https://wiki.debian.org/IPv6PrefixDelegation
      tmpNetCfgFiles=""
      for Count in $readIfupdown; do
        if [[ "$IPStackType" == "IPv4Stack" ]]; then
          NetCfgFiles=`grep -wrl 'iface' | grep -wrl "auto\|dhcp\|static\|manual" | grep -wrl 'inet' "$Count""/" 2>/dev/null | grep -v "if-*" | grep -v "state" | grep -v "helper" | grep -v "template"`
        elif [[ "$IPStackType" == "BiStack" ]] || [[ "$IPStackType" == "IPv6Stack" ]]; then
          NetCfgFiles=`grep -wrl 'iface' | grep -wrl "auto\|dhcp\|static\|manual" | grep -wrl 'inet\|inet6\|ip -6' "$Count""/" 2>/dev/null | grep -v "if-*" | grep -v "state" | grep -v "helper" | grep -v "template"`
        fi
        for Files in $NetCfgFiles; do
          if [[ `grep -w "$interface4\|$interface6" "$Files"` != "" ]]; then
            tmpNetCfgFiles+=$(echo -e "\n""$Files")
          fi
        done
      done
      getLargestOrSmallestFile "$tmpNetCfgFiles" "sort -hr"
      NetCfgFile="$FileName"
      NetCfgDir="$FileDirection"
      NetCfgWhole="$NetCfgDir$NetCfgFile"
    else
      echo -ne "\n[${red}Error${plain}] Invalid network configuration!\n"
      exit 1
    fi
  fi
}

# $1 is "$ipMask", $2 is "$ip6Mask". Can only accept prefix number transmit.
function acceptIPv4AndIPv6SubnetValue() {
  [[ -n "$1" ]] && {
    if [[ `echo "$1" | grep '^[[:digit:]]*$'` && "$1" -ge "1" && "$1" -le "32" ]]; then
      ipPrefix="$1"
      actualIp4Prefix="$ipPrefix"
      ipMask=`netmask "$1"`
      actualIp4Subnet=`netmask "$1"`
    else
      echo -ne "\n[${red}Warning${plain}] Only accept prefix format of IPv4 address, length from 1 to 32."
      echo -ne "\nIPv4 CIDR Calculator: https://www.vultr.com/resources/subnet-calculator/\n"
      exit 1
    fi
  }
  [[ -n "$2" ]] && {
    if [[ `echo "$2" | grep '^[[:digit:]]*$'` && "$2" -ge "1" && "$2" -le "128" ]]; then
      actualIp6Prefix="$2"
      ipv6SubnetCalc "$2"
    else
      echo -ne "\n[${red}Warning${plain}] Only accept prefix format of IPv6 address, length from 1 to 128."
      echo -ne "\nIPv6 CIDR Calculator: https://en.rakko.tools/tools/27/\n"
      exit 1
    fi
  }
}

# To confuse whether ipv4 is dhcp or static and whether ipv6 is dhcp or static in Redhat like os in version 9 and later,
# $1 is $NetCfgDir, $2 is $NetCfgFile, $3 is "ipv4" or "ipv6", $4 is "method="
function checkIpv4OrIpv6ConfigForRedhat9Later() {
  IpTypeLine="`awk '/\['$3'\]/{print NR}' $1/$2 | head -n 2 | tail -n 1`"
  ConnectTypeArray=()
  CtaSpace=()
  for tmpConnectType in `awk '/'$4'/{print NR}' $1/$2`; do
    ConnectTypeArray+=("$tmpConnectType" "$ConnectTypeArray")
    [[ `expr $tmpConnectType - $IpTypeLine` -gt "0" ]] && CtaSpace+=(`expr "$tmpConnectType" - "$IpTypeLine"` "$CtaSpace")
  done
  minArray=${CtaSpace[0]}
  for ((i=1;i<=`grep -io "$4" $1/$2 | wc -l`;i++)); do
    for j in ${CtaSpace[@]}; do
      [[ "$minArray" -gt "$j" ]] && minArray=$j
    done
  done
  NetCfgLineNum=`expr $minArray + $IpTypeLine`
}

# If original system using DHCP, skip IP address, subnet mask, gateway, DNS server settings manually.
# In many DHCP servers, manual settings may cause some additional problems.
# For example, in Hetzner's machine, the network configuration of official template is DHCP for IPv4, STATIC for IPv6,
# If we config both IPv4 and IPv6 as STATIC, IPv4 network will failure, even though according to the bullshit network config guide which provided by Hetzner:
# https://docs.hetzner.com/cloud/servers/static-configuration/
# So we need to distinguish whether IPv4 is DHCP or STATIC and whether IPv6 is DHCP or STATIC separately and clearly.

# $1 is $CurrentOS, $2 is $CurrentOSVer, $3 is $IPStackType
function checkDHCP() {
  getInterface "$1"
  if [[ "$1" == 'CentOS' || "$1" == 'AlmaLinux' || "$1" == 'RockyLinux' || "$1" == 'Fedora' || "$1" == 'Vzlinux' || "$1" == 'OracleLinux' || "$1" == 'OpenCloudOS' || "$1" == 'AlibabaCloudLinux' || "$1" == 'ScientificLinux' || "$1" == 'AmazonLinux' || "$1" == 'RedHatEnterpriseLinux' || "$1" == 'OpenAnolis' ]]; then
# RedHat like linux system 8 and before network config name is "ifcfg-interface", deposited in /etc/sysconfig/network-scripts/
# RedHat like linux system 9 and later network config name is "interface.nmconnection", deposited in /etc/NetworkManager/system-connections/
# In some templates like RockyLinux 9 x64 of DigitalOcean, both "/etc/sysconfig/network-scripts/ifcfg-eth0" and "/etc/NetworkManager/system-connections/ens3.nmconnection" are existed.
# in "ifcfg-eth0", BOOTPROTO=none; in "ens3.nmconnection", [ipv4] method=auto. the actually network adapter is "eth0", so the vaild network config file name is "ifcfg-eth0".
# So we need to check the type of the network configuration file to determine whether the method of config is dhcp or static.
    if [[ "$NetCfgFile" =~ "ifcfg" ]]; then
# "BOOTPROTO=dhcp" is for IPv4 DHCP, "=none" or "=static" is Static.
# "IPv6_AUTOCONf=yes" or "DHCPV6C=yes" is IPv6 DHCP, "=no" is IPv6 Static.
# For IPv6 STATIC configuration, "IPv6_AUTOCONf=no" or "DHCPV6C=no" doesn't exist is allowed.
# For IPv6 DHCP configuration, "IPv6_AUTOCONf=yes" or "DHCPV6C=yes" is necessary.
# Reference: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/s1-networkscripts-interfaces
      if [[ "$3" == "IPv4Stack" ]]; then
        Network6Config="isDHCP"
        [[ -n `grep -Ewirn "BOOTPROTO=none|BOOTPROTO=\"none\"|BOOTPROTO=\'none\'|BOOTPROTO=NONE|BOOTPROTO=\"NONE\"|BOOTPROTO=\'NONE\'|BOOTPROTO=static|BOOTPROTO=\"static\"|BOOTPROTO=\'static\'|BOOTPROTO=STATIC|BOOTPROTO=\"STATIC\"|BOOTPROTO=\'STATIC\'" $NetCfgWhole` ]] && Network4Config="isStatic" || Network4Config="isDHCP"
      elif [[ "$3" == "BiStack" ]]; then
        [[ -n `grep -Ewirn "BOOTPROTO=none|BOOTPROTO=\"none\"|BOOTPROTO=\'none\'|BOOTPROTO=NONE|BOOTPROTO=\"NONE\"|BOOTPROTO=\'NONE\'|BOOTPROTO=static|BOOTPROTO=\"static\"|BOOTPROTO=\'static\'|BOOTPROTO=STATIC|BOOTPROTO=\"STATIC\"|BOOTPROTO=\'STATIC\'" $NetCfgWhole` ]] && Network4Config="isStatic" || Network4Config="isDHCP"
        [[ -n `grep -Ewirn "IPV6_AUTOCONF=yes|IPV6_AUTOCONF=\"yes\"|IPV6_AUTOCONF=YES|IPV6_AUTOCONF=\"YES\"|DHCPV6C=yes|DHCPV6C=\"yes\"" $NetCfgWhole` ]] && Network6Config="isDHCP" || Network6Config="isStatic"
      elif [[ "$3" == "IPv6Stack" ]]; then
        Network4Config="isDHCP"
        [[ -n `grep -Ewirn "IPV6_AUTOCONF=yes|IPV6_AUTOCONF=\"yes\"|IPV6_AUTOCONF=YES|IPV6_AUTOCONF=\"YES\"|DHCPV6C=yes|DHCPV6C=\"yes\"" $NetCfgWhole` ]] && Network6Config="isDHCP" || Network6Config="isStatic"
      fi
    elif [[ "$NetCfgFile" =~ "nmconnection" ]]; then
# In NetworkManager for Redhat 9 and later, IPv4 and IPv6 share the same config method and value like the following sample:
#
# [ethernet]
#
# [ipv4]
# method=auto
#
# [ipv6]
# addr-gen-mode=eui64
# method=auto
#
# So we need to import the function "checkIpv4OrIpv6ConfigForRedhat9Later" to confuse
# which "method=auto or manual" is belonged to [ipv4], which "method=auto or manual" is belonged to [ipv6]. 
      checkIpv4OrIpv6ConfigForRedhat9Later "$NetCfgDir" "$NetCfgFile" "ipv4" "method="
      NetCfg4LineNum="$NetCfgLineNum"
      checkIpv4OrIpv6ConfigForRedhat9Later "$NetCfgDir" "$NetCfgFile" "ipv6" "method="
      NetCfg6LineNum="$NetCfgLineNum"
      if [[ "$3" == "IPv4Stack" ]]; then
        Network6Config="isDHCP"
        [[ `sed -n "$NetCfg4LineNum"p $NetCfgWhole` == "method=auto" ]] && Network4Config="isDHCP" || Network4Config="isStatic"
      elif [[ "$3" == "BiStack" ]]; then
        [[ `sed -n "$NetCfg4LineNum"p $NetCfgWhole` == "method=auto" ]] && Network4Config="isDHCP" || Network4Config="isStatic"
        [[ `sed -n "$NetCfg6LineNum"p $NetCfgWhole` == "method=auto" ]] && Network6Config="isDHCP" || Network6Config="isStatic"
      elif [[ "$3" == "IPv6Stack" ]]; then
        Network4Config="isDHCP"
        [[ `sed -n "$NetCfg4LineNum"p $NetCfgWhole` == "method=auto" ]] && Network4Config="isDHCP" || Network4Config="isStatic"
      fi
    fi
  elif [[ "$1" == 'Debian' ]] || [[ "$1" == 'Kali' ]] || [[ "$1" == 'Ubuntu' && "$networkManagerType" == "ifupdown" ]] || [[ "$1" == 'AlpineLinux' ]]; then
# Debian network configs may be deposited in the following directions.
# /etc/network/interfaces or /etc/network/interfaces.d/interface or /run/network/interfaces.d/interface
    if [[ "$3" == "IPv4Stack" ]]; then
      Network6Config="isDHCP"
      [[ `grep -iw "iface" $NetCfgWhole | grep -iw "$interface4" | grep -iw "inet" | grep -ic "auto\|dhcp"` -ge "1" ]] && Network4Config="isDHCP" || Network4Config="isStatic"
    elif [[ "$3" == "BiStack" ]]; then
      [[ `grep -iw "iface" $NetCfgWhole | grep -iw "$interface4" | grep -iw "inet" | grep -ic "auto\|dhcp"` -ge "1" ]] && Network4Config="isDHCP" || Network4Config="isStatic"
      [[ `grep -iw "iface" $NetCfgWhole | grep -iw "$interface6" | grep -iw "inet6" | grep -ic "auto\|dhcp"` -ge "1" ]] && Network6Config="isDHCP" || Network6Config="isStatic"
    elif [[ "$3" == "IPv6Stack" ]]; then
      Network4Config="isDHCP"
      [[ `grep -iw "iface" $NetCfgWhole | grep -iw "$interface6" | grep -iw "inet6" | grep -ic "auto\|dhcp"` -ge "1" ]] && Network6Config="isDHCP" || Network6Config="isStatic"
    fi
  elif [[ "$1" == 'Ubuntu' && "$networkManagerType" == "netplan" ]]; then
# For netplan(Ubuntu 18 and later), if network configuration is Static whether IPv4 or IPv6
# in "*.yaml" config file, dhcp(4 or 6): no or false doesn't exist is allowed.
# But if is DHCP, dhcp(4 or 6): yes or true is necessary.
# Typical format of dhcp status in "*.yaml" is "dhcp4/6: true/false" or "dhcp4/6: yes/no".
# The raw sample processed by function "parseYaml" is: " network_ethernets_enp1s0_dhcp4="true" network_ethernets_enp1s0_dhcp6="true" "
    dhcpStatus=$(parseYaml "$NetCfgWhole" | grep "$interface" | grep "dhcp")
    if [[ "$3" == "IPv4Stack" ]]; then
      Network6Config="isDHCP"
      [[ "$dhcpStatus" =~ "dhcp4=\"true\"" || "$dhcpStatus" =~ "dhcp4=\"yes\"" ]] && Network4Config="isDHCP" || Network4Config="isStatic"
    elif [[ "$3" == "BiStack" ]]; then
      [[ "$dhcpStatus" =~ "dhcp4=\"true\"" || "$dhcpStatus" =~ "dhcp4=\"yes\"" ]] && Network4Config="isDHCP" || Network4Config="isStatic"
      [[ "$dhcpStatus" =~ "dhcp6=\"true\"" || "$dhcpStatus" =~ "dhcp6=\"yes\"" ]] && Network6Config="isDHCP" || Network6Config="isStatic"
    elif [[ "$3" == "IPv6Stack" ]]; then
      Network4Config="isDHCP"
      [[ "$dhcpStatus" =~ "dhcp6=\"true\"" || "$dhcpStatus" =~ "dhcp6=\"yes\"" ]] && Network6Config="isDHCP" || Network6Config="isStatic"
    fi
  fi
  [[ "$tmpDHCP" == "dhcp" || "$tmpDHCP" == "auto" || "$tmpDHCP" == "automatic" || "$tmpDHCP" == "true" || "$tmpDHCP" == "yes" || "$tmpDHCP" == "1" ]] && {
    Network4Config="isDHCP"
    Network6Config="isDHCP"
  }
  [[ "$tmpDHCP" == "static" || "$tmpDHCP" == "manual" || "$tmpDHCP" == "none" || "$tmpDHCP" == "false" || "$tmpDHCP" == "no" || "$tmpDHCP" == "0" ]] && {
    Network4Config="isStatic"
    Network6Config="isStatic"
  }
  [[ "$Network4Config" == "" ]] && Network4Config="isStatic"
  [[ "$Network6Config" == "" ]] && Network6Config="isStatic"
  rm -rf "$tmpNetcfgDir"
}

# $1 is "in-target"
function DebianModifiedPreseed() {
  if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'kali' ]]; then
# Must use ";" instead of using "&&", "echo -e" etc to combine multiple commands, or write text in files, recommend sed.
# Can't pass parameters correctly in preseed environment
# DebianVimVer=`ls -a /usr/share/vim | grep vim[0-9]`
    DebianVimVer="vim"`expr ${DebianDistNum} + 71`
    [[ "$DIST" == "bookworm" || "$DIST" == "kali-rolling" ]] && DebianVimVer="vim90"
    AptUpdating="$1 apt update;"
# pre-install some commonly used software.
    # InstallComponents="$1 apt install sudo apt-transport-https bc binutils ca-certificates cron curl debian-keyring debian-archive-keyring dnsutils dosfstools dpkg efibootmgr ethtool fail2ban file figlet iputils-tracepath jq lrzsz libnet-ifconfig-wrapper-perl lsof libnss3 lsb-release mtr-tiny mlocate netcat-openbsd net-tools ncdu nmap ntfs-3g parted psmisc python3 socat sosreport subnetcalc tcpdump telnet traceroute unzip unrar-free uuid-runtime vim vim-gtk3 wget xz-utils -y;"
    InstallComponents="$1 apt install sudo ca-certificates cron curl dnsutils dpkg fail2ban file lrzsz lsb-release net-tools traceroute unzip vim wget xz-utils -y;"
# In Debian 9 and former, some certificates are expired.
    DisableCertExpiredCheck="$1 sed -i '/^mozilla\/DST_Root_CA_X3/s/^/!/' /etc/ca-certificates.conf; $1 update-ca-certificates -f;"
    if [[ "$IsCN" == "cn" ]]; then
# Modify /root/.bashrc to support colorful filename.
      ChangeBashrc="$1 rm -rf /root/.bashrc; $1 wget --no-check-certificate -qO /root/.bashrc 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Debian/.bashrc';"
# Need to install "resolvconf" manually after all installation ended, logged into new system.
# DNS server validation must setting up in installed system, can't in preseeding!
# Set China DNS server from USTC and Tsinghua University permanently
      SetDNS="CNResolvHead"
      DnsChangePermanently="$1 mkdir -p /etc/resolvconf/resolv.conf.d/; $1 wget --no-check-certificate -qO /etc/resolvconf/resolv.conf.d/head 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Debian/network/${SetDNS}';"
# Modify logging in welcome information(Message Of The Day) of Debian and make it more pretty.
      ModifyMOTD="$1 rm -rf /etc/update-motd.d/ /etc/motd /run/motd.dynamic; $1 mkdir -p /etc/update-motd.d/; $1 wget --no-check-certificate -qO /etc/update-motd.d/00-header 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Debian/updatemotd/00-header'; $1 wget --no-check-certificate -qO /etc/update-motd.d/10-sysinfo 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Debian/updatemotd/10-sysinfo'; $1 wget --no-check-certificate -qO /etc/update-motd.d/90-footer 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Debian/updatemotd/90-footer'; $1 chmod +x /etc/update-motd.d/00-header; $1 chmod +x /etc/update-motd.d/10-sysinfo; $1 chmod +x /etc/update-motd.d/90-footer;"
    else
      ChangeBashrc="$1 rm -rf /root/.bashrc; $1 wget --no-check-certificate -qO /root/.bashrc 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Debian/.bashrc';"
# Set DNS server from CloudFlare and Google permanently
      SetDNS="NomalResolvHead"
      DnsChangePermanently="$1 mkdir -p /etc/resolvconf/resolv.conf.d/; $1 wget --no-check-certificate -qO /etc/resolvconf/resolv.conf.d/head 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Debian/network/${SetDNS}';"
      ModifyMOTD="$1 rm -rf /etc/update-motd.d/ /etc/motd /run/motd.dynamic; $1 mkdir -p /etc/update-motd.d/; $1 wget --no-check-certificate -qO /etc/update-motd.d/00-header 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Debian/updatemotd/00-header'; $1 wget --no-check-certificate -qO /etc/update-motd.d/10-sysinfo 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Debian/updatemotd/10-sysinfo'; $1 wget --no-check-certificate -qO /etc/update-motd.d/90-footer 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Debian/updatemotd/90-footer'; $1 chmod +x /etc/update-motd.d/00-header; $1 chmod +x /etc/update-motd.d/10-sysinfo; $1 chmod +x /etc/update-motd.d/90-footer;"
    fi
# Set parameter "mouse-=a" in /usr/share/vim/vim-version/defaults.vim to support copy text from terminal to client.
    VimSupportCopy="$1 sed -i 's/set mouse=a/set mouse-=a/g' /usr/share/vim/${DebianVimVer}/defaults.vim;"
# Enable cursor edit backspace freely in insert mode.
# Reference: https://wonderwall.hatenablog.com/entry/2016/03/23/232634
    VimIndentEolStart="$1 sed -i 's/set compatible/set nocompatible/g' /etc/vim/vimrc.tiny; $1 sed -i '/set nocompatible/a\set backspace=2' /etc/vim/vimrc.tiny;"
# For multiple interfaces environment, if the interface which is configurated by "auto", regardless of it is plugged by internet cable, 
# Debian/Kali will continuously try to wake and start up it contains with dhcp even timeout.
# Set up with "allow-hotplug(default setting by Debian/Kali installer)" will skip this problem, but if one interface has more than 1 IP or it will connect to
# another network bridge, when system restarted, the interfaces' initialization will be failed, in most of VPS environments, the interfaces of machine should be stable,
# so replace the default from "allow-hotplug" to "auto" for interfaces config method is a better idea?
    [[ "$autoPlugAdapter" == "1" ]] && AutoPlugInterfaces="$1 sed -ri \"s/allow-hotplug $interface4/auto $interface4/g\" /etc/network/interfaces; $1 sed -ri \"s/allow-hotplug $interface6/auto $interface6/g\" /etc/network/interfaces;" || AutoPlugInterfaces=""
# If the network config type of server is DHCP and it have both public IPv4 and IPv6 address,
# Debian install program even get nerwork config with DHCP, but after log into new system,
# only the IPv4 of the server has been configurated.
# so need to write "iface interface inet6 dhcp" to /etc/network/interfaces in preseeding process,
# to avoid config IPv6 manually after log into new system.
    SupportIPv6orIPv4=""
    ReplaceActualIpPrefix=""
    if [[ "$IPStackType" == "IPv4Stack" ]]; then
# This IPv4Stack DHCP machine can access IPv6 network in the future, maybe.
# But it should be setting as IPv4 network priority.
      SupportIPv6orIPv4="$1 sed -i '\$aiface $interface inet6 dhcp' /etc/network/interfaces; $1 sed -i '\$alabel ::ffff:0:0/96' /etc/gai.conf;"
      ReplaceActualIpPrefix="$1 sed -ri \"s/address $ipAddr\/$ipPrefix/address $ipAddr\/$actualIp4Prefix/g\" /etc/network/interfaces;"
    elif [[ "$IPStackType" == "BiStack" ]]; then
      if [[ "$Network6Config" == "isDHCP" ]]; then
# Enable IPv6 dhcp and set prefer IPv6 access for BiStack or IPv6Stack machine: add "label 2002::/16", "label 2001:0::/32" in last line of the "/etc/gai.conf"
        SupportIPv6orIPv4="$1 sed -i '\$aiface $interface inet6 dhcp' /etc/network/interfaces; $1 sed -i '\$alabel 2002::/16' /etc/gai.conf; $1 sed -i '\$alabel 2001:0::/32' /etc/gai.conf;"
        [[ -n "$interface4" && -n "$interface6" && "$interface4" != "$interface6" ]] && SupportIPv6orIPv4="$1 sed -i '\$a\ ' /etc/network/interfaces; $1 sed -i '\$aallow-hotplug $interface6' /etc/network/interfaces; $1 sed -i '\$aiface $interface6 inet6 dhcp' /etc/network/interfaces; $1 sed -i '\$alabel 2002::/16' /etc/gai.conf; $1 sed -i '\$alabel 2001:0::/32' /etc/gai.conf;"
        ReplaceActualIpPrefix="$1 sed -ri \"s/address $ipAddr\/$ipPrefix/address $ipAddr\/$actualIp4Prefix/g\" /etc/network/interfaces;"
      elif [[ "$Network6Config" == "isStatic" ]]; then
        SupportIPv6orIPv4="$1 sed -i '\$aiface $interface inet6 static' /etc/network/interfaces; $1 sed -i '\$a\\\taddress $ip6Addr' /etc/network/interfaces; $1 sed -i '\$a\\\tnetmask $ip6Mask' /etc/network/interfaces; $1 sed -i '\$a\\\tgateway $ip6Gate' /etc/network/interfaces; $1 sed -i '\$a\\\tdns-nameservers $ip6DNS' /etc/network/interfaces; $1 sed -i '\$alabel 2002::/16' /etc/gai.conf; $1 sed -i '\$alabel 2001:0::/32' /etc/gai.conf;"
        [[ -n "$interface4" && -n "$interface6" && "$interface4" != "$interface6" ]] && SupportIPv6orIPv4="$1 sed -i '\$a\ ' /etc/network/interfaces; $1 sed -i '\$aallow-hotplug $interface6' /etc/network/interfaces; $1 sed -i '\$aiface $interface6 inet6 static' /etc/network/interfaces; $1 sed -i '\$a\\\taddress $ip6Addr' /etc/network/interfaces; $1 sed -i '\$a\\\tnetmask $ip6Mask' /etc/network/interfaces; $1 sed -i '\$a\\\tgateway $ip6Gate' /etc/network/interfaces; $1 sed -i '\$a\\\tdns-nameservers $ip6DNS' /etc/network/interfaces; $1 sed -i '\$alabel 2002::/16' /etc/gai.conf; $1 sed -i '\$alabel 2001:0::/32' /etc/gai.conf;"
        ReplaceActualIpPrefix="$1 sed -ri \"s/address $ipAddr\/$ipPrefix/address $ipAddr\/$actualIp4Prefix/g\" /etc/network/interfaces; $1 sed -ri \"s/netmask $ip6Mask/netmask $actualIp6Prefix/g\" /etc/network/interfaces;"
      fi
    elif [[ "$IPStackType" == "IPv6Stack" ]]; then
# This IPv6Stack Static machine can access IPv4 network in the future, maybe.
# But it should be setting as IPv6 network priority.
      [[ ! "$IPv4" || "$Network6Config" == "isStatic" ]] && SupportIPv6orIPv4="$1 sed -i '\$aiface $interface inet dhcp' /etc/network/interfaces; $1 sed -i '\$alabel 2002::/16' /etc/gai.conf; $1 sed -i '\$alabel 2001:0::/32' /etc/gai.conf;" || SupportIPv6orIPv4="$1 sed -i '\$alabel 2002::/16' /etc/gai.conf; $1 sed -i '\$alabel 2001:0::/32' /etc/gai.conf;"
      ReplaceActualIpPrefix="$1 sed -ri \"s/address $ip6Addr\/$ip6Mask/address $ip6Addr\/$actualIp6Prefix/g\" /etc/network/interfaces;"
    fi
# a typical network configuration sample of IPv6 static for Debian:
# iface eth0 inet static
#         address 10.0.0.72
#         netmask 255.255.255.0
#         gateway 10.0.0.1
#         dns-nameservers 1.0.0.1 8.4.4.8
#
# a typical network configuration sample of IPv6 static for Debian:
# iface eth0 inet6 static
#         address 2702:b43c:492a:9d1e:8270:fd59:6de4:20f1
#         netmask 128
#         gateway fe80::200:17ff:fe9e:f9d0
#         dns-nameservers 2606:4700:4700::1001 2001:4860:4860::8844
    [[ "$linux_relese" == 'kali' ]] && {
      ChangeBashrc=""
# Enable Kali ssh service.
      EnableSSH="$1 update-rc.d ssh enable; $1 /etc/init.d/ssh restart;"
# Revise terms of license from "Debian" to "Kali" in motd file of "00-header".
      ReviseMOTD="$1 sed -ri 's/Debian/Kali/g' /etc/update-motd.d/00-header;"
      SupportZSH="$1 apt install zsh -y; $1 chsh -s /bin/zsh; $1 rm -rf /root/.bashrc.original;"
    }
# Fail2ban configurations.
# Reference: https://github.com/fail2ban/fail2ban/issues/2756
#            https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1879390.html
    EnableFail2ban="$1 sed -i '/\[Definition\]/a allowipv6 = auto' /etc/fail2ban/fail2ban.conf; $1 sed -ri 's/backend.*/backend = systemd/g' /etc/fail2ban/jail.conf; $1 update-rc.d fail2ban enable; $1 /etc/init.d/fail2ban restart;"
    export DebianModifiedProcession="${AptUpdating} ${InstallComponents} ${DisableCertExpiredCheck} ${ChangeBashrc} ${VimSupportCopy} ${VimIndentEolStart} ${DnsChangePermanently} ${ModifyMOTD} ${AutoPlugInterfaces} ${SupportIPv6orIPv4} ${ReplaceActualIpPrefix} ${EnableSSH} ${ReviseMOTD} ${SupportZSH} ${EnableFail2ban}"
  fi
}

function DebianPreseedProcess() {
  if [[ "$setAutoConfig" == "1" ]]; then
# Default to make a GPT partition to support 3TB hard drive or larger.
# To remove LVM VGM PVM force automatically:
# https://serverfault.com/questions/571363/unable-to-automatically-remove-lvm-data
# To part all disks:
# https://unix.stackexchange.com/questions/341253/using-d-i-partman-recipe-strings
    if [[ "$setDisk" == "all" ]]; then
      FormatDisk=`echo -e "d-i partman-auto/disk string $AllDisks\nd-i partman-auto/method string regular\nd-i partman-auto/init_automatically_partition select Guided - use entire disk\nd-i partman-auto/choose_recipe select All files in one partition (recommended for new users)\nd-i partman-basicfilesystems/choose_label string gpt\nd-i partman-basicfilesystems/default_label string gpt\nd-i partman-partitioning/choose_label string gpt\nd-i partman-partitioning/default_label string gpt\nd-i partman/choose_label string gpt\nd-i partman/default_label string gpt"`
    else
      FormatDisk=`echo -e "d-i partman-auto/disk string $IncDisk\nd-i partman-auto/method string regular\nd-i partman-auto/init_automatically_partition select Guided - use entire disk\nd-i partman-auto/choose_recipe select All files in one partition (recommended for new users)\nd-i partman-basicfilesystems/choose_label string gpt\nd-i partman-basicfilesystems/default_label string gpt\nd-i partman-partitioning/choose_label string gpt\nd-i partman-partitioning/default_label string gpt\nd-i partman/choose_label string gpt\nd-i partman/default_label string gpt"`
    fi
# Default single disk format recipe:
# d-i partman-auto/disk string $AllDisks/$IncDisk
# d-i partman-auto/method string regular
# d-i partman-auto/init_automatically_partition select Guided - use entire disk
# d-i partman-auto/choose_recipe select All files in one partition (recommended for new users)
# d-i partman-basicfilesystems/choose_label string gpt
# d-i partman-basicfilesystems/default_label string gpt
# d-i partman-partitioning/choose_label string gpt
# d-i partman-partitioning/default_label string gpt
# d-i partman/choose_label string gpt
# d-i partman/default_label string gpt
    [[ -n "$setRaid" ]] && {
# Soft Raid 0, 1, 5, 6 and 10 methods are supported by Debian, only one disk can't be as a component for any Raid method. 
# Raid 0 needs at least two disks, all space of the disks will be exploited, and it's the most dangerous for the safety of the data.
# Raid 1 needs at least two disks, the space can be exploited is always equal one disk, it's safest for the date but a bit wasteful.
# Raid 5 needs at least three disks, it storages data on two disks and storages parity checking data on one disk, it's not save on any single disk over 4TB.
# Raid 6 needs at least four disks, it's an enhanced version of Raid 5, it uses two parity stripes by practicing of dividing data across the set of drives, 
# it allows for two disk failures within the RAID set before any data is lost.
# Raid 10 needs at least four disks, it's a combination of Raid 0 and Raid 1, the disk 0 and disk 1 as a set of Raid 0, the same as disk 2 and disk 3,
# and then the sets of disk 0,1 and disk 2,3 are composed as one Raid 1.
# These Raid recipes are also applicable to Kali, fuck Canonical again! you deperated the compatibility of "preseed.cfg" installation procession from Ubuntu 22.04 and later.
      if [[ "$setRaid" == "0" || "$setRaid" == "1" || "$setRaid" == "5" || "$setRaid" == "6" || "$setRaid" == "10" ]]; then
        [[ "$setRaid" == "0" || "$setRaid" == "1" ]] && [[ "$disksNum" -lt "2" ]] && {
          echo -ne "\n[${red}Error${plain}] There are $disksNum drives on your machine, Raid $setRaid partition recipe only supports a basic set of dual drive or more!\n"
          exit 1
        }
        [[ "$setRaid" == "5" ]] && [[ "$disksNum" -lt "3" ]] && {
          echo -ne "\n[${red}Error${plain}] There are $disksNum drives on your machine, Raid $setRaid partition recipe only supports a basic set of triple drive or more!\n"
          exit 1
        }
        [[ "$setRaid" == "6" || "$setRaid" == "10" ]] && [[ "$disksNum" -lt "4" ]] && {
          echo -ne "\n[${red}Error${plain}] There are $disksNum drives on your machine, Raid $setRaid partition recipe only supports a basic set of quad drive or more!\n"
          exit 1
        }
        for (( r=1;r<="$disksNum";r++ )); do
          tmpAllDisksPart=`echo "$AllDisks" | cut -d ' ' -f"$r"`
# Some NVME controller hard drives like "/dev/nvme0n1" etc are end of a number in there names must add "p" with partition numbers for "d-i partman-auto-raid/recipe string",
# SCSI controller or Virtual controller drives like "/dev/sda" or "/dev/vda" are not effected by this situation.
# Drives and their partitions must be connected with "#" like "/dev/nvme0n1p2#/dev/nvme0n2p2".
          echo "${tmpAllDisksPart: -1}" | [[ -n "`sed -n '/^[0-9][0-9]*$/p'`" ]] && tmpAllDisksPart="$tmpAllDisksPart""p" || tmpAllDisksPart="$tmpAllDisksPart"
          AllDisksPart1+="$tmpAllDisksPart""1#"
          AllDisksPart2+="$tmpAllDisksPart""2#"
          AllDisksPart3+="$tmpAllDisksPart""3#"
        done
        AllDisksPart1=`echo "$AllDisksPart1" | sed 's/.$//'`
        AllDisksPart2=`echo "$AllDisksPart2" | sed 's/.$//'`
        AllDisksPart3=`echo "$AllDisksPart3" | sed 's/.$//'`
# Raid recipe should include GPT table partition by force for not only UEFI but also BIOS servers to ensure any drive that above 4TB size can be taken advantage of all spaces.
        RaidRecipes=`echo -e "d-i partman-md/confirm boolean true
d-i partman-md/confirm_nooverwrite boolean true
d-i partman-md/confirm_nochanges boolean false
d-i partman-basicfilesystems/no_swap boolean false
d-i partman-partitioning/choose_label select gpt
d-i partman-partitioning/default_label string gpt
d-i partman-auto/method string raid
d-i partman-auto/disk string $AllDisks
d-i mdadm/boot_degraded boolean true"`
# In environment of UEFI firmware motherboard computers, it's not suggested to creat any Raid recipe for "/boot/efi" partition,
# in any virtual machine which created by VMware Workstation Pro, version up to the current 17.0.2(2023/6), host OS is Windows 10 Enterprise x64,
# we must assign an additional Raid 1 recipe for "/boot" partition to prevent the case of following to happen：
# otherwise except of the first reboot of the Debian 12 installed soon, the next time hard reboot the system, it will failed into "GNU GRUB version 2.0x"
# and we must type "exit" to fallback to "Boot Manager", select and enter the default opinion of "Boot normally" and then find that Debian can be booted by grub.
# This is a particularly fatal for those servers which has no permission to access VNC in website back-end management and impossible to manipulate UEFI boot manager to boot the system normally.
        if [[ "$EfiSupport" == "enabled" ]]; then
          FormatDisk=`echo -e "$RaidRecipes
d-i partman-auto-raid/recipe string                  \
    1        $disksNum 0 ext4 /boot $AllDisksPart2 . \
    $setRaid $disksNum 0 ext4 /     $AllDisksPart3 .
d-i partman-auto/expert_recipe string multiraid ::                                                               \
    538 100 1075 free \\$bootable{ } \\$primary{ } method{ efi } \\$iflabel{ gpt } \\$reusemethod{ } format{ } . \
    269 150 538  raid                \\$primary{ } method{ raid } .                                              \
    100 200 -1   raid                \\$primary{ } method{ raid } .
d-i partman-efi/non_efi_system boolean true"`
        else
          FormatDisk=`echo -e "$RaidRecipes
d-i partman-auto-raid/recipe string                  \
    1        $disksNum 0 ext4 /boot $AllDisksPart1 . \
    $setRaid $disksNum 0 ext4 /     $AllDisksPart2 .
d-i partman-auto/expert_recipe string multiraid ::                  \
    538 100 1075 raid \\$bootable{ } \\$primary{ } method{ raid } . \
    100 200 -1   raid                \\$primary{ } method{ raid } .
"`
        fi
      else
        echo -ne "\n[${red}Error${plain}] Raid $setRaid partition recipe is not suitable, only Raid 0, 1, 5, 6 or 10 is supported!\n"
        exit 1
      fi
    }
# Reference: https://github.com/airium/Linux-Reinstall/blob/master/install-raid0.sh
#            https://www.debian.org/releases/bookworm/example-preseed.txt
#            https://www.cnblogs.com/zhangshan-log/articles/14542166.html
#            https://gist.github.com/jnerius/6573343
#            https://gist.github.com/bearice/331a954d86d890d9dbeacdd7de3aabe8
#            https://lala.im/7911.html
#            https://github.com/office-itou/Linux/blob/master/installer/source/preseed_debian.cfg
#
# Prefer to use IPv4 to config networking.
    if [[ "$IPStackType" == "IPv4Stack" ]] || [[ "$IPStackType" == "BiStack" ]]; then
      [[ "$Network4Config" == "isStatic" ]] && NetConfigManually=`echo -e "d-i netcfg/disable_autoconfig boolean true\nd-i netcfg/dhcp_failed note\nd-i netcfg/dhcp_options select Configure network manually\nd-i netcfg/get_ipaddress string $IPv4\nd-i netcfg/get_netmask string $MASK\nd-i netcfg/get_gateway string $GATE\nd-i netcfg/get_nameservers string $ipDNS\nd-i netcfg/no_default_route boolean true\nd-i netcfg/confirm_static boolean true"` || NetConfigManually=""
    elif [[ "$IPStackType" == "IPv6Stack" ]]; then
      [[ "$Network6Config" == "isStatic" ]] && NetConfigManually=`echo -e "d-i netcfg/disable_autoconfig boolean true\nd-i netcfg/dhcp_failed note\nd-i netcfg/dhcp_options select Configure network manually\nd-i netcfg/get_ipaddress string $ip6Addr\nd-i netcfg/get_netmask string $ip6Subnet\nd-i netcfg/get_gateway string $ip6Gate\nd-i netcfg/get_nameservers string $ip6DNS\nd-i netcfg/no_default_route boolean true\nd-i netcfg/confirm_static boolean true"` || NetConfigManually=""
    fi
# Debian installer can only identify the full IPv6 address of IPv6 mask,
# so we need to covert IPv6 prefix shortening from "0-128" to whole IPv6 address.
# The result of "$ip6Subnet" is calculated by function "ipv6SubnetCalc".
# 
# Manually network setting configurations, including:
# d-i netcfg/disable_autoconfig boolean true
# d-i netcfg/dhcp_failed note
# d-i netcfg/dhcp_options select Configure network manually
# d-i netcfg/get_ipaddress string $IPv4/$ip6Addr
# d-i netcfg/get_netmask string $MASK/$ip6Subnet
# d-i netcfg/get_gateway string $GATE/$ip6Gate
# d-i netcfg/get_nameservers string $ipDNS/$ip6DNS
# d-i netcfg/no_default_route boolean true
# d-i netcfg/confirm_static boolean true
    DebianModifiedPreseed "in-target"
    cat >/tmp/boot/preseed.cfg<<EOF
### Unattended Installation
d-i auto-install/enable boolean true
d-i debconf/priority select critical

### Localization
d-i debian-installer/locale string en_US.UTF-8
d-i debian-installer/country string US
d-i debian-installer/language string en
d-i debian-installer/allow_unauthenticated boolean true
d-i console-setup/layoutcode string us
d-i keyboard-configuration/xkb-keymap string us

### Low memory mode
d-i lowmem/low boolean true

### Disable security, updates and backports
d-i apt-setup/services-select multiselect

### Disable source repositories
d-i apt-setup/enable-source-repositories boolean false

### Enable contrib and non-free
d-i apt-setup/non-free boolean true
d-i apt-setup/contrib boolean true

### Disable CD-rom automatic scan
d-i apt-setup/cdrom/set-first boolean false
d-i apt-setup/cdrom/set-next boolean false
d-i apt-setup/cdrom/set-failed boolean false

### Network configuration
d-i netcfg/choose_interface select $interfaceSelect
${NetConfigManually}
d-i hw-detect/load_firmware boolean true

### Mirror settings
d-i mirror/country string manual
d-i mirror/http/hostname string $MirrorHost
d-i mirror/http/directory string $MirrorFolder
d-i mirror/http/proxy string

### Account setup
d-i passwd/root-login boolean ture
d-i passwd/make-user boolean false
d-i passwd/root-password-crypted password $myPASSWORD
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false

### Clock and time zone setup
d-i clock-setup/utc boolean true
d-i time/zone string ${TimeZone}
d-i clock-setup/ntp boolean true
d-i clock-setup/ntp-server string ntp.nict.jp

### Get harddisk name and Windows DD installation set up
d-i preseed/early_command string anna-install libc6-udeb libfuse3-3-udeb fuse3-udeb ntfs-3g-udeb libcrypto3-udeb libpcre2-8-0-udeb libssl3-udeb libuuid1-udeb zlib1g-udeb wget-udeb
d-i partman/early_command string \
lvremove --select all -ff -y; \
vgremove --select all -ff -y; \
pvremove /dev/* -ff -y; \
[[ -n "\$(blkid -t TYPE='vfat' -o device)" ]] && umount "\$(blkid -t TYPE='vfat' -o device)"; \
debconf-set partman-auto/disk "\$(list-devices disk | grep ${IncDisk} | head -n 1)"; \
wget -qO- '$DDURL' | $DEC_CMD | /bin/dd of=\$(list-devices disk | grep ${IncDisk} | head -n 1); \
/bin/ntfs-3g \$(list-devices partition | grep ${IncDisk} | head -n 1) /mnt; \
cd '/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs'; \
cd Start* || cd start*; \
cp -f '/net.bat' './net.bat'; \
/sbin/reboot; \
umount /media || true; \

### Partitioning
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/device_remove_lvm_span boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman/default_filesystem string xfs
d-i partman-md/device_remove_md boolean true
d-i partman/mount_style select uuid
${FormatDisk}

### Package selection
tasksel tasksel/first multiselect minimal
d-i pkgsel/include string openssh-server

# Automatic updates are not applied, everything is updated manually.
d-i pkgsel/update-policy select none
d-i pkgsel/upgrade select none

### Disable to upload developer statistics anonymously
popularity-contest popularity-contest/participate boolean false

### Grub
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i grub-installer/bootdev string ${IncDisk}
d-i grub-installer/force-efi-extra-removable boolean true
d-i debian-installer/add-kernel-opts string net.ifnames=0 biosdevname=0 ipv6.disable=1

### Shutdown machine
d-i finish-install/reboot_in_progress note
d-i debian-installer/exit/reboot boolean true

### Write preseed
d-i preseed/late_command string	\
sed -ri 's/^#?Port.*/Port ${sshPORT}/g' /target/etc/ssh/sshd_config; \
sed -ri 's/^#?PermitRootLogin.*/PermitRootLogin yes/g' /target/etc/ssh/sshd_config; \
sed -ri 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config; \
echo '@reboot root cat /etc/run.sh 2>/dev/null |base64 -d >/tmp/run.sh; rm -rf /etc/run.sh; sed -i /^@reboot/d /etc/crontab; bash /tmp/run.sh' >>/target/etc/crontab; \
echo '' >>/target/etc/crontab; \
echo '${setCMD}' >/target/etc/run.sh; \
${DebianModifiedProcession}
EOF
  fi
}

alpineInstallOrDdAdditionalFiles() {
  AlpineInitFile="$1"
  AlpineDnsFile="$2"
  AlpineMotd="$3"
  AlpineInitFileName="alpineConf.start"
  if [[ "$targetRelese" == 'Ubuntu' ]]; then
    if [[ "$ubuntuVER" == "amd64" ]]; then
      targetLinuxMirror="$4"
    elif [[ "$ubuntuVER" == "arm64" ]]; then
      targetLinuxMirror="$5"
    fi
    AlpineInitFile="$6"
    AlpineInitFileName="ubuntuConf.start"
    [[ "$setIPv6" == "0" ]] && setIPv6="0" || setIPv6="1"
  elif [[ "$targetRelese" == 'Windows' ]]; then
    AlpineInitFile="$7"
    AlpineInitFileName="windowsConf.start"
    windowsStaticConfigCmd="$8"
  fi
}

checkSys

# Get the name of network adapter($interface).
# [[ -z "$interface" ]] && interface=`getInterface "$CurrentOS"
# Try to enable IPv4 by DHCP
# timeout 5 dhclient -4 $interface
# Try to enable IPv6 by DHCP
# timeout 5 dhclient -6 $interface

# IPv4 and IPv6 DNS check servers from OpenDNS, Quad9, Verisign and TWNIC.
checkIpv4OrIpv6 "$ipAddr" "$ip6Addr" "208.67.220.220" "9.9.9.9" "64.6.65.6" "101.102.103.104" "2620:0:ccc::2" "2620:fe::9" "2620:74:1b::1:1" "2001:de4::101"

# Youtube, Instagram and Wikipedia all have public IPv4 and IPv6 address and are also banned in mainland of China.
checkCN "www.youtube.com" "www.instagram.com" "www.wikipedia.org" "$IPStackType"

checkEfi "/sys/firmware/efi/efivars/" "/sys/firmware/efi/vars/" "/sys/firmware/efi/runtime-map/" "/sys/firmware/efi/mok-variables/"

checkVirt

if [[ "$sshPORT" ]];then
  if [[ ! ${sshPORT} -ge "1" ]] || [[ ! ${sshPORT} -le "65535" ]] || [[ `grep '^[[:digit:]]*$' <<< '${sshPORT}'` ]]; then
    sshPORT='22'
  fi
else
  sshPORT=$(grep -Ei "^port|^#port" /etc/ssh/sshd_config | head -n 1 | awk -F' ' '{print $2}')
  [[ "$sshPORT" == "" ]] && sshPORT=$(netstat -anp | grep -i 'sshd: root' | grep -iw 'tcp' | awk '{print $4}' | head -n 1 | cut -d':' -f'2')
  [[ "$sshPORT" == "" ]] && sshPORT=$(netstat -anp | grep -i 'sshd: root' | grep -iw 'tcp6' | awk '{print $4}' | head -n 1 | awk -F':' '{print $NF}')
  if [[ "$sshPORT" == "" ]] || [[ ! ${sshPORT} -ge "1" ]] || [[ ! ${sshPORT} -le "65535" ]] || [[ `grep '^[[:digit:]]*$' <<< '${sshPORT}'` ]]; then
    sshPORT='22'
  fi
fi

# Disable SELinux
[[ -f /etc/selinux/config ]] && {
  SELinuxStatus=$(sestatus -v | grep "SELinux status:" | grep enabled)
  [[ "$SELinuxStatus" != "" ]] && echo -ne "\n${aoiBlue}# Disabled SELinux${plain}" && setenforce 0
}

[[ ! -d "/tmp/" ]] && mkdir /tmp

if [[ "$loaderMode" == "0" ]]; then
  checkGrub "/boot/grub/" "/boot/grub2/" "/etc/" "grub.cfg" "grub.conf" "/boot/efi/EFI/"
  if [[ -z "$GRUBTYPE" ]]; then
    echo -ne "\n[${red}Error${plain}] Not Found grub.\n"
    exit 1
  fi
fi

[ -n "$Relese" ] || Relese='Debian'

[[ "$ddMode" == '1' ]] && {
  if [[ "$targetRelese" == 'Ubuntu' ]] || [[ "$targetRelese" == 'Windows' ]]; then
    Relese='AlpineLinux'
    tmpDIST='edge'
    if [[ "$targetRelese" == 'Windows' ]]; then
      [[ "$VER" == "aarch64" || "$VER" == "arm64" ]] && {
        echo -ne "\n[${red}Error${plain}] ${targetRelese} doesn't support ${VER} architecture.\n"
        exit 1
      }
    fi
  else
    linux_relese='debian'
    tmpDIST='bookworm'
  fi
}

linux_relese=$(echo "$Relese" |sed 's/\ //g' |sed -r 's/(.*)/\L\1/')
clear && echo -ne "\n${aoiBlue}# Check Dependence${plain}\n\n"

dependence awk,basename,cat,cpio,curl,cut,dig,dirname,file,find,grep,gzip,iconv,ip,lsblk,openssl,sed,wget,xz;

ipDNS1=$(echo $ipDNS | cut -d ' ' -f 1)
ipDNS2=$(echo $ipDNS | cut -d ' ' -f 2)
ip6DNS1=$(echo $ip6DNS | cut -d ' ' -f 1)
ip6DNS2=$(echo $ip6DNS | cut -d ' ' -f 2)
ipDNS=$(checkDNS "$ipDNS")
ip6DNS=$(checkDNS "$ip6DNS")

if [ -z "$interface" ]; then
  [ -n "$interface" ] || interface=`getInterface "$CurrentOS"`
fi

if [[ -n "$ipAddr" && -n "$ipMask" && -n "$ipGate" ]] && [[ -z "$ip6Addr" && -z "$ip6Mask" && -z "$ip6Gate" ]]; then
  setNet='1'
  checkDHCP "$CurrentOS" "$CurrentOSVer" "$IPStackType"
  [[ -n "$interface" ]] || interface=`getInterface "$CurrentOS"`
  acceptIPv4AndIPv6SubnetValue "$ipMask" ""
  Network4Config="isStatic"
  [[ "$IPStackType" != "IPv4Stack" ]] && getIPv6Address
elif [[ -n "$ipAddr" && -n "$ipMask" && -n "$ipGate" ]] && [[ -n "$ip6Addr" && -n "$ip6Mask" && -n "$ip6Gate" ]]; then
  setNet='1'
  [[ -n "$interface" ]] || interface=`getInterface "$CurrentOS"`
  acceptIPv4AndIPv6SubnetValue "$ipMask" "$ip6Mask"
  Network4Config="isStatic"
  Network6Config="isStatic"
elif [[ -z "$ipAddr" && -z "$ipMask" && -z "$ipGate" ]] && [[ -n "$ip6Addr" && -n "$ip6Mask" && -n "$ip6Gate" ]]; then
  setNet='1'
  checkDHCP "$CurrentOS" "$CurrentOSVer" "$IPStackType"
  [[ -n "$interface" ]] || interface=`getInterface "$CurrentOS"`
  acceptIPv4AndIPv6SubnetValue "" "$ip6Mask"
  Network6Config="isStatic"
  getIPv4Address
fi

if [[ "$setNet" == "0" ]]; then
  checkDHCP "$CurrentOS" "$CurrentOSVer" "$IPStackType"
  [[ -n "$interface" ]] || interface=`getInterface "$CurrentOS"`
  getIPv4Address
  [[ "$IPStackType" != "IPv4Stack" ]] && getIPv6Address
fi

checkWarp "warp*.conf" "wgcf*.conf" "wg[0-9].conf" "warp*" "wgcf*" "wg[0-9]" "privatekey" "publickey"

IPv4="$ipAddr"; MASK="$ipMask"; GATE="$ipGate";
if [[ -z "$IPv4" && -z "$MASK" && -z "$GATE" ]] && [[ -z "$ip6Addr" && -z "$ip6Mask" && -z "$ip6Gate" ]]; then
  echo -ne "\n[${red}Error${plain}] The network of your machine may not be available!\n"
  bash $0 error
  exit 1
fi

echo -ne "\n${aoiBlue}# Network Details${plain}\n"
echo -ne "\n[${yellow}Adapter Name${plain}]  $interface"
echo -ne "\n[${yellow}Network File${plain}]  $NetCfgWhole"
echo -ne "\n[${yellow}Server Stack${plain}]  $IPStackType\n"
[[ "$IPStackType" != "IPv6Stack" ]] && echo -ne "\n[${yellow}IPv4  Method${plain}]  $Network4Config\n" || echo -ne "\n[${yellow}IPv4  Method${plain}]  N/A\n"
[[ "$IPv4" && "$IPStackType" != "IPv6Stack" ]] && echo -e "[${yellow}IPv4 Address${plain}]  ""$IPv4" || echo -e "[${yellow}IPv4 Address${plain}]  ""N/A"
[[ "$IPv4" && "$IPStackType" != "IPv6Stack" ]] && echo -e "[${yellow}IPv4  Subnet${plain}]  ""$actualIp4Subnet" || echo -e "[${yellow}IPv4  Subnet${plain}]  ""N/A"
[[ "$IPv4" && "$IPStackType" != "IPv6Stack" ]] && echo -e "[${yellow}IPv4 Gateway${plain}]  ""$GATE" || echo -e "[${yellow}IPv4 Gateway${plain}]  ""N/A"
[[ "$IPv4" && "$IPStackType" != "IPv6Stack" ]] && echo -e "[${yellow}IPv4     DNS${plain}]  ""$ipDNS" || echo -e "[${yellow}IPv4     DNS${plain}]  ""N/A"
[[ "$IPStackType" != "IPv4Stack" ]] && echo -ne "\n[${yellow}IPv6  Method${plain}]  $Network6Config\n" || echo -ne "\n[${yellow}IPv6  Method${plain}]  N/A\n"
[[ "$ip6Addr" && "$IPStackType" != "IPv4Stack" ]] && echo -e "[${yellow}IPv6 Address${plain}]  ""$ip6Addr" || echo -e "[${yellow}IPv6 Address${plain}]  ""N/A"
[[ "$ip6Addr" && "$IPStackType" != "IPv4Stack" ]] && echo -e "[${yellow}IPv6  Subnet${plain}]  ""$actualIp6Prefix" || echo -e "[${yellow}IPv6  Subnet${plain}]  ""N/A"
[[ "$ip6Addr" && "$IPStackType" != "IPv4Stack" ]] && echo -e "[${yellow}IPv6 Gateway${plain}]  ""$ip6Gate" || echo -e "[${yellow}IPv6 Gateway${plain}]  ""N/A"
[[ "$ip6Addr" && "$IPStackType" != "IPv4Stack" ]] && echo -e "[${yellow}IPv6     DNS${plain}]  ""$ip6DNS" || echo -e "[${yellow}IPv6     DNS${plain}]  ""N/A"

getUserTimeZone "/root/timezonelists" "ZGEyMGNhYjhhMWM2NDJlMGE0YmZhMDVmMDZlNzBmN2E=" "ZTNlMjBiN2JjOTE2NGY2YjllNzUzYWU5ZDFjYjdjOTc=" "MWQ2NGViMGQ4ZmNlNGMzYTkxYjNiMTdmZDMxODQwZDc="
[[ -z "$TimeZone" ]] && TimeZone="Asia/Tokyo"
echo -ne "\n${aoiBlue}# User Timezone${plain}\n\n"
echo "$TimeZone"

[[ -z "$tmpWORD" || "$linux_relese" == 'alpinelinux' || "$targetRelese" == 'Ubuntu' ]] && tmpWORD='LeitboGi0ro'
myPASSWORD=$(openssl passwd -1 ''$tmpWORD'')
[[ -z "$myPASSWORD" ]] && myPASSWORD='$1$OCy2O5bt$m2N6XMgFUwCn/2PPP114J/'
echo -ne "\n${aoiBlue}# SSH or RDP Port, Username and Password${plain}\n\n"
[[ "$targetRelese" == 'Windows' ]] && echo "3389" || echo "$sshPORT"
[[ "$targetRelese" == 'Windows' ]] && echo "Administrator" || echo "root"
[[ "$targetRelese" == 'Windows' && "$tmpURL" == "" || "$tmpURL" =~ "dl.lamp.sh" ]] && echo "Teddysun.com" || echo "$tmpWORD"

getDisk
echo -ne "\n${aoiBlue}# Installing Disks${plain}\n\n"
[[ "$setDisk" == "all" || "$setRaid" == "0" || "$setRaid" == "1" || "$setRaid" == "5" || "$setRaid" == "6" || "$setRaid" == "10" ]] && echo "$AllDisks" || echo "$IncDisk"

echo -ne "\n${aoiBlue}# Motherboard Firmware${plain}\n\n"
[[ "$EfiSupport" == "enabled" ]] && echo "UEFI" || echo "BIOS"

[ -n "$Relese" ] || Relese='Debian'
linux_relese=$(echo "$Relese" |sed 's/\ //g' |sed -r 's/(.*)/\L\1/')

# Get architecture of current os automatically
ArchName=`uname -m`
[[ -z "$ArchName" ]] && ArchName=$(echo `hostnamectl status | grep "Architecture" | cut -d':' -f 2`)
case $ArchName in arm64) VER="arm64";; aarch64) VER="aarch64";; x86|i386|i686) VER="i386";; x86_64) VER="x86_64";; x86-64) VER="x86-64";; amd64) VER="amd64";; *) VER="";; esac
# Exchange architecture name
if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]] || [[ "$linux_relese" == 'kali' ]]; then
# In debian 12, the result of "uname -m" is "x86_64";
# the result of "echo `hostnamectl status | grep "Architecture" | cut -d':' -f 2`" is "x86-64"
  if [[ "$VER" == "x86_64" ]] || [[ "$VER" == "x86-64" ]]; then
    VER="amd64"
  elif [[ "$VER" == "aarch64" ]]; then
    VER="arm64"
  fi
elif [[ "$linux_relese" == 'alpinelinux' ]] || [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
  if [[ "$VER" == "amd64" ]] || [[ "$VER" == "x86-64" ]]; then
    VER="x86_64"
  elif [[ "$VER" == "arm64" ]]; then
    VER="aarch64"
  fi
fi

# Check and exchange input architecture name
tmpVER="$(echo "$tmpVER" |sed -r 's/(.*)/\L\1/')"
if [[ -n "$tmpVER" ]]; then
  case "$tmpVER" in
    i386|i686|x86|32)
      VER="i386"
      ;;
    amd64|x86_64|x64|64)
      [[ "$linux_relese" == 'alpinelinux' ]] || [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]] && VER='x86_64' || VER='amd64'
      ;;
    aarch64|arm64|arm)
      [[ "$linux_relese" == 'alpinelinux' ]] || [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]] && VER='aarch64' || VER='arm64'
      ;;
    *)
      VER=''
      ;;
  esac
fi

[[ ! -n "$VER" ]] && {
  echo -ne "\n[${red}Error${plain}] Unknown architecture.\n"
  bash $0 error
  exit 1
}

[[ -z "$tmpDIST" ]] && {
  [ "$Relese" == 'Debian' ] && tmpDIST='12'
  [ "$Relese" == 'Kali' ] && tmpDIST='rolling'
  [ "$Relese" == 'AlpineLinux' ] && tmpDIST='edge'
  [ "$Relese" == 'CentOS' ] && tmpDIST='9'
  [ "$Relese" == 'RockyLinux' ] && tmpDIST='9'
  [ "$Relese" == 'AlmaLinux' ] && tmpDIST='9'
  [ "$Relese" == 'Fedora' ] && tmpDIST='38'
}
[[ -z "$finalDIST" ]] && {
  [ "$targetRelese" == 'Ubuntu' ] && finalDIST='22.04'
  [ "$targetRelese" == 'Windows' ] && finalDIST='server 2022'
}

if [[ -n "$tmpDIST" ]]; then
  if [[ "$Relese" == 'Debian' ]]; then
    SpikCheckDIST='0'
    DIST="$(echo "$tmpDIST" |sed -r 's/(.*)/\L\1/')"
    DebianDistNum="${DIST}"
    echo "$DIST" |grep -q '[0-9]'
    [[ $? -eq '0' ]] && {
      isDigital="$(echo "$DIST" |grep -o '[\.0-9]\{1,\}' |sed -n '1h;1!H;$g;s/\n//g;$p' |cut -d'.' -f1)";
      [[ -n $isDigital ]] && {
        [[ "$isDigital" == '7' ]] && DIST='wheezy'
        [[ "$isDigital" == '8' ]] && DIST='jessie'
        [[ "$isDigital" == '9' ]] && DIST='stretch'
        [[ "$isDigital" == '10' ]] && DIST='buster'
        [[ "$isDigital" == '11' ]] && DIST='bullseye'
        [[ "$isDigital" == '12' ]] && DIST='bookworm'
        [[ "$isDigital" == '13' ]] && DIST='trixie'
        # [[ "$isDigital" == '14' ]] && DIST='forky'
# Debian releases TBA reference: https://wiki.debian.org/DebianReleases
#                                https://en.wikipedia.org/wiki/Debian_version_history#Release_table
      }
    }
    LinuxMirror=$(selectMirror "$Relese" "$DIST" "$VER" "$tmpMirror")
  fi
  if [[ "$Relese" == 'Kali' ]]; then
    SpikCheckDIST='0'
    DIST="$(echo "$tmpDIST" |sed -r 's/(.*)/\L\1/')"
    [[ ! "$DIST" =~ "kali-" ]] && DIST="kali-""$DIST"
# Kali Linux releases reference: https://www.kali.org/releases/
    LinuxMirror=$(selectMirror "$Relese" "$DIST" "$VER" "$tmpMirror")
  fi
  if [[ "$Relese" == 'AlpineLinux' ]]; then
    SpikCheckDIST='0'
    DIST="$(echo "$tmpDIST" |sed -r 's/(.*)/\L\1/')"
# Recommend "edge" version of Alpine Linux to make sure to keep always updating.
    AlpineVer1=`echo "$DIST" | sed 's/[a-z][A-Z]*//g' | cut -d"." -f 1`
    AlpineVer2=`echo "$DIST" | sed 's/[a-z][A-Z]*//g' | cut -d"." -f 2`
    if [[ "$AlpineVer1" -lt "3" || "$AlpineVer2" -le "15" ]] && [[ "$DIST" != "edge" ]]; then
      echo -ne "\n[${red}Warning${plain}] $Relese $DIST is not supported!\n"
      exit 1
    fi
    [[ "$DIST" != "edge" && ! "$DIST" =~ "v" ]] && DIST="v""$DIST"
# Alpine Linux releases reference: https://alpinelinux.org/releases/
    LinuxMirror=$(selectMirror "$Relese" "$DIST" "$VER" "$tmpMirror")
  fi
  if [[ "$Relese" == 'CentOS' ]] || [[ "$Relese" == 'RockyLinux' ]] || [[ "$Relese" == 'AlmaLinux' ]] || [[ "$Relese" == 'Fedora' ]]; then
    SpikCheckDIST='1'
    DISTCheck="$(echo "$tmpDIST" |grep -o '[\.0-9]\{1,\}' |head -n1)"
    RedHatSeries=`echo "$tmpDIST" | cut -d"." -f 1 | cut -d"-" -f 1`
# CentOS and CentOS stream releases history:
# https://endoflife.date/centos
    if [[ "$linux_relese" == 'centos' ]]; then
      [[ "$RedHatSeries" =~ [0-9]{${#1}} ]] && {
        if [[ "$RedHatSeries" == "6" ]]; then
          DISTCheck="6.10"
          echo -ne "\n[${red}Warning${plain}] $Relese $DISTCheck is not supported!\n"
          exit 1
        elif [[ "$RedHatSeries" == "7" ]]; then
          DISTCheck="7.9.2009"
        elif [[ "$RedHatSeries" -ge "8" ]] && [[ ! "$RedHatSeries" =~ "-stream" ]]; then
          DISTCheck="$RedHatSeries""-stream"
        elif [[ "$RedHatSeries" -le "5" ]]; then
          echo -ne "\n[${red}Warning${plain}] $Relese $DISTCheck is not supported!\n"
        else
          echo -ne "\n[${red}Error${plain}] Invaild $DIST! version!\n"
        fi
      }
      LinuxMirror=$(selectMirror "$Relese" "$DISTCheck" "$VER" "$tmpMirror")
      DIST="$DISTCheck"
    fi
    if [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
      [[ "$RedHatSeries" =~ [0-9]{${#1}} ]] && {
# RockyLinux releases history:
# https://wiki.rockylinux.org/rocky/version/
# AlmaLinux releases history:
# https://wiki.almalinux.org/release-notes/
        if [[ "$linux_relese" == 'rockylinux' || "$linux_relese" == 'almalinux' ]] && [[ "$RedHatSeries" -le "7" ]]; then
          echo -ne "\n[${red}Warning${plain}] $Relese $DISTCheck is not supported!\n"
          exit 1
# Fedora releases history:
# https://en.wikipedia.org/wiki/Fedora_Linux_release_history
        elif [[ "$linux_relese" == 'fedora' ]] && [[ "$RedHatSeries" -le "36" ]]; then
          echo -ne "\n[${red}Warning${plain}] $Relese $DISTCheck is not supported!\n"
          exit 1
        fi
      }
      LinuxMirror=$(selectMirror "$Relese" "$DISTCheck" "$VER" "$tmpMirror")
      DIST="$DISTCheck"
    fi
    [[ -z "$DIST" ]] && {
      echo -ne '\nThe dists version not found in this mirror, Please check it! \n\n'
      bash $0 error
      exit 1
    }
    if [[ "$linux_relese" == 'centos' ]] && [[ "$RedHatSeries" -le "7" ]]; then
      wget --no-check-certificate -qO- "$LinuxMirror/$DIST/os/$VER/.treeinfo" | grep -q 'general'
      [[ $? != '0' ]] && {
        echo -ne "\n[${red}Warning${plain}] $Relese $DISTCheck was not found in this mirror, Please change mirror try again!\n"
        exit 1
      }
    elif [[ "$linux_relese" == 'centos' && "$RedHatSeries" -ge "8" ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]]; then
      wget --no-check-certificate -qO- "$LinuxMirror/$DIST/BaseOS/$VER/os/media.repo" | grep -q 'mediaid'
      [[ $? != '0' ]] && {
        echo -ne "\n[${red}Warning${plain}] $Relese $DISTCheck was not found in this mirror, Please change mirror try again!\n"
        exit 1
      }
    elif [[ "$linux_relese" == 'fedora' ]]; then
      wget --no-check-certificate -qO- "$LinuxMirror/releases/$DIST/Server/$VER/os/media.repo" | grep -q 'mediaid'
      [[ $? != '0' ]] && {
        echo -ne "\n[${red}Warning${plain}] $Relese $DISTCheck was not found in this mirror, Please change mirror try again!\n"
        exit 1
      }
    fi    
  fi
fi

[[ -z "$LinuxMirror" ]] && {
  echo -ne "\n[${red}Error${plain}] Invaild mirror! \n"
  [ "$Relese" == 'Debian' ] && echo -ne "${yellow}Please check mirror lists:${plain} https://www.debian.org/mirror/list\n\n"
  [ "$Relese" == 'Ubuntu' ] && echo -ne "${yellow}Please check mirror lists:${plain} https://launchpad.net/ubuntu/+archivemirrors\n\n"
  [ "$Relese" == 'Kali' ] && echo -ne "${yellow}Please check mirror lists:${plain} https://http.kali.org/README.mirrorlist\n\n"
  [ "$Relese" == 'AlpineLinux' ] && echo -ne "${yellow}Please check mirror lists:${plain} https://mirrors.alpinelinux.org/\n\n"
  [ "$Relese" == 'CentOS' ] && echo -ne "${yellow}Please check mirror lists:${plain} https://www.centos.org/download/mirrors/\n\n"
  [ "$Relese" == 'RockyLinux' ] && echo -ne "${yellow}Please check mirror lists:${plain} https://mirrors.rockylinux.org/mirrormanager/mirrors\n\n"
  [ "$Relese" == 'AlmaLinux' ] && echo -ne "${yellow}Please check mirror lists:${plain} https://mirrors.almalinux.org/\n\n"
  [ "$Relese" == 'Fedora' ] && echo -ne "${yellow}Please check mirror lists:${plain} https://mirrors.fedoraproject.org/\n\n"
  # bash $0 error
  exit 1
}

[[ "$setNetbootXyz" == "1" ]] && SpikCheckDIST="1"
if [[ "$SpikCheckDIST" == '0' ]]; then
  echo -ne "\n${aoiBlue}# Check DIST${plain}\n"
  DistsList="$(wget --no-check-certificate -qO- "$LinuxMirror/dists/" |grep -o 'href=.*/"' |cut -d'"' -f2 |sed '/-\|old\|Debian\|experimental\|stable\|test\|sid\|devel/d' |grep '^[^/]' |sed -n '1h;1!H;$g;s/\n//g;s/\//\;/g;$p')"
  [[ "$linux_relese" == 'kali' ]] && DistsList="$(wget --no-check-certificate -qO- "$LinuxMirror/dists/" | grep -o 'href=.*/"' | cut -d'"' -f2 | grep '^[^/]' | sed -n '1h;1!H;$g;s/\n//g;s/\//\;/g;$p')"
  [[ "$linux_relese" == 'alpinelinux' ]] && DistsList="$(wget --no-check-certificate -qO- "$LinuxMirror/" | grep -o 'href=.*/"' | cut -d'"' -f2 | grep '^[^/]' | sed -n '1h;1!H;$g;s/\n//g;s/\//\;/g;$p')"
  for CheckDEB in `echo "$DistsList" |sed 's/;/\n/g'`
    do
# In some mirror, the value of parameter "DistsList" is "?C=N;O=Dbookworm;bullseye;buster;http:;;wisepoint.jp;product;wpshibb;"
# The second item in "DistsList" which is splited by ";" is O=Dbookworm.
# So we need to check whether "DIST" is approximately equal(contains) to "CheckDEB".
      [[ "$CheckDEB" =~ "$DIST" ]] && FindDists='1' && break;
    done
  [[ "$FindDists" == '0' ]] && {
    echo -ne '\n[${red}Error${plain}] The dists version not found, Please check it! \n\n'
    exit 1
  }
  echo -e "\nSuccess"
fi

if [[ "$ddMode" == '1' ]]; then
  if [[ "$targetRelese" == 'Ubuntu' ]]; then
    ubuntuDIST="$(echo "$finalDIST" |sed -r 's/(.*)/\L\1/')"
    UbuntuDistNum=`echo "$ubuntuDIST" | cut -d'.' -f1`
    echo "$ubuntuDIST" |grep -q '[0-9]'
    [[ $? -eq '0' ]] && {
      ubuntuDigital="$(echo "$ubuntuDIST" |grep -o '[\.0-9]\{1,\}' |sed -n '1h;1!H;$g;s/\n//g;$p')"
      ubuntuDigital1=`echo "$ubuntuDigital" | cut -d'.' -f1`
      ubuntuDigital2=`echo "$ubuntuDigital" | cut -d'.' -f2`
      if [[ "$ubuntuDigital1" -le "19" || "$ubuntuDigital1" -ge "23" || $((${ubuntuDigital1} % 2)) = 1 ]] || [[ "$ubuntuDigital2" != "04" ]]; then
        echo -ne "\n[${red}Error${plain}] The dists version not found, Please check it! \n'"
        exit 1
      fi
      [[ -n $ubuntuDigital ]] && {
        # [[ "$ubuntuDigital" == '12.04' ]] && finalDIST='precise'
        # [[ "$ubuntuDigital" == '14.04' ]] && finalDIST='trusty'
        # [[ "$ubuntuDigital" == '16.04' ]] && finalDIST='xenial'
        # [[ "$ubuntuDigital" == '18.04' ]] && finalDIST='bionic'
        [[ "$ubuntuDigital" == '20.04' ]] && finalDIST='focal'
# Ubuntu 22.04 and future versions started to using "Cloud-init" to replace legacy "d-i(Debian installer)" which is designed to support network installation of Debian like system.
# "Cloud-init" make a high hardware requirements of the server, one requirement must be demanded is CPU virtualization support.
# Many vps which are virtualizated by a physical machine, despite parent machine support virtualization, but sub-servers don't support.
# Because Ubuntu 22.04 and future version removed critical file of "initrd.gz" and "linux" which are critical files to implement "d-i".
# For example, the official of Ubuntu 22.04(jammy) mirror site doesn't provide any related files to download, the following is here:
# http://archive.ubuntu.com/ubuntu/dists/jammy/main/installer-amd64/current/legacy-images/
# So we have no possibility to accomplish Ubuntu network installation in future.
# Canonical.inc is son of a bitch, they change back and forth, pood and pee everywhere.
# More discussions: https://discourse.ubuntu.com/t/netbooting-the-live-server-installer/14510/18
        [[ "$ubuntuDigital" == '22.04' ]] && finalDIST='jammy'
# Ubuntu releases reference: https://releases.ubuntu.com/
      }
    }
    if [[ "$VER" == "x86_64" ]] || [[ "$VER" == "x86-64" ]]; then
      ubuntuVER="amd64"
    elif [[ "$VER" == "aarch64" ]]; then
      ubuntuVER="arm64"
    fi
    if [[ "$tmpURL" == "" ]]; then
      tmpURL="https://cloud-images.a.disk.re/Ubuntu/"
    fi
    echo "$tmpURL" | grep -q '^http://\|^ftp://\|^https://'
    [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Please input a vaild URL, only support http://, ftp:// and https:// ! \n" && exit 1
    tmpURLCheck=$(echo $(curl -s -I -X GET $tmpURL) | grep -wi "http/[0-9]*" | awk '{print $2}')
    [[ -z "$tmpURLCheck" || ! "$tmpURLCheck" =~ ^[0-9]+$ ]] && {
      echo -ne "\n[${red}Error${plain}] The mirror of DD images is temporarily unavailable!\n"
      exit 1
    }
    DDURL="$tmpURL$finalDIST-server-cloudimg-$ubuntuVER.raw"
    ReleaseName="$targetRelese $finalDIST $ubuntuVER"
  elif [[ "$targetRelese" == 'Windows' ]]; then
    if [[ -z "$tmpURL" ]]; then
      tmpURL="https://dl.lamp.sh/vhd"
      [[ `echo "$finalDIST" | grep -i "server"` ]] && tmpFinalDIST=`echo $finalDIST | awk -F ' |-|_' '{print $2}'`
      [[ `echo "$finalDIST" | grep -i "pro"` || `echo "$finalDIST" | grep -i "ltsc"` ]] && tmpFinalDIST=`echo $finalDIST | awk -F ' |-|_' '{print $1}'`
      [[ "$finalDIST" =~ ^[0-9]+$ ]] && tmpFinalDIST="$finalDIST"
      if [[ "$tmpFinalDIST" -ge "2012" && "$tmpFinalDIST" -le "2019" ]]; then
        tmpTargetLang="$targetLang"
      else
        [[ "$targetLang" == 'cn' ]] && tmpTargetLang="zh-""$targetLang"
        [[ "$targetLang" == 'en' ]] && tmpTargetLang="$targetLang""-us"
        [[ "$targetLang" == 'ja' ]] && tmpTargetLang="ja-""$targetLang"
      fi
      if [[ "$tmpFinalDIST" == "2012" ]]; then
        tmpURL="$tmpURL/"${tmpTargetLang}"_win"${tmpFinalDIST}"r2.xz"
        showFinalDIST="Server $tmpFinalDIST R2"
      elif [[ "$tmpFinalDIST" -ge "2016" && "$tmpFinalDIST" -le "2022" ]]; then
        tmpURL="$tmpURL/"${tmpTargetLang}"_win"${tmpFinalDIST}".xz"
        showFinalDIST="Server $tmpFinalDIST"
      elif [[ "$tmpFinalDIST" -ge "10" && "$tmpFinalDIST" -le "11" ]]; then
        [[ "$tmpFinalDIST" == "10" ]] && { tmpURL="$tmpURL/"${tmpTargetLang}"_windows"${tmpFinalDIST}"_ltsc.xz"; showFinalDIST="$tmpFinalDIST Enterprise LTSC"; }
        [[ "$tmpFinalDIST" == "11" ]] && { tmpURL="$tmpURL/"${tmpTargetLang}"_windows"${tmpFinalDIST}"_22h2.xz"; showFinalDIST="$tmpFinalDIST Pro for Workstations 22H2"; }
      fi
      if [[ "$EfiSupport" == "enabled" ]]; then
        [[ "$tmpFinalDIST" == "10" ]] && tmpURL=`echo $tmpURL | sed 's/windows/win/g'`
        tmpURL=`echo $tmpURL | sed 's/...$/_uefi.xz/g'`
      fi
      ReleaseName="$targetRelese $showFinalDIST"
    else
      showFinalDIST=""
      ReleaseName="$targetRelese"
    fi
    echo "$tmpURL" | grep -q '^http://\|^ftp://\|^https://'
    [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Please input a vaild URL, only support http://, ftp:// and https:// ! \n" && exit 1
    tmpURLCheck=$(echo $(curl -s -I -X GET $tmpURL) | grep -wi "http/[0-9]*" | awk '{print $2}')
    [[ -z "$tmpURLCheck" || ! "$tmpURLCheck" =~ ^[0-9]+$ ]] && {
      echo -ne "\n[${red}Error${plain}] The mirror of DD images is temporarily unavailable!\n"
      exit 1
    }
    DDURL="$tmpURL"
    # Decompress command selection
    if [[ "$setFileType" == "gz" ]]; then
      DEC_CMD="gunzip -dc"
      [[ $(echo "$DDURL" | grep -o ...$) == ".xz" ]] && DEC_CMD="xzcat"
    elif [[ "$setFileType" == "xz" ]]; then
      DEC_CMD="xzcat"
      [[ $(echo "$DDURL" | grep -o ...$) == ".gz" ]] && DEC_CMD="gunzip -dc"
    else
      [[ $(echo "$DDURL" | grep -o ...$) == ".xz" ]] && DEC_CMD="xzcat"
      [[ $(echo "$DDURL" | grep -o ...$) == ".gz" ]] && DEC_CMD="gunzip -dc"
    fi
  elif [[ "$tmpURL" != "" ]]; then
    echo -ne "\n[${red}Warning${plain}] Please input a vaild image URL!\n"
    exit 1
  fi
fi

if [ -z "$interfaceSelect" ]; then
  if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]] || [[ "$linux_relese" == 'kali' ]]; then
    interfaceSelect="auto"
  elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
    interfaceSelect="link"
  fi
else
# If the kernel of original system is loaded with parameter "net.ifnames=0 biosdevname=0" and users don't want to set this
# one in new system, they have to assign a valid, real name of their network adapter and the parameter "$interface"
# will be written to new network configuration in preseed file for new system.
  interface4=`echo "$interfaceSelect" | cut -d' ' -f 1`
  interface6=`echo "$interfaceSelect" | cut -d' ' -f 2`
  interface="$interface4"
  [[ -z "$interface6" ]] && {
    interface=`echo "$interfaceSelect" | sed 's/[[:space:]]//g'`
    interface6="$interface"
  }
fi
# The first network adapter name is must be "eth0" if kernel is loaded with parameter "net.ifnames=0 biosdevname=0". 
[[ "$setInterfaceName" == "1" ]] && {
  interface="eth0"
  [[ -n "$interface4" && -n "$interface6" && "$interface4" != "$interface6" ]] && {
    interface4="eth0"
    interface6="eth1"
  }
}

echo -ne "\n${aoiBlue}# Installation Starting${plain}\n"

[[ "$ddMode" == '1' ]] && echo -ne "${blue}Auto Mode${plain} insatll [${yellow}$ReleaseName${plain}]\n$DDURL\n"

if [[ "$linux_relese" == 'centos' ]]; then
  if [[ "$DIST" != "$UNVER" ]]; then
    awk 'BEGIN{print '${UNVER}'-'${DIST}'}' |grep -q '^-'
    if [ $? != '0' ]; then
      UNKNOWHW='1'
      echo -ne "\nThe version lower than ${red}$UNVER${plain} may not support in auto mode!\n"
    fi
  fi
fi
[[ "$setNetbootXyz" == "0" ]] && echo -ne "\n[${yellow}$Relese${plain}] [${yellow}$DIST${plain}] [${yellow}$VER${plain}] Downloading...\n" || echo -ne "\n[${yellow}netboot.xyz${plain}] Downloading...\n"

# RAM of RedHat series is 2GB required at least.
[[ "$setNetbootXyz" == "0" ]] && {
  checkMem "$linux_relese" "$RedHatSeries" "$targetRelese"
  Add_OPTION="$Add_OPTION $lowmemLevel"
}

if [[ "$setNetbootXyz" == "1" ]]; then
  [[ "$VER" == "x86_64" || "$VER" == "amd64" ]] && apt install grub-imageboot -y
  if [[ "$EfiSupport" == "enabled" ]] || [[ "$VER" == "aarch64" || "$VER" == "arm64" ]]; then
    echo -ne "\n[${red}Error${plain}] Netbootxyz doesn't support $VER architecture!\n"
    bash $0 error
    exit 1
  fi
# NetbootXYZ set to boot from an existing Linux installation using GRUB
# Reference: https://netboot.xyz/docs/booting/grub
  if [[ "$IsCN" == "cn" ]]; then
    NetbootXyzUrl="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/RedHat/NetbootXyz/netboot.xyz.iso"
    NetbootXyzGrub="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/RedHat/NetbootXyz/60_grub-imageboot"
  else
    NetbootXyzUrl="https://boot.netboot.xyz/ipxe/netboot.xyz.iso"
    NetbootXyzGrub="https://raw.githubusercontent.com/formorer/grub-imageboot/master/bin/60_grub-imageboot"
  fi
  [[ ! -d "/boot/images/" ]] && mkdir /boot/images/
  rm -rf /boot/images/netboot.xyz.iso
  echo -ne "[${yellow}Mirror${plain}] $NetbootXyzUrl\n"
  wget --no-check-certificate -qO '/boot/images/netboot.xyz.iso' "$NetbootXyzUrl"
  [[ ! -f "/etc/grub.d/60_grub-imageboot" ]] && wget --no-check-certificate -qO '/etc/grub.d/60_grub-imageboot' "$NetbootXyzGrub"
  chmod 755 /etc/grub.d/60_grub-imageboot
  [[ ! -z "$GRUBTYPE" && "$GRUBTYPE" == "isGrub2" ]] && {
    rm -rf /boot/memdisk
    cp /usr/share/syslinux/memdisk /boot/memdisk
    ln -s /usr/share/grub/grub-mkconfig_lib /usr/lib/grub/grub-mkconfig_lib
  }
elif [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]] || [[ "$linux_relese" == 'kali' ]]; then
  [ "$DIST" == "focal" ] && legacy="legacy-" || legacy=""
  InitrdUrl="${LinuxMirror}/dists/${DIST}/main/installer-${VER}/current/${legacy}images/netboot/${linux_relese}-installer/${VER}/initrd.gz"
  VmLinuzUrl="${LinuxMirror}/dists/${DIST}${inUpdate}/main/installer-${VER}/current/${legacy}images/netboot/${linux_relese}-installer/${VER}/linux"
  [[ "$linux_relese" == 'kali' ]] && {
    InitrdUrl="${LinuxMirror}/dists/${DIST}/main/installer-${VER}/current/images/netboot/debian-installer/${VER}/initrd.gz"
    VmLinuzUrl="${LinuxMirror}/dists/${DIST}/main/installer-${VER}/current/images/netboot/debian-installer/${VER}/linux"
  }
  echo -ne "[${yellow}Mirror${plain}] $InitrdUrl\n\t $VmLinuzUrl\n"
  wget --no-check-certificate -qO '/tmp/initrd.img' "$InitrdUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'initrd.img' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
  wget --no-check-certificate -qO '/tmp/vmlinuz' "$VmLinuzUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'vmlinuz' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
  MirrorHost="$(echo "$LinuxMirror" |awk -F'://|/' '{print $2}')"
  MirrorFolder="$(echo "$LinuxMirror" |awk -F''${MirrorHost}'' '{print $2}')"
  [ -n "$MirrorFolder" ] || MirrorFolder="/"
elif [[ "$linux_relese" == 'alpinelinux' ]]; then
  InitrdUrl="${LinuxMirror}/${DIST}/releases/${VER}/netboot/initramfs-lts"
  VmLinuzUrl="${LinuxMirror}/${DIST}/releases/${VER}/netboot/vmlinuz-lts"
  ModLoopUrl="${LinuxMirror}/${DIST}/releases/${VER}/netboot/modloop-lts"
  echo -ne "[${yellow}Mirror${plain}] $InitrdUrl\n\t $VmLinuzUrl\n"
  wget --no-check-certificate -qO '/tmp/initrd.img' "$InitrdUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'initramfs-lts' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
  wget --no-check-certificate -qO '/tmp/vmlinuz' "$VmLinuzUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'vmlinuz-lts' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
elif [[ "$linux_relese" == 'centos' ]] && [[ "$RedHatSeries" -le "7" ]]; then
  InitrdUrl="${LinuxMirror}/${DIST}/os/${VER}/images/pxeboot/initrd.img"
  VmLinuzUrl="${LinuxMirror}/${DIST}/os/${VER}/images/pxeboot/vmlinuz"
  echo -ne "[${yellow}Mirror${plain}] $InitrdUrl\n\t $VmLinuzUrl\n"
  wget --no-check-certificate -qO '/tmp/initrd.img' "$InitrdUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'initrd.img' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
  wget --no-check-certificate -qO '/tmp/vmlinuz' "$VmLinuzUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'vmlinuz' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
elif [[ "$linux_relese" == 'centos' && "$RedHatSeries" -ge "8" ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]]; then
  InitrdUrl="${LinuxMirror}/${DIST}/BaseOS/${VER}/os/images/pxeboot/initrd.img"
  VmLinuzUrl="${LinuxMirror}/${DIST}/BaseOS/${VER}/os/images/pxeboot/vmlinuz"
  echo -ne "[${yellow}Mirror${plain}] $InitrdUrl\n\t $VmLinuzUrl\n"
  wget --no-check-certificate -qO '/tmp/initrd.img' "$InitrdUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'initrd.img' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
  wget --no-check-certificate -qO '/tmp/vmlinuz' "$VmLinuzUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'vmlinuz' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
elif [[ "$linux_relese" == 'fedora' ]]; then
  InitrdUrl="${LinuxMirror}/releases/${DIST}/Server/${VER}/os/images/pxeboot/initrd.img"
  VmLinuzUrl="${LinuxMirror}/releases/${DIST}/Server/${VER}/os/images/pxeboot/vmlinuz"
  echo -ne "[${yellow}Mirror${plain}] $InitrdUrl\n\t $VmLinuzUrl\n"
  wget --no-check-certificate -qO '/tmp/initrd.img' "$InitrdUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'initrd.img' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
  wget --no-check-certificate -qO '/tmp/vmlinuz' "$VmLinuzUrl"
  [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download 'vmlinuz' for ${yellow}$linux_relese${plain} failed! \n" && exit 1
else
  bash $0 error
  exit 1
fi

if [[ "$IncFirmware" == '1' ]]; then
  if [[ "$linux_relese" == 'debian' ]]; then
    if [[ "$IsCN" == "cn" ]]; then
      wget --no-check-certificate -qO '/tmp/firmware.cpio.gz' "https://mirrors.ustc.edu.cn/debian-cdimage/unofficial/non-free/firmware/${DIST}/current/firmware.cpio.gz"
      [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download firmware for ${red}$linux_relese${plain} failed! \n" && exit 1
    else
      wget --no-check-certificate -qO '/tmp/firmware.cpio.gz' "http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/${DIST}/current/firmware.cpio.gz"
      [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download firmware for ${red}$linux_relese${plain} failed! \n" && exit 1
    fi
    if [[ "$ddMode" == '1' ]]; then
      vKernel_udeb=$(wget --no-check-certificate -qO- "http://$LinuxMirror/dists/$DIST/main/installer-$VER/current/images/udeb.list" |grep '^acpi-modules' |head -n1 |grep -o '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}-[0-9]\{1,2\}' |head -n1)
      [[ -z "vKernel_udeb" ]] && vKernel_udeb="6.1.0-9"
    fi
  elif [[ "$linux_relese" == 'kali' ]]; then
    if [[ "$IsCN" == "cn" ]]; then
      wget --no-check-certificate -qO /root/kaliFirmwareCheck 'https://mirrors.tuna.tsinghua.edu.cn/kali/pool/non-free/f/firmware-nonfree/?C=S&O=D'
      kaliFirmwareName=$(grep "href=\"firmware-nonfree" /root/kaliFirmwareCheck | head -n 1 | awk -F'\">' '/tar.xz/{print $3}' | cut -d'<' -f1 | cut -d'/' -f2)
      wget --no-check-certificate -qO '/tmp/kali_firmware.tar.xz' "https://mirrors.tuna.tsinghua.edu.cn/kali/pool/non-free/f/firmware-nonfree/$kaliFirmwareName"
      [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download firmware for ${red}$linux_relese${plain} failed! \n" && exit 1    
      rm -rf /root/kaliFirmwareCheck
    else
      wget --no-check-certificate -qO /root/kaliFirmwareCheck 'https://mirrors.ocf.berkeley.edu/kali/pool/non-free/f/firmware-nonfree/?C=S&O=D'
      kaliFirmwareName=$(grep "href=\"firmware-nonfree" /root/kaliFirmwareCheck | head -n 1 | awk -F'\">' '/tar.xz/{print $3}' | cut -d'<' -f1 | cut -d'/' -f2)
      wget --no-check-certificate -qO '/tmp/kali_firmware.tar.xz' "https://mirrors.ocf.berkeley.edu/kali/pool/non-free/f/firmware-nonfree/$kaliFirmwareName"
      [[ $? -ne '0' ]] && echo -ne "\n[${red}Error${plain}] Download firmware for ${red}$linux_relese${plain} failed! \n" && exit 1
      rm -rf /root/kaliFirmwareCheck
    fi
    decompressedKaliFirmwareDir=$(echo $kaliFirmwareName | cut -d'.' -f 1 | sed 's/_/-/g')
  fi
fi

[[ -d /tmp/boot ]] && rm -rf /tmp/boot
mkdir -p /tmp/boot
cd /tmp/boot

if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]] || [[ "$linux_relese" == 'kali' ]] || [[ "$linux_relese" == 'alpinelinux' ]]; then
  COMPTYPE="gzip"
elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
  COMPTYPE="$(file ../initrd.img |grep -o ':.*compressed data' |cut -d' ' -f2 |sed -r 's/(.*)/\L\1/' |head -n1)"
  [[ -z "$COMPTYPE" ]] && echo "Detect compressed type fail." && exit 1
fi
CompDected='0'
for COMP in `echo -en 'gzip\nlzma\nxz'`
  do
    if [[ "$COMPTYPE" == "$COMP" ]]; then
      CompDected='1'
      if [[ "$COMPTYPE" == 'gzip' ]]; then
        NewIMG="initrd.img.gz"
      else
        NewIMG="initrd.img.$COMPTYPE"
      fi
      mv -f "/tmp/initrd.img" "/tmp/$NewIMG"
      break;
    fi
  done
[[ "$CompDected" != '1' ]] && echo "Detect compressed type not support." && exit 1
[[ "$COMPTYPE" == 'lzma' ]] && UNCOMP='xz --format=lzma --decompress'
[[ "$COMPTYPE" == 'xz' ]] && UNCOMP='xz --decompress'
[[ "$COMPTYPE" == 'gzip' ]] && UNCOMP='gzip -d'
$UNCOMP < /tmp/$NewIMG | cpio --extract --make-directories --preserve-modification-time >>/dev/null 2>&1

if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]] || [[ "$linux_relese" == 'kali' ]]; then
  DebianPreseedProcess
  if [[ "$loaderMode" != "0" ]] && [[ "$setNet" == '0' ]]; then
    sed -i '/netcfg\/disable_autoconfig/d' /tmp/boot/preseed.cfg
    sed -i '/netcfg\/dhcp_options/d' /tmp/boot/preseed.cfg
    sed -i '/netcfg\/get_.*/d' /tmp/boot/preseed.cfg
    sed -i '/netcfg\/confirm_static/d' /tmp/boot/preseed.cfg
  fi
# If server has only one disk, lv/vg/pv volumes removement by force should be disallowed, it may causes partitioner continuous execution but not finished.
  if [[ "$disksNum" -le "1" || "$setDisk" != "all" ]]; then
    sed -i 's/lvremove --select all -ff -y;//g' /tmp/boot/preseed.cfg
    sed -i 's/vgremove --select all -ff -y;//g' /tmp/boot/preseed.cfg
    sed -i 's/pvremove \/dev\/\* -ff -y;//g' /tmp/boot/preseed.cfg
  fi
  if [[ "$disksNum" -gt "1" ]] && [[ "$setRaid" == "0" || "$setRaid" == "1" || "$setRaid" == "5" || "$setRaid" == "6" || "$setRaid" == "10" ]]; then
    sed -i 's/d-i partman\/early_command.*//g' /tmp/boot/preseed.cfg
    sed -ri "/d-i grub-installer\/bootdev.*/c\d-i grub-installer\/bootdev string $AllDisks" /tmp/boot/preseed.cfg
  fi
# Debian 8 and former or Raid mode don't support xfs.
  [[ "$DebianDistNum" -le "8" || "$setRaid" == "0" || "$setRaid" == "1" || "$setRaid" == "5" || "$setRaid" == "6" || "$setRaid" == "10" ]] && sed -i '/d-i\ partman\/default_filesystem string xfs/d' /tmp/boot/preseed.cfg
  if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'kali' ]]; then
    sed -i '/user-setup\/allow-password-weak/d' /tmp/boot/preseed.cfg
    sed -i '/user-setup\/encrypt-home/d' /tmp/boot/preseed.cfg
    sed -i '/pkgsel\/update-policy/d' /tmp/boot/preseed.cfg
    sed -i 's/umount\ \/media.*true\;\ //g' /tmp/boot/preseed.cfg
    [[ -f '/tmp/firmware.cpio.gz' ]] && gzip -d < /tmp/firmware.cpio.gz | cpio --extract --verbose --make-directories --no-absolute-filenames >>/dev/null 2>&1
# Uncompressed hardware drivers size of Kali firmware non-free such as "firmware-nonfree_20230210.orig.tar.xz" is almost 800MB,
# if the physical memory of server is below 3GB, I suggested that not load parameter "-firmware".
    [[ -f '/tmp/kali_firmware.tar.xz' ]] && {
      tar -Jxvf '/tmp/kali_firmware.tar.xz' -C /tmp/
      mv /tmp/$decompressedKaliFirmwareDir/* '/tmp/boot/lib/firmware/'
    }
  fi
# To avoid to entry into low memory mode.
  [[ "$TotalMem1" -ge "2558072" || "$TotalMem2" -ge "2558072" ]] && sed -i '/d-i\ lowmem\/low boolean true/d' /tmp/boot/preseed.cfg
# Ubuntu 20.04 and below does't support xfs, force grub-efi installation to the removable media path may cause grub install failed, low memory mode.
  if [[ "$linux_relese" == 'ubuntu' ]]; then
    sed -i '/d-i\ partman\/default_filesystem string xfs/d' /tmp/boot/preseed.cfg
    sed -i '/d-i\ grub-installer\/force-efi-extra-removable/d' /tmp/boot/preseed.cfg
    sed -i '/d-i\ lowmem\/low boolean true/d' /tmp/boot/preseed.cfg
  fi
# Kali preseed.cfg reference:
# https://github.com/iesplin/kali-preseed/blob/master/preseed/core-minimal.cfg
#
# Kali metapackages reference:
# https://www.kali.org/docs/general-use/metapackages/
  if [[ "$linux_relese" == 'kali' ]]; then
    sed -i 's/first multiselect minimal/first multiselect standard/g' /tmp/boot/preseed.cfg
    sed -i 's/upgrade select none/upgrade select full-upgrade/g' /tmp/boot/preseed.cfg
    sed -i 's/include string openssh-server/include string kali-linux-core openssh-server/g' /tmp/boot/preseed.cfg
    sed -i 's/d-i grub-installer\/with_other_os boolean true//g' /tmp/boot/preseed.cfg
  fi
  if [[ "$linux_relese" != 'kali' ]]; then
    sed -i '/d-i\ apt-setup\/services-select multiselect/d' /tmp/boot/preseed.cfg
    sed -i '/d-i\ apt-setup\/enable-source-repositories boolean false/d' /tmp/boot/preseed.cfg
  fi
# Static network environment doesn't support ntp clock setup.
  if [[ "$Network4Config" == "isStatic" ]] || [[ "$Network6Config" == "isStatic" ]]; then
    sed -i 's/ntp boolean true/ntp boolean false/g' /tmp/boot/preseed.cfg
    sed -i '/d-i\ clock-setup\/ntp-server string ntp.nict.jp/d' /tmp/boot/preseed.cfg
  fi
# If network adapter is not redirected, delete this setting to new system.
  [[ "$setInterfaceName" == "0" ]] && sed -i 's/net.ifnames=0 biosdevname=0//g' /tmp/boot/preseed.cfg
# If user not setting disable IPv6 or network is IPv6 or bio-stack, "ipv6.disable=1" should be deleted.
  [[ "$setIPv6" == "1" ]] && sed -i 's/ipv6.disable=1//g' /tmp/boot/preseed.cfg

  [[ "$ddMode" == '1' ]] && {
    WinNoDHCP(){
      echo -ne "for\0040\0057f\0040\0042tokens\00753\0052\0042\0040\0045\0045i\0040in\0040\0050\0047netsh\0040interface\0040show\0040interface\0040\0136\0174more\0040\00533\0040\0136\0174findstr\0040\0057I\0040\0057R\0040\0042本地\0056\0052\0040以太\0056\0052\0040Local\0056\0052\0040Ethernet\0042\0047\0051\0040do\0040\0050set\0040EthName\0075\0045\0045j\0051\r\nnetsh\0040\0055c\0040interface\0040ip\0040set\0040address\0040name\0075\0042\0045EthName\0045\0042\0040source\0075static\0040address\0075$IPv4\0040mask\0075$MASK\0040gateway\0075$GATE\r\nnetsh\0040\0055c\0040interface\0040ip\0040add\0040dnsservers\0040name\0075\0042\0045EthName\0045\0042\0040address\00758\00568\00568\00568\0040index\00751\0040validate\0075no\r\n\r\n" >>'/tmp/boot/net.tmp';
    }
    WinRDP(){
      echo -ne "netsh\0040firewall\0040set\0040portopening\0040protocol\0075ALL\0040port\0075$WinRemote\0040name\0075RDP\0040mode\0075ENABLE\0040scope\0075ALL\0040profile\0075ALL\r\nnetsh\0040firewall\0040set\0040portopening\0040protocol\0075ALL\0040port\0075$WinRemote\0040name\0075RDP\0040mode\0075ENABLE\0040scope\0075ALL\0040profile\0075CURRENT\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Network\0134NewNetworkWindowOff\0042\0040\0057f\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Terminal\0040Server\0042\0040\0057v\0040fDenyTSConnections\0040\0057t\0040reg\0137dword\0040\0057d\00400\0040\0057f\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Terminal\0040Server\0134Wds\0134rdpwd\0134Tds\0134tcp\0042\0040\0057v\0040PortNumber\0040\0057t\0040reg\0137dword\0040\0057d\0040$WinRemote\0040\0057f\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Terminal\0040Server\0134WinStations\0134RDP\0055Tcp\0042\0040\0057v\0040PortNumber\0040\0057t\0040reg\0137dword\0040\0057d\0040$WinRemote\0040\0057f\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Terminal\0040Server\0134WinStations\0134RDP\0055Tcp\0042\0040\0057v\0040UserAuthentication\0040\0057t\0040reg\0137dword\0040\0057d\00400\0040\0057f\r\nFOR\0040\0057F\0040\0042tokens\00752\0040delims\0075\0072\0042\0040\0045\0045i\0040in\0040\0050\0047SC\0040QUERYEX\0040TermService\0040\0136\0174FINDSTR\0040\0057I\0040\0042PID\0042\0047\0051\0040do\0040TASKKILL\0040\0057F\0040\0057PID\0040\0045\0045i\r\nFOR\0040\0057F\0040\0042tokens\00752\0040delims\0075\0072\0042\0040\0045\0045i\0040in\0040\0050\0047SC\0040QUERYEX\0040UmRdpService\0040\0136\0174FINDSTR\0040\0057I\0040\0042PID\0042\0047\0051\0040do\0040TASKKILL\0040\0057F\0040\0057PID\0040\0045\0045i\r\nSC\0040START\0040TermService\r\n\r\n" >>'/tmp/boot/net.tmp';
    }
    echo -ne "\0100ECHO\0040OFF\r\n\r\ncd\0056\0076\0045WINDIR\0045\0134GetAdmin\r\nif\0040exist\0040\0045WINDIR\0045\0134GetAdmin\0040\0050del\0040\0057f\0040\0057q\0040\0042\0045WINDIR\0045\0134GetAdmin\0042\0051\0040else\0040\0050\r\necho\0040CreateObject\0136\0050\0042Shell\0056Application\0042\0136\0051\0056ShellExecute\0040\0042\0045\0176s0\0042\0054\0040\0042\0045\0052\0042\0054\0040\0042\0042\0054\0040\0042runas\0042\0054\00401\0040\0076\0076\0040\0042\0045temp\0045\0134Admin\0056vbs\0042\r\n\0042\0045temp\0045\0134Admin\0056vbs\0042\r\ndel\0040\0057f\0040\0057q\0040\0042\0045temp\0045\0134Admin\0056vbs\0042\r\nexit\0040\0057b\00402\0051\r\n\r\n" >'/tmp/boot/net.tmp';
    [[ "$setNet" == '1' ]] && WinNoDHCP;
    [[ "$setNet" == '0' ]] && [[ "$AutoNet" == '0' ]] && WinNoDHCP;
    [[ "$setRDP" == '1' ]] && [[ -n "$WinRemote" ]] && WinRDP
    echo -ne "ECHO\0040SELECT\0040VOLUME\0075\0045\0045SystemDrive\0045\0045\0040\0076\0040\0042\0045SystemDrive\0045\0134diskpart\0056extend\0042\r\nECHO\0040EXTEND\0040\0076\0076\0040\0042\0045SystemDrive\0045\0134diskpart\0056extend\0042\r\nSTART\0040/WAIT\0040DISKPART\0040\0057S\0040\0042\0045SystemDrive\0045\0134diskpart\0056extend\0042\r\nDEL\0040\0057f\0040\0057q\0040\0042\0045SystemDrive\0045\0134diskpart\0056extend\0042\r\n\r\n" >>'/tmp/boot/net.tmp';
    echo -ne "cd\0040\0057d\0040\0042\0045ProgramData\0045\0057Microsoft\0057Windows\0057Start\0040Menu\0057Programs\0057Startup\0042\r\ndel\0040\0057f\0040\0057q\0040net\0056bat\r\n\r\n\r\n" >>'/tmp/boot/net.tmp';
    iconv -f 'UTF-8' -t 'GBK' '/tmp/boot/net.tmp' -o '/tmp/boot/net.bat'
    rm -rf '/tmp/boot/net.tmp'
  }
  [[ "$ddMode" == '0' ]] && {
    sed -i '/anna-install/d' /tmp/boot/preseed.cfg
    sed -i 's/wget.*\/sbin\/reboot\;\ //g' /tmp/boot/preseed.cfg
  }
elif [[ "$linux_relese" == 'alpinelinux' ]]; then
# Alpine Linux only support booting with IPv4 by dhcp or static, not support booting from IPv6 by any method.
  [[ "$IPStackType" == "IPv6Stack" ]] && {
    echo -ne "\n[${red}Error${plain}] Does't support $IPStackType!\n"
    exit 1
  }
# Hostname should not be "localhost"
  HostName=$(hostname)
  [[ "$HostName" == "localhost" ]] && HostName="alpinelinux"
# Enable IPv6
  echo "ipv6" >> /tmp/boot/etc/modules
  if [[ "$setAutoConfig" == "1" ]]; then
    AlpineInitLineNum=$(grep -E -n '^exec (/bin/busybox )?switch_root' /tmp/boot/init | cut -d: -f1)
    AlpineInitLineNum=$((AlpineInitLineNum - 1))
    if [[ "$IsCN" == "cn" ]]; then
      alpineInstallOrDdAdditionalFiles "https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Alpine/alpineInit.sh" "https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Alpine/network/resolv_cn.conf" "https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Alpine/motd.sh" "mirrors.ustc.edu.cn" "mirrors.tuna.tsinghua.edu.cn" "https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Ubuntu/ubuntuInit.sh" "https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Windows/windowsInit.sh" "https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Windows/SetupComplete.bat"
    else
      alpineInstallOrDdAdditionalFiles "https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Alpine/alpineInit.sh" "https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Alpine/network/resolv.conf" "https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Alpine/motd.sh" "archive.ubuntu.com" "ports.ubuntu.com" "https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Ubuntu/ubuntuInit.sh" "https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Windows/windowsInit.sh" "https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Windows/SetupComplete.bat"
    fi
# Cloud init configurate documents and resources:
# Ubuntu cloud images:
# https://cloud-images.ubuntu.com/daily/server/
# customize Ubuntu cloud images by our own: 
# https://bleatingsheep.org/2022/03/14/%E7%94%A8-Ubuntu-Cloud-Images-%E5%88%B6%E4%BD%9C%E8%87%AA%E5%B7%B1%E7%9A%84%E4%BA%91%E9%95%9C%E5%83%8F%EF%BC%88%E9%85%8D%E7%BD%AE-cloud-init-%E7%9A%84-NoCloud-%E6%95%B0%E6%8D%AE%E6%BA%90%EF%BC%89/
# documents from Redhat:
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_cloud-init_for_rhel_8/configuring-cloud-init_cloud-content
# network configuration:
# https://cloudinit.readthedocs.io/en/latest/reference/network-config-format-v2.html
# valid "*.yaml" format regulations for netplan samples:
# https://qiita.com/zen3/items/757f96cbe522a9ad397d
# netplan will deperate the "gateway4" and "gateway6", use "routes" to replace it.
# https://rohhie.net/ubuntu22-04-netplan-gateway4-has-been-deprecated/
# enable netplan configuration permanently to prevent to be changed by cloud init during rebooting from the new OS
# https://askubuntu.com/questions/1051655/convert-etc-network-interfaces-to-netplan
# disable cloud init service when next restart
# https://cloudinit.readthedocs.io/en/latest/howto/disable_cloud_init.html
    if [[ "$IPStackType" == "IPv4Stack" ]]; then
      if [[ "$Network4Config" == "isDHCP" ]]; then
        if [[ "$IsCN" == "cn" ]]; then
          AlpineNetworkConf="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Alpine/network/dhcp_interfaces"
          [[ "$targetRelese" == 'Ubuntu' ]] && cloudInitUrl="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Ubuntu/CloudInit/dhcp_interfaces.cfg"
        else
          AlpineNetworkConf="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Alpine/network/dhcp_interfaces"
          [[ "$targetRelese" == 'Ubuntu' ]] && cloudInitUrl="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Ubuntu/CloudInit/dhcp_interfaces.cfg"
        fi
      elif [[ "$Network4Config" == "isStatic" ]]; then
        if [[ "$IsCN" == "cn" ]]; then
          AlpineNetworkConf="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Alpine/network/ipv4_static_interfaces"
          [[ "$targetRelese" == 'Ubuntu' ]] && cloudInitUrl="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Ubuntu/CloudInit/ipv4_static_interfaces.cfg"
        else
          AlpineNetworkConf="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Alpine/network/ipv4_static_interfaces"
          [[ "$targetRelese" == 'Ubuntu' ]] && cloudInitUrl="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Ubuntu/CloudInit/ipv4_static_interfaces.cfg"
        fi
      fi
    elif [[ "$IPStackType" == "BiStack" ]]; then
# Alpine Linux doesn't support IPv6 automatic config, must manually.
      if [[ "$Network4Config" == "isDHCP" ]]; then
        [[ "$IsCN" == "cn" ]] && AlpineNetworkConf="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Alpine/network/ipv6_static_interfaces" || AlpineNetworkConf="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Alpine/network/ipv6_static_interfaces"
      elif [[ "$Network4Config" == "isStatic" ]]; then
        [[ "$IsCN" == "cn" ]] && AlpineNetworkConf="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Alpine/network/ipv4_ipv6_static_interfaces" || AlpineNetworkConf="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Alpine/network/ipv4_ipv6_static_interfaces"
      fi
      [[ "$targetRelese" == 'Ubuntu' ]] && {
        if [[ "$Network4Config" == "isDHCP" ]] && [[ "$Network6Config" == "isDHCP" ]]; then
          [[ "$IsCN" == "cn" ]] && cloudInitUrl="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Ubuntu/CloudInit/dhcp_interfaces.cfg" || cloudInitUrl="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Ubuntu/CloudInit/dhcp_interfaces.cfg"
        elif [[ "$Network4Config" == "isDHCP" ]] && [[ "$Network6Config" == "isStatic" ]]; then
          [[ "$IsCN" == "cn" ]] && cloudInitUrl="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Ubuntu/CloudInit/ipv4_dhcp_ipv6_static_interfaces.cfg" || cloudInitUrl="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Ubuntu/CloudInit/ipv4_dhcp_ipv6_static_interfaces.cfg"
        elif [[ "$Network4Config" == "isStatic" ]] && [[ "$Network6Config" == "isDHCP" ]]; then
          [[ "$IsCN" == "cn" ]] && cloudInitUrl="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Ubuntu/CloudInit/ipv4_static_ipv6_dhcp_interfaces.cfg" || cloudInitUrl="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Ubuntu/CloudInit/ipv4_static_ipv6_dhcp_interfaces.cfg"
        elif [[ "$Network4Config" == "isStatic" ]] && [[ "$Network6Config" == "isStatic" ]]; then
          [[ "$IsCN" == "cn" ]] && cloudInitUrl="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Ubuntu/CloudInit/ipv4_static_ipv6_static_interfaces.cfg" || cloudInitUrl="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Ubuntu/CloudInit/ipv4_static_ipv6_static_interfaces.cfg"
        fi
      }
    fi
# All the following steps are processed in the temporary Alpine Linux.
    cat <<EOF | sed -i "${AlpineInitLineNum}r /dev/stdin" /tmp/boot/init
# Download "interfaces" templates and replace IP details.
wget --no-check-certificate -O \$sysroot/etc/network/tmp_interfaces ${AlpineNetworkConf}

# Config nameservers
rm -rf \$sysroot/etc/resolv.conf
wget --no-check-certificate -O \$sysroot/etc/resolv.conf ${AlpineDnsFile}
chmod a+x \$sysroot/etc/resolv.conf

# Add customized motd
rm -rf \$sysroot/etc/motd
wget --no-check-certificate -O \$sysroot/etc/profile.d/motd.sh ${AlpineMotd}
chmod a+x \$sysroot/etc/profile.d/motd.sh

# Modify initial file.

# To determine main hard drive.
echo "IncDisk  "${IncDisk} >> \$sysroot/root/alpine.config

# To determine mirror.
echo "LinuxMirror  "${LinuxMirror} >> \$sysroot/root/alpine.config

# To determine release of Alpine Linux
echo "alpineVer  "${DIST} >> \$sysroot/root/alpine.config

# To determine target system mirror.
echo "targetLinuxMirror  "${targetLinuxMirror} >> \$sysroot/root/alpine.config

# To determine Windows network static config file.
echo "windowsStaticConfigCmd  "${windowsStaticConfigCmd} >> \$sysroot/root/alpine.config

# To determine Windows network IPv4 static or dhcp.
echo "Network4Config  "${Network4Config} >> \$sysroot/root/alpine.config

# Tod determine Windows dd package decompress method.
echo "DEC_CMD  "${DEC_CMD} >> \$sysroot/root/alpine.config

# To determine timezone.
echo "TimeZone  "${TimeZone} >> \$sysroot/root/alpine.config

# To determine root password.
echo 'tmpWORD  '$tmpWORD'' >> \$sysroot/root/alpine.config

# To determine ssh port.
echo "sshPORT  "${sshPORT} >> \$sysroot/root/alpine.config

# To determine IPv4 static config
echo "IPv4  "${IPv4} >> \$sysroot/root/alpine.config
echo "MASK  "${MASK} >> \$sysroot/root/alpine.config
echo "ipPrefix  "${ipPrefix} >> \$sysroot/root/alpine.config
echo "actualIp4Prefix  "${actualIp4Prefix} >> \$sysroot/root/alpine.config
echo "actualIp4Subnet  "${actualIp4Subnet} >> \$sysroot/root/alpine.config
echo "GATE  "${GATE} >> \$sysroot/root/alpine.config
echo "ipDNS1  "${ipDNS1} >> \$sysroot/root/alpine.config
echo "ipDNS2  "${ipDNS2} >> \$sysroot/root/alpine.config

# To determine Ipv6 static config
echo "ip6Addr  "${ip6Addr} >> \$sysroot/root/alpine.config
echo "ip6Mask  "${ip6Mask} >> \$sysroot/root/alpine.config
echo "actualIp6Prefix  "${actualIp6Prefix} >> \$sysroot/root/alpine.config
echo "ip6Gate  "${ip6Gate} >> \$sysroot/root/alpine.config
echo "ip6DNS1  "${ip6DNS1} >> \$sysroot/root/alpine.config
echo "ip6DNS2  "${ip6DNS2} >> \$sysroot/root/alpine.config

# To determine whether to disable IPv6 modules
echo "setIPv6  "${setIPv6} >> \$sysroot/root/alpine.config

# To Determine hostname
echo "HostName  "${HostName} >> \$sysroot/root/alpine.config

# To Determine dd image url
echo "DDURL  "${DDURL} >> \$sysroot/root/alpine.config

# To Determine cloud init url
echo "cloudInitUrl  "${cloudInitUrl} >> \$sysroot/root/alpine.config

# Download initial file.
wget --no-check-certificate -O \$sysroot/etc/local.d/${AlpineInitFileName} ${AlpineInitFile}

# Set initial file execute automatically.
chmod a+x \$sysroot/etc/local.d/${AlpineInitFileName}
ln -s /etc/init.d/local \$sysroot/etc/runlevels/default/
EOF
  fi
elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
  RedHatUrl=""
  RepoBase=""
  RepoAppStream=""
  [[ "$IsCN" == "cn" ]] && RepoEpel="repo --name=epel --baseurl=http://mirrors.ustc.edu.cn/epel/${RedHatSeries}/Everything/${VER}/" || RepoEpel="repo --name=epel --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=epel-${RedHatSeries}&arch=${VER}"
  AuthMethod="authselect --useshadow --passalgo sha512"
  SetTimeZone="timezone --utc ${TimeZone}"
  [[ "$IsCN" == "cn" ]] && FirewallRule="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/RedHat/RHEL9Public.xml" || FirewallRule="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/RedHat/RHEL9Public.xml"
  if [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]]; then
    if [[ "$RedHatSeries" -ge "8" ]]; then
      RedHatUrl="${LinuxMirror}/${DIST}/BaseOS/${VER}/os/"	  
      RepoBase="repo --name=base --baseurl=${LinuxMirror}/${DIST}/BaseOS/${VER}/os/"
      RepoAppStream="repo --name=appstream --baseurl=${LinuxMirror}/${DIST}/AppStream/${VER}/os/"
    elif [[ "$linux_relese" == 'centos' ]] && [[ "$RedHatSeries" -le "7" ]]; then
      RedHatUrl="${LinuxMirror}/${DIST}/os/${VER}/"
      AuthMethod="auth --useshadow --passalgo=sha512"
      SetTimeZone="timezone --isUtc ${TimeZone}"
      RepoBase="repo --name=base --baseurl=${LinuxMirror}/${DIST}/os/${VER}/"
      RepoAppStream="repo --name=updates --baseurl=${LinuxMirror}/${DIST}/updates/${VER}/"
      [[ "$IsCN" == "cn" ]] && FirewallRule="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/RedHat/RHEL7Public.xml" || FirewallRule="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/RedHat/RHEL7Public.xml"
    fi
  elif [[ "$linux_relese" == 'fedora' ]]; then
    RedHatUrl="${LinuxMirror}/releases/${DIST}/Server/${VER}/os/"
    RepoBase="repo --name=base --baseurl=${LinuxMirror}/releases/${DIST}/Server/${VER}/os/"
    [[ "$IsCN" == "cn" ]] && RepoAppStream="repo --name=updates --baseurl=http://mirrors.bfsu.edu.cn/fedora/updates/${DIST}/Everything/${VER}/" || RepoAppStream="repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f${DIST}&arch=${VER}"
    [[ "$IsCN" == "cn" ]] && RepoEpel="repo --name=epel --baseurl=http://mirrors.163.com/fedora/releases/${DIST}/Everything/${VER}/os/" || RepoEpel="repo --name=epel --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-${DIST}&arch=${VER}"
  fi
# If network adapter is redirected, the "eth0" is default.
# --bootproto="xx" is for IPv4, --bootproto=dhcp is IPv4 DHCP, --bootproto=static is IPv4 Static. 
# --ipv6="a vaild IPv6 address" is IPv6 Static, --ipv6=auto is IPv6 DHCP.
# Reference: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/system_design_guide/kickstart-commands-and-options-reference_system-design-guide#network_kickstart-commands-for-network-configuration
  if [[ "$IPStackType" == "IPv4Stack" ]]; then
    if [[ "$Network4Config" == "isDHCP" ]]; then
      NetConfigManually="network --device=$interface --bootproto=dhcp --ipv6=auto --nameserver=$ipDNS,$ip6DNS --hostname=$(hostname) --onboot=on"
    elif [[ "$Network4Config" == "isStatic" ]]; then
      NetConfigManually="network --device=$interface --bootproto=static --ip=$IPv4 --netmask=$actualIp4Subnet --gateway=$GATE --ipv6=auto --nameserver=$ipDNS,$ip6DNS --hostname=$(hostname) --onboot=on"
    fi
  elif [[ "$IPStackType" == "BiStack" ]]; then
    if [[ "$Network4Config" == "isDHCP" ]] && [[ "$Network6Config" == "isDHCP" ]]; then
      NetConfigManually="network --device=$interface --bootproto=dhcp --ipv6=auto --nameserver=$ipDNS,$ip6DNS --hostname=$(hostname) --onboot=on"
    elif [[ "$Network4Config" == "isDHCP" ]] && [[ "$Network6Config" == "isStatic" ]]; then
      NetConfigManually="network --device=$interface --bootproto=dhcp --ipv6=$ip6Addr/$actualIp6Prefix --ipv6gateway=$ip6Gate --nameserver=$ipDNS,$ip6DNS --hostname=$(hostname) --onboot=on"
    elif [[ "$Network4Config" == "isStatic" ]] && [[ "$Network6Config" == "isDHCP" ]]; then
      NetConfigManually="network --device=$interface --bootproto=static --ip=$IPv4 --netmask=$actualIp4Subnet --gateway=$GATE --ipv6=auto --nameserver=$ipDNS,$ip6DNS --hostname=$(hostname) --onboot=on"
    elif [[ "$Network4Config" == "isStatic" ]] && [[ "$Network6Config" == "isStatic" ]]; then
      NetConfigManually="network --device=$interface --bootproto=static --ip=$IPv4 --netmask=$actualIp4Subnet --gateway=$GATE --ipv6=$ip6Addr/$actualIp6Prefix --ipv6gateway=$ip6Gate --nameserver=$ipDNS,$ip6DNS --hostname=$(hostname) --onboot=on"
    fi
  elif [[ "$IPStackType" == "IPv6Stack" ]]; then
    if [[ "$Network6Config" == "isDHCP" ]]; then
      NetConfigManually="network --device=$interface --bootproto=dhcp --ipv6=auto --nameserver=$ipDNS,$ip6DNS --hostname=$(hostname) --onboot=on"
    elif [[ "$Network6Config" == "isStatic" ]]; then
      NetConfigManually="network --device=$interface --bootproto=dhcp --ipv6=$ip6Addr/$actualIp6Prefix --ipv6gateway=$ip6Gate --nameserver=$ipDNS,$ip6DNS --hostname=$(hostname) --onboot=on"
    fi
  fi
# Part disk manually.
# Reference: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax
#            https://blog.adachin.me/archives/3621
#            https://www.cnblogs.com/hukey/p/14919346.html
  IncDisk=`echo $IncDisk | cut -d'/' -f 3`
  if [[ "$disksNum" -le "1" || "$setDisk" != "all" ]]; then
    clearPart="clearpart --drives=${IncDisk} --all --initlabel"
    [[ "$EfiSupport" == "enabled" ]] && FormatDisk=`echo -e "part / --fstype="xfs" --ondisk="$IncDisk" --grow --size="0"\npart swap --ondisk="$IncDisk" --size="1024"\npart /boot --fstype="xfs" --ondisk="$IncDisk" --size="512"\npart /boot/efi --fstype="efi" --ondisk="$IncDisk" --size="512""` || FormatDisk=`echo -e "part / --fstype="xfs" --ondisk="$IncDisk" --grow --size="0"\npart swap --ondisk="$IncDisk" --size="1024"\npart /boot --fstype="xfs" --ondisk="$IncDisk" --size="512"\npart biosboot --fstype=biosboot --ondisk="$IncDisk" --size=1"`
  elif [[ "$setDisk" == "all" ]]; then
    clearPart="clearpart --all --initlabel"
    FormatDisk="autopart"
  fi
if [[ "$setAutoConfig" == "1" ]]; then
  cat >/tmp/boot/ks.cfg<<EOF
# platform x86, AMD64, or Intel EM64T, or ARM aarch64
# Firewall configuration
firewall --enabled --ssh

# Use network installation
url --url="${RedHatUrl}"
${RepoBase}
${RepoAppStream}
${RepoEpel}

# Root password
rootpw --iscrypted $myPASSWORD

# System authorization information
${AuthMethod}

# Disable system configuration
firstboot --disable

# System language
lang en_US

# Keyboard layouts
keyboard us

# SELinux configuration
selinux --disabled

# Use text install
text

# unsupported_hardware
# vnc
# dont't config display manager
skipx

# System Timezone
${SetTimeZone}

# Network Configuration
${NetConfigManually}

# System bootloader configuration
bootloader --location=mbr --boot-drive=${IncDisk} --append="rhgb quiet crashkernel=auto net.ifnames=0 biosdevname=0 ipv6.disable=1"

# Clear the Master Boot Record
zerombr
${clearPart}

# Disk partitioning information
${FormatDisk}

# Reboot after installation
reboot

%packages --ignoremissing
@^minimal-environment
bind-utils
curl
epel-release
fail2ban
file
lrzsz
net-tools
traceroute
vim
wget
xz

%end

# Enable services
services --enabled=fail2ban,firewalld

# All modified command should only be executed between %post and %end location!
%post --interpreter=/bin/bash

# Disable selinux
sei -ri "/^#?SELINUX=permissive/c\SELINUX=disabled" /etc/selinux/config
sei -ri "/^#?SELINUX=enforcing/c\SELINUX=disabled" /etc/selinux/config

# Allow password login
sed -ri "/^#?PermitRootLogin.*/c\PermitRootLogin yes" /etc/ssh/sshd_config
sed -ri "/^#?PasswordAuthentication.*/c\PasswordAuthentication yes" /etc/ssh/sshd_config

# Change ssh port
sed -ri "/^#?Port.*/c\Port ${sshPORT}" /etc/ssh/sshd_config
rm -rf /etc/firewalld/zones/public.xml
wget --no-check-certificate -qO /etc/firewalld/zones/public.xml '$FirewallRule'
sed -ri 's/port=""/port="${sshPORT}"/g' /etc/firewalld/zones/public.xml
firewall-cmd --reload

# Write fail2ban config
touch /etc/fail2ban/jail.d/local.conf
echo -ne "[DEFAULT]\nbanaction = firewallcmd-ipset\nbackend = systemd\n\n[sshd]\nenabled = true" > /etc/fail2ban/jail.d/local.conf

# Fail2ban config
touch /var/log/fail2ban.log
sed -i -E 's/^(logtarget =).*/\1 \/var\/log\/fail2ban.log/' /etc/fail2ban/fail2ban.conf
systemctl enable fail2ban

# Clean logs and kickstart files
rm -rf /root/anaconda-ks.cfg
rm -rf /root/install.*log
rm -rf /root/original-ks.cfg

%end

EOF
fi
# If network adapter is not redirected, delete this setting to new system.
  [[ "$setInterfaceName" == "0" ]] && sed -i 's/ net.ifnames=0 biosdevname=0//g' /tmp/boot/ks.cfg
# Support to add --setipv6 "0" to disable IPv6 modules permanently.
  [[ "$setIPv6" == "1" ]] && sed -i 's/ipv6.disable=1//g' /tmp/boot/ks.cfg
  
  [[ "$UNKNOWHW" == '1' ]] && sed -i 's/^unsupported_hardware/#unsupported_hardware/g' /tmp/boot/ks.cfg
  [[ "$(echo "$DIST" |grep -o '^[0-9]\{1\}')" == '5' ]] && sed -i '0,/^%end/s//#%end/' /tmp/boot/ks.cfg
fi

# find . | cpio -H newc --create --verbose | gzip -1 > /tmp/initrd.img
find . | cpio -o -H newc | gzip -1 > /tmp/initrd.img
cp -f /tmp/initrd.img /boot/initrd.img || sudo cp -f /tmp/initrd.img /boot/initrd.img
cp -f /tmp/vmlinuz /boot/vmlinuz || sudo cp -f /tmp/vmlinuz /boot/vmlinuz

# Grub config start
# Debian/Ubuntu/Kali Grub1 set start
if [[ ! -z "$GRUBTYPE" && "$GRUBTYPE" == "isGrub1" ]]; then
  if [[ "$setNetbootXyz" == "0" ]]; then
    READGRUB='/tmp/grub.read'
    [[ -f $READGRUB ]] && rm -rf $READGRUB
    touch $READGRUB
# Backup original grub config file
    cp $GRUBDIR/$GRUBFILE "$GRUBDIR/$GRUBFILE_$(date "+%Y%m%d%H%M").bak"
# Read grub file, search boot item.
#
# Here is the sample of "menuentry" in most regular Debian like Linux releases:
#
# menuentry 'Debian GNU/Linux' {
#   load_video
#   insmod ...
#   if [ x$grub_platform = xxen ]; then insmod ...; fi
#   set root='hd...'
#   if [ x$feature_platform_search_hint = xy ]; then
#	    search --no-floppy --fs-uuid --set=root --hint- ...
#   else
#     search --no-floppy --fs-uuid --set=root some uuid
#   fi
#   echo	'Loading Linux ...'
#	  linux	/boot/vmlinuz
#   echo	'Loading initial ramdisk ...'
#   initrd	/boot/initrd.img
# }
#
# But in Ubuntu series(version 20.04+) of official templates of Amazon Lightsail, there are two "}" in one set of the "menuentry" like:
#
# menuentry 'Ubuntu' {
#   gfxpayload ...
#   insmod ...
#   if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
#   if [ x$feature_platform_search_hint = xy ]; then ...; fi
#   if [ "${initrdfail}" = 1 ]; then
#     linux	/boot/vmlinuz
#     initrd	/boot/initrd.img
#   else
#     ...
#   fi
#   initrdfail
# }
#
# Original regex " grep -om 1 'menuentry\ [^}]*}' " written by "MoeClub" can only matches end to " menuentry 'Ubuntu' {..... if [ "${initrdfail} " so that " grep -om 1 'menuentry\ [^}]*}%%%%%%% " caused "$READGRUB" has nothing.
# That's why we need to add "." to split every regex conditions and delete space lines of "# code comments".
#
# Some grub file is written as a binary file, add parameter "-a, --text" process this file as if it were text; this is equivalent to the --binary-files=text option
    cat $GRUBDIR/$GRUBFILE | sed -n '1h;1!H;$g;s/\n/%%%%%%%/g;$p' | grep -aom 1 'menuentry\ [^{].*{.[^}].*}%%%%%%%' | sed 's/%%%%%%%/\n/g' | grep -v '^#' | sed '/^[[:space:]]*$/d' >$READGRUB
    LoadNum="$(cat $READGRUB | grep -c 'menuentry ')"
    if [[ "$LoadNum" -eq '1' ]]; then
      cat $READGRUB | sed '/^$/d' >/tmp/grub.new;
    elif [[ "$LoadNum" -gt '1' ]]; then
      CFG0="$(awk '/menuentry /{print NR}' $READGRUB | head -n 1)";
      CFG2="$(awk '/menuentry /{print NR}' $READGRUB | head -n 2 | tail -n 1)";
      CFG1="";
      for tmpCFG in `awk '/}/{print NR}' $READGRUB`; do
        [ "$tmpCFG" -gt "$CFG0" -a "$tmpCFG" -lt "$CFG2" ] && CFG1="$tmpCFG";
      done
      [[ -z "$CFG1" ]] && {
        echo -ne "\n[${red}Error${plain}] Read $GRUBFILE.\n";
        exit 1;
      }
      sed -n "$CFG0,$CFG1"p $READGRUB >/tmp/grub.new;
      [[ -f /tmp/grub.new ]] && [[ "$(grep -c '{' /tmp/grub.new)" -eq "$(grep -c '}' /tmp/grub.new)" ]] || {
        echo -ne "\n[${red}Error${plain}] Not configure $GRUBFILE.\n";
        exit 1;
      }
    fi  
    [ ! -f /tmp/grub.new ] && echo -ne "\n[${red}Error${plain}] $GRUBFILE. " && exit 1;
    sed -i "/menuentry.*/c\menuentry\ \'Install OS \[$Relese\ $DIST\ $VER\]\'\ --class debian\ --class\ gnu-linux\ --class\ gnu\ --class\ os\ \{" /tmp/grub.new
    sed -i "/echo.*Loading/d" /tmp/grub.new;
    INSERTGRUB="$(awk '/menuentry /{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)"
  
    [[ -n "$(grep 'linux.*/\|kernel.*/' /tmp/grub.new |awk '{print $2}' |tail -n 1 |grep '^/boot/')" ]] && Type='InBoot' || Type='NoBoot';
  
    LinuxKernel="$(grep 'linux.*/\|kernel.*/' /tmp/grub.new |awk '{print $1}' |head -n 1)";
    [[ -z "$LinuxKernel" ]] && echo -ne "\n${red}Error${plain} read grub config!\n" && exit 1;
    LinuxIMG="$(grep 'initrd.*/' /tmp/grub.new |awk '{print $1}' |tail -n 1)";
    [ -z "$LinuxIMG" ] && sed -i "/$LinuxKernel.*\//a\\\tinitrd\ \/" /tmp/grub.new && LinuxIMG='initrd';
# If network adapter need to redirect eth0, eth1... in new system, add this setting in grub file of the current system for netboot install file which need to be loaded after restart.
# The same behavior for grub2.
    [[ "$setInterfaceName" == "1" ]] && Add_OPTION="$Add_OPTION net.ifnames=0 biosdevname=0" || Add_OPTION="$Add_OPTION"
    [[ "$setIPv6" == "0" ]] && Add_OPTION="$Add_OPTION ipv6.disable=1" || Add_OPTION="$Add_OPTION"

    if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]] || [[ "$linux_relese" == 'kali' ]]; then
# The method for Debian series installer to search network adapter automatically is to set "d-i netcfg/choose_interface select auto" in preseed file.
# The same behavior for grub2.
      BOOT_OPTION="auto=true $Add_OPTION hostname=$(hostname) domain=$linux_relese quiet"
    elif [[ "$linux_relese" == 'alpinelinux' ]]; then
# Reference: https://wiki.alpinelinux.org/wiki/PXE_boot
# IPv4 dhcp config:
# ip=dhcp or not assign it.
# Allow a valid IPv4 static config:
# ip=client-ip::geteway:mask::adapter::dns:
# Sample:
# ip=179.86.100.76::179.86.100.1:255.255.255.0::eth0::1.0.0.1 8.8.8.8:
# Any of IPv6 address format can't be recognized.
      [[ "$Network4Config" == "isStatic" ]] && Add_OPTION="ip=$IPv4::$GATE:$MASK::$interface::$ipDNS:" || Add_OPTION="ip=dhcp"
      BOOT_OPTION="alpine_repo=$LinuxMirror/$DIST/main modloop=$ModLoopUrl $Add_OPTION"
      # Add_OPTION="ip=[2603:c020:800d:ae3d:6cde:8519:f1e3:a522]::[fe80::200:17ff:fe4c:e267]:[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff]::eth0::[2606:4700:4700::1001]:"
      # BOOT_OPTION="alpine_repo=$LinuxMirror/$DIST/main modloop=$LinuxMirror/$DIST/releases/$VER/netboot/modloop-lts ip=2001:19f0:000c:05b9:5400:04ff:fe74:7d40::fe80:0000:0000:0000:fc00:04ff:fe74:7d40:ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff::eth0::2606:4700:4700:0000:0000:0000:0000:1001:"
    elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
# The method for Redhat series installer to search network adapter automatically is to set "ksdevice=link" in grub file of the current system for netboot install file which need to be loaded after restart.
# The same behavior for grub2.
# "ksdevice=interface" will be deprecated in future versions of anaconda.
# Reference: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/performing_an_advanced_rhel_8_installation/kickstart-and-advanced-boot-options_installing-rhel-as-an-experienced-user
      BOOT_OPTION="inst.ks=file://ks.cfg $Add_OPTION inst.nomemcheck quiet"
    fi
    [[ "$setAutoConfig" == "0" ]] && sed -i 's/inst.ks=file:\/\/ks.cfg//' $GRUBDIR/$GRUBFILE
    
    [ -n "$setConsole" ] && BOOT_OPTION="$BOOT_OPTION --- console=$setConsole"
  
    [[ "$Type" == 'InBoot' ]] && {
      sed -i "/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/boot\/vmlinuz $BOOT_OPTION" /tmp/grub.new;
      sed -i "/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/boot\/initrd.img" /tmp/grub.new;
    }
    [[ "$Type" == 'NoBoot' ]] && {
      sed -i "/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/vmlinuz $BOOT_OPTION" /tmp/grub.new;
      sed -i "/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/initrd.img" /tmp/grub.new;
    }

    sed -i '$a\\n' /tmp/grub.new;
  
    sed -i ''${INSERTGRUB}'i\\n' $GRUBDIR/$GRUBFILE;
    sed -i ''${INSERTGRUB}'r /tmp/grub.new' $GRUBDIR/$GRUBFILE;
    [[ -f  $GRUBDIR/grubenv ]] && sed -i 's/saved_entry/#saved_entry/g' $GRUBDIR/grubenv;
# Debian/Ubuntu grub1 set end
  elif [[ "$setNetbootXyz" == "1" ]]; then
    grub-mkconfig -o $GRUBDIR/$GRUBFILE >>/dev/null 2>&1
    grub-set-default "Bootable ISO Image: netboot.xyz" >>/dev/null 2>&1
    grub-reboot "Bootable ISO Image: netboot.xyz" >>/dev/null 2>&1
  fi
elif [[ ! -z "$GRUBTYPE" && "$GRUBTYPE" == "isGrub2" ]]; then
  if [[ "$setNetbootXyz" == "0" ]]; then
# RedHat grub2 set start
# Confirm linux and initrd kernel direction
    if [[ -f /boot/grub2/grubenv ]] && [[ -d /boot/loader/entries ]] && [[ "$(ls /boot/loader/entries | wc -w)" != "" ]]; then
      LoaderPath=$(cat /boot/grub2/grubenv | grep 'saved_entry=' | awk -F '=' '{print $2}')
      LpLength=`echo ${#LoaderPath}`
      LpFile="/boot/loader/entries/$LoaderPath.conf"
# The saved_entry of OpenCloudOS(Tencent Cloud) is equal "0"
# [root@VM-4-11-opencloudos ~]# cat /boot/grub2/grubenv
# GRUB Environment Block
# saved_entry=0
# kernelopts=root=UUID=c21f153f-c0a8-42db-9ba5-8299e3c3d5b9 ro quiet elevator=noop console=ttyS0,115200 console=tty0 vconsole.keymap=us crashkernel=1800M-64G:256M,64G-128G:512M,128G-:768M vconsole.font=latarcyrheb-sun16 net.ifnames=0 biosdevname=0 intel_idle.max_cstate=1 intel_pstate=disable iommu=pt amd_iommu=on 
# boot_success=0
      if [[ "$LpLength" -le "1" ]] || [[ ! -f "$LpFile" ]]; then
        LpFile=`ls -Sl /boot/loader/entries/ | grep -wv "*rescue*" | awk -F' ' '{print $NF}' | sed -n '2p'`
        [[ "$(cat /boot/loader/entries/$LpFile | grep '^linux /boot/')" ]] && BootDIR='/boot' || BootDIR=''
      else
        [[ "$(cat $LpFile | grep '^linux /boot/')" ]] && BootDIR='/boot' || BootDIR=''
      fi
    else
      [[ -n "$(grep 'linux.*/\|kernel.*/' $GRUBDIR/$GRUBFILE | awk '{print $2}' | tail -n 1 | grep '^/boot/')" ]] && BootDIR='/boot' || BootDIR=''
    fi
# Confirm if BIOS or UEFI firmware for architecture of x86_64(AMD64) processors.
    if [[ "$VER" == "x86_64" || "$VER" == "amd64" ]]; then
      [[ "$EfiSupport" == "enabled" ]] && BootHex="efi" || BootHex="16"
# The architecture of aarch64(ARM64) processors have matched for only UEFI firmware even nowadays.
    elif [[ "$VER" == "aarch64" || "$VER" == "arm64" ]]; then
      BootHex=""
    fi
# Get main menuentry parameter from current system
    CFG0="$(awk '/insmod part_/{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)"
    CFG2tmp="$(awk '/--fs-uuid --set=root/{print NR}' $GRUBDIR/$GRUBFILE|head -n 2|tail -n 1)"
    CFG2=`expr $CFG2tmp + 1`
    CFG1=""
    for tmpCFG in `awk '/fi/{print NR}' $GRUBDIR/$GRUBFILE`; do
      [ "$tmpCFG" -ge "$CFG0" -a "$tmpCFG" -le "$CFG2" ] && CFG1="$tmpCFG"
    done
    if [[ -z "$CFG1" ]]; then
# In standard Redhat like linux OS with grub2 above version of 7, the OS boot configuration in "grub.cfg" is like:
#
# insmod part_msdos
# insmod xfs
# set root='hd0,msdos1'
# if [ x$feature_platform_search_hint = xy ]; then
#   search --no-floppy --fs-uuid --set=root --hint='hd0,msdos1'  d34311d7-62fd-419e-8f19-71494c773ddd
# else
#   search --no-floppy --fs-uuid --set=root d34311d7-62fd-419e-8f19-71494c773ddd
# fi
#
# But in RockyLinux 9.1 of official templates in Oracle Cloud, OVH Cloud etc, the boot configuration in "grub.cfg" is different from any other of Redhat release versions compeletely:
#
# insmod part_gpt
# insmod xfs
# search --no-floppy --fs-uuid --set=root 11000e8c-9777-43c3-a83b-54a13d609fdb
# insmod part_gpt
# insmod fat
# search --no-floppy --fs-uuid --set=boot 9E70-9B63
#
# In CentOS 7, Fedora 36+, AlmaLinux/CentOS-stream/RockyLinux 8+ of official templates in Linode, all the samples are the same:
#
# insmod part_msdos
# insmod ext2
# set root='hd0,gpt2'
# insmod part_msdos
# insmod ext2
# set boot='hd0,gpt2'
#
# Only the following method will effective:
#
# The expect component in grub file should be like "search --no-floppy --fs-uuid --set=root 9340b3c7-e898-44ae-bd1e-4c58dec2b16d" or "set boot='hd0'".
      SetRootCfg="$(awk '/--fs-uuid --set=root/{print NR}' $GRUBDIR/$GRUBFILE | head -n 2 | tail -n 1)"
      [[ "$SetRootCfg" == "" ]] && SetRootCfg="$(awk '/set root='\''hd[0-9]/{print NR}' /boot/grub2/grub.cfg | head -n 2 | tail -n 1)"
# An array for depositing all rows of "insmod part_".
      InsmodPartArray=()
# An array for row number of "search --no-floppy --fs-uuid --set=root..." minus row number of "insmod part_".
      IpaSpace=()
# Static how many times does "insmod part_" appeared and storage rows in array of "InsmodPartArray",
# storage minus rows in arrary of "IpaSpace"
      for tmpCFG in `awk '/insmod part_/{print NR}' $GRUBDIR/$GRUBFILE`; do
        InsmodPartArray+=("$tmpCFG" "$InsmodPartArray")
# One number of row minus another one shouldn't be less than "0".
        [[ `expr $SetRootCfg - $tmpCFG` -gt "0" ]] && IpaSpace+=(`expr "$SetRootCfg" - "$tmpCFG"` "$IpaSpace")
      done
# Definite order "0" in "IpaSpace" as a default value of variable of "minArray".
      minArray=${IpaSpace[0]}
# The outer condition of this cycle is to definite how many times does it will execute.
      for ((i=1;i<=`grep -io "insmod part_*" $GRUBDIR/$GRUBFILE | wc -l`;i++)); do
# The inner condition of this cycle is the orders in array of "IpaSpace".
        for j in ${IpaSpace[@]}; do
# A typical buddle sort for compare whether the current variable "minArray" is greater than the order of number in "IpaSpace" of current cycle.
# If "minArray" is greater than the order "j" in array of "IpaSpace", the less one "j" will replace the former "IpaSpace".
          [[ $minArray -gt $j ]] && minArray=$j
        done
      done
# The least "minArray" will be the result and once it plus "SetRootCfg" will be the nearest row number of "insmod part_".
# So we can figure out the valid section of boot configuration in "grub.cfg" like:
#
# insmod part_gpt
# insmod xfs
# search --no-floppy --fs-uuid --set=root 9340b3c7-e898-44ae-bd1e-4c58dec2b16d
#
      CFG0=`expr $SetRootCfg - $minArray`
      CFG1="$SetRootCfg"
    fi
    [[ -z "$CFG0" || -z "$CFG1" ]] && {
      echo -ne "\n[${red}Error${plain}] Read $GRUBFILE.\n"
      exit 1
    }
    sed -n "$CFG0,$CFG1"p $GRUBDIR/$GRUBFILE >/tmp/grub.new
    sed -i -e 's/^/  /' /tmp/grub.new
    [[ -f /tmp/grub.new ]] && [[ "$(grep -c '{' /tmp/grub.new)" -eq "$(grep -c '}' /tmp/grub.new)" ]] || {
      echo -ne "\n[${red}Error${plain}] Not configure $GRUBFILE. \n"
      exit 1
    }
    [ ! -f /tmp/grub.new ] && echo -ne "\n[${red}Error${plain}] $GRUBFILE.\n" && exit 1
# Set IPv6 or distribute unite network adapter interface
    [[ "$setInterfaceName" == "1" ]] && Add_OPTION="net.ifnames=0 biosdevname=0" || Add_OPTION=""
    [[ "$setIPv6" == "0" ]] && Add_OPTION="$Add_OPTION ipv6.disable=1" || Add_OPTION="$Add_OPTION"
# Write menuentry to grub
    if [[ "$linux_relese" == 'ubuntu'  || "$linux_relese" == 'debian' || "$linux_relese" == 'kali' ]]; then
      BOOT_OPTION="auto=true $Add_OPTION hostname=$(hostname) domain=$linux_relese quiet"
    elif [[ "$linux_relese" == 'alpinelinux' ]]; then
      [[ "$Network4Config" == "isStatic" ]] && Add_OPTION="ip=$IPv4::$GATE:$MASK::$interface::$ipDNS:" || Add_OPTION="ip=dhcp"
      BOOT_OPTION="alpine_repo=$LinuxMirror/$DIST/main modloop=$ModLoopUrl $Add_OPTION"
    elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
      BOOT_OPTION="inst.ks=file://ks.cfg $Add_OPTION inst.nomemcheck quiet"
    fi
    [[ "$setAutoConfig" == "0" ]] && sed -i 's/inst.ks=file:\/\/ks.cfg//' $GRUBDIR/$GRUBFILE
    cat >> /etc/grub.d/40_custom <<EOF
menuentry 'Install $Relese $DIST $VER' --class $linux_relese --class gnu-linux --class gnu --class os {
  load_video
  set gfxpayload=text
  insmod gzio
$(cat /tmp/grub.new)
  linux$BootHex $BootDIR/vmlinuz $BOOT_OPTION
  initrd$BootHex $BootDIR/initrd.img
}
EOF
# Make grub2 to prefer installation item to boot first.
    sed -ri 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/g' /etc/default/grub
# Refreshing current system grub2 service
    grub2-mkconfig -o $GRUBDIR/$GRUBFILE >>/dev/null 2>&1
    grub2-set-default "Install $Relese $DIST $VER" >>/dev/null 2>&1
    grub2-reboot "Install $Relese $DIST $VER" >>/dev/null 2>&1
# RedHat grub set end
  elif [[ "$setNetbootXyz" == "1" ]]; then
    grub2-mkconfig -o $GRUBDIR/$GRUBFILE >>/dev/null 2>&1
    grub2-set-default "Bootable ISO Image: netboot.xyz" >>/dev/null 2>&1
    grub2-reboot "Bootable ISO Image: netboot.xyz" >>/dev/null 2>&1
  fi
fi
# Grub config end

chown root:root $GRUBDIR/$GRUBFILE
chmod 444 $GRUBDIR/$GRUBFILE

if [[ "$loaderMode" == "0" ]]; then
  # sleep 5 && reboot || sudo reboot >/dev/null 2>&1
  echo -ne "\n[${green}Finish${plain}] Input '${yellow}reboot${plain}' to continue the subsequential installation.\n"
  exit 1
else
  rm -rf "$HOME/loader"
  mkdir -p "$HOME/loader"
  cp -rf "/boot/initrd.img" "$HOME/loader/initrd.img"
  cp -rf "/boot/vmlinuz" "$HOME/loader/vmlinuz"
  [[ -f "/boot/initrd.img" ]] && rm -rf "/boot/initrd.img"
  [[ -f "/boot/vmlinuz" ]] && rm -rf "/boot/vmlinuz"
  echo && ls -AR1 "$HOME/loader"
fi
