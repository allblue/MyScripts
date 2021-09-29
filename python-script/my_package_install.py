#!/bin/python3
# -*- coding: utf-8 -*-  

import os
import datetime
import re
import sys
import crypt

#PACMAN_CONF = "/etc/pacman.conf"
PACMAN_CONF = "E:\我的坚果云\private\\30.gitee\MyScripts\pacman.conf"
ARCH_MIRROR = {
                'archlinuxcn':"/media/nas/volume3/Repo/archlinux",
                'blackarch':"/media/nas/volume3/Repo/blackarch",
                'local':"/media/backup/archlocal",
              }
SOFT_LIST = {
              'SOFT_NETWORK':"aria2 filezilla fqterm-git chromium shadowsocks-qt5 teamviewer thunderbird thunderbird-i18n-zh-cn",
              'SOFT_PICS':"deepin-screenshot gimp gimp-help-zh_cn imagemagick mcomix ",
              'SOFT_OFFICE':"calibre geany geany-plugins goldendict libreoffice-fresh libreoffice-fresh-zh-cn texmaker wiznote wps-office ",
              'SOFT_AUDIO':"alsa-plugins alsa-utils deepin-music gst-plugins-base gst-plugins-base-libs gstreamer gstreamer0.10 gstreamer0.10-base lib32-alsa-lib lib32-alsa-plugins lib32-libpulse pamixer pavucontrol pavumeter pulseaudio pulseaudio-alsa",
              'SOFT_AUDIO':"alsa-plugins alsa-utils deepin-music  lib32-alsa-lib lib32-alsa-plugins lib32-libpulse pamixer pavucontrol pavumeter pulseaudio pulseaudio-alsa",
              'SOFT_VIDEO':"deepin-movie freshplayerplugin handbrake handbrake-cli mplayer pepper-flash smplayer smplayer-themes vlc",
              'SOFT_SYSTEM':"bash-completion bc cmake docker doublecmd-gtk2 cifs-utils exfat-utils fcitx fcitx-configtool fcitx-gtk2 fcitx-gtk3 fcitx-qt4 fcitx-qt5 git iptables jre8-openjdk jre8-openjdk-headless libunrar linux-headers lxdm mate mate-extra net-tools ntfs-3g  openssh os-prober  oxygen-icons p7zip python-chardet python2-pyopenssl rsync samba screen smbclient ttf-dejavu unrar unzip virtualbox virtualbox-guest-iso wicd wicd-gtk wine winetricks wqy-zenhei wqy-microhei wqy-bitmapfont yaourt",
              'SOFT_HACK':"metasploit",
              'SOFT_GAME':"assaultcube fceux openra supertux",
              'SOFT_LOCAL':"aliedit deepin-wine-thunderspeed dynamips gns3-converter gns3-server gns3-gui  jre8 menda-themes menda-themes-dark miredo proxyee-down pycharm-professional ttf-wps-fonts wine-qqintl xnviewmp",
            }

SERVICES_LIST = [ "fcitx", "docker", "wicd"]

def User_Config():
    username = "age"
    home_dir = "/home/" + username
    user.passwd = crypt.crypt("dragon","ab")
    os.system("useradd -o -u 0 -g 0 %s" %username)
    os.system("usermod -p %s %s" %(passwd, username))
    os.system("usermod -d %s %s" %(home_dir, username))
    os.system("chown -Rv %s:%s %s" %(username, username, home_dir))

    with open("/etc/sudoers", 'a') as sudoers:
        sudoers.write(username +" ALL=(ALL) NOPASSWD: ALL \n")

def AddSource():
    for item in ARCH_MIRROR:
        key = 0
        with open(PACMAN_CONF, 'r') as pacman_conf:
            all_text = pacman_conf.readlines()
            title = "[" + item + "]"
            title_pattern = "\[" + item + "\]"
            for each_line in all_text:
                if re.search(title_pattern, each_line):
                    key = 1
                    break
            if key == 0:    
                with open(PACMAN_CONF, 'a') as pacman_conf:
                   item_content = title + "\n" + "Server = " + ARCH_MIRROR[item] + "\n" + "SigLevel = Nerver \n\n"
                   pacman_conf.write(item_content)

def Install_Software():
    all_soft = ""
    
    for item in SOFT_LIST:
        all_soft = all_soft + SOFT_LIST[item] + " "

    cmd = "pacman -S -y " + all_soft
    print(cmd)
    #os.system(cmd)
  
def Grub_Mkconfig():
    grub_mkcong_cmd = "/bin/grub-mkconfig -o /boot/grub/grub.cfg"
    print(grub_mkcong_cmd)
    #os.system(grub_mkcong_cmd)

def Services_Config():
    for item in SERVICES_LIST:
        enable_cmd = "/bin/systemctl enable " + item
        start_cmd = "/bin/systemctl start " + item
        print(enable_cmd)
        print(start_cmd)
        #os.system(enable_cmd)
        #os.system(start_cmd)

if __name__ == '__main__':
    #User_Config()
    AddSource()
    Install_Software()
    Grub_Mkconfig()
    Services_Config()


