#!/bin/bash

#手动挂载CIFS共享
mount -a

#手动加载Virtulbox网络、PCI等驱动
#modprobe vboxnetflt
#modprobe vboxpci
#modprobe vboxnetadp
#modprobe vboxdrv

#启动goagent
#python2 "/media/d/Program Files/goagent-goagent-3.2.0/local/proxy.py"
