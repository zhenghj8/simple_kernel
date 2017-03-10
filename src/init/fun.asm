extern _disp_pos
extern _a
extern _count
extern _ch
extern _num
extern _k
extern _i33
extern _i34
extern _i35
extern _i36
extern _num1
extern _num2
extern _num3
extern _upper
extern _lower
extern _tovalue
extern _tochar 
extern _ch2
extern _length    
extern _value

;******************************************
public _cls

_cls proc 
              ; 清屏
        
push ax
        
push bx
        
push cx
        
push dx		
			
mov	ax, 600h	; AH = 6,  AL = 0
			
mov	bx, 700h	; 黑底白字(BL = 7)
			
mov	cx, 0		; 左上角: (0, 0)
			
mov	dx, 184fh	; 右下角: (24, 79)
				
int	10h		; 显示中断
		
pop dx
		
pop cx
		
pop bx
		
pop ax
        		
ret

_cls endp


;*********************************************


;*******************************************
public _read1
_read1 proc
xor  ax,ax 		; 相当于mov ax,0
mov  es,ax 		; ES=0
mov  bx,9400H           ; ES:BX=读入数据到内存中的存储地址
mov  ah,2 		; 功能号
mov  al,1 		; 要读入的扇区数
mov  dl,0 		; 软盘驱动器号（对硬盘和U盘，此处的值应改为80H）
mov  dh,0 		; 磁头号
mov  ch,0 		; 柱面号
mov  cl,7 		; 起始扇区号（编号从1开始）
int  13H 		; 调用13H号中断
ret 
_read1 endp
;*********************************************


;*********************************************
public _exc1
_exc1 proc
mov   ax,9400h
call  ax
ret
_exc1 endp
;**********************************************


;********************************************
public _read2
_read2 proc
xor  ax,ax 		; 相当于mov ax,0
mov  es,ax 		; ES=0
mov  bx,9600H            ; ES:BX=读入数据到内存中的存储地址
mov  ah,2 		; 功能号
mov  al,1 		; 要读入的扇区数
mov  dl,0 		; 软盘驱动器号（对硬盘和U盘，此处的值应改为80H）
mov  dh,0 		; 磁头号
mov  ch,0 		; 柱面号
mov  cl,8 		; 起始扇区号（编号从1开始）
int  13H 		; 调用13H号中断
ret 
_read2 endp
;*********************************************


;*********************************************
public _exc2
_exc2 proc
mov   ax,9600h
call  ax
ret
_exc2 endp
;**********************************************


;********************************************
public _read3
_read3 proc
xor  ax,ax 		; 相当于mov ax,0
mov  es,ax 		; ES=0
mov  bx,9800H            ; ES:BX=读入数据到内存中的存储地址
mov  ah,2 		; 功能号
mov  al,1 		; 要读入的扇区数
mov  dl,0 		; 软盘驱动器号（对硬盘和U盘，此处的值应改为80H）
mov  dh,0 		; 磁头号
mov  ch,0 		; 柱面号
mov  cl,9 		; 起始扇区号（编号从1开始）
int  13H 		; 调用13H号中断
ret 
_read3 endp
;*********************************************


;*********************************************
public _exc3
_exc3 proc
mov   ax,9800h
call  ax
ret
_exc3 endp
;**********************************************


;**************************************************
public _time 
_time proc
push bp
    
push es
	
push ax
        
xor ax,ax		         ; AX = 0
mov es,ax		         ; ES = 0
mov ax,offset Timer
mov es:[20h],ax	                 ; 设置时钟中断向量的偏移地址
mov ax,cs 
mov es:[22h],ax		         ; 设置时钟中断向量的段地址=CS
	  
pop ax
	
pop es
	
pop bp

ret			         ; 返回
                           
	                         ; 时钟中断处理程序
Timer:
push bp
    
push es
	
push ax
        
push bx
mov ax,0b800h
mov es,ax
dec [_count]		         ; 递减计数变量
jnz d			         ; >0：跳转
	
mov al,byte ptr [_num]
cmp al,4
jnz next
mov ax,0
mov [_num],ax
next:
mov bx,[_num]
mov al,byte ptr [_ch+bx]
mov ah,07h
mov es:[(24*80+79)*2],ax	; =0：递增显示字符的ASCII码值
mov es:[(24*80+78)*2],ax
mov es:[(24*80+77)*2],ax
inc [_num]
mov ax,4
mov [_count],ax		        ; 重置计数变量=初值delay
d:
mov al,20h			; AL = EOI
out 20h,al			; 发送EOI到主8529A
out 0A0h,al			; 发送EOI到从8529A  
pop bx
pop ax
	
