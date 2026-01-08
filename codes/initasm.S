#define __SFR_OFFSET 0
#include <avr/io.h>

.global init
.section .text

init:
push r16
	sbi DDRB, 5 ;set pin 13 as output pin (DDRB pin 5)
	ldi r16, 0b00000101 ;the last 3 bits define the prescaler, 101 => division by 1024
	out TCCR0B, r16


/*  ldi r16,0 		;reset system status
  out SREG,r16		;init stack pointer
   ldi r16,low(RAMEND);0xff
   out SPL,r16
   ldi r16,high(RAMEND)*/;0x08


   out SPH,r16
	ldi r16,0b00111100	;identifying output pins 2,3,4,5
	out DDRD,r16
	;declaring pins as output
	pop r16
	ret
