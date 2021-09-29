;;;;;;;; 一、打开常用软件、文件、文件夹和网页

;;;; 1、程序

;萤石Studio
:://ez::
IfWinExist  EzvizStudio.exe
	WinActivate
else
	Run D:\Program Files\Ezviz Studio\EzvizStudio.exe
return

;Cterm
:://cterm::
IfWinExist  CTerm.exe
	WinActivate
else
  Run D:\Program Files\CTerm\CTerm.exe
return

;snipast
:://snip::
IfWinExist  Snipaste.exe
	WinActivate
else
  Run D:\Program Files\Snipaste\Snipaste.exe
return

;PotPlayer
:://pot::
IfWinExist  PotPlayerMini.exe
	WinActivate
else
  Run D:\Program Files\PotPlayer\PotPlayerMini.exe
return


;;;; 2、文件和文件夹



;;;; 3、网页

;豆瓣
:://dou::
Run https://douban.com
return

;豆瓣fm
:://dfm::
Run https://fm.douban.com
return

;知乎
:://zhi::
Run https://zhihu.com
return



;;;;;;;; 四、小工具

;计时器
#c:: 
InputBox UserInput, Counter, Enter a number(minutes):
IfEqual, Errorlevel, 0
{    
    sleep UserInput * 60000
    SoundBeep
    MsgBox 时间到！
}
return

;定时关机
:://sd::
InputBox UserInput, Counter, 输入计划关机的时间（分钟）:
Run cmd
WinWaitActive ahk_class ConsoleWindowClass
time := UserInput * 60
send ^{Space} ;设置英文输入
Send shutdown{Space} -s{Space}-t{Space}%time%{Enter}
return

;取消定时关机
:://stop::
Run cmd
WinWaitActive ahk_class ConsoleWindowClass
send ^{Space} ;设置英文输入
Send shutdown{Space} -a{Space}{Enter}
return

;立刻关机
:://sdn:: 
Shutdown, 1
return

;游戏模式
;禁用Windows键，保持大写锁定
#v::
Run D:\Documents\game.ahk
;game.ahk的内容如下，退出游戏时关闭这个脚本
;LWin::return
;SetCapsLockState, AlwaysOn

;;;;;;;; 99、系统初始化

:://install::
; 设置变量
MyD := "D:\Program Files\"
MySoft := "G:\soft\软件安装包\"


; 设置个人文件夹
RunWait "%MyD%\PCMaster\pcmaster.exe"

; 恢复windows应用商店
Run powershell  -Command "add-appxpackage 'G:\soft\软件安装包\windows商店恢复\*.appx'"
Run powershell  -Command "add-appxpackage 'G:\soft\软件安装包\windows商店恢复\*.appxbundle'"

; 软件安装
RunWait "%MySoft%\BANDIZIP-SETUP.EXE" /S
RunWait "%MySoft%\DeskGo_2_9_20251_127_lite.exe"
RunWait "%MySoft%\ClassicShellSetup_4_3_0-zhCN.exe" /qn
RunWait "%MySoft%\DirectX9.0c End User Runtimes 64bit .exe"  /sp- /verysilent /suppressmsgboxes /norestart
RunWait "%MySoft%\JLWBIme_4.1.0.15.exe" /autoinstall
RunWait "%MySoft%\seadrive-1.0.3.exe" /quiet /passive /norestart
RunWait "%MySoft%\sysdiag-all-5.0.12.8.exe" /S
RunWait "%MySoft%\Office Tab Enterprise 13.10\SetupOfficeTabEnterpriseMSI.msi" /qn
RunWait "%MySoft%\VMware-viclient-all-6.0.0-2502222\bin\VMware-viclient.exe" /S /v/qn
RunWait "%MySoft%\MacTypeInstaller_2017_0628_0.exe" /qn
RunWait "%MySoft%\MSVBCRT AIO 2017.10.25 X86 X64.exe"  /sp- /verysilent /suppressmsgboxes /norestart
RunWait "%MySoft%\NutstoreWindowsInstaller.exe" /qn
RunWait "%MySoft%\Git-2.23.0-64-bit.exe"  /sp- /verysilent /suppressmsgboxes /norestart


RunWait "%MySoft%\BizConfVideoWin7.exe"
RunWait "%MySoft%\FaciShareSetup.win.1.7.1.exe"
RunWait "%MySoft%\HYsp5101.exe"
RunWait "%MySoft%\OneCloudSetup_1.4.5.112.exe"
RunWait "%MySoft%\SunloginClient10.1.exe"
; 挂载office iso镜像到H, 然后安装
RunWait "%MySoft%\OTP_Office_16.0.11727.20244_x86_zh-cn.iso"
RunWait "H:\Office Tool Plus.exe"

; 安装字体
FileCopy, "%MySoft%\字体\思源黑\*.otf", C:\Windows\Fonts\
FileCopy, "%MySoft%\字体\思源宋\*.otf", C:\Windows\Fonts\
FileCopy, "%MySoft%\字体\方正兰亭GBK\FZFONT\*.ttf", C:\Windows\Fonts\


; 绿色软件初始化
; 后台自动配置, 无需人工界入
Run "%MyD%\ALMRun\ALMRun.exe", , Min
Run "%MyD%\everything\Everything.exe", , Min
Run "%MyD%\Adobe Photoshop CC\QuickInstall.exe" /i
Run "%MyD%\XMind\XMind.Setup.bat", C:\
Run "%MyD%\ThunderX\Install_ThunderX.bat", C:\
Run "%MyD%\WPS Office Pro.10.8.0.5715\绿化和卸载.bat", C:\
Run regedit /s "%MyD%\RDM free\Plugins\puttyconf.reg"

; 前台弹出配置, 人工配置
RunWait "%MyD%\Axure RP v9.0.0 Build 3658 TE\绿化&卸载.exe"
RunWait "%MyD%\CleanMe\CleanMem_Settings.exe"
RunWait "%MyD%\DirectX Repair V3.3 (Enhanced Edition)\DirectX_Repair_win8_win10.exe"
RunWait "%MyD%\WPS Office Pro.10.8.0.5715\office6\ksomisc.exe"
RunWait "%MyD%\Dism++\Dism++x64.exe"


; 软件安装后配置
RunWait "%MyD%\PotPlayer\PotPlayerMini.exe"

RunWait "%MyD%\AAct v2.1 Portable\AAct3.9.1.x64.exe"

return