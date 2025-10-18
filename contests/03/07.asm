%include "io.inc"

section .bss
    n resd 1
    k resd 1

section .data
    mod dd 2011

section .text
f:
    push ebp
    mov ebp, esp

    push ebx  ; save ebx in [ebp + 4]
    push edi  ; save edi in [ebp + 8]

    mov eax, [ebp + 8]  ; eax is an argument

    cmp dword [k], 2
    je .optimization_for_base_2

    ; if base is > 2
    .to_base_k_loop:
        test eax, eax
        jz .to_base_k_done  ; break if eax == 0

        mov edx, 0  ; edx = 0 before division
        div dword [k]  ; eax /= k
        push dx  ; push eax % k

        jmp .to_base_k_loop
    .to_base_k_done:

    mov eax, 0  ; accumulator
    mov ecx, 1  ; ecx is k ** i
    mov edi, ebp  ; edi = ebp - 8, i. e. an address of the last "local variable" (-8, because we have ebx, edi in the frame)
    sub edi, 8
    .from_base_k_loop:
        cmp esp, edi
        je .from_base_k_done  ; break if esp == edi, i. e. we popped all of digits

        pop bx  ; get current digit
        movzx ebx, bx  ; extend bx with zeros
        imul ebx, ecx  ; ebx = digit * (k ** i)
        add eax, ebx

        imul ecx, [k]  ; ecx *= k (next power)

        jmp .from_base_k_loop
    .from_base_k_done:

    jmp .return

    ; special optimization for the worst (longest) case when base == 2
    .optimization_for_base_2:

    mov ebx, eax
    mov eax, 0
    .reverse_arg_loop:  ; while ebx != 0
        test ebx, ebx
        jz .reverse_arg_done  ; break if ebx == 0

        shl eax, 1  ; eax <<= 1
        shr ebx, 1  ; ebx >>= 1, CF is the last (removed by shift) bit of ebx
        adc eax, 0  ; eax += CF

        jmp .reverse_arg_loop
    .reverse_arg_done:

    .return:
    mov ebx, [ebp + 4]  ; restore registers
    mov edi, [ebp + 8]
    leave
    ret


global main
main:
    push ebp
    mov ebp, esp

    GET_UDEC 4, [k]
    GET_UDEC 4, [n]
    GET_UDEC 4, eax  ; eax = a

    mov edx, 0  ; edx = 0 before division
    div dword [mod]  ; edx = eax mod 2011
    mov eax, edx

    mov ecx, 1
    .calc_element_loop:  ; for ecx = 1 to n
        cmp ecx, [n]
        ja .calc_element_done

        mul eax  ; eax *= eax

        push ecx  ; save counter
        ALIGN_STACK 4
        push eax  ; push argument
        call f  ; eax = f(eax)
        UNALIGN_STACK
        pop ecx  ; restore counter

        mov edx, 0  ; edx = 0 before division
        div dword [mod]  ; edx = eax mod 2011
        mov eax, edx

        inc ecx
        jmp .calc_element_loop
    .calc_element_done:

    PRINT_UDEC 4, eax

    xor eax, eax
    leave
    ret
