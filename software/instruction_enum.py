from enum import Enum

######### här definierar vi vilka olika typer av instruktioner som finns baserat på deras indata, så att vi vet
######### hur många av de följande tokens som är viktiga, det är INGET PROBLEM att SFNEI rA, I ser ut på formen "0x2f - A I" (se sida 17 lab_pipe)
######### eftersom vi kommer under första delen (opcode, 0x2f) berätta att det är SFNEI och då kommer programminnet förstå att de kommande 5 bitarna är irrelevanta

class InstructionType(Enum):
    no_op = 0
    reg = 1
    reg_reg = 2
    reg_reg_reg = 3
    reg_i = 4
    reg_reg_i = 5
    label = 6

    # Dessa är överflödiga
    # mem_load = 6
    # mem_store = 7

    # Dessa är samma som label
    # jump = 8
    # branch = 9

class Operation(Enum):
    nop = 0
    ld = 1
    ldi = 17
    sto = 2
    stoi = 18

    add = 3
    addi = 19
    sub = 4
    subi = 20
    mul = 5
    muli = 21
    
    lsr = 6
    lsri = 22
    And = 7 # Kan ej döpas till and
    andi = 23
    Or = 8 # Kan ej döpas till or
    ori = 24
    Not = 9 # Kan ej döpas till not 
    noti = 25
    
    cmp = 10
    cmpi = 26
    beq = 11
    bne = 12
    bra = 13
    brie = 14
    cli = 15 

## här nere ska en dictionary göras med namn på instruktionen och dess instruktionstyp, detta för att 
## rätt antal indata ska tas in och behandlas på korrekt sätt (ex. rätt antal 01010110)
## så få ut info om en instr. genom t.ex. ADD = InstructionType.reg_reg , Operation.add

instruction_table = {
    "nop": (Operation.nop, InstructionType.no_op),
    "ld": (Operation.ld, InstructionType.reg_reg), # osäker kring detta
    "ldi": (Operation.ldi, InstructionType.reg_i), # osäker kring detta
    "sto": (Operation.sto, InstructionType.reg_reg), # osäker kring detta
    "stoi": (Operation.stoi, InstructionType.reg_i), # osäker kring detta
    # vi kanske behöver ha fler mod för att kunna adressera minnet!!!!!

    "add": (Operation.add, InstructionType.reg_reg_reg),
    "addi":(Operation.addi, InstructionType.reg_reg_i),
    "sub": (Operation.sub, InstructionType.reg_reg_reg),
    "subi":(Operation.subi, InstructionType.reg_reg_i),
    "mul": (Operation.mul, InstructionType.reg_reg_reg),
    "muli":(Operation.muli, InstructionType.reg_reg_i),
    
    "lsr": (Operation.lsr, InstructionType.reg_reg_reg), # Hur gör vi med denna?
    "lsri":(Operation.lsri, InstructionType.reg_reg_i), # Ska man kunna skifta fler än 1 gång

    "and": (Operation.And, InstructionType.reg_reg_reg),
    "andi":(Operation.andi, InstructionType.reg_reg_i),
    "or":  (Operation.Or, InstructionType.reg_reg_reg),
    "ori": (Operation.ori, InstructionType.reg_reg_i),
    "not": (Operation.Not, InstructionType.reg_reg),
    "noti":(Operation.noti, InstructionType.reg_i),

    "cmp": (Operation.cmp, InstructionType.reg_reg), 
    "cmpi":(Operation.cmpi, InstructionType.reg_i), 
    "beq": (Operation.beq, InstructionType.label),
    "bne": (Operation.bne, InstructionType.label),
    "bra": (Operation.bra, InstructionType.label),
    "brie":(Operation.brie, InstructionType.label),
    "cli": (Operation.cli, InstructionType.no_op),
    }

nr_expected_operands = {
        "no_op": 0,
        "reg": 1,
        "reg_reg": 2,
        "reg_reg_reg": 3,
        "reg_i": 2,
        "reg_reg_i": 3,
        "label": 1,

        # Överflödiga
        # "mem_load": 2,
        # "mem_store": 2,
        
        # Samma som label
        # "jump": 1,
        # "branch": 1,
    }


opcode_table = { 
    Operation.nop: format(0x00, '05b'),
    Operation.ld: format(0x01, '05b'),
    Operation.ldi: format(0x11, '05b'),
    Operation.sto: format(0x02, '05b'),
    Operation.stoi: format(0x12, '05b'),
    
    Operation.add: format(0x03, '05b'),
    Operation.addi: format(0x13, '05b'),
    Operation.sub: format(0x04, '05b'),
    Operation.subi: format(0x14, '05b'),
    Operation.mul: format(0x05, '05b'),
    Operation.muli: format(0x15, '05b'),
    
    Operation.lsr: format(0x06, '05b'),
    Operation.lsri: format(0x16, '05b'),
    Operation.And: format(0x07, '05b'),
    Operation.andi: format(0x17, '05b'),
    Operation.Or: format(0x08, '05b'),
    Operation.ori: format(0x18, '05b'),
    Operation.Not: format(0x09, '05b'),
    Operation.noti: format(0x19, '05b'),
    
    Operation.cmp: format(0x0A, '05b'),
    Operation.cmpi: format(0x1A, '05b'),
    Operation.beq: format(0x0B, '05b'),
    Operation.bne: format(0x0C, '05b'),
    Operation.bra: format(0x0D, '05b'),
    Operation.brie: format(0x0E, '05b'),
    Operation.cli : format(0x0F, '05b')
}

register_table = { 
    "r1": format(0x1, '04b'),
    "r2": format(0x2, '04b'),
    "r3": format(0x3, '04b'),
    "r4": format(0x4, '04b'),
    "r5": format(0x5, '04b'),
    "r6": format(0x6, '04b'),
    "r7": format(0x7, '04b'),
    "r8": format(0x8, '04b'),
    "r9": format(0x9, '04b'),
    "r10": format(0xA, '04b'),
    "r11": format(0xB, '04b'),
    "r12": format(0xC, '04b'),
    "r13": format(0xD, '04b'),
    "r14": format(0xE, '04b'),
    "r15": format(0xF, '04b'),
}

# r1-r14 får användas, 
# r0 och r15 är reserverade för konstanten 0 samt keyboard
VALID_REGISTERS = [f"r{i}" for i in range (1, 16)] 