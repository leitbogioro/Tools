#!/bin/ash
#
# Alpine Linux use "ash" as the default shell.

exec >/dev/tty0 2>&1

insertIntoFile() {
	file=$1
	location=$2
	regexToFind=$3

	lineNum=$(grep -E -n "$regexToFind" "$file" | cut -d: -f1)
	if [[ "$location" == "before" ]]; then
		lineNum=$((lineNum - 1))
	elif [[ "$location" != "after" ]]; then
		return 1
	fi

	sed -i "${lineNum}r /dev/stdin" "$file"
}

# Delete the initial script itself to prevent to be executed in the new system.
rm -f /etc/local.d/alpineConf.start
rm -f /etc/runlevels/default/local

# Install necessary components.
apk update
apk add bash coreutils grep sed

# Get Alpine Linux configurations.
confFile="/root/alpine.config"

# Read configs from initial file.
IncDisk=$(grep "IncDisk" $confFile | awk '{print $2}')
LinuxMirror=$(grep "LinuxMirror" $confFile | awk '{print $2}')
alpineVer=$(grep "alpineVer" $confFile | awk '{print $2}')
TimeZone=$(grep "TimeZone" $confFile | awk '{print $2}')
tmpWORD=$(grep -w "tmpWORD" $confFile | awk '{print $2}')
sshPORT=$(grep "sshPORT" $confFile | awk '{print $2}')
AlpineTestRepository=$(grep "AlpineTestRepository" $confFile | awk '{print $2}')
networkAdapter=$(grep "networkAdapter" $confFile | awk '{print $2}')
IPv4=$(grep "IPv4" $confFile | awk '{print $2}')
MASK=$(grep "MASK" $confFile | awk '{print $2}')
actualIp4Subnet=$(grep "actualIp4Subnet" $confFile | awk '{print $2}')
GATE=$(grep "GATE" $confFile | awk '{print $2}')
iAddrNum=$(grep "iAddrNum" $confFile | awk '{print $2}')
writeIpsCmd=$(grep "writeIpsCmd" $confFile | sed -e 's/writeIpsCmd  //g')
ip6Addr=$(grep "ip6Addr" $confFile | awk '{print $2}')
ip6Mask=$(grep "ip6Mask" $confFile | awk '{print $2}')
actualIp6Prefix=$(grep "actualIp6Prefix" $confFile | awk '{print $2}')
ip6Gate=$(grep "ip6Gate" $confFile | awk '{print $2}')
i6AddrNum=$(grep "i6AddrNum" $confFile | awk '{print $2}')
writeIp6sCmd=$(grep "writeIp6sCmd" $confFile | sed -e 's/writeIp6sCmd  //g')
HostName=$(grep "HostName" $confFile | awk '{print $2}')
virtualizationStatus=$(grep "virtualizationStatus" $confFile | awk '{print $2}')
serialConsolePropertiesForGrub=$(grep "serialConsolePropertiesForGrub" $confFile | sed -e 's/serialConsolePropertiesForGrub  //g')
setFail2banStatus=$(grep "setFail2banStatus" $confFile | awk '{print $2}')
setMotd=$(grep "setMotd" $confFile | awk '{print $2}')
lowMemMode=$(grep "lowMemMode" $confFile | awk '{print $2}')

if [[ "$lowMemMode" == "1" ]]; then
	# Preloading necessary modprobes and then delete modloop to squeeze out more memory.
	preLoadedModulesList="crc32c ext4 ipv6 nls_cp437 nls_utf8 vfat"
	for moduleItems in $preLoadedModulesList; do
		modprobe "$moduleItems"
	done
	rc-service modloop stop
	rm -f /lib/modloop-lts /lib/modloop-virt
	# Backup component of "set disk" of Alpine.
	[[ -e /sbin/setup-disk.orig ]] && cp -f /sbin/setup-disk.orig /sbin/setup-disk || cp -f /sbin/setup-disk /sbin/setup-disk.orig
	# Allocate 1GB swap when rebooting.
	insertIntoFile /sbin/setup-disk after 'mount -t \$ROOTFS \$root_dev "\$SYSROOT"' <<EOF
		fallocate -l 1G /mnt/swapspace
		chmod 0600 /mnt/swapspace
		mkswap /mnt/swapspace
		swapon /mnt/swapspace
		rc-update add swap boot
EOF
	# To making swap valid permanently.
	insertIntoFile /sbin/setup-disk after 'install_mounted_root "\$SYSROOT" "\$disks"' <<EOF
		echo "/swapspace swap swap defaults 0 0" >>/mnt/etc/fstab
EOF
fi

# Reset configurations of repositories
true >/etc/apk/repositories
setup-apkrepos $LinuxMirror/$alpineVer/main
setup-apkcache /var/cache/apk

# Add community mirror
sed -i '$a\'$LinuxMirror'/'$alpineVer'/community' /etc/apk/repositories
# Add edge testing to the repositories
# sed -i '$a\'$LinuxMirror'/edge/testing' /etc/apk/repositories

# Synchronize time from hardware
hwclock -s || true

