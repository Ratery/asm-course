extern scanf
extern printf

%macro ALIGN_STACK 1.nolist
    enter 0, 0
    sub esp, %1
    and esp, 0xfffffff0
    add esp, %1
%endmacro

%macro UNALIGN_STACK 0.nolist
    leave
%endmacro

%assign STRLEN 11  ; max length of string

section .bss
    n resd 1
    arr resb 5500

section .data
    fmt_d db "%d", 0
    fmt_s db "%s", %+ STRLEN, 0  ; "%s{STRLEN}"
    ans dd 0

section .text
global main
main:
    push ebp
    mov ebp, esp

    push ebx  ; save registers
    push edi
    push esi

    ; read n
    ALIGN_STACK 8
    push n
    push fmt_d
    call scanf
    UNALIGN_STACK

    ALIGN_STACK 12  ; to be aligned after pushing ecx and edi
    mov edi, arr
    mov ecx, 0
    .input_loop:
        cmp ecx, [n]
        jae .input_done

        push ecx  ; save ecx
        push edi  ; push args
        push fmt_s
        call scanf
        add esp, 8  ; clear args
        pop ecx  ; restore ecx

        mov ebx, arr
        .nested_loop:
            cmp ebx, edi
            je .nested_loop_done

            mov esi, 0  ; offset
            .check_equality_loop:
                mov al, [edi + esi]
                mov dl, [ebx + esi]

                cmp al, dl  ; if al != dl
                jne .not_equal

                ; now al == dl
                test al, al  ; if al == dl == 0
                je .equal

                inc esi
                jmp .check_equality_loop
            .not_equal:

            add ebx, STRLEN
            jmp .nested_loop
        .nested_loop_done:

        ; if not equal
        inc dword [ans]

        .equal:
        inc ecx
        add edi, STRLEN
        jmp .input_loop
    .input_done:

    UNALIGN_STACK

    ALIGN_STACK 8
    push dword [ans]
    push fmt_d
    call printf
    UNALIGN_STACK

    pop esi  ; restore registers
    pop edi
    pop ebx

    xor eax, eax
    leave
    ret
