# Tools
Something about scripts
# Linux reinstall useage
## Features:
- "InstallNET.sh" will give you a clean, safe, official Linux system, and help you escape of your server providers' monitoring.
- The operation is easy, several minutes installation will be complated.
- Support Debian 8+, Ubuntu 14.04+, CentOS 6.
- Support major cloud providers, especially support Oracle Cloud ARM machine.
- You can modify architecture, mirror, firmware, ssh port, password etc. 
- Friendly to low memory machine(recommend RAM above 256MB), <b>If your machine RAM is less than 768MB, you may should not bash it with "-firmware" or "-firmware --cdimage" parameters because it won't let machine installation go into low memory mode and causes installation failed!</b>
- Ubuntu 22.04 has cancelled net boot start features, so this program don't support Ubuntu 22.04 and above reinstallation(source: https://www.reddit.com/r/Ubuntu/comments/uroape/is_there_a_netbootiso_equivalent_for_2204_jammy/).
- South Korea debian official mirror(http://ftp.kr.debian.org/debian/) is usually crashed down, so I change mirror of Kyoto University to replace it. Japan debian mirror is from https://www.riken.jp/, a science research organization in Japan. America debian mirror is from Massachusetts Institute of Technology: https://web.mit.edu/.
## Download:
<pre><code>wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh</code></pre>
## Fully useage sample
<pre><code>bash InstallNET.sh -d/u/c(os type) 11(os version) -v 64(os bit) -port "your server port" -pwd "your server password" -a(auto install)/m(manually in VNC) -mirror "a valid url for OS image source" -firmware(with hardware drivers) --cdimage "cn"(this option is only for Debian)</code></pre>
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
Netease, Inc:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://mirrors.163.com/debian/" -firmware --cdimage "cn"</code></pre>
Tencent Cloud:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -mirror "http://mirrors.cloud.tencent.com/debian/" -firmware --cdimage "cn"</code></pre>
Alibaba Cloud:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://mirrors.aliyun.com/debian/" --cdimage 'cn'</code></pre>
### Debian 11 (prefer mirror manually with firmware, recommend for servers which are locating outside of mainland China)
Japan:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.riken.jp/Linux/debian/debian/"</code></pre>
HongKong:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.hk.debian.org/debian/"</code></pre>
Singapore:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.sg.debian.org/debian/"</code></pre>
South Korea:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://studenno.kugi.kyoto-u.ac.jp/debian/"</code></pre>
Taiwan:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.tw.debian.org/debian/"</code></pre>
America:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://debian.csail.mit.edu/debian/"</code></pre>
Canada:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.ca.debian.org/debian/"</code></pre>
British:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.uk.debian.org/debian/"</code></pre>
Germany:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.de.debian.org/debian/"</code></pre>
France:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.fr.debian.org/debian/"</code></pre>
Russia:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.ru.debian.org/debian/"</code></pre>
Australia:
<br />
<pre><code>bash InstallNET.sh -d 11 -v 64 -a -firmware -mirror "http://ftp.au.debian.org/debian/"</code></pre>

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
