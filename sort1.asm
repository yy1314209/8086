.model small
.stack 1000

.data
block dw 100 dup(?)
filename db "2.txt",0
read_buffer db 64 dup(0),0
handle dw ?
len equ 2

.code

.startup
    lea bx,block

read_file:
    mov al,2  ;read
    mov dx,offset filename
    mov ah,3dh
    int 21h
    mov handle,ax

start_read:                 
    mov ah,3fh
    lea dx,read_buffer
    mov bx,handle
    mov cx,64
    int 21h
    
    mov bx,offset block  
    mov di,dx
    mov si,0  ;n
    
exchange:
    inc si
    push bx
    mov bl,byte ptr[di]
    sub bl,48
    mov al,bl
    mov bl,10
    mul bl
    inc di
    mov bl,byte ptr[di]
    sub bl,48
    add al,bl
    dec di
    pop bx
    mov [bx],ax
    add bx,2
    
remove_space:    
    add di,2
    mov cl,byte ptr[di]
    cmp cl,13
    je start_sort
    add di,1
    jne exchange
    
start_sort:    
    lea dx,block
    mov ax,si
    push si
    mov bl,al ;n
    mov ah,0 ;i
    mov al,0 ;j
    
loop1:
    mov bh,bl
    sub bh,1
    cmp ah,bh  ;i  n-1
    je  print
    mov al,0
    
loop2:
    mov bh,bl
    sub bh,ah
    sub bh,1
    cmp al,bh  ;j   n-i-1
    je  next
    push ax
    push bx
    push dx
    mov bl,2
    mul bl
    lea bx,block
    add dx,ax
    add dx,bx
    mov di,dx
    mov di,ds:[di]
    add dx,2
    mov si,dx
    mov si,ds:[si]
    cmp di,si
    ja  above
    pop dx
    pop bx
    pop ax
    add al,1
    jmp loop2
       
next:
    add ah,1
    jmp loop1
    
above:
    mov ax,di
    mov di,dx
    mov ds:[di],ax
    sub di,2
    mov ds:[di],si
    pop dx
    pop bx
    pop ax
    add al,1
    jmp loop2    
    
print:
    pop si
    mov di,0
    lea bx,block
       
go_on:
    cmp di,si
    je  stop
    inc di 
    mov ax,[bx]
    push bx
    mov cx,0

convert:
    sub ax,16
    inc cx
    cmp ax,16
    jae convert
    mov dl,al
    mov al,cl
    mov bl,16
    mul bl
    add al,dl
    mov cx,0
    
prin:
    sub al,10
    inc cx
    cmp ax,10
    jae prin
    mov bl,al
    mov al,cl
    add al,48
    mov ah,0eh
    int 10h
    mov al,bl
    add al,48
    int 10h
    mov al,32 ;space
    int 10h
    pop bx
    add bx,2
    jmp go_on
    
stop:
        

.exit
