DATA    	SEGMENT
	A       DB   0		   ;����
DATA    	ENDS

CODE    	SEGMENT
        	ASSUME CS:CODE,DS:DATA
MAIN    	PROC    	FAR

        	MOV     	AX,DATA
        	MOV     	DS,AX
        	
        	MOV     	AX,108H
        	DIV     	A  ;��0��,������������ж�
        	
        	MOV     	AX,4C00H
        	INT     	21H
MAIN    	ENDP
CODE    	ENDS
        	END     	MAIN
