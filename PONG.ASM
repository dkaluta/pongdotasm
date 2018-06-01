;***************************************************************************************************************

;* Name of work: PONG.ASM                                                                                      *

;*                                                                                                             *

;* Student: David Kaluta                                                                                       *

;*                                                                                                             *

;* Twitter: @DavidKaluta                                                                                       *

;*                                                                                                             *

;* Yoana Jabotinsky High School,    Yud 5                                                                      *

;*                                                                                                             *

;* Laboratory experience unit: Computer organization and threshold language                                    *

;*                                                                                                             *

;* Development environment: TASM compiler, Sublime Text, Atom, Notepad++ on Windows 7 and macOS High Sierra    *

;*                                                                                                             *

;*Subject: Essentially a port of the classic Atari game PONG.                                                  *

;*                                                                                                             *

;* User guide:Press Esc to exit, W/S move left paddle, Up/Down move right paddle                               *

;***************************************************************************************************************

.model small

.data
;Variables
  scoreA db 30h 
  scoreB db 30h
  vx db 1
  vy db 1
  xBall db 12
  yBall db 39
  locA db 12 ;Location of left paddle
  locB db 12 ; Location of right paddle
  titlescreen db 'PONG.ASM$'
  subtitle db 'BY DAVID KALUTA$'
  p1wins db 'PLAYER 1 WINS!$'
  p2wins db 'PLAYER 2 WINS!$'
  pressesc db 'PRESS ANY KEY TO QUIT$'
  str db 'PRESS ANY KEY!$'
.stack 100h

.code

start:
  mov ax,@data
  mov ds,ax
  ;Commands
  ;title screen
  call clear
  call hide_cursor
  mov ah,2
  mov dh,10
  mov dl,32
  int 10h
  mov ah,9
  mov dx,offset titlescreen
  int 21h
  mov ah,2
  mov dh,11
  mov dl,29
  int 10h
  mov ah,9
  mov dx,offset subtitle
  int 21h
  mov ah,2
  mov dh,12
  mov dl,30
  int 10h
  mov ah,9
  mov dx,offset str
  int 21h
  mov ah,7
  int 21h
	;Getting ready
  call clear
  call start_point
next:
	; Getting everything printed
  call current_point
  call out_ball
  call start_point_paddle1
  call out_paddle
  sub locA,1
  call start_point_paddle1
  call out_paddle
  add locA,2
  call start_point_paddle1
  call out_paddle
  call start_point_paddle2
  call out_paddle
  sub locB,1
  call start_point_paddle2
  call out_paddle
  add locB,2
  call start_point_paddle2
  call out_paddle
  call scorea_point
  call out_scoreA
  call scoreb_point
  call out_scoreB
  sub locB,1
  sub locA,1
  ;Calling delay
  call delay
  
  call clear
	; Waiting for key: if key is ESC it exits the game, if W/S it moves left paddle, if Up/Down it moves right paddle
  call wait_key
  cmp al,27
  jz steppingst11
  cmp al,119
  jz steppingst12
  cmp al,115
  jz steppingst13
  cmp al,72
  jz steppingst14
  cmp al,80
  jz steppingst15
  push dx
  ; Checking if any score is above 9, if it is the game shows a game over screen
  mov dh,scoreA
  cmp dh,3ah
  je gameo;err
  mov dl,scoreB
  cmp dl,3ah
  je gameo;err
  ; Moving the ball
  mov dh,xBall
  mov dl,yBall
  ;Checking collision with up border
  cmp dl, 1	;upper border
  jg dn_border	;			  ---
  neg vy
  pop dx
  ; Actually move the ball and go on
aNuddaOne:  
  call move_ball
  call current_point  
  jmp next
;end the game
steppingst11:
jmp steppingst2
;move left paddle up
steppingst12:
jmp steppingstone7
;move left paddle down
steppingst13:
jmp steppingstone10
;move right paddle up
steppingst14:
jmp steppingstone9
;move right paddle down
steppingst15:
jmp steppingstone8
;going on and printing the ball, while popping dx after pushing it in a previous part
aNuddaNuddaOne:
  pop dx
  call move_ball
  call current_point  
  jmp next
