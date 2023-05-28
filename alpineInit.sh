#!/bin/ash
# shellcheck shell=dash
# alpine 默认使用 busybox ash

# 显示输出到前台
# 似乎script更优雅，但 alpine 不带 script 命令
# script -f/dev/tty0
exec >/dev/tty0 2>&1

add_community_repo() {
  alpine_ver=$(cut -d. -f1,2 </etc/alpine-release)
  echo http://dl-cdn.alpinelinux.org/alpine/v$alpine_ver/community >>/etc/apk/repositories
}

# 找到主硬盘
xda=$(ls /dev/ | grep -Ex '[shv]da|nvme0n1')

# arm要手动从硬件同步时间，避免访问https出错
hwclock -s

# 安装并打开 ssh
echo root:LeitboGi0ro | chpasswd
printf '\nyes' | setup-sshd

# 还原改动，不然本脚本会被复制到新系统
rm -f /etc/local.d/alpineConf.start
rm -f /etc/runlevels/default/local

# 网络
setup-interfaces -a
# 生成 /etc/network/interfaces
rc-update add networking boot

# 设置
setup-keymap us us
setup-timezone -i Asia/Shanghai
setup-ntp chrony

# 在 arm netboot initramfs init 中
# 如果识别到rtc硬件，就往系统添加hwclock服务，否则添加swclock
# 这个设置也被复制到安装的系统中
# 但是从initramfs chroot到真正的系统后，是能识别rtc硬件的
# 所以我们手动改用hwclock修复这个问题
rc-update del swclock boot
rc-update add hwclock boot

# 通过 setup-alpine 安装会多启用几个服务
# https://github.com/alpinelinux/alpine-conf/blob/c5131e9a038b09881d3d44fb35e86851e406c756/setup-alpine.in#L189
# acpid | default
# crond | default
# seedrng | boot

# 添加 virt-what 用到的社区仓库
add_community_repo

# 如果是 vm 就用 virt 内核
cp /etc/apk/world /tmp/world.old
[[ -n "$(virt-what)" ]] && kernel_opt="-k virt"

# 重置为官方仓库配置
true >/etc/apk/repositories
setup-apkrepos -1
setup-apkcache /var/cache/apk

# 去掉仓库 URL 配置中所有被注释的条目
sed -i 's/#//' /etc/apk/repositories
# 加入 edge testing 作为仓库源之一
sed -i '$a\http://dl-cdn.alpinelinux.org/alpine/edge/testing' /etc/apk/repositories
    
apk update
apk add bash bash-doc bash-completion bind-tools coreutils cpio curl figlet grep gzip lsblk net-tools python3 py3-pip sed vim

# 加入定制 motd  
rm -rf /etc/motd
wget --no-check-certificate -O /etc/profile.d/motd.sh https://gitee.com/mb9e8j2/Tools/raw/master/Linux_reinstall/Alpine/motd.sh
chmod a+x /etc/profile.d/motd.sh

# 替换 Alpine Linux 自带的 ash 为 bash.  
sed -i 's/ash/bash/' /etc/passwd

# 安装到硬盘
# alpine默认使用 syslinux (efi 环境除外)，这里强制使用 grub，方便用脚本再次重装
export BOOTLOADER="grub"
printf 'y' | setup-disk -m sys $kernel_opt -s 0 /dev/$xda

# 重启，此时内存中的系统会被自动写入到硬盘中
exec reboot