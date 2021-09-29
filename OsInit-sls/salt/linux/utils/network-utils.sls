instll-network-utils:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['network-utils'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update