pop es
	
pop bp

iret
_time endp


;**************************************************




;**************************************************
public _keyboard 
_keyboard proc
push bp
    
push es
	
push ax
        
xor ax,ax		    ; AX = 0
mov es,ax		    ; ES = 0
mov ax,offset key
mov es:[24h],ax	            ; 设置中断向量的偏移地址
mov ax,cs 
mov es:[26h],ax		    ; 设置中断向量的段地址=CS
	  
pop ax
	
pop es
	
pop bp

ret			    ; 返回
                           
	                    ; 中断处理程序
key:
push bp
    
push es
	
push ax
        
push bx
push cx
mov ax,0b800h
mov es,ax
mov cx,10
mov ax,80*4
mov di,ax
mov bx,0
lp:
mov al,byte ptr [_k+bx]
mov ah,0ch
mov es:[di],ax
mov es:[di+80],ax
inc bx
add di,2
loop lp
mov al,20h			; AL = EOI
out 20h,al			; 发送EOI到主8529A
out 0A0h,al			; 发送EOI到从8529A  
pop cx
pop bx
pop ax
	
pop es
	
pop bp

iret
_keyboard endp


;**************************************************




;**************************************************
public _int33 
_int33 proc
push bp
    
push es
	
push ax
        
xor ax,ax		    ; AX = 0
mov es,ax		    ; ES = 0
mov ax,offset it33
mov es:[51*4],ax	            ; 设置中断向量的偏移地址
mov ax,cs 
mov es:[51*4+2],ax		    ; 设置中断向量的段地址=CS
	  
pop ax
	
pop es
	
pop bp

ret			    ; 返回
                           
	                    ; 中断处理程序
it33:
push bp    
push es	
push ax        
push bx
push cx
mov ax,0b800h
mov es,ax
mov cx,15
mov ax,80*8
mov di,ax
mov bx,0
lp33:
mov al,byte ptr [_i33+bx]
mov ah,07h
mov es:[di],ax
inc bx
add di,2
loop lp33
mov al,20h			; AL = EOI
out 20h,al			; 发送EOI到主8529A
out 0A0h,al			; 发送EOI到从8529A  
pop cx
pop bx
pop ax
	
pop es
	
pop bp

iret
_int33 endp


;**************************************************



;**************************************************
public _int34 
_int34 proc
push bp
    
push es
	
push ax
        
xor ax,ax		    ; AX = 0
mov es,ax		    ; ES = 0
mov ax,offset it34
mov es:[52*4],ax	            ; 设置中断向量的偏移地址
mov ax,cs 
mov es:[52*4+2],ax		    ; 设置中断向量的段地址=CS
	  
pop ax
	
pop es
	
pop bp

ret			    ; 返回
                           
	                    ; 中断处理程序
it34:
push bp
    
push es
	
push ax
        
push bx
push cx
mov ax,0b800h
mov es,ax
mov cx,15
mov ax,80*20
mov di,ax
mov bx,0
lp34:
mov al,byte ptr [_i34+bx]
mov ah,07h
mov es:[di],ax
inc bx
add di,2
loop lp34
mov al,20h			; AL = EOI
out 20h,al			; 发送EOI到主8529A
out 0A0h,al			; 发送EOI到从8529A  
pop cx
pop bx
pop ax
	
pop es
	
pop bp

iret
_int34 endp


;**************************************************



;**************************************************
public _int35 
_int35 proc
push bp
    
push es
	
push ax
        
xor ax,ax		    ; AX = 0
mov es,ax		    ; ES = 0
mov ax,offset it35
mov es:[53*4],ax	            ; 设置中断向量的偏移地址
mov ax,cs 
mov es:[53*4+2],ax		    ; 设置中断向量的段地址=CS
	  
pop ax
	
pop es
	
pop bp


ret			    ; 返回
                           
	                    ; 中断处理程序
it35:
push bp
    
push es
	
push ax
        
