#!/bin/ash
#
# Alpine Linux use "ash" as the default shell.

exec >/dev/tty0 2>&1

# Delete the initial script itself to prevent to be executed in the new system.
rm -f /etc/local.d/rhelConf.start
rm -f /etc/runlevels/default/local

# Install necessary components.
apk update
apk add coreutils grep sed

# Get RHEL Linux configurations.
confFile='/root/alpine.config'
cloudInitFile='/mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg'

# Read configs from initial file.
rhelArchitecture=$(grep "rhelArchitecture" $confFile | awk '{print $2}')
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
i6AddrNum=$(grep "i6AddrNum" $confFile | awk '{print $2}')
writeIp6sCmd=$(grep "writeIp6sCmd" $confFile | awk '{print $2}')
setIPv6=$(grep "setIPv6" $confFile | awk '{print $2}')
HostName=$(grep "HostName" $confFile | awk '{print $2}')
DDURL=$(grep "DDURL" $confFile | awk '{print $2}')
DEC_CMD=$(grep "DEC_CMD" $confFile | awk '{print $2}')
cloudInitUrl=$(grep "cloudInitUrl" $confFile | awk '{print $2}')
RedHatSeries=$(grep "RedHatSeries" $confFile | awk '{print $2}')
lowMemMode=$(grep "lowMemMode" $confFile | awk '{print $2}')
serialConsolePropertiesForGrub=$(grep "serialConsolePropertiesForGrub" $confFile | sed -e 's/serialConsolePropertiesForGrub  //g')

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
apk add hdparm multipath-tools util-linux wget xz

# Start dd.
wget --no-check-certificate --report-speed=bits --tries=0 --timeout=10 --wait=5 -O- "$DDURL" | $DEC_CMD | dd of="$IncDisk" status=progress

# Get valid loop device.
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)

# Make a soft link between valid loop device and disk.
losetup $loopDevice $IncDisk

# Get mapper partition.
mapperDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | sort -rn | sed -n '1p' | awk '{print $3}')

# Mount RHEL dd partition to /mnt .
mount /dev/mapper/$mapperDevice /mnt

# Download cloud init file.
wget --no-check-certificate -qO $cloudInitFile ''$cloudInitUrl''

# User config.
sed -ri 's/HostName/'${HostName}'/g' $cloudInitFile
sed -ri 's/tmpWORD/'${tmpWORD}'/g' $cloudInitFile
sed -ri 's/sshPORT/'${sshPORT}'/g' $cloudInitFile
sed -ri 's/TimeZone/'${TimeZone1}'\/'${TimeZone2}'/g' $cloudInitFile
sed -ri 's/networkAdapter/'${networkAdapter}'/g' $cloudInitFile
if [[ "$iAddrNum" -ge "2" ]]; then
	sed -ri 's#IPv4/ipPrefix#'${writeIpsCmd}'#g' $cloudInitFile
else
	sed -ri 's/IPv4/'${IPv4}'/g' $cloudInitFile
	sed -ri 's/ipPrefix/'${ipPrefix}'/g' $cloudInitFile
	sed -ri "s/${IPv4}\/${ipPrefix}/${IPv4}\/${actualIp4Prefix}/g" $cloudInitFile
fi
sed -ri 's/GATE/'${GATE}'/g' $cloudInitFile
sed -ri 's/ipDNS1/'${ipDNS1}'/g' $cloudInitFile
sed -ri 's/ipDNS2/'${ipDNS2}'/g' $cloudInitFile
if [[ "$i6AddrNum" -ge "2" ]]; then
	sed -ri 's#ip6Addr/ip6Mask#'${writeIp6sCmd}'#g' $cloudInitFile
else
	sed -ri 's/ip6Addr/'${ip6Addr}'/g' $cloudInitFile
	sed -ri 's/ip6Mask/'${ip6Mask}'/g' $cloudInitFile
	sed -ri "s/${ip6Addr}\/${ip6Mask}/${ip6Addr}\/${actualIp6Prefix}/g" $cloudInitFile
fi
sed -ri 's/ip6Gate/'${ip6Gate}'/g' $cloudInitFile
sed -ri 's/ip6DNS1/'${ip6DNS1}'/g' $cloudInitFile
sed -ri 's/ip6DNS2/'${ip6DNS2}'/g' $cloudInitFile

# Disable SELinux permanently.
sed -ri 's/^SELINUX=.*/SELINUX=disabled/g' /mnt/etc/selinux/config

# Disable IPv6.
[[ "$setIPv6" == "0" ]] && sed -ri 's/net.ifnames=0 biosdevname=0/net.ifnames=0 biosdevname=0 ipv6.disable=1/g' /mnt/etc/default/grub

# Add tty console for grub.
sed -ri 's/console=tty0//g' /mnt/etc/default/grub
sed -ri 's/console=ttyS0,115200n8/console=tty1 console=ttyS0,115200n8/g' /mnt/etc/default/grub

# Replace serial console parameters.
[[ -n "$serialConsolePropertiesForGrub" && $(echo "$serialConsolePropertiesForGrub" | sed 's/[[:space:]]/#/g' | grep "ttyAMA[0-9]") ]] && {
	sed -ri 's/console=tty1/console=tty1 console=ttyAMA0,115200n8/g' /mnt/etc/default/grub
}

# Permit root user login by password, change ssh port.
sed -ri 's/^#?PermitRootLogin.*/PermitRootLogin yes/g' /mnt/etc/ssh/sshd_config
sed -ri 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/g' /mnt/etc/ssh/sshd_config
sed -ri 's/^#?Port.*/Port '${sshPORT}'/g' /mnt/etc/ssh/sshd_config

# Disable allocate swap.
# Note: Swap allowcation in "runcmd:" stage during execution of cloud init on aarch64 CPU architecture would cause a fatal because of "cloud-final.service" runs failed.
[[ "$lowMemMode" != "1" || "$rhelArchitecture" == "aarch64" ]] && sed -i '/swapspace/d' $cloudInitFile

# Hack cloud init.
# Note: this trick has a great effect on Ubuntu 20.04+, AlmaLinux / Rocky 9+ in almost any cloud platforms but unfortunately it
# is not suitable for Rocky 8 otherwise cloud init will meet a fatal may because of the lower version of python3.6(others are 3.9).
# More details: https://github.com/leitbogioro/Tools/blob/master/Linux_reinstall/Ubuntu/ubuntuInit.sh
[[ "$RedHatSeries" -ge "9" ]] && {
	utilProgram=$(find /mnt/usr/lib/python* -name "util.py" | grep "cloudinit" | head -n 1)
	sed -ri 's/iso9660/osi9876/g' $utilProgram
	sed -ri 's#"blkid"#"echo"#g' $utilProgram
}

# Umount mounted directory and loop device.
umount /mnt
kpartx -dv $loopDevice
losetup -d $loopDevice

# Reboot, the temporary intermediary system of AlpineLinux which is executing in memory will be destroyed during the power down and then server will reboot to the newly installed system immediately.
exec reboot
