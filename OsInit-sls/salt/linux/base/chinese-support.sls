us_locale:
  locale.present:
    - name: en_US.UTF-8

zh_locale:
  locale.present:
    - name: zh_CN.UTF-8

Install-chinese-fonts:
  pkg.installed:
      - pkgs: 
{% for each_font in pillar['pkg']['chinese-fonts'] %}
        - {{ each_font }}
{% endfor %}
      - require:
        - sls: linux.base.repo-update
