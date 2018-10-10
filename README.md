# WedTools
Something about website
# Linux reinstall useage
## Notes:
If your VPS is base by Bandwagon and reinstalled OS which constructed by Bandwagon just now, you must reboot and then execute it.
## Download:
<pre><code>wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/WedTools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh</code></pre>
## Install
### Useage
<pre><code>bash InstallNET.sh -[OS name] [OS version] -v [Architecture] -a[Automatic, recommend]/m[Manually in VNC]</pre></code>
### OS name
d: Debian
<br />
u: Ubuntu
<br />
c: CentOS
<br />
Architecture: 32/i386 64/amd64
<br />
for example:
### Debian 8
<pre><code>bash InstallNET.sh -d 8 -v 64 -a</code></pre>
### Debian 9
<pre><code>bash InstallNET.sh -d 9 -v 64 -a</code></pre>
### Ubuntu 16.04
<pre><code>bash InstallNET.sh -u 16.04 -v 64 -a</code></pre>
### Ubuntu 18.04
<pre><code>bash InstallNET.sh -u 18.04 -v 64 -a</code></pre>
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
Vicer
<b>After installed system, you must change passwords immediately.</b>