;game over screen
gameo:
  call clear
  mov ah,2
  mov dh,10
  mov dl,30
  int 10h
  mov ah,9
  cmp scoreA,':'
  je AWins
  mov dx,offset p2wins
  int 21h
  jmp finish
AWins:
  mov dx,offset p1wins
  int 21h
finish:
  mov ah,2
  mov dh,11
  mov dl,28
  int 10h
  mov ah,9
  mov dx,offset pressesc
  int 21h
  mov ah,7
  int 21h
  jmp fin
;Check collision with the down border, if there is it makes ball go up instead of down
dn_border:
  cmp dl, 24
  jl lt_border
  neg vy	; \/
  jmp aNuddaOne	;----
;Check collision with the left border, if there is it gives P2 1 point
lt_border:
  cmp xBall, 1
  jg rt_border
  call addscoreb
  call start_point
  jmp next
;move down p1
 steppingstone10:
	jmp steppingstone3
;move up p1
steppingstone7:
	jmp steppingstone4
;move up p2
steppingstone8:
	jmp steppingstone5
;move up p2
steppingstone9:
	jmp steppingstone6
;go to end of cycle
steppingstone:
	jmp aNuddaOne
;end game
steppingst2:
	jmp fin
;go to go to end of cycle 
steppingsteppingstone:
	jmp steppingstone
;check collision with the right border, if there is add 1 point to player 2
rt_border:
  cmp xBall, 78
  jl collision1
  call addscorea
  call start_point
  jmp next
; going on and printing the ball, while popping dx after pushing it in a previous part
aNNNO:
jmp aNuddaNuddaOne
;Check collision with left paddle
collision1:
	cmp xBall,2
	jne collision2
	push dx
	mov dl,yBall
  mov dh,locA
  cmp dl,dh
  je negvx
  sub dh,1
  cmp dl,dh
  je negvx
  add dh,2
  cmp dl,dh
  je negvx
	pop dx
	jmp aNuddaOne
;Check collision with right paddle
collision2:
	cmp xBall,77
	jne steppingstone
	push dx
	mov dl,yBall	
	mov dh,locB
	cmp dl,dh
	je negvx
	sub dh,1
	cmp dl,dh
	je negvx
	add dh,2
  cmp dl,dh
  je negvx
	pop dx
	jmp steppingstone
;Make the ball go to the opposite direction (L<->R)
negvx:
  pop dx
  neg vx
  jmp aNuddaOne
  ;move down p1
steppingstone3:
	jmp movedownp1
;move up p1
steppingstone4:
	jmp moveupp1
;move down p2
steppingstone5:
	jmp movedownp2
;move up p2
steppingstone6:
	jmp moveupp2
;go to next cycle
steppingstpstn:
	jmp steppingstone
moveupp1:
	cmp locA,2
	jl steppingstpstn
	sub locA,1
	jmp steppingstpstn
movedownp1:
	cmp locA,24
	jg steppingstpstn
	add locA,1
	jmp aNuddaOne

moveupp2:
	cmp locB,2
	jl steppingstpstn
	sub locB,1
	jmp steppingstpstn
movedownp2:
	cmp locB,24
	jg steppingstpstn
	add locB,1
	jmp steppingstpstn
;exit to MS-DOS prompt
fin:
  call clear2
  call show_cursor
  mov ah,4ch
  int 21h
;wait for key W/O printing it
wait_key	proc
;  push ax
  push cx
  push dx
  push bx
  	mov ah, 6	;check without stop
  	mov dl, 0ffh
  	int 21h
  pop bx
  pop dx
  pop cx
;  pop ax
  	ret
wait_key	endp

;set coordinates for the start point of the ball
start_point	proc
  mov ah,2
  mov yBall,12	;line   	start point
  mov xBall,39	;column
  int 10h

  ret
start_point	endp
;set coordinates for printing score of player 1
scorea_point proc
  mov ah,2
  mov dh,4
  mov dl,4
  int 10h
  ret
scorea_point endp
;set coordinates for printing score of player 1
scoreb_point proc
  mov ah,2
  mov dh,4
  mov dl,74
  int 10h
  ret
scoreb_point endp
; use coordinates of ball to set the cursor there
current_point	proc
  mov ah,2
  mov dh,yBall	;line   
  mov dl,xBall	;column
  int 10h

  ret
