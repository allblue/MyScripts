install-fcitx:
  pkg.installed:
    - pkgs:
{% for each_pkg in pillar['pkg']['fcitx5'] %}
      - {{ each_pkg }}
{% endfor %}
    - require:
      - sls: linux.base.repo-update
      
update-fcitx-cfg:
  file.append:
    - name: /home/{{ pillar['config']['user'] }}/.pam_environment
    - text:
      - GTK_IM_MODULE DEFAULT={{ pillar['config']['fcitx5'] }}
      - QT_IM_MODULE  DEFAULT={{ pillar['config']['fcitx5'] }}
      - XMODIFIERS    DEFAULT=\@im={{ pillar['config']['fcitx5'] }}
      - SDL_IM_MODULE DEFAULT={{ pillar['config']['fcitx5'] }}
    - require:
      - sls: linux.base.user
      - pkg: install-fcitx

set-autostart-fcitx:
  file.managed:
    - name: /home/{{ pillar['config']['user'] }}/.config/autostart/{ pillar['config']['fcitx5'] }}.desktop
    - source: salt://linux/utils/{{ pillar['config']['fcitx5'] }}.desktop
    - user: {{ pillar['config']['user'] }}
    - group: {{ pillar['config']['user'] }}
    - require:
      - file: update-fcitx-cfg
      - sls: linux.base.user
