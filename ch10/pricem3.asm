﻿EXTRN	SUBM : FAR
PUBLIC	TOTAL

STACKSG     SEGMENT	STACK    'STK'
	DW   32  DUP('S')
STACKSG     ENDS

DATA	SEGMENT
	PRICE   	DW 60
	QTY    	DW 80
	TOTAL 	DD ?
DATA	ENDS

CODE	SEGMENT 
	ASSUME 	CS:CODE, DS:DATA
MAIN	PROC FAR
	MOV  AX,DATA
	MOV  DS,AX
	
	MOV    AX,PRICE
	MOV    DX,QTY
    	CALL FAR PTR SUBM
    	
        	MOV AX,4C00H
        	INT 21H
MAIN	ENDP
CODE	ENDS
        	END  	MAIN