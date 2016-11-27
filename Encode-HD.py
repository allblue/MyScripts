#!/usr/bin/python
#coding=utf-8 

import os
import re
import json

DST_DIR="/media/video/DTA"
#DST_DIR="/media/video/e/DownLoad/TDDOWNLOAD"
#DST_DIR="/media/video/e/DownLoad/BT"
OUT_VIDEO_SUFFIX=".mp4"
#OUT_VIDEO_RES="800"
o_width_max="800"
TMP_FILES_LST=[]
TMP_ENCODED_LIST=[]
INPUT_VIDEO_PATTERN=[]
OUTPUT_VIDEO_PATTERN=[]
INPUT_VIDEO_SUFFIX=[".ra",".rm",".rmvb",".asf",".wmv",".dat",".mpeg",".MPEG",".mpg",".MPG",".avi",".AVI",".divx",".vod",".mp4",".MP4",".mov",".MOV",".mkv",".flv",".m4v",".mts",".MTS"]

#for i in INPUT_VIDEO_SUFFIX:
#    INPUT_VIDEO_PATTERN.append="."+i

#for i in OUTPUT_VIDEO_SUFFIX:
#    OUTPUT_VIDEO_PATTERN.append=strcat("\.",OUT_VIDEO_RES,"p.",i,"$")
#OUTPUT_VIDEO_PATTERN="\."+OUT_VIDEO_RES+"p\."+OUT_VIDEO_SUFFIX+"$"
OUTPUT_VIDEO_PATTERN="\."+"[0-9]+"+"p"+OUT_VIDEO_SUFFIX+"$"
print(OUTPUT_VIDEO_PATTERN)

for root,dirs,files in os.walk(DST_DIR):
    for name in files:
#        print(os.path.join(root,name))
        TMP_FILES_LST.append(os.path.join(root,name))
#print(TMP_FILES_LST)

for v in TMP_FILES_LST:
    j=os.path.splitext(v) 
#    print(j)
    if re.search(OUTPUT_VIDEO_PATTERN,v):
        print("The file had been encoded")
        print(v)
        print("")
    else:
        if j[-1] in INPUT_VIDEO_SUFFIX:
            ffprobe_cmd="ffprobe -v quiet -show_streams -print_format json -show_format -i "+'"'+v+'"'
            print(ffprobe_cmd)
            a=os.popen(ffprobe_cmd).read()
            codec_pram=json.loads(a)
            for i in codec_pram['streams']:
#                print(i)
                if i['codec_type'] == "video":
                    i_width=int(i['coded_width'])
                    i_height=int(i['coded_height'])
                    i_codec=i['codec_name']
                    i_afr_tmp=i['avg_frame_rate'].split("/")
                    i_afr=float(i_afr_tmp[0])/float(i_afr_tmp[1])
                    print(i_width)
                    print(i_height)

            if i_width < int(o_width_max):
                o_width  = i_width
                o_height = i_height
            else:
                o_width  = int(o_width_max)
                o_height = (i_height/i_width)*int(o_width)

            TEST_FILE_PATH=j[0]+"."+str(o_width)+"p"+OUT_VIDEO_SUFFIX
            if  os.path.exists(TEST_FILE_PATH):
                print("文件已转换")
                print(v)
                break
            else:
                print("文件即将转换")
                print(v)
#                TMP_ENCODED_LIST.append(i)
                if o_width < int(o_width_max):
                    if i_codec == "h264" and j[-1] == OUT_VIDEO_SUFFIX:
                        print("rename")
                        os.rename(v,TEST_FILE_PATH)
                    elif i_codec == "h264":
                        ffmpeg_cmd="ffmpeg –i "+'"'+v+'"'+" –vcodec copy -acodec aac –an –f "+OUT_VIDEO_SUFFIX+" "+'"'+TEST_FILE_PATH+'"'
                        print(ffmpeg_cmd)
                        os.system(ffmpeg_cmd)
                    else:
                        handbrake_cmd="HandBrakeCLI -v -i "+'"'+v+'"'+" -o "+'"'+TEST_FILE_PATH+'"'+" --preset=\"Normal\" -e x264 -E AAC --vfr"
                        print(handbrake_cmd)
                        os.system(handbrake_cmd)
                else:
                    handbrake_cmd="HandBrakeCLI -v -i "+'"'+v+'"'+" -w "+str(o_width)+" -l "+str(o_height)+" -o "+'"'+TEST_FILE_PATH+'"'+" --preset=\"Normal\" -e x264 -E AAC --vfr"
                    print(handbrake_cmd)
                    os.system(handbrake_cmd)
                print("")

