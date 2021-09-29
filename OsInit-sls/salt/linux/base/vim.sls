instll-vim:
  pkg.installed:
    - pkgs:
    {% for each_pkg in pillar['pkg']['vim'] %}
      - {{ each_pkg }}
    {% endfor %}
    - require:
      - sls: linux.base.repo-update

update-vim-config:
  file.append:
    - name: /etc/vimrc
    - text:
      - :set nu
      - :set mouse=
      - syntax on
    - require:
      - pkg: instll-vim