#!/bin/bash
#

# Vim config file "defaults.vim" can only be generated on the newly boot system, not in preseed process, so we need to revise it by motd.sh
sed -ri 's/set mouse=a/set mouse-=a/g' /usr/share/vim/vim82/defaults.vim >>/dev/null 2>&1
sed -ri 's/set mouse=a/set mouse-=a/g' /usr/share/vim/vim90/defaults.vim >>/dev/null 2>&1

DISTRIB_DESCRIPTION=$(cat /etc/os-release | grep -i "id=" | grep -vi "version\|like\|platform" | cut -d "=" -f2 | sed 's/\"//g' | tr 'A-Z' 'a-z' | sed 's/\b[a-z]/\u&/g')

printf "Welcome to %s %s (%s)\n" "$DISTRIB_DESCRIPTION" "$(uname -o)" "$(uname -r) $(uname -m)"
printf "\n"
printf "The Alpine Wiki contains a large amount of how-to guides and general"
printf "\n"
printf "information about administrating Alpine systems."
printf "\n"
printf "See <https://wiki.alpinelinux.org/>."
printf "\n"
printf "\n"
printf "You can setup the system with the command: setup-alpine"
printf "\n"
printf "\n"
printf "You may change this message by editing /etc/profile.d/motd.sh"
printf "\n"
printf "\n"

date=$(date)
load=$(cat /proc/loadavg | awk '{print $1}')
root_usage=$(df -h / | awk '/\// {print $(NF-1)}')
memory_usage=$(free -m | awk '/Mem:/ { total=$2; used=$3 } END { printf("%3.1f%%", used/total*100)}')

[[ $(free -m | awk '/Swap/ {print $2}') == "0" ]] && swap_usage="0.0%" || swap_usage=$(free -m | awk '/Swap/ { printf("%3.1f%%", $3/$2*100) }')
usersnum=$(netstat -anp | grep -i "sshd: [a-z]" | grep -i "established" | grep -iw 'tcp\|tcp6' | wc -l)
time=$(uptime | grep -ohe 'up .*' | sed 's/,/\ hours/g' | awk '{ printf $2" "$3 }')
processes=$(ps aux | wc -l)
localip=$(ip -4 addr show | grep -wA 5 "eth0" | grep -wv "lo\|host" | grep -w "inet" | grep -w "scope global*\|link*" | head -n 1 | awk -F " " '{for (i=2;i<=NF;i++)printf("%s ", $i);print ""}' | awk '{print$1}' | cut -d'/' -f1)

IPv4=$(timeout 0.2s dig -4 TXT +short o-o.myaddr.l.google.com @ns3.google.com | sed 's/\"//g')
[[ "$IPv4" == "" ]] && IPv4=$(timeout 0.2s dig -4 TXT CH +short whoami.cloudflare @1.0.0.3 | sed 's/\"//g')
IPv6=$(timeout 0.2s dig -6 TXT +short o-o.myaddr.l.google.com @ns3.google.com | sed 's/\"//g')
[[ "$IPv6" == "" ]] && IPv6=$(timeout 0.2s dig -6 TXT CH +short whoami.cloudflare @2606:4700:4700::1003 | sed 's/\"//g')
# IP_Check=$(echo $IPv4 | awk -F. '$1<255&&$2<255&&$3<255&&$4<255{print "isIPv4"}')
IP_Check="$IPv4"
if expr "$IP_Check" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
	for i in 1 2 3 4; do
		if [ $(echo "$IP_Check" | cut -d. -f$i) -gt 255 ]; then
			echo "fail ($IP_Check)"
			exit 1
		fi
	done
	IP_Check="isIPv4"
fi

[[ ${IPv6: -1} == ":" ]] && IPv6=$(echo "$IPv6" | sed 's/.$/0/')
[[ ${IPv6:0:1} == ":" ]] && IPv6=$(echo "$IPv6" | sed 's/^./0/')
IP6_Check="$IPv6"":"
IP6_Hex_Num=$(echo "$IP6_Check" | tr -cd ":" | wc -c)
IP6_Hex_Abbr="0"
if [[ $(echo "$IPv6" | grep -i '[[:xdigit:]]' | grep ':') ]] && [[ "$IP6_Hex_Num" -le "8" ]]; then
	for ((i = 1; i <= "$IP6_Hex_Num"; i++)); do
		IP6_Hex=$(echo "$IP6_Check" | cut -d: -f$i)
		[[ "$IP6_Hex" == "" ]] && IP6_Hex_Abbr=$(expr $IP6_Hex_Abbr + 1)
		[[ $(echo "$IP6_Hex" | wc -c) -le "4" ]] && {
			if [[ $(echo "$IP6_Hex" | grep -iE '[^0-9a-f]') ]] || [[ "$IP6_Hex_Abbr" -gt "1" ]]; then
				echo "fail ($IP6_Check)"
				exit 1
			fi
		}
	done
	IP6_Check="isIPv6"
fi

[[ "${IP6_Check}" != "isIPv6" ]] && IPv6="N/A"

[[ "${IP_Check}" != "isIPv4" ]] && IPv4="N/A"

if [[ "${localip}" == "${IPv4}" ]] || [[ "${localip}" == "${IPv6}" ]] || [[ -z "${localip}" ]] || [[ "${localip}" =~ ":" ]]; then
	localip=$(cat /etc/hosts | grep "localhost" | sed -n 1p | awk '{print $1}')
fi

echo " System information as of $date"
echo
printf "%-30s%-15s\n" " System Load:" "$load"
printf "%-30s%-15s\n" " Private IP Address:" "$localip"
printf "%-30s%-15s\n" " Public IPv4 Address:" "$IPv4"
printf "%-30s%-15s\n" " Public IPv6 Address:" "$IPv6"
printf "%-30s%-15s\n" " Memory Usage:" "$memory_usage"
printf "%-30s%-15s\n" " Usage On /:" "$root_usage"
printf "%-30s%-15s\n" " Swap Usage:" "$swap_usage"
printf "%-30s%-15s\n" " Users Logged In:" "$usersnum"
printf "%-30s%-15s\n" " Processes:" "$processes"
printf "%-30s%-15s\n" " System Uptime:" "$time"
echo
