;using assembly language for accessing arduino memory
;to drive a seven segment display


;.include "../../setup/m328Pdef/m328Pdef.inc"
.include "/home/subho/m328Pdef.inc"

sbi DDRB, 5 ;set pin 13 as output pin (DDRB pin 5)
ldi r16, 0b00000101 ;the last 3 bits define the prescaler, 101 => division by 1024
out TCCR0B, r16

  ldi r16,0b00111100	;identifying output pins 2,3,4,5
  out DDRD,r16		;declaring pins as output
  ldi xl,0x00		;loading memory address lower byte into r26
  ldi xh,0x01		;loading memory address higher byte into r27
  ldi r16,0b00000000	;initializing W 
  st  x,r16		;storing W in 0x0100 address
  ldi r17,0x09		;initializing  count

  ;loading numbers 0-9 into memory locations 0x0100-0x0109

loop_cnt:
  
  inc r16		;increment register value
  inc xl		;increment address
  st  x, r16		;store number into memory
  dec r17		;decrement count
  brne loop_cnt 

;start printing numbers from 0-9

Start:

  ldi r17, 0x0A		;load the number 10 in r17
  clr xl		;reset memory to 0x0100

loop_inc:
;writing W to pin 2
  ldi r16, 0b00000010	;counter = 0
  ld  r0, x		;load number from memory

loopw:

  lsl r0		;left shift
  dec r16		;counter --
  brne loopw		;if counter !=0

  out PORTD,r0		;writing output to pins 2,3,4,5
  ldi r19, 50
  sbi PINB,5
  call PAUSE		;calling delay
  sbi PINB,5
  ldi r19, 11
  call PAUSE

  inc xl		;incrementing address
  dec r17		;decrement decade count
  brne loop_inc 	;branch if decade count !=0
  
  rjmp Start

PAUSE:	;this is delay (function)
lp2:	;loop runs 64 times
		IN r20, TIFR0 ;tifr is timer interupt flag (8 bit timer runs 256 times)
		ldi r21, 0b00000010
		AND r20, r21 ;need second bit
		BREQ PAUSE 
		OUT TIFR0, r21	;set tifr flag high
	dec r19
	brne lp2
	ret
