Write-Host "Enabling Console.asm"
(Get-Content ".\WiiBuild\KingBird\BOOST.txt") -replace '#.include Source/Extras/Console.asm', '.include Source/Extras/Console.asm' | Out-File -encoding ASCII ".\WiiBuild\KingBird\BOOST.txt"
Write-Host "Enabling Tournament Codeset"
(Get-Content ".\WiiBuild\KingBird\TOURNAMENT.txt") -replace "Netplay/Tourney-Net-CodeMenu.asm", "Project+/Tourney-CodeMenu.asm" | Out-File -encoding ASCII ".\WiiBuild\KingBird\TOURNAMENT.txt"
(Get-Content ".\WiiBuild\KingBird\TOURNAMENT.txt") -replace "Netplay/Net-MultiGCT.asm", "Project+/MultiGCT.asm" | Out-File -encoding ASCII ".\WiiBuild\KingBird\TOURNAMENT.txt"
$TournamentPath = ".\WiiBuild\KingBird\TOURNAMENT.txt"
$strapcode = Select-String -Path $TournamentPath -Pattern "046CADE8"
if ($strapcode -eq $null)
{
	(Get-Content $TournamentPath).replace('80078E14', "80078E14`r`n* 046CADE8 48000298") | Set-Content $TournamentPath
}