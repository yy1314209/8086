.model flat,c 


.stack 1024

.data
arraychar db "jdiwah",0
.code
.startup
 
move macro a,b
    push ax
    mov ax,b
    mov a,ax
    pop ax
endm
move var1,var2
Reverse proc uses si
    mov si,offset arraychar
    mov ax,0
    push ax
    
    read:
        mov al,[si]
        push ax
        inc si
        cmp al,0
        jne read
    
    mov si,offset arraychar
    
    write:
        pop ax
        mov [si],al
        inc si
        cmp ax,0
        jne write
    ret


reverse  endp

End