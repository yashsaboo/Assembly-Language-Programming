mess macro msg ;Macro Definition. mess is macro name and msg is parameter name
mov ah,09h     ;Wrties string of msg to STDOUT
lea dx,msg     ;09h expects offset addrss of string in dx
int 21h        ;DOS interrupt
endm           ;Ends Macro


.model small   

.data

msg1 db 10,13, 'Enter the first string: $'
msg2 db 10,13, 'Enter the second string: $'
msg3 db 10,13, 'Length: $'
msg4 db 10,13, 'Concat: $'

str1 db 10,?,10 dup('$')
str2 db 10,?,10 dup('$')
n1 db 0h   	;for accept
n2 db 0h   	;first number
n3 db 0h 	;second number
n4 db 0h 	;for display	
n5 dw 0h
n6 dw 0h

.code

mov ax,@data
mov ds,ax


mess msg1      
mov ah,0Ah
lea dx,str1
int 21h

mess msg2      
mov ah,0Ah
lea dx,str2
int 21h

lea si,str1
inc si
mov ah,[si]
mov n4,ah
mess msg3
call disp

l1:inc si
mov ah,[si]
cmp ah,24h
jne l1

dec si
dec si
dec cl
dec cl

lea di,str2
inc di

l2:
inc si
inc di
mov ah,24h
cmp [di],ah
je exit
mov ah,[di]
mov [si],ah
jmp l2


exit:
mess msg4
lea dx,str1
mov ah,09h
int 21h


mov ah,4ch
int 21h


disp proc near   
mov al,n4       ;Move n4 in al to display tens place
and al,0F0h     ;AND with F0 so that n4 is converted to XXXX0000
mov cl,04h      ;Move 4 to cl for number of rotation
ror al,cl       ;Rotate 4 places to right to get 0000XXXX
cmp al,0Ah      ;Compare it with A to find if it's no. or alpha
jc d1           ;Jump if it's a number
add al,07h      ;Add 7 if it's a number
d1:add al,30h   ;Add 30 to make it match to table
mov dl,al       ;Move it to dl register
mov ah,02h      ;Write character to STDOUT
int 21h         ;02h need the information to display in dl reg.

mov al,n4       ;Move n4 again in al to display units place
and al,0Fh      ;AND with 0F so that n4 is converted to 0000XXXX
cmp al,0Ah      
jc d2
add al,07h
d2:add al,30h
mov dl,al
mov ah,02h
int 21h
ret
endp

end






