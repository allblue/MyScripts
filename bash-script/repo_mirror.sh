#!/bin/bash

# set -x

# 定义常量
DST_DIR="/volume3/Repo"
EXCLUDE_FILE="/volume4/SYS/scripts/rsync_exclue.txt"
declare -A REPOS
REPOS=( [centos7]="rsync://mirrors4.tuna.tsinghua.edu.cn/centos/7/"
                  [archlinux]="rsync://mirrors4.tuna.tsinghua.edu.cn/archlinux/"
          [archlinuxcn]="rsync://mirrors4.tuna.tsinghua.edu.cn/archlinuxcn/"
          [blackarch]="rsync://mirrors4.tuna.tsinghua.edu.cn/blackarch/"
          [epel7]="rsync://mirrors4.tuna.tsinghua.edu.cn/epel/7/"
          [manjaro]="rsync://mirrors4.tuna.tsinghua.edu.cn/manjaro/"
        )


# 打印任务开始水平分隔线，共3条
for ((i=0;i<80;i++)); do echo -n =; done
echo ""
for ((i=0;i<80;i++)); do echo -n =; done
echo ""
for ((i=0;i<80;i++)); do echo -n =; done
echo ""

# 打印任务开始时间
echo "本次同步任务开始时间: $(date)"

# 记录任务开始时间
timer_start=$(date +%s)

# 遍历镜像字典，逐个同步
for each_repo in $(echo ${!REPOS[*]})
do
        # 打印每个镜像同步任务开始水平分隔线，共2条
        for ((i=0;i<40;i++)); do echo -n \*; done
        echo ""
        for ((i=0;i<40;i++)); do echo -n \*; done
        echo ""
        
        # 打印同步镜像名称和同步任务开始时间
        echo "开始同步镜像: ${each_repo}"
        echo "当前时间为 $(date)"

        # 核心命令，同步镜像
        rsync -avh --progress --partial --delete-before --exclude-from "$EXCLUDE_FILE" ${REPOS[$each_repo]} ${DST_DIR}/${each_repo}

        # 打印每个镜像同步任务结束水平分隔线，共2条
        for ((i=0;i<40;i++)); do echo -n \*; done
        echo ""
        for ((i=0;i<40;i++)); do echo -n \*; done
        echo ""
done

# 打印任务结束时间
echo "本次同步任务结束时间: $(date)"

# 计算任务耗时
# 获取任务开始、结束秒数差，然后再依次计算出小时、分钟、秒
timer_end=$(date +%s)
cost_all=$(($timer_end - $timer_start))
cost_hours=$(($cost_all/3600))
cost_minutes=$(($cost_all%3600/60))
cost_seconds=$(($cost_all%3600%60))

echo "本次同步任务共耗时： $cost_hours 小时 $cost_minutes 分钟 $cost_seconds 秒"

# 打印任务结束水平分隔线，共3条
for ((i=0;i<80;i++)); do echo -n =; done
echo ""
for ((i=0;i<80;i++)); do echo -n =; done
echo ""
for ((i=0;i<80;i++)); do echo -n =; done
echo ""
