rmdir .\TournamentBuild\ /s /q

@echo Copying to Tournament Build Folder
Xcopy /E /I .\Build .\TournamentBuild

@echo Deleting Netplay Only Files
del .\TournamentBuild\KingBird\NETPLAY.txt /Q
del .\TournamentBuild\KingBird\NETBOOST.txt /Q
del .\TournamentBuild\KingBird\TOURNAMENT.txt /Q
del .\TournamentBuild\KingBird\pf\menu3\dnet.cmnu /Q
rmdir .\TournamentBuild\KingBird\pf\movie /s /q
rmdir .\TournamentBuild\KingBird\pf\sound\netplaylist /s /q
rmdir .\TournamentBuild\KingBird\Source\Netplay /s /q

powershell.exe .\EditFilesForTournamentBuild.ps1

@echo Building Codesets
".\TournamentBuild\KingBird\GCTRealMate.exe" -q ".\TournamentBuild\KingBird\RSBE01.txt"
".\TournamentBuild\KingBird\GCTRealMate.exe" -q ".\TournamentBuild\KingBird\BOOST.txt"

::@echo Zipping Files Please Wait
::powershell.exe .\ZipWiiFiles.ps1

@echo Finished!