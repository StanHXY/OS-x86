[BITS 64]
[ORG 0x200000]

start:
    mov rdi,Idt
    mov rax,handler0

    mov [rdi],ax
    shr rax,16
    mov [rdi+6],ax
    shr rax,16
    mov [rdi+8],eax

    lgdt [Gdt64Ptr]
    lidt [IdtPtr]


    push 8
    push KernelEntry
    db 0x48

    retf

KernelEntry:
    mov byte[0xb8000],'K'
    mov byte[0xb8001],0xa

    xor rbx,rbx
    div rbx


End:
    hlt
    jmp End

handler0:
    mov byte[0xb8000],'D'
    mov byte[0xb8001],0xc

    jmp End
    iretq ;interrupt return


Gdt64:
    dq 0
    dq 0x0020980000000000

Gdt64Len: equ $-Gdt64


Gdt64Ptr: dw Gdt64Len-1
          dq Gdt64


Idt:
    ;repeat:
    %rep 256 
        dw 0 ;declare word: 2 bytes
        dw 0x8 
        db 0 ;declare byte: 1 byte
        db 0x8e
        dw 0
        db 0
        db 0
    %endrep

IdtLen: equ $-Idt

IdtPtr: dw IdtLen-1
        dq Idt

