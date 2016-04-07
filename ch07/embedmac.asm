DMAC	MACRO	MNAME,OPER	;外层宏定义
	MNAME	MACRO  X,Y,Z	;内层宏定义
		
		PUSH  AX
		MOV   AX,X
		OPER  AX,Y
		MOV   Z,AX
		POP   AX
		
		ENDM	
		ENDM


DATA    	SEGMENT
	A        DW	    25
	B        DW	    12
	C        DW	    ?
DATA    	ENDS

CODE	SEGMENT
MAIN	PROC   FAR
        	ASSUME  CS:CODE, DS:DATA
        	
        	PUSH DS
        	XOR AX,AX
        	PUSH AX
        	
        	MOV AX,DATA
        	MOV DS,AX
        	
        	.LALL
        	
        	DMAC	ADDITION,ADD
        	ADDITION   A,B,C
        	
        	DMAC	LOGIC_AND,AND
        	LOGIC_AND   A,B,C
        	
        	RET
MAIN    	ENDP
CODE   	ENDS
	END      MAIN
        	
        	


