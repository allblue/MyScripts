#!/bin/bash
set -x

#======================================
#挂载硬盘
#======================================

# 安装分区格式
#pacman -S cifs-utils e2fsprogs fuse ntfs-3g xfprogs

# 更新/etc/fsta
#mkdir -p /media/{c,d,e,f,g,h,backup,nas,cd1}
#cat>>/etc/fstab<<EOF
#/dev/sdc3	/media/c	ntfs-3g		defaults	0 0 
#/dev/sdc4	/media/d	ntfs-3g		defaults	0 0 
#/dev/sdb1	/media/e	ntfs-3g		defaults	0 0 
#/dev/sdb2	/media/f	ntfs-3g		defaults	0 0 
#/dev/sdb3	/media/g	ntfs-3g		defaults	0 0 
#/dev/sdb4	/media/h	ntfs-3g		defaults	0 0 
#
#/dev/mapper/ng-backup	/media/backup	xfs		defaults	0 0 
#/dev/mapper/vg0-onedrive	/media/onedrive	xfs		defaults	0 0 
#
#//192.168.123.222/movie /media/nas      cifs    defaults,_netdev,username=age,password=YdL7j3b4JPKQT4Z2qWYVC5AgAVaCj2uuipfExsQMugmugVuv8E9sS4WtbWbV,uid=1000 0 0
#EOF
# 挂载所有硬盘
#mount -a

#======================================
#安装必要软件
#======================================
#更新/etc/pacman.conf
#cat>>/etc/pacman.conf<<EOF
#[multilib]
#Include = /etc/pacman.d/mirrorlist
#
#[archlocal]
#SigLevel = Never
#Server = file:///media/backup/local
#
#[archlinuxcn]
#SigLevel = Never
##Include = /etc/pacman.d/mirrorlist.archlinuxcn
#Server = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch
#
#[blackarch]
#SigLevel = Never
#Include = /etc/pacman.d/mirrorlist.blackarch
#Server = https://mirrors.bfsu.edu.cn/blackarch/blackarch/os/$arch
#EOF
#安装yay
pacman -Syy 
pacman -S -y yay
#安装软件包
NETWORK="brave-bin firefox firefox-i18n-zh-cn thunderbird thunderbird-i18n-zh-cn youtube-dl-gui-git"
OFFICE="dingtalk-linux drawio-desktop-bin goldendict-qt5-git obsidian rclone"
PICS="flameshot"
VIDEO="handbrake handbrake-cli smplayer smplayer-skins smplayer-themes vlc "
TOOLS="crossover doublecmd-qt5 fsearch-git keepassxc  p7zip terminator ventoy-bin xbindkeys"
SYSTEM="alsa-utils chrome-gnome-shell cronie digimend-kernel-drivers-dkms-git fcitx5 fcitx5-chinese-addons fcitx5-configtool fcitx5-gtk fcitx5-qt gnome gnome-extra  gnome-shell gnome-shell-extensions nvidia-settings nvidia-utils os-prober oxygen-icons oxygen-sounds powerline zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting"
FONTS="adobe-source-code-pro-fonts adobe-source-serif-fonts adobe-source-sans-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-ms-fonts ttf-symbola ttf-wps-fonts  wqy-microhei wqy-zenhei"
CROSS32="lib32-alsa-lib lib32-cairo lib32-dbus lib32-gcc-libs lib32-glib2 lib32-glibc lib32-icu "
LOCAL="clashy-bin fqterm-git lx-music-desktop-bin oxygen-sounds sunloginclient ttf-ms-win10-zh_cn ttf-symbola utools vscodium-bin wps-office-cn wps-office-mime-cn wps-office-mui-zh-cn  zy-player-appimage"

yay -S -y $NETWORK $OFFICE $PICS $SYSTEM $TOOLS $VIDEO  $FONTS $CROSS32 $LOCAL 



