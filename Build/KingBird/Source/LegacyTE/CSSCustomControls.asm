##################################################
CSS Custom Controls V1.51 [Fracture, DukeItOut]
##################################################
# Rewritten for stability and feature
# reasons to prevent it from occupying
# inappropriate memory
#
# Made portable. Note: It is now dependent 
# on sc_selcharacter.pac containing Msg
# data in Misc Data 140, 150, 160, 170 and 180!
##################################################
.alias TagSize = 0x124		# Size of each individual tag in memory
							# Configured this way should custom tag sizes happen in the future.
.alias SFX_Enter2		=	0x26	# (Menu 17)
.alias SFX_Enter3		=	0x25	# (Menu 16)
.alias SFX_Exit2   		= 	0x28	# (Menu 19)
.alias SFX_Exit3		=	0x08	# (Menu  8)
.alias SFX_MaxPage		=	0x03	# (Menu  4)
.alias SFX_SelectOption =	0x01	# (Menu  2)
.alias SFX_ToggleRumble	= 	0x24	# (Menu 15)

HOOK @ $8069FE78	# Done so there's room for a pointer below.
{
	lwz r0, 0x24(r1)
	mtlr r0
	addi r1, r1, 0x20
	blr 
}

	.BA<-InputTable
	.BA->$8069FE7C
	.BA<-DataRefTable
	.BA->$8069FE80
	.BA<-ButtonTable
	.BA->$8069FE84
	.RESET
	.GOTO->CustomControlCode

InputTable:

byte[4] 12, 15, 8, 13		# Input slots for each controller type. GC, Wiimote+Nunchuk, Wiimote, Classic

DataRefTable:

word[5] 0,0,0,0,0	# Addresses for MiscData[140], [150], [160], [170] and [180] from sc_selcharacter.pac
word[2] 0,0			# Used for tags (0x14, 0x18)	# Previously 935CE3D4, 935CE3D8
byte[4] 0,0,0,0		# Controller slot values (0x1C-0x1F)	# Previously 935CE3D0
word[4] 0,0,0,0		# Used for controller pointers (0x20, 0x24, 0x28, 0x2C) # Previously 935CE300


ButtonTable:
# GC Button
byte[8] 9, 0, 1, 2, 3, 4, 5, 6 		# 9: ATTACK, SPECIAL, JUMP, SHIELD, GRAB, UP TAUNT, SIDE TAUNT
byte[8] 7, 8, 0, 0, 0, 0, 0, 0 		# DOWN TAUNT, NONE 
#
byte[8]   9,   0, 1, 2, 3, 4, 0xA, 0xB	# Control index value to save as.
byte[8] 0xC, 0xE, 0, 0, 0, 0, 0, 0
#
# GC/CC Stick
#
byte[8] 10, 0, 1, 2,  3, 4, 11, 12	# 10: ATTACK, SPECIAL, JUMP, SHIELD, GRAB, TAUNT, CHARGE
byte[8] 13, 8, 14, 0, 0, 0, 0, 0	# TILT, NONE, SMASH
#
byte[8] 10, 0, 1, 2, 3, 4, 0xA, 0xB
byte[8] 0xC, 0xE, 5, 0, 0, 0, 0, 0
#
# GC/CC/Nunchuk Tap Jump
#
byte[8] 2, 10, 11, 0, 0, 0, 0, 0 # 2: ON, OFF
byte[8] 0, 0,   0, 0, 0, 0, 0, 0

byte[8] 2, 0x80, 0, 0, 0, 0, 0, 0 # Special. Toggles to 0x80 if Tap Jump on index 0x1F
byte[8] 0, 0,    0, 0, 0, 0, 0, 0

CustomControlCode:

