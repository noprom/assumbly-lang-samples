CODE    SEGMENT
SUBM    PROC   FAR
        	ASSUME CS:CODE
	
	MOV AX,PRICE
        	MUL QTY
        	
        	MOV WORD PTR TOTAL,AX
        	MOV WORD PTR TOTAL+2,DX
    	   
    	RET
SUBM    ENDP
CODE    ENDS
                END