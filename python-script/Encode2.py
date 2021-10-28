# coding=utf-8

import os
import re
import json

DST_DIR="/media/nas/Download/BT"
#DST_DIR="/media/nas/DTA/"
INPUT_VIDEO_SUFFIX=[".ra",".rm",".rmvb",".asf",".wmv",".dat",".mpeg",".mpg",
                    ".avi",".divx",".vod",".mp4",".mov",".mkv",".flv",".m4v",".mts",".ts"]
OUT_VIDEO_SUFFIX=".mp4"
OUTPUT_WIDTH = 870
EXCLUDE_FILE = "/home/archblue/github/MyScripts/python-script/exclude_file"
DEL_FILE_LIST = []

def GetVideoList(DST_DIR, INPUT_VIDEO_SUFFIX):
    ALL_FILE_LIST = []
    VIDEO_LIST = []

    with open(EXCLUDE_FILE,'r') as f:
        FILTER_PATTERN = f.read().splitlines()

    # 目录递归检索，形成所有文件列表
    for root, dirs, files in os.walk(DST_DIR):
        for name in files:
            ALL_FILE_LIST.append(os.path.join(root, name))

    print(ALL_FILE_LIST)
    # 从所有文件列表中过滤视频文件
    for each_file in ALL_FILE_LIST:
        print(each_file)
        key = 0
        FILTER_VIDEO_PATTERN = "/@"
        if re.search(FILTER_VIDEO_PATTERN, each_file):
            #ALL_FILE_LIST.remove(each_file)
            print("自动跳过")
        else:
            for each_pattern in FILTER_PATTERN:
                if each_pattern and re.search(each_pattern, each_file):
                    #ALL_FILE_LIST.remove(each_file)
                    DEL_FILE_LIST.append(each_file)
                    key = 1
                    print(each_pattern)
                    print("垃圾文件")
                    break
            if key == 0:
                if os.path.splitext(each_file)[-1].lower() in INPUT_VIDEO_SUFFIX:
                    #ALL_FILE_LIST.remove(each_file)
                    VIDEO_LIST.append(each_file)
                    print("待转码文件")
                else:
                    #ALL_FILE_LIST.remove(each_file)
                    DEL_FILE_LIST.append(each_file)
                    print("非视频文件")
    #print(VIDEO_LIST)
    return(VIDEO_LIST)


def GetVideoInfo(VIDEO_FILE, VIDEO_INFO):
    ffprobe_cmd = "ffprobe -v quiet -show_streams -print_format json -show_format -i " + \
        '"' + VIDEO_FILE + '"'
    a = os.popen(ffprobe_cmd).read()
    codec_pram = json.loads(a)
    #codec_pra = ffmpeg.probe(VIDEO_FILE)

    # 检测文件是否损坏，如损坏则跳出本次循环
    try:
        #item = next(c for c in codec_pra['streams'] if c['codec_type'] == 'video')
        for item in codec_pram['streams']:
            if item['codec_type'] == "video":
                VIDEO_INFO['width'] = int(item['coded_width'])
                VIDEO_INFO['height'] = int(item['coded_height'])
                VIDEO_INFO['codec'] = item['codec_name']
                afr_tmp = item['avg_frame_rate'].split("/")
                VIDEO_INFO['afr'] = float(afr_tmp[0])/float(afr_tmp[1])
                return(1)
    except KeyError:
        print("The file has been currupt\n")
        return(0)

