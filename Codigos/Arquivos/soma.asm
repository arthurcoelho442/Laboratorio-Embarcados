segment code
    ..start:
    
    ; Iniciar os registros DS e SS e o ponteiro de pilha SP
    mov ax, minhas_variaveis
    mov ds,ax
    mov ax, minha_pilha
    mov ss,ax
    mov sp,stacktop

    ; Programa
    mov		ah,9
    mov		dx,mensagem
    int		21h

    ; Termino
    mov ah,4ch
    int 21h

    ; Variaveis
    segment minhas_variaveis
        mensagem db 'Oi, olha eu aqui','$'
    segment minha_pilha stack
        resb 256
stacktop: