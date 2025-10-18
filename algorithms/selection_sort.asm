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
    
    mov ebx, 0
    .sort_loop:  ; for ebx = 1 to n - 1
        cmp ebx, [n]
        jae .sort_done
        
        lea edi, [arr + ebx * 4]  ; edi = address of arr[ebx]
        mov eax, [edi]  ; eax = arr[ebx]
        
        mov ecx, ebx
        .get_min_loop:  ; for ecx = ebx to n - 1
            cmp ecx, [n]
            jae .get_min_done
            
            lea edx, [arr + ecx * 4]  ; edx = address of arr[ecx]
            
            cmp [edx], eax  ; compare with current min value
            jge .continue
            
            ; arr[edx] is a new minimum
            mov edi, edx  ; update address
            mov eax, [edi]  ; update value
            
            .continue:
            inc ecx
            jmp .get_min_loop
        .get_min_done:
        
        ; swap(arr[edi], arr[ebx]), i. e. swap current with found minimum
        mov edx, [arr + ebx * 4]
        mov [arr + ebx * 4], eax
        mov [edi], edx
        
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
