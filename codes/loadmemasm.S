#define __SFR_OFFSET 0
#include <avr/io.h>

.global load_mem

.section .text

load_mem:
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
  ret
