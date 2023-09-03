# Tools
Something about scripts
# Linux reinstall useage

![3](3.png)

![1](1.jpg)

![2](2.png)

![4](4.jpg)

![5](5.png)

## If you are not a root user, try to execute the following commands to switch to get root user permission:
<pre><code>sudo -s</code></pre>
Switch to the default direction of the root user
<pre><code>cd ~</code></pre>
And then continue to download and execute this script.

## Dependences and OSs are supporting at the following list to install to the OS that script supported:
Debian series(Debian / Ubuntu / Kali):
<pre><code>apt update -y</code></pre>
<pre><code>apt install wget -y</code></pre>
RedHat series, only based on RedHat 7+, grub2(CentOS / AlmaLinux / CloudLinux / RockyLinux / OracleLinux / Fedora / VzLinux / ScientificOS / RedHat Enterprise Linux / Tencent OpenCloudOS / AWS AmazonLinux / AlibabaCloudLinux or AliyunLinux / OpenAnolis):
<pre><code>yum install wget -y</code></pre>
or (for Redhat 8+):
<pre><code>dnf install wget -y</code></pre>
Alpine Linux:
<pre><code>apk update</code></pre>
<pre><code>apk add bash wget</code></pre>
<pre><code>sed -i 's/root:\/bin\/ash/root:\/bin\/bash/g' /etc/passwd</code></pre>

## Download:
<pre><code>wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh</code></pre>
Servers in mainland of China:
<pre><code>wget --no-check-certificate -qO InstallNET.sh 'https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh</code></pre>

## Quickly start
If you need to add other parameters, version number must be assigned!
### Debian 12
<pre><code>bash InstallNET.sh -debian</code></pre>
### Kali Rolling
<pre><code>bash InstallNET.sh -kali</code></pre>
<b>Kali can be installed and run in OracleCloud Ampere A1 ARM64 machine successfully but there are not any output results in VNC screen, just waiting patiently after installation has been finished!</b>
### Alpine Linux Edge
<pre><code>bash InstallNET.sh -alpine</code></pre>
<b>Alpine Linux is a kind of light Linux release and it's friendly to low memory machine, even 384mb and lower can be executed, but the installation process is unfriendly to low memory because all files will write to the memory and them will write to hard drive at last. 1gb machine have no problem, but it can't install on 768mb or lower machine!</b>
### CentOS 9 stream
<pre><code>bash InstallNET.sh -centos</code></pre>
### AlmaLinux 9
<pre><code>bash InstallNET.sh -almalinux</code></pre>
### RockyLinux 9
<pre><code>bash InstallNET.sh -rockylinux</code></pre>
### Fedora 38
<pre><code>bash InstallNET.sh -fedora</code></pre>
### Ubuntu 22.04
<pre><code>bash InstallNET.sh -ubuntu</code></pre>
### Windows Server 2022
<pre><code>bash InstallNET.sh -windows</code></pre>

## Fully useage sample
<pre><code>bash InstallNET.sh -debian/kali/ubuntu/centos/almalinux/rockylinux/fedora(os type) 11(os version) -version 64(os bit, not necessary) -port "your server port" -pwd "your server password" -mirror "a valid url for linux image source" -dd/--image "dd image url" -filetype "gz or xz" -timezone "like Asia/Tokyo etc" --dhcp-static/--ip-addr 'x.x.x.x'(ip address) --ip-mask 'x.x.x.x'(subnet mask) --ip-gate 'x.x.x.x'(gateway) -firmware(Debian with hardware drivers)</code></pre>

## Parameters detail descriptions
**-debian 9-12** : Debian 9 and later
<br />
<br />

**-kali rolling/dev/experimental** : Kali Rolling, Development and Experimental, "Kali Rolling" is most recommend obviously.
<br />
<br />

**-centos 7 or 8/9-stream**: CentOS 7 and later
<br />
<br />

**-alpine 3.16-3.18/edge**: Alpine Linux 3.16 and later, to keep updating to newest version, "edge" is most recommend obviously.
<br />
<br />

