;Delay routine for blinking LED
#define __SFR_OFFSET 0
#include <avr/io.h>

.global delay

.section .text

delay:
lp2:	;loop runs 64 times
		IN r20, TIFR0 ;tifr is timer interupt flag (8 bit timer runs 256 times)
		ldi r21, 0b00000010
		AND r20, r21 ;need second bit
		BREQ delay
		OUT TIFR0, r21	;set tifr flag high
	dec r24
	brne lp2
	ret
