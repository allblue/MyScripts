install-gnome:
  pkg.installed:
    - pkgs:
    {% for each-pkg in pillar['pkg']['mate'] %}
      - {{ each-pkg}}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

install-lxdm:
  pkg.installed:
    - pkgs:
      - lxdm
    - require:
      - sls: linux.base.repo-update

service-lxdm:
  service.running:
    - name: lxdm
    - enable: True
    - reload: True
    - user: root
    - require:
      - pkg: install-lxdm

set-graphical:
  cmd.run:
    - name: systemctl set-default graphical
    - user: root
    - require:
      - pkg: install-gnome
      - service: service-lxdm


