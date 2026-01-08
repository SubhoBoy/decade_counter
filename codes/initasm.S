#define __SFR_OFFSET 0
#include <avr/io.h>

.global init

.section .text

init:
	sbi DDRB, 5 ;set pin 13 as output pin (DDRB pin 5)
	ldi r16, 0b00000101 ;the last 3 bits define the prescaler, 101 => division by 1024
	out TCCR0B, r16

	ldi r16,0b00111100	;identifying output pins 2,3,4,5
	out DDRD,r16		;declaring pins as output
	ret
