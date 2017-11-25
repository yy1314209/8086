.data
num equ 10
block db 25,69,-10,
      db -20,0,52,-30,
      db -52,96,10

.code
.startup
    mov ch,0 ;>
    mov cl,0 ;<
    mov dl,0 ;=
    lea bx,block
    mov di,0

count:
    cmp di,num
    je  stop
    lea bx,block
    add bx,di
    mov al,byte ptr[bx]
    cmp al,0
    je  equal
    and al,80h
    cmp al,0
    je  below
    jmp above 
    
equal:
    inc dl
    inc di
    jmp count

below:
    inc cl
    inc di
    jmp count
    
above:
    inc ch
    inc di
    jmp count 

stop:

.exit