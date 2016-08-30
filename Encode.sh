#!/bin/bash
# 2015.05.31
# 通过handbrake实现目录内视频自动递归转码
# 支持格式：“ra" "rm" "rmvb" "asf" "wmv" "dat" "mpeg" "mpg" "avi"  "divx" "vod"

set -x

IFS=$(echo -en "\n\b")
cd $1
DIR=`pwd`
echo "$DIR"
LST=`du -a ${DIR} | sed 's/^[0-9][0-9\.]*//g' | sed 's/^[ \t][ \t]*//g' > /tmp/lst`
#LST=`du -h -a ${DIR} | sed 's/^[0-9][0-9\.]*[MGK]//g' | sed 's/^[ \t][ \t]*//g' > /tmp/lst`
#IFS='\n\n'
FSUF=("ra" "rm" "rmvb" "asf" "wmv" "dat" "mpeg" "mpg" "avi"  "divx" "vod" "flv")
#if [ $1 =='' ]; then
#  echo Usage: Encode.sh <dir>
#  exit 1
#fi

for i in $(cat /tmp/lst)
   do
      echo "$i"
      for j in ${FSUF[@]}
	do
             if [[ "$i" =~ .+\."$j" ]]; then
		if [[ ! -f "${i%"$j"}mp4" ]]; then
	            HandBrakeCLI -v -i "$i" -o  "${i%"$j"}mp4" --preset="Normal" -e x264 -E AAC --vfr
		fi
             fi
	done
  done
						


		
		
	
