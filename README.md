# Tools
Something about scripts
# Linux reinstall useage
## Features:
- "InstallNET.sh" will give you a clean, safe, official Linux system, and help you escape of your server providers' monitoring.
- The operation is easy, several minutes installation will be complated.
- Support Debian 8+, Ubuntu 14.04+, CentOS 6.
- Support major cloud providers, especially support Oracle Cloud ARM machine.
- Support install from Linux to Windows. details refer to "How to install Windows?" section.
- Support single-stack(only have IPv6 public address) server like Vultr 2.5$/mo model, only for DHCP.
- Support network auto configurations in bio-stack(have both IPv4 and IPv6 public address), after log into system, you don't have to config IPv6 address manually, only for Debian, DHCP.
- You can modify architecture, mirror, firmware, ssh port, password etc. 
- Friendly to low memory machine(recommend RAM above 256MB), <b>If your machine RAM is less than 768MB, before Debian 11 and above version installation, you may should not bash it with "-firmware" or "-firmware --cdimage" parameters because it won't let machine installation go into low memory mode and causes installation failed!</b>
- Ubuntu 22.04 has cancelled net boot start features, so this program don't support Ubuntu 22.04 and above reinstallation(source: https://www.reddit.com/r/Ubuntu/comments/uroape/is_there_a_netbootiso_equivalent_for_2204_jammy/).
- South Korea debian official mirror(http://ftp.kr.debian.org/debian/) is usually crashed down, so I change mirror of Kyoto University to replace it. Japan debian mirror is from https://www.riken.jp/, a science research organization in Japan. America debian mirror is from Massachusetts Institute of Technology: https://web.mit.edu/.
- Completely  modified debian, such as support terminal files colorful displaying, permanently change dns server, disable expired certificates, add on a cute welcome introduction, pre-install many complements in preseeding progress, now enjoy a newly, comfortable, graceful debian experience!

![1](1.jpg)

- Change name server for Debian permanently is provided by "resolvconf", related configuration files has been written. you just need to logging in new installed system, and install "resolvconf":
<pre><code>echo "O" | apt install resolvconf -y</code></pre>
to make changes validating!

## Defects:
- Debian preseeding process can only config one IP address, for bio-stack machine(both have IPv4 and IPv6 address), after loggin to new system, you can realize that only IPv4 address has been configurated, we need to config IPv6 address manually.
<br />
edit network interfaces:
<br />
<br />
<pre><code>vim /etc/network/interfaces</code></pre>
add ipv6 configurations:
<br />
<br />
<pre><code>iface ens3 inet6 static
        address ::1
        netmask 64
        dns-nameservers 2606:4700:4700:0:0:0:0:6400</code></pre>
In above sample, you just need to change "::1" to your own IPv6 address which assigned by your cloud provider. "netmask" 64 is a typical value, "dns-nameservers" is from Cloudflare.com.
<br />
<br />
Save files and restart system.
<br />
<br />
<pre><code>:wq
reboot</code></pre>
<br />

- "InstallNET.sh" doesn't support pure IPv6 stack machine(have no IPv4 address, such as Vultr.com 2.5$/month plan).

## Download:
<pre><code>wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh</code></pre>

## Dependences:
Debian series(Debian/Ubuntu):
<pre><code>apt install xz-utils dnsutils wget file -y</code></pre>
Redhat series(CentOS/Almalinux/Rockylinux/Oraclelinux/Fedora):
<pre><code>yum install xz dnsutils wget file -y</code></pre>

## Fully useage sample
<pre><code>bash InstallNET.sh -d/u/c(os type) 11(os version) -v 64(os bit) -port "your server port" -pwd "your server password" -a(auto install)/m(manually in VNC) -mirror "a valid url for OS image source" --ip-addr 'x.x.x.x'(ip address) --ip-mask 'x.x.x.x'(subnet mask) --ip-gate 'x.x.x.x'(gateway) -firmware(with hardware drivers) --cdimage "cn"(this option is only for Debian)</code></pre>

## Parameters Descriptions
**-d** : Debian
<br />
<br />

**-u**: Ubuntu
<br />
<br />

**-c**: CentOS
<br />
<br />

**32/i386 or 64/amd64 or arm64**: OS bit
<br />
<br />

**-mirror**: OS install files resource, you can select one which nearest for actual location of your server to upspeed installation.
<br />
<br />

for Debian, official recommend mirror lists are here:
<br />
<pre><code>https://www.debian.org/mirror/list.html</code></pre>
<br />

for Ubuntu, official recommend mirror lists are here:
<br />
<pre><code>https://launchpad.net/ubuntu/+cdmirrors</code></pre>
<br />

for CentOS, official recommend mirror lists are here:
<br />
<pre><code>https://www.centos.org/download/mirrors/</code></pre>
<br />

**-firmware or -firmware --cdimage "cn"**: specify hardware drivers for Debian, if your server location is in mainland China, you can prefer it to mirror of 'University of Science and Technology of China(https://mirrors.ustc.edu.cn/debian-cdimage/)' for downloading more quickly, default mirror is from http://cdimage.debian.org/cdimage/.
<br />
<br />

**-port**: you can pre-specify ssh port of system, range is 1~65535, **default is '22'**.
<br />
<br />

**-pwd**: you can pre-specify ssh password of system, **default is 'LeitboGi0ro'**.
<br />
<br />

**--ip-addr**: if your cloud provider is from GCP etc, you should input it manually.
<br />
<br />

**--ip-gate**: if your cloud provider is from GCP etc, you should input it manually.
<br />
<br />

**--ip-mask**: if your cloud provider is from GCP etc, you should input it manually.
<br />
<br />

## Quickly start
### Debian 8
<pre><code>bash InstallNET.sh -d 8 -v 64 -a</code></pre>
### Debian 9
<pre><code>bash InstallNET.sh -d 9 -v 64 -a</code></pre>
### Debian 10
<pre><code>bash InstallNET.sh -d 10 -v 64 -a</code></pre>
### Debian 11 (prefer mirror manually with firmware, recommend for servers which are locating in mainland China)
Tsinghua University:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "https://mirrors.tuna.tsinghua.edu.cn/debian/" -firmware --cdimage "cn"</code></pre>
<br />
for low memory(less than 768MB) machines, you can bash:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "https://mirrors.tuna.tsinghua.edu.cn/debian/" -dnserv "cn"</code></pre>
<br />
Netease, Inc:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://mirrors.163.com/debian/" -firmware --cdimage "cn"</code></pre>
<br />
for low memory(less than 768MB) machines, you can bash:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://mirrors.163.com/debian/" -dnserv "cn"</code></pre>
<br />
Tencent Cloud:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://mirrors.cloud.tencent.com/debian/" -firmware --cdimage "cn"</code></pre>
<br />
for low memory(less than 768MB) machines, you can bash:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://mirrors.cloud.tencent.com/debian/" -dnserv "cn"</code></pre>
<br />
Alibaba Cloud:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://mirrors.aliyun.com/debian/" -firmware --cdimage 'cn'</code></pre>
<br />
for low memory(less than 768MB) machines, you can bash:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://mirrors.aliyun.com/debian/" -dnserv "cn"</code></pre>
<br />

### Debian 11 (prefer mirror manually with firmware, recommend for servers which are locating outside of mainland China)
Japan:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.riken.jp/Linux/debian/debian/" -firmware</code></pre>
<br />
for low memory(less than 768MB) machines, you can bash:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.riken.jp/Linux/debian/debian/"</code></pre>
<br />
HongKong:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.hk.debian.org/debian/" -firmware</code></pre>
<br />
for low memory(less than 768MB) machines, you can bash:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.hk.debian.org/debian/"</code></pre>
<br />
Singapore:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.sg.debian.org/debian/" -firmware</code></pre>
<br />
for low memory(less than 768MB) machines, you can bash:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.sg.debian.org/debian/"</code></pre>
<br />
South Korea:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://studenno.kugi.kyoto-u.ac.jp/debian/" -firmware</code></pre>
<br />
for low memory(less than 768MB) machines, you can bash:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://studenno.kugi.kyoto-u.ac.jp/debian/"</code></pre>
<br />
Taiwan:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.tw.debian.org/debian/" -firmware</code></pre>
America:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://debian.csail.mit.edu/debian/" -firmware</code></pre>
<br />
for low memory(less than 768MB) machines, you can bash:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://debian.csail.mit.edu/debian/"</code></pre>
<br />
Canada:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.ca.debian.org/debian/" -firmware</code></pre>
British:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.uk.debian.org/debian/" -firmware</code></pre>
Germany:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.de.debian.org/debian/" -firmware</code></pre>
France:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.fr.debian.org/debian/" -firmware</code></pre>
Russia:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.ru.debian.org/debian/" -firmware</code></pre>
Australia:
<br />
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://ftp.au.debian.org/debian/" -firmware</code></pre>

### Ubuntu 16.04
<pre><code>bash InstallNET.sh -u 16.04 -v 64 -a</code></pre>
### Ubuntu 18.04
<pre><code>bash InstallNET.sh -u 18.04 -v 64 -a</code></pre>
### Ubuntu 20.04
<pre><code>bash InstallNET.sh -u 20.04 -v 64 -a</code></pre>
### Cent OS 6
<pre><code>bash InstallNET.sh -c 6.10 -v 64 -a</code></pre>
## Default Configurations
### Time zone
Asia Tokyo
### Default User name
root
### Default Password
LeitboGi0ro
### Default Port
22
<br />
<br />
<b>After system installation, you must change passwords immediately if you assigned default password(LeitboGi0ro)!</b>
<br />
<br />

## How to install Windows?
Notice: Microsoft products and services—including images, text, and software downloads (the "content")—are owned either by Microsoft Corporation or by third parties who have granted Microsoft permission to use the content. Microsoft cannot grant you permission for content that is owned by third parties. You may only copy, modify, distribute, display, license, or sell the content if you are granted explicit permission within the End-User License Agreement (EULA) or license terms that accompany the content or are provided in the following guidelines. For more information, consult your copyright attorney.
<br />
<br />
<b>"installNET.sh" doesn't provide any third-part activation service for Windows, this function is only help you to research, evaluate related features of Windows. "installNET.sh" is not responsible or liable if someone cause any illegal circumstance.</b>
### Servers based on KVM or XEN virtualization:
<pre><code>bash InstallNET.sh -dd "DD image download URL"</code></pre>
### Servers based on physical hardware, Intel network adapter, kimsufi etc:
Change netboot to rescue mode, receive mail, get temporary username and password, log into linux, execute:
<pre><code>wget -O- "DD download URL" | xzcat | dd of=/dev/sda</code></pre>
### Available Windows DD images:
#### Windows Server series from TeddySun(https://teddysun.com/):
Username: Administrator
<br />
Password: Teddysun.com
<br />
- Windows Server 2022 Datacenter

Chinese: https://dl.lamp.sh/vhd/zh-cn_win2022.xz
<br />
English: https://dl.lamp.sh/vhd/en-us_win2022.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja-jp_win2022.xz
<br />
- Windows Server 2019 Datacenter

Chinese: https://dl.lamp.sh/vhd/cn_win2019.xz
<br />
English: https://dl.lamp.sh/vhd/en_win2019.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja_win2019.xz
<br />
- Windows Server 2012 R2 Datacenter

Chinese: https://dl.lamp.sh/vhd/cn_win2012r2.xz
<br />
English: https://dl.lamp.sh/vhd/en_win2012r2.xz
<br />
Japanese: https://dl.lamp.sh/vhd/ja_win2012r2.xz
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
