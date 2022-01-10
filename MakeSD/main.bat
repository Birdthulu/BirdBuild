:: ============================================================================
:: Virtual SD card main script
:: ============================================================================
@echo off
cls

cd /d %~dp0

::set MIN_EXEC_TIME=3

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

"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\RSBE01.txt"
"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\BOOST.txt"
"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\NETPLAY.txt"
"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\TOURNAMENT.txt"
"%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\GCTRealMate.exe" -q "%SD_CARD_MOUNT_DRIVE_LETTER:\=\\%:\\KingBird\NETBOOST.txt"

::timeout /t %MIN_EXEC_TIME% /nobreak > NUL

call unmount.bat || goto error

goto :eof

:error
color 0c
pause > NUL 2> NUL
color
goto :eof