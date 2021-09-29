instll-system-utils:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['system-utils'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

