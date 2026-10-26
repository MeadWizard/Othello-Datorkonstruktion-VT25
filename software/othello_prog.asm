; ----- ASSEMBLY-KODSKELETT -----
; Det här är koden som ska sedan kompileras. ASSEMBLY -> ETT & NOLL (PM)

startup:
    ;initiera brädet

main_loop:
    ;om det blir en keyboard_interrupt
    ;gå till interrupt-submodul-grej

interupt:
    ;om tangenttryckning är 'w'
    ;om tangenttryckning är 'a'
    ;om tangenttryckning är 's'
    ;om tangenttryckning är 'd'
    ;om tangenttryckning är 'esc'
    ;om tangenttryckning är 'enter'   

;
; tsea83 assembler.asm
;
; Created: 2025-05-05 11:17:31
; Author : embol439
;


; Översättning i hur jag tänker det kommer se ut i register form ish
; R1 = y
; R2 = x
; R3 = temp / index
; R4 = adress
; R5 = START_Y (3)
; R6 = START_X (6)
; R7 = VR_WIDTH (20)
; R8 = EMPTY_BOX (1)
; R9 = Video_ram basadress
; R10 = Konstant 8
; R11 = Konstant för poäng (typ en mellanlagring kan man väl säga)

; Initialiserar konstanterna
ldi R5, 3 ;START_Y
ldi R6, 6 ;START_X
ldi R7, 20 ;VR_WIDTH
ldi R8, 1 ;EMPTY_BOX
ldi R9, 0 ;Video_ram basadress
ldi R10, 8 ;KOnstanten 8

; Initialiserar startläget för board med startbrickor
ldi R1, 0 ;start för y = 0
loop_y:
cmp R1, R10
beq end_y

ldi R2, 0 ;start för x = 0
loop_x: 
cmp R2, R10
beq end_x

; R3 - (y + START_Y) * VR_WIDTH
add R3, R1, R5
muli R3, R3, 20

; R4 - (x + START_X)
add R4, R2, R6

; R4 - index = R3 + R4
add R4, R3, R4
add R4, R4, R9

; video_ram(index) = EMPTY_BOX
; sto R8, R4

addi R2, R2, 1
bra loop_x
end_x:
addi R1, R1, 1
bra loop_y
end_y:

;-----------------------------------------------------------------------
; Placerar ut brickor och vi bara lagrar dem direkt
; Antar att R1 = y, R2 = x och R8 = färg
; Vi använder R3-R4

place_piece:
; R3 = (y + START_Y) * VR_WIDTH
add R3, R1, R5
muli R3, R3, 20

; R4 (x + START_X)
add R4, R2, R6

; index = R3 + R4 + R9
add R4, R3, R4
add R4, R4, R9

; video_ram index = color
; sto R8, R4
; ret