#!/usr/bin/python
#coding=utf-8

#16.12.04 增加异常判断，对未转换完整文件，检测失败后自动跳过

#检测视频文件分辨率、文件格式，将统一转换为统一编码格式集中存储
#具体策略为：
#1. 视频分辨率宽度或高度（取最大值）上限800px，可自定义。
#2. 视频编码选用H264,视频文件容器选用MP4
#3. 文件命名为<原文件名>.<分辨率上限>p.mp4
#处理流程为：
#对指定目标遍历，筛选出视频文件
#通过ffprobe命令获取视频文件分辨率、编码方式
#将视频文件分辨率与限定上限相比较，取最小值作为输出分辨率
#以下二种情况自动跳过
#检测当前文件命名是否符合命名规范，即本文件即为转换后文件
#检测当前目前是否已有符合命名规范的文件，即已生成过转换文件
#其它情况，进一步检测输入分辨率大小
#小于设定上限时，
#    源文件已采用h264编码，且为mp4格式，按命名规范重命名即可。
#    源文件已采用h264编码，非mp4格式，通过ffmpeg命令抽取视频码流重新封装，无需转码
#    其它，通过handbrake命令转码
#大于设定上限
#    通过handbrake命令转码


import os
import re
import json

DST_DIR="/media/video/DTA"
#DST_DIR="/media/video/DTA/Hegre"
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

for root,dirs,files in os.walk(DST_DIR):
    for name in files:
#        print(os.path.join(root,name))
        TMP_FILES_LST.append(os.path.join(root,name))
#print(TMP_FILES_LST)

for v in TMP_FILES_LST:
    j=os.path.splitext(v) 
    print(j)
    key1=0
    key2=0
    if j[-1] in INPUT_VIDEO_SUFFIX:
        ffprobe_cmd="ffprobe -v quiet -show_streams -print_format json -show_format -i "+'"'+v+'"'
        print(ffprobe_cmd)
        a=os.popen(ffprobe_cmd).read()
        codec_pram=json.loads(a)
        # 检测文件是否损坏，如损坏则跳出本次循环
        try :
            xx=codec_pram['streams']
        except KeyError:
            print("The file has been currupt\n")
            continue

        for i in codec_pram['streams']:
#            print(i)
             if i['codec_type'] == "video":
                 i_width=int(i['coded_width'])
                 i_height=int(i['coded_height'])
                 i_codec=i['codec_name']
                 i_afr_tmp=i['avg_frame_rate'].split("/")
                 i_afr=float(i_afr_tmp[0])/float(i_afr_tmp[1])
                 print(i_width)
                 print(i_height)


        if i_width >= i_height:
             if i_width <= int(o_width_max):
                 o_width  = i_width
                 o_height = i_height
             else:
                 key2=1
                 o_width  = int(o_width_max)
                 o_height = (i_height/i_width)*int(o_width)
        else:
             key1=1
             if i_height <= int(o_width_max):
                 o_width  = i_width
                 o_height = i_height
             else:
                 key2=1
                 o_height  = int(o_width_max)
                 o_width = (i_width/i_height)*int(o_height)

        print(key1)
        print(key2)

        OUTPUT_VIDEO_PATTERN = "\." + str(o_width) + "p" + OUT_VIDEO_SUFFIX + "$"
        print(OUTPUT_VIDEO_PATTERN)
        if re.search(OUTPUT_VIDEO_PATTERN, v):
            print("The file had been encoded")
            print(v)
            print("")
        else:
            TEST_FILE_PATH = j[0] + "." + str(o_width) + "p" + OUT_VIDEO_SUFFIX
            print(TEST_FILE_PATH)
            if os.path.exists(TEST_FILE_PATH):
                print("The file had been encoded\n")
    #           break
            else:
                 print("The file will be encoded")
                 print(v)
        #            TMP_ENCODED_LIST.append(i)
                 if key2==0 :
                     #已采用h264编码，且为mp4格式，重命名
                     if i_codec == "h264" and j[-1] == OUT_VIDEO_SUFFIX:
                         print("Rename Success")
                         os.rename(v,TEST_FILE_PATH)
                    #已采用h264编码，非mp4格式，用ffmpeg直接复制视频码流，无需重新编码
                     elif i_codec == "h264":
                         ffmpeg_cmd="ffmpeg -i "+'"'+v+'"'+" -vcodec copy -acodec aac  "+'"'+TEST_FILE_PATH+'"'
                         print("CMD:",ffmpeg_cmd)
                         os.system(ffmpeg_cmd)
                    #非h264编码，统一转码
                     else:
                         handbrake_cmd="HandBrakeCLI -v -i "+'"'+v+'"'+" -o "+'"'+TEST_FILE_PATH+'"'+" --preset=\"Normal\" -e x264 -E AAC --vfr"
                         print("CMD：",handbrake_cmd)
                         os.system(handbrake_cmd)
                 else:
                     handbrake_cmd="HandBrakeCLI -v -i "+'"'+v+'"'+" -w "+str(o_width)+" -l "+str(o_height)+" -o "+'"'+TEST_FILE_PATH+'"'+" --preset=\"Normal\" -e x264 -E AAC --vfr"
                     print("CMD：",handbrake_cmd)
                     os.system(handbrake_cmd)
                 print("")

