# Tools
Something about scripts
# Linux reinstall useage
## Notes:
If your VPS is base by Bandwagon and reinstalled OS which constructed by Bandwagon just now, you must reboot and then execute it.
## Features:
Support Debian 8+, Ubuntu 14.04+, CentOS 6+, you can modify architecture, mirror, firmware, ssh port, password etc for easily to reinstall a cleanly Linux system.
## Download:
<pre><code>wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/WedTools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh</code></pre>
## Install
### Useage
<pre><code>bash InstallNET.sh -[OS name] [OS version] -v [Architecture x86 or x64] -a[Automatic, recommend]/m[Manually in VNC] --mirror '[a Debian/Ubuntu/Debian resource]' -firmware/-firmware --cdimage 'ustc' [these only for Debian, if you're living in China, you can prefer it to University of Science and Technology of China mirror for downloading quickly, default mirror is debian.org] -ssh [ssh port] -p [password]</pre></code>
### Parameters Describes
**-d** : Debian
<br />
<br />

**-u**: Ubuntu
<br />
<br />

**-c**: CentOS
<br />
<br />

**32/i386 64/amd64**: architecture
<br />
<br />

**--mirror**: Install files resource, you can select one which nearest for actual location of your server to upspeed the installation.
<br />
<br />

for Debian, mirror lists are here:
<br />
<pre><code>https://www.debian.org/mirror/list.zh-cn.html</code></pre>
<br />

for Ubuntu, mirror lists are here:
<br />
<pre><code>https://wiki.ubuntu.org.cn/%E6%BA%90%E5%88%97%E8%A1%A8</code></pre>
<br />

for CentOS, mirror lists are here:
<br />
<pre><code>https://www.centos.org/download/mirrors/</code></pre>
<br />

**-firmware/-firmware --cdimage 'ustc'**: specify hardware drivers for Debian.
<br />
<br />

**-ssh**: you can pre-specify ssh port of system, range is 1~65535.
<br />
<br />

**-p**: you can pre-specify ssh password of system, default is 'MoeClub.org'.
<br />
<br />

## for example:
### Debian 8
<pre><code>bash InstallNET.sh -d 8 -v 64 -a</code></pre>
### Debian 9
<pre><code>bash InstallNET.sh -d 9 -v 64 -a</code></pre>
### Debian 10 (Default)
<pre><code>bash InstallNET.sh -d 10 -v 64 -a</code></pre>
### Debian 10 (prefer mirror in China with firmware, recommend for Chinese users)
<pre><code>bash InstallNET.sh -d 10 -v 64 -a --mirror 'https://mirrors.tuna.tsinghua.edu.cn/debian/' -firmware --cdimage 'ustc'</code></pre>
<pre><code>bash InstallNET.sh -d 10 -v 64 -a --mirror 'http://mirrors.163.com/debian/' -firmware --cdimage 'ustc'</code></pre>
<pre><code>bash InstallNET.sh -d 10 -v 64 -a --mirror 'http://mirrors.cloud.tencent.com/debian/' -firmware --cdimage 'ustc'</code></pre>
### Debian 11
<pre><code>bash InstallNET.sh -d 11 -v 64 -a</code></pre>
### Ubuntu 16.04
<pre><code>bash InstallNET.sh -u 16.04 -v 64 -a</code></pre>
### Ubuntu 18.04
<pre><code>bash InstallNET.sh -u 18.04 -v 64 -a</code></pre>
### Ubuntu 20.04
<pre><code>bash InstallNET.sh -u 20.04 -v 64 -a</code></pre>
### Cent OS 6
<pre><code>bash InstallNET.sh -c 6.9 -v 64 -a</code></pre>
### Cent OS 7
<pre><code>bash InstallNET.sh -c 7.5 -v 64 -a</code></pre>
## Default Configurations
### Time zone
Shanghai Asia
### User name
root
### Password
MoeClub.org
### Port
22
<br />
<br />
<b>After installed system, you must change passwords immediately.</b>
<br />
<br />

# GroupPolicy import and export
This .bat script can only run in Windows. Although only one group-policy rule in Windows can be exported at a time and not support a global one and also have no GUI entrance to import another backuped group policy which exported from another computer. It can help you import or export GroupPolicy conveniently.
## Attentions
<ul>
<li>Compatible with all versions of Windows.</li>
<li>Only support the group-policy rules which exported by this script.</li>
<li>If you want to export group-policy rules. Folder which included group-policy files corresponds to current OS version strictly. Not support export rules which is different from current OS version.</li>
<li>Export operation is irreversible, be cautious to run it！</li>
<li>I provided a suggested rules file about Windows Server 2016.</li>
<li>You should run it on desktop.</li>
</ul>
