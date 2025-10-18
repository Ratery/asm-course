%pragma win32 prefix _

section .data
    const_0_5 dd 0.5
    const_2 dd 2.0
    const_3 dd 3.0
    const_6 dd 6.0


section .text
global f1
f1:
    push ebp
    mov ebp, esp
    
    finit
    fld dword [const_3]
    fld qword [ebp + 8]
    fld1
    fsubp
    fmul st0, st0
    fld1
    faddp
    fdivp
    
    leave
    ret


global f2
f2:
    push ebp
    mov ebp, esp

    finit
    fld qword [ebp + 8]
    fld dword [const_0_5]
    faddp
    fsqrt

    leave
    ret


global f3
f3:
    push ebp
    mov ebp, esp

    finit
    fldl2e
    fmul qword [ebp + 8]

    fld1
    fld st1

    fprem
    f2xm1
    faddp
    fscale
    fstp st1
    
    fld1
    fdivr
    
    leave
    ret
