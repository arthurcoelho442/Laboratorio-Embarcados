; versão de 18/10/2022
; Uso de diretivas extern e global 
; Professor Camilo Diaz

extern line, square, full_circle, circle, cursor, caracter, plot_xy, delay
global cor, velocidade

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
	;	Desenha circulo Vermelho
	MOV		byte [cor],vermelho	;cabeça
	MOV		AX , [x_pos]		;x
	PUSH	AX
	MOV		AX , [y_pos]		;y
	PUSH	AX
	MOV		AX , [raio_bola]	;r
	PUSH	AX
	CALL	full_circle

	;	Delay
	CALL	delay
	
	;	Desenha circulo Preto
	MOV		byte [cor],preto	;cabeça
	MOV		AX , [x_pos]		;x
	PUSH	AX
	MOV		AX , [y_pos]		;y
	PUSH	AX
	MOV		AX , [raio_bola]	;r
	PUSH	AX
	CALL	full_circle
	
	CALL 	adjust_direction

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

adjust_direction:
	; Ajusta a direção
	CMP		byte[direcao], angulo45
	JNE		J135
	CALL	adjustment_45
	RET
	J135:
		RET
 		CMP		byte[direcao], angulo135
		JNE		J225
		CALL	adjustment_135
		RET
	J225:
		CMP		byte[direcao], angulo225
		JNE		J315
		CALL	adjustment_225
		RET	
	J315:
		CALL	adjustment_315
		RET

adjustment_45:
	; Pega posição atual
	CALL	current_position
	
	ADD		BX, [raio_bola]
	ADD		CX, [raio_bola]

	; Comparação X
	CMP 	BX,		[x_canva]	; Compara no eixo X a posição da bolinha com o canva do jogo
	JE		R135				; Ajusta posição para 135° caso bata na parede Direita
	; Comparação Y
	CMP 	CX,		[y_canva]	; Compara no eixo Y a posição da bolinha com o canva do jogo
	JE		R315				; Ajusta posição para 315° caso bata no Teto
	
	; Anda em 45°
	INC 	BX
	INC 	CX

	; Remove Raio
	SUB		BX, [raio_bola]
	SUB		CX, [raio_bola]

	CALL	save_position
	RET

adjustment_135:
	; Pega posição atual
	CALL	current_position
	
	SUB		BX, [raio_bola]
	ADD		CX, [raio_bola]

	; Comparação X
	CMP 	BX,		0			; Compara no eixo X a posição da bolinha com o canva do jogo
	JE		R45					; Ajusta posição para 135° caso bata na parede Esquerda
	; Comparação Y
	CMP 	CX,		[y_canva]	; Compara no eixo Y a posição da bolinha com o canva do jogo
	JE		R225				; Ajusta posição para 315° caso bata no Teto

	; Anda em 135°
	DEC 	BX
	INC 	CX

	; Remove Raio
	ADD		BX, [raio_bola]
	SUB		CX, [raio_bola]

	call save_position
	RET

R45:
	MOV		byte[direcao], angulo45
	CALL	adjustment_45
	RET
R135:
	MOV		byte[direcao], angulo135
	CALL	adjustment_135
	RET
R225:
	MOV		byte[direcao], angulo225
	CALL	adjustment_225
	RET
R315:
	MOV		byte[direcao], angulo315
	CALL	adjustment_315
	RET

adjustment_225:
	; Pega posição atual
	CALL	current_position
	
	SUB		BX, [raio_bola]
	SUB		CX, [raio_bola]

	; Comparação X
	CMP 	BX,		0			; Compara no eixo X a posição da bolinha com o canva do jogo
	JE		R315				; Ajusta posição para 135° caso bata na parede Esquerda
	; Comparação Y
	CMP 	CX,		0			; Compara no eixo Y a posição da bolinha com o canva do jogo
	JE		R135					; Ajusta posição para 315° caso bata no Base

	; Anda em 225°
	DEC 	BX
	DEC 	CX

	; Remove Raio
	ADD		BX, [raio_bola]
	ADD		CX, [raio_bola]

	call save_position
	RET
adjustment_315:
	; Pega posição atual
	CALL	current_position
	
	ADD		BX, [raio_bola]
	SUB		CX, [raio_bola]

	; Comparação X
	CMP 	BX,		[x_canva]	; Compara no eixo X a posição da bolinha com o canva do jogo
	JE		R225				; Ajusta posição para 135° caso bata na parede Direita
	; Comparação Y
	CMP 	CX,		0			; Compara no eixo Y a posição da bolinha com o canva do jogo
	JE		R45					; Ajusta posição para 315° caso bata no Base

	; Anda em 315°
	INC 	BX
	DEC 	CX

	; Remove Raio
	SUB		BX, [raio_bola]
	ADD		CX, [raio_bola]

	call save_position
	RET

current_position:
	; Posição atual bolinha
	MOV		BX, [x_pos] ; x
	MOV		CX, [y_pos] ; y
	RET

save_position:
	; Salva posição
	MOV 	[x_pos], BX
	MOV 	[y_pos], CX
	RET
;*******************************************************************

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

direcao			db		10
;
; D = Direita
; E = Esquerda
; C = Cima
; B = Baixo
;
; 	D E C B DIRECAO
;;;;;;;;;;;;;;;
;	1 0 1 0  /|
;			/
;;;;;;;;;;;;;;;
;	1 0 0 1 \
;			 \|
;;;;;;;;;;;;;;;
;	0 1 1 0 |\
;			  \
;;;;;;;;;;;;;;;
;	0 1 0 1   /
;			|/
;;;;;;;;;;;;;;;

angulo45		equ		10
angulo315		equ		9
angulo135		equ		6
angulo225		equ		5

modo_anterior	db		0
linha   	    dw  	0
coluna  	    dw  	0
deltax		    dw		0
deltay		    dw		0	

velocidade      dw      1

x_canva			dw		639
y_canva			dw		479

x_pos			dw		320
y_pos			dw		240

raio_bola		dw		10

;*************************************************************************
segment stack stack
		DW 		512
stacktop: