%include "io.inc"

section .text
global main
main:
    GET_UDEC 4, eax
    GET_UDEC 4, ebx
    
    cmp eax, ebx  ; check invariant eax >= ebx
    jae .invariant_is_satisfied
    
    ; fix invariant using swap(eax, ebx)
    mov edx, eax
    mov eax, ebx
    mov ebx, edx
    
    .invariant_is_satisfied:
    
    .calc_gcd_loop:  ; while (ebx != 0)
        test ebx, ebx
        jz .calc_gcd_done  ; break if ebx == 0
        
        mov edx, 0
        div ebx  ; eax / ebx
        
        mov eax, ebx  ; eax = ebx
        mov ebx, edx  ; ebx = eax % ebx
        
        jmp .calc_gcd_loop
    .calc_gcd_done:
    
    PRINT_UDEC 4, eax
    
    xor eax, eax
    ret
