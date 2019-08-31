mess macro msg ;Macro Definition. mess is macro name and msg is parameter name
mov ah,09h     ;Wrties string of msg to STDOUT
lea dx,msg     ;09h expects offset addrss of string in dx
int 21h        ;DOS interrupt
endm           ;Ends Macro


.model small   

.data

msg1 db 10,13, 'Enter first 8-bit Integer: $'
msg2 db 10,13, 'Enter second 8-bit Integer: $'
msg3 db 10,13, 'Result for Addition: $'
msg4 db 10,13, 'Result for Multiplication: $'


n1 dw 0h   	;for accept
n2 dw 0h   	;first number
n3 dw 0h 	;second number
n4 db 0h 	;for display	
n5 dw 0h
n6 dw 0h

.code

mov ax,@data
mov ds,ax


mess msg1      
call accept    
mov ax,n1
mov n2,ax

mess msg2
call accept
mov ax,n1
mov n3,ax

mov ax,n3
add ax,n2
mov n5,ax

mess msg3
mov ax,n5
mov n4,ah
call disp
mov ax,n5
mov n4,al
call disp

mess msg4
mov ax,n2	;For multiplying, one 8-bit value should be in al
mul n3

mov n3,ax
mov n5,dx

mov ax,n5
mov n4,ah
call disp
mov ax,n5
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
down1: AND al,0Fh;AND to keep only rightmost 4 numbers(0000WWWW) 
ror al,04h       ;Rotate 4 places to right to get WWWW0000
mov ah,al 		 ;Gets WWWW0000 WWWW0000
mov al,00h 		 ;Gets WWWW0000 00000000
mov n1,ax        ;Move WWWW0000 to n1

mov ah,01h       ;Read character from STDIN and is stored in ah
int 21h        
cmp al,3Ah       ;Compare to find if it's a number or a alphabet
jc down2         ;Jumps if it's a number
sub al,07h       ;Subtract 7 if it's a alphabet
down2: AND al,0Fh;AND to keep only rightmost 4 numbers(0000XXXX) 
mov ah,al 		 ;Gets 0000XXXX 0000XXXX
mov al,00h 		 ;Gets 0000XXXX 00000000
add n1,ax        ;0000XXXX to n1(WWWW0000) = WWWWXXXX 00000000 

mov ah,01h       ;Read character from STDIN and is stored in ah
int 21h        
cmp al,3Ah       ;Compare to find if it's a number or a alphabet
jc down3         ;Jumps if it's a number
sub al,07h       ;Subtract 7 if it's a alphabet
down3: AND al,0Fh;AND to keep only rightmost 4 numbers(0000YYYY) 
ror al,04h       ;Rotate 4 places to right to get YYYY0000
mov ah,00h
add n1,ax        ;Move YYYY0000 to n1

mov ah,01h       ;Accepting the unit placed part of number
int 21h     
cmp al,3Ah       
jc down4
sub al,07h
down4: AND al,0Fh;Produces 0000ZZZZ
mov ah,00h
add n1,ax        ;0000ZZZZ + YYYY0000 = YYYYZZZZ
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






