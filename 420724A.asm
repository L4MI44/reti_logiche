%include 'utils.nasm'
section .data
    V dw [2,11,3,18,1,3]
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

;PERCHE NON 8, 12, 16?
section .data
    V equ 16
    n equ 12
    cnt equ 8 

section .text
    global proc
proc:
    push EBP
    mov EBP, ESP
    pushad
    mov EAX, [EBP + V]
    mov ESI, [EBP + n]
    shl ESI, 1              ;2*n
    xor EDI, EDI            ;indice
    xor ECX, ECX            ;contatore
ciclo:
    cmp EDI, ESI
    jge fine_ciclo
    mov BX, [EAX + EDI*2]   ;x
    imul BX, BX             ;x^2
    imul BX, 3              ;3*x^2
    sub BX, [EAX+EDI*2]     ;3*x^2-x
    inc BX                  ;3*x^2-x+1
    cmp BX, [EAX+EDI*2+2]   ;y =? 3*x^2-x+1 
    jne avanti
    inc ECX
avanti:
    inc EDI
    jmp ciclo
fine_ciclo:
    mov EAX, [EBP+cnt]
    mov [EAX], ECX
    popad
    pop EBP
    ret 12 