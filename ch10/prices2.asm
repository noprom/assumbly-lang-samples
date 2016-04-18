PUBLIC	SUBM

DATA	SEGMENT	COMMON
	PRICE   	DW 60
	QTY    	DW 80
	TOTAL 	DD ?
	REM	DB  '123'
DATA	ENDS

CODE    SEGMENT
SUBM    PROC   FAR
        	ASSUME CS:CODE, DS:DATA
	
	PUSH	DS
	PUSH	AX
	PUSH	DX
	
	MOV	AX,DATA
	MOV	DS,AX
	
	MOV AX,PRICE
        	MUL QTY
        	
        	MOV WORD PTR TOTAL,AX
        	MOV WORD PTR TOTAL+2,DX
    	   
    	POP	DX
    	POP	AX
    	POP	DS
    	
    	RET
SUBM    ENDP
CODE    ENDS
                END