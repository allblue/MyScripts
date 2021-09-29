install-zsh:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['zsh'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update
