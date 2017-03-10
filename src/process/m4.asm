org 100h
start:
        xor ax,ax				; AX = 0   
        mov ax,cs
	mov ds,ax					
	mov es,ax
        mov ax,0b800h
        mov es,ax
        mov cx,6
        mov bx,(13*80+44)*2
        mov si,(14*80+46)*2
loo:
        push cx
        mov ah,byte [color]
        mov al,byte [char]
        
        mov word [es:bx],ax
        call increase
        mov word [es:bx+10],ax
        call increase
        mov word [es:bx+20],ax
        call increase
        mov word [es:bx+30],ax
        call increase
        mov word [es:bx+40],ax
        call increase
        mov word [es:bx+50],ax
        call increase
        mov word [es:bx+60],ax
       
        call dd
        
        
        
        mov ah,byte [color]
        mov al,byte [char]
        mov word [es:si],ax
        call increase
        mov word [es:si+10],ax
        call increase
        mov word [es:si+20],ax
        call increase
        mov word [es:si+30],ax
        call increase
        mov word [es:si+40],ax
        call increase
        mov word [es:si+50],ax
        call increase
        mov word [es:si+60],ax
        
        call dd
        pop cx
        add bx,2*80*2
        add si,2*80*2
        loop loo
cls:
        mov	ax, 600h	; AH = 6,  AL = 0
			
        mov	bx, 700h	; 黑底白字(BL = 7)
			
        mov	cx, 0e28h	; 左上角: (14,40)
			
        mov	dx, 184fh	; 右下角: (24, 79)
				
        int	10h		; 显示中断
		
        jmp start
        
dd:
       mov cx,1000
delay1:     
       push cx                       ;延时
       mov cx,0
delay2:
       loop delay2
       pop cx
       loop delay1
       ret
       

increase:
     inc byte [color]
     inc byte [char]
     mov ah,byte [color]
     mov al,byte [char]
     ret
color:
     db 0ch
char:
     db 'a'

        times 510-($-$$) db 0             ; $=当前地址、$$=当前节地址
        db 55h,0aah                       ; 写入启动扇区的结束标志
 