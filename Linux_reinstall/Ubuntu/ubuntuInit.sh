#!/bin/ash
#
# Alpine Linux use "ash" as the default shell.

exec >/dev/tty0 2>&1

# Delete the initial script itself to prevent to be executed in the new system.
rm -f /etc/local.d/ubuntuConf.start
rm -f /etc/runlevels/default/local

# Install necessary components.
apk update
apk add coreutils grep sed

# Get Ubuntu Linux configurations.
confFile='/root/alpine.config'
cloudInitFile='/mnt/etc/cloud/cloud.cfg.d/99-fake_cloud.cfg'

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
i6AddrNum=$(grep "i6AddrNum" $confFile | awk '{print $2}')
writeIp6sCmd=$(grep "writeIp6sCmd" $confFile | awk '{print $2}')
setIPv6=$(grep "setIPv6" $confFile | awk '{print $2}')
HostName=$(grep "HostName" $confFile | awk '{print $2}')
DDURL=$(grep "DDURL" $confFile | awk '{print $2}')
DEC_CMD=$(grep "DEC_CMD" $confFile | awk '{print $2}')
targetLinuxMirror=$(grep "targetLinuxMirror" $confFile | awk '{print $2}')
targetLinuxSecurityMirror=$(grep "targetLinuxSecurityMirror" $confFile | awk '{print $2}')
cloudInitUrl=$(grep "cloudInitUrl" $confFile | awk '{print $2}')
setFail2banStatus=$(grep "setFail2banStatus" $confFile | awk '{print $2}')

# Reset configurations of repositories.
true >/etc/apk/repositories
setup-apkrepos $LinuxMirror/$alpineVer/main
setup-apkcache /var/cache/apk

# Add community mirror.
sed -i '$a\'$LinuxMirror'/'$alpineVer'/community' /etc/apk/repositories
# Add edge testing to the repositories
# sed -i '$a\'$LinuxMirror'/edge/testing' /etc/apk/repositories

# Synchronize time from hardware.
hwclock -s

# Install necessary components.
apk update
apk add hdparm multipath-tools util-linux wget xz

# Start dd.
wget --no-check-certificate --report-speed=bits --tries=0 --timeout=10 --wait=5 -O- "$DDURL" | $DEC_CMD | dd of="$IncDisk" status=progress

# Get a valid loop device.
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)

# Make a soft link between valid loop device and disk.
losetup $loopDevice $IncDisk

# Get mapper partition.
mapperDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | head -n 1 | awk '{print $3}')

# Mount Ubuntu dd partition to /mnt .
mount /dev/mapper/$mapperDevice /mnt

# Download cloud init file.
wget --no-check-certificate -qO $cloudInitFile ''$cloudInitUrl''

# User config.
sed -ri 's/HostName/'${HostName}'/g' $cloudInitFile
sed -ri 's/tmpWORD/'${tmpWORD}'/g' $cloudInitFile
sed -ri 's/TimeZone/'${TimeZone1}'\/'${TimeZone2}'/g' $cloudInitFile
sed -ri 's/targetLinuxMirror/'${targetLinuxMirror}'/g' $cloudInitFile
sed -ri 's/targetLinuxSecurityMirror/'${targetLinuxSecurityMirror}'/g' $cloudInitFile
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

# Disable any datahouse.
# Reference: https://github.com/canonical/cloud-init/issues/3772
echo 'datasource_list: [ NoCloud, None ]' > /mnt/etc/cloud/cloud.cfg.d/90_dpkg.cfg

# Disable IPv6.
[[ "$setIPv6" == "0" ]] && {
  sed -ri 's/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 ipv6.disable=1"/g' /mnt/etc/default/grub
  sed -ri 's/ro net.ifnames=0 biosdevname=0/ro net.ifnames=0 biosdevname=0 ipv6.disable=1/g' /mnt/boot/grub/grub.cfg
}

# Permit root user login by password, change ssh port.
sed -ri 's/^#?PermitRootLogin.*/PermitRootLogin yes/g' /mnt/etc/ssh/sshd_config
sed -ri 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/g' /mnt/etc/ssh/sshd_config
sed -ri 's/^#?Port.*/Port '${sshPORT}'/g' /mnt/etc/ssh/sshd_config

# Disable installing fail2ban.
[[ "$setFail2banStatus" != "1" ]] && {
  sed -ri 's/dnsutils fail2ban/dnsutils/g' $cloudInitFile 
  sed -i '/\/etc\/fail2ban/d' $cloudInitFile
  sed -i '/fail2ban enable/d' $cloudInitFile
  sed -i '/fail2ban restart/d' $cloudInitFile
}

