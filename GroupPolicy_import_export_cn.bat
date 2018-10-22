@echo off

::设置颜色
color DE

echo 检查管理员身份...
net session >nul 2>&1
if %errorLevel% == 0 (
        goto continue
) else (
        echo,
        echo 请以管理员身份运行该脚本！
        echo 按任意键退出...
        pause > nul
        exit
)

:continue

::设置延迟变量
SetLocal EnableDelayedExpansion

::获取系统版本
for /f "tokens=1* delims=[" %%a in ('ver') do (
    set b=%%b
)

::将版本信息赋值给变量b
set b=%b:* =%

::设置系统版本号命名的文件夹
for /f "tokens=1,3 delims=*." %%a in ("%b%") do (
    set ver1=!ver1!_%%a
    set ver3=!ver3!_%%b
)

for /f "tokens=2 delims=*." %%a in ("%b%") do (
    set ver2=!ver2!_%%a
)

set version=!ver1!!ver2!!ver3!

:: 变量
set db_name=%set
set gp_name="%UserProfile%\Desktop\gp_config%version%\%db_name%.inf"
set gp_folder="%UserProfile%\Desktop\gp_config%version%\"
set gp_file="%Windir%\System32\GroupPolicy"
set gp_export_file="%UserProfile%\Desktop\GroupPolicy"
set logs="%WinDir%\security\logs\scesetup.log"

echo,
echo   ∧____∧
echo   (·ω·)つ━ ☆..*¨
echo  ∈     ノ
echo * * * 欢迎进入组策略管理工具 copyright by Molly Lau * * *
echo * しーーＪ                                              *     
echo *                                                       *
echo *   使用须知：                                          *
echo *                                                       *
echo *   · 只支持导入由本脚本预先导出的组策略文件           *
echo *   · 组策略配置文件和系统内部版本号严格对应           *
echo *   · 不支持导入与当前版本系统不同的组策略配置文件     *
echo *   · 导入注册表配置文件过程不可逆，望三思谨慎操作     *
echo *   · 本工具支持以下功能：                             *
echo *                                                       *
echo *                    1. 导出组策略                      *
echo *                                                       *
echo *                    2. 导入组策略                      *
echo *                                                       *
echo *                      回车键退出                       *
echo *                                                       *
echo *                                                       *
echo * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
echo,
set /p ask1=请选择你需要的操作(1/2/回车键)：
if "%ask1%"=="1" (
    goto export_gp
) else (
    if "%ask1%"=="2" (
        goto import_gp
    ) else (
          exit
    )
)

::导出组策略
:export_gp
if exist %gp_folder% (
    rd /s /Q %gp_folder%
)
mkdir %gp_folder%
echo,
echo 正在导出第一部分的安全设置...
secedit /export /cfg %gp_name%
echo,
echo 正在导出所有安全组规则配置...
xcopy /e /h /r /y %gp_file% %gp_export_file%\
echo,
echo 正在归档文件...
attrib -h %gp_export_file%
move %gp_export_file% %gp_folder%
echo,
echo 组策略设置已导出到%gp_folder%文件夹！
echo,
echo 正在清理日志...
if exist logs del %logs%
echo,
set /p ask2=是否需要打开查看（y 查看/n 退出）？
if /i "%ask2%"=="n" exit
if /i "%ask2%"=="y" explorer %gp_folder%
exit

::导入组策略
:import_gp
echo,
if exist %gp_folder% (
    if exist %gp_name% (
        if exist %gp_folder%GroupPolicy (
            echo 正在导入第一部分的安全设置...
            secedit /configure /db %db_name%.sdb /CFG %gp_name%
            echo,
            echo 正在导入所有安全组规则配置...
            xcopy /e /h /r /y %gp_folder%GroupPolicy %gp_file%
            echo,
            echo 刷新组策略...
            gpupdate /force
            echo 组策略设置已导出成功！
            echo,
            echo 正在清理临时文件和日志...
            del %db_name%.jfm
            del %db_name%.sdb
            if exist logs del %logs%
            echo,
            echo 按回车键退出...           
            pause > nul
            exit     
        ) else (
              echo “GroupPolicy”文件夹不存在！
              pause 
        )
    ) else (
          echo “%db_name%.inf”文件不存在！
          pause    
    )
) else (
    echo 记录组策略规则的文件夹不存在或不适用于您的系统！
    pause
)