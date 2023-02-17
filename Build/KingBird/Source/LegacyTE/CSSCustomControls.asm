##################################################
CSS Custom Controls V1.6 [Fracture, DukeItOut]
##################################################
# Rewritten for stability and feature
# reasons to prevent it from occupying
# inappropriate memory or accessing
# input systems invasively.
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
.alias SFX_PinTag		=	0xD7	# (Fighter Common 159)

.macro playSFX(<soundID>)
{
	li r4, <soundID>
	lis r3, 0x805A			# \ Play Sound Effect!
	bla 0x6A83F4			# /	
}
#####
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
HOOK @ $8069FE88		# Tag menu input. (Note that page "0" (for writing tags) is not a part of this function! It won't read from here.)
{
	stw r0, -4(r1);  mflr r0
	stw r0, 4(r1);  mfctr r0
	stw r0, -8(r1);

	stwu r1, -132(r1)
	stmw r3, 8(r1)
  
	mr r5, r3				# Main pointer for information
	mr r26, r3
	mr r28, r4				# Pointer to recent inputs
  
	lwz r14, -0x20(r3)		# \ Wiimote integration is desired, but for right now, 
	cmpwi r14, 4			# | this is only covering GC for testing functionality.
	bge+ normalInputs		# / I'll try to add these afterwards at a later time.
	lbz r31, 0x60(r3);  cmpwi r31, 0x1;  beq+ TagPage		# go to check Y and Z presses if in page 1 (the normal tag page)
						cmpwi r31, 0x2;  blt- normalInputs	# Check if on page 2. If not, do normal behavior
###  
	mr r4, r31				# page index 
	
###########################
# PAGE 2/3: Custom Controls
###########################	
	lwz r6, 0x6C(r5)		# Amount of tags
	lwz r30, 0x44(r5) 		# Current tag index
	
	cmpwi r30, 0; bge+ ValidValue	# If this is a negative value 
	
	li r30, 0; stb r30, 0x67(r30)				# then set it to the first index instead
	li r4, 4		# Indicate an invalid page to suppress inputs this frame!
	
ValidValue:
	lwz r6, 0x6C(r5); cmpw r30, r6; ble+ ValidTag	# If the value is higher than the amount of tags
	mr r30, r6; stb r30, 0x67(r30)					# calibrate it to the highest possible value!
	li r4, 4		# Indicate an invalid page to suppress inputs this frame!
ValidTag:
	
	
# Check for inputs	
	lwz r12, 0x14(r28)	# Check sustained inputs
	li r11, 0			# Variable we'll use to suppress inputs
	
	cmpw r30, r6; blt+ DownPossible
	ori r11, r11, 4		# 4 = Down
DownPossible:
	cmpwi r30, 0; bgt+ UpPossible
	ori r11, r11, 8		# 8 = Up
UpPossible:
	not r11, r11		# Invert
	and r12, r12, r11
	stw r12, 0x14(r28)	# Suppress up/down inputs as needed based on slot position.

	cmpwi r4, 0x2; bne- CheckPage3
  
###############################
# PAGE 2: Custom Input Settings
###############################	
	

  
	lwz r4, 0xC(r28);  	andi. r30, r4, 0x100;  bne- APressP2
						andi. r30, r4, 0x200;  beq+ normalInputs
BPressP2:
	li r4, 0xFF		
	lbz r31, 0x57(r5)		# 
	subi r31, r31, 0x31		# Get player slot
	
  	lis r3, 0x806A 		# \
	lwz r3, -0x180(r3)	# | POINTER to DataRefTable
	addi r3, r3, 0x1C	# /
	rlwinm r6, r31, 30, 0, 31
	stbx r4, r3, r6		# Set port byte to -1
	li r4, 0x1;  stb r4, 0x60(r5)		# Change to page 1!
	lbz r4, 0x61(r5);  stb r4, 0x67(r5)
	lbz r4, 0x62(r5);  stb r4, 0x66(r5)
	%playSFX(SFX_Exit2)
	b suppressInput

APressP2:
  li r4, 0x3;  stb r4, 0x60(r5)				# Change to page 3!
  lwz r4, 0x44(r5);  stb r4, 0x63(r5)		# Store index
  li r30, 0x0;  stb r30, 0x67(r5)			# Set to the top of the index instead of using the control setting?
  li r30, 8;  lbz r4, 0x63(r5)				# Normally, there are 9 options (0x8 is the highest)
  cmpwi r4, 8;  bne- notTheCStick			# If the setting 8, it is the C-Stick
  addi r30, r30, 0x1						# Add one option for C-Stick (Smash)

notTheCStick:
  cmpwi r4, 11;  bne- notTheTap			# If this is Tap Jump
  li r30, 1								# There are 2 settings (0, 1)!
notTheTap:

  stb r30, 0x66(r5)
  %playSFX(SFX_Enter3)
  b suppressInput

#################################
# PAGE 3: Custom Command Settings
#################################

CheckPage3: 
  cmpwi r4, 0x3;  bne- normalInputs				# Not valid if it isn't page 3!
  lwz r4, 0xC(r28);  andi. r30, r4, 0x200; bne- BPressP3		# B BUTTON
					 andi. r30, r4, 0x100; beq+ normalInputs	# A BUTTON
   
  # By process of elimination, this is for pressing A
APressP3:  
  lbz r4, 0x61(r5);  mulli r4, r4, 0x2;  addi r4, r4, 0x6E
  lhzx r4, r5, r4;  mulli r4, r4, TagSize;  addi r4, r4, 0x14		# Tags are separated by this much.
  lbz r30, 0x63(r5);  add r30, r30, r4
  lwz r6, 0x44(r5);  cmpwi r6, 5;  blt- loc_0x360				# Check if less than option 5????
  addi r6, r6, 5												# Add 5 for A, B, C-Stick, Y, X and Tap Jump?

loc_0x360:
  cmpwi r6, 14;  bne- notSmash			# option (SMASH) 9 + 5 = 14. Exclusive to C-stick.
  li r6, 5								# SMASH

notSmash:
  cmpwi r6, 13;  bne- notNone			# option (NONE) 8 + 5 = 13.
  li r6, 14								# NONE

notNone:
  lwz r4, 0x6C(r5);  cmpwi r4, 0x1;  bne- notTapJump	# Check if the highest "tag" is 1. If it is, this is actually Tap Jump (2 options: 0, 1)
  rlwinm r6, r6, 7, 24, 24				# Convert setting into 0x80 bitflag for tap jump!

notTapJump:
	lis r4, 0x9017;  ori r4, r4, 0x2E20;  stbx r6, r4, r30		# Store control settings!
	%playSFX(SFX_SelectOption)
	b gotoPage2
	
BPressP3:
	%playSFX(SFX_Exit3)  
gotoPage2:
	mr r5, r26
	li r4, 2;  stb r4, 0x60(r5)			# Go back to page 2 from page 3!
	lbz r4, 0x63(r5);  stb r4, 0x67(r5)
	li r4, 11;  stb r4, 0x66(r5)		# 11 input types for GC!

	b suppressInput
  
#########################
# PAGE 1: Normal Page
#########################	
TagPage:	# Taken from loc_0x14C

		lwz r30, 0x44(r5)
		lwz r31, 0x6C(r5)
		cmpwi r30, 0; ble- normalInputs		# \ Don't allow any behaviors if not on an actual tag!
		cmpw r30, r31; bgt- normalInputs	# /

		lbz r31, 0x57(r5)		# 
		subi r31, r31, 0x31		# Get player slot
		lwz r30, 0x44(r5)		# Tag index offset
		add r30, r30, r30		# Multiply by 2
		addi r30, r30, 0x6C		# Tags start at 0x6C
		lwzx r30, r5, r30		# Get the tag we're modifying

	
	lwz r4, 0xC(r28)		# Get the current input
 
	andi. r30, r4, 0x1000;  beq- noStartPressP1			# START BUTTON
###
# Start: Tag pin
###
StartPressP1: 	# Holds true for all examples of pressing Start
	lwz r6, 0x44(r5);  mulli r6, r6, 0x2;  addi r6, r6, 0x6E	# Convert the tag
	lhzx r6, r5, r6;  mulli r6, r6, TagSize		# Index of current tag. How much each tag is separated by.
	lhz r3, 0x70(r5);  mulli r3, r3, TagSize	# The index and location of the first tag. How much each tag is separated by.
	lis r4, 0x9017;  ori r4, r4, 0x2E30			# POINTER TO 90172E30. Location of tags but offset by 0x10
	lwzx r3, r4, r3;  subi r3, r3, 0x1;  stwx r3, r4, r6	# Set new tag where first one is?
	%playSFX(SFX_PinTag)
	b suppressInput	# TODO: Force refresh of tag display.
	
noStartPressP1:	
	andi. r30, r4, 0x810;  beq- normalInputs	# Y OR Z BUTTONS PRESSED. If neither are, act normally!
	lis r6, 0x806A 		# \
	lwz r6, -0x180(r6)	# | POINTER to DataRefTable
	addi r6, r6, 0x1C	# /
	# rlwinm r3, r31, 30, 0, 31;  
	stbx r30, r6, r31							# 0 if entering custom controls

  andi. r30, r4, 0x0010;  beq- noZPressP1			# Z BUTTON
###
# Z: Tag rewrite
### 
	li r4, 0x0;  stb r4, 0x60(r5)				# Set to page 0 (Tag write)

noZPressP1:
  andi. r30, r4, 0x0800; beq- noYPressP1			# Y BUTTON
###
# Y: Tag reconfigure
### 
	li r4, 0x2;  stb r4, 0x60(r5)				# Set to page 2 (Custom Control Page)
	lwz r4, 0x44(r5);  stb r4, 0x61(r5)
	lwz r4, 0x6C(r5);  stb r4, 0x62(r5)
	li r4, 0;  stb r4, 0x67(r5)					# Set to top of list
	li r4, 11;  stb r4, 0x66(r5)				# Set there to be 11 options (Tap is 0xB)
	%playSFX(SFX_Enter2)

noYPressP1:  
  
skipInit:
  
  
###  
suppressInput:
  li r31, 0x0;  stw r31, 0xC(r28)	# Suppress controller inputs
  b finishCustomControls
  
  
  
finishCustomControls: 
normalInputs:


loc_0x30:
  lmw r3, 8(r1);  addi r1, r1, 0x84
  lwz r0, -8(r1);  mtctr r0
  lwz r0, 4(r1);  mtlr r0
  lwz r0, -4(r1);  stwu r1, -64(r1)
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
  lbz r3, 0x61(r6);  mulli r3, r3, 0x2;  addi r3, r3, 0x6E
  lhzx r3, r6, r3						# Get tag ID of current slot
  mulli r3, r3, TagSize					# Amount each tag is separated by. r3 was the tag index offset.
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
  lwz r3, 0x6C(r6);  cmpwi r3, 0x1;  bne- loc_0xD8		# if the entry count is 1 (technically 2), then use indexes 10 and 11
  addi r29, r29, 10					# TAP JUMP OFF, ON are 10 and 11

loc_0xD8:
  lbz r4, 0x60(r6);  cmpwi r4, 0x2;  bne- loc_0x138				# S TAUNT, D TAUNT, NONE, SMASH, OFF, ON
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
  lbz r28, 0x63(r6);  cmpwi r28, 0x8;  bne- loc_0x190				# SKIP THESE IF NOT THE C-STICK
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
  lbz r4, 0x66(r26);  cmpwi r4, 0x0;  beq- loc_0x10
  stw r4, 0x6C(r26)

loc_0x10:
  lbz r4, 0x67(r26);  cmpwi r4, 0xF0;  beq- loc_0x20
  stw r4, 0x44(r26)

loc_0x20:
  li r4, 0xF0;  sth r4, 0x66(r26)
  lwz r4, 0x44(r26)
}

