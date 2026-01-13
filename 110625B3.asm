%include 'utils.nasm'
section .data
    V dw ;dw 4, 3, -1, 6, 7, -8
    n equ ($-V)/2 ;equ 6
section .bss
    W1 resw n
    W2 resw n
section .text
    extern proc
    global _start
_start:
    push W2
    push W1
    push n
    push v
    call proc

xor EDI, EDI
ciclo_w1:
    cmp EDI, n
    jge avanti
    printw word [W1+EDI*2]
    inc EDI
    jmp ciclo_w1
avanti:
    xor EDI, EDI
ciclo_w2:
    cmp EDI, n
    jge esci
    printw word [W2+EDI*2]
    inc EDI
    jmp ciclo_w2
esci:
    exit 0

;section .data
;    n equ 8
;    V equ 12
;    W1 equ 16
;    W2 equ 20
section .text
    global proc
proc:
    push EBP
    mov EBP, ESP
    pushad
    mov ESI, [EBP+n]
    mov EAX, [EBP+V]
    mov EBX, [EBP+W1]
    mov ECX, [EBP+W2]

xor EDI, EDI
ciclo_init:
    cmp EDI, ESI
    jge continue
    mov [EBX, EDI*2], word 0
    mov [ECX, EDI*2], word 0
    inc EDI
    jmp ciclo_init
continue:
    xor EDI, EDI
ciclo:
    cmp EDI, ESI
    jge fine
    mov DX, [EAX+EDI*2] ;DX=V[EDI]
    test DX, 1 ;fa DX and 1, cioè confronta LSB (Least Significant Bit) con 1, se LSB[VX]=1 allora il numero in VX è dispari
    jnz dispari
    mov [EBX], DX
    add EBX, 2
    jmp avanti
dispari:
    mov [ECX], DX
    add ECX, 2
avanti:
    inc EDI
    jmp ciclo
fine:
    popad
    pop EBP
    ret 16










