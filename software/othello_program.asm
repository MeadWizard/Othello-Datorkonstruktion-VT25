;
; OTHELLO-PROGRAMMET:
; 
; Förklaring av registeranvändning:
; r1 - Index för CURSOR
; r2 - Rutvärdet som ligger under CURSOR
; r3 - Konstant 4
; r4 - X-KOORDINAT cursor 
; r5 - Y-KOORDINAT cursor
; r6 - Brick-värdet av den spelare vars tur det är.
; (skiftar mellan 2 och 3 för varje enterslag)
; r7 - X-KOORDINAT sökare
; r8 - Y-KOORDINAT sökare
; r9 - X-KOORDINAT sökvektor/DIRECTION X
; r10 - Y-KOORDINAT sökvektor/DIRECTION Y
; r11 - Index för SÖKARE
; r12 - Brickvärdet av brickan vi undersöker
; r13 - Antalet sökriktningar vi har kollat

; -----------------------------------------------------------------------------
; Initialisera programmet.
; -----------------------------------------------------------------------------
INIT:
    ldi r2, 1   ; Jag vet inte varför detta behövs
    ldi r6, 2   ; Vit börjar alltid spela

; -----------------------------------------------------------------------------
; Flytta tillbaka Cursor till startläget dvs (0,0) eller index 66 i DM.
; -----------------------------------------------------------------------------
move_cursor_home:
    ; Använder r3
    ldi r1, 66 ; cursor position
    nop
    ld r2, r1    
    nop
    ldi r3, 4
    nop
    sto r3, r1 
    ldi r4, 0 ; X KOORDINAT
    ldi r5, 0 ; Y KOORDINAT

; -----------------------------------------------------------------------------
; Program-loop: Kolla om det har skett en tangenttryckning.
; -----------------------------------------------------------------------------
main_loop:
    nop            ; om det blir en keyboard_interrupt
    brie interrupt ; gå till interrupt-submodul-grej
    bra main_loop  ; annars loopa vidare

; -----------------------------------------------------------------------------
; Interrupt-kontroll: Kolla vilken interrupt som har skett.
; -----------------------------------------------------------------------------
interrupt:
    cmpi r15, 29        ; om tangenttryckning är 'w'
    nop
    beq move_cursor_up
    cmpi r15, 27        ; om tangenttryckning är 's'
    nop
    beq move_cursor_down
    cmpi r15, 35        ; om tangenttryckning är 'd'
    nop
    beq move_cursor_right
    cmpi r15, 28        ; om tangenttryckning är 'a'
    nop
    beq move_cursor_left
    cmpi r15, 90   ; om tangenttryckning är "enter"
    nop
    beq place_tile
    cmpi r15, 22        ; om tangenttryckning är '1'
    nop
    beq place_white
    cmpi r15, 30        ; om tangenttryckning är '2'
    nop
    beq place_black      
    CLI                 ; okänd tangenttryckning
    nop
    bra main_loop       

; -----------------------------------------------------------------------------
; MOVE CURSOR
; -----------------------------------------------------------------------------
move_cursor_up:
    subi r5, r5, 1      ; ändra Y-värde av cursor
    sto r2, r1          ; skriv tillbaka gammal rutas värde i r2
    nop
    subi r1, r1, 20     ; nytt index för cursor, lägg i r1
    bra move_cursor_exit
move_cursor_down:
    addi r5, r5, 1      ; ändra Y-värde av cursor
    sto r2, r1          ; skriv tillbaka gammal rutas värde i r2
    nop
    addi r1, r1, 20     ; nytt index för cursor, lägg i r1
    bra move_cursor_exit
move_cursor_left:
    subi r4, r4, 1      ; ändra X-värde av cursor
    sto r2, r1          ; skriv tillbaka gammal rutas värde i r2
    nop
    subi r1, r1, 1      ; nytt index för cursor, lägg i r1
    bra move_cursor_exit
move_cursor_right:
    addi r4, r4, 1      ; ändra X-värde av cursor
    sto r2, r1          ; skriv tillbaka gammal rutas värde i r2
    nop
    addi r1, r1, 1      ; nytt index för cursor, lägg i r1
move_cursor_exit:
    nop
    ld r2, r1           ; spara nya rutas värde i r2
    nop
    ldi r3, 4           ; spara char-värdet för cursor i r3
    nop
    sto r3, r1          ; ersätt med cursor-värdet där nya rutan låg  
    CLI
    nop
    bra main_loop

