#Numbers of lines will probably need to change when edits to RSBE01.txt or BOOST.txt are made.

copy "../Build/KingBird/RSBE01.txt" "../Build/KingBird/NETPLAY.txt" -Force -erroraction 'silentlycontinue'
copy "../Build/KingBird/RSBE01.txt" "../Build/KingBird/TOURNAMENT.txt" -Force -erroraction 'silentlycontinue'
copy "../Build/KingBird/BOOST.txt" "../Build/KingBird/NETBOOST.txt" -Force -erroraction 'silentlycontinue'
#New-Item -ItemType Directory -Force -Path "../Build/KingBird/Source/Netplay/"
copy "../Build/KingBird/Source/Project+/StageFiles.asm" "../Build/KingBird/Source/Netplay/Net-StageFiles.asm" -Force -erroraction 'silentlycontinue'
copy "../Build/KingBird/Source/Project+/MyMusic.asm" "../Build/KingBird/Source/Netplay/Net-MyMusic.asm" -Force -erroraction 'silentlycontinue'
#copy "../NetplayFiles/Netplay" "../Build/KingBird/Source/" -Force -Recurse -erroraction 'silentlycontinue'
#copy "../NetplayFiles/dnet.cmnu" "../Build/KingBird/pf/menu3/" -Force -erroraction 'silentlycontinue'
del "../Build/KingBird/pf/sound/netplaylist" -Confirm:$false -Recurse -erroraction 'silentlycontinue'
Copy-Item "../Build/KingBird/pf/sound/tracklist" -Destination "../Build/KingBird/pf/sound/netplaylist" -Force -Recurse -erroraction 'silentlycontinue'

#TOURNAMENT.txt
$tournamentPath = "..\Build\KingBird\TOURNAMENT.txt"
(Get-Content $tournamentPath).replace('RSBE01.txt', 'TOURNAMENT.txt') | Set-Content $tournamentPath
(Get-Content $tournamentPath).replace('0417F368 08010100', '0417F368 08010101') | Set-Content $tournamentPath
(Get-Content $tournamentPath).replace('0417BE74 15200017', '0417BE74 04801109') | Set-Content $tournamentPath
(Get-Content $tournamentPath).replace('Source/KingBird/CodeMenu.asm', 'Source/Netplay/Tourney-Net-CodeMenu.asm') | Set-Content $tournamentPath
(Get-Content $tournamentPath).replace('.include Source/Extras/LoadFiles.asm', '!.include Source/Extras/LoadFiles.asm') | Set-Content $tournamentPath
(Get-Content $tournamentPath).replace('Source/KingBird/MultiGCT.asm', 'Source/Netplay/Net-MultiGCT.asm') | Set-Content $tournamentPath
$tournamentContent = Get-Content $tournamentPath
$tournamentContent[15] += "`r`n`r`n# Netplay Codeset Differences:`r`n"
$tournamentContent[15] += "#`r`n"
$tournamentContent[15] += "# NETBOOST.GCT is loaded instead of BOOST.GCT (see bottom of codeset)`r`n"
$tournamentContent[15] += '# "Source/Netplay/Net-CodeMenu.asm" is loaded instead of "Source/KingBird/CodeMenu.asm"'
$tournamentContent[15] += "`r`n#`r`n"
$tournamentContent[15] += "#############################################################################"
$tournamentContent | Set-Content $tournamentPath

