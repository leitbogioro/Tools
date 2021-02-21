@echo off

::set color
color DE

echo Checking administrator authority...
net session >nul 2>&1
if %errorLevel% == 0 (
	goto continue
) else (
	echo,
	echo Please run me as an administrator!
	echo Press any key to exit...
	pause > nul
	exit
)

:continue

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f

echo You will not receive all driver updates from Microsoft any more!
echo Press any key to exit
pause > nul
exit