###
# Set pointers to Misc Data blocks with text we need when generating the CSS.
###
op stwu r1, -0x40(r1) 	@ $806828C4	# Expand stack for below
op stw r0, 0x44(r1)		@ $806828D0
op lwz r0, 0x44(r1)		@ $80682914
op addi r1, r1, 0x40	@ $8068291C
HOOK @ $806828DC
{
	mr r30, r3				# Original operation
	stw r29, 0x18(r1)
	stw r28, 0x1C(r1)
	
	lis r29, 0x805A
	lwz r29, 0x60(r29)
	lwz r29, 0x04(r29)
	lwz r29, 0x410(r29)		# sc_selcharacter.pac
	# lis r29, 0x90E4
	# lwz r29, 0x3430(r29)	# 90E43020 + 0x410. sc_selcharacter.pac
	lis r28, 0				# Counter
	
	
  
AccessLoop: 
	mr r3, r29					# We'll be using this pac file pointer a few times. 
	li r4, 0					#
	li r5, 1					# Misc Data	
	mulli r12, r28, 10			# Each block we'll use is separated by 10
	addi r6, r12, 140			# 140: Control Options. 150: GC, 160: Nunchuk, 170: Wiimote, 180: Classic
	lis r7, 1					# \
	subi r7, r7, 2				# / FFFE
	bla 0x015DB4				# Get archive data
	rlwinm r12, r28, 2, 0, 31
	mulli r12, r28, 4			# Each of the 5 will be separated by a word
	
	lis r4, 0x806A 		# \
	lwz r4, -0x180(r4)	# / POINTER to DataRefTable
	stwx r3, r4, r12	# write the pointer to the appropriate slot!
	
	addi r28, r28, 1
	cmpwi r28, 5
	blt+ AccessLoop

	lwz r29, 0x18(r1)	# \ Restore
	lwz r28, 0x1C(r1)	# /	
    li r3, 0x654		# Original operation
	li r4, 42			# Original value.

}

HOOK @ $8069F254
{
  lis r11, 0x100
  stw r11, 0x60(r3)
  lis r11, 0xFFFF
  ori r11, r11, 0xF0
  stw r11, 0x64(r3)
  addi r11, r1, 0x20
}
HOOK @ $8069FEAC
{
  lwz r26, 0(r3)
  cmpwi r26, 0x0;  bne- loc_0x48
  lbz r26, 0x57(r3)
  # lis r28, 0x935C;  ori r28, r28, 0xE300				# POINTER 935CE300 
	lis r28, 0x806A 		# \
	lwz r28, -0x180(r28)	# | POINTER to DataRefTable
	addi r28, r28, 0x20		# /
  cmpwi r26, 0x31;  bne- loc_0x24;  stw r3, 0x00(r28)		# 8156A77C for P1???

loc_0x24:
  cmpwi r26, 0x32;  bne- loc_0x30;  stw r3, 0x04(r28)

loc_0x30:
  cmpwi r26, 0x33;  bne- loc_0x3C;  stw r3, 0x08(r28)

loc_0x3C:
  cmpwi r26, 0x34;  bne- loc_0x48;  stw r3, 0x0C(r28)

loc_0x48:
  mr r26, r3
}

