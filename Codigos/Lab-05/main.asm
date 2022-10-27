; versão de 18/10/2022
; Uso de diretivas extern e global 
; Professor Camilo Diaz

extern line, square, full_circle, circle, cursor, caracter, plot_xy, delay, ball
global cor, x_canva, y_canva, velocidade
segment code

;org 100h
..start:
	MOV     AX,data			;Inicializa os registradores
	MOV 	DS,AX
	MOV 	AX,stack
	MOV 	SS,AX 
	MOV 	SP,stacktop

	;Salvar modo corrente de video(vendo como esta o modo de video da maquina)
	MOV  	AH,0Fh
	INT  	10h
	MOV  	[modo_anterior],AL   

	;Alterar modo de video para grafico 640x480 16 cores
	MOV     AL,12h
	MOV     AH,0
	INT     10h
		
	;desenha Retangulo
	MOV		byte [cor],branco_intenso	;retangulo
	MOV		AX,0                     	;x1
	PUSH	AX
	MOV		AX,0                    	;y1
	PUSH	AX
	MOV		AX,	[x_canva]	            ;x2
	PUSH	AX
	MOV		AX, [y_canva]               ;y2
	PUSH	AX
	CALL	square

program:
	; Movimento Bolinha
	call	ball
	; 	Verifica Termino do Programa
	JMP 	verify

verify:
    mov     ah,0bh
    int     21h         ; Le buffer de teclado
    cmp     al,0        ; Se AL =0 nada foi digitado. Se AL =255 então há algum caracter na STDIN
    jne     escape
    jmp     program      ; se AL = 0 então nada foi digitado e a animação do jogo deve continuar

escape:
    mov     ah, 08H     ; Ler caracter da STDIN
    int     21H
    cmp     al, 27      ; Verifica se foi Esc. Se foi, finaliza o programa
    jne     program
    jmp     finish

finish:
    mov  	ah,0    			; set video mode
    mov  	al,[modo_anterior]  ; modo anterior
    int  	10h
    mov     ax,4c00h
    int     21h

;*************************************************************************
segment data
cor		db		branco_intenso

;	I R G B COR
;	0 0 0 0 preto
;	0 0 0 1 azul
;	0 0 1 0 verde
;	0 0 1 1 cyan
;	0 1 0 0 vermelho
;	0 1 0 1 magenta
;	0 1 1 0 marrom
;	0 1 1 1 branco
;	1 0 0 0 cinza
;	1 0 0 1 azul claro
;	1 0 1 0 verde claro
;	1 0 1 1 cyan claro
;	1 1 0 0 rosa
;	1 1 0 1 magenta claro
;	1 1 1 0 amarelo
;	1 1 1 1 branco intenso
preto		    equ		0
azul		    equ		1
verde		    equ		2
cyan		    equ		3
vermelho	    equ		4
magenta		    equ		5
marrom		    equ		6
branco		    equ		7
cinza		    equ		8
azul_claro	    equ		9
verde_claro	    equ		10
cyan_claro	    equ		11
rosa		    equ		12
magenta_claro	equ		13
amarelo		    equ		14
branco_intenso	equ		15
modo_anterior	db		0
x_canva			dw		639
y_canva			dw		479
velocidade      dw      1
segment stack stack
		DW 		512
stacktop: