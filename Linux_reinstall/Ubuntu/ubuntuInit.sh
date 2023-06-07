#!/bin/ash
#
# Alpine Linux use "ash" as the default shell.

exec >/dev/tty0 2>&1

addCommunityRepo() {
  alpineVer=$(cut -d. -f1,2 </etc/alpine-release)
  echo $LinuxMirror/v$alpineVer/community >>/etc/apk/repositories
}

# Delete the initial script itself to prevent to be executed in the new system.
rm -f /etc/local.d/alpineConf.start
rm -f /etc/runlevels/default/local

# Get Ubuntu Linux configurations.
confFile="/root/alpine.config"

# Read configs from initial file.
AllDisks=$(grep "AllDisks" $confFile | awk '{print $2}')
LinuxMirror=$(grep "LinuxMirror" $confFile | awk '{print $2}')
TimeZone=$(grep "TimeZone" $confFile | awk '{print $2}')
tmpWORD=$(grep "tmpWORD" $confFile | awk '{print $2}')
sshPORT=$(grep "sshPORT" $confFile | awk '{print $2}')
AlpineTestRepository=$(grep "AlpineTestRepository" $confFile | awk '{print $2}')
IPv4=$(grep "IPv4" $confFile | awk '{print $2}')
MASK=$(grep "MASK" $confFile | awk '{print $2}')
GATE=$(grep "GATE" $confFile | awk '{print $2}')
ip6Addr=$(grep "ip6Addr" $confFile | awk '{print $2}')
ip6Mask=$(grep "ip6Mask" $confFile | awk '{print $2}')
ip6Gate=$(grep "ip6Gate" $confFile | awk '{print $2}')
HostName=$(grep "HostName" $confFile | awk '{print $2}')

# Reset configurations of repositories
true >/etc/apk/repositories
setup-apkrepos -1
setup-apkcache /var/cache/apk

# Delete comment in the repositories
sed -i 's/#//' /etc/apk/repositories

# Add edge testing to the repositories
sed -i '$a\'${AlpineTestRepository}'' /etc/apk/repositories

# Install necessary components.
apk update
apk add bash coreutils e2fsprogs hdparm multipath-tools parted sed util-linux wget

# start dd
wget -qO- 'https://cloud-images.a.disk.re/Ubuntu/jammy-server-cloudimg-amd64.raw' | dd of="$AllDisks"

# get valid loop device
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)

# make a soft link between valid loop device and disk
losetup $loopDevice $AllDisks

# get mapper partition
mapperDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | head -n 1 | awk '{print $3}')

# mount Ubuntu dd partition to /mnt
mount /dev/mapper/$mapperDevice /mnt

# download cloud init file
wget --no-check-certificate -O /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/Ubuntu/CloudInit/99-fake_cloud.cfg'

# Reboot, the system in the memory will all be written to the hard drive.
exec reboot
