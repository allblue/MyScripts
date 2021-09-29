instll-audio-utils:
  pkg.installed:
    - pkgs:
{% for each_pkg in pillar['pkg']['audio-utils'] %}
      - {{ each_pkg }}
{% endfor %}
    - require:
      - sls: linux.base.repo-update

