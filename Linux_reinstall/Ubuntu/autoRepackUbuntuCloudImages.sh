#!/bin/bash
#
# kpartx and qumu-utils are required
apt update -y
apt install axel cron kpartx mount qemu-utils xz-utils -y
# get valid loop device
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)
linuxName="Ubuntu"
websiteDir="/www/wwwroot/cloud-images.a.disk.re/$linuxName"
[[ ! -d "$websiteDir" ]] && mkdir -p "$websiteDir"

for distName in "jammy" "focal" "noble"; do
	for archType in "amd64" "arm64"; do
		fileName="$distName-server-cloudimg-$archType"
		axel -n 16 -k -q -o /root/$fileName.img "https://cloud-images.ubuntu.com/$distName/current/$fileName.img"
		qemu-img convert -f qcow2 -O raw /root/$fileName.img /root/$fileName.raw
		losetup $loopDevice /root/$fileName.raw
		mapperDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | head -n 1 | awk '{print $3}')
		mount /dev/mapper/$mapperDevice /mnt
		sed -ri 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' /mnt/etc/default/grub
		sed -ri 's/cloudimg-rootfs ro/cloudimg-rootfs ro net.ifnames=0 biosdevname=0/g' /mnt/boot/grub/grub.cfg
		# sed -ri 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=3/g' /mnt/etc/default/grub
		# sed -ri 's/set timeout=0/set timeout=3/g' /mnt/boot/grub/grub.cfg
		umount /mnt
		kpartx -dv $loopDevice
		losetup -d $loopDevice
		xz -z -1 -T 0 /root/$fileName.raw
		mv /root/$fileName.raw.xz /root/$fileName.xz
		rm -rf $websiteDir/$fileName.xz
		mv /root/$fileName.xz $websiteDir/$fileName.xz
		rm -rf $websiteDir/$fileName.raw
		rm -rf /root/$fileName.raw
		rm -rf /root/$fileName.img
	done
done

# write crontab task
if [[ ! $(grep -i "autorepackubuntucloudimages" /etc/crontab) ]]; then
	sed -i '$i 30 4 8-14,22-28 * */7   root    bash /root/autoRepackUbuntuCloudImages.sh' /etc/crontab
	crontab -l
	/etc/init.d/cron reload
	/etc/init.d/cron restart
fi
