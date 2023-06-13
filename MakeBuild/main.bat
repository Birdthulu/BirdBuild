:: ============================================================================
:: Virtual SD card main script
:: ============================================================================
@echo off
cls

cd /d %~dp0

::set MIN_EXEC_TIME=3

powershell.exe .\ConfigureNetplay.ps1

call settings.bat

IF EXIST "%SD_CARD_PATH%" goto :Continue
IF NOT EXIST "%SD_CARD_PATH%" goto :MakeSD

:MakeSD
echo  Creating a virtual SD card. . .
"mksdcard.exe" %SD_CARD_SIZE% "sd.raw"
move "sd.raw" "%SD_CARD_PATH%"
echo.
echo  Created.

:Continue
set PURGE_COMMAND=
if %PURGE%==1 (
    set PURGE_COMMAND=/PURGE
)

call mount.bat || goto error

ROBOCOPY "%BUILD_DIR:\=\\%KingBird" "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird." ^
    /E ^
    /NS ^
    /NP ^
    /NJH ^
    %PURGE_COMMAND%
IF %ERRORLEVEL% GEQ 8 goto error

echo ########################################################################################################################
echo RSBE01.GCT
echo ########################################################################################################################
"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\RSBE01.txt"

echo:
echo ########################################################################################################################
echo BOOST.GCT
echo ########################################################################################################################
"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\BOOST.txt"

echo:
echo ########################################################################################################################
echo NETPLAY.GCT
echo ########################################################################################################################
"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\NETPLAY.txt"

echo:
echo ########################################################################################################################
echo TOURNAMENT.GCT
echo ########################################################################################################################
"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\TOURNAMENT.txt"

echo:
echo ########################################################################################################################
echo NETBOOST.GCT
echo ########################################################################################################################
"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\NETBOOST.txt"

fsutil file createnew "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\DON'T PUT THIS BUILD ON A WII.txt" 0

::timeout /t %MIN_EXEC_TIME% /nobreak > NUL

call unmount.bat || goto error

powershell.exe .\CleanNetplayFiles.ps1

cd ../
powershell.exe .\PrepareWiiBuild.bat

goto :eof

:error
color 0c
pause > NUL 2> NUL
color
goto :eof