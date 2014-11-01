#rsync -avh --progress --partial --delete-after rsync://ftp.halifax.rwth-aachen.de/manjaro/ /media/repo/manjaro/
rsync -avh --progress --partial --delete-after --exclude-from=/media/repo/exclude.txt rsync://mirror.jmu.edu/manjaro/ /media/repo/manjaro/
