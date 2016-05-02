EXTRN	PRICE:WORD, QTY:WORD, TOTAL:DWORD
PUBLIC	SUBM

STACKSG     SEGMENT
	DW   16  DUP('S')
     TOP	LABEL	WORD		;栈顶初始值
STACKSG     ENDS

CODE    SEGMENT
SUBM    PROC   FAR
        	ASSUME CS:CODE, SS:STACKSG
	
	MOV  CS:SAV_SS,SS
	MOV  CS:SAV_SP,SP	;保存原值
	
	CLI			;关中断
	MOV	AX,STACKSG
	MOV	SS,AX
	MOV	SP,OFFSET TOP	;堆栈切换
	STI			;开中断
	
	PUSH	AX
	PUSH	DX
	
	MOV AX,PRICE
        	MUL QTY
        	
        	MOV WORD PTR TOTAL,AX
        	MOV WORD PTR TOTAL+2,DX
    	   
    	POP	DX
    	POP	AX
    	
    	CLI
    	MOV	SS,CS:SAV_SS
    	MOV	SP,CS:SAV_SP		;恢复原值
    	STI
    	
    	RET
    	
    	SAV_SS	DW  ?
    	SAV_SP	DW  ?
    	
SUBM    ENDP
CODE    ENDS
                END