from instruction_enum import *
#from asm_enum import instruction_table, VALID_REGISTERS

"""
Har ansvar för att tolka textrader från en assembly-fil (.asm).

T.ex: "add r1, r2, r3" och omvandla dem till ett internt format 
som kodgeneratorn kan använda

#1, läs in en rad
#2, dela upp raden i tokens
#3, kolla upp operation och instruktionstyp
#4, verifiera antal och typ av argument
#5, skapa en intern instruktion som kan skickas till kodgeneratorn

RETURNERAR: (instr_name, instr_type, operands)
dvs: Enum Operation, Enum Instruction_type, List[Strings]

"""

def parse_line(line):

    # Strunta i tomma rader
    if not line:
        return None

    # Ta bort kommatecken
    line = line.replace(",", "")

    # Ta bort stora bokstäver
    line = line.lower()

    # Ta bort kommentarer
    for char in line:
        if char == ";":
            line = line[0:line.index(char)]
            if not line:
                return None
            break

    # Upptäck labels
    for char in line:
        if char == ":":
            return ("label", None, line[0:line.index(char)])
    
    # Skapa tokens
    tokens = line.split()
    #print(tokens)
    instr_name = tokens[0]
    operands = tokens[1:]

    # ----- Felhantering -----

    # Om det inte är en giltig operation kasta fel
    if instr_name not in instruction_table:
        raise ValueError(f"Okänd instruktion: {instr_name}")

    # Hämta information om instruktion, två enums
    operation, instr_type = instruction_table[instr_name]

    # Hämta antal förvantade operander
    expected = nr_expected_operands[instr_type.name]

    # Om det är fel antal operander kasta fel
    if len(operands) != expected:
        raise ValueError(f"Fel antal operander för {instr_name}: {len(operands)} (förväntade {expected})")

    # ----- Kolla operandtyper baserat på instruktionstyp -----

    # Inga operander
    if instr_type == InstructionType.reg:
        if operands[0]:
            raise ValueError(f"Överflödig operand: {operands[0]}")

    # 1 register
    if instr_type == InstructionType.reg:
        if operands[0] not in VALID_REGISTERS:
            raise ValueError(f"Ogiltigt register: {operands[0]}")
    
    # 2 register
    elif instr_type == InstructionType.reg_reg:
        if operands[0] not in VALID_REGISTERS\
        or operands[1] not in VALID_REGISTERS:
            raise ValueError(f"Ogiltigt register: {operands}")

    # 3 register
    elif instr_type == InstructionType.reg_reg_reg: 
        if operands[0] not in VALID_REGISTERS\
        or operands[1] not in VALID_REGISTERS\
        or operands[2] not in VALID_REGISTERS:
            raise ValueError(f"Ogiltigt register: {operands}")
    
    # 1 register, 1 konstant
    elif instr_type == InstructionType.reg_i: 
        if operands[0] not in VALID_REGISTERS:
            raise ValueError(f"Ogiltigt register: {operands[0]}")
        try: 
            integer = int(operands[1])
        except:
            raise ValueError(f"Ogiltig konstant: {operands[1]}")
        else:
            operands[1] = int(operands[1])
    
    # 2 register, 1 konstant
    elif instr_type == InstructionType.reg_reg_i:
        if operands[0] not in VALID_REGISTERS\
        or operands[1] not in VALID_REGISTERS:
            raise ValueError(f"Ogiltigt register: {operands[:1]}")
        try: 
            integer = int(operands[2])
        except:
            raise ValueError(f"Ogiltig konstant: {operands[2]}")
        else:
            operands[2] = int(operands[2])
    
    # 1 label eller typ konstant
    elif instr_type == InstructionType.label:
        # En label får inte börja med en siffra? idk allt kan väl typ vara en label.
        if not operands[0][0].islower():
            raise ValueError(f"Ogiltig label: {operands[0]}")

    # ----- -----

    # Returnerar instruktionsnamn samt listan av operander
    return (operation, instr_type, operands)