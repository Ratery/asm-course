extern io_get_hex
extern io_print_hex

section .bss
    a resd 1
    b resd 1
    c resd 1

section .text
global main
main:
    call io_get_hex
    mov [a], eax

    call io_get_hex
    mov [b], eax

    call io_get_hex
    mov [c], eax

    and eax, [a] ; eax = a & c

    mov ebx, [c]
    not ebx
    and ebx, [b] ; ebx = ~a & c

    or eax, ebx ; result = eax | ebx = (a & c) | (~c & b)
    call io_print_hex

    xor eax, eax
    ret
