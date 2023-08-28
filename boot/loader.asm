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

GetMemInfoStart:
    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20
    mov edi, 0x9000
    xor ebx,ebx
    int 0x15 ;memory map service
    jc NotSupport

GetMemInfo:
    add edi,20; each memory block info is 20 bytes
    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20
    int 0x15
    jc GetMemDone

    test ebx,ebx
    jnz GetMemInfo

GetMemDone:
    

TestA20:
    mov ax,0xffff
    mov es,ax
    mov word[ds:0x7c00],0xa200
    cmp word[es:0x7c10],0xa200
    jne SetA20LineDone
    mov word[0x7c00],0xb200
    cmp word[es:0x7c10],0xb200
    je End


SetA20LineDone:
    xor ax,ax
    mov es,ax

SetVideoMode:
    mov ax,3
    int 0x10
    
    ; Enable Protected Mode
    cli;clear interrupt flags, disable interrupt when Mode Switch
    lgdt [Gdt32Ptr]
    lidt [Idt32Ptr]

    mov eax,cr0
    or eax,1
    mov cr0,eax

    jmp 8:PMEntry

; use infinite loop to halt the processor
ReadError:
NotSupport:
End:
    hlt
    jmp End

[BITS 32]
PMEntry:
    mov ax,0x10
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov esp,0x7c00 ;stack pointer

    mov byte[0xb8000],'P'
    mov byte[0xb8001],0xa

PEnd:
    hlt
    jmp PEnd



DriveId: db 0
; Message:  db "Text Mode is set"
; MessageLen: equ $-Message
ReadPacket: times 16 db 0

Gdt32:
    dq 0
Code32:
    dw 0xffff
    dw 0
    db 0
    db 0x9a
    db 0xcf
    db 0
Data32:
    dw 0xffff
    dw 0
    db 0
    db 0x92
    db 0xcf
    db 0

Gdt32Len: equ $-Gdt32

Gdt32Ptr: dw Gdt32Len-1
          dd Gdt32

Idt32Ptr: dw 0
          dd 0

;     mov si,Message
;     mov ax,0xb800
;     mov es,ax
;     xor di,di
;     mov cx,MessageLen ;cx as loop counter

; PrintMessage:
;     mov al,[si]
;     mov [es:di],al
;     mov byte[es:di+1],0xa

;     add di,2
;     add si,1

;     loop PrintMessage



    ; mov ah,0x13 ;0x13(print string), ah holds function code
    ; mov al,1 ; al(write mode), 1 means cursor will be placed at end of string
    ; mov bx,0xa ; bx(character attributes), 0xa(bright green)
    ; xor dx,dx ;Zeros the dx(starts of screen)
    ; mov bp,Message
    ; mov cx,MessageLen
    ; int 0x10 ;call BIOS interrupts, interrupt 0x10 is PRINT