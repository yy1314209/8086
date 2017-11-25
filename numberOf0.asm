.data
num equ 1

.code
.startup
    mov cx,0
    mov bx,1010101010101010b
    
calculate:
    mov ax,bx
    and ax,0001h
    cmp ax,0
    je  move
    jne increase

increase:
    inc cx
    shr bx,1
    cmp bx,0
    je  stop
    jmp calculate
    

move:
    shr bx,1
    cmp bx,0
    je  stop
    jmp calculate

stop:

.exit
    