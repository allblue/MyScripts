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
O_FM="mp4"
O_VC1="h264"
O_VC2="x264"
O_AC1="aac"
O_AC2="AAC"

for i in $(cat /tmp/lst)
   do
		echo "$i"
		for j in ${FSUF[@]}
		do
			if [[ "$i" =~ .+\."$j"$ ]]; then
				ffprobe -show_streams -i $i > /tmp/lst2
				str1=$(grep -i -m1 coded_width /tmp/lst2)
				str2=$(grep -i -m1 coded_height /tmp/lst2)
				str3=$(grep -i -m1 codec_name=${O_VC1} /tmp/lst2)
				str4=$(grep -i -m1 codec_name=${O_AC1}  /tmp/lst2)
				i_w=${str1#coded_width=}
				i_h=${str2#coded_height=}
				i_vc=${str3#codec_name=}
				i_ac=${str4#codec_name=}
				echo $i_w
				echo $i_h
				if [[ "$i" =~ .+"${i_w}p"\."${O_FM}" ]];then
					echo "Nothing to do"
				elif [[ ! -f "${i%"$j"}${i_w}p."${O_FM}"" ]];then
					if [[ "${i_vc}" == "${O_VC1}" ]];then
						if [[ "$j" == "${O_FM}" ]];then
							mv "$i" "${i%"$j"}${i_w}p.${O_FM}"
						elif [[ "${i_ac}" == "${O_AC1}" ]];then
                                                	ffmpeg -i "$i" -acodec copy -vcodec copy "${i%"$j"}${i_w}p.${O_FM}"
						else
							ffmpeg -i "$i" -acodec "${O_AC1}"  -vcodec copy "${i%"$j"}${i_w}p.${O_FM}"
						fi
					else 
						HandBrakeCLI -v -i "$i" -o  "${i%"$j"}${i_w}p.${O_FM}" --preset="Normal" -e "${O_VC2}" -E "${O_AC2}" --vfr 
					fi
				else 
					echo "Nothing to do"
				
				fi
			fi
		done
	done
						


		
		
	
