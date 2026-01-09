; Reimplementation. Decade counter as per 7474
.include "/home/subho/m328Pdef.inc"

; y didn't i find this before
.def rT = r16
.def rW = r17
.def rX = r18
.def rY = r19
.def rZ = r20
.def rA = r21
.def rB = r22
.def rC = r23
.def rD = r24

    ; Init Stack Pointer
    ldi rT, low(RAMEND)
    out SPL, rT
    ldi rT, high(RAMEND)
    out SPH, rT
    ; cuz otherwise breaks at ret

    ; 2,3,4,5 OUTPUT 
    ; 6,7 INPUT 
    ldi rT, 0b00111100
    out DDRD, rT

    ; 8,9 INPUT
    ; 13 OUTPUT 
    ldi rT, 0b00100000
    out DDRB, rT
    
loop:
    in rT, PIND
    bst rT, 6      ; bit store 6 
    clr rW
    bld rW, 0         ; bit lod 0

    in rT, PIND
    bst rT, 7
    clr rX
    bld rX, 0

    in rT, PINB
    bst rT, 0
    clr rY
    bld rY, 0

    in rT, PINB
    bst rT, 1
    clr rZ
    bld rZ, 0

    ; KArnaugh wheeee 
    ; A = !W
    mov rA, rW
    ldi rT, 1
    eor rA, rT ; bit not    

    ; B = !Z & (W XOR X)
    mov rB, rW
    eor rB, rX        ; W XOR X
    mov rT, rZ
    com rT         ; !Z
    and rB, rT     

    ; C = !Z & (Y XOR (W & X))
    mov rT, rW
    and rT, rX     
    eor rT, rY     
    mov rC, rT
    mov rT, rZ
    com rT         
    and rC, rT     

    ; D = (W&&X&&Y&&!Z)||(!W&&!X&&!Y&&Z)
    ; W & X & Y & !Z
    mov rD, rW
    and rD, rX
    and rD, rY
    mov rT, rZ
    com rT
    and rD, rT     
    
    ; !W & !X & !Y & Z
    mov rT, rW
    com rT         
    mov r25, rX
    com r25
    and rT, r25
    mov r25, rY
    com r25
    and rT, r25
    and rT, rZ
    
    or rD, rT
    ; Fiiiiin

   ; Printing part
   ; DON'T TOUCH OTHER BITS IN PORT
    mov rT, rA
    lsl rT
    lsl rT         ; A << 2
    
    mov r25, rB
    lsl r25
    lsl r25
    lsl r25           ; B << 3
    or rT, r25

    mov r25, rC
    swap r25          ; craaazy. swaps nibbles, so like lsl 4
    or rT, r25

    mov r25, rD
    swap r25          
    lsl r25           ; D << 5
    or rT, r25

    in r25, PORTD     
    andi r25, 0b11000011 ; ONLY 2345!!!
    or r25, rT     
    out PORTD, r25    

    sbi PORTB, 5      ; clk high
    
    ldi r24, low(200)
    ldi r25, high(200)
    rcall del

    cbi PORTB, 5      ; clk low
    
    rjmp loop


del:
    push r24
    push r25
    push r26
    push r27

dello:
    ; Check if counter is zero
    mov rT, r24
    or rT, r25
    breq deldone

    ; Inner loop for 1ms
    ; 16000 cycles / 4 cycles per loop = 4000 iterations
    ldi r26, low(4000)
    ldi r27, high(4000)

delli:
    sbiw r26, 1       ; 2 cycles
    brne delli ; 2 cycles (if taken)
    
    ; Decrement ms counter
    sbiw r24, 1
    rjmp dello

deldone:
    pop r27
    pop r26
    pop r25
    pop r24
    ret
