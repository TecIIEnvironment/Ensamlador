.model small
.stack 64h
.DATA
titulo DB  "*  CALCULADORA ARITMETICA LOGICA BASICA  *$"
solicitar dB "operacion:$"
.code
MOV AX,@DATA
mov ds,ax


;escribir string de solicitud de operación
mov ah,09h
mov cx,01h
mov dx,offset solicitar; dir string de solicitar operación
int 21h

;capturar operación 
call CALC
;posicionar cursor
mov dx,1400h
mov ah,02h
mov bh,00h
int 10h
mov ah,01h
int 21h
mov ah,4Ch
int 21h


;funciones de la calculadora 
CALC:
CALL    CAPT; llamar a capturar operando
PUSH    AX;  guarda dato 1 en pila
MOV     AH,01h; capturer operador
INT     21h
MOV     DL,AL; lo guarda el DL
CALL    CAPT; llamar a capturar operando
MOV     BX,AX;  guarda dato 2 en BX
POP     AX; recupera dato 1
;comparación del operador para llamar al procedimiento de la operación escogida
CMP     DL,2Bh; (+)
JZ      SUMA ;salta a sumar
CMP     DL,2Dh;(-)
JZ      RESTA ; salta a restar
CMP     DL,2Ah;(*)
JZ      MULT;salta a multiplicar
CMP     DL,2Fh; (/)
JZ     DIVISION; salta a dividir
CMP     DL,26h;(&)
JZ     AND_LOGICA; salta a and
RESULTADO:
MOV     AH,02h; posición de retorno de calculo
MOV     DL,3Dh; (=)
INT     21h; imprime caracter
MOV     DL,CL; acarreo o signo negativo
INT     21h; imprime caracter
MOV     DL,BH; digito mas significativo
INT     21h; imprime caracter
MOV     DL,BL; digito menos significativo
INT     21h; imprime caracter
RET; retornar a la interfase gráfica que lo llamo

;capturar operando
CAPT:
MOV     AH,01h
INT     21h
MOV     BH,AL
INT     21h
MOV     AH,BH
SUB     AX,3030h
RET

SUMA:
MOV     CL,00
ADD     AX,BX
CMP     AL,0Ah
JB      DIGITO
DAA
INC     AH
DIGITO:
MOV     BL,AL
MOV     AL,AH
CMP     AL,0Ah
JB     DECENA
DAA
MOV     CL,31h
DECENA:
MOV     BH,AL
AND     BX,0F0Fh
OR      BX,3030h
JMP     RESULTADO

resta:
MOV     CL,00
CMP     AX,BX
JGE     restar
XCHG    AX,BX
MOV     CL,2Dh
restar:
SUB     AX,BX
CMP     AL,0Ah
JB      listo
DAS
listo:
MOV     BX,AX
AND     BX,0F0Fh
OR      BX,3030h
JMP     RESULTADO

;nota: multiplicaciones de operandos de un digito 
MULT:
MOV     CL,00
MUL     BL
AAM
MOV     BX,AX
AND     BX,0F0Fh
OR      BX,3030h
JMP     RESULTADO

;divisiones de números resultado de productos de un digito DIV es rervada no se usa como etiqueta
DIVISION:
MOV     CL,00
AAD
DIV     BL
MOV     BL,AL
OR      BL,30h
JMP     RESULTADO

AND_LOGICA:
AND     BX,AX
OR      BX,3030h
MOV     CX,0000h
JMP     RESULTADO

END