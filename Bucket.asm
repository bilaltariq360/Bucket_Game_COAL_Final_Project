[org 0x0100]
                jmp start
lives: db 9
score: db 0
x: dw 0
y: dw 0
count: dd 0
temp: dw 0
temp2: dw 0
start_adOfDi: dw 0
end_adOfDi: dw 0
gameover: db 'Game Over!', 0
maindisplay: db 'Welcome to bucket collector game', 0
author: db 'Developed by Bilal Tariq', 0
header: db '================================= INSTRUCTIONS =================================', 0
inst1: db '1. You have 9 lives in this game', 0
inst2: db '2. If you do not collect nine foods your game will be over', 0
inst3: db '3. If you collect it your score will increament', 0
inst4: db '4. For right movement of bucket press or hold d key', 0
inst5: db '5. For left movement of bucket press or hold a key', 0
inst6: db 'Press h key to continue', 0
scorestr: db 'Score: ', 0
livestr: db 'Lives: ', 0
numToStr: db '0', 0
c: dw 0


alldisplay:     call clrscr
                
                mov ax, 25
                push ax
                mov ax, 9
                push ax
                mov ax, 0x0002
                push ax
                mov ax, maindisplay
                push ax
                call printstr

                mov ax, 29
                push ax
                mov ax, 11
                push ax
                mov ax, 0x0002
                push ax
                mov ax, author
                push ax
                call printstr

                mov ax, 29
                push ax
                mov ax, 14
                push ax
                mov ax, 0x0005
                push ax
                mov ax, inst6
                push ax
                call printstr

                mov ah, 00h
                int 16h

                cmp al, 'h'
                jne alldisplay

againinst:      call clrscr
                
                mov ax, 0
                push ax
                mov ax, 0
                push ax
                mov ax, 0x0002
                push ax
                mov ax, header
                push ax
                call printstr

                mov ax, 0
                push ax
                mov ax, 3
                push ax
                mov ax, 0x0006
                push ax
                mov ax, inst1
                push ax
                call printstr

                mov ax, 0
                push ax
                mov ax, 4
                push ax
                mov ax, 0x0006
                push ax
                mov ax, inst2
                push ax
                call printstr

                mov ax, 0
                push ax
                mov ax, 5
                push ax
                mov ax, 0x0006
                push ax
                mov ax, inst3
                push ax
                call printstr

                mov ax, 0
                push ax
                mov ax, 6
                push ax
                mov ax, 0x0006
                push ax
                mov ax, inst4
                push ax
                call printstr

                mov ax, 0
                push ax
                mov ax, 7
                push ax
                mov ax, 0x0006
                push ax
                mov ax, inst5
                push ax
                call printstr

                mov ax, 0
                push ax
                mov ax, 9
                push ax
                mov ax, 0x0005
                push ax
                mov ax, inst6
                push ax
                call printstr

                mov ah, 00h
                int 16h

                cmp al, 'h'
                jne againinst

ret

printstr:       push bp
                mov bp, sp
                push es
                push ax
                push cx
                push si
                push di
                push ds
                pop es
                mov di, [bp+4]
                mov cx, 0xffff
                xor al, al
                repne scasb
                mov ax, 0xffff
                sub ax, cx
                dec ax
                jz exitprnt
                mov cx, ax
                mov ax, 0xb800
                mov es, ax
                mov al, 80
                mul byte [bp+8]
                add ax, [bp+10]
                shl ax, 1
                mov di,ax
                mov si, [bp+4]
                mov ah, [bp+6]
                cld
nextchar:       lodsb
                stosw
                loop nextchar

exitprnt:         pop di
                pop si
                pop cx
                pop ax
                pop es
                pop bp
ret 8

clrscr:          push es 
                 push ax 
                 push cx 
                 push di 

                 mov ax,0xb800
                 mov es,ax
                 xor di, di
                 mov ax, 0x0720
                 mov cx, 2000
                 cld
                 rep stosw

                 pop di 
                 pop cx 
                 pop ax 
                 pop es 
ret


