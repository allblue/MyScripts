{% for each_disk in pillar['config']['disk'] %}
media-{{ each_disk }}-create:
  file.directory:
    - name: /media/{{ each_disk }}
    - makedirs: True
{% endfor %}

Install-filesystem-tools:
  pkg.installed:
    - pkgs:
      - ntfs-3g
      - fuse3
      - xfsprogs
      - cifs-utils
      - lvm2

Update-fstab:
  file.append:
    - name: /etc/fstab
    - text:
      - /dev/sdc3	/media/c	ntfs-3g		defaults	0 0 
      - /dev/sdc4	/media/d	ntfs-3g		defaults	0 0 
      - /dev/sdb1	/media/e	ntfs-3g		defaults	0 0 
      - /dev/sdb2	/media/f	ntfs-3g		defaults	0 0 
      - /dev/sdb3	/media/g	ntfs-3g		defaults	0 0 
      - /dev/sdb4	/media/h	ntfs-3g		defaults	0 0 
      - /dev/mapper/ng-backup	/media/backup	xfs		defaults	0 0 
      - //192.168.123.222/movie /media/nas      cifs    defaults,_netdev,username=age,password=YdL7j3b4JPKQT4Z2qWYVC5AgAVaCj2uuipfExsQMugmugVuv8E9sS4WtbWbV,uid=1000 0 0
    - require:
      - pkg: Install-filesystem-tools

Mount-Disk:
   cmd.run:
    - name: mount -a
    - user: root
    - require:
      - file: Update-fstab
  
