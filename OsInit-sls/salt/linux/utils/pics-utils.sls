instll-pics-utils:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['pics-utils'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

