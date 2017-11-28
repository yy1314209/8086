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

read_file:    ;open file
    mov al,2  ;read/write
    mov dx,offset filename
    mov ah,3dh
    int 21h
    mov handle,ax ;ax = file handle

start_read:   ;read file to buffer              
    mov ah,3fh
    lea dx,read_buffer
    mov bx,handle
    mov cx,100
    int 21h
    
    mov bx,offset block  
    mov di,dx  ;read buffer
    mov si,0  ;n
    
    s:
    push bx
    mov ax,0 
    
exchange:    ;extract numbers from buffer,and put the numbers into block
    mov bl,byte ptr[di] ;read a byte from buffer
    sub bl,48
    mov cx,10
    mul cx
    mov bh,0
    add ax,bx
    inc di
    mov bl,byte ptr[di]
    cmp bl,48
    mov dl,bl
    jb  remove_space
    jmp exchange
    
    ;sub bl,48
    ;add al,bl
    ;pop bx
    ;mov [bx],ax ;write a number into block
    ;add bx,2
    
remove_space:  ;the next byte is space or '\r'
    inc si
    pop bx
    mov [bx],ax
    add bx,2  
    cmp dl,' '
    jb start_sort
    inc di
    jmp s
    
start_sort:  ;bubble sort  
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
    cmp al,bh  ;j   n-i-1..
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
    cmp di,si  ;compare number[j] with number[j+1]
    ja  above
    pop dx
    pop bx
    pop ax
    add al,1    ;j++
    jmp loop2
       
next:
    add ah,1 ;i++
    jmp loop1
    
above:    ;number[j] > number[j+1]  ,exchange them
    mov ax,di
    mov di,dx
    mov ds:[di],ax
    sub di,2
    mov ds:[di],si
    pop dx
    pop bx
    pop ax
    add al,1    ;j++
    jmp loop2    
    
print:
    pop si   ;si == n
    mov di,0
    lea bx,block
       
go_on:
    cmp di,si
    je  stop
    inc di 
    mov ax,[bx]  ;print number in ax
    push bx
    
    mov  dx,0     
    mov  bx, 10
    mov  cx, 0
L1:
    div  bx
    push dx
    inc  cx
    and  ax, ax
    mov  dx,0
    jnz  L1
L2:
    pop  dx
    add  dl, 48
    mov  ah, 2
    int  21H
    loop L2

    mov ah,2
    mov dl,32 ;space
    int 21h
    pop bx
    add bx,2
    jmp go_on
    
stop:
        

.exit

end
