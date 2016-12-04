#!/bin/bash

set -x

SOFT_NETWORK="aria2 filezilla fqterm-git google-chrome palemoon-bin palemoon-i18n-default thunderbird thunderbird-i18n-zh-cn"
SOFT_PICS="deepin-screenshot gimp gimp-help-zh_cn imagemagick mcomix "
SOFT_OFFICE="calibre geany geany-plugins goldendict kindlegen libreoffice-fresh libreoffice-fresh-zh-CN wiznote wps-office zotero"
SOFT_AUDIO="alsa-plugins alsa-utils deepin-music gst-plugins-base gst-plugins-base-libs gstreamer gstreamer0.10 gstreamer0.10-base  lib32-alsa-lib lib32-alsa-plugins lib32-libpulse pamixer pasystray pavucontrol pavumeter pulseaudio pulseaudio-alsa"
SOFT_VIDEO="deepin-movie handbrake handbrake-cli mplayer smplayer smplayer-themes vlc "
SOFT_SYSTEM="bash-completion bc cmake docker doublecmd-qt cifs-utils exfat-utils fcitx fcitx-configtool fcitx-gtk2 fcitx-gtk3 fcitx-qt4 fcitx-qt5 git iptables jre8-openjdk jre8-openjdk-headless libunrar linux-headers lxdm mate mate-extra net-tools ntfs-3g  openssh os-prober  oxygen-icons p7zip python-chardet python2-pyopenssl rsync samba smbclient ttf-dejavu unrar unzip virtualbox virtualbox-guest-iso virtualbox-host-modules wicd wicd-gtk wine winetricks wqy-zenhei wqy-microhei wqy-bitmapfont yaourt"
SOFT_HACK="metasploit"
SOFT_GAME="assaultcube fceux openra supertux"
SOFT_LOCAL="aliedit dynamips genymotion gns3-converter gns3-server gns3-gui  menda-themes menda-themes-dark teamviewer10 ttf-wps-fonts 
wine-qqintl xnviewmp"

pacman -S $SOFT_NETWORK $SOFT_PICS $SOFT_OFFICE $SOFT_VIDEO $SOFT_AUDIO $SOFT_SYSTEM $SOFT_HACK $SOFT_GAME $SOFT_LOCAL
