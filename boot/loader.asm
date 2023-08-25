[BITS 16]
[ORG 0x7e00]

start:
    mov [DriveId],dl

    ;check if input is allowed
    mov eax,0x80000000
    cpuid
    cmp eax,0x80000001
    jb NotSupport; jump if below

    ; get processor features, check if LONG mode is supported
    mov eax,0x80000001
    cpuid
    test edx, (1<<29) ;check long mode support
    jz NotSupport ; check zero flag
    test edx,(1<<26) ;check if support 1g page
    jz NotSupport

LoadKernel:
    mov si,ReadPacket
    mov word[si],0x10 ; size
    mov word[si+2],100 ; read 100 sectors
    mov word[si+4],0 ; offset
    mov word[si+6],0x1000 ; segment. 0x1000 * 16 + 0 = 0x100000 (kernel)
    mov dword[si+8], 6; boot file: 1 sector, loader: 5 sectors (0 based)
    mov dword[si+12],0
    mov dl,[DriveId]
    mov ah,0x42 ; 0x42(disk extension service)
    int 0x13
    jc ReadError

    mov ah,0x13 ;0x13(print string), ah holds function code
    mov al,1 ; al(write mode), 1 means cursor will be placed at end of string
    mov bx,0xa ; bx(character attributes), 0xa(bright green)
    xor dx,dx ;Zeros the dx(starts of screen)
    mov bp,Message
    mov cx,MessageLen
    int 0x10 ;call BIOS interrupts, interrupt 0x10 is PRINT

; use infinite loop to halt the processor
ReadError:
NotSupport:
End:
    hlt
    jmp End


DriveId: db 0
Message:  db "Kernel Loaded"
MessageLen: equ $-Message
ReadPacket: times 16 db 0