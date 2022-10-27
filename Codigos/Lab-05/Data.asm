segment data
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
linha   	    dw  	0
coluna  	    dw  	0
deltax		    dw		0
deltay		    dw		0	
x_pos			dw		320
y_pos			dw		240
raio_bola		dw		10
segment stack stack
		DW 		512
stacktop: