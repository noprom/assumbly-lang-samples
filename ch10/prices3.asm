EXTRN	TOTAL:DWORD
PUBLIC	SUBM

CODE    SEGMENT
SUBM    PROC   FAR
        	ASSUME CS:CODE
	
        	MUL DX
        	
        	MOV WORD PTR TOTAL,AX
        	MOV WORD PTR TOTAL+2,DX
    	
    	RET
SUBM    ENDP
CODE    ENDS
                END