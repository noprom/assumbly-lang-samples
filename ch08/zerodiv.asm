DATA    	SEGMENT
	A       DB   0		   ;除数
DATA    	ENDS

CODE    	SEGMENT
        	ASSUME CS:CODE,DS:DATA
MAIN    	PROC    	FAR

        	MOV     	AX,DATA
        	MOV     	DS,AX

        	MOV     	AX,108H
        	DIV     	A  ;被0除,会产生除法错中断

        	MOV     	AX,4C00H
        	INT     	21H
MAIN    	ENDP
CODE    	ENDS
        	END     	MAIN
