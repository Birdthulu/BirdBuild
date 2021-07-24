del .\Build\KingBird\NETPLAY.txt /Q
del .\Build\KingBird\NETBOOST.txt /Q
del .\Build\KingBird\pf\menu3\dnet.cmnu /Q
rmdir .\Build\KingBird\pf\movie /s /q
rmdir .\Build\KingBird\pf\sound\netplaylist /s /q
rmdir .\Build\KingBird\Source\Netplay /s /q
powershell.exe .\RenameFilesForWiiBuild.ps1
call "MakeSD\nonsecureSendKeys.bat" "progfortr" "{Enter}"
".\Build\KingBird\GCTRealMate.exe" ".\Build\KingBird\RSBE01.txt"
call "MakeSD\nonsecureSendKeys.bat" "progfortr" "{Enter}"
".\Build\KingBird\GCTRealMate.exe" ".\Build\KingBird\BOOST.txt"
call "MakeSD\nonsecureSendKeys.bat" "progfortr" "{Enter}"