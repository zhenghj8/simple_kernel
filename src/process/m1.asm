extern  macro %1    ;统一用extern导入外部标识符
extrn %1
endm


extern _main:near
.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT,ds:_DATA
DGROUP group _TEXT,_DATA,_BSS
org 100h
start:
	mov  ax,cs
	mov  ds,ax         ; DS = CS
	mov  es,ax         ; ES = CS
	mov  ss,ax         ; SS = cs
    mov  sp,100h
    call near ptr _main
    jmp  $





;*********************************
public _int37
_int37 proc
       
    push ax
    mov al,20h          ; AL = EOI
    out 20h,al          ; 发送EOI到主8529A
    out 0A0h,al         ; 发送EOI到从8529A
    pop ax  
    
int 37h  



ret
_int37 endp
;********************************


;*********************************
public _int_33
_int_33 proc
       
    push ax
    mov al,20h			; AL = EOI
    out 20h,al			; 发送EOI到主8529A
    out 0A0h,al			; 发送EOI到从8529A
    pop ax  
	
int 33h  



ret
_int_33 endp
;********************************


;*********************************
public _int_34
_int_34 proc


push ax
    mov al,20h			; AL = EOI
    out 20h,al			; 发送EOI到主8529A
    out 0A0h,al			; 发送EOI到从8529A
    pop ax  
	
int 34h


ret
_int_34 endp
;********************************


;*********************************
public _int_35
_int_35 proc

    push ax
    mov al,20h			; AL = EOI
    out 20h,al			; 发送EOI到主8529A
    out 0A0h,al			; 发送EOI到从8529A
    pop ax  
	
int 35h
 
ret
_int_35 endp
;********************************


;*********************************
public _int_36
_int_36 proc


push ax
    mov al,20h          ; AL = EOI
    out 20h,al          ; 发送EOI到主8529A
    out 0A0h,al         ; 发送EOI到从8529A
    pop ax  
    
int 36h


ret
_int_36 endp
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


_TEXT ends

_DATA segment word public 'DATA'
_DATA ends

_BSS	segment word public 'BSS'
_BSS ends

end start
