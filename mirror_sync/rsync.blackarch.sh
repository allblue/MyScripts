set -x
#BlackArch同步脚本
#从华中科技大学镜像站同步
#SRC="rsync://mirror.umd.edu/archassault/"
#SRC="rsync://blackarch@blackarch.org/blackarch/blackarch/"
SRC="rsync://mirrors.hustunique.com/blackarch/blackarch/"
EXCLUDE_FILE="/media/repo/exclude.txt"
DST="/media/repo/BlackArch/"
#DST="/media/cd1/ArchAssault/"
#rsync -avh --progress --partial --delete-after rsync://ftp.halifax.rwth-aachen.de/manjaro/ /media/repo/manjaro/
rsync -avh --progress --partial --delete-after --exclude-from=$EXCLUDE_FILE $SRC $DST
