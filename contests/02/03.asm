%include "io.inc"

section .bss
    n resd 1
    arr resd 500000
    arr2 resd 500000

section .text
global main
main:
    GET_UDEC 4, [n]

    mov ecx, 0
    input_loop:
        cmp ecx, [n]
        jae input_done
        GET_DEC 4, [arr + ecx * 4]

        inc ecx
        jmp input_loop
    input_done:

    mov esi, 0  ; pointer to array of minimums
    mov ecx, 1
    mov edx, [n]  ; edx is right bound (n - 1)
    dec edx
    find_mins_loop:  ; ecx = 1 to n - 1
        cmp ecx, edx
        jge find_mins_done  ; using signed comparison here because of case n = 0 => right bound is n - 1 = -1

        lea ebx, [arr + ecx * 4]  ; ebx is address of element
        mov eax, [ebx]  ; eax is value
        mov eax, [arr + ecx * 4]
        cmp [ebx - 4], eax  ; compare with previous
        jle .continue
        cmp [ebx + 4], eax  ; comare with next
        jle .continue

        mov [arr2 + esi * 4], ecx  ; write index (ecx) to array of minimums
        inc esi

        .continue:

        inc ecx
        jmp find_mins_loop
    find_mins_done:

    PRINT_UDEC 4, esi
    NEWLINE
    mov ecx, 0
    output_mins_loop:
        cmp ecx, esi
        jae output_mins_done

        PRINT_DEC 4, [arr2 + ecx * 4]
        PRINT_CHAR ' '

        inc ecx
        jmp output_mins_loop
    output_mins_done:

    NEWLINE  ; the code below is same as above except using jge instead of gle in comparisons
    mov esi, 0
    mov ecx, 1
    mov edx, [n]
    dec edx
    find_maxs_loop:
        cmp ecx, edx
        jge find_maxs_done

        lea ebx, [arr + ecx * 4]
        mov eax, [ebx]
        cmp [ebx - 4], eax
        jge .continue
        cmp [ebx + 4], eax
        jge .continue

        mov [arr2 + esi * 4], ecx
        inc esi

        .continue:

        inc ecx
        jmp find_maxs_loop
    find_maxs_done:

    PRINT_UDEC 4, esi
    NEWLINE
    mov ecx, 0
    output_maxs_loop:
        cmp ecx, esi
        jae output_maxs_done

        PRINT_DEC 4, [arr2 + ecx * 4]
        PRINT_CHAR ' '

        inc ecx
        jmp output_maxs_loop
    output_maxs_done:

    xor eax, eax
    ret
