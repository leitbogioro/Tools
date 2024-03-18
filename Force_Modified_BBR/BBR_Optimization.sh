#!/bin/bash

# color
underLine='\033[4m'
aoiBlue='\033[36m'
blue='\033[34m'
yellow='\033[33m'
green='\033[32m'
red='\033[31m'
plain='\033[0m'

Info="${green}[Info]${plain}"
Error="${red}[Error]${plain}"
reboot="${yellow}Reboot${plain}"

echo -e "${green}
#================================================
# Project:          Xanmod_Advanced_BBR
# Platform:         --Debian --KVM --AMD64
# Contributed by:   nanqinlang:  https://github.com/nanqinlang/
#                   Xanmod team: https://t.me/kernel_xanmod/
#                          NANI: https://github.com/UJX6N
# Author:           LeitboGioro: https://github.com/leitbogioro/Tools/
#================================================
${plain}"

# Check Root
function checkRoot() {
	[[ "$EUID" -ne '0' || $(id -u) != '0' ]] && echo -ne "\n[${red}Error${plain}] This script must be executed as root!\n\nTry to type:\n${yellow}sudo -s\n${plain}\nAfter entering the password, switch to root dir to execute this script:\n${yellow}cd ~${plain}\n\n" && exit 1
}

function check_system() {
	# Fix debian security sources 404 not found (only of default sources)
	sed -i 's/^\(deb.*security.debian.org\/\)\(.*\)\/updates/\1debian-security\2-security/g' /etc/apt/sources.list

	CurrentOSVer=$(cat /etc/os-release | grep -w "VERSION_ID=*" | awk -F '=' '{print $2}' | sed 's/\"//g' | cut -d'.' -f 1)
	
	apt update -y
	# Try to fix error of connecting to current mirror for Debian.
	if [[ $? -ne 0 ]]; then
		apt update -y >/root/apt_execute.log
		if [[ $(grep -i "debian" /root/apt_execute.log) ]] && [[ $(grep -i "err:[0-9]" /root/apt_execute.log) || $(grep -i "404  not found" /root/apt_execute.log) ]]; then
			currentDebianMirror=$(sed -n '/^deb /'p /etc/apt/sources.list | head -n 1 | awk '{print $2}' | sed -e 's|^[^/]*//||' -e 's|/.*$||')
			if [[ "$CurrentOSVer" -gt "9" ]]; then
				# Replace invalid mirror of Debian to 'deb.debian.org' if current version has not been 'EOL'(End Of Life).
				sed -ri "s/$currentDebianMirror/deb.debian.org/g" /etc/apt/sources.list
			else
				# Replace invalid mirror of Debian to 'archive.debian.org' because it had been marked with 'EOL'.
				sed -ri "s/$currentDebianMirror/archive.debian.org/g" /etc/apt/sources.list
			fi
			# Disable get security update.
			sed -ri 's/^deb-src/# deb-src/g' /etc/apt/sources.list
			apt update -y
		fi
		rm -rf /root/apt_execute.log
	fi
	apt install lsb-release -y
	
	DebianRelease=""
	IsUbuntu=$(uname -a | grep -i "ubuntu")
	IsDebian=$(uname -a | grep -i "debian")
	IsKali=$(uname -a | grep -i "kali")
	for Count in $(cat /etc/os-release | grep -w "ID=*" | awk -F '=' '{print $2}') $(cat /etc/issue | awk '{print $1}') "$OsLsb"; do
		[[ -n "$Count" ]] && DebianRelease=$(echo -e "$Count")"$DebianRelease"
	done
	
	if [[ "$IsDebian" ]] || [[ $(echo "$DebianRelease" | grep -i 'debian') != "" ]]; then
		CurrentOS="Debian"
		CurrentOSVer=$(lsb_release -r | awk '{print$2}' | cut -d'.' -f1)
	else
		echo -ne "\n[${red}Error${plain}] Does't support your system!\n"
		exit 1
	fi
	
	if [[ "$CurrentOSVer" -le "10" ]]; then
		echo -ne "\n[${red}Error${plain}] Does't support your system!\n"
		exit 1
	fi
}

