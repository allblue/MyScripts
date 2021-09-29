install-python3:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['python3'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

update-pip-config:
  file.managed:
    - name: /home/{{pillar['config']['user']}}/.pip/pip.conf
    - source: salt://linux/utils/python3-pip.conf
    - user: {{ pillar['config']['user'] }}
    - mode: 644
    - makedirs: True
    - require:
      - pkg: install-python3
      - sls: linux.base.user
