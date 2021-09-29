create-User:
  user.present:
    - name: {{ pillar['config']['user'] }}
    - shell: /bin/zsh
    - home: /home/{{ pillar['config']['user'] }}
    - usergroud: True
    - createhome: True
  
install-sudo:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['sudo'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

update-sudo-cfg:
  file.managed:
    - name: /etc/sudoers.d/users
    - source: salt://linux/base/users
    - makedirs: true
    - user: root
    - require:
      - pkg: install-sudo