###TODO: FIX THIS ONE IN PARTICULAR BY PORTING IT OUT. THIS CODE IS WAY TOO AGGRESIVELY PLACED IN INPUTS AND ONLY ACCESSES GC
HOOK @ $80029738
{
	lis r31, 0x805C; lwz r31,-0x7450(r31) 	# 805B8BB0
	cmpwi r31, 0; beq- skipInit # Game uninitialized
	lwz r30, 0xC(r31)
	lwz r31, 8(r31) 
	cmpwi r31, 4; blt+ skipInit
	cmpwi r31, 6; bgt+ skipInit
	cmpwi r30, 3; blt+ skipInit
	cmpwi r30, 4; bgt+ skipInit # only activate on CSS
onCSS:
	
  li r31, 0x0;  addi r26, r26, 0x6;  cmpwi r31, 0x10;  bge- loc_0x3D4		# wtf

loc_0x10:
  # lis r30, 0x935C;  ori r30, r30, 0xE300		# POINTER TO 935CE300 where pointer is kept!
	lis r30, 0x806A 		# \
	lwz r30, -0x180(r30)	# | POINTER to DataRefTable
	addi r30, r30, 0x20		# /  
  lwzx r5, r30, r31;  cmpwi r5, 0x0;  beq- loc_0x3C4	# Always loads directly from 935CE300?????? Why lwzx???
  lhz r4, 100(r5)		# BUGGY
  lhz r30, 0(r26);  and r4, r4, r30;  sth r4, 0(r26)
  eqv r4, r4, r30;  sth r4, 100(r5)	# BUGGY
					
  lbz r4, 96(r5); 		 # BUGGY
					cmpwi r4, 0x1;  bne- loc_0x1AC
  lbz r6, 71(r5);  		# BUGGY
				subi r30, r6, 0x1
  lbz r4, 111(r5);  	# BUGGY
			cmplw r30, r4;  bge- loc_0x1A8
  lbz r30, 71(r5)
  add r30, r30, r30
  addi r30, r30, 0x6E
  lhzx r30, r5, r30		# Get the port 
  # lis r6, 0x935C;  ori r6, r6, 0xE3D0		# POINTER TO 935CE3D0		# Custom point where we stored tag index
  	lis r6, 0x806A 		# \
	lwz r6, -0x180(r6)	# | POINTER to DataRefTable
	addi r6, r6, 0x1C	# /
  li r4, 0x0
  lbz r0, 0(r6);  cmpwi r4, 0x4;  bge- loc_0xA0

loc_0x84:
  cmpw r0, r30;  bne- loc_0x90
				b loc_0xA8

loc_0x90:
  lbzu r0, 1(r6);  addi r4, r4, 0x1;  cmpwi r4, 0x4;  blt+ loc_0x84

loc_0xA0:
  lis r4, 0xFFFF;  ori r4, r4, 0xFFFF				# Set to -1

loc_0xA8:
  addi r6, r5, 0x167;  li r3, 0x0
  lbz r0, 0(r6);  cmpwi r3, 0x4;  bge- loc_0xD8

loc_0xBC:
  cmpw r0, r30;  bne- loc_0xC8
				b loc_0xE0

loc_0xC8:
  lbzu r0, 4(r6);  addi r3, r3, 0x1;  cmpwi r3, 0x4;  blt+ loc_0xBC		# Loop 4 times. Why not just do lbzu r0, 0x10(r6)? 

loc_0xD8:
  lis r3, 0xFFFF;  ori r3, r3, 0xFFFF				# Set to -1

loc_0xE0:
  and r4, r4, r3;  cmpwi r4, 0x0;  blt- loc_0xF4
  li r4, 0x0		# Force it to behave as if there was no input if there was no input?!?!?!?
  b loc_0xF8

loc_0xF4:
  lhz r4, 0(r26);  
loc_0xF8: 
  andi. r6, r4, 0x1000;  cmpwi r6, 0x0;  beq- loc_0x144		# START BUTTON	
  lwz r6, 68(r5);  mulli r6, r6, 0x2;  addi r6, r6, 0x6E
  lhzx r6, r5, r6;  mulli r6, r6, 0x124		# How much each tag is separated by
  lhz r3, 112(r5);  mulli r3, r3, 0x124		# How much each tag is separated by 
  lis r4, 0x9017;  ori r4, r4, 0x2E30			# POINTER TO 90172E30. Location of tags but offset by 0x10
  lwzx r3, r4, r3;  subi r3, r3, 0x1;  stwx r3, r4, r6
  lhz r4, 100(r5); andi. r4, r4, 0xEFFF;  sth r4, 100(r5)	# TEST CONTROLLER BUT FILTER OUT START BUTTON
  li r4, 0x0

loc_0x144:
  andi. r6, r4, 0x810;  cmpwi r6, 0x0;  beq- loc_0x160			# Y OR Z
  # lis r6, 0x935C;  ori r6, r6, 0xE3D0			# POINTER TO 935CE3D0	# Sets byte to 1 if in custom controls
  	lis r6, 0x806A 		# \
	lwz r6, -0x180(r6)	# | POINTER to DataRefTable
	addi r6, r6, 0x1C	# /
  rlwinm r3, r31, 30, 0, 31;  stbx r30, r6, r3							# 0 if entering custom controls

loc_0x160:
  andi. r30, r4, 0x10;  cmpwi r30, 0x0;  beq- loc_0x174			# Z BUTTON
  li r4, 0x0;  stb r4, 96(r5)

loc_0x174:
  andi. r4, r4, 0x800;  cmpwi r4, 0x0;  beq- loc_0x1A8			# Y BUTTON
  li r4, 0x2;  stb r4, 96(r5)
  lbz r4, 71(r5);  stb r4, 97(r5)
  lbz r4, 111(r5);  stb r4, 98(r5)
  li r4, 0x0;  stb r4, 103(r5)				# Set to top of list
  li r4, 0xB;  stb r4, 102(r5)				# Set there to be 11 options (Tap is 0xB)

loc_0x1A8:
  b loc_0x3C4

loc_0x1AC:
  lbz r30, 71(r5);  cmpwi r30, 0xFF;  bne- loc_0x1C4
  li r30, 0x0;  stb r30, 103(r5)
  li r4, 0x4

loc_0x1C4:
  lbz r6, 111(r5);  cmpw r30, r6;  ble- loc_0x1DC
  addi r30, r6, 0x0;  stb r30, 103(r5)
  li r4, 0x4

loc_0x1DC:
  cmpw r30, r6;  bne- loc_0x214
  lbz r6, 43(r26);  extsb r6, r6;  cmpwi r6, 0xFFC3;  bgt- loc_0x1FC
  li r6, 0x0;  stb r6, 43(r26)

loc_0x1FC:
  lbz r6, 1(r26);  andi. r3, r6, 0x4;  cmpwi r3, 0x0;  beq- loc_0x214
  andi. r6, r6, 0xFFFB;  stb r6, 1(r26)

loc_0x214:
  cmpwi r30, 0x0;  bne- loc_0x24C
  lbz r6, 43(r26);  extsb r6, r6;  cmpwi r6, 0x3D;  blt- loc_0x234
  li r6, 0x0;  stb r6, 43(r26)

loc_0x234:
  lbz r6, 1(r26);  andi. r3, r6, 0x8;  cmpwi r3, 0x0;  beq- loc_0x24C
  andi. r6, r6, 0xFFF7;  stb r6, 1(r26)

loc_0x24C:
  cmpwi r4, 0x2;  bne- loc_0x310
  lhz r4, 0(r26);  andi. r30, r4, 0x200;  cmpwi r30, 0x0;  beq- loc_0x2AC
  li r4, 0xFF
  # lis r3, 0x935C;  ori r3, r3, 0xE3D0				# POINTER TO 935CE3D0 # Sets to FF to let it know something?
  	lis r3, 0x806A 		# \
	lwz r3, -0x180(r3)	# | POINTER to DataRefTable
	addi r3, r3, 0x1C	# /
  rlwinm r6, r31, 30, 0, 31
  stbx r4, r3, r6		# Set port byte to -1
  li r4, 0x1;  stb r4, 96(r5)
  lbz r4, 97(r5);  stb r4, 103(r5)
  lbz r4, 98(r5);  stb r4, 102(r5)
  lhz r4, 100(r5);  andi. r4, r4, 0xFDFF;  sth r4, 100(r5)
  lhz r4, 0(r26);  andi. r4, r4, 0xFDFF;  sth r4, 0(r26)
  b loc_0x30C

loc_0x2AC:
  andi. r30, r4, 0x100;  cmpwi r30, 0x0;  beq- loc_0x30C	# A BUTTON for entering the customization
  li r4, 0x3;  stb r4, 96(r5)
  lbz r4, 71(r5);  stb r4, 99(r5)
  li r30, 0x0;  stb r30, 103(r5)
  li r30, 0x8;  lbz r4, 99(r5)				# Normally, there are 9 options (0x8 is the highest)
  cmpwi r4, 0x8;  bne- loc_0x2E4			# If the setting 8, it is the C-Stick
  addi r30, r30, 0x1						# Add one option for C-Stick (Smash)

loc_0x2E4:
  cmpwi r4, 0xB;  bne- loc_0x2F0			# If this is Tap Jump
  li r30, 0x1								# There are 2 settings (0, 1)!

loc_0x2F0:
  stb r30, 102(r5)
  lhz r4, 100(r5);  andi. r4, r4, 0xFEFF;  sth r4, 100(r5)		# Filter out Start
  lhz r4, 0(r26);  andi. r4, r4, 0xFEFF;  sth r4, 0(r26)		# Filter out Start

loc_0x30C:
  b loc_0x3C4

loc_0x310:
  cmpwi r4, 0x3;  bne- loc_0x3C4
  lhz r4, 0(r26);  andi. r4, r4, 0x300							# FILTER FOR ONLY A AND B
  cmpwi r4, 0x0;  beq- loc_0x3C4								# NOTHING
  cmpwi r4, 0x100;  bne- loc_0x394								# A BUTTON
  
  # By process of elimination, this is for pressing B
  
  lbz r4, 97(r5);  mulli r4, r4, 0x2;  addi r4, r4, 0x6E
  lhzx r4, r5, r4;  mulli r4, r4, 0x124;  addi r4, r4, 0x14
  lbz r30, 99(r5);  add r30, r30, r4
  lbz r6, 71(r5);  cmpwi r6, 0x5;  blt- loc_0x360
  addi r6, r6, 0x5

loc_0x360:
  cmpwi r6, 0xE;  bne- loc_0x36C		# 
  li r6, 0x5							# 

loc_0x36C:
  cmpwi r6, 0xD;  bne- loc_0x378		# 
  li r6, 0xE							# NONE

loc_0x378:
  lbz r4, 111(r5);  cmpwi r4, 0x1;  bne- loc_0x388
  rlwinm r6, r6, 7, 24, 24

loc_0x388:
  lis r4, 0x9017;  ori r4, r4, 0x2E20;  stbx r6, r4, r30

loc_0x394:
  li r4, 0x2;  stb r4, 96(r5)
  lbz r4, 99(r5);  stb r4, 103(r5)
  li r4, 0xB;  stb r4, 102(r5)
  lhz r4, 100(r5);  andi. r4, r4, 0xFCFF;  sth r4, 100(r5)
  lhz r4, 0(r26);  andi. r4, r4, 0xFCFF;  sth r4, 0(r26)

loc_0x3C4:
  addi r31, r31, 0x4
  addi r26, r26, 0x40
  cmpwi r31, 0x10
  blt+ loc_0x10

loc_0x3D4:
  # lis r30, 0x935C;  ori r30, r30, 0xE300		# POINTER TO 935CE300		# Sets ports 1-4
  	lis r30, 0x806A 		# \
	lwz r30, -0x180(r30)	# | POINTER to DataRefTable
	addi r30, r30, 0x20		# /
  li r5, 0x0
  stw r5, 0(r30)		# \ 
  stw r5, 4(r30)		# | Reset all 4 ports 
  stw r5, 8(r30)		# |
  stw r5, 12(r30)		# /
skipInit:
  lis r26, 0x805B;  ori r26, r26, 0xAD00
  lwz r0, 68(r1)
}


