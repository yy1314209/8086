.model flat 
.stack 1024
.data
input_tips db "input the N:$"
output_tips db 10,13,"the N! is:$"
n      dw 0,0
op1    db 0,0,0,0         ;the first op
op2    db 50 dup(0)   ;the second op
result db 50 dup(0)  ;the result  or intermedium result
multiFlag   dw 0,0
addFlag    dw 0,0          
i      dw  0,0
j      dw  0,0

.code
.startup

;---------------main-----------------------------
main proc near
    mov  dx,offset input_tips  ;output tips
    mov  ah,9
    int  21h
    input_loop:            
        call input
        cmp  al,48
        jb   input_end
        mov  bx,offset n
        mov  dl,[bx]
        push ax
        mov  al,10
        mul  dl
        mov  dl,al
        pop  ax
        sub  al,48
        add  al,dl
        mov  [bx],al
        jmp  input_loop
    input_end:
    mov  bx,offset n
    mov  al,[bx]    
    cmp  al,8
    ja   greater_than_8
    mov  ch,0
    mov  cl,al
    mov  dx,0
    mov  ax,1
    mov  bx,0
    less_than_8:
        call fac
        jmp print
    greater_than_8:
        cmp  al,9
        ja   multiLargeNum
        call fac_spe
        mov  bx,offset result
        mov  ax,[bx]
        mov  dx,[bx+2]
        jmp  print
        multiLargeNum:
                    call init
                    mov  bx,offset n
                    mov  ax,[bx]
                    mov  cx,ax
                    sub  cx,9
                    multi_loop:
                        ;call clear_result
                        call multiLarge
                        mov  bx,offset op1
                        mov  dl,[bx]  
                        inc  dl      ;op1++
                        mov  [bx],dl
                        call copy
                        loop multi_loop
                        call print_large
                        jmp stop 
    print:
    call output
    jmp  stop

main endp
;---------------input----------------------    
input proc near
    mov ah,1
    int 21h
    ret
input endp

;---------------fac-----------------------------
fac proc near
    mult:
        inc  bx
        mul  bx
        loop  mult
    mov  dx,0
    mov  bx,offset result
    mov  [bx],ax
    ret
fac  endp

;--------------fac_spe----------------------------
fac_spe proc near
    mov  cx,8
    mov  dx,0
    mov  ax,1
    mov  bx,0
    call fac
    mov  cx,9
    sub  cx,9
    mov  bx,8
    next:
        inc  bx
        mul  bx
    mov  bx,offset result
    mov  [bx],ax
    mov  [bx+2],dx 
    ret
;---------------init-------------------------------
init proc near
    mov  bx,offset op2
    ;mov  byte ptr[bx],0
    ;inc  bx
    mov  byte ptr[bx],0
    inc  bx
    mov  byte ptr[bx],8
    inc  bx
    mov  byte ptr[bx],8
    inc  bx
    mov  byte ptr[bx],2
    inc  bx
    mov  byte ptr[bx],6
    inc  bx
    mov  byte ptr[bx],3
    inc  bx
    mov  byte ptr[bx],10  ;flag
    
    mov  bx,offset op1
    mov  byte ptr[bx],0
    inc  bx
    mov  byte ptr[bx],1
    inc  bx
    mov  byte ptr[bx],10  ;flag
    ret

;----------------copy--------------------------------
copy proc near
    push cx
    mov  cx,30
    mov  si,offset op2
    mov  di,offset result
    copy_next:
    mov  al,[di]
    mov  [si],al
    mov  byte ptr[di],0
    inc  si
    inc  di
    loop copy_next
    mov  bx,0
    mov  si,offset i
    add  bx,[si]
    mov  si,offset j
    add  bx,[si]
    mov  si,offset op2
    dec  bx
    mov  dx,[si+bx]
    cmp  dx,0
    je   over_inc
    inc  bx
    over_inc:
        mov  byte ptr[si+bx],10
    pop  cx
    ret
    
