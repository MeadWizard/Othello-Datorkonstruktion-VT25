MAIN:
        bra loop

LOOP:
        addi r1, r1, 1     ; 6 # Increment low word
        nop
        subi r2, r1, 8
        nop
        beq finish  ; Z-flaggan sätts inte så hoppet utförs inte då r2=0
        bra loop

FINISH:
        ldi r4, 10 
        ;nop
        ldi r5, 3
        nop    
        sto r5, r4
        stoi r4, 11
        ld r6, r4
        ;bra main