HOOK @ $8069F684
{
  lhz r3, 102(r6);  cmpwi r3, 0xF0;  bne- loc_0x1DC
  lbz r3, 96(r6);  cmpwi r3, 0x2;  blt- loc_0x1DC
  mr r28, r5							# Index from the top of which option you are currently on
  addi r29, r5, 0x0						# Store it in r29 AND r28??????
 
  cmpwi r3, 0x2;  bne- loc_0xC8
	 mr r29, r6
	
  	lis r3, 0x806A; lwz r3, -0x180(r3); lwz r3, 4(r3)		# Misc Data 150  
	mr r4, r5			# Message ID
	addi r5, r1, 0x48	# Where to write length
	addi r6, r1, 0x4C		
	bla 0x06B134		# Get the message data
	lwz r4, 0x48(r1)	# start of array of characters
	mr r5, r3			# length
	mr r3, r30			# r30 = where to write to characters, moved to r3
	bla 0x004338		# Copy text
	addi r30, r6, 1	
	
	
	mr r5, r28
    mr r6, r29
	mr r29, r28





loc_0x58:
  lis r3, 0x3A20;  stw r3, 0(r30)		# ": "
  addi r30, r30, 0x2					# move over two characters
  lbz r3, 97(r6);  mulli r3, r3, 0x2;  addi r3, r3, 0x6E
  lhzx r3, r6, r3						# Get tag ID of current slot
  mulli r3, r3, 0x124					# Amount each tag is separated by. r3 was the tag index offset.
  lis r4, 0x9017;  ori r4, r4, 0x2E20	# POINTER TO 90172E20	# Tags in save file. 
  add r3, r3, r4							# Each tag block is separated by 0x124
  addi r3, r3, 0x14							# Beginning of input block
  lbzx r4, r3, r5;  cmpwi r4, 0x5;  bne- loc_0x98				
  li r4, 0x9							# Set to 9 if it finds a 5 for C-Stick Smash?????????

loc_0x98:
  cmpwi r5, 0xB;  bne- loc_0xA8			# Branch if not Tap Jump
  rlwinm r4, r4, 25, 31, 31				# Do weird things to the value
  addi r4, r4, 0xF						# instead of something normal.

loc_0xA8:
  cmpwi r4, 0xE;  bne- loc_0xB8			# if option is NONE internally
  li r4, 0x8							# make it choose option 8 (NONE)
  b loc_0xC4

loc_0xB8:
  cmpwi r4, 0xA;  blt- loc_0xC4			# 
  subi r4, r4, 0x5						# If too high, prevent crash from bad options, there are only 10 possibilities.

loc_0xC4:								# MOVE IT OVER
  addi r29, r4, 0x0

loc_0xC8:
  lbz r3, 111(r6);  cmpwi r3, 0x1;  bne- loc_0xD8		# if the entry count is 1 (technically 2), then use indexes 10 and 11
  addi r29, r29, 10					# TAP JUMP OFF, ON are 10 and 11

loc_0xD8:
  lbz r4, 96(r6);  cmpwi r4, 0x2;  bne- loc_0x138				# S TAUNT, D TAUNT, NONE, SMASH, OFF, ON
  cmpwi r28, 0x8;  bne- loc_0x138		# Branch if not the C-Stick
  cmpwi r29, 0x5;  bne- loc_0x10C
  li r29, 12			# TAUNT (5)
  b loc_0x138
  
loc_0x10C:
  cmpwi r29, 0x6;  bne- loc_0x124	
  li r29,13			# CHARGE (6)
  b loc_0x138

loc_0x124:
  cmpwi r29, 0x7;  bne- loc_0x138
  li r29, 14			# TILT (7)

loc_0x138:
  cmpwi r4, 0x3;  bne- loc_0x190
  lbz r28, 99(r6);  cmpwi r28, 0x8;  bne- loc_0x190				# SKIP THESE IF NOT THE C-STICK
					cmpwi r29, 0x5;  bne- loc_0x164
  li r29, 12		# TAUNT
  b loc_0x190

loc_0x164:
  cmpwi r5, 0x6;  bne- loc_0x17C
  li r29, 13		# CHARGE
  b loc_0x190

loc_0x17C:
  cmpwi r29, 0x7;  bne- loc_0x190
  li r29, 14		# TILT

loc_0x190:
/*
  mulli r29, r29, 0x8				# OFFSET TO EACH OPTION RELATIVE TO 935CE56C (NONE is 8th regardless)
  add r3, r3, r29
  lbz r4, 0(r3);  stb r4, 0(r30)
  cmpwi r4, 0x0
  beq- loc_0x1B8

loc_0x1A8:
  lbzu r4, 1(r3);  stbu r4, 1(r30)
  cmpwi r4, 0x0
  bne+ loc_0x1A8					# WRITE STRING UNTIL NULL TERMINATOR IS FOUND
*/

  	lis r3, 0x806A; lwz r3, -0x180(r3); lwz r3, 0(r3)		# Misc Data 140  
	mr r4, r29			# Message ID
	addi r5, r1, 0x48	# Where to write length
	addi r6, r1, 0x4C		
	bla 0x06B134		# Get the message data
	lwz r4, 0x48(r1)	# start of array of characters
	mr r5, r3			# length
	mr r3, r30			# r30 = where to write to characters, moved to r3
	bla 0x004338		# Copy text
	li r3, 0
	stb r3, 1(r6)		# Add terminator
	
loc_0x1B8:
  mr r3, r31
  # mr r7, r18
  lwz r31, 124(r1)
  lwz r30, 120(r1)
  lwz r29, 116(r1)
  lwz r28, 112(r1)
  lwz r0, 132(r1)
  mtlr r0
  addi r1, r1, 0x80
  blr 

loc_0x1DC:
  cmpwi r5, 0x0
}


