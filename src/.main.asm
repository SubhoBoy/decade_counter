;using assembly language for accessing arduino memory
;to drive a seven segment display


;.include "../../setup/m328Pdef/m328Pdef.inc"
.include "/root/m328Pdef.inc"

sbi DDRB, 5 ;set pin 13 as output pin (DDRB pin 5)
ldi r16, 0b00000101 ;the last 3 bits define the prescaler, 101 => division by 1024
out TCCR0B, r16 

  ldi r16,0 		;reset system status
  out SREG,r16		;init stack pointer
   ldi r16,low(RAMEND)	;0xff
   out SPL,r16
   ldi r16,high(RAMEND)	;0x08
   out SPH,r16

  ldi r16,0b00111100	;identifying output pins 2,3,4,5
  out DDRD,r16		;declaring pins as output
  ldi xl,0x00		;loading memory address lower byte into r26
  ldi xh,0x01		;loading memory address higher byte into r27
  ldi r16,0b00000000	;initializing W 
  st  x,r16		;storing W in 0x0100 address

;start printing numbers from 0-9

Start:

  ldi r22, 0b00000010	;counter = 0
  ld  r0, x		;load number from memory
  mov r16, r0

loopw:

  lsl r0		;left shift
  dec r22		;counter --
  brne loopw		;if counter !=0

  out PORTD,r0		;writing output to pins 2,3,4,5
  ldi r19, 50
  sbi PINB,5
  call PAUSE		;calling delay
  sbi PINB,5
  ldi r19, 11
  call PAUSE

      ; We want r16 = r16 + 1 using only logic gates
    ldi r17, 1              ; We are adding '1' to the accumulator

add:
    mov r18, r16            ; Save copy of current accumulator
    eor r16, r17            ; SUM = A XOR B (Calculate sum without carry)
    and r18, r17            ; CARRY = A AND B (Calculate where carries happen)
    lsl r18                 ; Shift Carry to the left (Carry goes to next bit)
    mov r17, r18            ; Move new carry to r17
    tst r17                 ; Check if Carry is 0
    brne add        ; If Carry exists, repeat loop


    cpi r16, 10             ; Compare result with 10
    brne save       ; If not 10, skip reset
    ldi r16, 0              ; If 10, reset counter to 0

save:
    st x, r16               ; Save new value to memory
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
