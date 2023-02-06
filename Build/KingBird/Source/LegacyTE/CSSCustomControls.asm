CSS Custom Controls
* 42000000 92000000
* 075CE310 00000060
* 4C000000 00000000	# L
* 52000000 00000000 # R
* 5A000000 00000000 # Z
* 44205550 00000000 # D UP
* 44205349 44450000 # D SIDE
* 4420444F 574E0000 # D DOWN
* 41000000 00000000 # A
* 42000000 00000000 # B
* 43535449 434B0000 # CSTICK
* 59000000 00000000 # Y
* 58000000 00000000 # X
* 54415000 00000000 # TAP

* 42000000 80000000

* 42000000 92000000 
* 075CE370 00000060
* 41545441 434B0000 # ATTACK
* 53504543 49414C00 # SPECIAL
* 4A554D50 00000000 # JUMP
* 53484945 4C440000 # SHIELD
* 47524142 00000000 # GRAB
* 55205441 554E5400 # U TAUNT
* 53205441 554E5400 # S TAUNT
* 44205441 554E5400 # D TAUNT
* 4E4F4E45 00000000 # NONE
* 534D4153 48000000 # SMASH
* 4F464600 00000000 # OFF
* 4F4E0000 00000000 # ON

* 42000000 80000000

* 42000000 92000000
* 075CE56C 00000018
* 5441554E 54000000 # TAUNT
* 43484152 47450000 # CHARGE
* 54494C54 00000000 # TILT
* 42000000 80000000

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
  lis r28, 0x935C;  ori r28, r28, 0xE300				# POINTER 935CE300 
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

