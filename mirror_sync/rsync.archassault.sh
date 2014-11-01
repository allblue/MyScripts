set -x
#SRC="rsync://mirror.umd.edu/archassault/"
SRC="rsync://mirror.catn.com/pub/archassault/"
#SRC="rsync://ftp.heanet.ie/pub/archassault/"
#SRC="rsync://noodle.portalus.net/ArchAssault/"
#SRC="rsync://mirror.jmu.edu/archassault/"
EXCLUDE_FILE="/media/repo/exclude.txt"
DST="/media/repo/ArchAssault/"
#rsync -avh --progress --partial --delete-after rsync://ftp.halifax.rwth-aachen.de/manjaro/ /media/repo/manjaro/
rsync -avh --progress --partial --delete-after --exclude-from=$EXCLUDE_FILE $SRC $DST
