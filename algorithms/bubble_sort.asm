%include "io.inc"

section .bss
    n resd 1
    arr resd 10000


section .text
global main
main:
    GET_UDEC 4, [n]
    
    mov ecx, 0
    .input_loop:
        cmp ecx, [n]
        jae .input_done
        
        GET_DEC 4, [arr + ecx * 4]
        
        inc ecx
        jmp .input_loop
    .input_done:
    
    mov ecx, 1
    .sort_loop:  ; for ecx = 1 to n - 1
        cmp ecx, [n]
        jae .sort_done
        
        mov ebx, 1
        .swap_loop:  ; for ebx = 1 to n - 1
            cmp ebx, [n]
            jae .swap_done
            
            lea edi, [arr + ebx * 4]
            mov eax, [edi - 4]
            mov edx, [edi]
            
            cmp eax, edx
            jle .continue  ; continue if order of neighbours is correct
            
            ; swap
            mov [edi], eax
            mov [edi - 4], edx
            
            .continue:
            inc ebx
            jmp .swap_loop
        .swap_done:
        
        inc ecx
        jmp .sort_loop
    .sort_done:
    
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
    ret
