#!/bin/bash
NETWORK="firefox firefox-i18n-zh-cn thunderbird thunderbird-i18n-zh-cn  pidgin axel "
VIDEO="smplayer vlc flashplugin gstreamer0.10-bad-plugins gstreamer0.10-ffmpeg gstreamer0.10-base-plugins gstreamer0.10-good-plugins 
gstreamer0.10-ugly-plugins imagemagick banshee mcomix "
OFFICE="goldendict wiznote  gvim  libreoffice-still-zh-CN "
TOOL="git rsync wine wine_gecko doublecmd-gtk2 mlocate oxygen-icons virtualbox virtualbox-guest-utils virtualbox-guest-iso ipython wireshark-gtk  "
SYSTEM="ntfs-3g wqy-zenhei wqy-microhei wqy-bitmapfont cmake libpng12 fcitx fcitx-configtool os-prober bash-completion  "
LOCAL="wps-office gns3 qterm  metasploit zotero aliedit "
pacman -S -y $NETWORK $VIDEO $OFFICE $TOOL $SYSTEM
