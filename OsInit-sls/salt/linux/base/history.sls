histor-timeformat:
  file.append:
    - name: /etc/profile
    - text:
      - export HISTTIMEFORMAT="%F %T `whoami`"