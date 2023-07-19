#!/bin/bash
#
# kpartx and qumu-utils are required
apt install cron kpartx mount qemu-utils -y
# get valid loop device
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)
websiteDir="/www/wwwroot/cloud-images.a.disk.re/Arch"
distName="Arch-Linux"

for archVer in "x86_64"; do
  fileName="${distName}-${archVer}-cloudimg"
  wget --no-check-certificate -qO /root/$fileName.qcow2 "https://geo.mirror.pkgbuild.com/images/latest/$fileName.qcow2"
  qemu-img convert -f qcow2 -O raw /root/$fileName.qcow2 /root/$fileName.raw
  losetup $loopDevice /root/$fileName.raw
  mapperDevice=$(kpartx -av $loopDevice | tail -n 1 | grep "$loopDeviceNum" | head -n 1 | awk '{print $3}')
  mount /dev/mapper/$mapperDevice /mnt
  sed -ri 's/net.ifnames=0/net.ifnames=0 biosdevname=0/g' /mnt/etc/default/grub
  sed -ri 's/rw net.ifnames=0/rw net.ifnames=0 biosdevname=0/g' /mnt/boot/grub/grub.cfg
  umount /mnt
  kpartx -dv $loopDevice
  losetup -d $loopDevice
  rm -rf $websiteDir/$fileName.raw
  mv /root/$fileName.raw $websiteDir/$fileName.raw
  rm -rf /root/$fileName.qcow2
done

# write crontab task
if [[ ! `grep -i "autorepackarchcloudimages" /etc/crontab` ]]; then
  sed -i '$i 00 5    * * 0   root    bash /root/autoRepackArchCloudImages.sh' /etc/crontab
  /etc/init.d/cron restart
fi
