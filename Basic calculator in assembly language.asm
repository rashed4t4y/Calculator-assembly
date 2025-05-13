.MODEL SMALL
.STACK 100H

.DATA
    MSG_MENU  DB 13,10, 'Choose operation:', 13,10
              DB '1. Addition', 13,10
              DB '2. Subtraction', 13,10
              DB '3. Multiplication', 13,10
              DB '4. Division', 13,10
              DB '5. Decimal to Binary', 13,10
              DB '6. Decimal to Hexadecimal', 13,10
              DB '7. Binary to Decimal', 13,10
              DB '8. nPr (Permutation)', 13,10
              DB 'Enter choice (1-8): $'
    MSG_DEC_PROMPT  DB 13,10, 'Enter a 4-digit decimal number: $'
    MSG_DEC2_PROMPT DB 13,10, 'Enter second 4-digit decimal number: $'
    MSG_BIN_PROMPT  DB 13,10, 'Enter up to 8-digit binary number: $'
    MSG_BIN   DB 13,10, 'Binary: $'
    MSG_HEX   DB 13,10, 'Hexadecimal: $'
    MSG_DEC   DB 13,10, 'Decimal: $'
    MSG_ERR   DB 13,10, 'Invalid input.$'
    MSG_ZERO_DIV DB 13,10, 'Error: Cannot divide by zero.$'
    MSG_OVERFLOW DB 13,10, 'Error: Overflow occurred.$'
    MSG_RESULT_ADD DB 13,10, 'Addition is: $'
    MSG_RESULT_SUB DB 13,10, 'Subtraction is: $'
    MSG_RESULT_MUL DB 13,10, 'Multiplication is: $'
    MSG_RESULT_DIV DB 13,10, 'Division is: $'
    MSG_NPR     DB 13,10, 'nPr is: $'
    MSG_PROMPT_N DB 13,10, 'Enter n (0-9): $'
    MSG_PROMPT_R DB 13,10, 'Enter r (0-9): $'
    MSG_INVALID DB 13,10, 'Not possible. r > n.$'

    DEC_STR   DB 4 DUP(?)
    DEC_STR2  DB 4 DUP(?)
    BIN_STR   DB 8 DUP(?)
    DECIMAL   DW ?
    DECIMAL2  DW ?
    RESULT    DW ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG_MENU
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H
    CMP AL, '1'
    JE ADDITION
    CMP AL, '2'
    JE SUBTRACTION
    CMP AL, '3'
    JE MULTIPLICATION
    CMP AL, '4'
    JE DIVISION
    CMP AL, '5'
    JE DEC_TO_BIN
    CMP AL, '6'
    JE DEC_TO_HEX
    CMP AL, '7'
    JE BIN_TO_DEC
    CMP AL, '8'
    JE NPR
    JMP EXIT

READ_DECIMAL PROC NEAR
    LEA DX, MSG_DEC_PROMPT
    MOV AH, 9
    INT 21H
    LEA SI, DEC_STR
    MOV CX, 4
READ_LOOP1:
    MOV AH, 1
    INT 21H
    MOV [SI], AL
    INC SI
    LOOP READ_LOOP1
    LEA SI, DEC_STR
    MOV AX, 0
    MOV CX, 4
TO_INT1:
    MOV BL, [SI]
    SUB BL, '0'
    MOV BH, 0
    MOV DX, AX
    MOV AX, 10
    MUL DX
    ADD AX, BX
    INC SI
    LOOP TO_INT1
    MOV DECIMAL, AX
    RET
READ_DECIMAL ENDP

READ_DECIMAL2 PROC NEAR
    LEA DX, MSG_DEC2_PROMPT
    MOV AH, 9
    INT 21H
    LEA SI, DEC_STR2
    MOV CX, 4
READ_LOOP2:
    MOV AH, 1
    INT 21H
    MOV [SI], AL
    INC SI
    LOOP READ_LOOP2
    LEA SI, DEC_STR2
    MOV AX, 0
    MOV CX, 4
TO_INT2:
    MOV BL, [SI]
    SUB BL, '0'
    MOV BH, 0
    MOV DX, AX
    MOV AX, 10
    MUL DX
    ADD AX, BX
    INC SI
    LOOP TO_INT2
    MOV DECIMAL2, AX
    RET
READ_DECIMAL2 ENDP

PRINT_DECIMAL PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AX, RESULT
    CMP AX, 0
    JNE CONT_DEC_PRINT
    MOV DL, '0'
    MOV AH, 2
    INT 21H
    JMP END_DEC_PRINT
CONT_DEC_PRINT:
    MOV CX, 0
    MOV BX, 10
DEC_DIV:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE DEC_DIV
PRINT_DEC_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP PRINT_DEC_LOOP
END_DEC_PRINT:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_DECIMAL ENDP

PRINT_RESULT_LABEL PROC NEAR
    MOV AH, 9
    INT 21H
    CALL PRINT_DECIMAL
    RET
PRINT_RESULT_LABEL ENDP

PRINT_MINUS_LABEL PROC NEAR
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    CALL PRINT_DECIMAL
    RET
PRINT_MINUS_LABEL ENDP

