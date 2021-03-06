mess macro msg ;Macro Definition. mess is macro name and msg is parameter name
mov ah,09h     ;Wrties string of msg to STDOUT
lea dx,msg     ;09h expects offset addrss of string in dx
int 21h        ;DOS interrupt
endm           ;Ends Macro


.model small   

.data

msg1 db 10,13, 'Enter first 32-bit Integer: $'
msg2 db 10,13, 'Enter second 32-bit Integer: $'
msg3 db 10,13, 'Result for Addition: $'


n1 db 0h   	;for accept
n2 dw 0h   	;first number's higher part
n3 dw 0h 	;first number's lower part
n4 db 0h 	;for display	
n5 dw 0h 	;second number's higher part
n6 dw 0h 	;second number's lower part

.code

mov ax,@data
mov ds,ax


mess msg1

call accept
mov ah,n1
mov al,0h
mov n2,ax

call accept
mov ah,0h
mov al,n1
add n2,ax

call accept
mov ah,n1
mov al,0h
mov n3,ax

call accept
mov ah,0h
mov al,n1
add n3,ax


mess msg2

call accept
mov ah,n1
mov al,0h
mov n5,ax

call accept
mov ah,0h
mov al,n1
add n5,ax

call accept
mov ah,n1
mov al,0h
mov n6,ax

call accept
mov ah,0h
mov al,n1
add n6,ax

mov ax,n6
add n3,ax
mov ax,n5
adc n2,ax


mess msg3

mov ax,n2
mov n4,ah
call disp

mov ax,n2
mov n4,al
call disp

mov ax,n3
mov n4,ah
call disp

mov ax,n3
mov n4,al
call disp

mov ah,4ch
int 21h

accept proc near
mov ah,01h       ;Read character from STDIN and is stored in ah
int 21h        
cmp al,3Ah       ;Compare to find if it's a number or a alphabet
jc down1         ;Jumps if it's a number
sub al,07h       ;Subtract 7 if it's a alphabet
down1: AND al,0Fh;AND to keep only rightmost 4 numbers(0000XXXX) 
ror al,04h       ;Rotate 4 places to right to get XXXX0000
mov n1,al        ;Move XXXX0000 to n1

mov ah,01h       ;Accepting the unit placed part of number
int 21h     
cmp al,3Ah       
jc down2
sub al,07h
down2: AND al,0Fh;Produces 0000YYYY
add n1,al        ;Add 0000YYYY to XXXX0000
ret
endp

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






