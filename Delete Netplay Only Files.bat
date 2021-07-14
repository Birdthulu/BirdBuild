del .\KingBird\NETPLAY.txt /Q
del .\KingBird\NETBOOST.txt /Q
del .\KingBird\pf\menu3\dnet.cmnu /Q
rmdir .\KingBird\pf\movie /s /q
rmdir .\KingBird\pf\sound\netplaylist /s /q
rmdir .\KingBird\Source\Netplay /s /q
powershell.exe .\RenameFilesForWiiBuild.ps1