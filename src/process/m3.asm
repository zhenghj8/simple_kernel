org 100h					; 程序加载到主引导扇区
start:

        
	xor ax,ax				; AX = 0   
        mov ax,cs
	mov ds,ax					
	mov es,ax		
	mov ax,0B800h				; 文本窗口显存起始地址
	mov es,ax			        ; es=b800h 		

loop1:                                          ; 延时显示
	dec word[count]				; 递减计数变量
	jnz loop1				; >0：跳转;
	mov word[count],delay
	dec word[dcount]			; 递减计数变量
        jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay

name_num:                                       ;显示姓名学号
       
        mov cx,11
        mov si,name
        mov bx,(18*80+15)*2
        mov di,name
       
dispstr1:                                       ;显示姓名
        mov al,[di]
        mov [es:bx],al
        inc bx
        inc di
        mov al,[color]
        mov [es:bx],al
        inc bx
        ;inc byte[color]                       ;改变颜色
        loop dispstr1
       

        mov cx,8
        mov bx,(19*80+16)*2
        mov di,number

dispstr2:                                      ;显示学号
        mov al,[di]
        mov [es:bx],al
        inc bx
        inc di
        mov al,[color]
        mov [es:bx],al
        inc bx
        ;inc byte[color]                       ;改变颜色
        loop dispstr2


dispchar:
        mov al,1                               ;动态显示字符
        cmp al,byte[rdul]                      ;判断运动状态
	jz  DnRt
        mov al,2
        cmp al,byte[rdul]    
	jz  UpRt
        mov al,3
        cmp al,byte[rdul]    
	jz  UpLt
        mov al,4
        cmp al,byte[rdul]    
	jz  DnLt
        jmp $	

DnRt:                                         ;右下运动
	inc word[x]
	inc word[y]
	mov bx,word[x]
	mov ax,25
	sub ax,bx
        jz  dr2ur
	mov bx,word[y]
	mov ax,40
	sub ax,bx
        jz  dr2dl
	jmp show
dr2ur:    
                                           ;反射
        mov word[x],23
        mov byte[rdul],Up_Rt	
        jmp show
dr2dl:
        
        mov word[y],38
        mov byte[rdul],Dn_Lt	
        jmp show

UpRt:                                        ;右上运动
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,40
	sub ax,bx
        jz  ur2ul
	mov bx,word[x]
	mov ax,12
	sub ax,bx
        jz  ur2dr
	jmp show
ur2ul:
        
        mov word[y],38
        mov byte[rdul],Up_Lt	
        jmp show
ur2dr:
        
        mov word[x],14
        mov byte[rdul],Dn_Rt	
        jmp show

	
	
UpLt:                                       ;左上运动
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,12
	sub ax,bx
        jz  ul2dl
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
        jz  ul2ur
	jmp show

ul2dl:
        
        mov word[x],14
        mov byte[rdul],Dn_Lt	
        jmp show
ul2ur:
        
        mov word[y],1
        mov byte[rdul],Up_Rt	
        jmp show

	
	
DnLt:                                     ;左下运动
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
        jz  dl2dr
	mov bx,word[x]
	mov ax,25
	sub ax,bx
        jz  dl2ul
	jmp show

dl2dr:
        
        mov word[y],1
        mov byte[rdul],Dn_Rt	
        jmp show
	
dl2ul:
       
        mov word[x],23
        mov byte[rdul],Up_Lt	
        jmp show
	
show:	                               ; 显示字符
        mov bx,word[x]                 ; 中间位置方框不显示
        mov ax,17                      
        sub ax,bx
        ja  show1
        mov ax,20
        sub ax,bx
        jl  show1
        mov bx,word[y]
        mov ax,13
        sub ax,bx
        ja  show1
        mov ax,28
        sub ax,bx
        ja  show2

show1:  
        xor ax,ax                      ; 计算显存地址
        mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bx,ax
	mov ah,[color2]	              
	inc byte [color2]
        mov al,byte[char]              ; AL = 显示字符值
        inc byte [char]
	mov word[es:bx],ax  	       ; 显示字符的ASCII码值


show2:	
       mov  ax,[count1]
       dec  ax
       
       mov  [count1],ax
       cmp  ax,1

       jnz loop1
	
end:
         jmp $
                                ; 停止画框，无限循环 
	
datadef:	
	count dw delay
	dcount dw ddelay
        rdul db Dn_Rt                  ; 初始化向右下运动
        x dw 12
	y dw -1
	char db 'A' 
        name db "ZhengHuijie"
        number db"13349161"
        color db 0eh
        color2 db 0eh
        count1 dw 430
Dn_Rt equ 1                            ; 设定各个运动状态的值
Up_Rt equ 2                  
Up_Lt equ 3                  
Dn_Lt equ 4                  
delay equ 8000		               ; 计时器延迟计数,用于控制画框的速度
ddelay equ 580		               ; 计时器延迟计数,用于控制画框的速度

times 510-($-$$) db 0   ; $=当前地址、$$=当前节地址
                                ; 写入启动扇区的结束标志
	db 55h,0aah
