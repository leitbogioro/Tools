#!/bin/bash
##
## License: GPL
## It can reinstall Debian, Ubuntu, CentOS, AlmaLinux, RockyLinux, Fedora linux system with network.
## Default root password: LeitboGi0ro
## Written By MoeClub.org
## Blog: https://moeclub.org
## Modified By 秋水逸冰
## Blog: https://teddysun.com/
## Modified By VPS收割者
## Blog: https://www.idcoffer.com/
## Modified By airium
## Blog: https://github.com/airium
## Modified By Leitbogioro
## Blog: https://www.zhihu.com/column/originaltechnic

export tmpVER=''
export tmpDIST=''
export tmpURL=''
export tmpWORD=''
export tmpMirror=''
export tmpDHCP=''
export TimeZone=''
export ipAddr=''
export ipMask=''
export ipGate=''
export ipDNS='1.0.0.1'
export ip6Addr=''
export ip6Mask=''
export ip6Gate=''
export ip6DNS='2606:4700:4700::1001'
export IncDisk='default'
export interface=''
export interfaceSelect=''
export setInterfaceName='0'
export IsCN=''
export Relese=''
export sshPORT=''
export ddMode='0'
export setNet='0'
export setRDP='0'
export setIPv6='0'
export setRaid=''
export isMirror='0'
export FindDists='0'
export setFileType=''
export loaderMode='0'
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
      Relese='Ubuntu'
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
    --noipv6)
      shift
      setIPv6='1'
      ;;
    *)
      if [[ "$1" != 'error' ]]; then echo -ne "\nInvaild option: '$1'\n\n"; fi
      echo -ne " Usage:\n\tbash $(basename $0)\t-debian       [\033[33m\033[04mdists-name\033[0m]\n\t\t\t\t-ubuntu       [\033[04mdists-name\033[0m]\n\t\t\t\t-centos       [\033[04mdists-name\033[0m]\n\t\t\t\t-rockylinux   [\033[04mdists-name\033[0m]\n\t\t\t\t-almalinux    [\033[04mdists-name\033[0m]\n\t\t\t\t-fedora       [\033[04mdists-name\033[0m]\n\t\t\t\t-v/--ver      [32/i386|64/\033[33m\033[04mamd64\033[0m|arm/\033[33m\033[04marm64\033[0m] [\033[33m\033[04mdists-verison\033[0m]\n\t\t\t\t--ip-addr/--ip-gate/--ip-mask\n\t\t\t\t-apt/-yum/-mirror\n\t\t\t\t-dd/--image\n\t\t\t\t-pwd [linux password]\n\t\t\t\t-port [linux ssh port] [only support debian or ubuntu]\n"
      exit 1;
      ;;
    esac
  done

[[ "$EUID" -ne '0' ]] && echo -ne "\n\033[31mError: \033[0mThis script must be run as root!\n" && exit 1;

# Ping delay to YouTube($1) and Instagram($2) and Twitter($3), support both ipv4 and ipv6, $4 is $IPStackType
function checkCN(){
  for TestUrl in "$1" "$2" "$3"; do
    IPv4PingDelay=`ping -4 -c 2 -w 2 "$TestUrl" | grep rtt | cut -d'/' -f5 | awk -F'.' '{print $NF}' | sed -n '/^[0-9]\+\(\.[0-9]\+\)\?$/p'`
    IPv6PingDelay=`ping -6 -c 2 -w 2 "$TestUrl" | grep rtt | cut -d'/' -f5 | awk -F'.' '{print $NF}' | sed -n '/^[0-9]\+\(\.[0-9]\+\)\?$/p'`
    if [[ "$4"="BioStack" ]]; then
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
    TimeZone="Asia/Shanghai"
    if [[ "$4" == "BioStack" || "$4" == "IPv6Stack" ]]; then
      ipDNS="101.6.6.6"
      ip6DNS="2001:da8::666"
    else
      ipDNS="101.6.6.6"
    fi
  fi
}

function dependence(){
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
          echo -en "[\033[32mok\033[0m]\t";
        else
          Full='1';
          echo -en "[\033[31mNot Install\033[0m]";
        fi
        echo -en "\t$BIN_DEP\n";
      fi
    done
  if [ "$Full" == '1' ]; then
    echo -ne "\n\033[31mError! \033[0mPlease use '\033[33mapt-get\033[0m' or '\033[33myum\033[0m' install it.\n\n\n"
    exit 1;
  fi
}