push bx
push cx
mov ax,0b800h
mov es,ax
mov cx,15
mov ax,80*32
mov di,ax
mov bx,0
lp35:
mov al,byte ptr [_i35+bx]
mov ah,07h
mov es:[di],ax
inc bx
add di,2
loop lp35
mov al,20h			; AL = EOI
out 20h,al			; 发送EOI到主8529A
out 0A0h,al			; 发送EOI到从8529A  
pop cx
pop bx
pop ax
	
pop es
	
pop bp

iret
_int35 endp


;**************************************************



;**************************************************
public _int36 
_int36 proc
push bp
    
push es
	
push ax
        
xor ax,ax		    ; AX = 0
mov es,ax		    ; ES = 0
mov ax,offset it36
mov es:[54*4],ax	            ; 设置中断向量的偏移地址
mov ax,cs 
mov es:[54*4+2],ax		    ; 设置中断向量的段地址=CS
	  
pop ax
	
pop es
	
pop bp


ret			    ; 返回
                           
	                    ; 中断处理程序
it36:
push bp
    
push es
	
push ax
        
push bx
push cx
mov ax,0b800h
mov es,ax
mov cx,15
mov ax,80*44
mov di,ax
mov bx,0
lp36:
mov al,byte ptr [_i36+bx]
mov ah,07h
mov es:[di],ax
inc bx
add di,2
loop lp36
mov al,20h			; AL = EOI
out 20h,al			; 发送EOI到主8529A
out 0A0h,al			; 发送EOI到从8529A  
pop cx
pop bx
pop ax
	
pop es
	
pop bp

iret
_int36 endp


;**************************************************


;**************************************************
public _intr
_intr proc
push ax
        
push bx
        
push cx
        
push dx	
int 33h
int 34h
int 35h
int 36h
pop dx
		
pop cx
		
pop bx
		
pop ax
    
ret
_intr endp
;**************************************************



;******************************************
public _delay
_delay proc 
                   
push ax
        
push bx
        
push cx
        
push dx		
			
push es
push bp			
mov	cx, 0
l1:
push cx
mov cx,0f000h
l2:
loop l2
pop cx
loop l1		

pop bp
pop es				
pop dx
		
pop cx
		
pop bx
		
pop ax
        		
ret

_delay endp


;*********************************************


;******************************
public _getch
_getch proc
push bp
    
push es
	
push ax
    	
mov bp,sp


mov ah,0eh
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov ah,0
int 16h
mov dl,0
mov ah,0eh
int 10h

mov  bx,word ptr [bp+2+2+2+2]
mov byte ptr [bx],al

mov ah,0eh
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov sp,bp
    
pop ax
	
pop es
	
pop bp
	
ret

_getch endp
;********************************


;******************************
public _putch
_putch proc
push bp
    
push es
	
push ax
    	
mov bp,sp

mov bx,word ptr [bp+2+2+2+2]
mov al,byte ptr [bx]


mov ah,0eh
mov dl,0
int 10h

mov ah,0eh
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov sp,bp
    
pop ax
	
pop es
	
pop bp
	
ret

_putch endp
;********************************



;********************************
public _getstr
_getstr proc
push bp
push es
push ax

mov bp,sp
mov bx,word ptr [bp+2+2+2+2]
get:
mov ah,0
int 16h
mov byte ptr [bx],al
inc bx
mov dl,0
mov ah,0eh
int 10h
cmp al,0dh
jnz get
dec bx
mov byte ptr [bx],0

mov ah,0eh
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov sp,bp
pop ax
pop es
pop bp
ret
_getstr endp
;********************************



;********************************
public _putstr
_putstr proc
push bp
push es
push ax

mov bp,sp
mov bx,word ptr [bp+2+2+2+2]
put:
mov al,byte ptr [bx]
mov ah,0eh
mov dl,0
int 10h
inc bx
cmp al,0
jnz put

mov ah,0eh
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov sp,bp

pop ax
pop es
pop bp
ret
_putstr endp
;***********************************

;***********************************
public _scanf
_scanf proc
push bp
push es
push ax
mov bp,sp

get1:
mov ah,0
int 16h
mov dl,0
mov ah,0eh
int 10h

mov dl,al
cmp al,0dh
jnz tonum
mov bx,offset _num1
mov al,[bx]
mov bx,word ptr [bp+2+2+2+2]
mov byte ptr [bx],al

mov ah,0eh
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov sp,bp
pop ax
pop es
pop bp
ret

