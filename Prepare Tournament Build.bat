@echo Deleting Netplay Only Files
del .\Build\KingBird\NETPLAY.txt /Q
del .\Build\KingBird\NETBOOST.txt /Q
del .\Build\KingBird\pf\menu3\dnet.cmnu /Q
rmdir .\Build\KingBird\pf\movie /s /q
rmdir .\Build\KingBird\pf\sound\netplaylist /s /q
rmdir .\Build\KingBird\Source\Netplay /s /q
powershell.exe .\EditFilesForTournamentBuild.ps1
@echo Building Codesets
".\Build\KingBird\GCTRealMate.exe" -q ".\Build\KingBird\RSBE01.txt"
".\Build\KingBird\GCTRealMate.exe" -q ".\Build\KingBird\BOOST.txt"
@echo Zipping Files Please Wait
powershell.exe .\ZipWiiFiles.ps1
@echo Finished!