function selectMirror(){
  [ $# -ge 3 ] || exit 1
  Relese=$(echo "$1" |sed -r 's/(.*)/\L\1/')
  DIST=$(echo "$2" |sed 's/\ //g' |sed -r 's/(.*)/\L\1/')
  VER=$(echo "$3" |sed 's/\ //g' |sed -r 's/(.*)/\L\1/')
  New=$(echo "$4" |sed 's/\ //g')
  [ -n "$Relese" ] && [ -n "$DIST" ] && [ -n "$VER" ] || exit 1
  if [ "$Relese" == "debian" ] || [ "$Relese" == "ubuntu" ]; then
    [ "$DIST" == "focal" ] && legacy="legacy-" || legacy=""
    TEMP="SUB_MIRROR/dists/${DIST}/main/installer-${VER}/current/${legacy}images/netboot/${Relese}-installer/${VER}/initrd.gz"
  elif [ "$Relese" == "centos" ] || [ "$Relese" == "rockylinux" ] || [ "$Relese" == "almalinux" ]; then
    if [ "$Relese" == "centos" ] && [[ "$RedHatSeries" -le "7" ]]; then
      TEMP="SUB_MIRROR/${DIST}/os/${VER}/images/pxeboot/initrd.img"
    else
      TEMP="SUB_MIRROR/${DIST}/BaseOS/${VER}/os/images/pxeboot/initrd.img"
    fi
  elif [ "$Relese" == "fedora" ]; then
    TEMP="SUB_MIRROR/releases/${DIST}/Server/${VER}/os/images/pxeboot/initrd.img"
  fi
  [ -n "$TEMP" ] || exit 1
  mirrorStatus=0
  declare -A MirrorBackup
  if [[ "$IsCN" == "cn" ]]; then
    MirrorBackup=(["debian0"]="" ["debian1"]="http://mirror.nju.edu.cn/debian" ["debian2"]="http://mirrors.hit.edu.cn/debian" ["debian3"]="https://mirrors.aliyun.com/debian-archive/debian" ["ubuntu0"]="" ["ubuntu1"]="https://mirrors.ustc.edu.cn/ubuntu" ["ubuntu2"]="http://mirrors.xjtu.edu.cn/ubuntu" ["centos0"]="" ["centos1"]="https://mirrors.ustc.edu.cn/centos-stream" ["centos2"]="https://mirrors.tuna.tsinghua.edu.cn/centos" ["centos3"]="http://mirror.nju.edu.cn/centos-altarch" ["centos4"]="https://mirrors.tuna.tsinghua.edu.cn/centos-vault" ["fedora0"]="" ["fedora1"]="https://mirrors.bfsu.edu.cn/fedora" ["fedora2"]="https://mirrors.tuna.tsinghua.edu.cn/fedora" ["rockylinux0"]="" ["rockylinux1"]="http://mirror.nju.edu.cn/rocky" ["rockylinux2"]="http://mirrors.sdu.edu.cn/rocky" ["almalinux0"]="" ["almalinux1"]="https://mirror.sjtu.edu.cn/almalinux" ["almalinux2"]="http://mirrors.neusoft.edu.cn/almalinux")
  else
    MirrorBackup=(["debian0"]="" ["debian1"]="http://deb.debian.org/debian" ["debian2"]="http://ftp.kddilabs.jp/pub/debian" ["debian3"]="http://archive.debian.org/debian" ["ubuntu0"]="" ["ubuntu1"]="http://archive.ubuntu.com/ubuntu" ["ubuntu2"]="http://ports.ubuntu.com" ["centos0"]="" ["centos1"]="http://mirror.centos.org/centos" ["centos2"]="http://mirror.stream.centos.org" ["centos3"]="http://mirror.math.princeton.edu/pub/centos-altarch" ["centos4"]="http://vault.centos.org" ["fedora0"]="" ["fedora1"]="https://download-ib01.fedoraproject.org/pub/fedora/linux" ["fedora2"]="https://download-cc-rdu01.fedoraproject.org/pub/fedora/linux" ["rockylinux0"]="" ["rockylinux1"]="http://download.rockylinux.org/pub/rocky" ["rockylinux2"]="http://ftp.riken.jp/Linux/rocky" ["almalinux0"]="" ["almalinux1"]="http://repo.almalinux.org/almalinux" ["almalinux2"]="http://ftp.iij.ad.jp/pub/linux/almalinux")
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

function getDisk(){
  disks=`lsblk | sed 's/[[:space:]]*$//g' |grep "disk$" |cut -d' ' -f1 |grep -v "fd[0-9]*\|sr[0-9]*" |head -n1`
  [ -n "$disks" ] || echo ""
  echo "$disks" |grep -q "/dev"
  [ $? -eq 0 ] && echo "$disks" || echo "/dev/$disks"
}

function diskType(){
  echo `udevadm info --query all "$1" 2>/dev/null |grep 'ID_PART_TABLE_TYPE' |cut -d'=' -f2`
}

# $1 is timezone checkfile direction, $2 $3 $4 are api keys.
function getUserTimezone(){
  if [[ "$TimeZone" == "" ]]; then
    GuestIP=`who am i | awk '{print $5}' | sed 's/(//g' | sed 's/)//g'`
    for Count in "$2" "$3" "$4"; do
      [[ "$TimeZone" == "Asia/Shanghai" ]] && break
      tmpApi=`echo -n "$Count" | base64 -d`
      TimeZone=`curl -s "https://api.ipgeolocation.io/timezone?apiKey=$tmpApi&ip=$GuestIP" | jq '.timezone' | tr -d '"'`
      checkTz=`echo $TimeZone | cut -d'/' -f 1`
      [[ -n "$checkTz" && "$checkTz" =~ ^[a-zA-Z] ]] && break
    done
  else
    echo `timedatectl list-timezones` >> "$1"
    [[ `grep -c "$TimeZone" "$1"` == "0" ]] && TimeZone="Asia/Tokyo"
    rm -rf "$1"
  fi
}

function checkEfi(){
  EfiStatus=`efibootmgr l | head -n 1`
  EfiVars=""
  for Count in "$1" "$2" "$3" "$4"; do
    EfiVars=`ls -Sa $Count | wc -l`
    [[ "$EfiVars" -ge "1" ]] && break
  done
  if [[ "$EfiStatus" == "" ]] || [[ "$EfiVars" == "0" ]]; then
    EfiSupport="disabled"
  elif [[ -n `echo "$EfiStatus" | awk '{print $2}' | sed -n '/^[0-9][0-9]*$/p'` ]] && [[ "$EfiVars" != "0" ]]; then
    EfiSupport="enabled"
  else
    echo -ne "\n\033[31mError: \033[0mboot firmware of your system could not be confirmed!\n"
    exit 1
  fi
}

function checkGrub(){
  GRUBDIR=""
  GRUBFILE=""
  for Count in "$1" "$2" "$3"; do
# don't support grub1
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

# $1 is $linux_relese, $2 is $RedHatSeries
function checkMem(){
  TotalMem1=$(cat /proc/meminfo | grep "^MemTotal:" | sed 's/kb//i' | grep -o "[0-9]*" | awk -F' ' '{print $NF}')
  TotalMem2=$(free -k | grep -wi "mem*" | awk '{printf $2}')
# Without the function of OS re-installation templates in control panel which provided by cloud companies(many companies even have not).
# A independent VPS with only one hard drive is lack of the secondary hard drive to format and copy new OS file to main hard drive.
# So PXE installation need to use memory as a 'hard drive' temporary.
# For redhat series, the main OS installation file is 'squashfs.img', for example, this is the link of rockylinux 8 LiveOS iso file:
# http://dl.rockylinux.org/pub/rocky/8/Live/x86_64/Rocky-8-MATE-x86_64-latest.iso
# If you download and mount it, you will found that the size of '/LiveOS/squashfs.img' is 1.55GB!
# It means in first step of netboot installation, this 1.55GB file will be all downloaded and loaded in memory!
# So and consider other install programs if necessary, even 2GB memory is not enough, 2.5GB only just pass, it's so ridiculous!
# Debian 11 PXE installation will be able in low memory mode just 512M, why redhat loves swallow memory so much, is shame on you!
# Redhat 9 slightly improved the huge occupy of the memory, 2GB RAM machine can run it successfully.
# Technology companies usually add useless functions and redundant code in new version of software increasingly.
# They never optimize or improve it, just tell users they need to pay more to expand their hardware performance and adjust to the endless demand of them. it's not a correct decision. 
  [[ "$1" == 'fedora' || "$1" == 'rockylinux' || "$1" == 'almalinux' || "$1" == 'centos' ]] && {
    if [[ "$1" == 'rockylinux' || "$1" == 'almalinux' || "$1" == 'centos' ]]; then
      if [[ "$2" == "8" ]] && [[ "$TotalMem1" -le "2406400" || "$TotalMem2" -le "2406400" ]]; then
        echo -ne "\n\033[31mError: \033[0mMinimum system memory requirement is 2.5GB!\n"
        exit 1
      elif [[ "$2" -ge "9" ]] && [[ "$TotalMem1" -le "1740800" || "$TotalMem2" -le "1740800" ]]; then
        echo -ne "\n\033[31mError: \033[0mMinimum system memory requirement is 2GB!\n"
        exit 1
      elif [[ "$2" == "7" ]] && [[ "$TotalMem1" -le "1384200" || "$TotalMem2" -le "1384200" ]]; then
        echo -ne "\n\033[31mError: \033[0mMinimum system memory requirement is 1.5GB!\n"
        exit 1
      fi
    elif [[ "$1" == 'fedora' ]]; then
      if [[ "$TotalMem1" -le "1740800" || "$TotalMem2" -le "1740800" ]]; then
        echo -ne "\n\033[31mError: \033[0mMinimum system memory requirement is 2GB!\n"
        exit 1
      fi
    fi
  }
}

function checkSys(){
  apt update -y
  apt install curl dnsutils efibootmgr file subnetcalc jq lsb-release wget xz-utils -y
  yum update --allowerasing -y
  yum update -y
  yum install epel-release -y
  yum install bind-utils curl dnsutils efibootmgr file ipcalc jq redhat-lsb wget xz --skip-broken -y
  OsLsb=`lsb_release -d | awk '{print$2}'`
  CurrentOSVer=`cat /etc/os-release | grep -w "VERSION_ID=*" | awk -F '=' '{print $2}' | sed 's/\"//g' | cut -d'.' -f 1`
  
  RedHatRelease=""
  for Count in `cat /etc/redhat-release | awk '{print$1}'` `cat /etc/system-release | awk '{print$1}'` `cat /etc/os-release | grep -w "ID=*" | awk -F '=' '{print $2}' | sed 's/\"//g'` "$OsLsb"; do
    [[ -n "$Count" ]] && RedHatRelease=`echo -e "$Count"`"$RedHatRelease"
  done
  
  DebianRelease=""
  IsUbuntu=`uname -a | grep -i "ubuntu"`
  IsDebian=`uname -a | grep -i "debian"`
  for Count in `cat /etc/os-release | grep -w "ID=*" | awk -F '=' '{print $2}'` `cat /etc/issue | awk '{print $1}'` "$OsLsb"; do
    [[ -n "$Count" ]] && DebianRelease=`echo -e "$Count"`"$DebianRelease"
  done
  
  if [[ `echo "$RedHatRelease" | grep -i "centos"` != "" ]]; then
    CurrentOS="CentOS"
  elif [[ `echo "$RedHatRelease" | grep -i "almalinux"` != "" ]]; then
    CurrentOS="AlmaLinux"
  elif [[ `echo "$RedHatRelease" | grep -i "rocky"` != "" ]]; then
    CurrentOS="RockyLinux"
  elif [[ `echo "$RedHatRelease" | grep -i "fedora"` != "" ]]; then
    CurrentOS="Fedora"
  elif [[ `echo "$RedHatRelease" | grep -i "virtuozzo"` != "" ]]; then
    CurrentOS="Vzlinux"
  elif [[ `echo "$RedHatRelease" | grep -i 'ol\|oracle'` != "" ]]; then
    CurrentOS="OracleLinux"
  elif [[ `echo "$RedHatRelease" | grep -i 'opencloudos'` != "" ]]; then
    CurrentOS="OpenCloudOS"
  elif [[ `echo "$RedHatRelease" | grep -i 'alibaba\|aliyun'` != "" ]]; then
    CurrentOS="AlibabaCloudLinux"
  elif [[ `echo "$RedHatRelease" | grep -i 'scientific'` != "" ]]; then
    CurrentOS="ScientificLinux"
  elif [[ "$IsUbuntu" ]] || [[ `echo "$DebianRelease" | grep -i "ubuntu"` != "" ]]; then
    CurrentOS="Ubuntu"
    CurrentOSVer=`lsb_release -r | awk '{print$2}' | cut -d'.' -f1`
  elif [[ "$IsDebian" ]] || [[ `echo "$DebianRelease" | grep -i "debian"` != "" ]]; then
    CurrentOS="Debian"
    CurrentOSVer=`lsb_release -r | awk '{print$2}' | cut -d'.' -f1`
  else
    echo -e "Does't support your system!\n"
    exit 1
  fi
  if [[ "$CurrentOS" == "CentOS" || "$CurrentOS" == "OracleLinux" ]] && [[ "$CurrentOSVer" == "6" ]]; then
    echo -e "Does't support your system!\n"
    exit 1
  fi
}

function checkIpv4OrIpv6(){
  IPv4DNSLookup=`timeout 2 dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed 's/\"//g'`
  IPv6DNSLookup=`timeout 2 dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed 's/\"//g'`
  IP_Check="$IPv4DNSLookup"
  if expr "$IP_Check" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
    for i in 1 2 3 4; do
      if [ $(echo "$IP_Check" | cut -d. -f$i) -gt 255 ]; then
        echo "fail ($IP_Check)"
        exit 1
      fi
    done
    IP_Check="isIPv4"
  fi

  IPv6_Check="$IPv6DNSLookup"
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

  [[ "$IP_Check" == "isIPv4" && "$IP6_Check" == "isIPv6" ]] && IPStackType="BioStack"
  [[ "$IP_Check" == "isIPv4" && "$IP6_Check" != "isIPv6" ]] && IPStackType="IPv4Stack"
  [[ "$IP_Check" != "isIPv4" && "$IP6_Check" == "isIPv6" ]] && IPStackType="IPv6Stack"
}

# $1 is $CurrentOS $2 is $CurrentOSVer
function getInterface(){
# Network config file for Ubuntu 16.04 and former version, 
# Debian all version included the latest Debian 11 is deposited in /etc/network/interfaces, they managed by "ifupdown".
# Ubuntu 18.04 and later version, using netplan to replace legacy ifupdown, the network config file is in /etc/netplan
# Some templates of cloud provider like Bandwagonhosts, Ubuntu 22.04, may modify parameters in " GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0" " in /etc/default/grub
# to make Linux kernel redirect names of network adapters from real name like ens18, ens3, enp0s4 to eth0, eth1, eth2...
# This setting may confuse program to get real adapter name from reading /proc/cat/dev
  GrubCmdLine=`grep "GRUB_CMDLINE_LINUX" /etc/default/grub | grep -v "#" | grep "net.ifnames=0\|biosdevname=0"`
# So we need to comfirm whether adapter name is renamed and whether we should inherit it into new system.
  [[ -n "$GrubCmdLine" && -z "$interfaceSelect" ]] && setInterfaceName='1'
  interface=""
  Interfaces=`cat /proc/net/dev |grep ':' |cut -d':' -f1 |sed 's/\s//g' |grep -iv '^lo\|^sit\|^stf\|^gif\|^dummy\|^vmnet\|^vir\|^gre\|^ipip\|^ppp\|^bond\|^tun\|^tap\|^ip6gre\|^ip6tnl\|^teql\|^ocserv\|^vpn'`
  defaultRoute=`ip route show default | grep "^default"`
  for item in `echo "$Interfaces"`; do
    [ -n "$item" ] || continue
    echo "$defaultRoute" | grep -q "$item"
    [ $? -eq 0 ] && interface="$item" && break
  done
  echo "$interface"
  if [[ "$1" == 'Ubuntu' ]] && [[ "$2" -ge "18" ]]; then
    NetCfgDir="/etc/netplan/"
    NetCfgFile=`ls -Sl $NetCfgDir | grep ".yaml" | head -n 1 | awk -F' ' '{print $NF}'`
  elif [[ "$1" == 'CentOS' || "$1" == 'AlmaLinux' || "$1" == 'RockyLinux' || "$1" == 'Fedora' || "$1" == 'Vzlinux' || "$1" == 'OracleLinux' || "$1" == 'OpenCloudOS' || "$1" == 'AlibabaCloudLinux' || "$1" == 'ScientificLinux' ]]; then
    for Count in "/etc/sysconfig/network-scripts/" "/etc/NetworkManager/system-connections/" "/run/NetworkManager/system-connections/" "/usr/lib/NetworkManager/system-connections/" "/run/sysconfig/network-scripts/" "/run/network-scripts/" "/usr/lib/sysconfig/network-scripts/" "/usr/lib/network-scripts/"; do
      NetCfgDir="$Count"
      NetCfgFile=`ls -Sl $NetCfgDir | grep "nmconnection\|ifcfg-*" | grep -iv 'lo\|sit\|stf\|gif\|dummy\|vmnet\|vir\|gre\|ipip\|ppp\|bond\|tun\|tap\|ip6gre\|ip6tnl\|teql\|ocserv\|vpn' | head -n 1 | awk -F' ' '{print $NF}'`
      [[ -n `grep -wlr "BOOTPROTO=*\|DEVICE=*\|ONBOOT=*\|DEFROUTE=*\|id=*\|\[connection\]\|interface-name=*\|method=*" $NetCfgDir*` ]] && break
    done
  else
    for Count in "/run/network/" "/etc/network/"; do
      NetCfgWhole=`grep -wrl "network" | grep -wrl "iface" | grep -wrl "lo" | grep -wrl "inet\|inte6" | grep -wrl "dhcp\|static" $Count* | grep -v "if-*" | grep -v "state"`
      if [[ "$NetCfgWhole" != "" ]] && [[ `grep -c "source /etc/network/interfaces.d/\*" "$NetCfgWhole"` -lt "1" ]]; then
        NetCfgFile=`echo $NetCfgWhole | awk -F/ '{print $NF}'`
        NetCfgDir=`echo $NetCfgWhole | sed "s/$NetCfgFile//g"`
        break
      fi  
    done
  fi
}

# If original system using DHCP, skip IP address, subnet mask, gateway, DNS server settings manually.
# In many DHCP server, manual settings may cause problems.
# $1 is $CurrentOS $2 is $CurrentOSVer
function checkDHCP(){
  getInterface "$CurrentOS" "$CurrentOSVer"
  if [[ "$1" == 'CentOS' || "$1" == 'AlmaLinux' || "$1" == 'RockyLinux' || "$1" == 'Fedora' || "$1" == 'Vzlinux' || "$1" == 'OracleLinux' || "$1" == 'OpenCloudOS' || "$1" == 'AlibabaCloudLinux' || "$1" == 'ScientificLinux' ]]; then
# RedHat like linux system 8 and before network config name is "ifcfg-interface", deposited in /etc/sysconfig/network-scripts/
# RedHat like linux system 9 and later network config name is "interface.nmconnection", deposited in /etc/NetworkManager/system-connections
    if [[ -n `grep -Ewrn "BOOTPROTO=none|BOOTPROTO=\"none\"|BOOTPROTO=\'none\'|BOOTPROTO=NONE|BOOTPROTO=\"NONE\"|BOOTPROTO=\'NONE\'|BOOTPROTO=static|BOOTPROTO=\"static\"|BOOTPROTO=\'static\'|BOOTPROTO=STATIC|BOOTPROTO=\"STATIC\"|BOOTPROTO=\'STATIC\'" $NetCfgDir*` ]] || [[ -n `grep -Ewrn "method=manual" $NetCfgDir*` ]] || [[ "$tmpDHCP" == "static" || "$tmpDHCP" == "manual" || "$tmpDHCP" == "none" || "$tmpDHCP" == "false" || "$tmpDHCP" == "no" || "$tmpDHCP" == "0" ]]; then
      NetworkConfig="isStatic"
    else
      NetworkConfig="isDHCP"
    fi
  elif [[ "$1" == 'Debian' ]] || [[ "$1" == 'Ubuntu' && "$2" -le "16" ]]; then
# Debian network configs may be deposited in the following directions.
# /etc/network/interfaces or /etc/network/interfaces.d/interface or /run/network/interfaces.d/interface
    if [[ `grep -c "inet" $NetCfgDir$NetCfgFile | grep -c "static" $NetCfgDir$NetCfgFile` -ne "0" ]] || [[ `grep -c "inet6" $NetCfgDir$NetCfgFile | grep -c "static" $NetCfgDir$NetCfgFile` -ne "0" ]] || [[ "$tmpDHCP" == "static" || "$tmpDHCP" == "manual" || "$tmpDHCP" == "none" || "$tmpDHCP" == "false" || "$tmpDHCP" == "no" || "$tmpDHCP" == "0" ]]; then
      NetworkConfig="isStatic"
    else
      NetworkConfig="isDHCP"
    fi
  elif [[ "$1" == 'Ubuntu' ]] && [[ "$2" -ge "18" ]]; then
    if [[ `grep -c "dhcp4: false" $NetCfgDir$NetCfgFile` -ne "0" || `grep -c "dhcp4: no" $NetCfgDir$NetCfgFile` -ne "0" || `grep -c "dhcp6: false" $NetCfgDir$NetCfgFile` -ne "0" || `grep -c "dhcp6: no" $NetCfgDir$NetCfgFile` -ne "0" ]] || [[ "$tmpDHCP" == "static" || "$tmpDHCP" == "manual" || "$tmpDHCP" == "none" || "$tmpDHCP" == "false" || "$tmpDHCP" == "no" || "$tmpDHCP" == "0" ]]; then
      NetworkConfig="isStatic"
    else
      NetworkConfig="isDHCP"
    fi
  fi
  [[ "$tmpDHCP" == "dhcp" || "$tmpDHCP" == "auto" || "$tmpDHCP" == "automatic" || "$tmpDHCP" == "true" || "$tmpDHCP" == "yes" || "$tmpDHCP" == "1" ]] && NetworkConfig="isDHCP"
}

function DebianModifiedPreseed(){
  if [[ "$linux_relese" == 'debian' ]]; then
# Must use ";" instead of using "&&", "echo -e" etc to combine multiple commands, or write text in files, recommend sed.
# Can't pass parameters correctly in preseed environment
# DebianVimVer=`ls -a /usr/share/vim | grep vim[0-9]`
    DebianVimVer="vim"`expr ${DebianDistNum} + 71`
    [[ "$DIST" == "bookworm" ]] && DebianVimVer="vim90"
# $1 is "in-target"
    AptUpdating="$1 apt update;"
# pre-install some commonly used software.
    InstallComponents="$1 apt install sudo apt-transport-https bc binutils ca-certificates cron curl debian-keyring debian-archive-keyring dnsutils dosfstools efibootmgr ethtool fail2ban file figlet iptables iptables-persistent iputils-tracepath jq lrzsz libnet-ifconfig-wrapper-perl lsof libnss3 lsb-release mtr-tiny mlocate netcat-openbsd net-tools ncdu nmap ntfs-3g parted psmisc python3 socat sosreport subnetcalc tcpdump telnet traceroute unzip unrar-free uuid-runtime vim vim-gtk3 wget xz-utils -y;"
# In debian 9 and former, some certificates are expired.
    DisableCertExpiredCheck="$1 sed -i '/^mozilla\/DST_Root_CA_X3/s/^/!/' /etc/ca-certificates.conf; $1 update-ca-certificates -f;"
    if [[ "$IsCN" == "cn" ]]; then
# Modify /root/.bashrc to support colorful filename.
      ChangeBashrc="$1 rm -rf /root/.bashrc; $1 wget --no-check-certificate -qO /root/.bashrc 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/.bashrc';"
# Need to install "resolvconf" manually after all installation ended, logged into new system.
# DNS server validation must setting up in installed system, can't in preseeding!
# Set China DNS server from USTC and Tsinghua University permanently
      SetDNS="CNResolvHead"
      DnsChangePermanently="$1 mkdir -p /etc/resolvconf/resolv.conf.d/; $1 wget --no-check-certificate -qO /etc/resolvconf/resolv.conf.d/head 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/${SetDNS}';"
# Modify logging in welcome information(Message Of The Day) of Debian and make it more pretty.
      ModifyMOTD="$1 rm -rf /etc/update-motd.d/ /etc/motd /run/motd.dynamic; $1 mkdir -p /etc/update-motd.d/; $1 wget --no-check-certificate -qO /etc/update-motd.d/00-header 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/updatemotd/00-header'; $1 wget --no-check-certificate -qO /etc/update-motd.d/10-sysinfo 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/updatemotd/10-sysinfo'; $1 wget --no-check-certificate -qO /etc/update-motd.d/90-footer 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/updatemotd/90-footer'; $1 chmod +x /etc/update-motd.d/00-header; $1 chmod +x /etc/update-motd.d/10-sysinfo; $1 chmod +x /etc/update-motd.d/90-footer;"
    else
      ChangeBashrc="$1 rm -rf /root/.bashrc; $1 wget --no-check-certificate -qO /root/.bashrc 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/.bashrc';"
# Set DNS server from CloudFlare and Google permanently
      SetDNS="NomalResolvHead"
      DnsChangePermanently="$1 mkdir -p /etc/resolvconf/resolv.conf.d/; $1 wget --no-check-certificate -qO /etc/resolvconf/resolv.conf.d/head 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/${SetDNS}';"
      ModifyMOTD="$1 rm -rf /etc/update-motd.d/ /etc/motd /run/motd.dynamic; $1 mkdir -p /etc/update-motd.d/; $1 wget --no-check-certificate -qO /etc/update-motd.d/00-header 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/updatemotd/00-header'; $1 wget --no-check-certificate -qO /etc/update-motd.d/10-sysinfo 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/updatemotd/10-sysinfo'; $1 wget --no-check-certificate -qO /etc/update-motd.d/90-footer 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/updatemotd/90-footer'; $1 chmod +x /etc/update-motd.d/00-header; $1 chmod +x /etc/update-motd.d/10-sysinfo; $1 chmod +x /etc/update-motd.d/90-footer;"
    fi
# Set parameter "mouse-=a" in /usr/share/vim/vim-version/defaults.vim to support copy text from terminal to client.
    VimSupportCopy="$1 sed -i 's/set mouse=a/set mouse-=a/g' /usr/share/vim/${DebianVimVer}/defaults.vim;"
# If the network config type of server is DHCP and it have both public IPv4 and IPv6 address,
# Debian install program even get nerwork config with DHCP, but after log into new system,
# only the IPv4 of the server has been configurated.
# so need to write "iface interface inet6 dhcp" to /etc/network/interfaces in preseeding process,
# to avoid config IPv6 manually after log into new system.
    SupportIPv6=""
    if [[ "$NetworkConfig" == "isDHCP" ]]; then
# This IPv4Stack DHCP machine can access IPv6 network in the future, maybe.
      SupportIPv6="$1 sed -i '\$aiface $interface inet6 dhcp' /etc/network/interfaces"
# Enable IPv6 dhcp and set prefer IPv6 access for BioStack or IPv6Stack machine: add "label 2002::/16" in last line of the "/etc/gai.conf"
      [[ "$IPStackType" == "BioStack" || "$IPStackType" == "IPv6Stack" ]] && SupportIPv6="$1 sed -i '\$aiface $interface inet6 dhcp' /etc/network/interfaces; $1 sed -i '\$alabel 2002::/16   2' /etc/gai.conf"
    elif [[ "$NetworkConfig" == "isStatic" ]]; then
      [[ "$IPStackType" == "BioStack" || "$IPStackType" == "IPv6Stack" ]] && SupportIPv6="$1 sed -i '\$aiface $interface inet6 static' /etc/network/interfaces; $1 sed -i '\$a\\\taddress $ip6Addr' /etc/network/interfaces; $1 sed -i '\$a\\\tgateway $ip6Gate' /etc/network/interfaces; $1 sed -i '\$a\\\tnetmask $ip6Mask' /etc/network/interfaces; $1 sed -i '\$a\\\tdns-nameservers $ip6DNS' /etc/network/interfaces; $1 sed -i '\$alabel 2002::/16   2' /etc/gai.conf"
# a typical network configuration sample of IPv6 static for Debian:
# iface eth0 inet static
#         address 10.0.0.72
#         gateway 10.0.0.1
#         netmask 255.255.255.0
#         dns-nameservers 1.0.0.1 8.4.4.8
#
# a typical network configuration sample of IPv6 static for Debian:
# iface eth0 inet6 static
#         address 2702:b43c:492a:9d1e:8270:fd59:6de4:20f1
#         gateway fe80::200:17ff:fe9e:f9d0
#         netmask 128
#         dns-nameservers 2606:4700:4700::1001
    fi
    [[ "$setRaid" == "0" ]] && FormatDisk=`echo -e "d-i partman-md/confirm boolean true
d-i partman-md/confirm_nooverwrite boolean true
d-i partman-basicfilesystems/no_swap boolean false
d-i partman/mount_style select label
d-i partman-auto/method string raid
d-i partman-auto/disk string "$IncDisk" /dev/sdb
d-i partman-auto-raid/recipe string          \
    1 2 0 ext4 /boot "$IncDisk"1#/dev/sdb1 . \
    0 2 0 ext4 /     "$IncDisk"2#/dev/sdb2 .
d-i partman-auto/expert_recipe string multiraid ::                 \
    400 100 400 raid \\$bootable{ } \\$primary{ } method{ raid } . \
    100 200  -1 raid                \\$primary{ } method{ raid } .
d-i mdadm/boot_degraded boolean true"`
# Raid 0 partition recipe:
# d-i partman-md/confirm boolean true
# d-i partman-md/confirm_nooverwrite boolean true
# d-i partman-basicfilesystems/no_swap boolean false
# d-i partman/mount_style select label
# d-i partman-auto/method string raid
# d-i partman-auto/disk string /dev/sda /dev/sdb
# d-i partman-auto-raid/recipe string        \
#     1 2 0 ext4 /boot /dev/sda1#/dev/sdb1 . \
#     0 2 0 ext4 /     /dev/sda2#/dev/sdb2 .
# d-i partman-auto/expert_recipe string multiraid ::               \
#     400 100 400 raid \$bootable{ } \$primary{ } method{ raid } . \
#     100 200  -1 raid               \$primary{ } method{ raid } .
# d-i mdadm/boot_degraded boolean true
    export DebianModifiedProcession="${AptUpdating} ${InstallComponents} ${DisableCertExpiredCheck} ${ChangeBashrc} ${VimSupportCopy} ${DnsChangePermanently} ${ModifyMOTD} ${SupportIPv6}"
  fi
}

function DebianPreseedProcess(){
# Default to make a GPT partition to support 3TB hard drive or larger.
FormatDisk=`echo -e "d-i partman/mount_style select uuid\nd-i partman-auto/method string regular\nd-i partman-auto/init_automatically_partition select Guided - use entire disk\nd-i partman-auto/choose_recipe select All files in one partition (recommended for new users)\nd-i partman-basicfilesystems/choose_label string gpt\nd-i partman-basicfilesystems/default_label string gpt\nd-i partman-partitioning/choose_label string gpt\nd-i partman-partitioning/default_label string gpt\nd-i partman/choose_label string gpt\nd-i partman/default_label string gpt"`
# Default disk format recipe:
# d-i partman/mount_style select uuid
# d-i partman-auto/method string regular
# d-i partman-auto/init_automatically_partition select Guided - use entire disk
# d-i partman-auto/choose_recipe select All files in one partition (recommended for new users)
# d-i partman-basicfilesystems/choose_label string gpt
# d-i partman-basicfilesystems/default_label string gpt
# d-i partman-partitioning/choose_label string gpt
# d-i partman-partitioning/default_label string gpt
# d-i partman/choose_label string gpt
# d-i partman/default_label string gpt
[[ "$NetworkConfig" == "isDHCP" ]] && NetConfigManually="" || NetConfigManually=`echo -e "d-i netcfg/disable_autoconfig boolean true\nd-i netcfg/dhcp_failed note\nd-i netcfg/dhcp_options select Configure network manually\nd-i netcfg/get_ipaddress string $IPv4\nd-i netcfg/get_netmask string $MASK\nd-i netcfg/get_gateway string $GATE\nd-i netcfg/get_nameservers string $ipDNS\nd-i netcfg/no_default_route boolean true\nd-i netcfg/confirm_static boolean true"`
# Manually network setting configurations, including:
# d-i netcfg/disable_autoconfig boolean true
# d-i netcfg/dhcp_failed note
# d-i netcfg/dhcp_options select Configure network manually
# d-i netcfg/get_ipaddress string $IPv4
# d-i netcfg/get_netmask string $MASK
# d-i netcfg/get_gateway string $GATE
# d-i netcfg/get_nameservers string $ipDNS
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

### Windows DD installation set up
d-i preseed/early_command string anna-install libfuse2-udeb fuse-udeb ntfs-3g-udeb libcrypto1.1-udeb libpcre2-8-0-udeb libssl1.1-udeb libuuid1-udeb zlib1g-udeb wget-udeb
d-i partman/early_command string [[ -n "\$(blkid -t TYPE='vfat' -o device)" ]] && umount "\$(blkid -t TYPE='vfat' -o device)"; \
debconf-set partman-auto/disk "\$(list-devices disk |head -n1)"; \
wget -qO- '$DDURL' | $DEC_CMD | /bin/dd of=\$(list-devices disk |head -n1); \
mount.ntfs-3g \$(list-devices partition |head -n1) /mnt; \
cd '/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs'; \
cd Start* || cd start*; \
cp -f '/net.bat' './net.bat'; \
/sbin/reboot; \
umount /media || true; \

### Partitioning
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman/default_filesystem string xfs
d-i partman-md/device_remove_md boolean true
${FormatDisk}

### Package selection
tasksel tasksel/first multiselect minimal
# Automatic updates are not applied, everything is updated manually.
d-i pkgsel/update-policy select none
d-i pkgsel/include string openssh-server
d-i pkgsel/upgrade select none

### Disable to upload developer statistics anonymously
popularity-contest popularity-contest/participate boolean false

### Grub
d-i grub-installer/only_debian boolean true
d-i grub-installer/bootdev string $IncDisk
d-i grub-installer/force-efi-extra-removable boolean true
d-i debian-installer/add-kernel-opts string net.ifnames=0 biosdevname=0

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
}

checkSys

# Get the name of network adapter($interface).
# [[ -z "$interface" ]] && interface=`getInterface "$CurrentOSCurrentOS" "$CurrentOSVer"`
# Try to enable IPv4 by DHCP
# timeout 5 dhclient -4 $interface
# Try to enable IPv6 by DHCP
# timeout 5 dhclient -6 $interface

checkIpv4OrIpv6

# Youtube, Instagram and Wikipedia all have public IPv4 and IPv6 address and are also banned in mainland China.
checkCN "www.youtube.com" "www.instagram.com" "www.wikipedia.org" "$IPStackType"

checkEfi "/sys/firmware/efi/efivars/" "/sys/firmware/efi/mok-variables/" "/sys/firmware/efi/runtime-map/" "/sys/firmware/efi/vars/"

if [[ ! ${sshPORT} -ge "1" ]] || [[ ! ${sshPORT} -le "65535" ]] || [[ `grep '^[[:digit:]]*$' <<< '${sshPORT}'` ]]; then
  sshPORT='22'
fi

# Disable SELinux
if [ -f /etc/selinux/config ]; then
  SELinuxStatus=$(sestatus -v | grep "SELinux status:" | grep enabled)
  [[ "$SELinuxStatus" != "" ]] && echo -e "\033[36mDisabled SELinux\033[0m" && setenforce 0
fi

[[ ! -d "/tmp/" ]] && mkdir /tmp

if [[ "$loaderMode" == "0" ]]; then
  checkGrub "/boot/grub/" "/boot/grub2/" "/etc/" "grub.cfg" "grub.conf" "/boot/efi/EFI/"
  if [[ -z "$GRUBTYPE" ]]; then
    echo -ne "\n\033[31mError: \033[0mNot Found grub.\n"
    exit 1
  fi
fi

[ -n "$Relese" ] || Relese='Debian'
linux_relese=$(echo "$Relese" |sed 's/\ //g' |sed -r 's/(.*)/\L\1/')
clear && echo -e "\n\033[36m# Check Dependence\033[0m\n"

dependence awk,basename,cat,cpio,curl,cut,dig,dirname,efibootmgr,file,find,grep,gzip,jq,lsblk,sed,wget,xz;

if [[ "$ddMode" == '1' ]]; then
  dependence iconv;
  linux_relese='debian';
  tmpDIST='bookworm';
  tmpVER='';
fi

if [[ "$IPStackType" == "IPv4Stack" ]]; then
  [[ -n "$ipAddr" && -n "$ipMask" && -n "$ipGate" ]] && setNet='1'
else
  [[ -n "$ipAddr" && -n "$ipMask" && -n "$ipGate" && -n "$ip6Addr" && -n "$ip6Mask" && -n "$ip6Gate" ]] && setNet='1'
fi
if [[ "$setNet" == "0" ]]; then
  dependence ip
  [[ -n "$interface" ]] || interface=`getInterface "$CurrentOS" "$CurrentOSVer"`
  iAddr=`ip addr show | grep -wv "lo\|host" | grep -w "inet" | grep "$interface" | grep -w "scope global*\|link*" | head -n 1 | awk -F " " '{for (i=2;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
  ipAddr=`echo ${iAddr} | cut -d'/' -f1`
  ipMask=`netmask $(echo ${iAddr} | cut -d'/' -f2)`
# In most situation, at least 99.9% probability, the first hop of the network should be the same as the available gateway. 
# But in 0.1%, they are actually different. 
# Because one of the first hop of a tested machine is 5.45.72.1, I told Debian installer this router as a gateway 
# But installer said the correct gateway should be 5.45.76.1, in a typical network, for example, your home, 
# the default gateway is the same as the first route hop of the machine, it may be 192.168.0.1.
# If possible, we should configure out the real available gateway of the network.
  FirstRoute=`ip route show default | grep -w "via" | grep -w "dev $interface*" | head -n 1 | awk -F " " '{for (i=3;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
# We should find it in ARP, the first hop IP and gateway IP is managed by the same device, use device mac address to configure it out.
  RouterMac=`arp -n | grep "$FirstRoute" | awk '{print$3}'`
  FrFirst=`echo "$FirstRoute" | cut -d'.' -f 1,2`
  FrThird=`echo "$FirstRoute" | cut -d'.' -f 3`
# Print all matched available gateway.
  ipGates=`ip route show | grep -v "via" | grep -w "dev $interface*" | grep -w "proto*" | grep -w "scope global\|link src $ipAddr*" | awk '{print$1}'`
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

  [[ ! "$IPStackType" == "IPv4Stack" ]] && {
    i6Addr=`ip -6 addr show | grep -wv "lo\|host" | grep -wv "link" | grep -w "inet6" | grep "scope" | grep "global" | head -n 1 | awk -F " " '{for (i=2;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
    ip6Addr=`echo ${i6Addr} |cut -d'/' -f1`
    ip6Mask=`echo ${i6Addr} |cut -d'/' -f2`
    ip6Gate=`ip -6 route show default | grep -w "via" | grep -w "$interface" | grep "dev" | head -n 1 | awk -F " " '{for (i=3;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}'`
  }
fi
if [ -z "$interface" ]; then
  dependence ip
  [ -n "$interface" ] || interface=`getInterface "$CurrentOS" "$CurrentOSVer"`
fi
IPv4="$ipAddr"; MASK="$ipMask"; GATE="$ipGate";
if [[ -z "$IPv4" && -z "$MASK" && -z "$GATE" ]]; then
  echo -ne "\n\033[31mError: \033[0mThe network of your machine may not be available!\n"
  bash $0 error
  exit 1
fi
checkDHCP "$CurrentOS" "$CurrentOSVer"
getUserTimezone "/root/timezonelists" "ZGEyMGNhYjhhMWM2NDJlMGE0YmZhMDVmMDZlNzBmN2E=" "ZTNlMjBiN2JjOTE2NGY2YjllNzUzYWU5ZDFjYjdjOTc=" "MWQ2NGViMGQ4ZmNlNGMzYTkxYjNiMTdmZDMxODQwZDc="

[ -n "$tmpWORD" ] && dependence openssl
[[ -n "$tmpWORD" ]] && myPASSWORD="$(openssl passwd -1 "$tmpWORD")";
[[ -z "$myPASSWORD" ]] && myPASSWORD='$1$OCy2O5bt$m2N6XMgFUwCn/2PPP114J/';

tempDisk=`getDisk`
[ -n "$tempDisk" ] && IncDisk="$tempDisk"
[[ "$setRaid" == "0" ]] && IncDisk="/dev/sda"

# Get architecture of current os automatically
ArchName=`uname -m`
[[ -z "$ArchName" ]] && ArchName=$(echo `hostnamectl status | grep "Architecture" | cut -d':' -f 2`)
case $ArchName in arm64) VER="arm64";; aarch64) VER="aarch64";; x86|i386|i686) VER="i386";; x86_64) VER="x86_64";; amd64) VER="amd64";; *) VER="";; esac
# Exchange architecture name
if [[ "$linux_relese" == "debian" ]] || [[ "$linux_relese" == "ubuntu" ]]; then
  if [[ "$VER" == "x86_64" ]]; then
    VER="amd64"
  elif [[ "$VER" == "aarch64" ]]; then
    VER="arm64"
  fi
elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
  if [[ "$VER" == "amd64" ]]; then
    VER="x86_64"
  elif [[ "$VER" == "arm64" ]]; then
    VER="aarch64"
  fi
fi

# Check and exchange input architecture name
tmpVER="$(echo "$tmpVER" |sed -r 's/(.*)/\L\1/')";
if [[ -n "$tmpVER" ]]; then
  case "$tmpVER" in
    i386|i686|x86|32)
      VER="i386"
      ;;
    amd64|x86_64|x64|64)
      [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]] && VER='x86_64' || VER='amd64'
      ;;
    aarch64|arm64|arm)
      [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]] && VER='aarch64' || VER='arm64'
      ;;
    *)
      VER=''
      ;;
  esac
fi

if [[ ! -n "$VER" ]]; then
  echo -ne "\n\033[31mError: \033[0mUnknown architecture.\n"
  bash $0 error;
  exit 1;
fi

if [[ -z "$tmpDIST" ]]; then
  [ "$Relese" == 'Debian' ] && tmpDIST='12'
  [ "$Relese" == 'Ubuntu' ] && tmpDIST='20.04'
  [ "$Relese" == 'CentOS' ] && tmpDIST='9'
  [ "$Relese" == 'RockyLinux' ] && tmpDIST='9'
  [ "$Relese" == 'AlmaLinux' ] && tmpDIST='9'
  [ "$Relese" == 'Fedora' ] && tmpDIST='37'
fi

if [[ -n "$tmpDIST" ]]; then
  if [[ "$Relese" == 'Debian' ]]; then
    SpikCheckDIST='0'
    DIST="$(echo "$tmpDIST" |sed -r 's/(.*)/\L\1/')"
    DebianDistNum="${DIST}"
    echo "$DIST" |grep -q '[0-9]'
    [[ $? -eq '0' ]] && {
      isDigital="$(echo "$DIST" |grep -o '[\.0-9]\{1,\}' |sed -n '1h;1!H;$g;s/\n//g;$p' |cut -d'.' -f1)";
      [[ -n $isDigital ]] && {
        [[ "$isDigital" == '7' ]] && DIST='wheezy';
        [[ "$isDigital" == '8' ]] && DIST='jessie';
        [[ "$isDigital" == '9' ]] && DIST='stretch';
        [[ "$isDigital" == '10' ]] && DIST='buster';
        [[ "$isDigital" == '11' ]] && DIST='bullseye';
        [[ "$isDigital" == '12' ]] && DIST='bookworm';
        # [[ "$isDigital" == '13' ]] && DIST='trixie';
        # [[ "$isDigital" == '14' ]] && DIST='forky';
      }
    }
    LinuxMirror=$(selectMirror "$Relese" "$DIST" "$VER" "$tmpMirror")
  fi
  if [[ "$Relese" == 'Ubuntu' ]]; then
    SpikCheckDIST='0'
    DIST="$(echo "$tmpDIST" |sed -r 's/(.*)/\L\1/')"
    UbuntuDistNum=`echo "$DIST" | cut -d'.' -f1`
    echo "$DIST" |grep -q '[0-9]'
    [[ $? -eq '0' ]] && {
      isDigital="$(echo "$DIST" |grep -o '[\.0-9]\{1,\}' |sed -n '1h;1!H;$g;s/\n//g;$p')";
      [[ -n $isDigital ]] && {
        [[ "$isDigital" == '12.04' ]] && DIST='precise';
        [[ "$isDigital" == '14.04' ]] && DIST='trusty';
        [[ "$isDigital" == '16.04' ]] && DIST='xenial';
        [[ "$isDigital" == '18.04' ]] && DIST='bionic';
        [[ "$isDigital" == '20.04' ]] && DIST='focal';
# Ubuntu 22.04 and future versions started to using "Cloud-init" to replace legacy "d-i(Debian installer)" which is designed to support network installation of Debian like system.
# "Cloud-init" make a high hardware requirements of the server, one requirement must be demanded is CPU virtualization support.
# Many vps which are virtualizated by a physical machine, despite parent machine support virtualization, but sub-servers don't support.
# Because Ubuntu 22.04 and future version removed critical file of "initrd.gz" and "linux" which are critical files to implement "d-i".
# For example, the official of Ubuntu 22.04(jammy) mirror site doesn't provide any related files to download, the following is here:
# http://archive.ubuntu.com/ubuntu/dists/jammy/main/installer-amd64/current/legacy-images/
# So we have no possibility to accomplish Ubuntu network installation in future.
# Canonical.inc is son of a bitch, they change back and forth, pood and pee everywhere.
# More discussions: https://discourse.ubuntu.com/t/netbooting-the-live-server-installer/14510/18
       # [[ "$isDigital" == '22.04' ]] && DIST='jammy';
      }
    }
    LinuxMirror=$(selectMirror "$Relese" "$DIST" "$VER" "$tmpMirror")
  fi
  if [[ "$Relese" == 'CentOS' ]] || [[ "$Relese" == 'RockyLinux' ]] || [[ "$Relese" == 'AlmaLinux' ]] || [[ "$Relese" == 'Fedora' ]]; then
    SpikCheckDIST='1'
    DISTCheck="$(echo "$tmpDIST" |grep -o '[\.0-9]\{1,\}' |head -n1)"
    RedHatSeries=`echo "$tmpDIST" | cut -d"." -f 1 | cut -d"-" -f 1`
    if [[ "$linux_relese" == 'centos' ]]; then
      [[ "$RedHatSeries" =~ [0-9]{${#1}} ]] && {
        if [[ "$RedHatSeries" == "6" ]]; then
          DISTCheck="6.10"
          echo -ne "\n\033[33mWarning: \033[0m$Relese $DISTCheck is not supported!\n"
          exit 1
        elif [[ "$RedHatSeries" == "7" ]]; then
          DISTCheck="7.9.2009"
        elif [[ "$RedHatSeries" -ge "8" ]] && [[ ! "$RedHatSeries" =~ "-stream" ]]; then
          DISTCheck="$RedHatSeries""-stream"
        elif [[ "$RedHatSeries" -le "5" ]]; then
          echo -ne "\n\033[33mWarning: \033[0m$Relese $DISTCheck is not supported!\n"
        else
          echo -ne "\n\033[33mError: \033[0mInvaild $DIST! version!\n"
        fi
      }
      LinuxMirror=$(selectMirror "$Relese" "$DISTCheck" "$VER" "$tmpMirror")
      DIST="$DISTCheck"
    fi
    if [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
      [[ "$RedHatSeries" =~ [0-9]{${#1}} ]] && {
        if [[ "$linux_relese" == 'rockylinux' || "$linux_relese" == 'almalinux' ]] && [[ "$RedHatSeries" -le "7" ]]; then
          echo -ne "\n\033[33mWarning: \033[0m$Relese $DISTCheck is not supported!\n"
          exit 1
        elif [[ "$linux_relese" == 'fedora' ]] && [[ "$RedHatSeries" -le "33" ]]; then
          echo -ne "\n\033[33mWarning: \033[0m$Relese $DISTCheck is not supported!\n"
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
        echo -ne "\n\033[33mWarning: \033[0m$Relese $DISTCheck was not found in this mirror, Please change mirror try again!\n"
        exit 1
      }
    elif [[ "$linux_relese" == 'centos' && "$RedHatSeries" -ge "8" ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]]; then
      wget --no-check-certificate -qO- "$LinuxMirror/$DIST/BaseOS/$VER/os/media.repo" | grep -q 'mediaid'
      [[ $? != '0' ]] && {
        echo -ne "\n\033[33mWarning: \033[0m$Relese $DISTCheck was not found in this mirror, Please change mirror try again!\n"
        exit 1
      }
    elif [[ "$linux_relese" == 'fedora' ]]; then
      wget --no-check-certificate -qO- "$LinuxMirror/releases/$DIST/Server/$VER/os/media.repo" | grep -q 'mediaid'
      [[ $? != '0' ]] && {
        echo -ne "\n\033[33mWarning: \033[0m$Relese $DISTCheck was not found in this mirror, Please change mirror try again!\n"
        exit 1
      }
    fi    
  fi
fi

if [[ -z "$LinuxMirror" ]]; then
  echo -ne "\033[31mError! \033[0mInvaild mirror! \n"
  [ "$Relese" == 'Debian' ] && echo -en "\033[33mPlease check mirror lists:\033[0m https://www.debian.org/mirror/list\n\n"
  [ "$Relese" == 'Ubuntu' ] && echo -en "\033[33mPlease check mirror lists:\033[0m https://launchpad.net/ubuntu/+archivemirrors\n\n";
  [ "$Relese" == 'CentOS' ] && echo -en "\033[33mPlease check mirror lists:\033[0m https://www.centos.org/download/mirrors/\n\n"
  [ "$Relese" == 'RockyLinux' ] && echo -en "\033[33mPlease check mirror lists:\033[0m https://mirrors.rockylinux.org/mirrormanager/mirrors\n\n"
  [ "$Relese" == 'AlmaLinux' ] && echo -en "\033[33mPlease check mirror lists:\033[0m https://mirrors.almalinux.org/\n\n"
  [ "$Relese" == 'Fedora' ] && echo -en "\033[33mPlease check mirror lists:\033[0m https://mirrors.fedoraproject.org/\n\n"
  bash $0 error;
  exit 1;
fi

if [[ "$SpikCheckDIST" == '0' ]]; then
  echo -e "\n\033[36mCheck DIST\033[0m"
  DistsList="$(wget --no-check-certificate -qO- "$LinuxMirror/dists/" |grep -o 'href=.*/"' |cut -d'"' -f2 |sed '/-\|old\|Debian\|experimental\|stable\|test\|sid\|devel/d' |grep '^[^/]' |sed -n '1h;1!H;$g;s/\n//g;s/\//\;/g;$p')";
  for CheckDEB in `echo "$DistsList" |sed 's/;/\n/g'`
    do
      [[ "$CheckDEB" == "$DIST" ]] && FindDists='1' && break;
    done
  [[ "$FindDists" == '0' ]] && {
    echo -ne '\n\033[31mError! \033[0mThe dists version not found, Please check it! \n\n'
    bash $0 error;
    exit 1;
  }
  echo -e "\nSuccess"
fi

if [[ "$ddMode" == '1' ]]; then
  if [[ -n "$tmpURL" ]]; then
    DDURL="$tmpURL"
    echo "$DDURL" | grep -q '^http://\|^ftp://\|^https://';
    [[ $? -ne '0' ]] && echo 'Please input vaild URL, Only support http://, ftp:// and https:// !' && exit 1;
    # Decompress command selection
    if [[ "$setFileType" == "gz" ]]; then
      DEC_CMD="gunzip -dc"
      [[ $(echo "$DDURL" | grep -o ...$) == ".xz" ]] && DEC_CMD="xzcat"
    elif [[ "$setFileType" == "xz" ]]; then
      DEC_CMD="xzcat"
      [[ $(echo "$DDURL" | grep -o ...$) == ".gz" ]] && DEC_CMD="gunzip -dc"
    else
      DEC_CMD="gunzip -dc"
    fi
  else
    echo 'Please input a vaild image URL!';
    exit 1;
  fi
fi

clear && echo -e "\n\033[36m# Install\033[0m\n"

[[ "$ddMode" == '1' ]] && echo -ne "\033[34mAuto Mode\033[0m insatll \033[33mWindows\033[0m\n[\033[33m$DDURL\033[0m]\n"

if [ -z "$interfaceSelect" ]; then
  if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]]; then
    interfaceSelect="auto"
  elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
    interfaceSelect="link"
  fi
else
# If the kernel of original system is loaded with parameter "net.ifnames=0 biosdevname=0" and users don't want to set this
# one in new system, they have to assign a valid, real name of their network adapter and the parameter "$interface"
# will be written to new network configuration in preseed file for new system.
  interface="$interfaceSelect"
fi
# The first network adapter name is must be "eth0" if kernel is loaded with parameter "net.ifnames=0 biosdevname=0". 
[[ "$setInterfaceName" == "1" ]] && interface="eth0"

if [[ "$linux_relese" == 'centos' ]]; then
  if [[ "$DIST" != "$UNVER" ]]; then
    awk 'BEGIN{print '${UNVER}'-'${DIST}'}' |grep -q '^-'
    if [ $? != '0' ]; then
      UNKNOWHW='1';
      echo -en "\033[33mThe version lower then \033[31m$UNVER\033[33m may not support in auto mode! \033[0m\n";
    fi
  fi
fi
echo -e "\n[\033[33m$Relese\033[0m] [\033[33m$DIST\033[0m] [\033[33m$VER\033[0m] Downloading...\n"

# RAM of RedHat series is 2GB required at least.
checkMem "$linux_relese" "$RedHatSeries"

if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]]; then
  [ "$DIST" == "focal" ] && legacy="legacy-" || legacy=""
  InitrdUrl="${LinuxMirror}/dists/${DIST}/main/installer-${VER}/current/${legacy}images/netboot/${linux_relese}-installer/${VER}/initrd.gz"
  VmLinuzUrl="${LinuxMirror}/dists/${DIST}${inUpdate}/main/installer-${VER}/current/${legacy}images/netboot/${linux_relese}-installer/${VER}/linux"
  echo -e "[\033[33mMirror\033[0m] $InitrdUrl\n\t $VmLinuzUrl\n"
  wget --no-check-certificate -qO '/tmp/initrd.img' "$InitrdUrl"
  [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'initrd.img' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
  wget --no-check-certificate -qO '/tmp/vmlinuz' "$VmLinuzUrl"
  [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'vmlinuz' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
  MirrorHost="$(echo "$LinuxMirror" |awk -F'://|/' '{print $2}')";
  MirrorFolder="$(echo "$LinuxMirror" |awk -F''${MirrorHost}'' '{print $2}')";
  [ -n "$MirrorFolder" ] || MirrorFolder="/"
elif [[ "$linux_relese" == 'centos' ]] && [[ "$RedHatSeries" -le "7" ]]; then
  InitrdUrl="${LinuxMirror}/${DIST}/os/${VER}/images/pxeboot/initrd.img"
  VmLinuzUrl="${LinuxMirror}/${DIST}/os/${VER}/images/pxeboot/vmlinuz"
  echo -e "[\033[33mMirror\033[0m] $InitrdUrl\n\t $VmLinuzUrl\n"
  wget --no-check-certificate -qO '/tmp/initrd.img' "$InitrdUrl"
  [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'initrd.img' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
  wget --no-check-certificate -qO '/tmp/vmlinuz' "$VmLinuzUrl"
  [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'vmlinuz' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
elif [[ "$linux_relese" == 'centos' && "$RedHatSeries" -ge "8" ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]]; then
  InitrdUrl="${LinuxMirror}/${DIST}/BaseOS/${VER}/os/images/pxeboot/initrd.img"
  VmLinuzUrl="${LinuxMirror}/${DIST}/BaseOS/${VER}/os/images/pxeboot/vmlinuz"
  echo -e "[\033[33mMirror\033[0m] $InitrdUrl\n\t $VmLinuzUrl\n"
  wget --no-check-certificate -qO '/tmp/initrd.img' "$InitrdUrl"
  [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'initrd.img' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
  wget --no-check-certificate -qO '/tmp/vmlinuz' "$VmLinuzUrl"
  [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'vmlinuz' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
elif [[ "$linux_relese" == 'fedora' ]]; then
  InitrdUrl="${LinuxMirror}/releases/${DIST}/Server/${VER}/os/images/pxeboot/initrd.img"
  VmLinuzUrl="${LinuxMirror}/releases/${DIST}/Server/${VER}/os/images/pxeboot/vmlinuz"
  echo -e "[\033[33mMirror\033[0m] $InitrdUrl\n\t $VmLinuzUrl\n"
  wget --no-check-certificate -qO '/tmp/initrd.img' "$InitrdUrl"
  [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'initrd.img' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
  wget --no-check-certificate -qO '/tmp/vmlinuz' "$VmLinuzUrl"
  [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'vmlinuz' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
else
  bash $0 error;
  exit 1;
fi
if [[ "$linux_relese" == 'debian' ]]; then
  [[ "$IsCN" == "cn" ]] && FirmwareImage="cn"
  if [[ "$IncFirmware" == '1' ]]; then	
    if [[ "$FirmwareImage" == "cn" ]]; then
      wget --no-check-certificate -qO '/tmp/firmware.cpio.gz' "https://mirrors.ustc.edu.cn/debian-cdimage/unofficial/non-free/firmware/${DIST}/current/firmware.cpio.gz"
      [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'firmware' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
    elif [[ "$FirmwareImage" == '' ]]; then
      wget --no-check-certificate -qO '/tmp/firmware.cpio.gz' "http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/${DIST}/current/firmware.cpio.gz"
      [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'firmware' for \033[33m$linux_relese\033[0m failed! \n" && exit 1
    fi
  fi
  if [[ "$ddMode" == '1' ]]; then
    vKernel_udeb=$(wget --no-check-certificate -qO- "http://$LinuxMirror/dists/$DIST/main/installer-$VER/current/images/udeb.list" |grep '^acpi-modules' |head -n1 |grep -o '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}-[0-9]\{1,2\}' |head -n1)
    [[ -z "vKernel_udeb" ]] && vKernel_udeb="5.19.0-1"
  fi
fi

[[ -d /tmp/boot ]] && rm -rf /tmp/boot;
mkdir -p /tmp/boot;
cd /tmp/boot;

if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]]; then
  COMPTYPE="gzip";
elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
  COMPTYPE="$(file ../initrd.img |grep -o ':.*compressed data' |cut -d' ' -f2 |sed -r 's/(.*)/\L\1/' |head -n1)"
  [[ -z "$COMPTYPE" ]] && echo "Detect compressed type fail." && exit 1;
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
[[ "$CompDected" != '1' ]] && echo "Detect compressed type not support." && exit 1;
[[ "$COMPTYPE" == 'lzma' ]] && UNCOMP='xz --format=lzma --decompress';
[[ "$COMPTYPE" == 'xz' ]] && UNCOMP='xz --decompress';
[[ "$COMPTYPE" == 'gzip' ]] && UNCOMP='gzip -d';
$UNCOMP < /tmp/$NewIMG | cpio --extract --verbose --make-directories --no-absolute-filenames >>/dev/null 2>&1

if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]]; then
  DebianPreseedProcess
  if [[ "$loaderMode" != "0" ]] && [[ "$setNet" == '0' ]]; then
    sed -i '/netcfg\/disable_autoconfig/d' /tmp/boot/preseed.cfg
    sed -i '/netcfg\/dhcp_options/d' /tmp/boot/preseed.cfg
    sed -i '/netcfg\/get_.*/d' /tmp/boot/preseed.cfg
    sed -i '/netcfg\/confirm_static/d' /tmp/boot/preseed.cfg
  fi
  if [[ "$linux_relese" == 'debian' ]]; then
    sed -i '/user-setup\/allow-password-weak/d' /tmp/boot/preseed.cfg
    sed -i '/user-setup\/encrypt-home/d' /tmp/boot/preseed.cfg
    sed -i '/pkgsel\/update-policy/d' /tmp/boot/preseed.cfg
    sed -i 's/umount\ \/media.*true\;\ //g' /tmp/boot/preseed.cfg
    [[ -f '/tmp/firmware.cpio.gz' ]] && gzip -d < /tmp/firmware.cpio.gz | cpio --extract --verbose --make-directories --no-absolute-filenames >>/dev/null 2>&1
# Debian 8 and former or Raid 0 mode don't support xfs.
    [[ "$DebianDistNum" -le "8" || "$setRaid" == "0" ]] && sed -i '/d-i\ partman\/default_filesystem string xfs/d' /tmp/boot/preseed.cfg
  fi
# To avoid to entry into low memory mode, Debian 10 needs at least 512M memory and more, Debian 11 needs at least 768MB memory and more. 
  if [[ "$DebianDistNum" == "11" ]]; then
    [[ "$TotalMem1" -ge "768000" || "$TotalMem2" -ge "768000" ]] && sed -i '/d-i\ lowmem\/low boolean true/d' /tmp/boot/preseed.cfg
  elif [[ "$DebianDistNum" == "10" ]]; then
    [[ "$TotalMem1" -ge "512000" || "$TotalMem2" -ge "512000" ]] && sed -i '/d-i\ lowmem\/low boolean true/d' /tmp/boot/preseed.cfg
  elif [[ "$DebianDistNum" -le "9" ]]; then
    sed -i '/d-i\ lowmem\/low boolean true/d' /tmp/boot/preseed.cfg
  fi
# Ubuntu 20.04 and below does't support xfs, force grub-efi installation to the removable media path may cause grub install failed, low memory mode.
  if [[ "$linux_relese" == 'ubuntu' ]]; then
    sed -i '/d-i\ partman\/default_filesystem string xfs/d' /tmp/boot/preseed.cfg
    sed -i '/d-i\ grub-installer\/force-efi-extra-removable/d' /tmp/boot/preseed.cfg
    sed -i '/d-i\ lowmem\/low boolean true/d' /tmp/boot/preseed.cfg
  fi
# Static network environment doesn't support ntp clock setup.
  if [[ "$NetworkConfig" == "isStatic" ]]; then
    sed -i 's/ntp boolean true/ntp boolean false/g' /tmp/boot/preseed.cfg
    sed -i '/d-i\ clock-setup\/ntp-server string ntp.nict.jp/d' /tmp/boot/preseed.cfg
  fi
# If network adapter is not redirected, delete this setting to new system.
  [[ "$setInterfaceName" == "0" ]] && sed -i '/d-i\ debian-installer\/add-kernel-opts string net.ifnames=0 biosdevname=0/d' /tmp/boot/preseed.cfg

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
elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
  RedHatUrl=""
  RepoBase=""
  RepoAppStream=""
  RepoEpel=""
  AuthMethod="authselect --useshadow --passalgo sha512"
  SetTimeZone="timezone --utc ${TimeZone}"
  [[ "$IsCN" == "cn" ]] && FirewallRule="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/RedHat/RHEL9Public.xml" || FirewallRule="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/RedHat/RHEL9Public.xml"
  if [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]]; then
    if [[ "$RedHatSeries" -ge "8" ]]; then
      RedHatUrl="${LinuxMirror}/${DIST}/BaseOS/${VER}/os/"	  
      RepoBase="repo --name=base --baseurl=${LinuxMirror}/${DIST}/BaseOS/${VER}/os/"
      RepoAppStream="repo --name=appstream --baseurl=${LinuxMirror}/${DIST}/AppStream/${VER}/os/"
      if [[ "$IsCN" == "cn" ]]; then
        RepoEpel="repo --name=epel --baseurl=http://mirror.nju.edu.cn/epel/$RedHatSeries/Everything/${VER}/"
      else
        RepoEpel="repo --name=epel --baseurl=https://archives.fedoraproject.org/pub/epel/$RedHatSeries/Everything/${VER}/"
      fi
    elif [[ "$linux_relese" == 'centos' ]] && [[ "$RedHatSeries" -le "7" ]]; then
      RedHatUrl="${LinuxMirror}/${DIST}/os/${VER}/"
      AuthMethod="auth --useshadow --passalgo=sha512"
      SetTimeZone="timezone --isUtc ${TimeZone}"
      RepoBase="repo --name=base --baseurl=${LinuxMirror}/${DIST}/os/${VER}/"
      RepoAppStream="repo --name=updates --baseurl=${LinuxMirror}/${DIST}/updates/${VER}/"
      [[ "$IsCN" == "cn" ]] && FirewallRule="https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/RedHat/RHEL7Public.xml" || FirewallRule="https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/RedHat/RHEL7Public.xml"
      if [[ "$IsCN" == "cn" ]]; then
        RepoEpel="repo --name=epel --baseurl=http://mirror.nju.edu.cn/epel/$RedHatSeries/${VER}/"
      else
        RepoEpel="repo --name=epel --baseurl=https://archives.fedoraproject.org/pub/archive/epel/$RedHatSeries/${VER}/"
      fi
    fi
  elif [[ "$linux_relese" == 'fedora' ]]; then
    RedHatUrl="${LinuxMirror}/releases/${DIST}/Server/${VER}/os/"
    RepoBase="repo --name=base --baseurl=${LinuxMirror}/releases/${DIST}/Server/${VER}/os/"
    RepoEpel="repo --name=epel --baseurl=${LinuxMirror}/releases/${DIST}/Everything/${VER}/os/"
  fi
# If network adapter is redirected, the "eth0" is default.
  if [[ "$NetworkConfig" == "isDHCP" ]]; then
    NetConfigManually="network --bootproto=dhcp --hostname=$(hostname) --onboot=on"
  elif [[ "$NetworkConfig" == "isStatic" ]]; then
    [[ "$IPStackType" == "isIPv4" ]] && NetConfigManually="network --device=$interface --bootproto=static --ip=$IPv4 --netmask=$MASK --gateway=$GATE --nameserver=$ipDNS --hostname=$(hostname) --onboot=on" || NetConfigManually="network --device=$interface --bootproto=static --ip=$IPv4 --netmask=$MASK --gateway=$GATE --ipv6=$i6Addr --ipv6gateway=$ip6Gate --nameserver=$ipDNS,$ip6DNS --hostname=$(hostname) --onboot=on"
  fi
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
bootloader --location=mbr --append="rhgb quiet crashkernel=auto net.ifnames=0 biosdevname=0"

# Clear the Master Boot Record
zerombr
clearpart --all --initlabel

# Disk partitioning information
autopart

# Reboot after installation
reboot

%packages --ignoremissing
@^minimal-environment
bind-utils
curl
efibootmgr
epel-release
fail2ban
file
ipcalc
jq
lrzsz
net-tools
opensslwget
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

# Clean logs
rm -rf /root/anaconda-ks.cfg
rm -rf /root/install.*log

%end

EOF
# If network adapter is not redirected, delete this setting to new system.
  [[ "$setInterfaceName" == "0" ]] && sed -i 's/ net.ifnames=0 biosdevname=0//g' /tmp/boot/ks.cfg
  
  [[ "$UNKNOWHW" == '1' ]] && sed -i 's/^unsupported_hardware/#unsupported_hardware/g' /tmp/boot/ks.cfg
  [[ "$(echo "$DIST" |grep -o '^[0-9]\{1\}')" == '5' ]] && sed -i '0,/^%end/s//#%end/' /tmp/boot/ks.cfg
fi

find . | cpio -H newc --create --verbose | gzip -9 > /tmp/initrd.img;
cp -f /tmp/initrd.img /boot/initrd.img || sudo cp -f /tmp/initrd.img /boot/initrd.img
cp -f /tmp/vmlinuz /boot/vmlinuz || sudo cp -f /tmp/vmlinuz /boot/vmlinuz

# Grub config start
# Debian/Ubuntu Grub1 set start
if [[ ! -z "$GRUBTYPE" && "$GRUBTYPE" == "isGrub1" ]]; then
  READGRUB='/tmp/grub.read'
  [[ -f $READGRUB ]] && rm -rf $READGRUB
  touch $READGRUB
# Backup original grub config file
  cp $GRUBDIR/$GRUBFILE "$GRUBDIR/$GRUBFILE_$(date "+%Y%m%d%H%M").bak"
# Read grub file, search boot item
# Some grub file is written as a binary file, add parameter "-a, --text" process this file as if it were text; this is equivalent to the --binary-files=text option
  cat $GRUBDIR/$GRUBFILE |sed -n '1h;1!H;$g;s/\n/%%%%%%%/g;$p' |grep -aom 1 'menuentry\ [^{]*{[^}]*}%%%%%%%' |sed 's/%%%%%%%/\n/g' >$READGRUB
  LoadNum="$(cat $READGRUB |grep -c 'menuentry ')"
  if [[ "$LoadNum" -eq '1' ]]; then
    cat $READGRUB |sed '/^$/d' >/tmp/grub.new;
  elif [[ "$LoadNum" -gt '1' ]]; then
    CFG0="$(awk '/menuentry /{print NR}' $READGRUB|head -n 1)";
    CFG2="$(awk '/menuentry /{print NR}' $READGRUB|head -n 2 |tail -n 1)";
    CFG1="";
    for tmpCFG in `awk '/}/{print NR}' $READGRUB`; do
      [ "$tmpCFG" -gt "$CFG0" -a "$tmpCFG" -lt "$CFG2" ] && CFG1="$tmpCFG";
    done
    [[ -z "$CFG1" ]] && {
      echo "Error! read $GRUBFILE.\n";
      exit 1;
    }
    sed -n "$CFG0,$CFG1"p $READGRUB >/tmp/grub.new;
    [[ -f /tmp/grub.new ]] && [[ "$(grep -c '{' /tmp/grub.new)" -eq "$(grep -c '}' /tmp/grub.new)" ]] || {
      echo -ne "\033[31mError! \033[0mNot configure $GRUBFILE.\n";
      exit 1;
    }
  fi  
  [ ! -f /tmp/grub.new ] && echo -ne "\033[31mError! \033[0m $GRUBFILE. " && exit 1;
  sed -i "/menuentry.*/c\menuentry\ \'Install OS \[$Relese\ $DIST\ $VER\]\'\ --class debian\ --class\ gnu-linux\ --class\ gnu\ --class\ os\ \{" /tmp/grub.new
  sed -i "/echo.*Loading/d" /tmp/grub.new;
  INSERTGRUB="$(awk '/menuentry /{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)"
  
  [[ -n "$(grep 'linux.*/\|kernel.*/' /tmp/grub.new |awk '{print $2}' |tail -n 1 |grep '^/boot/')" ]] && Type='InBoot' || Type='NoBoot';
  
  LinuxKernel="$(grep 'linux.*/\|kernel.*/' /tmp/grub.new |awk '{print $1}' |head -n 1)";
  [[ -z "$LinuxKernel" ]] && echo -ne "\n\033[31mError: \033[0mread grub config!\n" && exit 1;
  LinuxIMG="$(grep 'initrd.*/' /tmp/grub.new |awk '{print $1}' |tail -n 1)";
  [ -z "$LinuxIMG" ] && sed -i "/$LinuxKernel.*\//a\\\tinitrd\ \/" /tmp/grub.new && LinuxIMG='initrd';
# If network adapter need to redirect eth0, eth1... in new system, add this setting in grub file of the current system for netboot install file which need to be loaded after restart.
# The same behavior for grub2.
  [[ "$setInterfaceName" == "1" ]] && Add_OPTION="net.ifnames=0 biosdevname=0" || Add_OPTION=""
  [[ "$setIPv6" == "1" || "$IPStackType" == "IPv4Stack" ]] && Add_OPTION="$Add_OPTION ipv6.disable=1"

  if [[ "$linux_relese" == 'debian' ]] || [[ "$linux_relese" == 'ubuntu' ]]; then
# The method for Debian series installer to search network adapter automatically is to set "d-i netcfg/choose_interface select auto" in preseed file.
# The same behavior for grub2.
    BOOT_OPTION="auto=true $Add_OPTION hostname=$(hostname) domain=$linux_relese quiet"
  elif [[ "$linux_relese" == 'centos' ]] || [[ "$linux_relese" == 'rockylinux' ]] || [[ "$linux_relese" == 'almalinux' ]] || [[ "$linux_relese" == 'fedora' ]]; then
# The method for Redhat series installer to search network adapter automatically is to set "ksdevice=link" in grub file of the current system for netboot install file which need to be loaded after restart.
# The same behavior for grub2.
    BOOT_OPTION="inst.ks=file://ks.cfg $Add_OPTION ksdevice=$interfaceSelect quiet"
  fi
  
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
elif [[ ! -z "$GRUBTYPE" && "$GRUBTYPE" == "isGrub2" ]]; then
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
      LpFile=`ls -Sl /boot/loader/entries/ | grep -wv "rescue*" | awk -F' ' '{print $NF}' | sed -n '2p'`
      [[ "$(cat /boot/loader/entries/$LpFile | grep '^linux /boot/')" ]] && BootDIR='/boot' || BootDIR=''
    else
      [[ "$(cat $LpFile | grep '^linux /boot/')" ]] && BootDIR='/boot' || BootDIR=''
    fi
  else
    [[ -n "$(grep 'linux.*/\|kernel.*/' $GRUBDIR/$GRUBFILE | awk '{print $2}' | tail -n 1 | grep '^/boot/')" ]] && BootDIR='/boot' || BootDIR='';
  fi
# Confirm if BIOS or UEFI firmware for architecture of x86_64(AMD64) processors.
  if [[ "$VER" == "x86_64" || "$VER" == "amd64" ]]; then
    if [[ "$EfiSupport" == "enabled" ]]; then
      BootHex="efi"
    else
      BootHex="16"
    fi
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
# In standard redhat like linux os with grub2 above version of 7, the boot configuration in "grub.cfg" is like:
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
# But in Rocky Linux 9.1 of official templates in Oracle Cloud, the boot configuration in "grub.cfg" is different from any other of redhat release version compeletely:
#
# insmod part_gpt
# insmod xfs
# search --no-floppy --fs-uuid --set=root 11000e8c-9777-43c3-a83b-54a13d609fdb
# insmod part_gpt
# insmod fat
# search --no-floppy --fs-uuid --set=boot 9E70-9B63
#
# Only the following method will effective:
#
# The expect component in grub file should be like "search --no-floppy --fs-uuid --set=root 9340b3c7-e898-44ae-bd1e-4c58dec2b16d".
    SetRootCfg="$(awk '/--fs-uuid --set=root/{print NR}' $GRUBDIR/$GRUBFILE|head -n 2|tail -n 1)"
# An array for depositing all rows of "insmod part_".
    InsmodPartArray=()
# An array for row number of "search --no-floppy --fs-uuid --set=root..." minus row number of "insmod part_".
    IpaSpace=()
# Static how many times does "insmod part_" appeared and storage rows in array of "InsmodPartArray",
# storage minus rows in arrary of "IpaSpace"
    for tmpCFG in `awk '/insmod part_/{print NR}' $GRUBDIR/$GRUBFILE`; do
      InsmodPartArray+=($tmpCFG $InsmodPartArray)
      IpaSpace+=(`expr $SetRootCfg - $tmpCFG` $IpaSpace)
    done
# Definite order "0" in "IpaSpace" as a default value of variable of "minArray".
    minArray=${IpaSpace[0]}
# The outer condition of this cycle is to definite how many times does it will execute.
    for ((i=1;i<=`grep -io "insmod part_*" $GRUBDIR/$GRUBFILE | wc -l`;i++)); do
# The inner condition of this cycle is the orders in array of "IpaSpace".
      for j in ${IpaSpace[@]}; do
# A typical buddle sort for compare whether the current variable "minArray" is greater than the order of number in "IpaSpace" of current cycle.
# One number of row minus another one shouldn't be less than "0".
# If "minArray" is greater than the order "j" in array of "IpaSpace", the less one "j" will replace the former "IpaSpace".
        [[ ${IpaSpace[$j]} -lt "0" ]] && exit 1
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
    echo -ne "\n\033[31mError: \033[0mread $GRUBFILE.\n"
    exit 1
  }
  sed -n "$CFG0,$CFG1"p $GRUBDIR/$GRUBFILE >/tmp/grub.new
  sed -i -e 's/^/  /' /tmp/grub.new
  [[ -f /tmp/grub.new ]] && [[ "$(grep -c '{' /tmp/grub.new)" -eq "$(grep -c '}' /tmp/grub.new)" ]] || {
  echo -ne "\033[31mError! \033[0mNot configure $GRUBFILE. \n"
  exit 1
  }
  [ ! -f /tmp/grub.new ] && echo -e "\n\033[31mError: \033[0m$GRUBFILE.\n" && exit 1
# Set IPv6 or distribute unite network adapter interface
  [[ "$setInterfaceName" == "1" ]] && Add_OPTION="net.ifnames=0 biosdevname=0" || Add_OPTION=""
  [[ "$setIPv6" == "1" || "$IPStackType" == "IPv4Stack" ]] && Add_OPTION="$Add_OPTION ipv6.disable=1"
# Write menuentry to grub
  if [[ "$linux_relese" == 'ubuntu'  || "$linux_relese" == 'debian' ]]; then
    BOOT_OPTION="auto=true $Add_OPTION hostname=$(hostname) domain=$linux_relese quiet"
  else
    BOOT_OPTION="inst.ks=file://ks.cfg $Add_OPTION ksdevice=$interfaceSelect quiet"
  fi
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
fi
# Grub config end

chown root:root $GRUBDIR/$GRUBFILE
chmod 444 $GRUBDIR/$GRUBFILE

if [[ "$loaderMode" == "0" ]]; then
  sleep 3 && reboot || sudo reboot >/dev/null 2>&1
else
  rm -rf "$HOME/loader"
  mkdir -p "$HOME/loader"
  cp -rf "/boot/initrd.img" "$HOME/loader/initrd.img"
  cp -rf "/boot/vmlinuz" "$HOME/loader/vmlinuz"
  [[ -f "/boot/initrd.img" ]] && rm -rf "/boot/initrd.img"
  [[ -f "/boot/vmlinuz" ]] && rm -rf "/boot/vmlinuz"
  echo && ls -AR1 "$HOME/loader"
fi