current_point	endp
; use lpaddle location to set the cursor there
start_point_paddle1	proc
  mov ah,2
  mov dh,locA	;line   	start point
  mov dl,1	;column
  int 10h

  ret
start_point_paddle1 endp	
; use rpaddle location to set the cursor there
start_point_paddle2	proc
  mov ah,2
  mov dh,locB	;line   	start point
  mov dl,78	;column
  int 10h

  ret
start_point_paddle2	endp
;make the screen blue and clear
clear	proc;V
  push ax
  push cx
  push dx
  push bx

  mov ah,6	;rectangle shift up
  mov al,25	;lines number for shift
  mov ch,0	;borders:
  mov cl,0
  mov dh,24
  mov dl,79
  mov bh,0011111b	;new attributes
  int 10h

  pop bx
  pop dx
  pop cx
  pop ax
  ret
clear	endp
; add 1 to scoreA
addscorea proc
  push dx
  mov dl,scoreA
  add dl,1
  mov scoreA,dl
  pop dx
ret
addscorea endp
;add 1 to scoreB
addscoreb proc
  push dx
  mov dl,scoreB
  add dl,1
  mov scoreB,dl
  pop dx
ret
addscoreb endp
;return to regular MS-DOS colors
clear2	proc
  push ax
  push cx
  push dx
  push bx

  mov ah,6	;rectangle shift up
  mov al,25	;lines number for shift
  mov ch,0	;borders:
  mov cl,0
  mov dh,24
  mov dl,79
  mov bh,00000111b	;new attributes
  int 10h

  pop bx
  pop dx
  pop cx
  pop ax
  ret
clear2	endp
;unused
clear1	proc
  push ax
  push cx
  push dx
  push bx

  mov ah,6	;rectangle shift up
  mov al,17	;lines number for shift
  mov ch,4	;borders:
  mov cl,4
  mov dh,20
  mov dl,75
  mov bh,00111111b	;new attributes
  int 10h

  pop bx
  pop dx
  pop cx
  pop ax
  ret
clear1	endp
;hide the MS-DOS system cursor
hide_cursor	proc;V
  mov ah,1	;set cursor shape
  mov ch,1	;hides it if ch>cl
  mov cl,0
  int 10h
  ret
hide_cursor	endp
;show the MS-DOS system cursor
show_cursor	proc
  mov ah,1	;set cursor shape
  mov ch,9	;hides it if ch>cl
  mov cl,10
  int 10h
  ret
show_cursor	endp
;move the ball
move_ball 	proc
  mov ah, 2
  mov dh,yBall
  mov dl,xBall
  add dh, vy	;new point - y = y + vy
  add dl, vx	;	     x = x + vx
  int 10h	;go-go
  mov yBall,dh
  mov xBall,dl
  ret
move_ball	endp
;move paddle 1
move_paddle1 	proc
  mov ah, 2
  mov dh, locA	;new point - y = y + vy
  mov dl, 5	;	     x = x + vx
  int 10h	;go-go

  ret
move_paddle1	endp
;move paddle 2
move_paddle2 	proc
  mov ah, 2
  mov dh, locB	;new point - y = y + vy
  mov dl, 74	;	     x = x + vx
  int 10h	;go-go

  ret
move_paddle2	endp
;print the ball
out_ball proc
  push dx
  mov dx, 'O'
  int 21h
  pop dx
  ret
out_ball endp
;print a part of a paddle
out_paddle proc
  push dx
  mov dx, '#'
  int 21h
  pop dx
  ret
out_paddle endp
;print score of P1
out_scoreA proc
  push dx
  mov dl,scoreA
  int 21h
  pop dx
  ret
out_scoreA endp
;print score of P2
out_scoreB proc
  push dx
  mov dl,scoreB
  int 21h
  pop dx
  ret
out_scoreB endp
;delay proc (originally from movingb1.asm)
delay	proc
  push dx
  push ax
  push bx
  push cx

  mov ah,0
  int 1ah	;dx<-ticks
  mov bx,dx	;save old tick
  add bx,2	;set bx/18 sec of delay
repeat:
  int 1ah
  cmp dx,bx
  jl repeat

  pop cx
  pop bx
  pop ax
  pop dx
  ret
delay	endp

end start
