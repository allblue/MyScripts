install-docker:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['docker'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

update-docker-config:
  file.managed:
    - name: /etc/docker/daemon.json
    - source: salt://linux/utils/docker-daemon.json
    - user: root
    - group: root
    - makedirs: true
    - require:
      - pkg: install-docker

enable-docker-service:
  service.running:
    - name: docker
    - enable: True
    - reload: True
    - watch:
      - file: update-docker-config
