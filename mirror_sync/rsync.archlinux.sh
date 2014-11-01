set -x
#SRC="rsync://ftp.jaist.ac.jp/pub/Linux/ArchLinux/"
SRC="rsync://mirrors.kernel.org/archlinux/"

#rsync -avh --progress --partial --delete-after rsync://ftp.halifax.rwth-aachen.de/manjaro/ /media/repo/manjaro/
rsync -avh --progress --partial --delete-after --exclude-from=/media/repo/exclude.txt $SRC /media/repo/ArchLinux/
