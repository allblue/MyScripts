#!/bin/python3
# -*- coding: utf-8 -*-  

import os
import datetime

REPOS = { 'centos7':'rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/',
          'archlinux':'rsync://mirrors.tuna.tsinghua.edu.cn/archlinux/',
          'archlinuxcn':'rsync://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/',
          'blackarch':'rsync://mirrors.tuna.tsinghua.edu.cn/blackarch/',
          'epel7':'rsync://mirrors.tuna.tsinghua.edu.cn/epel/7/',
          'manjaro':'rsync://mirrors.tuna.tsinghua.edu.cn/manjaro/',
         }
DST_DIR = "/volume3/Repo/"
EXCLUDE_FILE = "/volume4/SYS/scripts/rsync_exclue.txt"
LOG_FILE = "/volume4/SYS/scripts/repo_mirror.log"

start_time = datetime.datetime.now()
print("本次任务执行开始时间为" + start_time.strftime("%Y-%m-%d %H:%M:%S") + "\n" )

with open(LOG_FILE, 'a') as rsync_log:
    rsync_log.write("本次任务执行开始时间为" + start_time.strftime("%Y-%m-%d %H:%M:%S") + "\n")

for each_repo in REPOS:
    each_repo_dst_dir = DST_DIR + each_repo
    if not os.path.exists(each_repo_dst_dir):
        os.mkdir(each_repo_dst_dir)
                            
    rsync_cmd = "rsync -avh --progress --partial --delete-after --exclude-from " + EXCLUDE_FILE  + "  " + REPOS[each_repo] + "  " + each_repo_dst_dir
    print("正在同步" + each_repo + "镜像\n" )
    print("当前时间为" + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + "\n")

    with open(LOG_FILE, 'a') as rsync_log:
        rsync_log.write("正在同步" + each_repo + "镜像" + "\n" )
        rsync_log.write("当前时间为" + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + "\n" )


    os.system(rsync_cmd)

stop_time = datetime.datetime.now()
misson_time_cost = stop_time - start_time
mission_time_cost_days = misson_time_cost.days
mission_time_cost_hours = int(misson_time_cost.seconds/3600)
mission_time_cost_minutes = int(misson_time_cost.seconds%3600/60)
mission_time_cost_seconds = misson_time_cost.seconds%360 - mission_time_cost_minutes*60



print("本次任务执行结束时间为" + stop_time.strftime("%Y-%m-%d %H:%M:%S") )
print("本次任务共用时长为" + misson_time_cost.strftime("%Y-%m-%d %H:%M:%S"))
with open(LOG_FILE, 'a') as rsync_log:
    rsync_log.write("本次任务执行结束时间为" + stop_time.strftime("%Y-%m-%d %H:%M:%S") + "\n" )
    rsync_log.write("本次任务共用时长为 %d 天 %d 小时 %d 分钟 %f 秒 \n"  %(mission_time_cost_days, mission_time_cost_hours, mission_time_cost_minutes, mission_time_cost_seconds) )