**-almalinux/alma 8/9**: AlmaLinux 8 and later
<br />
<br />

**-rockylinux/rocky 8/9**: RockyLinux 8 and later
<br />
<br />

**-fedora 37/38**: Fedora 37 and later
<br />
<br />

**-ubuntu 20.04/22.04**: Ubuntu from 20.04 and later
<br />
<br />

**-windows 10/11/2012/2016/2019/2022**: Windows 10 Enterprise LTSC, Windows 11 Pro for Workstation 22H2, Windows Server 2012 R2, Windows Server 2016, Windows Server 2019, Windows Server 2022. Supports IPv4 dhcp and static, expand current OS disk partition. Automatic steps must be executed after user logged in.
<br />
<br />

**-mirror "a valid DIST mirror url"**: OS install files resource, you can select one which nearest for actual location of your server to upspeed installation.
<br />
<br />

For Debian, official recommend mirror lists are here:
<br />
<pre><code>https://www.debian.org/mirror/list.html</code></pre>
<br />

For Kali, official recommend mirror lists are here:
<br />
<pre><code>https://http.kali.org/README.mirrorlist</code></pre>
<br />

For Alpine Linux, official recommend mirror lists are here:
<br />
<pre><code>https://mirrors.alpinelinux.org/</code></pre>
<br />

For CentOS 7 and 8-stream, official recommend mirror lists are here:
<br />
<pre><code>https://www.centos.org/download/mirrors/</code></pre>
<br />

For CentOS 9-stream and later, official recommend mirror lists are here:
<br />
<pre><code>https://admin.fedoraproject.org/mirrormanager/mirrors/CentOS</code></pre>
<br />

For AlmaLinux, official recommend mirror lists are here:
<br />
<pre><code>https://mirrors.almalinux.org/</code></pre>
<br />

For RockyLinux, official recommend mirror lists are here:
<br />
<pre><code>https://mirrors.rockylinux.org/mirrormanager/mirrors</code></pre>
<br />

For Fedora, official recommend mirror lists are here:
<br />
<pre><code>https://admin.fedoraproject.org/mirrormanager/mirrors/Fedora</code></pre>
<br />

For Ubuntu, official recommend mirror lists are here:
<br />
<pre><code>https://launchpad.net/ubuntu/+cdmirrors</code></pre>
<br />

**Recommended terminal client is Xshell or Putty**

**-port ""**: you can pre-specify ssh port of system, range is 1~65535, both Redhat series or Debian series could be supported, **default is '22'**.
<br />
<br />

**-pwd ''**: you can pre-specify ssh password of system, both Redhat series or Debian series could be supported, **default is 'LeitboGi0ro'**.
<br />
<br />

**-dd/--image "DD image from a valid url"**: This parameter is for DD mode in KVM or XEN virtualization platform, current os must be Debian series, for example, if you want to DD windows, you can refer to chapter "How to install Windows?" to get more in this document.
<br />
<br />

**-filetype "gz/xz"**: To determine DD file type, not only ".gz"(default) but also ".xz" can be supported.
<br />
<br />

**-timezone "like Asia/Tokyo etc"**: It means assign timezone manually, if you are using a proxy to connect to your machine and then execute "InstallNET.sh", automatic timezone configuration may not suitable for you in this situation.
<br />
<br />

**-raid "0, 1, 5, 6 or 10"**: Test succeed on Debian 12, Kali rolling, CentOS 9-stream, AlmaLinux 9, RockyLinux 9, Fedora 38 with raid 0, 1, 5, 6 or 10 disks raid partition recipes, raid 0 or 1 needs at least 2 disks, raid 5 needs at least 3 disks, raid 6 or 10 needs at least 4 disks, if your machine has only one hard drive, don't assign it!
<br />
<br />

**-setdisk "a name of one disk or all"**: If your machine has 2 or more hard drives, and every hard drive want to format during the installation, you can assign -setdisk "all" to enable it, data is invaluable, you should deal with them carefully! or you can allow system to be installed on one disk like "vdc" or "/dev/sdb", This parameter is only suitable for Debian/Redhat series and conflicts with "-raid".
<br />
<br />

