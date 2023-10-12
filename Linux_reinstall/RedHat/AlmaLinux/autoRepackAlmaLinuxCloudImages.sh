#!/bin/bash
#
# Installing necessary components:
apt update -y
apt install axel cron kpartx mount qemu-utils xfsprogs xz-utils -y
# get valid loop device
loopDevice=$(echo $(losetup -f))
loopDeviceNum=$(echo $(losetup -f) | cut -d'/' -f 3)
linuxName="AlmaLinux"
websiteDir="/www/wwwroot/cloud-images.a.disk.re/$linuxName"
[[ ! -d "$websiteDir" ]] && mkdir -p "$websiteDir"

for distNum in "9"; do
	for archType in "x86_64" "aarch64"; do
		fileName="$linuxName-$distNum-GenericCloud-latest.$archType"
		# Replace "wget" to "axel" because axel supports multithreading and improve speed of downloading.
		axel -n 16 -k -q -o /root/$fileName.qcow2 "https://repo.almalinux.org/almalinux/$distNum/cloud/$archType/images/$fileName.qcow2"
		qemu-img convert -f qcow2 -O raw /root/$fileName.qcow2 /root/$fileName.raw
		losetup $loopDevice /root/$fileName.raw
		# Add some parameters for kernel aims to "redirect name of network adapters", "disable kdump", "disable selinux".
		grub2DirDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | sort -rn | sed -n '2p' | awk '{print $3}')
		sysDirDevice=$(kpartx -av $loopDevice | grep "$loopDeviceNum" | sort -rn | sed -n '1p' | awk '{print $3}')
		mount /dev/mapper/$grub2DirDevice /mnt
		sed -ri 's/biosdevname=0.*/net.ifnames=0 biosdevname=0 crashkernel=0 selinux=0 "/g' /mnt/grub2/grub.cfg
		umount /mnt
		mount /dev/mapper/$sysDirDevice /mnt
		sed -ri 's/biosdevname=0.*/net.ifnames=0 biosdevname=0 crashkernel=0 selinux=0"/g' /mnt/etc/default/grub
		umount /mnt
		kpartx -dv $loopDevice
		losetup -d $loopDevice
		# Transfer file format from ".raw" to ".xz" because xz can skip sparse files of cloud images and has a very light size aims to reduce I/O of network expenses.
		xz -z -1 -T 0 /root/$fileName.raw
		mv /root/$fileName.raw.xz /root/$fileName.xz
		rm -rf $websiteDir/$fileName.xz
		mv /root/$fileName.xz $websiteDir/$fileName.xz
		rm -rf /root/$fileName.raw
		rm -rf /root/$fileName.qcow2
	done
done

# write crontab task
# Crontab simulator: https://crontab.guru/
# Schedule cronjob for the certain day in a week: https://blog.healthchecks.io/2022/09/schedule-cron-job-the-funky-way/
if [[ ! $(grep -i "autorepackalmalinuxcloudimages" /etc/crontab) ]]; then
	sed -i '$i 0 7 */100,1-7 * SUN   root    bash /root/autoRepackAlmaLinuxCloudImages.sh' /etc/crontab
	crontab -l
	/etc/init.d/cron reload
	/etc/init.d/cron restart
fi
