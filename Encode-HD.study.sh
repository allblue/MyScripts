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
FSUF=("ra" "rm" "rmvb" "asf" "wmv" "dat" "mpeg""MPEG" "mpg" "MPG" "avi" "AVI" "divx" "vod" "mp4" "mov" "MOV" "mkv" "flv" "f4v" "m4v" "mts" "MTS")

for i in $(cat /tmp/lst)
   do
		echo "$i"
		for j in ${FSUF[@]}
		do
			if [[ "$i" =~ .+\."$j"$ ]]; then
				ffprobe -show_streams -i $i > /tmp/lst2
				str1=$(grep -i -m1 coded_width /tmp/lst2)
				str2=$(grep -i -m1 coded_height /tmp/lst2)
				str3=$(grep -i -m1 codec_name  /tmp/lst2)
				i_w=${str1#coded_width=}
				i_h=${str2#coded_height=}
				i_c=${str3#codec_name=}
				echo $i_w
				echo $i_h
				if [[ "$i" =~ .+"${i_w}p"\.mp4  ]];then
					echo "Nothing to do"
				elif [[ ! -f "${i%"$j"}${i_w}p.mp4" ]];then
					if [[ "${i_c}" == "h264" ]];then
						if [[ "$j" == "mov" || "$j" == "MOV" || "$j" == "mkv" || "$j" == "MKV" ]];then
                                                        ffmpeg -i "$i" -acodec copy -vcodec copy "${i%"$j"}${i_w}p.mp4"
						elif [[ "$j" == "mp4" || "$j" == "MP4" ]];then
							mv "$i" "${i%"$j"}${i_w}p.mp4"
						else
							ffmpeg -i "$i" -acodec aac  -vcodec copy "${i%"$j"}${i_w}p.mp4"
						fi
					else 
						HandBrakeCLI -v -i "$i" -o  "${i%"$j"}${i_w}p.mp4" --preset="Normal" -e x264 -E AAC --vfr 
					fi
				else 
					echo "Nothing to do"
				
				fi
			fi
		done
	done
						


		
		
	
