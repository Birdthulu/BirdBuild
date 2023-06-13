del "..\Build\KingBird\NETPLAY.txt" -Confirm:$false -Recurse -erroraction 'silentlycontinue'
del "..\Build\KingBird\NETBOOST.txt" -Confirm:$false -Recurse -erroraction 'silentlycontinue'
del "..\Build\KingBird\pf\movie" -Confirm:$false -Recurse -erroraction 'silentlycontinue'
del "..\Build\KingBird\pf\sound\netplaylist" -Confirm:$false -Recurse -erroraction 'silentlycontinue'
#del "..\Build\KingBird\Source\Netplay" -Confirm:$false -Recurse -erroraction 'silentlycontinue'

#RSBE01.txt
#$rsbe01Path = "..\Build\KingBird\RSBE01.txt"
#$strapcode = Select-String -Path $rsbe01Path -Pattern "046CADE8"
#if ($strapcode -ne $null)
#{
#	(Type "..\Build\KingBird\RSBE01.txt") -notmatch "^* 046CADE8 48000298$" | Set-Content "..\Build\KingBird\RSBE01.txt"
#}