###TODO: FIX THIS ONE IN PARTICULAR
HOOK @ $80029738
{
  li r31, 0x0;  addi r26, r26, 0x6;  cmpwi r31, 0x10;  bge- loc_0x3D4		# wtf

loc_0x10:
  lis r30, 0x935C;  ori r30, r30, 0xE300		# POINTER TO 935CE300 where pointer is kept!
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
  lis r6, 0x935C;  ori r6, r6, 0xE3D0		# POINTER TO 935CE3D0		# Custom point where we stored tag index
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
  lis r6, 0x935C;  ori r6, r6, 0xE3D0			# POINTER TO 935CE3D0	# Sets byte to 1 if in custom controls
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
  lis r3, 0x935C;  ori r3, r3, 0xE3D0				# POINTER TO 935CE3D0 # Sets to FF to let it know something?
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
  lis r30, 0x935C;  ori r30, r30, 0xE300		# POINTER TO 935CE300		# Sets ports 1-4
  li r5, 0x0
  stw r5, 0(r30)		# \ 
  stw r5, 4(r30)		# | Reset all 4 ports 
  stw r5, 8(r30)		# |
  stw r5, 12(r30)		# /
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
  mulli r3, r5, 0x8						# Each option is separated by 8 characters!
  lis r4, 0x935C;  ori r4, r4, 0xE310;  add r3, r3, r4	# POINTER TO 935CE310	# BUTTONS
  lbz r4, 0(r3);  stb r4, 0(r30)
  cmpwi r4, 0x0;  beq- loc_0x58

loc_0x48:	# String write loop!
  lbzu r4, 1(r3);  stbu r4, 1(r30)
  cmpwi r4, 0x0;  bne+ loc_0x48			# Write string until null terminator is written!

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
  bc 20, 20, 0xc4

loc_0xB8:
  cmpwi r4, 0xA;  blt- loc_0xC4			# 
  subi r4, r4, 0x5						# If too high, prevent crash from bad options, there are only 10 possibilities.

loc_0xC4:								# MOVE IT OVER
  addi r29, r4, 0x0

loc_0xC8:
  lbz r3, 111(r6);  cmpwi r3, 0x1;  bne- loc_0xD8		# if the entry count is 1 (technically 2), then use 0xA and 0xB
  addi r29, r29, 0xA					# TAP JUMP OFF, ON are 0xA and 0xB

loc_0xD8:
  lis r3, 0x935C;  ori r3, r3, 0xE370	# POINTER TO 935CE370	# ATTACK, SPECIAL, JUMP, SHIELD, GRAB, U TAUNT,
  lbz r4, 96(r6);  cmpwi r4, 0x2;  bne- loc_0x138				# S TAUNT, D TAUNT, NONE, SMASH, OFF, ON
  cmpwi r28, 0x8;  bne- loc_0x138		# Branch if not the C-Stick
  cmpwi r29, 0x5;  bne- loc_0x10C
  lis r3, 0x935C;  ori r3, r3, 0xE56C	# POINTER TO 935CE56C	# TAUNT, CHARGE, TILT
  li r29, 0x0			# TAUNT (5)
  b loc_0x138
  
loc_0x10C:
  cmpwi r29, 0x6;  bne- loc_0x124
  lis r3, 0x935C;  ori r3, r3, 0xE56C	# POINTER TO 935CE56C	# TAUNT, CHARGE, TILT	
  li r29, 0x1			# CHARGE (6)
  b loc_0x138

loc_0x124:
  cmpwi r29, 0x7;  bne- loc_0x138
  lis r3, 0x935C;  ori r3, r3, 0xE56C	# POINTER TO 935CE56C	# TAUNT, CHARGE, TILT	
  li r29, 0x2			# TILT (7)

loc_0x138:
  cmpwi r4, 0x3;  bne- loc_0x190
  lbz r28, 99(r6);  cmpwi r28, 0x8;  bne- loc_0x190				# SKIP THESE IF NOT THE C-STICK
					cmpwi r29, 0x5;  bne- loc_0x164
  lis r3, 0x935C;  ori r3, r3, 0xE56C	# POINTER TO 935CE56C	# TAUNT, CHARGE, TILT
  li r29, 0x0		# TAUNT
  b loc_0x190

loc_0x164:
  cmpwi r5, 0x6;  bne- loc_0x17C
  lis r3, 0x935C;  ori r3, r3, 0xE56C	# POINTER TO 935CE56C	# TAUNT, CHARGE, TILT
  li r29, 0x1		# CHARGE
  b loc_0x190

loc_0x17C:
  cmpwi r29, 0x7;  bne- loc_0x190
  lis r3, 0x935C;  ori r3, r3, 0xE56C	# POINTER TO 935CE56C	# TAUNT, CHARGE, TILT
  li r29, 0x2		# TILT

loc_0x190:
  mulli r29, r29, 0x8				# OFFSET TO EACH OPTION RELATIVE TO 935CE56C (NONE is 8th regardless)
  add r3, r3, r29
  lbz r4, 0(r3);  stb r4, 0(r30)
  cmpwi r4, 0x0
  beq- loc_0x1B8

loc_0x1A8:
  lbzu r4, 1(r3);  stbu r4, 1(r30)
  cmpwi r4, 0x0
  bne+ loc_0x1A8					# WRITE STRING UNTIL NULL TERMINATOR IS FOUND

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
  lis r3, 0x935C;  ori r3, r3, 0xE3D8;  stw r4, 0(r3)	# POINTER TO 935CE3D8
  lwz r4, 0(r4)
  lis r3, 0x935C;  ori r3, r3, 0xE3D4;  stw r4, 0(r3)	# POINTER TO 935CE3D4
  li r4, 0x1;  stb r4, 613(r29)

loc_0x70:
  li r3, 0x0;  stb r3, 604(r29)
  mr r3, r20
}

HOOK @ $8069B9F8
{
  lis r3, 0x8067;  ori r3, r3, 0x4B64;  mtctr r3;  addi r3, r29, 0x370;  bctrl 	# close/[MuSelctChrNameEntry]
  lis r3, 0x935C;  ori r3, r3, 0xE3D0				# POINTER TO 935CE3D0
  li r11, 0xFF;  stbx r11, r3, r30				# set to -1 the port
  lbz r3, 604(r29);  cmpwi r3, 0x0;  bne- loc_0x98
  lis r3, 0x935D;  lwz r3, -7212(r3)				# POINTER TO 935CE3D4
  lis r11, 0x935D;  lwz r11, -7208(r11)				# POINTER TO 935CE3D8
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
  lis r20, 0x935C;  ori r20, r20, 0xE3D0			# POINTER TO 935CE3D0
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
  lis r3, 0x935C;  ori r3, r3, 0xE3D0		# POINTER TO 935CE3D0
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
HOOK @ $806828E0
{
  lis r3, 0x935C;  ori r3, r3, 0xE3D0	# POINTER TO 935CE3D0
  lis r4, 0xFFFF;  ori r4, r4, 0xFFFF;  stw r4, 0(r3)		# Reset all controllers to -1
  li r4, 0x2A
  li r3, 0x654

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
  lis r5, 0x935C;  ori r5, r5, 0xE3CF	# POINTER TO 935CE3CF
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