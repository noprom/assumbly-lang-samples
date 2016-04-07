﻿STACKSG     SEGMENT   STACK   'STK'
        	DW 16 DUP('S')
STACKSG    ENDS

DATA    	SEGMENT
	ARY        DW   1,2,3,4,5,6,7,8,9,10
	COUNT  DW   ($-ARY)/2
	SUM       DW    ?
DATA    	ENDS

CODE1   	SEGMENT
MAIN    	PROC FAR
        	ASSUME  CS:CODE1 , DS:DATA , SS:STACKSG
        	
        	PUSH DS
        	XOR AX,AX
        	PUSH AX
        	
        	MOV AX,DATA
        	MOV DS,AX
        	
        	LEA  BX,ARY
        	PUSH BX		;压入数组起始地址
        	LEA BX,COUNT
        	PUSH BX		;压入元素个数地址
        	LEA BX,SUM
        	PUSH BX		;压入和地址
        	
        	CALL  FAR PTR  ARY_SUM
        	
	RET
MAIN    	ENDP
CODE1   	ENDS

CODE2   	SEGMENT
        	ASSUME CS:CODE2
        	
STACK_STRC 	STRUC		;定义结构
	SAVE_BP	            DW   ?
	SAVE_CS_IP        DW  2 DUP (?)
	SUM_ADDR         DW   ?
	COUNT_ADDR    DW   ?
	ARY_ADDR          DW   ?
STACK_STRC 	ENDS

ARY_SUM	PROC   FAR	;数组求和子程序
        	
        	PUSH BP		;保存BP值
        	MOV BP,SP
		
	PUSH AX
        	PUSH CX
        	PUSH SI
        	PUSH DI
        	
        	MOV SI,[BP].ARY_ADDR	;数组始地址
        	MOV DI,[BP].COUNT_ADDR
        	MOV CX,[DI]
        	MOV DI,[BP].SUM_ADDR	;得到和地址
        	
        	XOR AX,AX
NEXT:   	ADD AX,[SI]		;累加
        	ADD SI,TYPE ARY		;修改地址指针
        	LOOP NEXT
        	MOV [DI],AX		;存和
        	
        	POP DI
        	POP SI
        	POP CX
        	POP AX
        	
        	POP BP
        	
        	RET 6			;返回并调整SP指针
        	
ARY_SUM 	ENDP
CODE2   		ENDS
        		END       MAIN
