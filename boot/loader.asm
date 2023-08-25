[BITS 16]
[ORG 0x7e00]

start:
    mov ah,0x13 ;0x13(print string), ah holds function code
    mov al,1 ; al(write mode), 1 means cursor will be placed at end of string
    mov bx,0xa ; bx(character attributes), 0xa(bright green)
    xor dx,dx ;Zeros the dx(starts of screen)
    mov bp,Message
    mov cx,MessageLen
    int 0x10 ;call BIOS interrupts, interrupt 0x10 is PRINT

; use infinite loop to halt the processor
End:
    hlt
    jmp End


Message:  db "Loader Starts ..."
MessageLen: equ $-Message