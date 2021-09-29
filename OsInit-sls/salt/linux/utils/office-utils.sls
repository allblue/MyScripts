instll-office-utils:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['office-utils'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

set-autostart-rclone:
  file.managed:
    - name: /home/{{ pillar['config']['user'] }}/.config/autostart/rclone.desktop
    - source: salt://linux/utils/office-utils-rclone.desktop
    - user: {{ pillar['config']['user'] }}
    - group: {{ pillar['config']['user'] }}
    - require:
      - pkg: instll-office-utils
      - sls: linux.base.user