#NETPLAY.txt
$netplayPath = "..\Build\KingBird\NETPLAY.txt"
(Get-Content $netplayPath).replace('RSBE01.txt', 'NETPLAY.txt') | Set-Content $netplayPath
(Get-Content $netplayPath).replace('0417BE74 15200017', '0417BE74 04000001') | Set-Content $netplayPath
(Get-Content $netplayPath).replace('0417BE70 00021000', '0417BE70 00020000') | Set-Content $netplayPath
(Get-Content $netplayPath).replace('Source/KingBird/CodeMenu.asm', 'Source/Netplay/Net-CodeMenu.asm') | Set-Content $netplayPath
(Get-Content $netplayPath).replace('.include Source/Extras/LoadFiles.asm', '!.include Source/Extras/LoadFiles.asm') | Set-Content $netplayPath
(Get-Content $netplayPath).replace('Source/KingBird/MultiGCT.asm', 'Source/Netplay/Net-MultiGCT.asm') | Set-Content $netplayPath
$netplayContent = Get-Content $netplayPath
$netplayContent[15] += "`r`n`r`n# Netplay Codeset Differences:`r`n"
$netplayContent[15] += "#`r`n"
$netplayContent[15] += "# NETBOOST.GCT is loaded instead of BOOST.GCT (see bottom of codeset)`r`n"
$netplayContent[15] += '# "Source/Netplay/Net-CodeMenu.asm" is loaded instead of "Source/KingBird/CodeMenu.asm"'
$netplayContent[15] += "`r`n#`r`n"
$netplayContent[15] += "#############################################################################"
$netplayContent | Set-Content $netplayPath

#NETBOOST.txt
$netboostPath = "..\Build\KingBird\NETBOOST.txt"
(Get-Content $netboostPath).replace('Source/KingBird/StageFiles.asm', 'Source/Netplay/Net-StageFiles.asm') | Set-Content $netboostPath
(Get-Content $netboostPath).replace('.include Source/Extras/Console.asm', '#.include Source/Extras/Console.asm') | Set-Content $netboostPath
(Get-Content $netboostPath).replace('#.include Source/Extras/Netplay.asm', '.include Source/Extras/Netplay.asm') | Set-Content $netboostPath

#Net-MultiGCT
(Get-Content "..\Build\KingBird\Source\Project+\MultiGCT.asm") -replace 'BOOST.GCT', 'NETBOOST.GCT' | Out-File -encoding ASCII "..\Build\KingBird\Source\Netplay\Net-MultiGCT.asm"

#Net-StageFiles
$stagefilesPath = "..\Build\KingBird\Source\Netplay\Net-StageFiles.asm"
(Get-Content $stagefilesPath).replace('/sound/tracklist/', '/sound/netplaylist/') | Set-Content $stagefilesPath
(Get-Content $stagefilesPath).replace('source/KingBird/MyMusic.asm', 'source/Netplay/Net-MyMusic.asm') | Set-Content $stagefilesPath
$stagefilesContent = Get-Content $stagefilesPath
$stagefilesContent[0] = "#`r`n"
$stagefilesContent[0] += "# This file is nearly identical to Project+/StageFiles.asm but changes the following:`r`n"
$stagefilesContent[0] += "# -it points to Netplay/Net-MyMusic.asm instead of Project+/MyMusic.asm`r`n"
$stagefilesContent[0] += '# -string "/sound/tracklist/" -> "sound/netplaylist/"'
$stagefilesContent[0] += "`r`n#`r`n#################################"
$stagefilesContent | Set-Content $stagefilesPath

#Net-MyMusic
$mymusicPath = "..\Build\KingBird\Source\Netplay\Net-MyMusic.asm"
(Get-Content $mymusicPath).replace("CMM SD File Saver (Uses SD Root Code’s Directory) [Desi, Fracture, DukeItOut]", "# Note that CMM SD File Saver isn’t present here, that’s by design! Netplay doesn’t save tracklists on purpose!`r`n!CMM SD File Saver (Uses SD Root Code’s Directory) [Desi, Fracture, DukeItOut]") | Set-Content $mymusicPath

#RSBE01.txt
#$rsbe01Path = "..\Build\KingBird\RSBE01.txt"
#$strapcode = Select-String -Path $rsbe01Path -Pattern "046CADE8"
#if ($strapcode -eq $null)
#{
#	(Get-Content $rsbe01Path).replace("80078E14", "80078E14`r`n* 046CADE8 48000298") | Set-Content $rsbe01Path
#}