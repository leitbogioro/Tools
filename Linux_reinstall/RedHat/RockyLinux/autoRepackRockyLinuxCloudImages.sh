#!/bin/bash
#
# Installing necessary components:
apt update -y
apt install axel cron kpartx mount qemu-utils xfsprogs xz-utils -y
# get valid loop device
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)
linuxName="Rocky"
websiteDir="/www/wwwroot/cloud-images.a.disk.re/$linuxName"
[[ ! -d "$websiteDir" ]] && mkdir -p "$websiteDir"

for distNum in "8" "9"; do
	for archType in "x86_64" "aarch64"; do
		fileName="$linuxName-$distNum-GenericCloud.latest.$archType"
		axel -n 16 -k -q -o /root/$fileName.qcow2 "https://download.rockylinux.org/pub/rocky/$distNum/images/$archType/$fileName.qcow2"
		qemu-img convert -f qcow2 -O raw /root/$fileName.qcow2 /root/$fileName.raw
		losetup $loopDevice /root/$fileName.raw
		grub2EfiDirDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | sed -n '1p' | awk '{print $3}')
		grub2DirDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | sed -n '2p' | awk '{print $3}')
		sysDirDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | sort -rn | sed -n '1p' | awk '{print $3}')
		mount /dev/mapper/$grub2EfiDirDevice /mnt
		sed -ri 's/net.ifnames=0.*/net.ifnames=0 biosdevname=0 crashkernel=0 selinux=0 "/g' /mnt/EFI/$linuxName/grub.cfg
		umount /mnt
		mount /dev/mapper/$grub2DirDevice /mnt
		sed -ri 's/net.ifnames=0.*/net.ifnames=0 biosdevname=0 crashkernel=0 selinux=0 "/g' /mnt/grub2/grub.cfg
		umount /mnt
		mount /dev/mapper/$sysDirDevice /mnt
		sed -ri 's/net.ifnames=0.*/net.ifnames=0 biosdevname=0 crashkernel=0 selinux=0"/g' /mnt/etc/default/grub
		umount /mnt
		kpartx -dv $loopDevice
		losetup -d $loopDevice
		xz -z -1 -T 0 /root/$fileName.raw
		mv /root/$fileName.raw.xz /root/$fileName.xz
		rm -rf $websiteDir/$fileName.xz
		mv /root/$fileName.xz $websiteDir/$fileName.xz
		rm -rf /root/$fileName.raw
		rm -rf /root/$fileName.qcow2
	done
done

# write crontab task
if [[ ! $(grep -i "autorepackrockylinuxcloudimages" /etc/crontab) ]]; then
	sed -i '$i 0 5 */100,1-7 * SUN   root    bash /root/autoRepackRockyLinuxCloudImages.sh' /etc/crontab
	crontab -l
	/etc/init.d/cron reload
	/etc/init.d/cron restart
fi
