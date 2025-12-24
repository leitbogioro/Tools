#!/bin/sh
#
#    Alpine ash/POSIX compatible MOTD
#    Put this file in /etc/profile.d/motd.sh
#    Authors:Leitbogioro
#

# ------------------ 0) helpers ------------------
have_cmd() { command -v "$1" >/dev/null 2>&1; }

# Do not "exit" in a sourced script; try return, fallback to true.
safe_return() { return 0 2>/dev/null || true; }

run_timeout() {
  _t="$1"; shift
  if have_cmd timeout; then
    timeout "$_t" "$@" 2>/dev/null
  else
    "$@" 2>/dev/null
  fi
}

# CPU usage: sample /proc/stat twice, output integer percent like "8%"
get_cpu_usage() {
  # 1st sample
  set -- $(head -n 1 /proc/stat 2>/dev/null)
  [ "$1" = "cpu" ] || { echo "N/A"; return; }

  user=${2:-0}
  nice=${3:-0}
  system=${4:-0}
  idle=${5:-0}
  iowait=${6:-0}
  irq=${7:-0}
  softirq=${8:-0}
  steal=${9:-0}

  idle_all1=$((idle + iowait))
  total1=$((user + nice + system + idle + iowait + irq + softirq + steal))

  # small interval; if fractional sleep unsupported, fallback to 1s
  sleep 0.2 2>/dev/null || sleep 1

  # 2nd sample
  set -- $(head -n 1 /proc/stat 2>/dev/null)
  [ "$1" = "cpu" ] || { echo "N/A"; return; }

  user2=${2:-0}
  nice2=${3:-0}
  system2=${4:-0}
  idle2=${5:-0}
  iowait2=${6:-0}
  irq2=${7:-0}
  softirq2=${8:-0}
  steal2=${9:-0}

  idle_all2=$((idle2 + iowait2))
  total2=$((user2 + nice2 + system2 + idle2 + iowait2 + irq2 + softirq2 + steal2))

  dt=$((total2 - total1))
  di=$((idle_all2 - idle_all1))

  [ "$dt" -gt 0 ] 2>/dev/null || { echo "N/A"; return; }

  awk -v dt="$dt" -v di="$di" 'BEGIN{printf "%d%%", ((dt-di)*100)/dt}'
}

# ------------------ 1) tweak vim defaults ------------------
sed -i 's/set mouse=a/set mouse-=a/g' /usr/share/vim/vim82/defaults.vim >/dev/null 2>&1
sed -i 's/set mouse=a/set mouse-=a/g' /usr/share/vim/vim90/defaults.vim >/dev/null 2>&1

# ------------------ 2) distro name ------------------
DISTRIB_DESCRIPTION="Alpine"
if [ -r /etc/os-release ]; then
  _id="$(awk -F= 'tolower($1)=="id"{gsub(/"/,"",$2); print $2; exit}' /etc/os-release 2>/dev/null)"
  if [ -n "$_id" ]; then
    _id="$(printf "%s" "$_id" | tr '[:upper:]' '[:lower:]')"
    DISTRIB_DESCRIPTION="$(printf "%s" "$_id" | awk '{printf toupper(substr($0,1,1)) substr($0,2)}')"
  fi
fi

UNAME_O="$(uname -o 2>/dev/null)"
[ -z "$UNAME_O" ] && UNAME_O="$(uname -s 2>/dev/null)"

printf "Welcome to %s %s (%s)\n" "$DISTRIB_DESCRIPTION" "$UNAME_O" "$(uname -r 2>/dev/null) $(uname -m 2>/dev/null)"
printf "\n"
printf "The Alpine Wiki contains a large amount of how-to guides and general\n"
printf "information about administrating Alpine systems.\n"
printf "See <https://wiki.alpinelinux.org/>.\n"
printf "\n"
printf "You can setup the system with the command: setup-alpine\n"
printf "\n"
printf "You may change this message by editing /etc/profile.d/motd.sh\n"
printf "\n"

# ------------------ 3) system info ------------------
date_str="$(date 2>/dev/null)"

load="$(awk '{print $1}' /proc/loadavg 2>/dev/null)"
[ -z "$load" ] && load="0.00"

root_usage="$(df -h / 2>/dev/null | awk 'NR==2{print $5}')"
[ -z "$root_usage" ] && root_usage="N/A"

# memory usage: prefer /proc/meminfo (no free dependency)
mem_total_kb="$(awk '/^MemTotal:/{print $2; exit}' /proc/meminfo 2>/dev/null)"
mem_avail_kb="$(awk '/^MemAvailable:/{print $2; exit}' /proc/meminfo 2>/dev/null)"
if [ -n "$mem_total_kb" ] && [ -n "$mem_avail_kb" ] && [ "$mem_total_kb" -gt 0 ] 2>/dev/null; then
  mem_used_kb=$((mem_total_kb - mem_avail_kb))
  memory_usage="$(awk -v u="$mem_used_kb" -v t="$mem_total_kb" 'BEGIN{printf "%.1f%%", (u/t)*100}')"
else
  if have_cmd free; then
    memory_usage="$(free -m 2>/dev/null | awk '/Mem:/ { total=$2; used=$3 } END { if(total>0) printf("%.1f%%", used/total*100); else print "N/A"}')"
  else
    memory_usage="N/A"
  fi
fi

# swap usage from /proc/meminfo
swap_total_kb="$(awk '/^SwapTotal:/{print $2; exit}' /proc/meminfo 2>/dev/null)"
swap_free_kb="$(awk '/^SwapFree:/{print $2; exit}' /proc/meminfo 2>/dev/null)"
if [ -n "$swap_total_kb" ] && [ "$swap_total_kb" -gt 0 ] 2>/dev/null; then
  swap_used_kb=$((swap_total_kb - swap_free_kb))
  swap_usage="$(awk -v u="$swap_used_kb" -v t="$swap_total_kb" 'BEGIN{printf "%.1f%%", (u/t)*100}')"
else
  swap_usage="0.0%"
fi

# Users Logged In: prefer ssh established sessions (ss/netstat), fallback to who
usersnum="0"
if have_cmd ss; then
  usersnum="$(ss -tnp 2>/dev/null | awk '/sshd/ && /ESTAB/{c++} END{print c+0}')"
elif have_cmd netstat; then
  usersnum="$(netstat -tnp 2>/dev/null | awk '/sshd/ && /ESTABLISHED/{c++} END{print c+0}')"
elif have_cmd who; then
  usersnum="$(who 2>/dev/null | wc -l | tr -d ' ')"
  [ -z "$usersnum" ] && usersnum="0"
fi

# processes count
processes="$(ps aux 2>/dev/null | wc -l | tr -d ' ')"
case "$processes" in ""|0) processes="$(ps 2>/dev/null | wc -l | tr -d ' ')";; esac
[ -z "$processes" ] && processes="0"

# uptime: /proc/uptime seconds -> "Xd Yh" / "Xh Ymin" / "X min"
uptime_str="N/A"
uptime_s="$(cut -d. -f1 /proc/uptime 2>/dev/null)"
case "$uptime_s" in
  ""|*[!0-9]*) uptime_str="N/A" ;;
  *)
    days=$((uptime_s / 86400))
    hrs=$(((uptime_s % 86400) / 3600))
    mins=$(((uptime_s % 3600) / 60))
    if [ "$days" -gt 0 ]; then
      uptime_str="${days} days ${hrs} hours"
    elif [ "$hrs" -gt 0 ]; then
      uptime_str="${hrs} hours ${mins} min"
    else
      uptime_str="${mins} min"
    fi
    ;;
esac

# ------------------ 4) local IP (improved) ------------------
localip=""
if have_cmd ip; then
  # best: infer real source IP used to reach internet
  localip="$(ip -4 route get 1.1.1.1 2>/dev/null | awk '
    { for(i=1;i<=NF;i++){ if($i=="src"){print $(i+1); exit} } }')"
  # fallback: first global ipv4
  if [ -z "$localip" ]; then
    localip="$(ip -4 addr show scope global 2>/dev/null | awk '/inet /{print $2; exit}' | cut -d/ -f1)"
  fi
fi

# ------------------ 5) public IP ------------------
IPv4=""
IPv6=""

# Prefer dig (same as your original), fallback to curl/wget if present
if have_cmd dig; then
  IPv4="$(run_timeout 1 dig -4 TXT +short o-o.myaddr.l.google.com @ns3.google.com | head -n 1 | tr -d '"')"
  [ -z "$IPv4" ] && IPv4="$(run_timeout 1 dig -4 TXT CH +short whoami.cloudflare @1.0.0.3 | head -n 1 | tr -d '"')"

  IPv6="$(run_timeout 1 dig -6 TXT +short o-o.myaddr.l.google.com @ns3.google.com | head -n 1 | tr -d '"')"
  [ -z "$IPv6" ] && IPv6="$(run_timeout 1 dig -6 TXT CH +short whoami.cloudflare @2606:4700:4700::1003 | head -n 1 | tr -d '"')"
