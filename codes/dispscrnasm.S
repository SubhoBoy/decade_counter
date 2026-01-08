;displaying number on 7seg
#define __SFR_OFFSET 0
#include <avr/io.h>

.global disp_scrn

.section .text

disp_scrn:
push r16
    push r17
    push r26        ; XL
    push r27        ; XH

  ldi xl, 0x00
  ldi xh, 0x01

  ldi r22, 0b00000010	;counter = 0
  ld  r0, x		;load number from memory
  mov r16, r0

loopw:

  lsl r0		;left shift
  dec r22		;counter --
  brne loopw		;if counter !=0

  out PORTD,r0		;writing output to pins 2,3,4,5

      ; We want r16 = r16 + 1 using only logic gates
    ldi r17, 1              ; We are adding '1' to the accumulator

addl:
    mov r18, r16            ; Save copy of current accumulator
    eor r16, r17            ; SUM = A XOR B (Calculate sum without carry)
    and r18, r17            ; CARRY = A AND B (Calculate where carries happen)
    lsl r18                 ; Shift Carry to the left (Carry goes to next bit)
    mov r17, r18            ; Move new carry to r17
    tst r17                 ; Check if Carry is 0
    brne addl        ; If Carry exists, repeat loop


    cpi r16, 10             ; Compare result with 10
    brne save       ; If not 10, skip reset
    ldi r16, 0              ; If 10, reset counter to 0

save:
    st x, r16               ; Save new value to memory
    pop r27
    pop r26
    pop r17
    pop r16
    ret
	;shifting LSB in r24 to 6th position
