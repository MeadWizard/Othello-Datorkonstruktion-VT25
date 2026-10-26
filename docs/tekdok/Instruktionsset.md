# Instruktionsset (Eget assembly-språk)

OBS: kolumnen med flaggor som påverkas stämmer ej!

32-bit-ordet kan ha flera olika format: 
* Opcode 5, rR 4, rA 4, rB 4, k 15.
* Opcode 5, rR 4, rA 4, -  3, k 16.
* Opcode 5, rR 4,       -  7, k 16.
* Opcode 5, -  4, rA 4, -  3, k 16.
* Opcode 5,             - 11, k 16.
* Opcode 5,             - 27      .       

#### Data-förflyttning:

|OpKod | Förkortning | Operander        | Förklaring                                               | Flaggor | Format         | Exempel          |
|------|-------------|------------------|----------------------------------------------------------|---------|----------------|------------------|
| x00  | NOP         | Inga             | Gör inget / Vänta                                        | Inga    | 5-(27)         | "nop"            | 
| x01  | LD          | rA, rB           | Ladda till rA värdet på plats rB                         | Inga    | 5-4-(7)-16     | "ld rR, k"       |
| x11  | LDi         | rA, K            | Ladda till rA värdet K                                   | Inga    | 5-4-(7)-16     | "ldi rR, K"      |
| x02  | STO         | rA, rB           | Lagras värdet i rA på plats rB i DM                      | Inga    | 5-4-(7)-16     | "sto rA, rB"     |
| x12  | STOi        | rA, k            | Lagras värdet i rA på plats k i DM                       | Inga    | 5-4-(7)-16     | "stoi rA, k"     |

#### Aritmetik:

|OpKod | Förkortning | Operander        | Förklaring                                               | Flaggor | Format         | Exempel          |
|------|-------------|------------------|----------------------------------------------------------|---------|----------------|------------------|
| x03  | ADD         | rR, rA, rB       | Spara i rR summan av rA & rB                             | Z,N,C,V | 5-4-4-4-(15)   | "add rR, rA, rB" |
| x13  | ADDi        | rR, rA, K        | Spara i rR summan av rA & K                              | Z,N,C,V | 5-4-4-(3)-16   | "addi rR, rA, K" |
| x04  | SUB         | rR, rA, rB       | Spara i rR differensen av rA & rB                        | Z,N,C,V | 5-4-4-4-(15)   | "sub rR, rA, rB" |
| x14  | SUBi        | rR, rA, K        | Spara i rR differensen av rA & K                         | Z,N,C,V | 5-4-4-(3)-16   | "subi rR, rA, K" |
| x05  | MUL         | rR, rA, rB       | Spara i rR produkten av rA & rB                          | Z,N,C,V | 5-4-4-4-(15)   | "mul rR, rA, rB" |
| x15  | MULi        | rR, rA, K        | Spara i rR produkten av rA & K                           | Z,N,C,V | 5-4-4-(3)-16   | "muli rR, rA, K" |

#### Bit-operationer:

|OpKod | Förkortning | Operander        | Förklaring                                               | Flaggor | Format         | Exempel          |
|------|-------------|------------------|----------------------------------------------------------|---------|----------------|------------------|
| x06  | LSR         | rR, rA, rB       | Spara i rR bitresultatet av att skifta rA,rB antal gånger| Z,N,C,V | 5-4-4-4-(15)   | "lsr rR, rA"     |
| x16  | LSRi        | rR, K            | Spara i rR bitresultatet av att skifta rA, K antal gånger| Z,N,C,V | 5-4-4-(3)-16   | "lsri rR, rA, K" |
| x07  | AND         | rR, rA, rB       | Spara i rR bitresultatet av rA 'and' rB                  | Z,N,C,V | 5-4-4-4-(15)   | "and rR, rA, rB" |
| x17  | ANDi        | rR, rA, K        | Spara i rR bitresultatet av rA 'and' K                   | Z,N,C,V | 5-4-4-(3)-16   | "andi rR, rA, K" |
| x08  | OR          | rR, rA, rB       | Spara i rR bitresultatet av rA 'or' rB                   | Z,N,C,V | 5-4-4-4-(15)   | "or rR, rA, rB"  |
| x18  | ORi         | rR, rA, K        | Spara i rR bitresultatet av rA 'or' K                    | Z,N,C,V | 5-4-4-(3)-16   | "ori rR, rA, K"  |
| x09  | NOT         | rR, rA           | Spara i rR bitresultatet av att inverta rA               | Z,N,C,V | 5-4-4-(19)     | "not rR, rA"     |
| x19  | NOTi        | rR, K            | Spara i rR inverteringen av bitarna talet K representerar| Z,N,C,V | 5-4-(7)-16     | "noti rR, K"     |

#### Kontrollflöde:

|OpKod | Förkortning | Operander        | Förklaring                                               | Flaggor | Format         | Exempel          |
|------|-------------|------------------|----------------------------------------------------------|---------|----------------|------------------|
| x0A  | CMP         | rA, rB           | Samma som sub fast spara inte resultatet                 | Inga    | 5-(4)-4-4-(15) | "cmp rA, rB"     |
| x1A  | CMPi        | rA, K            | Samma som subi fast spara inte resultatet                | Inga    | 5-(4)-4-(3)-16 | "cmpi rA, K"     |
| x0B  | BEQ / JEQ   | K                | Hoppa till rad K i PM om resultatet var noll             | Inga    | 5-(11)-16      | "beq K"          |
| x0C  | BNE / JNE   | K                | Hoppa till rad K i PM om resultatet INTE var noll        | Inga    | 5-(11)-16      | "bne K"          |
| x0D  | BRA / JMP   | K                | Hoppa till rad K i PM                                    | Inga    | 5-(11)-16      | "bra K"          |
| x0E  | BRIE        | K                | Hoppa till rad K i PM om I-flaggan är ettställd          | Inga    | 5-(11)-16      | "brie K"         |
| x0F  | CLI         | -                | Nollställ I-flaggan                                      | I       | 5-(27)         | "cli"            |
