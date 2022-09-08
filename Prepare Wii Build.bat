rmdir .\WiiBuild\ /s /q

@echo Copying to Wii Build Folder
Xcopy /E /I .\Build .\WiiBuild

@echo Deleting Netplay Only Files
del .\WiiBuild\KingBird\NETPLAY.txt /Q
del .\WiiBuild\KingBird\NETBOOST.txt /Q
del .\WiiBuild\KingBird\pf\menu3\dnet.cmnu /Q
rmdir .\WiiBuild\KingBird\pf\movie /s /q
rmdir .\WiiBuild\KingBird\pf\sound\netplaylist /s /q
rmdir .\WiiBuild\KingBird\Source\Netplay /s /q

powershell.exe .\RenameFilesForWiiBuild.ps1

@echo Building Codesets
".\WiiBuild\KingBird\GCTRealMate.exe" -q ".\WiiBuild\KingBird\RSBE01.txt"
".\WiiBuild\KingBird\GCTRealMate.exe" -q ".\WiiBuild\KingBird\BOOST.txt"

::@echo Zipping Files Please Wait
::powershell.exe .\ZipWiiFiles.ps1

@echo Finished!