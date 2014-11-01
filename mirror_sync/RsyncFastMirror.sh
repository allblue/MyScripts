#!/bin/bash
#2010.03.05 archlinux同步脚本, 实现基本功能
#2010.05.11 增加自动检测镜像源速度功能, 自动选择最快镜像源同步
#		    基本原理, 分别从各个源同步一个小文件, 然后检测其速度大小, 取最快的那个源.
#		    考虑到源数目过多时, 逐一检测非常耗时, 因而设了一个自选优化值:
#		   	RATE_EXPECT	速度期望值, 若最快速度大于此值, 则不再进行后续检测, 直接使用此镜像源
#		    	若不想启用该条件, 可将之设为0
#		    RATE_MINIMUM	速度下限, 若同步速度低于此值则排除该镜像.以保证有效的最快速度总是大于此值.
#		    MIRROR_FILE为镜像源列表, 支持#注释符
#		    TEST_FILE为待同步的小文件, 本例中选取/extra/os/i686/extra.abs.tar.gz, 因为它的大小只有2M, 即使低速率下载也不会消耗太多时间. 
#2010.05.12 更新速度检测算法, 不再只考虑最后一行, 而改用全局平均速度,以便获得更精确值.
#		    Rsync的结果不能用管道全部传送, 只好调用中间日志文件做重定向
set -x

MIRROR_FILE="/media/repo/mirror.list"
TEST_FILE="/extra/os/i686/extra.abs.tar.gz"
RATE_MINIMUM=100
RATE_EXPECT=150
FASTMIRROR=""
RATE_FAST="0"

DST="/media/repo/ArchLinux"
EXCLUDE_FILE="/media/cd1/exclude.txt"

if [ ! -d $DST ]; then
        mkdir -p $DST
fi

if [ -f /tmp/$(basename $TEST_FILE) ]; then
	  rm /tmp/$(basename $TEST_FILE)
fi

killall rsync

#排除以#开头的内容, 使MIRROR_FILE支持注释功能
for i in $(cat $MIRROR_FILE | sed 's/\#.*$//g' )
do
#获得同步的速度, 注意bash不支持实数型数值比较,因而用awk将之截断,只取整数部分.
#	RATE=$(rsync -avh --progress --timeout=10 $i/$TEST_FILE /tmp/ | sed  -n '/xfer/p' |  sed  -r 's/.*[ ]+(.*)kB\/s.*/\1/g' | awk 'BEGIN{FS="."}{print $1}') 
	rsync -avh --progress --timeout=10 $i/$TEST_FILE /tmp/ > /tmp/log
	RATE=$( cat -A /tmp/log  | sed -n '/kB\/s/p' | sed  's/\^M/\n/g' | sed -r 's/.*[ ]+([0-9.]+)kB\/s.*/\1/g' | awk 'BEGIN{sum=0} {sum=sum+$1} END{if (NR!=0) print sum/NR; else print 0}' | awk 'BEGIN{FS="."}{print $1}' ) 
	rm /tmp/$(basename $TEST_FILE)
#若RATE_MINIMUM开启, 且速度低于RATE_MINIMUM, 则跳到本次循环, 排除该镜像源
	if [ "$RATE_MINIMUM" -gt "0" ] && [ "$RATE" -lt "$RATE_MINIMUM"  ]; then
		continue
	fi
	
#若RATE_EXPECT开启, 且速度大于RATE_EXPECT, 则直接选择该镜像源, 结束循环
	if [ "$RATE_EXPECT" -gt "0" ] && [ "$RATE" -gt "$RATE_EXPECT" ]; then
		FASTMIRROR="$i"
		break
	fi
	
#	若当前速度大于RATE_FAST, 则将值赋与RATE_FAST, 并将当前源设为FASTMIRROR
	if [ "$RATE_FAST" -ge "0" ] && [ "$RATE" -gt "$RATE_FAST" ]; then
		RATE_FAST="$RATE"
		FASTMIRROR="$i"
	fi
	
	#因为需要重复下载该文件, 必须将之删除,否则下次将跳过,不再同步
#	rm /tmp/$(basename $TEST_FILE)
done

#echo "$FASTMIRROR"

#如果FASTMIRROR非空, 则开始同步
if [ -n "$FASTMIRROR" ]; then
		rsync -avh --progress --delete-after --partial --exclude-from=$EXCLUDE_FILE $FASTMIRROR/  $DST/
fi
