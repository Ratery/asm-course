%include "io.inc"

section .bss
    n resd 1
    k resd 1
    m resd 1
    seq resb 10  ; current generating sequence

section .data
    gen_count dd 0  ; number of generated sequences
    used times 11 db 0  ; table indicating whether a number was used

section .text
f:  ; f(i)
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]  ; eax = i
    cmp eax, [k]  ; check if i == k
    jne .length_limit_not_exceeded

    ; i == k
    inc dword [gen_count]  ; increment generated sequences counter
    mov eax, [gen_count]
    cmp eax, [m]  ; compare with target index
    jne .return

    ; if gen_count == m, print the current sequence
    mov ecx, 0
    .print_seq_loop:  ; for cx = 0 to k - 1
        cmp ecx, [k]
        jae .print_seq_done

        PRINT_UDEC 1, [seq + ecx]
        PRINT_CHAR ' '

        inc ecx
        jmp .print_seq_loop
    .print_seq_done:

    jmp .return

    ; i < k, generate i-th element of current sequence
    .length_limit_not_exceeded:

    mov ecx, 1
    .gen_elements_loop:  ; ecx = 1 to n, try all possible values
        cmp ecx, [n]
        ja .gen_elements_done

        mov dl, [used + ecx]  ; dl = used[ecx]
        test dl, dl
        jnz .continue  ; continue if used[ecx] == 1, i. e. ecx was used

        mov byte [used + ecx], 1  ; used[ecx] = 1, mark that we used ecx

        mov eax, [ebp + 8]  ; eax = i
        mov [seq + eax], cl  ; seq[eax] = cl, i. e. seq[i] = cl

        push ecx  ; save ecx
        ALIGN_STACK 4
        inc eax
        push eax  ; push argument
        call f  ; f(i + 1)
        UNALIGN_STACK
        pop ecx  ; restore ecx

        mov byte [used + ecx], 0  ; used[ecx] = 0

        .continue:
        inc ecx
        jmp .gen_elements_loop
    .gen_elements_done:

    .return:
    leave
    ret


global main
main:
    push ebp
    mov ebp, esp

    GET_UDEC 1, [n]
    GET_UDEC 1, [k]
    GET_UDEC 4, [m]

    ALIGN_STACK 4
    push dword 0
    call f  ; f(0)
    UNALIGN_STACK

    xor eax, eax
    leave
    ret
