{% if grains['os'] == "Manjaro" or grains['os'] == "Arch" %} 
Update-repo-conf:
  file.append:
    - name: /etc/pacman.conf
    - text: | 
       [multilib]
       Include = /etc/pacman.d/mirrorlist
       [archlocal]
       SigLevel = Never
       Server = file:///media/backup/local
       [archlinuxcn]
       SigLevel = Never
       Server = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch
       [blackarch]
       SigLevel = Never
       Server = https://mirrors.bfsu.edu.cn/blackarch/blackarch/os/$arch  
    - require:
      - sls: linux.base.disk-mount
{% endif %}

Update-repo-cache:
  cmd.run:
    - name: {{ pillar['cmd']['update_repo_cache'] }}
    - user: root
    - require:
      - file: Update-repo-conf
