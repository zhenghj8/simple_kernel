extern  macro %1    ;ͳһ��extern�����ⲿ��ʶ��
	extrn %1
endm


extern _cmain:near

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
        call near ptr _cmain
        jmp  $
        
        include fun.asm        
        include proctr.asm

_TEXT ends

_DATA segment word public 'DATA'
_DATA ends

_BSS	segment word public 'BSS'
_BSS ends

end start