ADDITION:
    CALL READ_DECIMAL
    CALL READ_DECIMAL2
    MOV AX, DECIMAL
    ADD AX, DECIMAL2
    JC PRINT_OVERFLOW
    MOV RESULT, AX
    LEA DX, MSG_RESULT_ADD
    CALL PRINT_RESULT_LABEL
    JMP EXIT

SUBTRACTION:
    CALL READ_DECIMAL
    CALL READ_DECIMAL2
    MOV AX, DECIMAL
    SUB AX, DECIMAL2
    JNS SUB_POS
    NEG AX
    MOV RESULT, AX
    LEA DX, MSG_RESULT_SUB
    CALL PRINT_MINUS_LABEL
    JMP EXIT
SUB_POS:
    MOV RESULT, AX
    LEA DX, MSG_RESULT_SUB
    CALL PRINT_RESULT_LABEL
    JMP EXIT

MULTIPLICATION:
    CALL READ_DECIMAL
    CALL READ_DECIMAL2
    MOV AX, DECIMAL
    MUL DECIMAL2
    JC PRINT_OVERFLOW
    MOV RESULT, AX
    LEA DX, MSG_RESULT_MUL
    CALL PRINT_RESULT_LABEL
    JMP EXIT

DIVISION:
    CALL READ_DECIMAL
    CALL READ_DECIMAL2
    CMP DECIMAL2, 0
    JE PRINT_ZERO_DIV
    MOV AX, DECIMAL
    MOV DX, 0
    DIV DECIMAL2
    MOV RESULT, AX
    LEA DX, MSG_RESULT_DIV
    CALL PRINT_RESULT_LABEL
    JMP EXIT

PRINT_OVERFLOW:
    LEA DX, MSG_OVERFLOW
    MOV AH, 9
    INT 21H
    JMP EXIT

PRINT_ZERO_DIV:
    LEA DX, MSG_ZERO_DIV
    MOV AH, 9
    INT 21H
    JMP EXIT

DEC_TO_BIN:
    CALL READ_DECIMAL
    LEA DX, MSG_BIN
    MOV AH, 9
    INT 21H
    MOV AX, DECIMAL
    MOV CX, 0
    MOV BX, 2
PUSH_BIN:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PUSH_BIN
PRINT_BIN:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP PRINT_BIN
    JMP EXIT

DEC_TO_HEX:
    CALL READ_DECIMAL
    LEA DX, MSG_HEX
    MOV AH, 9
    INT 21H
    MOV AX, DECIMAL
    MOV CX, 0
    MOV BX, 16
PUSH_HEX:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PUSH_HEX
PRINT_HEX:
    POP DX
    CMP DL, 9
    JBE IS_DIGIT
    ADD DL, 7
IS_DIGIT:
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP PRINT_HEX
    JMP EXIT

BIN_TO_DEC:
    LEA DX, MSG_BIN_PROMPT
    MOV AH, 9
    INT 21H
    LEA SI, BIN_STR
    MOV CX, 8
    MOV BX, 0
READ_BIN:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE READ_BIN_DONE
    MOV [SI], AL
    INC SI
    INC BX
    LOOP READ_BIN
READ_BIN_DONE:
    MOV SI, OFFSET BIN_STR
    MOV CX, BX
    MOV AX, 0
BIN_TO_INT:
    MOV DL, [SI]
    SUB DL, '0'
    SHL AX, 1
    ADD AX, DX
    INC SI
    LOOP BIN_TO_INT
    MOV RESULT, AX
    LEA DX, MSG_DEC
    MOV AH, 9
    INT 21H
    CALL PRINT_DECIMAL
    JMP EXIT

NPR:
    LEA DX, MSG_PROMPT_N
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    MOV BL, AL

    LEA DX, MSG_PROMPT_R
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    MOV BH, AL

    MOV AL, BL
    CMP BH, AL
    JA PRINT_INVALID

    MOV CL, BL
    CALL FACTORIAL
    JC PRINT_OVERFLOW
    MOV AX, RESULT
    PUSH AX

    MOV AL, BL
    SUB AL, BH
    MOV CL, AL
    CALL FACTORIAL
    JC PRINT_OVERFLOW

    POP AX
    MOV DX, 0
    DIV RESULT
    MOV RESULT, AX
    LEA DX, MSG_NPR
    CALL PRINT_RESULT_LABEL
    JMP EXIT

PRINT_INVALID:
    LEA DX, MSG_INVALID
    MOV AH, 9
    INT 21H
    JMP EXIT

FACTORIAL PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    MOV AX, 1
    MOV BL, 1
FACTORIAL_LOOP:
    CMP BL, CL
    JA DONE_FACT
    MUL BL
    JC FACT_OVERFLOW
    INC BL
    JMP FACTORIAL_LOOP
DONE_FACT:
    MOV RESULT, AX
    CLC
    POP CX
    POP BX
    POP AX
    RET
FACT_OVERFLOW:
    STC
    POP CX
    POP BX
    POP AX
    RET
FACTORIAL ENDP

EXIT:
    MOV AX, 4C00H
    INT 21H
;MAIN ENDP
END MAIN
