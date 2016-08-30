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
FSUF=("ra" "rm" "rmvb" "asf" "wmv" "dat" "mpeg""MPEG" "mpg" "MPG" "avi" "AVI" "divx" "vod" "mp4" "mov" "MOV" "mkv" "flv" "m4v" "mts" "MTS")
#if [ $1 =='' ]; then
#  echo Usage: Encode.sh <dir>
#  exit 1
#fi
o_w=800
o_avg=25

for i in $(cat /tmp/lst)
   do
		echo "$i"
		for j in ${FSUF[@]}
		do
			if [[ "$i" =~ .+\."$j"$ ]]; then
				ffprobe -show_streams -i $i > /tmp/lst2
				str1=$(grep -i -m1 coded_width /tmp/lst2)
				str2=$(grep -i -m1 coded_height /tmp/lst2)
				str3=$(grep -i -m1 avg_frame_rate /tmp/lst2)
				i_w=${str1#coded_width=}
				i_h=${str2#coded_height=}
				i_afr=${str3#avg_frame_rate=}
				i_fps=$(echo "$i_afr" | bc)
				echo $i_w
				echo $i_h
				echo $i_afr
				echo $i_fps
				if [[ $i_fps -gt $o_avg || $i_fps -eq 0 ]];then
					o_fps=$o_avg
				else
					o_fps=$i_fps
				fi
				
				if [[ $i_w -le $o_w ]];then
					if [[ "$j" == "mp4" && "$(echo "$i" | grep -i "$i_w" )" != ""  ]];then
						echo "$i"已跳过
					elif [[ "$j" == "mp4" && "$(echo "$i" | grep -i "$i_w" )" == "" ]];then
						mv "$i" "${i%"$j"}${i_w}p.mp4"
					elif [[ "$j" != "mp4" && ! -f "${i%"$j"}${i_w}p.mp4" ]];then
						HandBrakeCLI -v -i "$i" -o  "${i%"$j"}${i_w}p.mp4" --preset="Normal" -e x264 -E AAC --vfr -r $o_fps
					else
						echo "$i"无匹配
					fi
				else
					if [[ ! -f "${i%"$j"}${o_w}p.mp4" ]];then
						o_h=$(echo "scale=2; $i_h/$i_w*$o_w" | bc)
						echo "${i%"$j"}${o_w}p.mp4"
						HandBrakeCLI -v -i "$i" -o  "${i%"$j"}${o_w}p.mp4" --preset="Normal" -e x264 -w $o_w -l $o_h -E AAC --vfr -r $o_fps
					fi
				fi
			fi
		done
	done
						


		
		
	
