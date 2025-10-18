%include "io.inc"

section .bss
    n resd 1

section .text
global main
main:
    GET_UDEC 4, [n]

    mov ecx, 2
    .loop:  ; ecx = 2; while (ecx * ecx <= n)
        mov eax, ecx
        mul ecx  ; eax = ecx * ecx
        cmp eax, [n]
        ja .loop_done

        mov eax, [n]
        div ecx  ; eax = n / ecx, edx = n % ecx

        test edx, edx
        jnz .continue  ; continue if r != 0

        PRINT_UDEC 4, eax  ; print quotient
        xor eax, eax
        ret  ; exit

        .continue:
        inc ecx
        jmp .loop
    .loop_done:

    PRINT_CHAR '1'  ; if not divisors found in range [2, sqrt(n)], answer is 1

    xor eax, eax
    ret