HOOK @ $8068A0F4
{
  lbz r28, 0x25C(r23);  cmpwi r28, 0x0;  bne- loc_0x2C	# 1FC + 60
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
  stb r19, 0x25C(r29) # 1FC + 60
  mr r19, r3
}
###
# Tag name creation using Z
###
HOOK @ $8069B87C
{
  # lbz r3, 0x25C(r29);  cmpwi r3, 0x0;  bne- loc_0x70	# 1FC + 60. Skip most of this if not in page 0 of the tag menu. . . . . actually not needed.
  lwz r12, 0x240(r29);  			# Tag index
  cmpwi r12, 1; blt+ loc_0x70		# This is the first tag entry box (-1), lacking a tag (0) or invalid, not an actual tag!
  lwz r11, 0x268(r29)	# 1FC + 6C. Amount of tags.
  cmpw r12, r11; bgt+ loc_0x70		# This is the last tag entry box (Amount of tags + 1) or invalid, not an actual tag!
  
  mulli r19, r12, 0x2;  addi r19, r19, 0x26A;  lhzx r19, r29, r19	# 1FC + 44. Tag index
  
  lis r5, 0x8000;  lwz r5, 0x2800(r5);  cmpwi r5, 0x1;  bne- loc_0x3C		# Check if in custom controls menu done by Chase
  lis r5, 0x805A;  lwz r5, 0xE0(r5);  lwz r5, 0x1C(r5);  stb r19, 0x28(r5)

loc_0x3C:
  mulli r3, r19, TagSize					# Tags are separated by this amount
  lis r4, 0x9017;  ori r4, r4, 0x2E30		# POINTER TO 90172E30, first tag + 0x10
  add r4, r4, r3
  lis r3, 0x806A; lwz r3, -0x180(r3); stw r4, 0x18(r3)
  # lis r3, 0x935C;  ori r3, r3, 0xE3D8;  stw r4, 0(r3)	# POINTER TO 935CE3D8
  lwz r4, 0(r4)
  stw r4, 0x14(r3)
  # lis r3, 0x935C;  ori r3, r3, 0xE3D4;  stw r4, 0(r3)	# POINTER TO 935CE3D4
  li r4, 0x1;  stb r4, 613(r29)

loc_0x70:
  li r3, 0x0;  stb r3, 0x25C(r29)	# Force to be on custom page 0 of the tag menu
  mr r3, r20						# Original operation
}
###
# When backing out of tag renaming custom behavior, try to go to the tag we just modified.
###
HOOK @ $8069B9F8
{
  lis r3, 0x8067;  ori r3, r3, 0x4B64;  mtctr r3;  addi r3, r29, 0x370;  bctrl 	# close/[MuSelctChrNameEntry]

 	lis r3, 0x806A 		# \
	lwz r3, -0x180(r3)	# | POINTER to DataRefTable
	addi r3, r3, 0x1C	# /
	
	lbz r12, 0x253(r29)	 # 0x57 + 0x1FC 
	subi r12, r12, 0x31	 # Port slot
	li r11, 0xFF;  stbx r11, r3, r12				# set to -1 the port. Fixed relative to previous version that would always receive 0.
  
  lbz r3, 0x25C(r29);  cmpwi r3, 0x0;  bne- loc_0x98	# 1FC + 60. Check if it is page 0 (Custom tag edit). If it isn't, it is a new tag.
 
  lis r3, 0x806A; lwz r3, -0x180(r3)
  
  lwz r11, 0x18(r3)		# Data Pointer
  lwz r3, 0x14(r3)		# Start of tag character array  
  cmpwi r11, 0	#
  beq- loc_0x98	# Result is backing out to the CSS if the pointer is invalid!
  
  stw r3, 0(r11)
  li r3, 0x1;  stb r3, 0x264(r29)	# 1FC + 68
  lis r3, 0x8069;  ori r3, r3, 0xF240;  mtctr r3	# Prepare to open the tag menu after closing the tag creation menu
  addi r3, r29, 0x1FC	# Pointer needed for various things
  li r4, 0x0			# Needed to initialize opening the tag menu 
  lwz r5, 0x44(r3)		# Current tag index
  lwz r11, 0x6C(r3)		# Amount of tags
  
  cmpwi r5, 0x0;  bge- loc_0x78		# Check if this tag index was valid!
  lwz r5, 0x6C(r3);  b loc_0x94		# Set to the highest tag instead if it wasn't.

loc_0x78:
  cmpw r5, r11;  ble- loc_0x88		# Is the tag index somehow higher than the amount of tags available?
  lwz r5, 0x6C(r3)					# Set to the highest tag instead if that's the case.
  b loc_0x94

loc_0x88:
  mulli r5, r5, 0x2 	# \
  addi r5, r5, 0x6E		# | Get tag index
  lhzx r5, r3, r5		# /
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
HOOK @ $806A0714
{
  lis r4, 0x100;  stw r4, 0x60(r3)
  lbz r4, 0x57(r3)
  # lis r5, 0x935C;  ori r5, r5, 0xE3CF	# POINTER TO 935CE3CF
  	lis r5, 0x806A 		# \
	lwz r5, -0x180(r5)	# | POINTER to DataRefTable
	addi r5, r5, 0x1B	# / 1C - 1 since D0 - 1
  andi. r4, r4, 0xF
  li r6, 0xFF;  stbx r6, r5, r4
  stwu r1, -0x10(r1)	# Original operation
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