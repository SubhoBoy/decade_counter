; delayasm.S
; clk cycle
; Argument r24: number of 10ms ticks to wait
#define __SFR_OFFSET 0
#include <avr/io.h>

.global del

.section .text

del:
    tst r24
    breq deldone

dell:
    in r20, TIFR0 
    ldi r21, 0b00000010 ; 0CF0A
    and r20, r21
    breq dell ; flag not set, keep waiting

    out TIFR0, r21 ; clear flag
    
    dec r24
    brne dell

deldone:
    ret
