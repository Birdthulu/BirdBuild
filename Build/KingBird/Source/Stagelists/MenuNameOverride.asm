###############################################################
Set menus based on Code Menu Stagelist setting [Bird]
###############################################################
* 26523400 00000002 # If 80523400 is less than 2
string "menu2/mu_menumain.pac"          @ $806FB248
string "mu_menumain_en.pac"             @ $817F62BC
string "/menu2/sc_selcharacter.pac"     @ $806FF2EC
string "sc_selcharacter_en.pac"         @ $817F6365
string "/menu2/sc_selcharacter2.pac"    @ $806FF308
string "sc_selcharacter2_en.pac"        @ $817F634D
string "/menu2/sc_selmap.pac"           @ $806FF3F0
string "sc_selmap_en.pac"               @ $817F637C
string "stageslot/"                     @ $80550B18 # This address might change and crash
string "stageinfo/"                     @ $80550B28 # This address might change and crash
* E0000000 80008000
* 24523400 00000001 # If 80523400 is greater than 1
string "menu2/db_menumain.pac"          @ $806FB248
string "db_menumain_en.pac"             @ $817F62BC
string "/menu2/db_selcharacter.pac"     @ $806FF2EC
string "db_selcharacter_en.pac"         @ $817F6365
string "/menu2/db_selcharacter2.pac"    @ $806FF308
string "db_selcharacter2_en.pac"        @ $817F634D
string "/menu2/db_selmap.pac"           @ $806FF3F0
string "db_selmap_en.pac"               @ $817F637C
string "stageslotdubs/"                 @ $80550B18 # This address might change and crash
string "stageinfodubs/"                 @ $80550B28 # This address might change and crash
* E0000000 80008000
* 20523400 00000004 # If 80523400 is 4 (NE)
string "/menu2/ne_selmap.pac"         @ $806FF3F0
string "ne_selmap_en.pac"             @ $817F637C
string "stageslotne/"                 @ $80550B18 # This address might change and crash
string "stageinfone/"                 @ $80550B28 # This address might change and crash
* E0000000 80008000