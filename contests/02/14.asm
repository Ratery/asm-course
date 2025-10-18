%include "io.inc"

section .bss
    n resd 1
    k resd 1
    k_plus_1 resd 1
    n_bin_length resb 1


section .data
    ans dd 0
    combs times 961 dd 0  ; table of C(n, k), 0 <= n, k <= 30


section .text
global main
main:
    GET_UDEC 4, [n]
    GET_UDEC 4, [k]

    cmp dword [k], 30
    jb .valid_k

    ; k can not be >= 30
    PRINT_CHAR '0'
    xor eax, eax
    ret  ; exit

    .valid_k:

    mov eax, [k]  ; calculate k_plus_1
    inc eax
    mov [k_plus_1], eax

    mov dword [combs], 1  ; base: C(0, 0) = 1

    mov ecx, 1
    .compute_combs_loop:  ; for ecx = 1 to 30
        cmp ecx, 30
        ja .compute_combs_done

        mov ebx, 0
        .inner_loop:  ; for ebx = 0 to k
            cmp ebx, [k]
            ja .inner_loop_done

            mov edi, ecx
            sub edi, 1
            imul edi, [k_plus_1]
            add edi, ebx  ; edi is offset of [ecx - 1][ebx]

            mov eax, [combs + edi * 4]  ; eax = comb[ecx - 1][ebx]
            test ebx, ebx
            jz .ebx_is_zero  ; if ebx = 0, comb[ecx - 1][0] = 1

            dec edi  ; update offset to match [ecx - 1][ebx - 1]
            add eax, [combs + edi * 4]  ; eax += comb[ecx - 1][ebx - 1]
            jmp .write_eax

            .ebx_is_zero:
            mov eax, 1

            .write_eax:  ; assign comb[ecx][ebx] = eax
            mov edi, ecx
            imul edi, [k_plus_1]
            add edi, ebx
            mov [combs + edi * 4], eax

            inc ebx
            jmp .inner_loop
        .inner_loop_done:

        inc ecx
        jmp .compute_combs_loop
    .compute_combs_done:

    mov edx, 1  ; edx is a binary mask represents only one bit set (0000...1)

    mov cl, 1
    .find_length_loop:  ; ecx = 1, while ...
        shl edx, 1  ; edx <<= 1

        cmp edx, [n]  ; break the loop if edx > n, e. g. ecx == n.bit_length()
        ja .find_length_done

        inc cl
        jmp .find_length_loop
    .find_length_done:

    mov [n_bin_length], cl

    movzx edx, byte [n_bin_length]  ; edx is upper bound
    sub edx, 2
    mov ecx, [k]
    .summing_combs_loop:  ; for ecx = k to edx = n.bit_length - 2
        cmp ecx, edx
        ja .summing_combs_done

        ; ans += comb[ecx][k]
        mov edi, ecx
        imul edi, [k_plus_1]
        add edi, [k]  ; edi is offset of [ecx][k]

        mov eax, [combs + edi * 4]
        add [ans], eax

        inc ecx
        jmp .summing_combs_loop
    .summing_combs_done:

    mov eax, 1  ; zeros count

    mov edx, 1  ; edx is a binary mark represents 1000...
    mov cl, [n_bin_length]
    shl edx, cl
    shr edx, 2

    mov ecx, 1
    .final_loop:  ; for ecx = 1 to n.bit_length - 1
        cmp cl, [n_bin_length]
        jae .final_loop_done

        mov ebx, [n]
        and ebx, edx
        test ebx, ebx  ; check current bit of n
        jz .bit_is_0

        ; if current bit is 1
        cmp [k], eax
        jb .continue  ; continue if k < zeros

        mov ebx, [k]
        sub ebx, eax  ; ebx = k - zeros

        movzx edi, byte [n_bin_length]
        sub edi, ecx
        dec edi  ; edi = pos = n.bit_length - ecx - 1
        imul edi, [k_plus_1]
        add edi, ebx  ; edi is offset of [pos][k - zeros]

        ; ans += combs[pos][k - zeros]
        mov ebx, [combs + edi * 4]
        add [ans], ebx

        jmp .continue

        ; if current bit is 0
        .bit_is_0:
        inc eax  ; zeros++

        .continue:
        inc ecx
        shr edx, 1  ; shift mask
        jmp .final_loop
    .final_loop_done:

    dec eax
    cmp eax, [k]
    jne .print_ans
    inc dword [ans]  ; ans++ if zeros - 1 == k

    .print_ans:
    PRINT_UDEC 4, [ans]

    xor eax, eax
    ret
