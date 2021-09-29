cmd:
{% if grains['os'] == "Manjaro" or grains['os'] == "Arch" %}
  update_repo_cache: pacman -Syy

{% elif grains['os'] == "Debain" %}
  update-repo-cache: apt update

{% endif %}

