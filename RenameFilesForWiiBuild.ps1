(Get-Content ".\KingBird\BOOST.txt") -replace '#.include Source/Extras/Console.asm', '.include Source/Extras/Console.asm' | Out-File -encoding ASCII ".\KingBird\BOOST.txt"
Rename-Item -Path ".\KingBird\GCTRM-Convert.bat" -NewName "GCTRM-Convert1.bat"
Get-Content ".\KingBird\GCTRM-Convert1.bat" | Where-Object {$_ -notmatch 'NET'} | Set-Content ".\KingBird\GCTRM-Convert.bat"
Remove-Item ".\KingBird\GCTRM-Convert1.bat"