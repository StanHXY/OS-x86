[BITS 16] ;boot code running in 16 bits mode
[ORG 0x7c00] ;BIOS load the boot code from first sector to 0x7c00

; Boot
; Initialize Segment Registers & Stack Pointers
start:
    xor ax,ax ;Zeros ax register
    mov ds,ax ;copy ax to ds
    mov es,ax
    mov ss,ax
    mov sp,0x7c00

TestDiskExtension:
    mov [DriveId],dl
    mov ah,0x41
    mov bx,0x55aa
    int 0x13
    jc NotSupport
    cmp bx,0xaa55
    jne NotSupport

LoadLoader:

    mov si,ReadPacket
    mov word[si],0x10 ; size
    mov word[si+2],5 ; read 5 sectors
    mov word[si+4],0x7e00 ; offset
    mov word[si+6],0 ; segment. physical addr: 0*16 + 0x7e00 = 0x7e00
    mov dword[si+8],1
    mov dword[si+12],0
    mov dl,[DriveId]
    mov ah,0x42 ; 0x42(disk extension service)
    int 0x13
    jc ReadError

    mov dl,[DriveId]
    jmp 0x7e00 ;memory of our Loader

ReadError:
NotSupport:
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

DriveId:  db 0
Message:  db "Error in boot process"
MessageLen: equ $-Message
ReadPacket: times 16 db 0 ;define 16 bytes

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


