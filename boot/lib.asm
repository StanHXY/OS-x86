section .text
global memset
global memcpy
global memmove
global memcmp

memset:
    cld
    ; rdi(buffer), rsi(value), rdx(size)
    mov ecx,edx
    mov al,sil ;same value in al
    rep stosb
    ret

memcmp:
    cld
    ; rdi(src1), rsi(src2), rdx(size)
    xor eax,eax
    mov ecx,edx
    repe cmpsb ;repeat while equal
    setnz al
    ret

memmove:
memcpy:
    cld
    cmp rsi,rdi
    jae .copy
    
    mov r8,rsi
    add r8,rdx
    cmp r8,rdi
    jbe .copy

.overlap:
    std
    add rdi,rdx
    add rsi,rdx
    sub rdi,1
    sub rsi,1
    
.copy:
    mov ecx,edx
    rep movsb
    cld
    ret
