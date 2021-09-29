install-gnome:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['gnome'] %}
      - {{ each_pkg}}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

service-gdm:
  service.running:
    - name: gdm
    - enable: true
    - reload: true
    - require:
      - pkg: install-gnome

set-graphical:
  cmd.run:
    - name: systemctl set-default graphical
    - user: root
    - require:
      - service: service-gdm


