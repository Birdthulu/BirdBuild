#########################################################################
Animation Engine v2.6 [spunit262, Phantom Wings, Almas, Magus, DukeItOut]
#########################################################################
HOOK @ $80766C20
{
  lis r3, 0x9380
  cmpw r28, r3;  bge- notValid  # Try to prevent non-characters from attempting to use this
  lwz r3, 0x110(r28)	# Access character ID
  lwz r4, 0x14(r29)		# \ Get animation frame
  lfs f1, 0x40(r4)		# /
  fctiwz f2, f1			# \ Convert current frame to an integer
  stfd f2, 0x10(r2)		# |
  lwz r0, 0x14(r2)		# /
  lwz r9, 0x58(r4)		# \ Access subaction ID
  ori r9, r9, 0x8000	# / Used as a flag to indicate that there is a difference between the action and subaction without complex coding
  lwz r5, 0x7C(r29)		# \ Access action ID
  lwz r5, 0x38(r5)		# /

loc_0x3C:
  mulli r7, r3, 0x4	
  addis r6, r7, 0x8058	# Table below starts at 80580000 + 0x1000
  lwz r6, 0(r6);  cmpwi r6, 0x0;  bge- notUniversal		# Check if the engine value ID is -1, which applies to all characters
  subi r6, r6, 0x8

loc_0x58:
  lwzu r7, 8(r6);  				cmpwi r7, 0x0; beq- loc_0x98	# If it is 0, we've made it to the end of the list.
  srawi r8, r7, 24;  			cmpw r8, r3;   bne- loc_0x98	# Check if character ID matches
  rlwinm r8, r7, 16, 24, 31;  	cmpw r0, r8;   blt- loc_0x58	# Check if frame count is lower 
  rlwinm r8, r7, 0, 16, 31;  	cmpw r8, r5;   beq- loc_0x90	# Check if action matches
								cmpw r8, r9;   bne+ loc_0x58	# Check if subaction matches

loc_0x90:
  lfs f1, 4(r6)		# Load new frame rate speed
  fmuls f0, f1, f0
  b finish

notUniversal:
loc_0x98:
  cmpwi r3, 0xFFFF;  beq- Universal
  li r3, 0xFFFF		# Set engine to universal status
  b loc_0x3C

notValid:
finish:
Universal:
  stfs f0, 0x10(r31)	# Original operation, enforce a frame rate if it is modified, above
}
HOOK @ $80766FB8
{
	cmpwi r29, 0x1
	lfs f1, 0x10(r3)
	bne- %END%
	lwz r12, 0x34(r3)
	cmpwi r12, 0x1
	bne- %END%
	lfs f1, -0x7C38(r2)
}

###################################################
Animation Engine Initialization v2.0 [Almas, Magus]
###################################################
* 2057FFF8 00000000
* 2057FFFC 00000001
PULSE 
{
  lis r10, 0x8058		# Pointer to table, below.
  ori r11, r10, 0x1000	#
  lwz r3, 0(r11);  cmpwi r3, 0x0;  beq- loc_0x40
  srawi r3, r3, 24

loc_0x18:
  mr r5, r3
  mulli r9, r3, 0x4
  stwx r11, r10, r9

loc_0x24:
  lwzu r3, 8(r11);  cmpwi r3, 0x0;  beq- loc_0x40
  srawi r3, r3, 24;  cmpw r3, r5;  beq+ loc_0x24
  b loc_0x18

loc_0x40:
  blr 
}

int 1 @ $8057FFF8
* E0000000 80008000

[Project+] Animation Modifier Data
* 2057FFFC 00000000
* 06581000 00000280
* 01000040 3F2AC083
* 02120034 3FC00000
* 02140036 3FE66666
* 02140038 3FF33333
* 030B8072 3FA22229
* 03000034 3FA66666
* 031D0036 3FA00000
* 031F0038 3FCCCCCC
* 03140123 3F99999A
* 03190125 3F800000
* 041A0034 3FC00000
* 04150036 3FC00000
* 051201BB 3F800000
* 050001BB 40266666
* 091E81DF 3F800000
* 090081DF 40400000
* 0A000040 3FAAC083
* 0B00003B 3F68F5C2
* 0D008039 3F955566
* 0D00803A 3F955566
* 0D0081D2 3FB33333
* 0D0081D5 3FB33333
* 0D0081D6 3FAAAAAB
* 0D280112 3FCA1CAC
* 0D0B0112 3F800000
* 0D000112 3FB00000
* 0D1D0113 40000000
* 0D0C0113 3FC5D174
* 0D000113 3FAAAABB
* 0D000117 3F600000
* 12128065 41F00000
* 120C8065 3E99999A
* 12058065 3FB33333
* 12008065 40200000
* 12120112 3F800000
* 12000112 40266666
* 141E81E1 3F800000
* 140081E1 3FF00000
* 15010118 3F199999
* 18088062 3F800000
* 18008062 40000000
* 18000112 3FA22222
* 18000120 3FC00000
* 19068072 3F800000
* 19008072 3F0BA2E9
* 19068073 3F800000
* 19008073 3F0BA2E9
* 1A2F0032 3FA00000
* 1A160032 3F800000
* 1A010032 3FB33333
* 1A000040 3FAAC083
* 1A00011B 3FA00000
* 1B000128 3FC00000
* 1D1B8065 3FE00000
* 1D148066 3FC00000
* 1D118066 3F800000
* 1D028066 3FC00000
* 1D000084 40000000
* 1F100034 3F999999
* 1F1D0113 3FC00000
* 2000012E 3FC00000
* 29120034 3FC00000
* 29140036 3FE66666
* 29140038 3FF33333
* 2B120034 3FC00000
* 2B140036 3FE66666
* 2B140038 3FF33333
* 2E00002F 3F999999
* 2E00010C 3FA00000
* 2E0E0119 3F800000
* 2E000119 40000000
* 2E0081D8 3F800000
* 2E0081D2 3F800000
* 2E0081E9 3FE00000
* 2E0081ED 3FE00000
* FF000041 3FD56041
* FF000064 3FA66666
* FF0080A0 3FB4F72D
* FF0080C9 3FC00000
* 00000000 00000000
* 0457FFFC 00000001
* E0000000 80008000


