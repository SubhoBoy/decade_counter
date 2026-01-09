; initasm.S
; Setup Input/Output ports and Timer0
#define __SFR_OFFSET 0
#include <avr/io.h>

.global init

.section .text

init:
    ldi r16, 0b00111100
    out DDRD, r16

    ldi r16, 0b00100000
    out DDRB, r16

    ; Timer Freq = 16000000 / 1024 = 15625 Hz
    ; 10ms = 0.01s * 15625 = ~156 ticks.
    
    ldi r16, 0
    out TCCR0A, r16
    
    ldi r16, 0b00000101 ; Prescaler 1024
    out TCCR0B, r16

    ldi r16, 156 ; Compare val
    out OCR0A, r16
    
    ldi r16, 0b00000010
    out TCCR0A, r16

    ret
