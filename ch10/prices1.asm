EXTRN	PRICE:WORD, QTY:WORD, TOTAL:DWORD
PUBLIC	SUBM

CODE    SEGMENT
SUBM    PROC   FAR
        	ASSUME CS:CODE
	
	PUSH	AX
	PUSH	DX
	
	MOV AX,PRICE
        	MUL QTY
        	
        	MOV WORD PTR TOTAL,AX
        	MOV WORD PTR TOTAL+2,DX
    	   
    	POP	DX
    	POP	AX
    	
    	RET
SUBM    ENDP
CODE    ENDS
                END