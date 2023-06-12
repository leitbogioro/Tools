#!/bin/ash
#
# Alpine Linux use "ash" as the default shell.

exec >/dev/tty0 2>&1

# Delete the initial script itself to prevent to be executed in the new system.
rm -f /etc/local.d/alpineConf.start
rm -f /etc/runlevels/default/local

# Install necessary components.
apk update
apk add bash bash bash-doc bash-completion coreutils sed

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
IPv4=$(grep "IPv4" $confFile | awk '{print $2}')
MASK=$(grep "MASK" $confFile | awk '{print $2}')
GATE=$(grep "GATE" $confFile | awk '{print $2}')
ip6Addr=$(grep "ip6Addr" $confFile | awk '{print $2}')
ip6Mask=$(grep "ip6Mask" $confFile | awk '{print $2}')
ip6Gate=$(grep "ip6Gate" $confFile | awk '{print $2}')
HostName=$(grep "HostName" $confFile | awk '{print $2}')

# Setting Alpine Linux by "setup-alpine" will enable the following services
# https://github.com/alpinelinux/alpine-conf/blob/c5131e9a038b09881d3d44fb35e86851e406c756/setup-alpine.in#L189
acpid | default
crond | default
seedrng | boot

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

# Install and enable ssh
echo root:${tmpWORD} | chpasswd
printf '\nyes' | setup-sshd
sed -ri 's/^#?Port.*/Port '${sshPORT}'/g' /etc/ssh/sshd_config

# Network configurations.
# https://wiki.alpinelinux.org/wiki/Configure_Networking
# Setup adapter.
setup-interfaces -a
# Generate network file of "/etc/network/interfaces"
rc-update add networking boot
# Delete network file and replace it by us.
rm -rf /etc/network/interfaces
mv /etc/network/tmp_interfaces /etc/network/interfaces
# Static network configurating
sed -ri 's/IPv4/'${IPv4}'/g' /etc/network/interfaces
sed -ri 's/MASK/'${MASK}'/g' /etc/network/interfaces
sed -ri 's/GATE/'${GATE}'/g' /etc/network/interfaces
sed -ri 's/ip6Addr/'${ip6Addr}'/g' /etc/network/interfaces
sed -ri 's/ip6Mask/'${ip6Mask}'/g' /etc/network/interfaces
sed -ri 's/ip6Gate/'${ip6Gate}'/g' /etc/network/interfaces
# Restoring access permission.
chmod a+x /etc/network/interfaces
# Enable IPv6
modprobe ipv6
# Rebuild hosts
rm -rf /etc/hosts
# Add special IPv4 addresses
echo "127.0.0.1       $HostName localhost.localdomain" >> /etc/hosts
# Add special IPv6 addresses
echo "::1             $HostName localhost.localdomain ipv6-localhost ipv6-loopback" >> /etc/hosts
echo "fe00::0         ipv6-localnet" >> /etc/hosts
echo "ff00::0         ipv6-mcastprefix" >> /etc/hosts
echo "ff02::1         ipv6-allnodes" >> /etc/hosts
echo "ff02::2         ipv6-allrouters" >> /etc/hosts
echo "ff02::3         ipv6-allhosts" >> /etc/hosts
# Hostname
rm -rf /etc/hostname
echo "$HostName" > /etc/hostname
hostname -F /etc/hostname

# Localization
setup-keymap us us
setup-timezone -i ${TimeZone}
setup-ntp chrony

# In arm netboot initramfs init,
# if rtc hardware is detected, add hwclock for system, otherwise add swclock,
# this settings will be copied to the new system,
# but the new system boot from initramfs chroot can detect rtc hardwa1 correctly,
# so we use hwclock manually to fix it.
rc-update del swclock boot
rc-update add hwclock boot

# Replace "ash" to "bash" as the default shell of the Alpine Linux.
sed -ri 's/ash/bash/g' /etc/passwd

# Insall more components.
apk update
apk add axel bind-tools cpio curl e2fsprogs figlet grep grub gzip hdparm lsblk lsof net-tools parted python3 py3-pip udev util-linux virt-what vim wget

# Use kernel "virt" if be executed on virtual machine.
cp /etc/apk/world /tmp/world.old
[[ -n "$(virt-what)" ]] && kernelOpt="-k virt"

# Make a blank motd to avoid Alpine Linux writes a new one.
echo "" >> /etc/motd

# Install to hard drive.
export BOOTLOADER="grub"
printf 'y' | setup-disk -m sys $kernelOpt -s 0 $IncDisk

# Reboot, the system in the memory will all be written to the hard drive.
exec reboot