# Hack cloud init, this method is effective for versions from 22.1.9 to 23.2.2 .
#
# Some cloud providers will storage a set of static cloud init configs which are including like "vendor-data", "meta-data", "network-config" and "user-data" in another hard drive with filesystem of iso like "sr0" or "sdb" etc. :
#
# [root@WIKIHOST-230702AJ306Z ~]# lsblk -ipf
# NAME        FSTYPE  FSVER LABEL  UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
# /dev/sr0    iso9660       cidata 2023-09-01-12-11-27-00                     0   100% /mnt
#
# or
#
# root@crunchbits-DualStackTest1:~# lsblk -ipf
# NAME         FSTYPE   FSVER            LABEL           UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
# /dev/sdb     iso9660  Joliet Extension cidata          2023-09-30-05-08-06-00                     0   100% /mnt
#
# Here is the list of the mounted files:
#
# [root@WIKIHOST-230702AJ306Z ~]# ls /mnt/
# meta-data  network-config  user-data  vendor-data
#
# The initiate priority of these cloud init config files which were offered by cloud providers was executed in the early stage even laid over our cloud init file
# which had been storaged in directory of "/etc/cloud/cloud.cfg.d/" named like "99-fake_cloud.cfg" and the earliest command of "bootcmd:" in "99-fake_cloud.cfg" was
# executed later than them.
#
# If the consequence of this situation could not be resolved entirely, we are unable to set user timezone, permit root password login, config vim settings etc.
# The "user-data" in one cloud provider like "Crunchbits" even prohibit us to root user login although we changed password by "passwd" or added new ssh keys, that's quite serious.
# Here is the sample of file:
#
# root@crunchbits-DualStackTest1:~# cat /mnt/user-data
# #cloud-config
# timezone: Europe/London
# ssh_pwauth: false
# users:
#   -
#     name: root
#     ssh-authorized-keys:
#       - 'ssh-rsa abcde'
#       hashed_passwd: ''
#       lock_passwd: true
# runcmd:
#   - 'DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get ...'
#
# I analyzed the log file of cloud init which can be found in directory of "/var/log/cloud-init.log" in "WikiHost" and got some clues:
#
# 2023-09-29 03:13:20,892 - util.py[DEBUG]: Reading from /var/lib/cloud/seed/nocloud/user-data (quiet=False)
# 2023-09-29 03:13:20,893 - util.py[DEBUG]: Reading from /var/lib/cloud/seed/nocloud/meta-data (quiet=False)
# 2023-09-29 03:13:20,893 - util.py[DEBUG]: Reading from /var/lib/cloud/seed/nocloud/vendor-data (quiet=False)
# 2023-09-29 03:13:20,893 - util.py[DEBUG]: Reading from /var/lib/cloud/seed/nocloud/network-config (quiet=False)
# 2023-09-29 03:13:20,893 - util.py[DEBUG]: Reading from /var/lib/cloud/seed/nocloud-net/user-data (quiet=False)
# 2023-09-29 03:13:20,893 - util.py[DEBUG]: Reading from /var/lib/cloud/seed/nocloud-net/meta-data (quiet=False)
# 2023-09-29 03:13:20,893 - util.py[DEBUG]: Reading from /var/lib/cloud/seed/nocloud-net/vendor-data (quiet=False)
# 2023-09-29 03:13:20,893 - util.py[DEBUG]: Reading from /var/lib/cloud/seed/nocloud-net/network-config (quiet=False)
# 2023-09-29 03:13:20,894 - subp.py[DEBUG]: Running command ['blkid', '-tTYPE=vfat', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 03:13:21,053 - subp.py[DEBUG]: Running command ['blkid', '-tTYPE=iso9660', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 03:13:22,381 - subp.py[DEBUG]: Running command ['blkid', '-tLABEL=CIDATA', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 03:13:22,486 - subp.py[DEBUG]: Running command ['blkid', '-tLABEL=cidata', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 03:13:22,584 - subp.py[DEBUG]: Running command ['blkid', '-tLABEL_FATBOOT=cidata', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 03:13:22,679 - DataSourceNoCloud.py[DEBUG]: Attempting to use data from /dev/sr0
#
# Another log was generated in "Crunchbits":
#
# 2023-09-30 10:39:04,417 - util.py[DEBUG]: Be similar with above and omitted.
# 2023-09-30 10:39:04,417 - subp.py[DEBUG]: Running command ['blkid', '-tTYPE=vfat', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-30 10:39:04,479 - subp.py[DEBUG]: Running command ['blkid', '-tTYPE=iso9660', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-30 10:39:04,572 - subp.py[DEBUG]: Running command ['blkid', '-tLABEL=CIDATA', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-30 10:39:04,663 - subp.py[DEBUG]: Running command ['blkid', '-tLABEL=cidata', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-30 10:39:04,748 - subp.py[DEBUG]: Running command ['blkid', '-tLABEL_FATBOOT=cidata', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-30 10:39:04,836 - DataSourceNoCloud.py[DEBUG]: Attempting to use data from /dev/sdb
#
# The log generated in "Racknerd" which is using "SolusVM" panel to manage and initiate virtual machines without using cloud init, so there are no "user-data" in "/dev/vdb" or "/dev/sr1" etc.
# and the initial of cloud init was not affected by items came from upstream cloud providers. Here is the record:
#
# 2023-09-29 21:37:54,936 - util.py[DEBUG]: Be similar with above and omitted.
# 2023-09-29 21:37:54,936 - subp.py[DEBUG]: Running command ['blkid', '-tTYPE=vfat', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 21:37:55,007 - subp.py[DEBUG]: Running command ['blkid', '-tTYPE=iso9660', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 21:37:55,065 - subp.py[DEBUG]: Running command ['blkid', '-tLABEL=CIDATA', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 21:37:55,128 - subp.py[DEBUG]: Running command ['blkid', '-tLABEL=cidata', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 21:37:55,191 - subp.py[DEBUG]: Running command ['blkid', '-tLABEL_FATBOOT=cidata', '-odevice'] with allowed return codes [0, 2] (shell=False, capture=True)
# 2023-09-29 21:37:55,254 - __init__.py[DEBUG]: Datasource DataSourceNoCloud [seed=None][dsmode=net] not updated for events: boot-new-instance
# 2023-09-29 21:37:55,254 - handlers.py[DEBUG]: finish: init-local/search-NoCloud: SUCCESS: no local data found from DataSourceNoCloud
#
# I'm not quite familiar with python, but I discovered that "subp.py" called "blkid" commands of bash and tried to found any valid cloud init configs if they were in any filesystem of iso9660 drive
# and then applied them on a very, very, very early stage. That's why we wrote our own cloud init configs into "99-fake_cloud.cfg" even through but it was not be executed completely.
# We can also use "blkid" to repeat the behavior of cloud init, here are the results of those three machines:
#
# root@crunchbits-DualStackTest1:~# blkid -tTYPE=vfat -odevice
# /dev/sda15
# root@crunchbits-DualStackTest1:~# blkid -tTYPE=iso9660 -odevice
# /dev/sdb
# root@crunchbits-DualStackTest1:~# blkid -tLABEL=cidata -odevice
# /dev/sdb
#
# [root@WIKIHOST-230702AJ306Z ~]# blkid -tTYPE=vfat -odevice
# /dev/vda1
# [root@WIKIHOST-230702AJ306Z ~]# blkid -tTYPE=iso9660 -odevice
# /dev/sr0
# [root@WIKIHOST-230702AJ306Z ~]# blkid -tLABEL=cidata -odevice
# /dev/sr0
#
# root@racknerd-20fb37:~# blkid -tTYPE=vfat -odevice
# /dev/vda15
# root@racknerd-20fb37:~# blkid -tTYPE=iso9660 -odevice
# root@racknerd-20fb37:~# blkid -tLABEL=cidata -odevice
#
# We can make a obvious conclusion that when booting from a newly installed linux system which belongs to cloud image, cloud init will scan any valid iso filesystem hard drives and attempt to
# find any existed valid cloud init configs which were named by "meta-data, user-data etc." and treat them as the most prioritized configs so that this case contributes to bring a fatal for us
# to use our own cloud init config whatever we put any commands in it even in "bootcmd:" because it was executed extremely later than those cloud inits which were storaged in iso drives.
# I'm so confused that why Canonical has a almost maniacal passion and strange persistence with iso image not only on this case but also on deleting compatible with Debian "preseed" unattended installation method.
# They didn't intent to deliver a similar solution but told all individual users to install Ubuntu 22.04+ with downloading a huge iso image finally.
# So fuck you son of bitch, Canonical!
#
# We can replace all key words of "iso9660" and "blkid" in "util.py" which belongs to a component of cloud init and give it a failure of finding other hard drives.
#
# Due to dissimilar versions of python 3 and other factors, in different linux distributions of cloud images,
# the directory which contains main programs of cloud init may not the same, for examples:
#
# Official cloud image of Ubuntu 22.04.3:
# /usr/lib/python3/dist-packages/cloudinit/*
#
# Official cloud image of Rocky Linux 9.2:
# /usr/lib/python3.9/site-packages/cloudinit/*

utilProgram=$(find /mnt/usr/lib/python* -name "util.py" | grep "cloudinit" | head -n 1)
sed -ri 's/iso9660/osi9876/g' $utilProgram
sed -ri 's#"blkid"#"echo"#g' $utilProgram

# Umount mounted directory and loop device.
umount /mnt
kpartx -dv $loopDevice
losetup -d $loopDevice

# Reboot, the temporary intermediary system of AlpineLinux which is executing in memory will be destroyed during the power down and soon reboot to the newly system.
exec reboot
