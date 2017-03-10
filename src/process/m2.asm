org 100h
start:
        xor ax,ax				; AX = 0   
        mov ax,cs
	mov ds,ax					
	mov es,ax	
        mov ax,0b800h
        mov es,ax
clock:	
    mov al,[count]
    dec al
    mov [count],al
    cmp al,1
    jnz lp
    mov al,100
    mov [count],al
    inc byte [char]
    inc byte [color]
lp:
    mov cx,28  
    mov bx,(2*80+45)*2
    mov al,[char]
    mov ah,[color]
lp1:
    mov word [es:bx],ax
    inc bx
    inc bx
    loop lp1

    mov cx,28   
    mov bx,(8*80+45)*2
    mov al,[char]
    mov ah,[color]
lp2:
    mov word [es:bx],ax
    inc bx
    inc bx
    loop lp2    

    mov bx,(3*80+45)*2
    mov cx,5
lp3:
    mov word [es:bx],ax
    add bx,80*2
    loop lp3

    mov bx,(3*80+45+27)*2
    mov cx,5
lp4:
    mov word [es:bx],ax
    add bx,80*2
    loop lp4

    mov ah,2h
    int 1ah
    mov ax,0b800h
    mov es,ax
    mov bx,(5*80+55)*2
    xor ah,ah
    mov al,ch
    call h_2_d
    call showt
    add bx,4
    mov al,':'
    mov ah,0ch
    mov word [es:bx],ax
    add bx,2
    xor ah,ah
    mov al,cl
    call h_2_d
    call showt
    add bx,4
    mov al,':'
    mov ah,0ch
    mov word [es:bx],ax
    add bx,2
    xor ah,ah
    mov al,dh
    call h_2_d
    call showt
    jmp clock
	
h_2_d:
  mov dl,16
  div  dl
  add al,48
  add ah,48
  ret	
showt:
  mov [es:bx],al
  mov byte [es:bx+1],0ch
  mov [es:bx+2],ah
  mov byte [es:bx+3],0ch
  ret
	
     
char db 'a'      
color db 0fh  
count db 100  

times 510-($-$$) db 0   ; $=当前地址、$$=当前节地址
                                ; 写入启动扇区的结束标志
	db 55h,0aah

