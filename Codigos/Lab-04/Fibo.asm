segment code
..start:
	mov ax, dados
	mov ds, ax
	mov ax, stack
	mov ss,ax
	mov sp,stacktop
 
 ; AQUI COMECA A EXECUCAO DO PROGRAMA PRINCIPAL
	mov dx,mensini ; mensagem de inicio
	mov ah,9
	int 21h
	
	mov ax,0 ; primeiro elemento da série
	mov bx,1 ; segundo elemento da série
	
	L10:
		mov dx,ax
		add dx,bx ; calcula novo elemento da série
		mov ax,bx
		mov bx,dx
		cmp dx, 0x8000
	jb L10

	;bin2ascii:
	;	cmp dx,10
	;	jb	Uni
	;	
	;	cmp dx,100
	;	jb	Des
	;	
	;	cmp dx,1000
	;	jb	Cen
	;	
	;	cmp dx,10000
	;	jb	Mil
	;	
	;	jb	Dezmil
	
	exit:
	mov dx,mensfim ; mensagem de inicio
	mov ah,9
	int 21h
	
	mov dx,saida ; mensagem de inicio
	mov ah,9
	int 21h
	
	int 3

	; AQUI TERMINA A EXECUCAO DO PROGRAMA PRINCIPAL
	quit:
	mov ah,4CH ; retorna para o DOS com código 0
	int 21h
 
 segment dados ;segmento de dados inicializados
	mensini: 	db 'Programa que calcula a Serie de Fibonacci. ',13,10,'$'
	mensfim: 	db 'bye',13,10,'$'
	saida: 		db '00000',13,10,'$'
	segment stack stack
	
	resb 256 ; reserva 256 bytes para formar a pilha
	stacktop: ; posição de memória que indica o topo da pilha=SP