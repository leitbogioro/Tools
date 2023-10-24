#!/bin/ash
#
# Alpine Linux use "ash" as the default shell.

exec >/dev/tty0 2>&1

# Delete the initial script itself to prevent to be executed in the new system.
rm -f /etc/local.d/windowsConf.start
rm -f /etc/runlevels/default/local

# Install necessary components.
apk update
apk add coreutils grep sed

# Get Windows static networking configurations.
confFile="/root/alpine.config"

# Read configs from initial file.
IncDisk=$(grep "IncDisk" $confFile | awk '{print $2}')
LinuxMirror=$(grep -w "LinuxMirror" $confFile | awk '{print $2}')
alpineVer=$(grep "alpineVer" $confFile | awk '{print $2}')
IPv4=$(grep "IPv4" $confFile | awk '{print $2}')
MASK=$(grep "MASK" $confFile | awk '{print $2}')
actualIp4Subnet=$(grep "actualIp4Subnet" $confFile | awk '{print $2}')
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
Network6Config=$(grep "Network6Config" $confFile | awk '{print $2}')
DEC_CMD=$(grep "DEC_CMD" $confFile | awk '{print $2}')

# Reset configurations of repositories.
true >/etc/apk/repositories
setup-apkrepos $LinuxMirror/$alpineVer/main
setup-apkcache /var/cache/apk

# Add community mirror.
sed -i '$a\'$LinuxMirror'/'$alpineVer'/community' /etc/apk/repositories
# Add edge testing to the repositories
# sed -i '$a\'$LinuxMirror'/edge/testing' /etc/apk/repositories

# Synchronize time from hardware.
hwclock -s || true

# Install necessary components.
apk update
apk add fuse gzip hdparm multipath-tools musl ntfs-3g util-linux wget xz

# Start dd.
wget --no-check-certificate --report-speed=bits --tries=0 --timeout=10 --wait=5 -O- "$DDURL" | $DEC_CMD | dd of="$IncDisk" status=progress

# Get valid loop device.
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)

# Make a soft link between valid loop device and disk.
losetup $loopDevice $IncDisk

# Get mapper partition.
mapperDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | sort -rn | sed -n '1p' | awk '{print $3}')

# Mount Windows dd partition to /mnt .
ntfs-3g /dev/mapper/$mapperDevice /mnt

# Download initiate file.
setupCompleteFile='/mnt/Users/Administrator/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/SetupComplete.bat'
wget --no-check-certificate -qO "$setupCompleteFile" ''$windowsStaticConfigCmd''

# Write IPv4 static config script to setup step.
if [[ "$Network4Config" == "isStatic" && -n "$IPv4" && -n "$actualIp4Subnet" && -n "$GATE" ]]; then
	sed -ri "s/IPv4/$IPv4/g" "$setupCompleteFile"
	sed -ri "s/actualIp4Subnet/$actualIp4Subnet/g" "$setupCompleteFile"
	sed -ri "s/GATE/$GATE/g" "$setupCompleteFile"
	sed -ri "s/ipDNS1/$ipDNS1/g" "$setupCompleteFile"
	sed -ri "s/ipDNS2/$ipDNS2/g" "$setupCompleteFile"
else
	sed -ri "s/setipv4mode=on/setipv4mode=off/g" "$setupCompleteFile"
fi

# Write IPv6 static config script to setup step.
if [[ "$Network6Config" == "isStatic" && -n "$ip6Addr" && -n "$actualIp6Prefix" && -n "$ip6Gate" ]]; then
	sed -ri "s/ip6Addr/$ip6Addr/g" "$setupCompleteFile"
	sed -ri "s/actualIp6Prefix/$actualIp6Prefix/g" "$setupCompleteFile"
	sed -ri "s/ip6Gate/$ip6Gate/g" "$setupCompleteFile"
	sed -ri "s/ip6DNS1/$ip6DNS1/g" "$setupCompleteFile"
	sed -ri "s/ip6DNS2/$ip6DNS2/g" "$setupCompleteFile"
else
	sed -ri "s/setipv6mode=on/setipv6mode=off/g" "$setupCompleteFile"
fi

# Umount mounted directory and loop device.
umount /mnt
kpartx -dv $loopDevice
losetup -d $loopDevice

# Reboot, the temporary intermediary system of AlpineLinux which is executing in memory will be destroyed during the power down and then server will reboot to the newly installed system immediately.
exec reboot