# Install and enable ssh
echo root:${tmpWORD} | chpasswd
printf '\nyes' | setup-sshd
sed -ri 's/^#?Port.*/Port '${sshPORT}'/g' /etc/ssh/sshd_config

# Network configurations.
# https://wiki.alpinelinux.org/wiki/Configure_Networking
#
# Config dhcpcd
apk add dhcpcd
sed -i '/^slaac private/s/^/#/' /etc/dhcpcd.conf
sed -i '/^#slaac hwaddr/s/^#//' /etc/dhcpcd.conf
# Setup adapter.
setup-interfaces -a
# Generate network file of "/etc/network/interfaces"
rc-update add networking boot
# Delete network file and replace it by us.
rm -rf /etc/network/interfaces
mv /etc/network/tmp_interfaces /etc/network/interfaces
# Static network configurating
sed -ri 's/networkAdapter/'${networkAdapter}'/g' /etc/network/interfaces
sed -ri 's/IPv4/'${IPv4}'/g' /etc/network/interfaces
sed -ri 's/MASK/'${MASK}'/g' /etc/network/interfaces
sed -ri 's/netmask '${MASK}'/netmask '${actualIp4Subnet}'/g' /etc/network/interfaces
sed -ri 's/GATE/'${GATE}'/g' /etc/network/interfaces
if [[ "$iAddrNum" -ge "2" ]]; then
	echo -e "${writeIpsCmd}" >>/etc/network/interfaces
fi
sed -ri 's/ip6Addr/'${ip6Addr}'/g' /etc/network/interfaces
sed -ri 's/ip6Mask/'${ip6Mask}'/g' /etc/network/interfaces
sed -ri 's/netmask '${ip6Mask}'/netmask '${actualIp6Prefix}'/g' /etc/network/interfaces
sed -ri 's/ip6Gate/'${ip6Gate}'/g' /etc/network/interfaces
if [[ "$i6AddrNum" -ge "2" ]]; then
	echo -e "${writeIp6sCmd}" >>/etc/network/interfaces
fi
# Restoring access permission.
chmod a+x /etc/network/interfaces
# Enable IPv6
modprobe ipv6
# Rebuild hosts
rm -rf /etc/hosts
# Add special IPv4 addresses
echo "127.0.0.1       $HostName localhost.localdomain" >>/etc/hosts
# Add special IPv6 addresses
echo "::1             $HostName localhost.localdomain ipv6-localhost ipv6-loopback" >>/etc/hosts
echo "fe00::0         ipv6-localnet" >>/etc/hosts
echo "ff00::0         ipv6-mcastprefix" >>/etc/hosts
echo "ff02::1         ipv6-allnodes" >>/etc/hosts
echo "ff02::2         ipv6-allrouters" >>/etc/hosts
echo "ff02::3         ipv6-allhosts" >>/etc/hosts
# Hostname
rm -rf /etc/hostname
echo "$HostName" >/etc/hostname
hostname -F /etc/hostname

# Localization
setup-keymap us us
setup-timezone -i ${TimeZone}
setup-ntp chrony || true

# In arm netboot initramfs init,
# if rtc hardware is detected, add hwclock for system, otherwise add swclock,
# this settings will be copied to the new system,
# but the new system boot from initramfs chroot can detect rtc hardwa1 correctly,
# so we use hwclock manually to fix it.
rc-update del swclock boot || true
rc-update add hwclock boot

# Setting Alpine Linux by "setup-alpine" will enable the following services
# https://github.com/alpinelinux/alpine-conf/blob/c5131e9a038b09881d3d44fb35e86851e406c756/setup-alpine.in#L189
# acpid | default
# crond | default
# seedrng | boot
[[ -e /dev/input/event0 ]] && rc-update add acpid
rc-update add crond
rc-update add seedrng boot

# Replace "ash" to "bash" as the default shell of the Alpine Linux.
sed -ri 's/ash/bash/g' /etc/passwd

# Insall more components.
if [[ "$setFail2banStatus" == "1" && "$lowMemMode" != "1" ]]; then
	apk update
	apk add bind-tools curl e2fsprogs fail2ban grub lsblk lsof net-tools util-linux vim wget
	# Config fail2ban
	sed -i '/^\[Definition\]/a allowipv6 = auto' /etc/fail2ban/fail2ban.conf
	rc-update add fail2ban
	/etc/init.d/fail2ban start
elif [[ "$lowMemMode" == "1" ]]; then
	echo ""
else
	apk update
	apk add bind-tools curl e2fsprogs grub lsblk lsof net-tools util-linux vim wget
fi

# Make a blank motd to avoid Alpine Linux writes a new one.
[[ "$setMotd" == "1" ]] && {
	rm -rf /etc/motd
	touch /etc/motd
}

# Use kernel "virt" if be executed on virtual machine.
[[ "$virtualizationStatus" == "1" ]] && kernelType="virt" || kernelType="lts"

# Install to hard drive.
KERNELOPTS="$serialConsolePropertiesForGrub"
export KERNELOPTS
export BOOTLOADER="grub"
printf 'y' | setup-disk -m sys -k $kernelType -s 0 $IncDisk

# Reboot, the system in the memory will all be written to the hard drive.
exec reboot
