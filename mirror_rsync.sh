#!/bin/bash
set -x

SRC="/media/cd1"
DST="/media/repo"
REPO=("ArchLinux"  "antergos" "BlackArch" "centos" "freshrpms" "epel")
for i in ${REPO[@]};do
	if [ ! -d ${DST}/${i} ];	then
		mkdir -p ${DST}/${i}
	fi
	rsync -avh --progress --delete-after --partial ${SRC}/${i}/ ${DST}/${i}/
done

