extern io_get_udec
extern io_print_udec

section .data
    ans dd 0

section .bss
    a resw 1
    b resw 1
    c resw 1
    d resw 1
    e resw 1
    f resw 1
    sum resw 1

section .text
global main
main:
    call io_get_udec
    mov [a], ax

    call io_get_udec
    mov [b], ax

    call io_get_udec
    mov [c], ax

    call io_get_udec
    mov [d], ax

    call io_get_udec
    mov [e], ax

    call io_get_udec
    mov [f], ax

    ; calculating sum
    add ax, [e]
    add ax, [d]
    mov [sum], ax

    ; calculating result by terms
    movzx eax, word [a]
    mov ebx, [sum]
    sub bx, [d]
    mul ebx
    add [ans], eax

    movzx eax, word [b]
    mov ebx, [sum]
    sub bx, [e]
    mul ebx
    add [ans], eax

    movzx eax, word [c]
    mov ebx, [sum]
    sub bx, [f]
    mul ebx
    add [ans], eax

    mov eax, [ans]
    call io_print_udec

    xor eax, eax
    ret
