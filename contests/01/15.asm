extern io_get_udec
extern io_print_udec
extern io_print_char

section .bss
    x1 resw 1
    x2 resw 1
    x3 resw 1
    y1 resw 1
    y2 resw 1
    y3 resw 1

section .text
global main
main:
    call io_get_udec
    mov [x1], ax
    call io_get_udec
    mov [y1], ax
    call io_get_udec
    mov [x2], ax
    call io_get_udec
    mov [y2], ax
    call io_get_udec
    mov [x3], ax
    call io_get_udec
    mov [y3], ax

    ; eax = (x2 - x1) * (y3 - y1)
    mov ax, [x2]
    sub ax, [x1]
    mov bx, [y3]
    sub bx, [y1]
    movsx eax, ax
    movsx ebx, bx
    imul eax, ebx

    ; ebx = (x3 - x1) * (y2 - y1)
    mov bx, [x3]
    sub bx, [x1]
    mov cx, [y2]
    sub cx, [y1]
    movsx ebx, bx
    movsx ecx, cx
    imul ebx, ecx

    sub eax, ebx  ; eax -= ebx

    ; eax = abs(eax) = (eax ^ ebx) - ebx, where ebx = eax >> 31
    mov ebx, eax
    sar ebx, 31
    xor eax, ebx
    sub eax, ebx

    ; eax /= 2
    mov ebx, 2
    xor edx, edx
    div ebx
    mov bl, dl  ; save rem in bl before io_print_dec

    call io_print_udec  ; print quotient

    mov eax, '.'
    call io_print_char

    movzx eax, bl  ; print rem * 5
    mov bl, 5
    mul bl
    call io_print_udec

    xor eax, eax
    ret
