
# TSEA83 VT 2025, Grupp 36 - Othello

Grupp 36 består av:
Lovisa Bogeklint.
Ivar Lenner,
Embla Olin och
Frida Strömberg 


Examinator: Anders Nilsson 

Handledare: Theodor Lindberg

## Sammanfattning
Detta är en del av ett projekt i kursen TSEA83 där vi konstruerar en processor som är anpassad för att spela Othello. Processorn består av en 2-stegs pipeline och är uppdelat i program och dataminne, vilket möjliggör parallell åtkomst till både instruktioner och data. Hårdvaran inkluderar specifika enheter som är ansvariga för olika uppgifter, bland annat som att hantera beräkningar och minnesoperationer. Varje enhet i processorn har specifika ansvarsområden, och användningen av ett uppdelat minne för program påverkar designen. Processorn arbetar med 16-bitars ord och programmet lagras i ett ROM som kommer kunna exekveras direkt vid start. 

Inmatningen sker via ett tangentbord, och grafiken hanteras via en VGA-skärm som uppdateras vid varje spelardrag. Vissa utmaningar, såsom pipeline-hantering och eventuell avsaknad av dataforwarding kommer kräva särskild uppmärksamhet i konstruktionen.  

## Struktur

Projektet producerar tre delar:

- Dokumentationsdelen - (Kravspecifikation, Designspecifikation & Teknisk Dokumentation)
- Hårdvarudelen - (Datorkonstruktionen: Design och Testbänkar skrivna i VHDL)
- Mjukvarudelen - (Den uppkommna koden i det egna assembly-språket framtaget)

## Blockdiagram för hårdvara

![Block diagram](Pipelinead_dator_detalj_2.0.png "Block Diagram") 

