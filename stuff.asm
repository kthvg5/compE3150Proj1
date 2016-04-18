#include <reg932.inc>

cseg at 0
	mov P2M1,#0 				; set Port 2 to bi-directional
 	mov P1M1,#0 				; set Port 1 to bi-directional
 	mov P0M1,#0 				; set Port 0 to bi-directional
	setb P2.0					; Set Switch 2 to not pressed
	setb P2.3					; Set Switch 3 to not pressed
	mov TMOD, #0x01
NOT_PRESSED:	
	jnb	p0.1, NOT_PRESSED			;Make sure it isn't held down
	jnb	p2.3, NOT_PRESSED
DELAY:							;100ms delay for input
	MOV R0, 0x91
DLOOP:	
	MOV R1, 0xFF
DLOOP2: 
	DJNZ R1, DLOOP2
	DJNZ R0, DLOOP
	acall WAIT_INPUT

WAIT_INPUT:			
	jnb P0.1, INCREMENT			;Check for Increment button, Sw2
	jnb P2.3, DECREMENT			;Check for Decrement button, Sw3		
	acall WAIT_INPUT			;will continue to loop here until Sw1 is pressed

INCREMENT:
	ACALL SOUND_INC
	JB p2.4, CHECK_NEG
	JNB p0.5, CHECK_NEG
 	JNB p2.7, CHECK_NEG
        JNB p0.6, CHECK_NEG
	JB p0.4, INC_NEG
	SETB p2.4
	SETB p0.4
	ACALL DELAYDOT5S
	ACALL SOUND_DEC
	ACALL DONE			;check for from -1 to 0, beep beep noise
CHECK_NEG:
	JNB p0.4, DEC_NEG ;This port being 0 indicates negative

INC_NEG:							;Will increment by 1 0=ON and 1=OFF			
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
	acall NOT_PRESSED 				;jumps up to delay input
LED1: 
	JB p2.4, LED1_ISOFF
	JNB p2.4, LED1_ISON
LED1_ISON:
	setb p2.4 					;Turning LED off
	acall L2
LED1_ISOFF:
	clr p2.4 					;Turning LED on
	clr c					
	acall L2
;LED 2
LED2: 
	JB p0.5, LED2_ISOFF
	JNB p0.5, LED2_ISON
LED2_ISON:
	setb p0.5 
	acall L3					;Turning LED off
LED2_ISOFF:
	clr p0.5 					;Turning LED on
	clr c						
	acall L3
;LED 3
LED3: 
	JB p2.7, LED3_ISOFF
	JNB p2.7, LED3_ISON
LED3_ISON:
	setb p2.7
	acall L4 					;Turning LED off
LED3_ISOFF:
	clr p2.7 					;Turning LED on
	clr c		
	acall L4
;LED 4
LED4: 
	JB p0.6, LED4_ISOFF
	JNB p0.6, LED4_ISON
LED4_ISON:
	setb p0.6 					;Clears all the LED's because over 15
	setb p2.4					
	setb p0.5
	setb p2.7
	setb p0.6
	setb p0.4					;rollover always turns off negative light
	;ACALL BEEP_UP
	acall DONE
LED4_ISOFF:
	clr p0.6 					;Turning LED on
	clr c		
	acall DONE

DECREMENT:
	ACALL SOUND_DEC
	JNB p0.4, INC_NEG   		;This port being 0 indicates negative
DEC_NEG:
 	JNB p2.4, NOT_0 	;this chunk checks for the exception
	JNB p0.5, NOT_0 	;where we would be going from 0 to -1
	JNB p2.7, NOT_0	
	JNB p0.6, NOT_0
	CLR p2.4
	CLR p0.4
	ACALL DELAYDOT5S
	ACALL SOUND_INC
	ACALL DONE	;sepcial case, from 1 to 0, beep beep noise
NOT_0:
	JNB p2.4, D_L1ON
	CLR p2.4		;p2.4 = 0, light is on
	ACALL D_L2		;check light 2
D_L1ON:
	SETB p2.4	       
	ACALL DONE		;ACALL DOWN_SOUND		; Play a sound when exiting

D_L2:
	JNB p0.5, D_L2ON
	CLR p0.5		;p.05 = 0, light is on	       
	ACALL D_L3		;check light 3
D_L2ON:
	SETB p0.5	       
	ACALL DONE		;ACALL DOWN_SOUND		; Play a sound when exiting

D_L3:
	JNB p2.7, D_L3ON
	CLR p2.7		;p2.7 = 0, light is on	       
	ACALL D_L4		;check light 4
D_L3ON:
	SETB p2.7	       
	ACALL DONE		;ACALL DOWN_SOUND		; Play a sound when exiting

D_L4:
	JNB p0.6, D_L4ON
	CLR p0.6		;p0.6 = 0, light is on	       
	ACALL DONE		;ACALL DOWN_SOUND		; Play a sound when exiting
D_L4ON:
	SETB p0.6	       
	ACALL DONE		; ACALL DOWN_SOUND		; Play a sound when exiting

SOUND_INC: ;----------------------------------BEGIN SOUND CODE FOR 1 PARTICULAR FREQUENCY. DOCUMENTATION BELOW--------------------
	MOV R7, #255 ;MAKES FOR A DECENT LENGTH BEEP
	SINC_LOOP:
	SETB p1.7
	ACALL DELAY500HZ
	CLR p1.7
	ACALL DELAY500HZ
	DJNZ R7, SINC_LOOP
	RET

DELAY500HZ:
	CLR TF0
	CLR TR0
	MOV TL0,#0xCD ;MODIFY THESE FOR DIFFERENT FREQUENCIES, THERE IS A PROGRAM PACKAGED IN THE PROJECT FOLDER THAT CAN CALCULATE THESE FOR YOU :)
	MOV TH0,#0xFE
	SETB TR0
	WAIT500: JNB TF0, WAIT500
	CLR TR0
	CLR TF0
	;SETB p1.7 
	RET
;----------------------------------------END 1 FREQ. SOUND CODE--------------------------------------------------------------	
SOUND_DEC:
	MOV R7, #255
	SDEC_LOOP:
	SETB P1.7
	ACALL DELAY250HZ
	CLR P1.7
	ACALL DELAY250HZ
	DJNZ R7, SDEC_LOOP
	RET

DELAY250HZ:
	CLR TF0
	CLR TR0
	MOV TL0,#0x33
	MOV TH0,#0xFB
	SETB TR0
	WAIT250: JNB TF0, WAIT250
	CLR TR0
	CLR TF0
	;SETB p1.7 
	RET

DELAYDOT5S:
	MOV R7, #5
	DELDOT5SINNER:
	CLR TF0
	CLR TR0
	MOV TL0,#0xFE
	MOV TH0,#0x0F
	SETB TR0
	WAIT5S: JNB TF0, WAIT5S
	CLR TR0
	CLR TF0
	;SETB p1.7 
	DJNZ R7, DELDOT5SINNER
	RET

;REST:
;        mov R0, #1
;	mov R3, #0x00	; TIMER 0 re-load value is set to minimum
;	mov R4, #0x00	; possible value.
;	acall stall
;	ret


END