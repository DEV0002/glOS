[bits 32]
[extern _kernel]
_detect_64:
    ; Detect CPUID
    pushfd
    pop eax

    mov eax, ecx
    xor eax, 1 << 21
    push eax
    popfd

    pushfd
    pop eax

    push ecx
    popfd
    xor eax, ecx
    jnz .detect_lm ; Detect long mode if CPUID is supported

    ; Print error message
    mov esi, cpuid_err
    mov cx, 19
    mov edi, 0xb8000
    cld
    rep movsw
    hlt

    .detect_lm:
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jnz _enter_lm

    ; Print error message
    mov esi, cpuid_err
    mov cx, 19
    mov edi, 0xb8000
    cld
    rep movsw
    hlt ; TODO: 32-bit Support

_enter_lm:


    jmp codeseg:enter_kernel

cpuid_err: ; 'CPUID not Supported'
    dw 0x0f43, 0x0f50, 0x0f55, 0x0f49, 0x0f44, 0x0f20, 0x0f6e, 0x0f6f, 0x0f74, 0x0f20, 0x0f53, 0x0f75, 0x0f70, 0x0f70, 0x0f6f, 0x0f72, 0x0f74, 0x0f65, 0x0f64

lm_err: ; 64bit not Supported
    dw 0x0f36, 0x0f34, 0x0f62, 0x0f69, 0x0f74, 0x0f20, 0x0f6e, 0x0f6f, 0x0f74, 0x0f20, 0x0f53, 0x0f75, 0x0f70, 0x0f70, 0x0f6f, 0x0f72, 0x0f74, 0x0f65, 0x0f64
 
[bits 64]

enter_kernel:
    call _kernel
    jmp $