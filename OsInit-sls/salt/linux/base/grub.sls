install-grub:
  pkg.installed:
    - pkgs:
      - grub
      - os-prober
      - efibootmgr
    - require:
      - sls: linux.base.repo-update
    
update-grub-default-StartOrder:
  file.replace:
    - name: /etc/default/grub
    - pattern: ".*GRUB_DEFAULT.*"
    - repl: "GRUB_DEFAULT=2"
    - show_changes: True
    - append_if_not_found: True
    - require:
      - pkg: install-grub

update-grub-default-EnableOsprober:
  file.append:
    - name: /etc/default/grub
    - text:
      - GRUB_DISABLE_OS_PROBER=false
    - require:
      - pkg: install-grub     

update-clover:
  file.append:
    - name: /etc/grub.d/40_custom
    - text:
      - menuentry "Clover Mac OS X Bootloader" {
      - insmod part_gpt
      - insmod fat
      - insmod search_fs_uuid
      - insmod chain
      - search --fs-uuid --no-floppy --set=root '{{ pillar['config']['clover-efi'] }}'
      - chainloader /EFI/boot/BOOTX64.efi }
    - require:
      - pkg: install-grub

create-grub-cfg:
  file.touch:
    - name: /boot/grub/grub.cfg
    - makedirs: True
    - require:
      - pkg: install-grub

update-grub-cfg:
  cmd.run:
    - name: grub-mkconfig -o /boot/grub/grub.cfg
    - user: root
    - require:
      - file: create-grub-cfg
      - file: update-grub-default-StartOrder
      - file: update-grub-default-EnableOsprober
      - file: update-clover
      - sls:  linux.base.disk-mount
