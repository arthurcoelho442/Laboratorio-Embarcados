;-----------------------------------------------------------------------------
;
; Função delay
; velocidade CALL delay;
;
global delay

extern plot_xy, line, velocidade
	
delay: ; Esteja atento pois talvez seja importante salvar contexto (no caso, CX, o que NÃO foi feito aqui).
	mov cx, word [velocidade] ; Carrega “velocidade” em cx (contador para loop)
del2:
	push cx ; Coloca cx na pilha para usa-lo em outro loop
	mov cx, 0800h ; Teste modificando este valor
del1:
	loop del1 ; No loop del1, cx é decrementado até que volte a ser zero
	pop cx ; Recupera cx da pilha
	loop del2 ; No loop del2, cx é decrementado até que seja zero
	ret