**-partition "mbr" or "gpt"**: Default is "mbr", ext4 file system with mbr partition table, if assign "gpt", the partition method will be as xfs file system with gpt partition table. This is only valid for Debian series, single hard drive formatting environment, not suitable for Raid.
<br />
<br />

**--nomemcheck**: Disable memory check by force so that you can install any OS on any size of the memory in target machine, whether installation will succeed is not guaranteed.
<br />
<br />

**--network "dhcp/auto" or "static/manual"**: Default to use DHCP to finish network configuration. If your cloud provider is a small or middle merchant, the network of your machine may be static so you need to add it. it is equal with add --ip-addr "" --ip-mask "" --ip-gate "", if you add this, don't distribute the following three items again! It must be added in the last of the command.
<br />
<br />

**--networkstack "ipv4" or "ipv6" or "dual"**: To specify one supported IP stack manually by reading related configurations instead of checking connectivity of IP stacks, "ipv4" is for IPv4 stack, "dual" is for IPv4 and IPv6 stack. To make sure the parameter of corresponded stack must has specify configurations in system before assign it.
<br />
<br />

**--ip-addr "IPv4 address"**: It must be added with --ip-gate and --ip-mask together, in this situation, --network "static/manual" is automatically assigned.
<br />
<br />

**--ip-gate "IPv4 gateway"**: It must be added with --ip-addr and --ip-mask together, in this situation, --network "static/manual" is automatically assigned.
<br />
<br />

**--ip-mask "IPv4 subnet musk"**: It must be added with --ip-addr and --ip-gate together, in this situation, --network "static/manual" is automatically assigned, can only accept prefix number transmit. IPv4 CIDR Calculator: https://www.vultr.com/resources/subnet-calculator/
<br />
<br />

**--ip-dns "IPv4 DNS server"**: This one is only for static network configuration and default is 1.0.0.1 and 8.8.4.4, you can also change other IPv4 dns server like 8.8.8.8, 9.9.9.9, 4.4.2.2 etc to replace it. If the network of your machine is DHCP, don't assign it!
<br />
<br />

**--ip6-addr "IPv6 address"**: It must be added with --ip6-gate and --ip6-mask together, in this situation, --network "static/manual" is automatically assigned.
<br />
<br />

**--ip6-gate "IPv6 gateway"**: It must be added with --ip6-addr and --ip6-mask together, in this situation, --network "static/manual" is automatically assigned.
<br />
<br />

**--ip6-mask "IPv6 subnet musk"**: It must be added with --ip6-addr and --ip6-gate together, in this situation, --network "static/manual" is automatically assigned, can only accept prefix number transmit. IPv6 CIDR Calculator: https://en.rakko.tools/tools/27/
<br />
<br />

**--ip6-dns "IPv6 DNS server"**: This one is only for static network configuration and default is 2606:4700:4700::1001 and 2001:4860:4860::8844, you can also change other IPv6 dns server to replace it. If the network of your machine is DHCP, don't assign it!
<br />
<br />

**--setipv6 "0 is disabled"**: Default will enable IPv6, if your machine is IPv4 stack and provided by Racknerd and Virmach etc. they will give IPv6 DNS for IPv4 stack server, the server will access to invalid IPv6 network for priority, not IPv4 first, you can remove all IPv6 modules force in new os by adding --setipv6 "0" to avoid the situation of above.
<br />
<br />

**--adapter "real network adapter interface name of the machine, like ens3, enp6s0 etc."**: If the kernel is added parameter "net.ifnames=0" or "biosdevname=0", all different network adapters' name will be directed to the same like "eth0", "eth1" etc. If you know the the real name of the network adapter and want let them to replace "eth0", please input the correct value, if you are not sure the real name of it, don't assign it!
<br />
<br />

**--netdevice-unite**: This function has an opposite effect of --adapter "real interface name", it will add "net.ifnames=0 biosdevname=0" to the kernel to redirect all different network adapters' interface name to united "eth0", this one don't need to assign any value, I suggest you that before input it and start OS installation, you should backup the real name of the network adapter carefully!
<br />
<br />

**--autoplugadapter**: Only valid for Debian/Kali, when add this, the valid interface config method in /etc/network/interfaces will be replaced from "allow-hotplug" to "auto". For multiple interfaces environment, if the interface which is configurated by "auto", regardless of it is plugged by internet cable, Debian/Kali will continuously try to wake and start up it contains with dhcp even timeout. Set up with "allow-hotplug(default setting by Debian/Kali installer)" will skip this problem, but if one interface has more than 1 IP or it will connect to another network bridge, when system restarted, the interfaces' initialization will be failed, in most of VPS environments, the interfaces of machine should be stable, so replace the default from "allow-hotplug" to "auto" for interfaces config method is a better idea, but it causes some server spending a long time to boot up(try to activate all internet adapters and waiting dhcp fatal time).
<br />
<br />

**-netbootxyz**: Use netbootXYZ(https://netboot.xyz/) to install netbootXYZ supported OS manually, must have VNC, only for x86_64 and AMD64 with BIOS firmware(UEFI is not supported!)
<br />
<br />

**-allbymyself**: Install OS supported by this script manually, must have VNC.
<br />
<br />

**-firmware**: Specify drivers for Debian and Kali to support old hardwares, if your server location is in mainland China, program will switch to mirror of 'University of Science and Technology of China(https://mirrors.ustc.edu.cn/debian-cdimage/)' for downloading more quickly, default mirror is from http://cdimage.debian.org/cdimage/.
<br />
<br />

**-version 32/i386 or 64/amd64 or arm/arm64**: OS bit. Program will automatically detect and redirect the CPU architecture from your machine to new system which would be installed, if you aren't known it well, don't assign it!
<br />
<br />

### Advanced usage, for example Debian 12 (recommend for servers which are locating outside of mainland China)
Japan:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.riken.jp/Linux/debian/debian/"</code></pre>
HongKong:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.hk.debian.org/debian/"</code></pre>
Singapore:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.sg.debian.org/debian/"</code></pre>
South Korea:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.kaist.ac.kr/debian/"</code></pre>
Taiwan:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.tw.debian.org/debian/"</code></pre>

America:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "https://mirrors.ocf.berkeley.edu/debian/"</code></pre>
Canada:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.ca.debian.org/debian/"</code></pre>
Britain:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.uk.debian.org/debian/"</code></pre>
Germany:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.de.debian.org/debian/"</code></pre>
France:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.fr.debian.org/debian/"</code></pre>
Netherlands:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.nl.debian.org/debian/"</code></pre>
Switzerland:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.ch.debian.org/debian/"</code></pre>
Russia:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.ru.debian.org/debian/"</code></pre>
Australia:
<br />
<pre><code>bash InstallNET.sh -debian 12 -mirror "http://ftp.au.debian.org/debian/"</code></pre>

## Default configurations
### Time zone
Depends on the geo-location of guest's IP(automode) or "Asia/Tokyo"(if the format of the input parameter is incorrect or it's not supported by current operating system in manual mode)
### Default user name
root
### Default password
LeitboGi0ro
### Default port
The same as the former system which you were connected by terminal, if script can't find any port on the former system, the default is 22.
<br />
<br />
<b>If you didn't assign any other ssh password or port, after system installation, you must change password(LeitboGi0ro) and ssh port(22) immediately to prevent unauthorized access!</b>
<br />
<br />

## Errors and solutions:
In some versions of CentOS 8 which are not subsumed into CentOS-stream are end of supporting by CentOS official, so the source is failure:
<pre><code>Failed to synchronize cache for repo 'baseos', ignoring this repo.
Failed to synchronize cache for repo 'appstream', ignoring this repo.</pre></code>
You first need to fix the source available and then execute this script.
<pre><code>cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*</pre></code>
If script notices any error like in "# Check Dependence", please execute it again!
<br />
<br />
If you have enabled and assigned IPv6 address after server had been created in the website panel of some cloud providers like Oracle etc. but IPv6 is still invalid in the original system, you can try "dhclient" command to enable IPv6, the same as IPv4:
<pre><code>dhclient -6 "network adapter name"</pre></code>
<pre><code>dhclient -4 "network adapter name"</pre></code>

## How to install Windows?
Notice: Microsoft products and services—including images, text, and software downloads (the "content")—are owned either by Microsoft Corporation or by third parties who have granted Microsoft permission to use the content. Microsoft cannot grant you permission for content that is owned by third parties. You may only copy, modify, distribute, display, license, or sell the content if you are granted explicit permission within the End-User License Agreement (EULA) or license terms that accompany the content or are provided in the following guidelines. For more information, consult your copyright attorney.
<br />
<br />
<b>"InstallNET.sh" doesn't provide any third-part activation service for Windows, this function is only aim to assist you with researching, evaluating related features of Windows. "InstallNET.sh" is not responsible or liable if someone cause any illegal circumstance or lose their data by inappropriate using without any backups. "InstallNET.sh" only supports your server to install from Linux to Windows but it can't work well in Windows so that you have no more chance to use "InstallNET.sh" to install from Windows to Linux again.</b>
### Servers based on KVM or XEN or QEMU virtualization, the middle handling linux system is Debian 12(bookworm):
<pre><code>bash InstallNET.sh -dd 'DD image download URL'</code></pre>
### Servers based on physical hardware, Intel network adapter, kimsufi etc:
Change netboot to rescue mode, receive mail, get temporary username and password, login rescue linux, execute:
<pre><code>wget -O- 'DD download URL' | xzcat | dd of=/dev/sda</code></pre>
Wait until downloading and unpackaging are all finished, change netboot to formal mode, restart rescue linux:
<pre><code>reboot</code></pre>
#### Initial connection configurations, hardware requirements and available Windows series DD image download URLs which are provided by TeddySun(thanks for his efforts, here is his blog: https://teddysun.com/):
Username: **Administrator**
<br />
Password: **Teddysun.com**
<br />
RDC(Remote Desktop Connection) port: 5900
<br />
Network: **IPv4 DHCP is necessary**
<br />
CPU: **AMD64** architecture, single core at least, dual core or more is recommend.
<br />
Hard Drive: **20GB at least**, 50GB or more, SSD is recommend.
<br />
Memory: **2GB at least**, 8GB or more is recommend.

##### For BIOS firmware and MBR partition table #####

- Windows 11 Pro for Workstations 22H2

Chinese: https://dl.lamp.sh/vhd/zh-cn_windows11_22h2.xz
<br />
English: https://dl.lamp.sh/vhd/en-us_windows11_22h2.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja-jp_windows11_22h2.xz
<br />

- Windows Server 2022 Datacenter

Chinese: https://dl.lamp.sh/vhd/zh-cn_win2022.xz
<br />
English: https://dl.lamp.sh/vhd/en-us_win2022.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja-jp_win2022.xz
<br />

- Windows 10 Enterprise LTSC

Chinese: https://dl.lamp.sh/vhd/zh-cn_windows10_ltsc.xz
<br />
English: https://dl.lamp.sh/vhd/en-us_windows10_ltsc.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja-jp_windows10_ltsc.xz
<br />

- Windows Server 2012 R2 Datacenter

Chinese: https://dl.lamp.sh/vhd/cn_win2012r2.xz
<br />
English: https://dl.lamp.sh/vhd/en_win2012r2.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja_win2012r2.xz

##### For UEFI firmware and GPT partition table #####

- Windows 11 Pro for Workstations 22H2

Chinese: https://dl.lamp.sh/vhd/zh-cn_windows11_22h2_uefi.xz
<br />
English: https://dl.lamp.sh/vhd/en-us_windows11_22h2_uefi.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja-jp_windows11_22h2_uefi.xz
<br />

- Windows Server 2022 Datacenter

