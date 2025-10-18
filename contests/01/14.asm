extern io_get_udec
extern io_print_udec

section .bss
    n resw 1
    m resw 1
    k resw 1
    d resw 1
    x resb 1
    y resb 1
    total_cnt resd 1

section .text
global main
main:
    call io_get_udec
    mov [n], ax
    call io_get_udec
    mov [m], ax
    call io_get_udec
    mov [k], ax
    call io_get_udec
    mov [d], ax
    call io_get_udec
    mov [x], al
    call io_get_udec
    mov [y], al

    ; k * n * m
    movzx eax, word [k]

    movzx ebx, word [n]
    mul ebx

    movzx ebx, word [m]
    mul ebx

    ; /= d (ceiling)
    movzx ebx, word [d]
    add eax, ebx
    dec eax

    xor edx, edx
    div ebx

    ; total_cnt = (k * n * m + d - 1) / d
    mov [total_cnt], eax

    ; ebx = mask 0 or 1 depending on the time
    movzx ebx, byte [x]
    imul ebx, 60
    movzx ecx, byte [y]
    add ebx, ecx
    sub ebx, 360
    sar ebx, 31
    not ebx

    ; eax = (eax + 2) / 3
    add eax, 2
    mov ecx, 3
    xor edx, edx
    div ecx

    and eax, ebx  ; applying the mask (ebx)

    ; answer = total_cnt - eax
    sub [total_cnt], eax
    mov eax, [total_cnt]

    call io_print_udec

    xor eax, eax
    ret
