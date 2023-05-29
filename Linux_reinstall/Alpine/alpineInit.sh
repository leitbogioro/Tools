#!/bin/bash
#
# Alpine Linux use "ash" as default shell.

exec >/dev/tty0 2>&1

addCommunityRepo() {
  alpineVer=$(cut -d. -f1,2 </etc/alpine-release)
  echo LinuxMirror/v$alpineVer/community >>/etc/apk/repositories
}

# Setting Alpine Linux by "setup-alpine" will enable the following services
# https://github.com/alpinelinux/alpine-conf/blob/c5131e9a038b09881d3d44fb35e86851e406c756/setup-alpine.in#L189
# acpid | default
# crond | default
# seedrng | boot

# Add virt-what to community repository
addCommunityRepo

# Use kernel "virt" if be executed on virtual machine
cp /etc/apk/world /tmp/world.old
[[ -n "$(virt-what)" ]] && kernelOpt="-k virt"

# Reset configurations of repositories
true >/etc/apk/repositories
setup-apkrepos -1
setup-apkcache /var/cache/apk

# Delete comment in the repositories
sed -i 's/#//' /etc/apk/repositories

# Install necessary components.
apk update
apk add axel bash bash-doc bash-completion bind-tools coreutils cpio curl e2fsprogs figlet grep grub gzip hdparm lsblk net-tools parted python3 py3-pip sed udev util-linux vim virt-what wget

# Get Alpine Linux configurations.
confFile="/root/alpine.config"

# Read configs from initial file.
AllDisks=$(grep "AllDisks" $confFile | awk '{print $2}')
LinuxMirror=$(grep "LinuxMirror" $confFile | awk '{print $2}')
TimeZone=$(grep "TimeZone" $confFile | awk '{print $2}')
tmpWORD=$(grep "tmpWORD" $confFile | awk '{print $2}')
sshPORT=$(grep "sshPORT" $confFile | awk '{print $2}')
AlpineTestRepository=$(grep "AlpineTestRepository" $confFile | awk '{print $2}')

# Add edge testing to the repositories
sed -i '$a\${AlpineTestRepository}' /etc/apk/repositories

# Synchronize time from hardware
hwclock -s

# Install and enable ssh
echo root:${tmpWORD} | chpasswd
printf '\nyes' | setup-sshd
sed -ri 's/^#?Port.*/Port ${sshPORT}/g' /etc/ssh/sshd_config

# Delete the initial script itself to prevent to be executed in the new system.
rm -f /etc/local.d/alpineConf.start
rm -f /etc/runlevels/default/local

# Network configurations.
# Setup adapter.
setup-interfaces -a
# Generate network file of "/etc/network/interfaces"
rc-update add networking boot
# Delete network file and replace it by us.
rm -rf /etc/network/interfaces
mv /etc/network/tmp_interfaces /etc/network/interfaces

# Localization
setup-keymap us us
setup-timezone -i ${TimeZone}
setup-ntp chrony

# In arm netboot initramfs init,
# If rtc hardware is detected, add hwclock for system, otherwise add swclock
# This settings will be copied to the new system
# But the new system boot from initramfs chroot can detect rtc hardwa1 correctly
# So we use hwclock manually to fix it
rc-update del swclock boot
rc-update add hwclock boot

# Install to hard drive.
export BOOTLOADER="grub"
printf 'y' | setup-disk -m sys $kernelOpt -s 0 $AllDisks

# Replace "ash" to "bash" as the default shell of the Alpine Linux.
sed -i 's/ash/bash/' /etc/passwd

# Reboot, the system in the memory will all be written to the hard drive.
exec reboot
