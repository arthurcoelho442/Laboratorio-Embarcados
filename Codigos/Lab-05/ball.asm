;-----------------------------------------------------------------------------
;
; Função ball
;
global ball

extern full_circle, delay, cor, x_canva, y_canva

ball:
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
	RET

adjust_direction:
	; Ajusta a direção
	CMP		byte[direcao], angulo45
	JNE		J135
	CALL	adjustment_45
	RET
	J135:
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

%include "Data.asm"