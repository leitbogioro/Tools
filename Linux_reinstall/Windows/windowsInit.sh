#!/bin/ash
#
# Alpine Linux use "ash" as the default shell.

exec >/dev/tty0 2>&1

# Delete the initial script itself to prevent to be executed in the new system.
rm -f /etc/local.d/windowsConf.start
rm -f /etc/runlevels/default/local

# Install necessary components.
apk update
apk add bash bash bash-doc bash-completion coreutils grep sed

# Get Windows static networking configurations.
confFile="/root/alpine.config"

# Read configs from initial file.
IncDisk=$(grep "IncDisk" $confFile | awk '{print $2}')
LinuxMirror=$(grep -w "LinuxMirror" $confFile | awk '{print $2}')
alpineVer=$(grep "alpineVer" $confFile | awk '{print $2}')
sshPORT=$(grep "sshPORT" $confFile | awk '{print $2}')
IPv4=$(grep "IPv4" $confFile | awk '{print $2}')
MASK=$(grep "MASK" $confFile | awk '{print $2}')
ipPrefix=$(grep "ipPrefix" $confFile | awk '{print $2}')
actualIp4Prefix=$(grep "actualIp4Prefix" $confFile | awk '{print $2}')
GATE=$(grep "GATE" $confFile | awk '{print $2}')
ipDNS1=$(grep "ipDNS1" $confFile | awk '{print $2}')
ipDNS2=$(grep "ipDNS2" $confFile | awk '{print $2}')
ip6Addr=$(grep "ip6Addr" $confFile | awk '{print $2}')
ip6Mask=$(grep "ip6Mask" $confFile | awk '{print $2}')
actualIp6Prefix=$(grep "actualIp6Prefix" $confFile | awk '{print $2}')
ip6Gate=$(grep "ip6Gate" $confFile | awk '{print $2}')
ip6DNS1=$(grep "ip6DNS1" $confFile | awk '{print $2}')
ip6DNS2=$(grep "ip6DNS2" $confFile | awk '{print $2}')
DDURL=$(grep "DDURL" $confFile | awk '{print $2}')
windowsStaticConfigCmd=$(grep "windowsStaticConfigCmd" $confFile | awk '{print $2}')
Network4Config=$(grep "Network4Config" $confFile | awk '{print $2}')
DEC_CMD=$(grep "DEC_CMD" $confFile | awk '{print $2}')

# Reset configurations of repositories
true >/etc/apk/repositories
setup-apkrepos $LinuxMirror/$alpineVer/main
setup-apkcache /var/cache/apk

# Add community mirror
sed -i '$a\'$LinuxMirror'/'$alpineVer'/community' /etc/apk/repositories
# Add edge testing to the repositories
sed -i '$a\'$LinuxMirror'/edge/testing' /etc/apk/repositories

# Synchronize time from hardware
hwclock -s

# Install necessary components.
apk update
apk add ca-certificates e2fsprogs fuse hdparm multipath-tools musl ntfs-3g parted util-linux wget xz

# start dd
wget --no-check-certificate -qO- "$DDURL"  | $DEC_CMD | dd of="$IncDisk"

# get valid loop device
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)

# make a soft link between valid loop device and disk
losetup $loopDevice $IncDisk

# get mapper partition
mapperDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | head -n 1 | awk '{print $3}')