HOOK @ $806A0154
{
  lbz r4, 102(r26);  cmpwi r4, 0x0;  beq- loc_0x10
  stw r4, 108(r26)

loc_0x10:
  lbz r4, 103(r26);  cmpwi r4, 0xF0;  beq- loc_0x20
  stw r4, 68(r26)

loc_0x20:
  li r4, 0xF0;  sth r4, 102(r26)
  lwz r4, 68(r26)
}

HOOK @ $8068A0F4
{
  lbz r28, 604(r23);  cmpwi r28, 0x0;  bne- loc_0x2C
  mfctr r28
  lis r3, 0x806A;  ori r3, r3, 0x714		# POINTER TO 806A0714	#### close/[MuSelctChrList]
  mtctr r3;  addi r3, r23, 0x1FC;  bctrl 
  mtctr r28;
  li r3, 0x2

loc_0x2C:
  cmpwi r3, 0x1
}
HOOK @ $8069B868
{
  li r19, 0x1
  stb r19, 604(r29)
  mr r19, r3
}
###
# Tag name creation using Z
###
HOOK @ $8069B87C
{
  lbz r3, 604(r29);  cmpwi r3, 0x0;  bne- loc_0x70
  lbz r19, 579(r29);  mulli r19, r19, 0x2;  addi r19, r19, 0x26A;  lhzx r19, r29, r19
  lis r5, 0x8000;  lwz r5, 10240(r5);  cmpwi r5, 0x1;  bne- loc_0x3C
  lis r5, 0x805A;  lwz r5, 224(r5);  lwz r5, 28(r5);  stb r19, 40(r5)

loc_0x3C:
  mulli r3, r19, 0x124			 # Tags are separated by this amount
  lis r4, 0x9017;  ori r4, r4, 0x2E30		# POINTER TO 90172E30
  add r4, r4, r3
  lis r3, 0x806A; lwz r3, -0x180(r3); stw r4, 0x18(r3)
  # lis r3, 0x935C;  ori r3, r3, 0xE3D8;  stw r4, 0(r3)	# POINTER TO 935CE3D8
  lwz r4, 0(r4)
  stw r4, 0x14(r3)
  # lis r3, 0x935C;  ori r3, r3, 0xE3D4;  stw r4, 0(r3)	# POINTER TO 935CE3D4
  li r4, 0x1;  stb r4, 613(r29)

loc_0x70:
  li r3, 0x0;  stb r3, 604(r29)
  mr r3, r20
}
###
# Tag name creation using Z
###
HOOK @ $8069B9F8
{
  lis r3, 0x8067;  ori r3, r3, 0x4B64;  mtctr r3;  addi r3, r29, 0x370;  bctrl 	# close/[MuSelctChrNameEntry]
  # lis r3, 0x935C;  ori r3, r3, 0xE3D0				# POINTER TO 935CE3D0
 	lis r3, 0x806A 		# \
	lwz r3, -0x180(r3)	# | POINTER to DataRefTable
	addi r3, r3, 0x1C	# /
  li r11, 0xFF;  stbx r11, r3, r30				# set to -1 the port
  lbz r3, 604(r29);  cmpwi r3, 0x0;  bne- loc_0x98
  # lis r3, 0x935D;  lwz r3, -7212(r3)				# POINTER TO 935CE3D4
  # lis r11, 0x935D;  lwz r11, -7208(r11)				# POINTER TO 935CE3D8
  
  lis r3, 0x806A; lwz r3, -0x180(r3)
  
  lwz r11, 0x18(r3)
  lwz r3, 0x14(r3)		# Data Pointer  
  cmpwi r11, 0	# TODO: figure out cause. Prevent break. 
  beq- loc_0x98	# Result is backing out to the CSS instead of the tag selected.
  
  stw r3, 0(r11)
  li r3, 0x1;  stb r3, 612(r29)
  lis r3, 0x8069;  ori r3, r3, 0xF240;  mtctr r3
  addi r3, r29, 0x1FC
  li r4, 0x0
  lwz r5, 68(r3)
  lwz r11, 108(r3);  cmpwi r5, 0x0;  bge- loc_0x78
  lbz r5, 111(r3);  b loc_0x94

loc_0x78:
  cmpw r5, r11;  ble- loc_0x88
  lbz r5, 111(r3)
  b loc_0x94

loc_0x88:
  mulli r5, r5, 0x2;  addi r5, r5, 0x6E
  lhzx r5, r3, r5		# Get tag index
loc_0x94:
  bctrl 			# open/[MuSelctChrList]

loc_0x98:
}
HOOK @ $8068A278
{
  lbz r5, 612(r24);  cmpwi r5, 0x1;  bne- loc_0x20
  stb r4, 612(r24)
  li r4, 0x7;  lbz r5, 595(r24);  subi r5, r5, 0x31
  b %END%

loc_0x20:
  li r5, 0x0

}
HOOK @ $8069B840
{
  lbz r19, 604(r29)
  cmpwi r19, 0x0;  bne- loc_0x14
  cmpwi r3, 0x3E8; b %END%
loc_0x14:
  cmpwi r3, 0x78
}
HOOK @ $8069F9E4
{
  li r5, 0x0
  lbz r20, 96(r24);  cmpwi r20, 0x1;  bne- loc_0x5C
  # lis r20, 0x935C;  ori r20, r20, 0xE3D0			# POINTER TO 935CE3D0
  	lis r20, 0x806A 		# \
	lwz r20, -0x180(r20)	# | POINTER to DataRefTable
	addi r20, r20, 0x1C		# /
  li r19, 0x0
  lbz r18, 0(r20);  cmpwi r19, 0x4;  bge- loc_0x44
loc_0x28:
  cmpw r18, r4;  bne- loc_0x34
				b loc_0x4C
loc_0x34:
  lbzu r18, 1(r20);  addi r19, r19, 0x1;  cmpwi r19, 0x4;  blt+ loc_0x28
loc_0x44:
  lis r19, 0xFFFF;  ori r19, r19, 0xFFFF
loc_0x4C:
  cmpwi r19, 0x0
  blt- loc_0x58
  li r5, 0x1
loc_0x58:
  or r5, r5, r0
loc_0x5C:
  cmpwi r5, 0x0
}