# Check architecture of CPU, only support amd64 or arm64.
function check_architecture() {
	# Get architecture of current os automatically
	ArchName=$(uname -m)
	[[ -z "$ArchName" ]] && ArchName=$(echo $(hostnamectl status | grep "Architecture" | cut -d':' -f 2))
	case $ArchName in arm64) Architecture="arm64" ;; aarch64) Architecture="aarch64" ;; x86 | i386 | i686) Architecture="i386" ;; x86_64) Architecture="x86_64" ;; x86-64) Architecture="x86-64" ;; amd64) Architecture="amd64" ;; *) Architecture="" ;; esac
	# Exchange architecture name
	if [[ "$CurrentOS" == 'Debian' ]]; then
		# In debian 12, the result of "uname -m" is "x86_64";
		# the result of "echo `hostnamectl status | grep "Architecture" | cut -d':' -f 2`" is "x86-64"
		if [[ "$Architecture" == "x86_64" ]] || [[ "$Architecture" == "x86-64" ]]; then
			Architecture="amd64"
		elif [[ "$Architecture" == "aarch64" ]]; then
			Architecture="arm64"
		fi
	fi
	[[ "$Architecture" != "amd64" && "$Architecture" != "arm64" ]] && echo -ne "\n[${red}Error${plain}] Unsupported CPU architecture!" && exit 1
	# To install Xanmod Linux kernel, the differences from "v1" "v2" "v3" "v4" is the different optimizations for ISA (Instruction Set Architecture) of CPUs from each periods,
	# we can visit https://xanmod.org/, title "x86-64 psABI level reference" to inquire or execute this script to confirm it: https://dl.xanmod.org/check_x86-64_psabi.sh .
	[[ "$Architecture" == "amd64" ]] && {
		if [[ $(grep -iw "avx512f" "/proc/cpuinfo") || $(grep -iw "avx512bw" "/proc/cpuinfo") || $(grep -iw "avx512cd" "/proc/cpuinfo") || $(grep -iw "avx512dq" "/proc/cpuinfo") || $(grep -iw "avx512vl" "/proc/cpuinfo") ]]; then
			isaLevel="4"
		elif [[ $(grep -iw "avx" "/proc/cpuinfo") || $(grep -iw "avx2" "/proc/cpuinfo") || $(grep -iw "bmi1" "/proc/cpuinfo") || $(grep -iw "bmi2" "/proc/cpuinfo") || $(grep -iw "f16c" "/proc/cpuinfo")|| $(grep -iw "fma" "/proc/cpuinfo") || $(grep -iw "abm" "/proc/cpuinfo") || $(grep -iw "movbe" "/proc/cpuinfo") || $(grep -iw "xsave" "/proc/cpuinfo") ]]; then
			isaLevel="3"
		elif [[ $(grep -iw "cx16" "/proc/cpuinfo") || $(grep -iw "lahf" "/proc/cpuinfo") || $(grep -iw "popcnt" "/proc/cpuinfo") || $(grep -iw "sse4_1" "/proc/cpuinfo") || $(grep -iw "sse4_2" "/proc/cpuinfo") || $(grep -iw "ssse3" "/proc/cpuinfo") ]]; then
			isaLevel="2"
		elif [[ $(grep -iw "lm" "/proc/cpuinfo") || $(grep -iw "cmov" "/proc/cpuinfo") || $(grep -iw "cx8" "/proc/cpuinfo") || $(grep -iw "fpu" "/proc/cpuinfo") || $(grep -iw "fxsr" "/proc/cpuinfo") || $(grep -iw "mmx" "/proc/cpuinfo") || $(grep -iw "syscall" "/proc/cpuinfo") || $(grep -iw "sse2" "/proc/cpuinfo") ]]; then
			isaLevel="1"
		fi
		[[ -z "$isaLevel" ]] && isaLevel="3"
	}
}

