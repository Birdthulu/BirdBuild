######
Grounded Wavedashes
#####
.alias PSA_Off = 0x80541250
.alias PSA_Off2 = 0x80541350
CODE @ $80541250
{
	word 2; word PSA_Off+0x68
	word 0; word 0x19 
	word 6; word 1
	word 6; word 0x30
	word 0; word 3
	word 6; word 0x80000030
	word 0; word 0
	word 6; word 7
	word 5; IC_Basic 1018
	word 0; word 0
	word 1; scalar 0

	word 1; scalar 10.0
	word 5; LA_Float 0

	word 0x02010200; word PSA_Off+0x8
	word 0x02040200; word PSA_Off+0x18
	word 0x02040200; word PSA_Off+0x28
	word 0x02040400; word PSA_Off+0x38
	word 0x12060200; word PSA_Off+0x58		#Float Variable Set: LA-Float[0] = 10.0 (Special Landing Lag = 10 frames)
	
	word 0x02010200; word 0x80FAD8FC
	word 0x0; word 0x0 
}
CODE @ $80FC17E0
{
	word 0x00070100; word PSA_Off
}

CODE @ $80541350
{

	word 1; scalar 2.7
	word 5; LA_Float 44

	word 5; IC_Basic 1011
	word 5; LA_Float 44

	word 1; scalar 0
	word 1; scalar 0
	word 0; word 1
	word 0; word 1

	word 5; LA_Float 44
	word 1; scalar 0

	word 6; word 7
	word 5; IC_Basic 20001
	word 0; word 2
	word 1; scalar 0x19

	word 0x000A0400; word PSA_Off2+0x50 #if action = waveland 
	word 0x12060200; word PSA_Off2+0x00	#Float Variable Multiply: LA-Float[44] = 2.7
	word 0x120F0200; word PSA_Off2+0x10	#Float Variable Multiply: LA-Float[44] *= IC-Basic[1011]
	word 0x0E080400; word PSA_Off2+0x20	#Set/Add Momentum: 0.0, 0.0, 0x1, 0x1
	word 0x0E010200; word PSA_Off2+0x40	#Add/Subtract Momentum: Horizontal Speed=LA-Float[44], Vertical Speed=LA-Float[45]
	word 0x000F0000; word 0
	word 0; word 0
}

CODE @ $80FC03FC
{
	word PSA_Off2+0x70 @ $80FC03FC
}


###################################################
Melee Air Dodge v5.4 (2/2) [Shanus, Magus, camelot] Jump check added for Grounded Wavedashes [Eon]
###################################################
.alias AirDodge_Loc = 0x80541420
CODE @ $80541420
{
	#
	word 0; word 1
	#If: Comparison Compare: IC-Basic[200003] = 33.0 (IF Prev action = 0x21)
	word 6; word 7
	word 5; IC_Basic 20003
	word 0; word 2
	word 1; scalar 33.0
	#Or: Comparison Compare: IC-Basic[200003] = 127.0 (IF Prev action = 0x7F)
	word 6; word 7
	word 5; IC_Basic 20003
	word 0; word 2
	word 1; scalar 127.0
	#Change Subaction: 0x32
	word 0; word 0x32
	#Frame Speed Modifier: 3.1
	word 1; scalar 3.1
	#Pointer to Injection
	word 2; word AirDodge_Loc+0x80
	#IF prevaction = jump
	word 6; word 7
	word 5; IC_Basic 20003
	word 0; word 2
	word 1; scalar 0xA 
	#Injection Start
	word 0x02010200; word 0x80FAF454		#Change Action: Requirement: Action=E, Requirement=In Air
	word 0x08000100; word AirDodge_Loc  	#Set Aerial/Onstage State: 0x1
	word 0x000A0400; word AirDodge_Loc+0x08 #If: Comparison Compare: IC-Basic[200003] = 33.0 (IF Prev action = 0x21)
	word 0x000C0400; word AirDodge_Loc+0x28 #	Or: Comparison Compare: IC-Basic[200003] = 127.0 (IF Prev action = 0x7F)
	word 0x000C0400; word AirDodge_Loc+0x60 #	Or: Comparison Compare: IC-Basic[200003] = 127.0 (IF Prev action = 0xA)
	word 0x04000100; word AirDodge_Loc+0x48 #	Change Subaction: 0x32
	word 0x000A0400; word AirDodge_Loc+0x08 #	If: Comparison Compare: IC-Basic[200003] = 33.0 (IF Prev action = 0x21)
	word 0x000C0400; word AirDodge_Loc+0x60 #		Or: Comparison Compare: IC-Basic[200003] = 127.0 (IF Prev action = 0xA)
	word 0x04070100; word AirDodge_Loc+0x50 #		Frame Speed Modifier: 3.1,
	word 0x000F0000; word 0					#	Endif
	word 0x000F0000; word 0					#Endif
	word 0x00080000; word 0					#Return
}
CODE @ $80FC1CA0
{
	word 0x00070100; word AirDodge_Loc+0x58 #Sub Routine: Injection
}