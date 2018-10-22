@echo off

color DE

echo Check whether run as Administrator...
net session >nul 2>&1
if %errorLevel% == 0 (
    goto continue
) else (
    echo,
    echo Please run as Administrator!
    echo Press any key to exit...
    pause > nul
    exit
)

:continue

SetLocal EnableDelayedExpansion

for /f "tokens=1* delims=[" %%a in ('ver') do (
    set b=%%b
)

set b=%b:* =%

for /f "tokens=1,3 delims=*." %%a in ("%b%") do (
    set ver1=!ver1!_%%a
    set ver3=!ver3!_%%b
)

for /f "tokens=2 delims=*." %%a in ("%b%") do (
    set ver2=!ver2!_%%a
)

set version=!ver1!!ver2!!ver3!

set db_name=%set
set gp_name="%UserProfile%\Desktop\gp_config%version%\%db_name%.inf"
set gp_folder="%UserProfile%\Desktop\gp_config%version%\"
set gp_file="%Windir%\System32\GroupPolicy"
set gp_export_file="%UserProfile%\Desktop\GroupPolicy"
set logs="%WinDir%\security\logs\scesetup.log"

echo,
echo   ¡Ä____¡Ä
echo   (¡¤¦Ø¡¤)¤Ä©¥ ¡î..*¡§
echo  ¡Ê     ¥Î
echo * * * Welcome to GroupPolicy management by MollyLau * * *
echo * ¤·©`©`£Ê                                              *     
echo *                                                       *
echo *                                                       *
echo *                1. Export GroupPolicy                  *
echo *                                                       *
echo *                2. Import GroupPolicy                  *
echo *                                                       *
echo *                Press any key to exit                  *
echo *                                                       *
echo *                                                       *
echo * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
echo,
set /p ask1=Choose an operation(1/2/any key)£º
if "%ask1%"=="1" (
    goto export_gp
) else (
    if "%ask1%"=="2" (
        goto import_gp
    ) else (
          exit
    )
)

:export_gp
if exist %gp_folder% (
    rd /s /Q %gp_folder%
)
mkdir %gp_folder%
echo,
echo Exporting security settings about first part...
secedit /export /cfg %gp_name%
echo,
echo Exporting all configurations about group policies...
xcopy /e /h /r /y %gp_file% %gp_export_file%\
echo,
echo Archiving files...
attrib -h %gp_export_file%
move %gp_export_file% %gp_folder%
echo,
echo Group policies has been exported to %gp_folder% successfully!
echo,
echo Cleaning up...
if exist logs del %logs%
echo,
set /p ask2=Need to browse back-uped files(y browse/n exit)?
if /i "%ask2%"=="n" exit
if /i "%ask2%"=="y" explorer %gp_folder%
exit

:import_gp
echo,
if exist %gp_folder% (
    if exist %gp_name% (
        if exist %gp_folder%GroupPolicy (
            echo Importing security settings about first part...
            secedit /configure /db %db_name%.sdb /CFG %gp_name%
            echo,
            echo Importing all configurations about group policies...
            xcopy /e /h /r /y %gp_folder%GroupPolicy %gp_file%
            echo,
            echo Refresh group policy services...
            gpupdate /force
            echo Group policies has been imported successfully!
            echo,
            echo Cleaning up...
            del %db_name%.jfm
            del %db_name%.sdb
            if exist logs del %logs%
            echo,
            echo Press any key to exit...           
            pause > nul
            exit     
        ) else (
              echo  The folder ¡°GroupPolicy¡± doesn't exist!
              pause 
        )
    ) else (
          echo The file ¡°%db_name%.inf¡± doesn't exist!
          pause    
    )
) else (
    echo The folder ¡°gp_config%version%¡± doesn't exist or your back-uped grouppolicy file doesn't support current version of Windows! 
    pause
)