CHARS	MACRO	NUM
	MOV	AH,2
	CHAR='A'
	REPT 	NUM
	         MOV  DL,CHAR
	         INT  21H
	         CHAR=CHAR+1
	ENDM
	ENDM

CODE	SEGMENT
	ASSUME	CS:CODE
MAIN	PROC	FAR

	CHARS	26
	MOV	AX,4C00H
	INT	21H

MAIN	ENDP
CODE	ENDS
			END		MAIN
