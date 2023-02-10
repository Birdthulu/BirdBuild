##################################################
Memory Extension for FighterXResource2 [Dantarion]
#
# 0.53MB -> 0.57MB
##################################################
int 0x91E80 @ $80421B54
int 0x91E80 @ $80421B74
int 0x91E80 @ $80421B94
int 0x91E80 @ $80421BB4
int 0x91E80 @ $80421E1C
int 0x91E80 @ $80421E3C
int 0x91E80 @ $80421EBC
int 0x91E80 @ $80421EDC

#########################################
Stage Resource 6.4MB -> 6.0MB [DukeItOut]
#########################################
int 0x600000 @ $80421D64

###############################################################
Memory Extension for CSS/SSS MenuResource (+0.48MB) [DukeItOut]
###############################################################
#int 0x73EA00 @ $80422384 #+0.88MB version. Disabled for now so characters can take advanage of an extra 0.4MB due to the above code
int 0X6D8300 @ $80422384  #+0.48MB version. Keep this size synchronized with the Stage Resource change! (i.e. if Stage Resource = 6.4MB, this can be made +0.88)

###########################################
!Network Resource 1.4MB -> 1.1MB [DukeItOut]
###########################################
#Currently disabled, as with this active, entering the Home menu crashes. May consider just disabling the Home menu if things get desperate in terms of memory.
int 0x119B00 @ $804218AC

#############################################
Sound Resource 12.76MB -> 11.08MB [DukeItOut]
#
# Space used: 12.06MB (94%) -> 11.08MB (100%)
#############################################
.alias size = 0x50000    # Normally E6000
.alias size_hi = size / 0x10000
.alias size_lo = size & 0xFFFF
op li r4, 0x880 @ $8007A0D8    # \ 0x66680 block -> 0x880
op li r5, 0x880 @ $8007A0EC    # /
CODE @ $8007326C
{
    lis r31, size_hi
    ori r4, r31, size_lo
}
op ori r8, r31, size_lo @ $800732A4
int 0xB14B40 @ $804217B4	# Normally 0xCC7C00.