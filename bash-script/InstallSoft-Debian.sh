#!/bin/bash
set -x
apt update
apt -y install software-properties-common dirmngr apt-transport-https lsb-release ca-certificates

apt-add-repository 'deb https://apt.atzlinux.com/atzlinux buster main contrib non-free'
apt-key add ./public.key
apt update

NETWORK=" clashy-atzlinux fqterm thunderbird thunderbird-l10n-zh-cn"
OFFICE="codium draw.io wps-office wps-office-fonts xmind-vana"
PICS=""
VIDEO="handbrake handbrake-cli smplayer smplayer-l10n smplayer-themes vlc vlc-l10n"
TOOLS="doublecmd-gtk git keepassxc  p7zip rclone remmina remmina-plugin-rdp screen terminator vim "
SYSTEM=" cifs-utils ntfs-3g gnome gnome-panel gnome-tweak-tool  os-prober oxygen-icon-theme oxygen-sounds oxygencursors  powerline  xbindkeys xfsprogs zsh zsh-autosuggestions zsh-syntax-highlighting"
FONTS="fonts-adobe-source-han-cn fonts-dejavu  fonts-dejavu-extra fonts-noto-cjk  fonts-symbola  fonts-wqy-microhei  fonts-wqy-zenhei xfonts-wqy"

apt install  -y $NETWORK $OFFICE $PICS $SYSTEM $TOOLS $VIDEO  $FONTS
