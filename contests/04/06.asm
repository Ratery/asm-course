extern fopen
extern fclose
extern fread
extern fwrite

%macro ALIGN_STACK 1.nolist
    enter 0, 0
    sub esp, %1
    and esp, 0xfffffff0
    add esp, %1
%endmacro

%macro UNALIGN_STACK 0.nolist
    leave
%endmacro

%assign MAX_ARR_SIZE 1048576  ; 1024 * 1024 dwords

section .bss
    n resd 1
    arr resd MAX_ARR_SIZE
    type_map resb 4
    ans resd 1

section .data
    input_filename db "input.bin", 0
    output_filename db "output.bin", 0
    mode_rb db "rb", 0
    mode_wb db "wb", 0


section .text
global main
main:
    push ebp
    mov ebp, esp

    push edi  ; save edi and esi
    push esi

    ; open the input file
    ; eax = fopen(input_filename, "rb")
    ALIGN_STACK 8
    push mode_rb
    push input_filename
    call fopen
    UNALIGN_STACK

    mov esi, eax  ; esi = pointer to the file
    test esi, esi
    jz .file_error  ; if file pointer is NULL

    ; fread(arr, 4, 1048576, esi)
    ALIGN_STACK 16
    push esi
    push dword 1048576
    push dword 4
    push arr
    call fread
    UNALIGN_STACK

    mov [n], eax  ; n = number of successfully readed integers

    ; fclose(esi)
    ALIGN_STACK 4
    push esi
    call fclose
    UNALIGN_STACK

    mov ebx, 0  ; ebx is a mask
    mov ecx, 0
    mov eax, [n]
    lea esi, [arr + eax * 4]  ; esi = address of arr[n]
    .loop:
        cmp ecx, [n]
        jae .end_loop

        mov eax, [arr + ecx * 4]  ; eax = arr[ecx]

        lea edi, [arr + ecx * 8 + 4]  ; address of arr[ecx * 2 + 1]
        cmp edi, esi
        jae .end_loop  ; break if ecx * 2 + 1 >= esi

        cmp eax, [edi]  ; compare parent and the left child
        je .end_if
        jl .less

        ; if parent > child
        or ebx, 0b10
        jmp .end_if

        ; if parent < child
        .less:
        or ebx, 0b01

        .end_if:

        add edi, 4  ; add 4 to make edi represent an address of the right child
        cmp edi, esi
        jae .end_loop  ; break if ecx * 2 + 2 >= esi

        cmp eax, [edi]  ; compare parent and the right child
        je .end_if_2
        jl .less_2

        ; if parent > child
        or ebx, 0b10
        jmp .end_if_2

        ; if parent < child
        .less_2:
        or ebx, 0b01

        .end_if_2:

        inc ecx
        jmp .loop
    .end_loop:

    ; fill mapping
    mov byte [type_map + 0b00], 1
    mov byte [type_map + 0b01], 1
    mov byte [type_map + 0b10], -1
    mov byte [type_map + 0b11], 0

    movsx eax, byte [type_map + ebx]  ; eax = answer
    mov [ans], eax  ; save eax to access to it's address next (consider pushing it instead)

    ; open the output file
    ; eax = fopen(output_filename, "wb")
    ALIGN_STACK 8
    push mode_wb
    push output_filename
    call fopen
    UNALIGN_STACK

    mov esi, eax  ; esi = pointer to the file
    test esi, esi
    jz .file_error  ; if file pointer is NULL

    ; fwrite(&ans, 4, 1, esi)
    ALIGN_STACK 16
    push esi
    push dword 1
    push dword 4
    push ans
    call fwrite
    UNALIGN_STACK

    ; fclose(esi)
    ALIGN_STACK 4
    push esi
    call fclose
    UNALIGN_STACK

    jmp .return

    .file_error:  ; file-related errors handler
    pop esi  ; restore esi and edi
    pop edi
    mov eax, 1
    leave
    ret

    .return:
    pop esi  ; restore esi and edi
    pop edi
    xor eax, eax
    leave
    ret
