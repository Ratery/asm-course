%include "io.inc"

section .bss
    n resd 1
    m resd 1
    k resd 1
    a resd 10000
    b resd 10000
    c resd 10000

section .text
global main
main:
    GET_UDEC 1, [n]
    GET_UDEC 1, [m]
    GET_UDEC 1, [k]

    mov eax, 0
    input_a_loop:  ; eax = 0 to n - 1
        cmp eax, [n]
        jae input_a_done

        mov ebx, 0
        .inner_loop:  ; ebx = 0 to m - 1
            cmp ebx, [m]
            jae .inner_loop_done

            ; edi is the element's, edi = eax * m + ebx
            mov edi, eax  ; edi = eax
            imul edi, [m]  ; edi *= m
            add edi, ebx  ; edi += ebx
            GET_DEC 4, [a + edi * 4]

            inc ebx
            jmp .inner_loop
        .inner_loop_done:

        inc eax
        jmp input_a_loop
    input_a_done:


    mov eax, 0
    input_b_loop:  ; eax = 0 to m - 1
        cmp eax, [m]
        jae input_b_done

        mov ebx, 0
        .inner_loop:  ; ebx = 0 to k - 1
            cmp ebx, [k]
            jae .inner_loop_done

            ; edi is the element's, edi = eax * k + ebx
            mov edi, eax  ; edi = eax
            imul edi, [k]  ; edi *= k
            add edi, ebx  ; edi += ebx
            GET_DEC 4, [b + edi * 4]

            inc ebx
            jmp .inner_loop
        .inner_loop_done:

        inc eax
        jmp input_b_loop
    input_b_done:



    mov eax, 0
    multiply_loop:  ; eax = 0 to n - 1
        cmp eax, [n]
        jae multiply_loop_done

        mov ebx, 0
        .inner_loop1:  ; ebx = 0 to k - 1
            cmp ebx, [k]
            jae .inner_loop1_done

            mov edx, 0  ; accumulator, will be c[eax][ebx]

            mov ecx, 0
            .inner_loop2:  ; ecx = 0 to m - 1
                cmp ecx, [m]
                jae .inner_loop2_done

                mov edi, eax  ; edi = eax
                imul edi, [m]  ; edi *= m
                add edi, ecx  ; edi += ecx

                mov esi, [a + edi * 4]  ; esi = a[eax][ecx]

                mov edi, ecx  ; edi = ecx
                imul edi, [k]  ; edi *= k
                add edi, ebx  ; edi += ebx

                imul esi, [b + edi * 4]  ; esi *= b[ecx][ebx]
                add edx, esi  ; edx += esi

                inc ecx
                jmp .inner_loop2
            .inner_loop2_done:

            ; edi is the element's offset, edi = eax * k + ebx
            mov edi, eax  ; edi = eax
            imul edi, [k]  ; edi *= k
            add edi, ebx  ; edi += ebx
            mov [c + edi * 4], edx  ; c[eax][ebx] = edx

            inc ebx
            jmp .inner_loop1
        .inner_loop1_done:

        inc eax
        jmp multiply_loop
    multiply_loop_done:

    mov eax, 0
    output_c_loop:  ; eax = 0 to n - 1
        cmp eax, [n]
        jae output_c_done

        mov ebx, 0
        .inner_loop:  ; ebx = 0 to k - 1
            cmp ebx, [k]
            jae .inner_loop_done

            ; edi is the element's, edi = eax * k + ebx
            mov edi, eax  ; edi = eax
            imul edi, [k]  ; edi *= k
            add edi, ebx  ; edi += ebx
            PRINT_DEC 4, [c + edi * 4]
            PRINT_CHAR ' '

            inc ebx
            jmp .inner_loop
        .inner_loop_done:

        NEWLINE

        inc eax
        jmp output_c_loop
    output_c_done:

    xor eax, eax
    ret
