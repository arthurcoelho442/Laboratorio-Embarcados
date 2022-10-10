segment code
..start:
; iniciar os registros de segmento DS e SS e o ponteiro de pilha SP
    mov     ax,data
    mov     ds,ax
    mov     ax,stack
    mov     ss,ax
    mov     sp,stacktop
    mov     cx,[size]
; iniciar o codigo do programa

    MULTIPLICACAO:  
        mov bx, [index_vetores]         ; Posição inicial dos dois vetores
        mov ax, [Vet1+bx]               ; Multiplicando
        mov bx, [Vet2+bx]               ; Multiplicador
        mul bx                          ; Execulta multiplicação colocando em Ax e Dx o resultado

        mov bx, [inde_result]           ; Posição inicial do resultado
        mov word [resultado+bx], ax     ; Coloca o resuldado da multiplicação no endereço de resultado
        mov word [resultado+bx+2], dx   ; 

        ; Incrementa os contadores
        mov bx, [index_vetores]
        add bx, 2			            ; anda para a próxima possição dos vetores
        mov [index_vetores], bx

        mov bx, [inde_result]
        add bx, 4				        ; anda para a próxima possição do resultado incrementa duas vezes pois o word é duplo
        mov [inde_result], bx

    loop MULTIPLICACAO
    int 3

; Terminar o programa e voltar para o sistema operacional
mov        ah,4ch
int     21h

segment data
    Vet1                dw    2, 4, 6
    Vet2                dw    5, 7, 25
    resultado           resw 6

    size                dw  3
    index_vetores       dw  0
    inde_result         dw  0

segment stack stack
    resb 256
stacktop: