config-crontab-backup:
  cron.present:
    - name: rsync -avh --progress --partial /etc/ /media/backup/{{ grains['os'] }}/etc/
    - user: root
    - minute: 0 10 20 30 40 50 
    - require:
      - sls: linux.base.repo-update
      - sls: linux.base.disk-mount