HOOK @ $806A004C
{
  # lis r3, 0x935C;  ori r3, r3, 0xE3D0		# POINTER TO 935CE3D0
  	lis r3, 0x806A 		# \
	lwz r3, -0x180(r3)	# | POINTER to DataRefTable
	addi r3, r3, 0x1C	# /
  li r5, 0x0
  lbz r6, 0(r3);  cmpwi r5, 0x4;  bge- loc_0x34		# It is always 0!

loc_0x18:
  cmpw r6, r4;  bne- loc_0x24
				b loc_0x3C

loc_0x24:
  lbzu r6, 1(r3);  addi r5, r5, 0x1;  cmpwi r5, 0x4;  blt+ loc_0x18 # Why not just do lbz r6, 4(r3)?

loc_0x34:
  lis r5, 0xFFFF;  ori r5, r5, 0xFFFF

loc_0x3C:
  cmpwi r5, 0x0;  blt- loc_0x4C
  li r25, 0x1
  li r27, 0x3

loc_0x4C:
  lis r3, 0x805A
}
HOOK @ $806828C8
{
  # lis r3, 0x935C;  ori r3, r3, 0xE3D0	# POINTER TO 935CE3D0
  	lis r5, 0x806A 		# \
	lwz r5, -0x180(r5)	# / POINTER to DataRefTable

   li r0, -1;  stw r0, 0x1C(r5)		# Reset all controllers to -1
	mflr r0 # Original operation

}
HOOK @ $8069FECC
{
  lbz r4, 96(r3);  cmpwi r4, 0x1;  bgt- loc_0x40
  andi. r14, r6, 0x400;  cmpwi r14, 0x400;  bne- loc_0x40		# X BUTTON
  lwz r14, 68(r3);  cmpwi r14, 0x0;  bne- loc_0x40
  lbz r14, 87(r3);  subi r14, r14, 0x31
  lis r4, 0x9017;  ori r4, r4, 0xBE60	# POINTER TO 9017BE60
  lbzux r14, r4, r14;  xori r14, r14, 1;  stb r14, 0(r4)

loc_0x40:
  rlwinm. r4, r0, 0, 23, 23
}
HOOK @ $806A0714
{
  lis r4, 0x100;  stw r4, 96(r3)
  lbz r4, 87(r3)
  # lis r5, 0x935C;  ori r5, r5, 0xE3CF	# POINTER TO 935CE3CF
  	lis r5, 0x806A 		# \
	lwz r5, -0x180(r5)	# | POINTER to DataRefTable
	addi r5, r5, 0x1B	# / 1C - 1 since D0 - 1
  andi. r4, r4, 0xF
  li r6, 0xFF;  stbx r6, r5, r4
  stwu r1, -16(r1)
}
HOOK @ $8069FE88
{
  stw r0, -4(r1);  mflr r0
  stw r0, 4(r1);  mfctr r0
  stw r0, -8(r1);

  stwu r1, -132(r1)
  stmw r3, 8(r1)
  lbz r31, 96(r3);  cmpwi r31, 0x2;  blt- loc_0x30
  li r31, 0x0;  stw r31, 12(r4)

loc_0x30:
  lmw r3, 8(r1);  addi r1, r1, 0x84
  lwz r0, -8(r1);  mtctr r0
  lwz r0, 4(r1);  mtlr r0
  lwz r0, -4(r1);  stwu r1, -64(r1)
}


# TAG FORMAT
#
# 0x00-0xxB 5-character length
# 0x0C Rumble
# 0x14 L		-	BUTTON
# 0x15 R		-	BUTTON
# 0x16 Z		-	BUTTON
# 0x17 D^		-	BUTTON
# 0x18 D<>		-	BUTTON 
# 0x19 Dv		-	BUTTON
# 0x1A A		-	BUTTON
# 0x1B B		-	BUTTON
# 0x1C CSTICK	-	STICK
# 0x1D Y		-	BUTTON
# 0x1E X		-	BUTTON
# 0x1F TAP JUMP-	TOGGLE	(0x80)


# Input Settings:
# 00 - ATTACK
# 01 - SPECIAL
# 02 - JUMP
# 03 - SHIELD
# 04 - GRAB

# 05 - SMASH	(STICK-ONLY)

# 0A - U TAUNT - TAUNT
# 0B - S TAUNT - CHARGE
# 0C - D TAUNT - TILT

# 0E - NONE

#
# TO FIND: Shake
# ZL, ZR, Plus, Minus, 1, 2
# C