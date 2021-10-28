pkg:
{% if grains['os'] == "Manjaro" or grains['os'] == "Arch" %}
  chinese-fonts:
    - adobe-source-code-pro-fonts
    - adobe-source-serif-fonts 
    - adobe-source-sans-fonts
    - noto-fonts-cjk
    - noto-fonts-emoji
    - ttf-dejavu
    - ttf-wps-fonts
    - wqy-microhei
    - wqy-zenhei
    - wqy-bitmapfont
  fcitx5:
    - fcitx5
    - fcitx5-chinese-addons
    - fcitx5-configtool
    - fcitx5-gtk
    - fcitx5-qt
  docker:
    - docker
  sudo: 
    - sudo    
  mate:
    - mate
    - mate-extra
    - oxygen-icons 
  gnome:
    - gnome-shell
    - gnome-shell-extensions
  python3:
    - python
    - python-pip
  vim:
    - vim
  zsh:
    - zsh
    - zsh-autosuggestions
    - zsh-completions
    - zsh-history-substring-search
    - zsh-syntax-highlighting
  network-utils:
    - brave-bin
    - clashy-bin
    - firefox
    - firefox-i18n-zh-cn 
    - fqterm-git
    - qv2ray
    - sunloginclient
    - thunderbird
    - thunderbird-i18n-zh-cn
    - v2ray
    - youtube-dl-gui-git
  tool-utils:
    - crossover
    - doublecmd-qt5
    - fsearch-git
    - keepassxc
    - p7zip
    - terminator
    - utools
    - ventoy-bin
    - xbindkeys
  pics-utils:
    - flameshot
    - gimp
    - gimp-help-zh_cn
    - imagemagick
  audio-utils:
    - alsa-plugins
    - alsa-utils
    - gst-plugins-base
    - gst-plugins-base-libs
    - gstreamer
    - gstreamer0.10
    - gstreamer0.10-base
    - lib32-alsa-lib
    - lib32-alsa-plugins
    - lib32-libpulse
    - lx-music-desktop-bin
    - pulseaudio
    - pulseaudio-alsa
  video-utils:
    - handbrake
    - handbrake-cli
    - smplayer
    - smplayer-skins
    - smplayer-themes
    - vlc
    - zy-player-appimage
  office-utils:
    - calibre
    - code
    - dingtalk-linux
    - drawio-desktop-bin
    - goldendict-qt5-git
    - libreoffice-fresh
    - libreoffice-fresh-zh-cn
    - obsidian
    - rclone
    - wps-office-cn
    - wps-office-mime-cn
    - wps-office-mui-zh-cn    
  system-utils:
    - alsa-utils
    - bc
    - chrome-gnome-shell
    - cmake
    - cronie
    - digimend-kernel-drivers-dkms-git 
    - git 
    - libunrar
    - linux-headers 
    - net-tools 
    - nvidia-settings
    - nvidia-utils 
    - openssh 
    - oxygen-icons
    - oxygen-sounds  
    - p7zip 
    - powerline
    - rsync
    - samba
    - screen 
    - smbclient
    - unrar
    - unzip
    - virtualbox
    - virtualbox-guest-iso 
    - yay
{% elif grains['os'] == "Debain" %}


{% endif %}
