%macro printd 0
    pushd
    mov bx, 0
    mov ecx, 10
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
    jg %%_digit
    popd
%endmacro

%macro pushd 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro popd 0
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

%macro decimal 2
    pushd
    mov eax, %1
    mov ebx, 10
    mul ebx
    mov ecx, %2
    div ecx
    pop edx
    pop ecx
    pop ebx
%endmacro

%macro new_line 0
    putchar 0xA
    putchar 0xD
%endmacro

%macro putchar 1
    pushd
    jmp %%work
    %%char db %1
%%work:
    mov eax, 4
    mov ebx, 1
    mov ecx, %%char
    mov edx, 1
    int 0x80
    popd
%endmacro

%macro const_print 1
    pushd
    jmp %%print 
    %%str db %1, 0xA
    %%len equ $ - %%str
    
%%print:  
    mov eax, 4
    mov ebx, 1
    mov ecx, %%str
    mov edx, %%len
    int 0x80
    popd
%endmacro

%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    popd
%endmacro

section .text
    global _start

_start:
    mov ebx, 0
    mov eax, 0
_sum_x:
    add al, [x + ebx*4]
    inc ebx
    cmp ebx, array_len
    jl _sum_x

    mov [x_sum], eax
    mov ebx, 0
    mov eax, 0

_sum_y:
    add al, [y + ebx*4]
    inc ebx
    cmp ebx, array_len
    jl _sum_y

    
    mov [y_sum], eax
    mov ebx, [x_sum]
    cmp eax, ebx
    jl _iflower
    jg _ifgrower

_iflower:
    mov [sign], byte 0
    mov eax, [x_sum]
    mov ebx, [y_sum]
    sub eax, ebx
    
    jmp _result

_ifgrower:
    mov [sign], byte 1
    mov eax, [y_sum]
    mov ebx, [x_sum]
    sub eax, ebx

    jmp _result


_result:
    mov ebx, array_len
    div ebx
    const_print "Arithmetic mean:"
    cmp [sign], byte 1 
    je _minus
    jmp _print
_minus: 
    putchar '-'
_print:
    printd

    putchar ','
    decimal edx, array_len
    printd

    new_line
    print len, message
    new_line

section .data
    x dd 5, 3, 2, 6, 1, 7, 4 
    y dd 0, 10, 1, 9, 2, 8, 5 
    array_len equ ($ - y) / 4
    message db "Done!"
    len equ $ - message

section .bss
    result resb 1
    x_sum resb 10
    y_sum resb 10
    result_integer resb 5
    result_decimal resb 1
    sign resb 1
