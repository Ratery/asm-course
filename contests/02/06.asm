%include "io.inc"

section .bss
    n resd 1
    k resb 1

section .data
    ans dd 0

section .text
global main
main:
    GET_UDEC 4, [n]
    GET_UDEC 1, [k]

    mov eax, 1  ; eax is binary mask
    mov cl, 0
    pow_loop:  ; cl = 0 to k - 1
        cmp cl, [k]
        jae pow_done

        mov ebx, 2
        mul ebx

        inc cl
        jmp pow_loop
    pow_done:

    sub eax, 1  ; eax = 000...111 with k ones

    mov ebx, [n]  ; ebx = n, then in the loop we will do ebx >>= 1

    mov cl, 1
    shift_loop:  ; cl = 1 to 32
        cmp cl, 32
        ja shift_loop_done

        mov edx, ebx
        and edx, eax  ; edx = ebx & eax

        cmp edx, [ans]
        jbe .continue  ; continue if edx = ebx & eax <= ans

        mov [ans], edx  ; update ans

        .continue:

        shr ebx, 1  ; ebx >>= 1
        inc cl
        jmp shift_loop
    shift_loop_done:

    PRINT_UDEC 4, [ans]

    xor eax, eax
    ret
