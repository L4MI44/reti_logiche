%include 'utils.nasm'

section .data
    V dw 2,7,3,20,1,1
    n equ ($-V)/2

section .bss
    cnt resd 1

section .text
    extern proc
    global _start
_start:
    push cnt
    push n 
    push V 
    call proc
    printd dword [cnt]
    exit 0

section .data
    V equ 16
    n equ 12
    cnt equ 8

section .text
    push EBP
    mov EBP, ESP
    pushad
    mov EAX, [EBP + V]
    mov ESI, [EBP + n]
    shl ESI, 1
    xor EDI, EDI
    xor ECX, ECX
ciclo:
    cmp EDI, ESI
    jge esci
    xor BX, BX
    mov BX, [EAX+EDI*2]
    imul BX, BX
    imul BX, [EAX+EDI*2]
    sub BX, [EAX+EDI*2]
    inc BX
    cmp BX, [EAX+EDI*2 + 2]
    jne avanti
    inc ECX
avanti:
    inc EDI
    jmp ciclo
esci:
    mov EAX, [EBP+cnt]
    mov [EAX], ECX
    popad
    pop EBP
    ret 12