;----------------clear_result----------------------
clear_result proc near
    push cx
    mov  cx,30
    mov  di,offset result
    clear_next:
        mov  byte ptr[di],0
        inc  di
        loop  clear_next
    ret   
;---------------multiLarge-------------------------
multiLarge proc near
    mov  bx,offset op1
    mov  dl,[bx]   ;in  op
    mov  si,offset i  ;initial i
    mov  [si],0
    loop1:
         cmp dl,10
         je  back
         mov si,offset multiFlag
         mov word ptr[si],0
         mov si,offset addFlag
         mov word ptr[si],0
         mov  di,offset op2
         mov  dh,[di]   ;in op2
         mov  si,offset j  ;initial j
         mov  [si],0
    loop2:
         cmp  dh,10
         je   readytoLoop1
         push dx
         mov  al,dl
         mul  dh  ;al
         mov  si,offset multiFlag
         mov  dl,[si]
         add  al,dl
         mov  dl,10
         div  dl   ;ah reminder  al shiwei
         mov  si,offset multiFlag
         mov  [si],al
         ;mov  al,ah
         mov  si,offset i
         mov  al,[si]
         mov  si,offset j
         add  al,[si]
         push ax
         mov  ah,0
         mov  si,offset result
         add  si,ax
         mov  dl,[si]
         pop  ax
         mov  al,ah
         mov  ah,0
         add  al,dl
         mov  si,offset addFlag
         mov  si,[si]
         add  ax,si
         mov  dl,10
         div  dl  ;ah reminder  al shiwei
         mov  si,offset addFlag
         mov  [si],al
         mov  si,offset i
         mov  dx,[si]
         mov  si,offset j
         add  dx,[si]
         mov  si,offset result
         add  si,dx
         mov  [si],ah
         
         mov  si,offset j    ;j++
         mov  ax,[si]
         inc  ax
         mov  [si],ax
         pop  dx
         inc  di
         mov  dh,[di]
         jmp  loop2
              
    readytoLoop1:
         mov  si,offset j  ; result[i + m] += multiFlag + addFlag;
         mov  dx,[si]
         mov  si,offset i
         add  dx,[si]
         mov  si,offset result
         add  si,dx
         push si
         mov  al,[si]
         mov  si,offset multiFlag
         add  al,[si]
         mov  si,offset addFlag
         add  al,[si]
         pop  si
         mov  [si],al
         ;mov  ax,10  ;flag
         ;inc  si
         ;mov  [si],ax
           
         mov  si,offset i  
         mov  ax,[si]
         inc  ax      ;i++
         mov  [si],ax
         inc  bx
         mov  dl,[bx]
         jmp  loop1
    back:
        ret
        

;---------------output-----------------------------
output proc near
    push dx
    push ax
    mov  dx,offset output_tips  ;output tips
    mov  ah,9 
    int  21h
    pop  ax 
    pop  dx
    MOV  BX, 10
    MOV  CX, 0
L1:
    DIV  BX
    PUSH DX
    INC  CX
    AND  AX, AX
    mov  dx,0
    JNZ  L1
L2:
    POP  DX
    ADD  DL, 48
    MOV  AH, 2
    INT  21H
    LOOP L2
    ret

;-----------------print_large------------------------------    
print_large proc near
    mov  dx,offset output_tips  ;output tips
    mov  ah,9 
    int  21h
    mov  cx,0
    mov  si,offset i
    add  cx,[si]
    mov  si,offset j
    add  cx,[si]
    mov  si,offset op2
    dec  cx
    mov  bx,cx
    mov  dl,[si+bx]
    cmp  dl,0
    je   do_nothing
    print_loop:
         mov  bx,cx 
         mov  dl,[si+bx]
         add  dl,48
         mov  ah,2
         int  21h
         loop print_loop
         mov  bx,cx 
         mov  dl,[si+bx]
         add  dl,48
         mov  ah,2
         int  21h
         ret
          
    do_nothing:
         dec  cx
         jmp  print_loop
       
stop:

.exit

end