segment code
..start:
; iniciar os registros de segmento DS e SS e o ponteiro de pilha SP
	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
	mov sp,stacktop
	
; iniciar o codigo do programa
	mov bx,three_chars 	; passa o endereço de trhree_chars para o registrador BX
	
	mov ah,1			
	int 21h 			; função do dos de entrada de carcater. Retorna em AL
	
	dec al				; decrementa o valor em AL
	mov [bx],al			; Coloca no endereço de bx (referente a primeira possição de three_chars) o valor em AL
	
	inc bx				; anda para a segunda possição de three_chars
	int 21h				; 
	
	dec al				; decrementa novamente o valor em AL
	mov [bx],al			; Coloca no endereço de bx (referente a segunda possição de three_chars) o valor em AL
	
	
	inc bx				; anda para a terceira possição de three_chars
	int 21h				;
	
	dec al				; decrementa novamente o valor em AL
	mov [bx],al			; Coloca no endereço de bx (referente a terceira possição de three_chars) o valor em AL
	
	mov dx,display_string
	mov ah,9
	int 21h				; função do dos de Impressão de carcateres.
	
; Terminar o programa e voltar para o sistema operacional
	mov ah,4ch
	int 21h
segment data
	CR equ 0dh ; 10
	LF equ 0ah ; 13
	display_string db CR,LF ; Serve para demonstrar a mensagem
	three_chars resb 3 	; reserva 3 bits para a mensagem
			db '$'		; acresenta o caracter expecial
segment stack stack
	resb 256
stacktop: