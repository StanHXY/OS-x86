[BITS 16] ;boot code running in 16 bits mode
[ORG 0x7c00] ;BIOS load the boot code from first sector to 0x7c00


; Initialize Segment Registers & Stack Pointers
start:
    xor ax,ax ;Zeros ax register
    mov ds,ax ;copy ax to ds
    mov es,ax
    mov ss,ax
    mov sp,0x7c00

PrintMessage:
    mov ah,0x13 ;0x13(print string), ah holds function code
    mov al,1 ; al(write mode), 1 means cursor will be placed at end of string
    mov bx,0xa ; bx(character attributes), 0xa(bright green)
    xor dx,dx ;Zeros the dx(starts of screen)
    mov bp,Message
    mov cx,MessageLen
    int 0x10 ;call BIOS interrupts, interrupt 0x10 is PRINT

End:
    hlt
    jmp End


Message:  db "Hello"

MessageLen: equ $-Message

times (0x1be-($-$$)) db 0 ;0x1be(partition entry)

    db 80h
    db 0,2,0
    db 0f0h
    db 0ffh,0ffh,0ffh
    dd 1
    dd (20*16*63-1)

    times (16*3) db 0

    db 0x55
    db 0xaa


