%include "utils.nasm"
section .data
    V dw [5,-3,8,4,0,-18,14,5]
    n equ ($-V)/2

section .bss
    ind resd 1

section .text
    extern proc
    global _start
_start:
    ;caricamento parametri
    push ind
    push n
    push V
    call proc ;chiamata funzione
    printd dword[ind]
esci: ;NON SERVE?
    exit 0

section .data
    V equ 8
    n equ 12
    i equ 16

section .text
    global proc
proc:
    push EBP
    mov EBP, ESP
    pushad
    ;lettura parametri
    mov ESI, [EBP + n]
    mov EBX, [EBP + V]
    ;somma elementi di V
    xor AX, AX ;AX=0 per valore somma totale
    xor EDI, EDI ;i=0

ciclo_somma:
    cmp EDI, ESI
    jge avanti
    add AX, [EBX + EDI*2] ;AX=AX+V[EDI]. Si usa EDI*2 perché ogni elemento è una word (2 byte)
    inc EDI
    jmp ciclo_somma
;calcolo AX*2/3 (obiettivo)
avanti:
    shl AX, 1 ;Shift Left di 1 bit equivale a *2 quindi moltiplica AX per 2, ora AX=AX*2
    mov CX, 3 ;prepara il divisore (=3) in CX
    cwd ;Convert Word to Doubleword: estende il segno di AX in DX, per una divisione corretta
    div CX ;divide DX:AX (due registri da 16-bit affiancati per formare il numero segno:somma*2) per CX (=3)
    cmp DX, 0 ;se è multiplo di 3
    jne non_trovato ;se non è un multiplo di 3 allora non può esistere
    xor CX, CX ;CX=0 per valore somma corrente
    xor EDI, EDI ;i=0
;ricerca dell'indice
ciclo:
    cmp EDI, ESI
    jge non_trovato
    add CX, [EBX + EDI*2]
    cmp CX, AX
    je fine_ciclo 
    inc EDI
    jmp ciclo
non_trovato:
    mov EDI, -1
fine_ciclo:
    mov ECX, [EBP + ind] ;carica in ECX l'indirizzo della variabile 'i' passato come parametro 
    mov [ECX], EDI ;scrive il valore di EDI (l'indice trovato o -1) in quell'indirizzo di memoria
esci:
    popad ;repristina i registri salvati
    pop EBP ;repristina il base pointer EBP
    ret 12 ;ritorna al chiamante pulendo 12 byte dallo stack (i 3 parametri pushati)