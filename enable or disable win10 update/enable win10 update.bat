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

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /ve 2>nul | findstr "WindowsUpdate"  > nul

if %errorLevel% == 0 (
	reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f
	echo The update of your system has been enabled.
	echo Please restart your system!
) else (
	echo The update of your system has been enabled!	
)

echo Press any key to exit
pause > nul
exit