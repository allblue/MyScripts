instll-tool-utils:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['tool-utils'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

{% for each_pkg in pillar['config']['autostart-tools'] %}
set-autostart-{{each_pkg}}:
  file.managed:
    - name: /home/{{ pillar['config']['user'] }}/.config/autostart/{{each_pkg}}.desktop
    - source: salt://linux/utils/tool-utils-{{each_pkg}}.desktop
    - makedirs: True
    - user: {{ pillar['config']['user'] }}
    - group: {{ pillar['config']['user'] }}
    - require:
      - pkg: instll-tool-utils
      - sls: linux.base.user
{% endfor %}
