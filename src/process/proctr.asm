extern _count
extern _ch
extern _num


extern _Current_Process
extern _Save_Process
extern _Schedule
extern _special
extern _Program_Num
extern _CurrentPCBno
extern _Segment


extern _do_fork
extern _do_wait
extern _do_exit
extern _SemGet
extern _SemFree
extern _do_p
extern _do_v


;************************************
public _another_load
_another_load proc
    push ax
	push bp
	
	mov bp,sp
	
    mov ax,[bp+6]      	
	mov es,ax          	
	mov bx,100h        	
	mov ah,2           	
	mov al,2          	
	mov dl,0          	
	mov dh,1          	
	mov ch,0          	
	mov cl,[bp+8]      
	int 13H          	
	
	pop bp
	pop ax
	
	ret
_another_load endp
;*****************************************



;*****************************************
Finite dw 0	
Pro_Timer:
;*****************************************
;*                Save                   *
; ****************************************
    cmp word ptr[_Program_Num],0
	jnz Save
	jmp No_Progress
Save:
	inc word ptr[Finite]
	cmp word ptr[Finite],1600
	jnz Lee 
        mov word ptr[_CurrentPCBno],0
	mov word ptr[Finite],0
	mov word ptr[_Program_Num],0
	mov word ptr[_Segment],2000h
	jmp Pre
Lee:
    push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
	call near ptr _Schedule 
	
Pre:
	mov ax, cs
	mov ds, ax
	mov es, ax
	
	call near ptr _Current_Process
	mov bp, ax

	mov ss,word ptr ds:[bp+0]         
	mov sp,word ptr ds:[bp+16] 

	cmp word ptr ds:[bp+32],0 
	jnz No_First_Time

;*****************************************
;*                Restart                *
; ****************************************
Restart:
        call near ptr _special
	
	push word ptr ds:[bp+30]
	push word ptr ds:[bp+28]
	push word ptr ds:[bp+26]
	
	push word ptr ds:[bp+2]
	push word ptr ds:[bp+4]
	push word ptr ds:[bp+6]
	push word ptr ds:[bp+8]
	push word ptr ds:[bp+10]
	push word ptr ds:[bp+12]
	push word ptr ds:[bp+14]
	push word ptr ds:[bp+18]
	push word ptr ds:[bp+20]
	push word ptr ds:[bp+22]
	push word ptr ds:[bp+24]

	pop ax
	pop cx
	pop dx
	pop bx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	pop fs
	pop gs
	.8086

	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

No_First_Time:	
	add sp,16 
	jmp Restart
	
No_Progress:
       call another_Timer
	
	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret
;********************************************
	
	
;********************************************
;*             时钟中断                     *
;********************************************
SetTimer: 
    push ax
    mov al,34h    
    out 43h,al   
    mov ax,29830 
    out 40h,al    
    mov al,ah     
    out 40h,al 
	pop ax
	ret

public _setClock
_setClock proc
        push ax
	push bx
	push cx
	push dx
	push ds
	push es
	
        call SetTimer
        xor ax,ax
	mov es,ax
	mov word ptr es:[20h],offset Pro_Timer
	mov ax,cs
	mov word ptr es:[22h],cs
	
	pop ax
	mov es,ax
	pop ax
	mov ds,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_setClock endp
;*****************************************


;******************************************
another_Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
    mov ax,cs
	mov ds,ax
    mov ax,0b800h
    mov es,ax
    dec [_count]		         
    jnz d1			             
	
mov al,byte ptr [_num]
cmp al,4
jnz next1
mov ax,0
mov [_num],ax
next1:
mov bx,[_num]
mov al,byte ptr [_ch+bx]
mov ah,07h
mov es:[(24*80+79)*2],ax	
mov es:[(24*80+78)*2],ax
mov es:[(24*80+77)*2],ax
inc [_num]
mov ax,4
mov [_count],ax		        
        
        
	
d1:	
	pop ax
	mov ds,ax
	pop ax
	mov es,ax
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;*********************************************

;
;*********************************************
;*              栈段复制                     *
;*********************************************
public _stackcopy
_stackcopy proc
    push ax
    push cx
	push bp
	push di
	push es
    push ds
	mov bp,sp
    mov ax,word ptr [bp+16]
    mov es,ax
    mov ax,word ptr [bp+14]
    mov ds,ax
    mov di,100h
    mov cx,80h
copyst:
    mov ax,word ptr ds:[di]
    mov word ptr es:[di],ax
    sub di,2
    loop copyst
    
    pop ds
    pop es
    pop di
	pop bp
	pop cx
	pop ax
	
	ret
_stackcopy endp
;*****************************************



;*****************************************
;*      int37封装fork                    *
;*****************************************
public _set_int37 
_set_int37 proc
push bp
push es
push ax
        
xor ax,ax		              ; AX = 0
mov es,ax		              ; ES = 0
mov ax,offset it37
mov es:[55*4],ax	          
mov ax,cs 
mov es:[55*4+2],ax		      
	  
pop ax
pop es
pop bp
ret			                 
                           
	                          
it37:
    push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax, cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
	call near ptr _do_fork 
	

	
	

_set_int37 endp
;********************************************

