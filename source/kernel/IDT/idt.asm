[extern _idt]
idt_descriptor:
    dw 4095
    dq _idt

%macro PUSHALL 0
    push rax
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
%endmacro

%macro POPALL 0
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rax
%endmacro

[extern _isr1_handler]
isr1:
    PUSHALL
    call _isr1_handler
    POPALL
    iretq
    global isr1

loadIDT:
    lidt [idt_descriptor]
    sti
    ret
    global loadIDT