#define __SFR_OFFSET 0
#include <avr/io.h>

.global load_mem

.section .text

load_mem:
  ldi xl,0x00		;loading memory address lower byte into r26
  ldi xh,0x01		;loading memory address higher byte into r27
  ldi r16,0b00000000	;initializing W
  st  x,r16		;storing W in 0x0100 address
ret

