%include 'utils.nasm'

section .data
    V dw            ;input array of word 16_bit values
    n equ ($-V)/2   ;num of elements of V

section .bss
    W1 resw n       ;reserves space for W1
    W2 resw n

section .text
    extern proc
    global _start
    
_start:             ;elements are pushed right to left
    push W2
    push W1
    push n 
    push V
    call proc       ;calls procedure

    xor EDI, EDI                    ;EDI=0
ciclo_w1:                           ;prints W1 elements
    cmp EDI, n                      ;compares EDI with n
    jge avanti                      ;jumps to avanti if greater or equal
    printw word [W1 + EDI*2]        ;gets the address of the EDI-th word in array W1
    inc EDI                         ;increments EDI
    jmp ciclo_w1                    
avanti:
    xor EDI, EDI

ciclo_w2:
    cmp EDI, n
    jge esci
    printw word [W2 + EDI*2]
    inc EDI
    jmp ciclo_w2
esci:
    exit 0

;PROCEDURA
section .data
    V equ 8
    n equ 12
    W1 equ 16
    W2 equ 20

section .text
    global proc
proc:                   ;standard stack frame
    push EBP            ;EBP marks the base
    mov EBP, ESP
    pushad              ;saves all general-purpose registers

    ;LETTURA PARAMETRI
    mov ESI, [EBP + n]      ;ESI=n (length)
    mov EAX, [EBP + V]      ;ESI=V (input vector)
    mov EBX, [EBP + W1]     ;address of output W1
    mov ECX, [EBP + W2]     ;output

;INIZIALIZZAZIONE DI W1 E W2
    xor EDI, EDI
ciclo_init:                 ;this loop initializes both output arrays to 0
    cmp EDI, ESI
    jge avanti
    mov [EBX + EDI*2], word 0
    mov [ECX + EDI*2], word 0
    inc EDI
    jmp ciclo_init

avanti:                     ;we trynna fill W1 and W2
    xor EDI, EDI
ciclo:
    cmp EDI, ESI
    jge esci
    mov DX, [EAX + EDI*2]   ;DX=V[EDI]
    cmp DX, 0
    jl negativo             ;if V[EDI]<0, go to negativo
    mov [EBX], DX           ;W1[current]=DX
    add EBX, 2              ;move W1 pointer forward
    inc EDI
    jmp ciclo

negativo:                   ;stores negative values in W2
    mov [ECX], DX
    add ECX, 2
    inc EDI
    jmp ciclo

esci:
    popad                   ;restores saved registers
    pop EBP                 ;restores base pointer
    ret 16                  ;returns and cleans 12 bytes (the 4 arguments)

