; --------------- Testfil för kompilatorn --------------------
    Nop
    ld r12, 15
    ldi r11, 31
    sto r8, 12
TEST:
    add r3, r2, R5
    addi r3, r2, 21
    sub r3, r2, R5
    SUBi r3, r2, 21
    mul r2, r3, r8
    muli r4, r8, 08
    lsr r4, r4, r2
    lsri r2, r2, 43
    and r1, r5, R10
    anDi r2, r6, 17
    or r2, r4, r6
    ori r3, r9, 13
    not r3, r7
    noti r13, 68
    cmp r4, r5
    cmpi r2, 7
    beQ TEST
    bne TEST
    bra Test
    brie test 
    cli 