# Check is not OpenVZ
function checkKvm() {
	dpkg_updates="/var/lib/dpkg/updates"
	if [ -f $($dpkg_updates) ]; then
		rm -r $dpkg_updates
		mkdir $dpkg_updates
	fi
	apt-get update
	apt-get install virt-what ca-certificates apt-transport-https -y
	virt=$(virt-what)
	[[ "${virt}" = "openvz" ]] && echo -ne "\n[${red}Error${plain}] OpenVZ not support !" && exit 1
	#[[ "`virt-what`" != "kvm" ]] && echo -e "${Error} only support KVM !" && exit 1
}

# Get official mainstream kernel.
# "$1" is sort method, "$2" is kernel url, "$3" is cert file, "$4" is mainstream version of the kernel.
function getVersion() {
	wget --no-check-certificate -O ${3} ${2}${1}
	#get_kernel_ver=`awk '{print $5}' index | grep "v4.9." | sed -n '$p' | sed -r 's/.*href=\"(.*)\">v4.9.*/\1/' | sed 's/.$//' | sed 's/^.//g'`
	#get_ver_legacy=${get_kernel_ver}
	get_kernel_ver=$(awk '{print $5}' index | grep "v${4}" | tail -1 | head -n 1 | sed -r 's/.*href=\"(.*)\">v'${4}'*/\1/' | sed 's/.$//' | sed 's/^.//g')

	#
	declare -a kernel_ver=()
	num=1
	for ((i = 0; i <= 3; i++)); do
		get_kernel_ver=$(awk '{print $5}' index | grep "v${4}" | tail -$num | head -n 1 | sed -r 's/.*href=\"(.*)\">v'${4}'*/\1/' | sed 's/.$//' | sed 's/^.//g')
		num=$(expr $num + 1)
		ver_last=($(echo ${get_kernel_ver} | awk -F '.' '{print $3}'))
		kernel_ver_last[$i]=$(expr ${ver_last})
	done

	len=${#kernel_ver_last[@]}
	for ((i = 0; i < $len; i++)); do
		for ((j = i + 1; j < $len; j++)); do
			if [[ ${kernel_ver_last[i]} -lt ${kernel_ver_last[j]} ]]; then
				temp=${kernel_ver_last[i]}
				kernel_ver_last[i]=${kernel_ver_last[j]}
				kernel_ver_last[j]=$temp
			fi
		done
	done

	download_ver=${kernel_ver_last[0]}
	wget --no-check-certificate -O downloadpage ${2}v${4}${download_ver}
	ver_sub=0
	while [[ ! $(grep -i ".deb" downloadpage) ]]; do
		rm -rf downloadpage
		ver_sub=$(expr $ver_sub + 1)
		download_ver="${kernel_ver_last[$ver_sub]}"
		wget --no-check-certificate -O downloadpage ${2}v${4}${download_ver}
	done

	rm -rf downloadpage
	rm -rf ${3}

	latest_kernel_ver="${4}${download_ver}"
	echo -ne "${green}${latest_kernel_ver}${plain} is the latest version of ${4}X series which belongs to Long-term support, press ${yellow}Enter${plain} key to install the above mentioned kernel by default."
	echo ""
	read -p "(Type which version you'd like to upgrade):" required_version
	echo $required_version
	[[ -z "${required_version}" ]] && required_version=${latest_kernel_ver}
}

function get_url() {
	getVersion '?C=M;O=A' "https://kernel.ubuntu.com/~kernel-ppa/mainline/" "index" "6.6."
	if [[ "$Architecture" == "amd64" ]]; then
		image_name=$(wget --no-check-certificate -qO- http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/ | grep "linux-image" | awk -F'\">' '/'${Architecture}'.deb/{print $2}' | cut -d'<' -f1 | head -1 | cut -d'/' -f2)
		image_url="http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/${Architecture}/${image_name}"
		headers_flavor_name=$(wget --no-check-certificate -qO- http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/ | grep "linux-headers" | awk -F'\">' '/all.deb/{print $2}' | cut -d'<' -f1 | head -1 | cut -d'/' -f2)
		headers_all_url="http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/${Architecture}/${headers_flavor_name}"
		modules_name=$(wget --no-check-certificate -qO- http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/ | grep "linux-modules" | awk -F'\">' '/'${Architecture}'.deb/{print $2}' | cut -d'<' -f1 | head -1 | cut -d'/' -f2)
		modules_url="http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/${Architecture}/${modules_name}"
	elif [[ "$Architecture" == "arm64" ]]; then
		image_name=$(wget --no-check-certificate -qO- http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/ | grep "linux-image" | grep -v "64k" | awk -F'\">' '/'${Architecture}'.deb/{print $2}' | cut -d'<' -f1 | head -1 | cut -d'/' -f2)
		image_url="http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/${Architecture}/${image_name}"
		headers_flavor_name=$(wget --no-check-certificate -qO- http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/ | grep "linux-headers" | grep -v "64k" | awk -F'\">' '/'${Architecture}'.deb/{print $2}' | cut -d'<' -f1 | head -1 | cut -d'/' -f2)
		headers_all_url="http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/${Architecture}/${headers_flavor_name}"
		modules_name=$(wget --no-check-certificate -qO- http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/ | grep "linux-modules" | grep -v "64k" | awk -F'\">' '/'${Architecture}'.deb/{print $2}' | cut -d'<' -f1 | head -1 | cut -d'/' -f2)
		modules_url="http://kernel.ubuntu.com/~kernel-ppa/mainline/v${required_version}/${Architecture}/${modules_name}"
	else
		echo -e "${red}Not supported architecture!${plain}" && exit 1
	fi
}

function delete_surplus_headers() {
	for ((integer = 1; integer <= ${surplus_total_headers}; integer++)); do
		surplus_sort_headers=$(dpkg -l | grep linux-headers | awk '{print $2}' | grep -v "${required_version}" | head -${integer})
		apt-get purge -y ${surplus_sort_headers}
	done
	apt-get autoremove -y
	if [[ "${surplus_total_headers}" = "0" ]]; then
		echo -e "${Info} uninstall all surplus headers successfully, continuing"
	fi
}

function delete_surplus_modules() {
	for ((integer = 1; integer <= ${surplus_total_modules}; integer++)); do
		surplus_sort_modules=$(dpkg -l | grep linux-modules | awk '{print $2}' | grep -v "${required_version}" | head -${integer})
		apt-get purge -y ${surplus_sort_modules}
	done
	apt-get autoremove -y
	if [[ "${surplus_total_modules}" = "0" ]]; then
		echo -e "${Info} uninstall all surplus modules successfully, continuing"
	fi
}

function delete_surplus_image() {
	for ((integer = 1; integer <= ${surplus_total_image}; integer++)); do
		surplus_sort_image=$(dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${required_version}" | head -${integer})
		apt-get purge -y ${surplus_sort_image}
	done
	apt-get autoremove -y
	if [[ "${surplus_total_image}" = "0" ]]; then
		echo -e "${Info} uninstall all surplus images successfully, continuing"
	fi
}

function install_headers() {
	if [[ -f ${headers_all_name} ]]; then
		echo -e "${Info} deb file exist"
	else
		echo -e "${Info} downloading headers_all" && wget --no-check-certificate -O ${headers_all_name} ${headers_all_url}
	fi
	if [[ -f ${headers_all_name} ]]; then
		echo -e "${Info} installing headers_all" && dpkg -i ${headers_all_name}
	else
		echo -e "${Error} headers_all download failed, please check !" && exit 1
	fi
	rm -rf ${headers_all_name}
}

function install_modules() {
	if [[ -f ${modules_name} ]]; then
		echo -e "${Info} deb file exist"
	else
		echo -e "${Info} downloading modules" && wget --no-check-certificate -O ${modules_name} ${modules_url}
	fi
	if [[ -f ${modules_name} ]]; then
		echo -e "${Info} installing modules" && dpkg -i ${modules_name}
	else
		echo -e "${Error} modules download failed, please check !" && exit 1
	fi
	rm -rf ${modules_name}
}

function install_image() {
	if [[ -f "${image_name}" ]]; then
		echo -e "${Info} deb file exist"
	else
		echo -e "${Info} downloading image" && wget --no-check-certificate -O ${image_name} ${image_url}
	fi
	if [[ -f "${image_name}" ]]; then
		echo -e "${Info} installing image" && dpkg -i ${image_name}
	else
		echo -e "${Error} image download failed, please check !" && exit 1
	fi
	rm -rf ${image_name}
}

#check/install required version and remove surplus kernel
function check_kernel() {
	get_url

	#when kernel version = required version, response required version number.
	digit_ver_image=$(dpkg -l | grep linux-image | awk '{print $2}' | awk -F '-' '{print $3}' | grep "${required_version}")
	digit_ver_headers=$(dpkg -l | grep linux-headers | awk '{print $2}' | awk -F '-' '{print $3}' | grep "${required_version}")
	digit_ver_modules=$(dpkg -l | grep linux-modules | awk '{print $2}' | awk -F '-' '{print $3}' | grep "${required_version}")

	#total digit of kernel without required version
	surplus_total_image=$(dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${required_version}" | wc -l)
	surplus_total_headers=$(dpkg -l | grep linux-headers | awk '{print $2}' | grep -v "${required_version}" | wc -l)
	surplus_total_modules=$(dpkg -l | grep linux-modules | awk '{print $2}' | grep -v "${required_version}" | wc -l)

	if [[ -z "${digit_ver_headers}" ]]; then
		echo -e "${Info} installing required headers" && install_headers
	else
		echo -e "${Info} headers already installed a required version"
	fi
	
	if [[ -z "${digit_ver_modules}" ]]; then
		echo -e "${Info} installing required modules" && install_modules
	else
		echo -e "${Info} modules already installed a required version"
	fi

	if [[ -z "${digit_ver_image}" ]]; then
		echo -e "${Info} installing required image" && install_image
	else
		echo -e "${Info} image already installed a required version"
	fi

	if [[ "${surplus_total_headers}" != "0" ]]; then
		echo -e "${Info} removing surplus headers" && delete_surplus_headers
	else
		echo -e "${Info} no surplus headers need to remove"
	fi
	
	if [[ "${surplus_total_modules}" != "0" ]]; then
		echo -e "${Info} removing surplus modules" && delete_surplus_modules
	else
		echo -e "${Info} no surplus modules need to remove"
	fi

	if [[ "${surplus_total_image}" != "0" ]]; then
		echo -e "${Info} removing surplus image" && delete_surplus_image
	else
		echo -e "${Info} no surplus image need to remove"
	fi

	update-grub
}

function dpkg_list() {
	echo -e "${Info} This following list includes all installed kernels:"
	dpkg -l | grep linux-image | awk '{print $2}'
	dpkg -l | grep linux-headers | awk '{print $2}'
	echo -e "${Info} This is the list includes all kernels need to be installed: \nlinux-image-${required_version}-lowlatency\nlinux-headers-${required_version}\nlinux-headers-${required_version}-lowlatency"
	echo -e "${Info} Make sure two lists are completely consistent!"
}

function check_status() {
	#status_sysctl=`sysctl net.ipv4.tcp_congestion_control | awk '{print $3}'`
	#status_lsmod=`lsmod | grep nanqinlang`
	if [[ "$(lsmod | grep nanqinlang)" != "" ]]; then
		echo -e "${Info} tcp_nanqinlang is installed !"
		if [[ "$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')" = "nanqinlang" ]]; then
			echo -e "${Info} tcp_nanqinlang is running !"
		else
			echo -e "${Error} tcp_nanqinlang is installed but not running !"
		fi
	else
		echo -e "${Error} tcp_nanqinlang not installed !"
	fi
}

###################################################################################################
function install() {
	check_system
	check_architecture
	check_root
	check_kvm
	check_kernel
	dpkg_list
	echo -e "${Info} Finish replaced kernel, ${reboot} your machine, execute the second action of this script when you re-login as root!"
	exit 1
}

function start() {
	check_system
	check_architecture
	check_root
	check_kvm
	sed -i '/net\.core\.default_qdisc/d' /etc/sysctl.conf
	sed -i '/net\.ipv4\.tcp_congestion_control/d' /etc/sysctl.conf
	echo -e "\n#Enable BBR Congestion Control Protocol" >>/etc/sysctl.conf
	echo -e "net.core.default_qdisc=fq" >>/etc/sysctl.conf
	echo -e "net.ipv4.tcp_congestion_control=nanqinlang\c" >>/etc/sysctl.conf
	sysctl -p
	check_status
	rm -rf /home/tcp_nanqinlang
}

function optimize() {
	if [[ ! $(cat /etc/rc.local | grep "ulimit -n 51200") ]] || [ ! -d "/etc/rc.local" ]; then
		ulimit -n 51200 && echo ulimit -n 51200 >>/etc/rc.local
	fi

	if [[ ! $(cat /etc/security/limits.conf | grep "* soft nofile 51200") ]]; then
		echo "* soft nofile 51200" >>/etc/security/limits.conf
	fi

	if [[ ! $(cat /etc/security/limits.conf | grep "* hard nofile 51200") ]]; then
		echo "* hard nofile 51200" >>/etc/security/limits.conf
	fi

	if [[ ! $(cat /etc/sysctl.conf | grep "#TCP Optimizations") ]] && [[ ! $(cat /etc/sysctl.conf | grep "fs.file-max = 51200") ]]; then
		echo -e '\n' >>/etc/sysctl.conf
		cat >>/etc/sysctl.conf <<-EOF
			#TCP Optimizations
			#Optimize File System Operation Performance
			fs.file-max = 51200
			net.core.rmem_max = 67108864
			net.core.wmem_max = 67108864
			net.core.rmem_default = 65536
			net.core.wmem_default = 65536
			net.core.netdev_max_backlog = 8192
			net.core.somaxconn = 8192
			#Enhance Network Transport/Exchange Performance
			net.ipv4.tcp_syncookies = 1
			net.ipv4.tcp_tw_reuse = 1
			net.ipv4.tcp_tw_recycle = 0
			net.ipv4.tcp_fin_timeout = 600
			net.ipv4.tcp_keepalive_time = 10800
			net.ipv4.tcp_max_syn_backlog = 8192
			net.ipv4.tcp_max_tw_buckets = 5000
			net.ipv4.tcp_fastopen = 3
			net.ipv4.tcp_mem = 25600 51200 102400
			net.ipv4.tcp_rmem = 4096 87380 67108864
			net.ipv4.tcp_wmem = 4096 65536 67108864
			net.ipv4.tcp_mtu_probing = 1
			net.ipv4.ip_local_port_range = 1 65536
			#END OF LINE
		EOF
	fi
	sysctl -p >/dev/null 2>&1
	echo "Optimizations are finished, exiting......"
	exit 1
}

function status() {
	check_status
}

function uninstall() {
	check_root
	sed -i '/net\.core\.default_qdisc=/d' /etc/sysctl.conf
	sed -i '/net\.ipv4\.tcp_congestion_control=/d' /etc/sysctl.conf
	sysctl -p
	rm /lib/modules/$(uname -r)/kernel/net/ipv4/tcp_nanqinlang.ko
	echo -e "${Info} please remember ${reboot} to stop tcp_nanqinlang !"
}

echo -e "${Info} Select one: "
echo -e "1.Upgrade to another kernel.\n2.Enable enhanced BBR module.\n3.Optimize networking.\n4.Check if modification fulfilled.\n5.Uninstall"
read -p "Type number:" function

while [[ ! "${function}" =~ ^[1-5]$ ]]; do
	echo -e "${Error} Invalid input!"
	echo -e "${Info} Reselect" && read -p "Type number:" function
done

if [[ "${function}" == "1" ]]; then
	install
elif [[ "${function}" == "2" ]]; then
	start
elif [[ "${function}" == "3" ]]; then
	optimize
elif [[ "${function}" == "4" ]]; then
	status
else
	uninstall
fi
