segment code
..start:
	MOV 	AX, dados
	MOV 	DS, AX
	MOV 	AX, stack
	MOV 	SS,AX
	MOV 	SP,stacktop 
		
 ; AQUI COMECA A EXECUCAO DO PROGRAMA PRINCIPAL
	MOV 	DX,mensini ; mensagem de inicio
	MOV 	AH,9
	INT 	21h
				
	MOV 	AX,0 ; primeiro elemento da série
	MOV 	BX,1 ; segundo elemento da série
	L10:
		MOV 	DX,AX
		
		CALL	imprimenumero
		
		
		ADD 	DX,BX ; calcula novo elemento da série
		MOV 	AX,BX
		MOV 	BX,DX
		
		CMP 	DX, 0x5a
		JL 		L10

; AQUI TERMINA A EXECUCAO DO PROGRAMA PRINCIPAL
exit:
		MOV 	DX,mensfim ; mensagem de inicio
		MOV 	AH,9
		INT	 	21h
quit:
		MOV 	AH,4CH ; retorna para o DOS com código 0
		INT 	21h

;*****************************************************************

imprimenumero:
; Save the context
	PUSHF
	PUSH 	AX
	PUSH 	BX
	PUSH	CX
	PUSH 	DX
				
	MOV 	DI,saida
	CALL 	bin2ascii		

	MOV 	DX,saida
	MOV 	AH,9h
	INT 	21h         
		
; Upgrade the context
	POP 	DX
	POP 	CX
	POP		BX
	POP 	AX
	POPF
	RET

bin2ascii:
	CMP		DX,10
	JB		Uni
	CMP		DX,100 
	JB		Des
	CMP		DX,1000
	JB		Cen
	CMP		DX,10000
	JB		Mil
	JMP		Dezmil
			
Uni:	
	ADD		DX,0x0030
	MOV 	byte [DI],DL
	RET
Des:
	MOV 	AX,DX
	MOV		BL,10
	DIV		BL
	ADD		AH,0x30
	ADD		AL,0x30
	MOV 	byte [DI],AL
	MOV 	byte [DI+1],AH
	RET
Cen:		
	MOV 	AX,DX
	MOV		BL,100
	DIV		BL
	ADD		AL,0x30
	MOV 	byte [DI],AL
	MOV 	AL,AH
	AND		AX,0x00FF
	MOV		BL,10
	DIV		BL
	ADD		AH,0x30
	ADD		AL,0x30
	MOV 	byte [DI+1],AL		
	MOV 	byte [DI+2],AH
	RET
Mil:		
	MOV 	AX,DX
	MOV     DX,0
	MOV		BX,1000
	DIV		BX
	ADD		AL,0x30
	MOV 	byte [DI],AL
	MOV 	AX,DX
	MOV		BL,100
	DIV		BL
	ADD		AL,0x30
	MOV 	byte [DI+1],AL		
	MOV 	AL,AH
	AND     AX,0x00FF
	MOV		BL,10
	DIV		BL
	ADD		AH,0x30
	ADD		AL,0x30
	MOV 	byte [DI+2],AL		
	MOV 	byte [DI+3],AH
	RET
Dezmil:
	MOV 	AX,DX
	MOV     DX,0
	MOV		BX,10000
	DIV		BX
	ADD		AL,0x30
	MOV 	byte [DI],AL
	MOV		AX,DX		
	MOV     DX,0
	MOV		BX,1000
	DIV		BX
	ADD		AL,0x30
	MOV 	byte [DI+1],AL
	MOV 	AX,DX
	MOV		BL,100
	DIV		BL
	ADD		AL,0x30
	MOV 	byte [DI+2],AL		
	MOV 	AL,AH
	AND     AX,0x00FF
	MOV		BL,10
	DIV		BL
	ADD		AH,0x30
	ADD		AL,0x30
	MOV 	byte [DI+3],AL		
	MOV 	byte [DI+4],AH
	RET
		
segment dados ;segmento de dados inicializados
CR 			EQU		13
LF 			EQU		10
mensini: 	db 'Programa que calcula a Serie de Fibonacci. ',CR,LF,'$'
mensfim: 	db 'Fim da serie!!',CR,LF,'$'

;saida: 		db '00000',CR,LF,'$'
saida: 		resb 5 
            db CR,LF,'$'

segment stack stack
resb 256 ; reserva 256 bytes para formar a pilha
stacktop: