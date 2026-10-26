;
; Räkna till 50 000
;

MAIN:
    ldi r7, 0

LOOP:
    addi r1, r1, 1     ; 6 # Increment low word
    nop
    cmpi r1, 10
    nop
    beq finish  ; Z-flaggan sätts inte så hoppet utförs inte då r2=0
    bra loop
FINISH:
    ldi r5, 3
    nop    
    sto r5, r7
    addi r7, r7, 1
    ldi r1, 0
    bra LOOP