; -----------------------------------------------------------------------------
; PLACE TILE
; -----------------------------------------------------------------------------
place_tile:
    cmpi r6, 2
    nop
    beq place_white
    cmpi r6, 3
    nop
    beq place_black
    nop
    CLI
    bra move_cursor_home 

; -----------------------------------------------------------------------------
; PLACE WHITE TILE
; -----------------------------------------------------------------------------
place_white:
    nop
    sto r2, r1
    nop
    ldi r13, 0
    nop
search_for_black:
    nop
    addi r13, r13, 1
    nop
    cmpi r13, 1
    nop
    beq search_for_black_south
    cmpi r13, 2
    nop
    beq search_for_black_north
    cmpi r13, 3
    nop
    beq search_for_black_east
    cmpi r13, 4
    nop
    beq search_for_black_west
    cmpi r13, 5
    nop
    beq search_for_black_south_east
    cmpi r13, 6
    nop
    beq search_for_black_south_west
    cmpi r13, 7
    nop
    beq search_for_black_north_east
    cmpi r13, 8
    nop
    beq search_for_black_north_west
    nop
    bra end_place_white 
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
    ; Ladda SÖKNINGSVEKTOR 
    ldi r9, 1       ; X=1
    ldi r10, 65535  ; Y=-1
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
    bra search_for_black
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
    addi r11, r11, 3
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
    ldi r6, 3
    nop
    CLI
    bra move_cursor_home

; -----------------------------------------------------------------------------
; PLACE BLACK TILE
; -----------------------------------------------------------------------------
place_black:
    nop
    sto r2, r1
    nop
    ldi r13, 0
    nop
search_for_white:
    nop
    addi r13, r13, 1
    nop
    cmpi r13, 1
    nop
    beq search_for_white_south
    cmpi r13, 2
    nop
    beq search_for_white_north
    cmpi r13, 3
    nop
    beq search_for_white_east
    cmpi r13, 4
    nop
    beq search_for_white_west
    cmpi r13, 5
    nop
    beq search_for_white_south_east
    cmpi r13, 6
    nop
    beq search_for_white_south_west
    cmpi r13, 7
    nop
    beq search_for_white_north_east
    cmpi r13, 8
    nop
    beq search_for_white_north_west
    nop
    bra end_place_black 
    nop
search_for_white_south:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 0       ; X=0
    ldi r10, 1      ; Y=1
    nop
    bra pre_search_for_white_loop
search_for_white_north:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 0       ; X=0
    ldi r10, 65535  ; Y=-1
    nop
    bra pre_search_for_white_loop
search_for_white_east:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 1       ; X=1
    ldi r10, 0      ; Y=0
    nop
    bra pre_search_for_white_loop
search_for_white_west:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 65535   ; X=-1
    ldi r10, 0      ; Y=0
    nop
    bra pre_search_for_white_loop
search_for_white_south_east:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 1       ; X=1
    ldi r10, 1      ; Y=1
    nop
    bra pre_search_for_white_loop
search_for_white_south_west:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 65535   ; X=-1
    ldi r10, 1      ; Y=1
    nop
    bra pre_search_for_white_loop
search_for_white_north_east:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 1       ; X=1
    ldi r10, 65535  ; Y=-1
    nop
    bra pre_search_for_white_loop
search_for_white_north_west:
    ; Ladda SÖKNINGSVEKTOR
    ldi r9, 65535   ; X=-1
    ldi r10, 65535  ; Y=-1
pre_search_for_white_loop:
    ; Kopiera CURSOR till SÖKARE
    ldi r7, 0
    ldi r8, 0
    add r7, r7, r4
    add r8, r8, r5
search_for_white_loop:
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
    cmpi r12, 2         ; Är det en vit bricka
    nop
    beq search_for_white_loop     ; Fortsätt leta
    cmpi r12, 3         ; Är det en svart bricka
    nop 
    beq flip_for_black  ; Vänd brickorna
    nop
    bra search_for_white
    nop
flip_for_black:
    cmp r7, r4
    nop
    bne loop_flip_for_black
    cmp r8, r5
    nop
    bne loop_flip_for_black
    ; Nu har vi flippat för ett väderstreck; sök andra riktningar!
    nop
    bra search_for_white
loop_flip_for_black:
    ; Stega SÖKARE BAKÅT med SÖKNINGSVEKTOR
    sub r7, r7, r9  
    sub r8, r8, r10
    ; Beräkna adress/index för brickan vi ska vända
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
    ; Skriv över den vita brickan med en svart bricka
    sto r6, r11
    nop
    bra flip_for_black
end_place_black:
    nop
    ldi r6, 2
    nop
    CLI
    bra move_cursor_home