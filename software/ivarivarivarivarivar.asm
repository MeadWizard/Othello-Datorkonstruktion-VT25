place_white:
    ldi r2, 2
    nop
    sto r2, r1
search_for_black:
    cmpi r13, 0
    nop
    beq search_for_black_south
    cmpi r13, 1
    nop
    beq search_for_black_north
    cmpi r13, 2
    nop
    beq search_for_black_east
    cmpi r13, 3
    nop
    beq search_for_black_west
    cmpi r13, 4
    nop
    beq search_for_black_south_east
    cmpi r13, 5
    nop
    beq search_for_black_south_west
    cmpi r13, 6
    nop
    beq search_for_black_north_east
    cmpi r13, 7
    nop
    beq search_for_black_north_west
    nop
    bra end_place_black 
    nop
search_for_black_south:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 0       ; X=0
    ldi r10, 1      ; Y=1
    nop
    bra pre_search_for_black_loop
search_for_black_north:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 0       ; X=0
    ldi r10, 65535  ; Y=-1
    nop
    bra pre_search_for_black_loop
search_for_black_east:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 1       ; X=1
    ldi r10, 0      ; Y=0
    nop
    bra pre_search_for_black_loop
search_for_black_west:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 65535   ; X=-1
    ldi r10, 0      ; Y=0
    nop
    bra pre_search_for_black_loop
search_for_black_south_east:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 1       ; X=1
    ldi r10, 1      ; Y=1
    nop
    bra pre_search_for_black_loop
search_for_black_south_west:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 65535   ; X=-1
    ldi r10, 1      ; Y=1
    nop
    bra pre_search_for_black_loop
search_for_black_north_east:
    ; Ladda SÖKNINGSVEKTOR ; LOVISA HAR ÄNDRAT SAKER WAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH
    ldi r9, 1       ; X=1
    ldi r10, 0
    nop
    subi r10, r10, 1
    ;ldi r10, 65535  ; Y=-1
    nop
    bra pre_search_for_black_loop
search_for_black_north_west:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 65535   ; X=-1
    ldi r10, 65535  ; Y=-1
pre_search_for_black_loop:
    ; Kopiera CURSOR till SÖKARE
    ldi r7, 0
    ldi r8, 0
    add r7, r7, r4
    add r8, r8, r5
search_for_black_loop:
    ; Stega SÖKARE med SÖKNINGSVEKTOR
    add r7, r7, r9  
    add r8, r8, r10
    ; Beräkna adress/index för brickan vi undersöker
    ldi r11, 0          ; Temp för index
    nop
    add r11, r11, r8
    nop
    addi r11, r11, 3
    nop
    muli r11, r11, 20
    nop
    add r11, r11, r7
    nop
    addi r11, r11, 6
    nop
    ; Ladda brickvärdet av brickan vi undersöker
    ld r12, r11 
    nop
    ; Undersök vilken bricka det är:
    cmpi r12, 3         ; Är det en svart bricka
    nop
    beq search_for_black_loop     ; Fortsätt leta
    cmpi r12, 2         ; Är det en vit bricka
    nop 
    beq flip_for_white  ; Vänd brickorna
    nop
    bra end_place_white
    nop
flip_for_white:
    cmp r7, r4
    nop
    bne loop_flip_for_white
    cmp r8, r5
    nop
    bne loop_flip_for_white
    ; Nu har vi flippat för ett väderstreck; sök andra riktningar!
    nop
    addi r13, r13, 1
    nop
    bra search_for_black
loop_flip_for_white:
    ; Stega SÖKARE BAKÅT med SÖKNINGSVEKTOR
    sub r7, r7, r9  
    sub r8, r8, r10
    ; Beräkna adress/index för brickan vi ska vända
    ldi r11, 0          ; Temp för index
    nop
    add r11, r11, r8
    nop
    addi r11, r11, 2
    nop
    muli r11, r11, 20
    nop
    add r11, r11, r7
    nop
    addi r11, r11, 6
    nop
    ; Skriv över den vita brickan med en svart bricka
    sto r6, r11
    nop
    bra flip_for_white
end_place_white:
    nop
    ldi r6, 2
    nop
    CLI
    bra move_cursor_home