tonum:
mov bx,offset _num1
mov al,[bx]
mov cl,10
mul cl
sub dl,48
add al,dl
mov bx,offset _num1
mov byte ptr [bx],al
jmp get1

_scanf endp
;********************************


;********************************
public _print
_print proc
push bp
push es
push ax
mov bp,sp
mov bx,word ptr [bp+2+2+2+2]
mov al,byte ptr [bx]
mov bx,offset _num2
mov byte ptr [bx],al
mov cx,0
store:
xor ah,ah
mov dl,10
div dl
inc bx
add ah,48
mov byte ptr [bx],ah
inc cx
cmp al,0
jnz store
put1:
mov dl,0
mov al,byte ptr [bx]
mov ah,0eh
int 10h
dec bx
loop put1

mov ah,0eh
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov sp,bp
pop ax
pop es
pop bp
ret

_print endp
;********************************


;********************************
public _printf
_printf proc
push bp
push es
push ax
mov bp,sp

mov ah,0eh
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov bx,word ptr [bp+2+2+2+2]
mov al,byte ptr [bx]
mov ah,0eh
mov dl,0
int 10h
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov bx,word ptr [bp+2+2+2+2+2]
put2:
mov dl,0
mov al,byte ptr [bx]
mov ah,0eh
int 10h
inc bx
cmp al,00h
jnz put2
mov ah,0eh
mov al,0dh
mov dl,0
int 10h
mov al,0ah
int 10h

mov bx,word ptr [bp+2+2+2+2+2+2]
mov al,byte ptr [bx]
mov bx,offset _num3
mov byte ptr [bx],al
mov cx,0
store1:
xor ah,ah
mov dl,10
div dl
inc bx
add ah,48
mov byte ptr [bx],ah
inc cx
cmp al,0
jnz store1
put3:
mov dl,0
mov al,byte ptr [bx]
mov ah,0eh
int 10h
dec bx
loop put3

mov sp,bp
pop ax
pop es
pop bp
ret

_printf endp
;********************************


;********************************
;**    function int 21
;********************************
public _load_int21
_load_int21 proc
        push  bp
                                   ;装21号中断功能
        push  es
	
        push  ax
  
	xor   ax,ax
	mov   es,ax
	mov   word ptr es:[4*33],offset syscall
        mov   ax,cs
	mov   word ptr es:[4*33+2],ax
        pop  ax
	
        pop  es
	
        pop  bp

        ret
   
syscall:                                          ;21号中断程序
     push bp
    
     push es
	
        
     push bx
     cmp ah,0
     je  fno0
     cmp ah,1
     je  fno1
     cmp ah,2
     je  j0
     cmp ah,3
     je  j1
     cmp ah,4
     je  j2
     cmp ah,5
     je  j3
     pop bx
	
     pop es
	
     pop bp

     iret
j0:
     jmp fno2
j1:
     jmp fno3
j2:
     jmp fno4
j3:
     jmp fno5
fno0:                                            ;0号功能
     mov ax,0b800h
     mov es, ax
     mov bx,(2*80+38)*2
     mov ah,0fh
     mov al,'O'
     mov es:[bx],al
     mov es:[bx+1],ah
     mov al,'U'
     mov es:[bx+2],al
     mov es:[bx+3],ah
     mov al,'c'
     mov es:[bx+4],al
     mov es:[bx+5],ah
     mov al,'h'
     mov es:[bx+6],al
     mov es:[bx+7],ah
     mov al,'!'
     mov es:[bx+8],al
     mov es:[bx+9],ah 
     pop bx
	
     pop es
	
     pop bp

     iret

fno1:                                               ;1号功能
     mov word ptr [_length],cx
     mov di,offset _ch2
     mov si,bx
lp1:
     mov ah,es:[bx]
     mov byte ptr [di],ah
     add bx,2
     inc di
     loop lp1
     mov cx,word ptr [_length]   
     call near ptr _upper
     mov di,offset _ch2
     mov bx,si
lpp1:   
     mov ah,byte ptr [di]
     mov es:[bx],ah
     add bx,2
     inc di
     loop lpp1
     pop bx

	
     pop es
	
     pop bp

     iret


fno2:                                                ;2号功能
     mov word ptr [_length],cx
     mov di,offset _ch2
     mov si,bx
lp2:
     mov ah,es:[bx]
     mov [di],ah
     add bx,2
     inc di
     loop lp2
     mov cx,word ptr [_length]     
     call near ptr _lower
     mov di,offset _ch2
     mov bx,si
lpp2:   
     mov ah,byte ptr [di]
     mov es:[bx],ah
     add bx,2
     inc di
     loop lpp2
     pop bx

	
     pop es
	
     pop bp

     iret

fno3:                                                 ;3号功能
     push es
     push bx
     mov word ptr [_length],cx
     mov di,offset _ch2
     pop bx
     pop es 
lp3:
     mov ah,es:[bx]
     mov [di],ah
     add bx,2
     inc di
     loop lp3   
     call near ptr _tovalue
     mov ax,word ptr [_value]
     pop bx

	
     pop es
	
     pop bp

     iret
fno4:                                                  ;4号功能
     push es
     push bx
     mov word ptr [_value],dx
     call near ptr _tochar
     mov cx,word ptr [_length]
     mov ax,word ptr [_length]
     dec ax
     mov di,offset _ch2
     add di,ax
     pop bx
     pop es
lpp4:
     mov ah,byte ptr [di]
     mov es:[bx],ah
     inc bx
     mov ah,0ch
     mov es:[bx],ah
     inc bx
     dec di
     loop lpp4
     pop bx

	
     pop es
	
     pop bp
 
     iret
fno5:                                                 ;5号功能
     add cx,cx
     mov word ptr [_length],cx
     mov di,offset _ch2
lp5:
     mov ah,es:[bx]
     mov byte ptr [di],ah
     inc bx
     inc di
     loop lp5
     mov cx,word ptr [_length]     
     mov di,offset _ch2
     mov ah,0
     mov al,dh
     mov dh,80
     mul dh
     adc al,dl
     add ax,ax
     mov bx,ax
lpp5:   
     mov ah,byte ptr [di]
     mov es:[bx],ah     
     inc bx
     inc di
     loop lpp5
     pop bx

     pop es
	
     pop bp

     iret  
_load_int21 endp
;*************************************




;********************************
;*       show int 21h 
;********************************
public _Sh_int21
_Sh_int21 proc
        push ax
        push bx
        push cx
        push dx
        push es
        xor ax,ax		  ; AX = 0   
        mov ax,cs
	mov ds,ax					
	mov es,ax
    
       mov ah,0                   ;0号功能
       int 21h
       call ddd

       mov ax,0b800h              ;1号功能
       mov es,ax
       mov ah,1
       mov bx,(2*80+38)*2
       mov cx,5
       int 21h
       call ddd

       mov ah,2                    ;2号功能
       mov bx,(2*80+38)*2
       mov cx,5
       int 21h
       call ddd

       mov ah,5                    ;5号功能
       mov bx,(2*80+38)*2
       mov cx,5
       mov dh,5
       mov dl,37
       int 21h
       call ddd
 
       mov ax,0b800h                ;在屏幕中间输出"1234"
       mov es,ax
       mov bx,(3*80+38)*2
       mov ah,0ch
       mov al,'1'
       mov word ptr es:[bx],ax
       add bx,2
       mov al,'2'
       mov word ptr es:[bx],ax
       add bx,2
       mov al,'3'
       mov word ptr es:[bx],ax
       add bx,2
       mov al,'4'
       mov word ptr es:[bx],ax
       
       mov ax,0b800h                ;3号功能
       mov es,ax
       mov bx,(3*80+38)*2
       mov ah,3      
       mov cx,4
       int 21h

       mov dx,ax                    ;4号功能
       mov ax,0b800h
       mov es,ax      
       mov bx,(4*80+38)*2
       mov ah,4
       int 21h
       call ddd

   
       pop es
       pop dx
       pop cx
       pop bx
       pop ax
       ret    


ddd:
       mov cx,0
delay10:                            ;延时
       push cx
       mov cx,0
delay20:
       loop delay20
       pop cx
       loop delay10
       ret

_Sh_int21 endp
;**********************************


;**********************************
public _setcur
_setcur proc   
push ax
        
push bx
        
push cx
        
push dx		
			
mov ah,02h
mov bh,0
mov dh,0
mov dl,0
int 10h		
pop dx
		
pop cx
		
pop bx
		
pop ax
        		
ret

_setcur endp


;*********************************************