Chinese: https://dl.lamp.sh/vhd/zh-cn_win2022_uefi.xz
<br />
English: https://dl.lamp.sh/vhd/en-us_win2022_uefi.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja-jp_win2022_uefi.xz
<br />

- Windows 10 Enterprise LTSC

Chinese: https://dl.lamp.sh/vhd/zh-cn_win10_ltsc_uefi.xz
<br />
English: https://dl.lamp.sh/vhd/en-us_win10_ltsc_uefi.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja-jp_win10_ltsc_uefi.xz
<br />

- Windows Server 2012 R2 Datacenter

Chinese: https://dl.lamp.sh/vhd/cn_win2012r2_uefi.xz
<br />
English: https://dl.lamp.sh/vhd/en_win2012r2_uefi.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja_win2012r2_uefi.xz
<br />

## Features and updates:
- "InstallNET.sh" will give you a clean, safe, official Linux system, and help you escape of your server providers' monitoring.
- The operation is easy, several minutes installation will be complated.
- Support install to Debian series(including Debian 8+, Ubuntu 14.04 ~ 20.04), Redhat series(including CentOS 7+, AlmaLinux 8+, RockyLinux 8+, Fedora 34+).
- Can also run in mainline version of other Redhat series(Oracle Linux 7+, VzLinux 8+) to install supported system.
- Support major cloud providers, especially support Oracle Cloud ARM machine.
- Detect the CPU architecture of current os and exchange correct architecture to new system automatically, you need not to add parameter '-version' at all to comfirm architecture manually.
- Can handle boot menuentry items automatically of grub2 in different hardware platforms(AMD64 legacy / AMD64 UEFI / ARM64 UEFI) to make sure all supported boot file can be loaded correctly.
- Support install from Linux(Debian series only) to Windows. details refer to "How to install Windows?" section.
- Support IPv6 single-stack(have only IPv6 public address and IPv4 intranet routing) server like Vultr 2.5$ monthly plan, only for DHCP.
- Support network auto configurations in bio-stack(have both IPv4 and IPv6 public address), after log into new system, you don't have to config IPv6 address manually, only for Debian, DHCP.
- You can modify architecture, mirror, firmware, ssh port, password etc. 
- Friendly to low memory device, for Debian series, recommend RAM is above 512MB, for Redhat series, recommend RAM is above 2GB.</b>
- Ubuntu 22.04 has cancelled net boot start features, so this program don't support Ubuntu 22.04 and above reinstallation, source: http://archive.ubuntu.com/ubuntu/dists/jammy/main/installer-amd64/current/legacy-images/: The Legacy Ubuntu Server Installer is no longer available, initrd.gz and linux netboot file for arm64 architecture as also.
- The Debian official mirror of South Korea http://ftp.kr.debian.org/debian/ is usually crashed down, so I changed recommend mirror as Jaist University https://www.jaist.ac.jp/index.html, for Japan is from https://www.riken.jp/, a science research organization, for America is from University of California, Berkeley: https://www.berkeley.edu/.
- Completely modified Debian, such as support terminal files colorful displaying, permanently change dns server, disable expired certificates, add on a cute welcome introduction, pre-install many complements in preseeding progress, now enjoy a newly, comfortable, graceful debian experience!
- Support grub2 boot file modify, it can switch Debian series to Redhat series or switch Redhat series to Debian series smoothly, in old version if you installed from Debian series to Redhat series, you can never switch to Debian series again.
- Support xfs file system(only for Debian 9 and later), it's better than the old ext2 and it's the default option of Redhat series, the file system of raid 0 disk partition mode is ext4.
- Detect if the machine is operating in mainland of China or outside and switch mirror automatically.
- Support the parameter of '-port' to modify ssh port of Redhat series.
- Detect the network of device is DHCP or static automatically.
- For windows DD package, default compression method is "gz", if your package is ".xz", you can add parameter -filetype "xz" to decompress it.
- Support Raid 0, to add parameter -raid "0", the validation need to be certificated.
- Disable ntp clock setup for static network in Debian/Ubuntu installation otherwise it may cause static network failed.
- Fix if input --ip-addr "" --ip-mask "" --ip-gate "", static network configuration may not valid.
- Support config timezone automatically according to the geo-location of the guest's IP or determine an existed timezone parameter to config it manually is also be supported.
- Concentrate all needed installation of dependences to inner command except "wget" because you need to download "InstallNET.sh" first.
- Change name server for Debian permanently is provided by "resolvconf", related configuration files has been written. you just need to logging in new installed system, and install "resolvconf":
<pre><code>echo "O" | apt install resolvconf -y</code></pre>
to make changes validating!
- Support Debian 12.
- Update pre-install components, python2 to python3, vim-gtk2 to vim-gtk3 for support Debian 12.
- Creat a new algorithm for checking effectiveness about IPv6, it's applied in 10-sysinfo for motd file in Debian and the main program "InstallNET.sh".
- Because of boot menuentry configuration in grub file "grub.cfg" from RockyLinux 9 of official template of Oracle Cloud is different from other standard Redhat like os(version 7+) compeletely, so I creat a new algorithm for handle this and all of similar situation in future.
- Update vim file modification for Debian 12.
- Because of github.com and githubusercontent.com etc are banned by China, so I switich external files download sources which are necessary for Debian or Redhat like os example files for motd, firewall configurations etc. If your server is in mainland of China, the external files will be downloaded from https://gitee.com/mb9e8j2/Tools/, the other country/area will also be downloaded in this depository.
- Try to enable IPv4 and IPv6 dhcp if possible.
- Add necessary annotates
- Set default installation os as Debian 12 and the value of architecture is empty instead of AMD64 because program will check architecture automatically.

## Defects:
- Not support for Ubuntu 22.04(jammy) and further versions because Canonical has deprecated the traditions which were also applied together with Debian by forcing users to download a huge several gigabytes iso image and then load it in its&apos; fuckin Cloud-init instead of just two simply a hundred megabytes total network boot files by PXE boot, it runs in QEMU environment and CPU hardware virtualization must be demanded but most of VPS can&apos;t handle it well at all. Canonical has developed into a mature commercial company which intends to earn more money from major partners so they discrimes their personal users intentionally who are low-end clients in their conceptions certainly despite these users were their devoted fans since always and helped Canonical to make great achieves today step by step. According to the behavior of discarding a large amount of former precious Debian installer preseed heritances, Canonical would play a role as a guilty dictator like Apple.Inc in more areas and then violate the spirit of the universal free software finally.
- For Redhat series 8, the minimum memory requirement is 2.5GB, for Redhat series 9, the minimum memory requirement is 2GB.
- Because the syntax of grub1 in Redhat series 6 is different from other Linux version of grub1 or grub2 completely, so I removed support to CentOS 6 and Oracle Linux 6.
- All system templates of GCP are not supported.
___

# .bashrc
.bashrc is a script file system which contains a series of configurations for the terminal session. when the user logs in. The file itself includes highlight settingup for different files.
how to use?
## Delete default .bashrc
<pre><code>rm -rf ~/.bashrc</code></pre>
## Download .bashrc and reboot your system
<pre><code>wget --no-check-certificate -qO ~/.bashrc 'https://raw.githubusercontent.com/leitbogioro/Tools/master/.bashrc' && chmod a+x .bashrc
<br />
<br />reboot</code></pre>

# GroupPolicy import and export
This ".bat" script can only run in Windows. Although only one group-policy rule in Windows can be exported at a time and not support a global one and also have no GUI entrance to import another backuped group policy which exported from another computer. It can help you import or export GroupPolicy conveniently.
## Attentions
<ul>
<li>Compatible with all versions of Windows.</li>
<li>Only support the group-policy rules which exported by this script.</li>
<li>If you want to export group-policy rules. Folder which included group-policy files corresponds to current OS version strictly. Not support export rules which is different from current OS version.</li>
<li>Export operation is irreversible, be cautious to run it！</li>
<li>I provided a suggested rules file about Windows Server 2016.</li>
<li>You should run it on desktop.</li>
</ul>
