import sys
from parser import parse_line
from instruction_enum import *

"""
--------------------------------------------------------------
Kompilator som ska parsa Assembly-koden till Maskinkod.
Den bör ej vara case-sensitive. Maskinkoden ska sedan läggas in 
i minnet som definieras i 'kod/hardware/DM/dm.vhd'.

Exempelanvändning i terminalen:
- python3 compiler.py othello_prog.asm othello_maskinkod.txt -debug
--------------------------------------------------------------
"""
def compile():

    # ----- Läs terminalargument ----

    filnamn_input = sys.argv[1]
    filnamn_output = sys.argv[2]
    print("\n----- Kompilerar... ------\n")

    # ----- Läs in -----

    print("* Läser in fil", filnamn_input + "...")

    with open(filnamn_input, 'r') as infile:
        innehall = [rad.strip() for rad in infile.readlines()]
    
    print("- Lyckat!")

    # ----- Parsa ----- 

    print("* Parsar...")
    if debugMode:
        print()
    asm_parsed = []
    rad_counter = 0
    pm_counter = 0
    jump_dict = {}

    for rad in innehall:
        try:
            parsed_line = parse_line(rad)
            rad_counter += 1

        except Exception as e:
            print(f"\n! Ett fel inträffade i {filnamn_input} på rad {rad_counter+1}") 
            print(f"! {e}")
            print(f"! ''{rad}''\n")
            print("----- Misslyckades kompilera. ------\n")
            return
        
        else:
            if parsed_line == None:
                continue                
            elif parsed_line[0] != "label":
                asm_parsed.append(parsed_line)
                if debugMode: 
                    print(f"#{pm_counter}\t{parsed_line}")
                pm_counter += 1
            elif parsed_line[0] == "label":
                jump_dict[parsed_line[2]] = pm_counter 

    if debugMode: 
        print(f"\nHopp-tabellen blev: \n {jump_dict}\n")

    print("- Lyckat!")

    # ----- Generera maskinkod -----

    print("* Översätter till maskinkod...")
    if debugMode:
        print()
    pm_counter = 0
    machine_code = []

    for rad in asm_parsed:
        binary_line = translateToBinary(rad, jump_dict)
        machine_code.append(binary_line)
        if debugMode: 
            print(f"# {pm_counter}\t{binary_line}")
        pm_counter += 1

    if debugMode:
        print()
        
    print("- Lyckat!")

    # ----- Skriv till fil -----

    if not debugMode:
        print("* Skriver till fil", filnamn_output+"...")
        with open(filnamn_output, 'w') as outfile:
            for rad in machine_code:
                outfile.write("\"" + rad + "\",\n")
        print("- Lyckat!")
    else:
        print("Skriver INTE till någon fil eftersom detta är debug-mode.")

    print("\n----- Lyckades kompilera! -----\n")



"""
--------------------------------------------------------------
Ska baserat på den parsade raden översätta till 1 och 0.

Parsed_line är på formatet (instr_name, instr_type, operands)
dvs: Enum Operation, Enum Instruction_type, List[Strings]
--------------------------------------------------------------
"""
def translateToBinary(parsed_line, jump_dict):
    
    instr_name = parsed_line[0] # Detta ska vara en enum
    instr_type = parsed_line[1] # Detta ska vara en enum
    operands = parsed_line[2]   # Detta ska vara en list av str
    
    if debugMode:
        binary_line = "----####----####----####----####"
    else:
        binary_line = '0'*32

    binary_line = opcode_table[instr_name] + binary_line[5:]
    
    nr_written_regs = 0

    ignoreFirst = (instr_name == Operation.sto or instr_name == Operation.stoi or \
                   instr_name == Operation.cmp or instr_name == Operation.cmpi) 

    ignoreSecond = (instr_name == Operation.ld)

    ignoreNone = not (ignoreFirst or ignoreSecond)

    for operand in operands:
        
        isRegister = isinstance(operand, str) and (operand in VALID_REGISTERS)

        #"""

        if isRegister and ignoreFirst and nr_written_regs == 0:
            binary_line = binary_line[:9] + register_table[operand] + binary_line[13:]
            nr_written_regs += 1
        elif isRegister and ignoreFirst and nr_written_regs == 1:
            binary_line = binary_line[:13] + register_table[operand] + binary_line[17:]
            nr_written_regs += 1 
        elif isRegister and ignoreSecond and nr_written_regs == 0:
            binary_line = binary_line[:5] + register_table[operand] + binary_line[9:]
            nr_written_regs += 1
        elif isRegister and ignoreSecond and nr_written_regs == 1:
            binary_line = binary_line[:13] + register_table[operand] + binary_line[17:]
            nr_written_regs += 1 
        elif isRegister and ignoreNone and nr_written_regs == 0:
            binary_line = binary_line[:5] + register_table[operand] + binary_line[9:]
            nr_written_regs += 1
        elif isRegister and ignoreNone and nr_written_regs == 1:
            binary_line = binary_line[:9] + register_table[operand] + binary_line[13:]
            nr_written_regs += 1
        elif isRegister and ignoreNone and nr_written_regs == 2:
            binary_line = binary_line[:13] + register_table[operand] + binary_line[17:]
            nr_written_regs += 1 
        elif isinstance(operand, int):
            kValue = operand
            binary_line = binary_line[:16] + f"{kValue:016b}"
        elif isinstance(operand, str):
            kValue = jump_dict[operand]
            binary_line = binary_line[:16] + f"{kValue:016b}"
        else:
            raise ValueError(f"Lyckades ej översätta {parsed_line} till maskinkod.") 
        #"""

    if (len(binary_line) != 32):
        raise ValueError(f"Lyckades ej översätta {parsed_line} till maskinkod.") 
    else:
        return binary_line 

# ----- Kör main-funktionen
if len(sys.argv)==4:
    if sys.argv[3] == "-debug" or sys.argv[3] == "-d":
        debugMode = True
    else:
        debugMode = False
else:
    debugMode = False

compile()