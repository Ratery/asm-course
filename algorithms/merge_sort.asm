%include "io.inc"

section .bss
    n resd 1
    arr resd 10000
    left_arr resd 10000
    right_arr resd 10000


section .text
sort:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]  ; left bound
    
    cmp eax, [ebp + 12]
    je .return  ; handle base case (l == r)
    
    mov edx, eax
    add edx, [ebp + 12]
    shr edx, 1  ; edx = mid = (l + r) / 2
    push edx  ; save edx in [ebp - 4]
    
    sub esp, 12  ; align stack
    push edx  ; push mid
    push eax  ; push left bound
    call sort
    
    add esp, 8
    push dword [ebp + 12]  ; push right bound
    mov edx, [ebp - 4]
    inc edx
    push edx  ; push mid + 1
    call sort
    
    add esp, 20  ; clear space
    
    mov edx, 0
    mov ecx, [ebp + 8]  ; ecx = left bound
    .fill_left_loop:
        cmp ecx, [ebp - 4]
        ja .fill_left_done
        
        mov eax, [arr + ecx * 4]
        mov [left_arr + edx * 4], eax
        
        inc ecx
        inc edx
        jmp .fill_left_loop
    .fill_left_done:
    mov dword [left_arr + edx * 4], 0x7FFFFFFF
    
    mov edx, 0
    .fill_right_loop:
        cmp ecx, [ebp + 12]
        ja .fill_right_done
        
        mov eax, [arr + ecx * 4]
        mov [right_arr + edx * 4], eax
        
        inc ecx
        inc edx
        jmp .fill_right_loop
    .fill_right_done:
    mov dword [right_arr + edx * 4], 0x7FFFFFFF
    
    ; merge
    mov eax, [ebp + 8]  ; eax = left bound
    mov ecx, 0
    mov edx, 0
    .merge_loop:
        cmp eax, [ebp + 12]
        ja .merge_done
        
        mov ebx, [left_arr + ecx * 4]
        cmp ebx, [right_arr + edx * 4]
        jl .use_left
        
        ; use right
        mov ebx, [right_arr + edx * 4]
        mov [arr + eax * 4], ebx
        inc edx
        jmp .continue
        
        .use_left:
        mov [arr + eax * 4], ebx
        inc ecx
        
        .continue:
        inc eax
        jmp .merge_loop
    .merge_done:
    
    .return:
    leave
    ret

global main
main:
    push ebp
    mov ebp, esp
    
    GET_UDEC 4, [n]
    
    mov ecx, 0
    .input_loop:
        cmp ecx, [n]
        jae .input_done
        
        GET_DEC 4, [arr + ecx * 4]
        
        inc ecx
        jmp .input_loop
    .input_done:
    
    ALIGN_STACK 8
    mov eax, [n]
    dec eax
    push eax
    push dword 0
    call sort
    UNALIGN_STACK
    
    mov ecx, 0
    .output_loop:
        cmp ecx, [n]
        jae .output_done

        PRINT_DEC 4, [arr + ecx * 4]
        PRINT_CHAR ' '
        
        inc ecx
        jmp .output_loop
    .output_done:
    
    xor eax, eax
    leave
    ret
