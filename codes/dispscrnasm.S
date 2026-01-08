;displaying number on 7seg
#define __SFR_OFFSET 0
#include <avr/io.h>

.global disp_scrn

.section .text

disp_scrn:
	;shifting LSB in r24 to 6th position
	LDI R16, 0b00000010	;counter = 2
	RCALL looplsl		;calling the looplsl routine
	OUT PORTD,R24		;writing output to pin 13 (PB5)
	RET

;loop for bit shift to left
looplsl:	
	LSL R24			;left shift
	DEC r16			;counter --
	BRNE looplsl	;if counter != 0
	RET
