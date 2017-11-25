.model small 

.stack 1000 

.data

num equ 36
column  equ 6
row     equ 6
block db 36 dup('\0')
      
.code

.startup
    mov di,offset block
    mov bx,1
    
store:    ;store 1~36
    mov [di],bx 
    inc bx 
    add di,1
    cmp bx,num+1
    jb  store 
    
    mov bx,0
    lea di,block
    mov dx,0

print_loop1:
    cmp bx,0  ;bx row
    ja  change_line

go_on:
    mov cx,0
    inc bx
    cmp bx,row
    ja  stop
    jmp print_loop2
    
change_line: ;change line
    mov ah,0eh
    mov al,10
    int 10h
    mov al,13
    int 10h
    jmp go_on
    

print_loop2:
    cmp cx,column ;cx>=6??
    je  print_loop1
    cmp cx,bx     ;cx >= bx  print space
    jae print_space
    mov ah,0eh
    lea di,block
    add di,dx
    mov al,byte ptr[di]
    
print_num:
    mov si,0
    cmp al,10
    jae convert    ;>10  print in convert
    add al,48      ;<10  print here
    int 10h
    mov al,32  ;print space
    int 10h
    int 10h
    inc dx
    inc cx
    jmp print_loop2

convert:  ;
    sub al,10
    inc si
    cmp al,10
    jae convert
    push dx
    push ax
    mov dx,si
    mov al,dl
    add al,48
    int 10h 
    pop ax
    add al,48
    int 10h
    mov al,32  ;print space
    int 10h
    pop dx
    inc dx
    inc cx
    jmp print_loop2 

print_space:
    int 10h
    mov al,32  ;print space
    int 10h
    inc cx
    inc dx
    jmp print_loop2

stop:    
     
.exit
end
   