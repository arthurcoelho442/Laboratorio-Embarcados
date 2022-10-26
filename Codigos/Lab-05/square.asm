;-----------------------------------------------------------------------------
;
; Função square
; PUSH x1; PUSH y1; PUSH x2; PUSH y2; CALL square;  (x<639, y<479)
;
global square

extern plot_xy, line
		
square: ;desenhar retas
	PUSH 	BP
	MOV	 	BP,SP
	;Salvando o contexto, empilhando registradores		
	PUSHF
	PUSH 	AX
	PUSH 	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	;Resgata os valores das coordenadas	previamente definidas antes de chamar a funcao line
	MOV		BX,[bp+10]  ;x1
	MOV		CX,[bp+8]   ;y1 
	MOV		DX,[bp+6]   ;x2 
	MOV		SI,[bp+4]   ;y2

	MOV		AX, 479
	SUB		AX, CX
	MOV		CX, AX

	MOV		AX, 479
	SUB		AX, SI
	MOV		SI, AX

	; Superior
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	CX
	CALL	line
	; Inferior
	PUSH	DX
	PUSH	SI
	PUSH	BX
	PUSH	SI
	CALL	line
	; Direita
	PUSH	DX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	CALL	line
	; Esquerda
	PUSH	BX
	PUSH	CX
	PUSH	BX
	PUSH	SI
	CALL	line

	POP		DI
	POP		SI
	POP		DX
	POP		CX
	POP		BX
	POP		AX
	POPF
	POP		BP
	RET		8
%include "Data.asm"