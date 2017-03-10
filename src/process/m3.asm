org 100h					; ������ص�����������
start:

        
	xor ax,ax				; AX = 0   
        mov ax,cs
	mov ds,ax					
	mov es,ax		
	mov ax,0B800h				; �ı������Դ���ʼ��ַ
	mov es,ax			        ; es=b800h 		

loop1:                                          ; ��ʱ��ʾ
	dec word[count]				; �ݼ���������
	jnz loop1				; >0����ת;
	mov word[count],delay
	dec word[dcount]			; �ݼ���������
        jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay

name_num:                                       ;��ʾ����ѧ��
       
        mov cx,11
        mov si,name
        mov bx,(18*80+15)*2
        mov di,name
       
dispstr1:                                       ;��ʾ����
        mov al,[di]
        mov [es:bx],al
        inc bx
        inc di
        mov al,[color]
        mov [es:bx],al
        inc bx
        ;inc byte[color]                       ;�ı���ɫ
        loop dispstr1
       

        mov cx,8
        mov bx,(19*80+16)*2
        mov di,number

dispstr2:                                      ;��ʾѧ��
        mov al,[di]
        mov [es:bx],al
        inc bx
        inc di
        mov al,[color]
        mov [es:bx],al
        inc bx
        ;inc byte[color]                       ;�ı���ɫ
        loop dispstr2


dispchar:
        mov al,1                               ;��̬��ʾ�ַ�
        cmp al,byte[rdul]                      ;�ж��˶�״̬
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

DnRt:                                         ;�����˶�
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
                                           ;����
        mov word[x],23
        mov byte[rdul],Up_Rt	
        jmp show
dr2dl:
        
        mov word[y],38
        mov byte[rdul],Dn_Lt	
        jmp show

UpRt:                                        ;�����˶�
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

	
	
UpLt:                                       ;�����˶�
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

	
	
DnLt:                                     ;�����˶�
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
	
show:	                               ; ��ʾ�ַ�
        mov bx,word[x]                 ; �м�λ�÷�����ʾ
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
        xor ax,ax                      ; �����Դ��ַ
        mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bx,ax
	mov ah,[color2]	              
	inc byte [color2]
        mov al,byte[char]              ; AL = ��ʾ�ַ�ֵ
        inc byte [char]
	mov word[es:bx],ax  	       ; ��ʾ�ַ���ASCII��ֵ


show2:	
       mov  ax,[count1]
       dec  ax
       
       mov  [count1],ax
       cmp  ax,1

       jnz loop1
	
end:
         jmp $
                                ; ֹͣ��������ѭ�� 
	
datadef:	
	count dw delay
	dcount dw ddelay
        rdul db Dn_Rt                  ; ��ʼ���������˶�
        x dw 12
	y dw -1
	char db 'A' 
        name db "ZhengHuijie"
        number db"13349161"
        color db 0eh
        color2 db 0eh
        count1 dw 430
Dn_Rt equ 1                            ; �趨�����˶�״̬��ֵ
Up_Rt equ 2                  
Up_Lt equ 3                  
Dn_Lt equ 4                  
delay equ 8000		               ; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
ddelay equ 580		               ; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�

times 510-($-$$) db 0   ; $=��ǰ��ַ��$$=��ǰ�ڵ�ַ
                                ; д�����������Ľ�����־
	db 55h,0aah
