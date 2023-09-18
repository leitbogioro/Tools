#!/bin/ash
#
# Alpine Linux use "ash" as the default shell.

exec >/dev/tty0 2>&1

# Delete the initial script itself to prevent to be executed in the new system.
rm -f /etc/local.d/ubuntuConf.start
rm -f /etc/runlevels/default/local

# Install necessary components.
apk update
apk add bash bash bash-doc bash-completion coreutils grep sed

# Get Ubuntu Linux configurations.
confFile="/root/alpine.config"

# Read configs from initial file.
IncDisk=$(grep "IncDisk" $confFile | awk '{print $2}')
LinuxMirror=$(grep -w "LinuxMirror" $confFile | awk '{print $2}')
alpineVer=$(grep "alpineVer" $confFile | awk '{print $2}')
TimeZone1=$(grep "TimeZone" $confFile | awk '{print $2}' | cut -d'/' -f 1)
TimeZone2=$(grep "TimeZone" $confFile | awk '{print $2}' | cut -d'/' -f 2)
tmpWORD=$(grep -w "tmpWORD" $confFile | awk '{print $2}')
sshPORT=$(grep "sshPORT" $confFile | awk '{print $2}')
networkAdapter=$(grep "networkAdapter" $confFile | awk '{print $2}')
IPv4=$(grep "IPv4" $confFile | awk '{print $2}')
MASK=$(grep "MASK" $confFile | awk '{print $2}')
ipPrefix=$(grep "ipPrefix" $confFile | awk '{print $2}')
actualIp4Prefix=$(grep "actualIp4Prefix" $confFile | awk '{print $2}')
GATE=$(grep "GATE" $confFile | awk '{print $2}')
ipDNS1=$(grep "ipDNS1" $confFile | awk '{print $2}')
ipDNS2=$(grep "ipDNS2" $confFile | awk '{print $2}')
iAddrNum=$(grep "iAddrNum" $confFile | awk '{print $2}')
writeIpsCmd=$(grep "writeIpsCmd" $confFile | awk '{print $2}')
ip6Addr=$(grep "ip6Addr" $confFile | awk '{print $2}')
ip6Mask=$(grep "ip6Mask" $confFile | awk '{print $2}')
actualIp6Prefix=$(grep "actualIp6Prefix" $confFile | awk '{print $2}')
ip6Gate=$(grep "ip6Gate" $confFile | awk '{print $2}')
ip6DNS1=$(grep "ip6DNS1" $confFile | awk '{print $2}')
ip6DNS2=$(grep "ip6DNS2" $confFile | awk '{print $2}')
setIPv6=$(grep "setIPv6" $confFile | awk '{print $2}')
HostName=$(grep "HostName" $confFile | awk '{print $2}')
DDURL=$(grep "DDURL" $confFile | awk '{print $2}')
targetLinuxMirror=$(grep "targetLinuxMirror" $confFile | awk '{print $2}')
cloudInitUrl=$(grep "cloudInitUrl" $confFile | awk '{print $2}')
setFail2banStatus=$(grep "setFail2banStatus" $confFile | awk '{print $2}')

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
apk add ca-certificates e2fsprogs hdparm multipath-tools parted util-linux wget

# start dd
wget --no-check-certificate -qO- "$DDURL" | dd of="$IncDisk"

# get valid loop device
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)

# make a soft link between valid loop device and disk
losetup $loopDevice $IncDisk

# get mapper partition
mapperDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | head -n 1 | awk '{print $3}')

# mount Ubuntu dd partition to /mnt
mount /dev/mapper/$mapperDevice /mnt

# download cloud init file
wget --no-check-certificate -qO /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg ''$cloudInitUrl''

# user config
sed -ri 's/HostName/'${HostName}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/tmpWORD/'${tmpWORD}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/sshPORT/'${sshPORT}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/TimeZone/'${TimeZone1}'\/'${TimeZone2}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/targetLinuxMirror/'${targetLinuxMirror}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/networkAdapter/'${networkAdapter}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
if [[ "$iAddrNum" -ge "2" ]]; then
  sed -ri 's#IPv4/ipPrefix#'${writeIpsCmd}'#g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
else
  sed -ri 's/IPv4/'${IPv4}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
  sed -ri 's/ipPrefix/'${ipPrefix}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
  sed -ri "s/${IPv4}\/${ipPrefix}/${IPv4}\/${actualIp4Prefix}/g" /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
fi
sed -ri 's/GATE/'${GATE}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/ipDNS1/'${ipDNS1}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/ipDNS2/'${ipDNS2}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/ip6Addr/'${ip6Addr}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/ip6Mask/'${ip6Mask}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri "s/${ip6Addr}\/${ip6Mask}/${ip6Addr}\/${actualIp6Prefix}/g" /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/ip6Gate/'${ip6Gate}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/ip6DNS1/'${ip6DNS1}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
sed -ri 's/ip6DNS2/'${ip6DNS2}'/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg

# Disable any datahouse
# Reference: https://github.com/canonical/cloud-init/issues/3772
echo 'datasource_list: [ NoCloud, None ]' > /mnt/etc/cloud/cloud.cfg.d/90_dpkg.cfg

# disable IPv6
[[ "$setIPv6" == "0" ]] && {
  sed -ri 's/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 ipv6.disable=1"/g' /mnt/etc/default/grub
  sed -ri 's/ro net.ifnames=0 biosdevname=0/ro net.ifnames=0 biosdevname=0 ipv6.disable=1/g' /mnt/boot/grub/grub.cfg
}

# disable installing fail2ban
[[ "$setFail2banStatus" != "1" ]] && {
  sed -ri 's/dnsutils fail2ban/dnsutils/g' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg 
  sed -i '/\/etc\/fail2ban/d' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
  sed -i '/fail2ban enable/d' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
  sed -i '/fail2ban restart/d' /mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg
}

# Reboot, the system in the memory will all be written to the hard drive.
exec reboot