def CompareVideo(VIDEO_FILE, VIDEO_INFO, OUTPUT_WIDTH, OUT_SUFFIX):
    if OUT_SUFFIX == OUT_VIDEO_SUFFIX:
        GetVideoInfo(VIDEO_FILE, VIDEO_INFO)

    OUT_VIDEO_INFO = {}
    # 确定输出视频长、宽
    # 横版视频
    if VIDEO_INFO['width'] >= VIDEO_INFO['height']:
        if VIDEO_INFO['width'] <= OUTPUT_WIDTH:
            OUT_VIDEO_INFO['width'] = VIDEO_INFO['width']
            OUT_VIDEO_INFO['height'] = VIDEO_INFO['height']
            OUT_VIDEO_INFO['isless'] = 1
        else:
            OUT_VIDEO_INFO['width'] = OUTPUT_WIDTH
            OUT_VIDEO_INFO['height'] = int(OUT_VIDEO_INFO['width'] * VIDEO_INFO['height'] / VIDEO_INFO['width'])
            OUT_VIDEO_INFO['isless'] = 0
    # 竖板视频
    else:
        if VIDEO_INFO['height'] <= OUTPUT_WIDTH:
            OUT_VIDEO_INFO['height'] = VIDEO_INFO['height']
            OUT_VIDEO_INFO['width']  = VIDEO_INFO['width']
            OUT_VIDEO_INFO['isless'] = 1
        else:
            OUT_VIDEO_INFO['height'] = OUTPUT_WIDTH
            OUT_VIDEO_INFO['width'] = int(OUT_VIDEO_INFO['height'] * VIDEO_INFO['width'] / VIDEO_INFO['height'])
            OUT_VIDEO_INFO['isless'] = 0

    OUTPUT_VIDEO_PATTERN = "." + str(OUT_VIDEO_INFO['width']) + "p" + OUT_VIDEO_SUFFIX
    TEST_FILE_PATH = VIDEO_FILE.strip("."+VIDEO_FILE.split(".")[-1]) + "." + str(OUT_VIDEO_INFO['width']) + "p" + OUT_VIDEO_SUFFIX
    print(OUTPUT_VIDEO_PATTERN)

    if re.search(OUTPUT_VIDEO_PATTERN, VIDEO_FILE):
        print("The file had been encoded")
        print(VIDEO_FILE)
        print("")
        return(0)
    elif os.path.exists(TEST_FILE_PATH):
        print("The encoded file had been exist")
        #print(TEST_FILE_PATH)
        print(VIDEO_FILE)
        print("")
        return(0)
    else:
        return(OUT_VIDEO_INFO)


def TranscodeVideo(VIDEO_FILE, OUT_VIDEO_INFO, OUTPUT_WIDTH, OUT_VIDEO_SUFFIX):
    OUT_FILE_PATH = VIDEO_FILE.strip("."+VIDEO_FILE.split(".")[-1]) + "." + str(OUT_VIDEO_INFO['width']) + "p" + OUT_VIDEO_SUFFIX

    if VIDEO_INFO['codec'] == "h264" :
        if OUT_VIDEO_INFO['isless']:
            if VIDEO_FILE.split(".")[-1].lower() == OUT_VIDEO_SUFFIX:
                print("Rename Success")
                print(OUT_FILE_PATH)
                print("")
                os.rename(VIDEO_FILE,OUT_FILE_PATH)
            else:
                ffmpeg_cmd="ffmpeg -i " + '"' + VIDEO_FILE + '"' + " -vcodec copy -acodec aac  " + '"' + OUT_FILE_PATH + '"'
                print("CMD:",ffmpeg_cmd)
                print("")
                os.system(ffmpeg_cmd)
        else:
            handbrake_cmd="HandBrakeCLI -v -i " + '"' + VIDEO_FILE + '"' + " -w " + str(OUT_VIDEO_INFO['width']) + " -l " + str(OUT_VIDEO_INFO['height']) + " -o " + '"' + OUT_FILE_PATH + '"' + " --preset=\"Fast 720p30\" -e x264 -E AAC --vfr"
            print("CMD：", handbrake_cmd)
            print("")
            os.system(handbrake_cmd)
    else:
        handbrake_cmd="HandBrakeCLI -v -i " + '"' + VIDEO_FILE + '"' + " -w " + str(OUT_VIDEO_INFO['width']) + " -l " + str(OUT_VIDEO_INFO['height']) + " -o " + '"' + OUT_FILE_PATH + '"' + " --preset=\"Fast 720p30\" -e x264 -E AAC --vfr"
        print("CMD：",handbrake_cmd)
        print("")
        os.system(handbrake_cmd)

def CleanFiles():
    for each_file in DEL_FILE_LIST:
        os.remove(each_file)

if __name__ == '__main__':

    VIDEO_LIST=[]
    VIDEO_INFO={}
    OUT_VIDEO_INFO={}

    VIDEO_LIST=GetVideoList(DST_DIR, INPUT_VIDEO_SUFFIX)
    print(VIDEO_LIST)

    for each_video in VIDEO_LIST:
        OUT_VIDEO_INFO=CompareVideo(each_video, VIDEO_INFO, OUTPUT_WIDTH, OUT_VIDEO_SUFFIX)
        if OUT_VIDEO_INFO:
           TranscodeVideo(each_video, OUT_VIDEO_INFO, OUTPUT_WIDTH, OUT_VIDEO_SUFFIX)
