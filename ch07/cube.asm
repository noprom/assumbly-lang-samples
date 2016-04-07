STACKSG	      SEGMENT  STACK  'STK'
	DW 32 DUP('S')
STACKSG      ENDS
	
DATA    	SEGMENT
TABLE	LABEL    WORD
	X=5
	REPT 6	                     ;重复6次
	     DW X*X*X	   ;定义立方值
	     X=X+1
	ENDM	
DATA    	ENDS

CODE   	SEGMENT
MAIN    	PROC FAR
        	ASSUME CS:CODE,DS:DATA,SS:STACKSG
        	
        	MOV	AX,DATA
        	MOV	DS,AX
        	
        	MOV	AX,4C00H
        	INT	21H

MAIN	ENDP
CODE	ENDS
	END	MAIN