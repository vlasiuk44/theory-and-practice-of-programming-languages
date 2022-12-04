%macro print 2
    push_d
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    pop_d
%endmacro

%macro push_d 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro pop_d 0
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

%macro dprint 0
    push_d
    
    mov ecx, 10
    mov bx, 0
    
%%_divide:
    mov edx, 0
    div ecx
    push dx
    inc bx
    
    test eax, eax
    
    jnz %%_divide
    
%%_digit:
    pop ax
    add ax, '0'
    mov [result], ax
    
    print 1, result
    
    dec bx
    cmp bx, 0
    jnz %%_digit
    
    pop_d
%endmacro

section .text
    global _start
    
    
_start:

    sub esp, 8           
    mov dword [esp], 100
    fild dword [esp]     
    
    fsqrt

    fist dword [esp]
    mov eax, dword [esp]
    
    print len, message
    dprint

_end:
    mov ebx, 0
    mov eax, 1   ;sys_exit
    int 0x80    ;call kernel


section .data
    message db "Square root: "
    len equ $ - message
    
    newline db 0xA, 0xD
    nlen equ $ - newline 

section .bss
    result resb 1