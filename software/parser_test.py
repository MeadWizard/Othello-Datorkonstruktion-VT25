from parser import parse_line

# Rader som inte ska kasta fel
lines_lyckas = [

    "nop",
    "ld r7, 12",
    "ldi r5, 13",
    "sto r7, 13",

    "add r1, r2, r3",
    "addi r1, r2, 52",
    "sub r4, r5, r1",
    "subi r14, r1, 17",
    "mul r1, r2, r1",
    "dethärärenlabel: ; kommentar",
    "muli r1, r2, 5 ; kommentar",

    "aDd r1, r2, R3",
    "aDDi r1, r2, 52",
    "sUb r4, r5, r1",
    "subi r14, R1, 17",
    "mUl R1, R2, r1"
]

# Rader som ska misslyckas dvs
lines_misslyckas = [
    "store r1, 15",
    "push r0", 
    "pull r1, r2", 
    "subi r1, r15, r1", 
    "load r0, 12"
]

print("\n----- Testar instruktionsuppsättningen... -----\n")

for line in lines_lyckas:
    result = parse_line(line)
    print(line, "parsade LYCKAT till", result ,". \n")

print("----- Testar felhantering... -----\n")

for line in lines_misslyckas:
    try:
        result = parse_line(line)
    except ValueError:
        print(line, "kastade LYCKAT fel. \n")
    else:
        print(line, "kastade INTE fel. womp womp \n")

print("----- Testande klart! -----\n")