fi

if [ -z "$IPv4" ] && have_cmd curl; then
  IPv4="$(run_timeout 2 curl -4 -fsS https://api.ipify.org | head -n 1)"
fi
if [ -z "$IPv6" ] && have_cmd curl; then
  IPv6="$(run_timeout 2 curl -6 -fsS https://api64.ipify.org | head -n 1)"
fi

if [ -z "$IPv4" ] && have_cmd wget; then
  IPv4="$(run_timeout 2 wget -T 2 -qO- https://api.ipify.org | head -n 1)"
fi
if [ -z "$IPv6" ] && have_cmd wget; then
  IPv6="$(run_timeout 2 wget -T 2 -qO- https://api64.ipify.org | head -n 1)"
fi

# ---- IPv4 validate ----
is_ipv4="0"
if [ -n "$IPv4" ]; then
  echo "$IPv4" | awk -F. '
    NF==4 {
      for(i=1;i<=4;i++){
        if($i !~ /^[0-9]+$/) exit 1
        if($i < 0 || $i > 255) exit 1
      }
      exit 0
    }
    { exit 1 }
  ' >/dev/null 2>&1 && is_ipv4="1"
fi
[ "$is_ipv4" != "1" ] && IPv4="N/A"

# ---- IPv6 normalize (no bash substring) ----
if [ -n "$IPv6" ]; then
  case "$IPv6" in
    :*) IPv6="0$IPv6" ;;
  esac
  case "$IPv6" in
    *:) IPv6="${IPv6}0" ;;
  esac
fi

# ---- IPv6 validate (simple but practical) ----
is_ipv6="0"
if [ -n "$IPv6" ]; then
  echo "$IPv6" | awk '
    {
      s=$0
      if (index(s,":")==0) exit 1
      if (s ~ /[^0-9A-Fa-f:]/) exit 1
      if (s ~ /:::/) exit 1

      tmp=s
      n=gsub(/::/, "&", tmp)
      if (n>1) exit 1

      split(s, a, ":")
      hext=0
      for(i=1;i<=length(a);i++){
        if (a[i]!=""){
          if (length(a[i])>4) exit 1
          if (a[i] ~ /[^0-9A-Fa-f]/) exit 1
          hext++
        }
      }

      if (n==0){
        if (length(a)!=8) exit 1
      } else {
        if (hext>8) exit 1
      }
      exit 0
    }
  ' >/dev/null 2>&1 && is_ipv6="1"
fi
[ "$is_ipv6" != "1" ] && IPv6="N/A"

# localip fallback rules: if empty / equals public ip / contains ":" => use localhost
if [ -z "$localip" ] || [ "$localip" = "$IPv4" ] || [ "$localip" = "$IPv6" ]; then
  localip="$(awk '/localhost/{print $1; exit}' /etc/hosts 2>/dev/null)"
fi
case "$localip" in
  *:*) localip="$(awk '/localhost/{print $1; exit}' /etc/hosts 2>/dev/null)" ;;
esac
[ -z "$localip" ] && localip="127.0.0.1"

# CPU usage (after IPs, before memory output)
cpu_usage="$(get_cpu_usage)"

# ------------------ 6) output ------------------
echo " System information as of $date_str"
echo
printf "%-30s%-15s\n" " System Load:" "$load"
printf "%-30s%-15s\n" " Private IP Address:" "$localip"
printf "%-30s%-15s\n" " Public IPv4 Address:" "$IPv4"
printf "%-30s%-15s\n" " Public IPv6 Address:" "$IPv6"
printf "%-30s%-15s\n" " CPU Usage:" "$cpu_usage"
printf "%-30s%-15s\n" " Memory Usage:" "$memory_usage"
printf "%-30s%-15s\n" " Usage On /:" "$root_usage"
printf "%-30s%-15s\n" " Swap Usage:" "$swap_usage"
printf "%-30s%-15s\n" " Users Logged In:" "$usersnum"
printf "%-30s%-15s\n" " Processes:" "$processes"
printf "%-30s%-15s\n" " System Uptime:" "$uptime_str"
echo

safe_return
