; decadeasm.S
#define __SFR_OFFSET 0
#include <avr/io.h>

.global logic
.global clk

.section .text

;#define r16 = r16
;#define r17 = r17
;#define r18 = r18
;#define r19 = r19
;#define r20 = r20
;#define r21 = r21
;#define r22 = r22
;#define r23 = r23
;#define r24 = r24

logic:

    in r16, PIND
    bst r16, 6      ; bit store 6 
    clr r17
    bld r17, 0         ; bit lod 0

    in r16, PIND
    bst r16, 7
    clr r18
    bld r18, 0

    in r16, PINB
    bst r16, 0
    clr r19
    bld r19, 0

    in r16, PINB
    bst r16, 1
    clr r20
    bld r20, 0

    ; KArnaugh wheeee 
    ; A = !W
    mov r21, r17
    ldi r16, 1
    eor r21, r16 ; bit not    

    ; B = !Z & (W XOR X)
    mov r22, r17
    eor r22, r18        ; W XOR X
    mov r16, r20
    com r16         ; !Z
    and r22, r16     

    ; C = !Z & (Y XOR (W & X))
    mov r16, r17
    and r16, r18     
    eor r16, r19     
    mov r23, r16
    mov r16, r20
    com r16         
    and r23, r16     

    ; D = (W&&X&&Y&&!Z)||(!W&&!X&&!Y&&Z)
    ; W & X & Y & !Z
    mov r24, r17
    and r24, r18
    and r24, r19
    mov r16, r20
    com r16
    and r24, r16     
    
    ; !W & !X & !Y & Z
    mov r16, r17
    com r16         
    mov r25, r18
    com r25
    and r16, r25
    mov r25, r19
    com r25
    and r16, r25
    and r16, r20
    
    or r24, r16
    ; Fiiiiin

   ; Printing part
   ; DON'T TOUCH OTHER BITS IN PORT
    mov r16, r21
    lsl r16
    lsl r16         ; A << 2
    
    mov r25, r22
    lsl r25
    lsl r25
    lsl r25           ; B << 3
    or r16, r25

    mov r25, r23
    swap r25          ; craaazy. swaps nibbles, so like lsl 4
    or r16, r25

    mov r25, r24
    swap r25          
    lsl r25           ; D << 5
    or r16, r25

    in r25, PORTD     
    andi r25, 0b11000011 ; ONLY 2345!!!
    or r25, r16     
    out PORTD, r25    

    ret

clk:
    tst r24
    breq off
    sbi PORTB, 5
    ret
off:
    cbi PORTB, 5
    ret
