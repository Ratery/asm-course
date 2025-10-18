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
    
    mov ebx, 1
    .sort_loop:  ; for ebx = 1 to n - 1
        cmp ebx, [n]
        jae .sort_done
        
        mov ecx, ebx
        .swap_loop:  ; ecx = ebx, while (ecx != 0 && arr[ecx - 1] > arr[ecx])
            test ecx, ecx
            jz .swap_done  ; break if ecx == 0
            
            lea edi, [arr + ecx * 4]
            mov eax, [edi - 4]  ; previous
            mov edx, [edi]  ; current
            
            cmp eax, edx
            jle .swap_done  ; break if order of neighbours is correct
            
            ; swap
            mov [edi], eax
            mov [edi - 4], edx
            
            dec ecx
            jmp .swap_loop
        .swap_done:
        
        inc ebx
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
