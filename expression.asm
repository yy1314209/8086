.model flat
             
.stack 1024

.data
input_tips db "input the expression:$"
output_tips db 10,13,"the value of the expression is:$" 
top1 dw 0    ;stack_op top
top2 dw 0    ;stack_data  top
stack_op db 100 dup(0)   ;
stack_data db 100 dup(0)

.code
.startup

;----------------------------main----------------------
main proc near
    mov  dx,offset input_tips  ;output tips
    mov  ah,9
    int  21h
    call init
    input_loop:            
        call input
        cmp  al,61
        je   input_end
        call handle
        jmp  input_loop
    
    input_end:
        call print
    jmp stop
    
;---------------------------init---------------------------
init proc near
    mov si,offset top1
    mov word ptr[si],1
    mov si,offset top2
    mov word ptr[si],0
    mov si,offset stack_op
    mov word ptr[si],0
    ret 
    
;---------------input----------------------    
input proc near
    mov ah,1
    int 21h
    ret
input endp

;---------------------------handle-----------------------
handle proc near
    cmp al,48   ;is digit?
    jb  enter_stack_op
    mov si,offset top2
    mov bx,[si]
    mov si,offset stack_data
    sub al,48
    mov [si+bx],al     ;stack_data[top2] == al
    inc bx
    mov si,offset top2
    mov [si],bx
    
    mov si,offset top1   ;fetch the stack_op[top1-1]
    mov bx,[si]
    dec bx
    mov si,offset stack_op
    mov dl,[si+bx]
    
    go_there:
        cmp dl,43 ;+
        jne mi
    ad:                 ;stack_data[top-1] = stack_data[top-1] + stack_data[top-2]
        mov si,offset top2
        mov bx,[si]
        dec bx
        mov si,offset stack_data
        mov dl,[si+bx]
        dec bx
        mov dh,[si+bx]
        add dl,dh
        mov [si+bx],dl
        inc bx
        mov si,offset top2
        mov [si],bx
        
        mov si,offset top1   ;pop '+' 
        mov bx,[si]
        dec bx
        mov [si],bx
        jmp handle_end
        
    mi:               ;stack_data[top-1] = stack_data[top-2] - stack_data[top-1]
        cmp dl,45
        jne handle_end
        
        mov si,offset top2
        mov bx,[si]
        dec bx
        mov si,offset stack_data
        mov dh,[si+bx]
        dec bx
        mov dl,[si+bx]
        sub dl,dh
        mov [si+bx],dl
        inc bx
        mov si,offset top2
        mov [si],bx
        
        mov si,offset top1   ;pop '-' 
        mov bx,[si]
        dec bx
        mov [si],bx
        jmp handle_end
    
     
    
    enter_stack_op:
        cmp al,41 ;is ')' ?  
        je  pop_stack_op
        mov si,offset top1 ;stack_op[top1] == al
        mov bx,[si]
        mov si,offset stack_op
        mov [si+bx],al
        inc bx ;top1++
        mov si,offset top1
        mov [si],bx
        jmp handle_end
        
        pop_stack_op:
            mov si,offset top1  ;top1--
            mov bx,[si]
            dec bx
            mov [si],bx
            dec bx
            mov si,offset stack_op ;now the stack_op[top1-1] is '+' or '-'??
            mov dl,[si+bx]
            jmp go_there
            
    handle_end:
        ret
        
;-----------------------print----------------------------
print proc near
    mov  dx,offset output_tips  ;output tips
    mov  ah,9 
    int  21h
    
    mov si,offset top2   ;print stack_data[top2-1]
    mov bx,[si]
    dec bx
    mov si,offset stack_data
    mov dl,[si+bx]
    add dl,48
    mov ah,2
    int 21h
    ret 
    
;--------------------------end--------------------------------------
stop:    
    .exit

end