#include <red932.inc>

cseg at 0
	mov P2.0, #0

loop:
	mov c, P2.0 
	jnc led_on
	sjmp loop

led_on:
	mov P2.4, #0x01
	sjmp loop




;fucntions:

;100ms delay
DELAY:
	MOV R0 0x91
DLOOP:	MOV R1 0xFF
DLOOP2: DJNZ R1, DLOOP2
	DJNZ R0, DLOOP
	RET



;iNCREMENT AND dECREMENT STUFFS
;If Inc button pressed (Sw1)
;0=ON   1=OFF
inc button pressed
	setb c ;set carry to 1
L1:
	JC LED1
L2:
	JC LED2
L3:
	JC LED3
L4:
	JC LED4
Done:
	sjmp (CHECKING FOR INPUT)

;Here are all the actions for the LED's
LED1: 
	JB p2.4, LED1_ISOFF
	JNB p2.4 LED1_ISON
LED1_ISON:
	setb p2.4 	;Turning LED off
LED1_ISOFF:
	clr p2.4 	;Turning LED on
	clr c		;Clear C
	sjmp L2
;LED 2
LED2: 
	JB p0.5, LED2_ISOFF
	JNB p0.5 LED2_ISON
LED2_ISON:
	setb p0.5 	;Turning LED off
LED2_ISOFF:
	clr p0.5 	;Turning LED on
	clr c		;Clear C
	sjmp L3
;LED 3
LED3: 
	JB p2.7, LED3_ISOFF
	JNB p2.7 LED3_ISON
LED3_ISON:
	setb p2.7 	;Turning LED off
LED3_ISOFF:
	clr p2.7 	;Turning LED on
	clr c		;Clear C
	sjmp L4
;LED 4
LED4: 
	JB p0.6, LED4_ISOFF
	JNB p0.6 LED4_ISON
LED4_ISON:
	setb p0.6 	;Turning LED off
	;Clears all the LED's because over 15
	setb p2.4
	setb p0.5
	setb p2.7
	setb p0.6

LED4_ISOFF:
	clr p0.6 	;Turning LED on
	clr c		;Clear C
	sjmp Done




