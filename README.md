# Tools
Something about scripts
# Linux reinstall useage
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

![1](1.jpg)

- Change name server for Debian permanently is provided by "resolvconf", related configuration files has been written. you just need to logging in new installed system, and install "resolvconf":
<pre><code>echo "O" | apt install resolvconf -y</code></pre>
to make changes validating!

## Defects:
- Not support for Ubuntu 22.04(jammy) and further versions because Canonical has deprecated the traditions which were also applied together with Debian by forcing users to download a huge several gigabytes iso image and then load it in its' fuckin Cloud-init instead of just two simply a hundred megabytes total network boot files by PXE boot, it runs in QEMU environment and CPU hardware virtualization must be demanded but most of VPS can't handle it well at all. Canonical has developed into a mature commercial company which intends to earn more money from major partners so they discrimes their personal users intentionally who are low-end clients in their conceptions certainly despite these users were their devoted fans since always and helped Canonical to make great achieves today step by step. According to the behavior of discarding a large amount of former precious Debian installer preseed heritances, Canonical would play a role as a guilty dictator like Apple.Inc in more areas and then violate the spirit of the universal free software finally.
