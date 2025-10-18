%include "io.inc"

section .text
f:
    push ebp
    mov ebp, esp

    GET_DEC 4, eax
    test eax, eax
    jz .return  ; if number == 0

    mov edx, [ebp + 8]  ; edx is an argument

    ; check parity
    mov ecx, edx
    and ecx, 1
    test ecx, ecx
    jz .is_even

    ; edx is odd
    PRINT_DEC 4, eax
    PRINT_CHAR ' '

    ALIGN_STACK 4
    inc edx
    push edx
    call f  ; f(edx + 1)
    UNALIGN_STACK
    jmp .return

    ; edx is even
    .is_even:

    push eax  ; save eax in "local variable"

    ALIGN_STACK 4
    inc edx
    push edx
    call f  ; f(edx + 1)
    UNALIGN_STACK

    mov eax, [ebp - 4]  ; restore eax from "local variable"
    PRINT_DEC 4, eax
    PRINT_CHAR ' '

    .return:
    leave
    ret


global main
main:
    push ebp
    mov ebp, esp

    ALIGN_STACK 4
    push dword 1
    call f  ; f(1)
    UNALIGN_STACK

    xor eax, eax
    leave
    ret