printpaddle:    
                push bp
                mov bp,sp
                push ax
                push es
                push di
                push cx

                mov ax, 0xb800
                mov es,ax
                call clrscr

                mov ax, 2
                push ax
                mov ax, 0
                push ax
                mov ax, 0x0002
                push ax
                mov ax, scorestr
                push ax
                call printstr

                mov dl, byte[score]
                add dl, 48
         
                mov [numToStr], dl

                mov ax, 10
                push ax
                mov ax, 0
                push ax
                mov ax, 0x0002
                push ax
                mov ax, numToStr
                push ax
                call printstr

                mov ax, 68
                push ax
                mov ax, 0
                push ax
                mov ax, 0x0002
                push ax
                mov ax, livestr
                push ax
                call printstr

                mov dl, byte[lives]
                add dl, 48
         
                mov [numToStr], dl

                mov ax, 76
                push ax
                mov ax, 0
                push ax
                mov ax, 0x0002
                push ax
                mov ax, numToStr
                push ax
                call printstr

                cmp word[bp+4],3840
                jb exit2
                cmp word[bp+4],3988
                ja exit2
                mov di,[bp+4]

                mov word[start_adOfDi], di
                mov cx,10
                mov ax,0x7720
                cld
                lodsb
                rep stosw

                mov word[end_adOfDi], di

exit2:          pop cx
                pop di
                pop es
                pop ax
                pop bp
ret 2 


movleft:        push bp
                mov bp,sp
                push ax
                push es
                push di
                push cx

                cmp di,3842
                jb exit1
                mov di,[bp+4]
                sub di,2
                push di

                call printpaddle


exit1:          pop cx
                pop cx
                pop es
                pop ax
                pop bp
ret 2


movright:       push bp
                mov bp,sp
                push ax
                push es
                push di
                push cx

                cmp di,3978
                ja exit
                mov di,[bp+4]
                add di,2
                push di

                call printpaddle


exit:           pop cx
                pop cx
                pop es
                pop ax
                pop bp
ret 2

food:         
                push bp
                mov bp,sp
                push di
                push bx
                push cx
                push ax
                push dx
                push es
                push si

                mov word[temp],di

                mov ah, 00h     
                int 1Ah   
                
                mov  ax, dx
                xor  dx, dx
                mov  cx,25
                div  cx   
                mov word[y],dx

                mov ah, 00h     
                int 1Ah         

                mov  ax, dx
                xor  dx,dx
                mov  cx,160
                div  cx   
                mov word[x],dx
                mov ax,[y]
                mov bx,80
                mul bx
                add ax,[x]
                shl ax,1
                mov bx ,3200
                div bx
                mov di,dx

                mov ax,di
                mov bl,160 
                div bl
                mov bl,25
                sub bl,al
                xor cx,cx
                mov cl,bl
                dec cl
                mov word[c], cx

                mov ax,0xb800
                mov es,ax

                mov ax,0x442A
                add di,160
                mov [es:di],ax


foodDown:       mov ax,0x442A
                add di,160
                mov [es:di],ax

                mov word[temp2],di

   	            mov dword[count],60000
n1:             dec dword[count]
	            cmp dword[count],0
	            jne  n1

                push word[temp]

                call printpaddle

                xor ax,ax
                mov ah, 01h
                int 16h
                jz continue
                mov ah, 00h
                int 16h
    
                cmp al,'d'
                jne moveleft2
  
                mov di ,[temp]
                push di

                call movright

                mov  word[temp],di
                jmp continue
   
moveleft2:      cmp al,'a'
                jne continue
 
                mov di ,[temp]
                push di

                call movleft

                mov  word[temp],di
    

continue:       dec word[c]
                mov cx,[c]
                mov di,word[temp2]
                loop foodDown
           
                pop si
                pop es
                pop dx
                pop ax
                pop cx
                pop bx
                pop dx
                pop bp
                
                cmp di, [start_adOfDi]
                jb minus
                cmp di, [end_adOfDi]
                ja minus
                inc byte [score]

backToReturn:   mov di ,[temp]
ret

minus:         dec byte [lives]
               jz endClrScr
               jmp backToReturn

endClrScr:     call clrscr
               mov ax, 35
               push ax
               mov ax, 12
               push ax
               mov ax, 0x0002
               push ax
               mov ax, gameover
               push ax
               call printstr

               mov ax, 36
                push ax
                mov ax, 13
                push ax
                mov ax, 0x0006
                push ax
                mov ax, scorestr
                push ax
                call printstr

                mov dl, byte[score]
                add dl, 48
         
                mov [numToStr], dl

                mov ax, 43
                push ax
                mov ax, 13
                push ax
                mov ax, 0x0006
                push ax
                mov ax, numToStr
                push ax
                call printstr

               jmp end

start:          mov di,3920
                call alldisplay


loopMain:       mov ax ,di
                push ax

                call printpaddle

                call food

next:           jmp loopMain

end:            mov ah ,4ch
                int 21h