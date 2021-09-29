instll-video-utils:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['video-utils'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

