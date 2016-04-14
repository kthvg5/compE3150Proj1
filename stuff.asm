#include <red932.inc>

cseg at 0
	mov P2.0, #0

WAIT_INPUT:							
	jb P2.0 INCREMENT			;Check for Increment button, Sw1
	jb P0.1 DECREMENT			;Check for Decrement button, Sw2
	sjmp wait_input				;will continue to loop here until Sw1 is pressed


DELAY:							;100ms delay for input
	MOV R0 0x91
DLOOP:	MOV R1 0xFF
DLOOP2: DJNZ R1, DLOOP2
	DJNZ R0, DLOOP
	RET


INCREMENT:						;Will increment by 1 0=ON and 1=OFF			
	setb c 						;set carry to 1 which will be used to increment
L1:								;All of these loops are used to increment
	JC LED1
L2:
	JC LED2
L3:
	JC LED3
L4:
	JC LED4
DONE:
	sjmp DELAY 					;jumps up to delay input
LED1: 
	JB p2.4, LED1_ISOFF
	JNB p2.4 LED1_ISON
LED1_ISON:
	setb p2.4 					;Turning LED off
LED1_ISOFF:
	clr p2.4 					;Turning LED on
	clr c					
	sjmp L2
;LED 2
LED2: 
	JB p0.5, LED2_ISOFF
	JNB p0.5 LED2_ISON
LED2_ISON:
	setb p0.5 					;Turning LED off
LED2_ISOFF:
	clr p0.5 					;Turning LED on
	clr c						
	sjmp L3
;LED 3
LED3: 
	JB p2.7, LED3_ISOFF
	JNB p2.7 LED3_ISON
LED3_ISON:
	setb p2.7 					;Turning LED off
LED3_ISOFF:
	clr p2.7 					;Turning LED on
	clr c		
	sjmp L4
;LED 4
LED4: 
	JB p0.6, LED4_ISOFF
	JNB p0.6 LED4_ISON
LED4_ISON:
	setb p0.6 					;Clears all the LED's because over 15
	setb p2.4					
	setb p0.5
	setb p2.7
	setb p0.6

LED4_ISOFF:
	clr p0.6 					;Turning LED on
	clr c		
	sjmp DONE




