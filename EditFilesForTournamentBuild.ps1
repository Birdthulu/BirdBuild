Write-Host "Enabling Console.asm"
(Get-Content ".\TournamentBuild\KingBird\BOOST.txt") -replace '#.include Source/Extras/Console.asm', '.include Source/Extras/Console.asm' | Out-File -encoding ASCII ".\TournamentBuild\KingBird\BOOST.txt"

Write-Host "Enabling Tournament Code Menu"
(Get-Content ".\TournamentBuild\KingBird\RSBE01.txt") -replace "CodeMenu.asm", "Tourney-CodeMenu.asm" | Out-File -encoding ASCII ".\TournamentBuild\KingBird\RSBE01.txt"

Write-Host "Enabling ALC"
(Get-Content ".\TournamentBuild\KingBird\RSBE01.txt") -replace "0417F368 08010100", "0417F368 08010101" | Out-File -encoding ASCII ".\TournamentBuild\KingBird\RSBE01.txt"

Write-Host "Setting Default Stagelist"
(Get-Content ".\TournamentBuild\KingBird\RSBE01.txt") -replace "0417F36C 00000000", "0417F36C 00000000`r`n* 0417BE74 04A08521 # Brawl stages`r`n* 0417BE70 00020000 # Melee stages" | Out-File -encoding ASCII ".\TournamentBuild\KingBird\RSBE01.txt"

Write-Host "Disabling Fudgepop code menu"
(Get-Content ".\TournamentBuild\KingBird\RSBE01.txt") -replace '.include Source/Extras/LoadFiles.asm', '!.include Source/Extras/LoadFiles.asm' | Out-File -encoding ASCII ".\TournamentBuild\KingBird\RSBE01.txt"