﻿STASG	SEGMENT    STACK	 'S'
          DW 32 DUP(?)
STASG   	ENDS

CODE    	SEGMENT
	ASSUME CS:CODE , SS:STASG
MAIN    	PROC FAR
	
	MOV  BX,162EH	;要转换的二进制数在BX中
	CALL   TERN            	    	
	
	MOV AX,4C00H
        	INT 21H
        	
MAIN    	ENDP

TERN    	PROC		;二→十并显示。
        	
        	MOV CX,10000
	CALL DEC_DIV	;转换万位数
        	
        	MOV CX,1000
	CALL DEC_DIV	;转换千位数
        	
        	MOV CX,100
	CALL DEC_DIV	;转换百位数
        	
        	MOV CX,10
	CALL DEC_DIV	;转换十位数
        	
        	MOV CX,1
	CALL DEC_DIV	;转换个位数
			
	RET
	
TERN  	ENDP

DEC_DIV	PROC		;CX中为十进制的位权
	
	MOV AX,BX
	MOV DX,0
	
        	DIV  CX		;商为转换后的一位十进制数
	MOV BX,DX
	
	MOV DL,AL
        	ADD DL,30H	;转换成ASCII码
        	MOV AH,2	;显示
	INT 21H
    	
    	RET
    	
DEC_DIV	ENDP

CODE    	ENDS
        	END MAIN