;*****************************************
;*           int38封装wait               *
;*****************************************
public _set_int38 
_set_int38 proc
push bp
push es
push ax
        
xor ax,ax		              ; AX = 0
mov es,ax		              ; ES = 0
mov ax,offset it38
mov es:[56*4],ax	          
mov ax,cs 
mov es:[56*4+2],ax		      
	  
pop ax
pop es
pop bp
ret			                  
                           
	                          
it38:

   push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
	call near ptr _do_wait
	
	
_set_int38 endp
;**************************************************



;*****************************************
;*           int39封装exit               *
;*****************************************
public _set_int39 
_set_int39 proc
push bp
push es
push ax
        
xor ax,ax		              ; AX = 0
mov es,ax		              ; ES = 0
mov ax,offset it39
mov es:[57*4],ax	          
mov ax,cs 
mov es:[57*4+2],ax		     
	  
pop ax
pop es
pop bp
ret			                  
                           
	                          
it39:
    push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
	call near ptr _do_exit
	
_set_int39 endp
;**************************************************


;**************************************************
public _pcb_restart
_pcb_restart proc
mov ax, cs
	mov ds, ax
	mov es, ax
	
	call near ptr _Current_Process
	mov bp, ax

	mov ss,word ptr ds:[bp+0]         
	mov sp,word ptr ds:[bp+16] 

	cmp word ptr ds:[bp+32],0 
	jnz No_First_Time4

;*****************************************
;*                Restart                *
; ****************************************
Restart4:
        call near ptr _special
	
	push word ptr ds:[bp+30]
	push word ptr ds:[bp+28]
	push word ptr ds:[bp+26]
	
	push word ptr ds:[bp+2]
	push word ptr ds:[bp+4]
	push word ptr ds:[bp+6]
	push word ptr ds:[bp+8]
	push word ptr ds:[bp+10]
	push word ptr ds:[bp+12]
	push word ptr ds:[bp+14]
	push word ptr ds:[bp+18]
	push word ptr ds:[bp+20]
	push word ptr ds:[bp+22]
	push word ptr ds:[bp+24]

	pop ax
	pop cx
	pop dx
	pop bx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	pop fs
	pop gs
	.8086

	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

No_First_Time4:	
	add sp,16 
	jmp Restart4

_pcb_restart endp
;****************************************


;*****************************************
;*             int33封装semget           *
;*****************************************
public _set_int_33 
_set_int_33 proc
push bp
push es
push ax
        
xor ax,ax		              ; AX = 0
mov es,ax		              ; ES = 0
mov ax,offset it_33
mov es:[51*4],ax	          
mov ax,cs 
mov es:[51*4+2],ax		      
	  
pop ax
pop es
pop bp
ret			                  
                           
	                          
it_33:
    mov bp,sp
    xor cx,cx
    mov cx,word ptr [bp+12]
    push cx
	call near ptr _SemGet
	pop cx
    iret
	
_set_int_33 endp
;**************************************************



;*****************************************
;*        int34封装semfree               *
;*****************************************
public _set_int_34 
_set_int_34 proc
push bp
push es
push ax
        
xor ax,ax		              ; AX = 0
mov es,ax		              ; ES = 0
mov ax,offset it_34
mov es:[52*4],ax	         
mov ax,cs 
mov es:[52*4+2],ax		      
	  
pop ax
pop es
pop bp
ret			                 
                           
	                         
it_34:
    mov bp,sp
    mov ax,word ptr [bp+12]
    push ax
	call near ptr _SemFree
	pop ax
    iret
	
_set_int_34 endp
;**************************************************



;*****************************************
;*      int35封装do_p                    *
;*****************************************
public _set_int_35 
_set_int_35 proc
push bp
push es
push ax
        
xor ax,ax		              ; AX = 0
mov es,ax		              ; ES = 0
mov ax,offset it_35
mov es:[53*4],ax	          
mov ax,cs 
mov es:[53*4+2],ax		      
	  
pop ax
pop es
pop bp
ret			                  
                           
	                          
it_35:

   push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
	mov bp,sp
    mov ax,word ptr [bp+38]
    push ax
	call near ptr _do_p
	pop ax

	.386
	pop gs
	pop fs
	.8086
	pop es
	pop ds
	pop di
	pop si
	pop bp
	pop sp
	pop dx
	pop cx
	pop bx
	pop ax
	pop ss
	iret
_set_int_35 endp
;**************************************************



;*****************************************
;*        int36封装do_v                  *
;*****************************************
public _set_int_36 
_set_int_36 proc
push bp
push es
push ax
        
xor ax,ax		              ; AX = 0
mov es,ax		              ; ES = 0
mov ax,offset it_36
mov es:[54*4],ax	          
mov ax,cs 
mov es:[54*4+2],ax		    
	  
pop ax
pop es
pop bp
ret			                 
                           
	                          
it_36:
    push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
	mov bp,sp
    mov ax,word ptr [bp+38]
    push ax
	call near ptr _do_v
	pop ax

	.386
	pop gs
	pop fs
	.8086
	pop es
	pop ds
	pop di
	pop si
	pop bp
	pop sp
	pop dx
	pop cx
	pop bx
	pop ax
	pop ss
	iret
_set_int_36 endp
;**************************************************


