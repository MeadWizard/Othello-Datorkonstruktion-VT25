; Test2
    ldi r11, 3
    nop
    stoi r11, 0
    ldi r12, 4
    nop
    stoi r12, 6
    ldi r13, 5
    nop
    sto r13, r12 
    nop
    brie kaos 
    nop
    nop
    nop
    nop
    nop
KAOS:
    nop
    addi r1, r1, 1
