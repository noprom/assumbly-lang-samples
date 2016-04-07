﻿STACKSG     SEGMENT  STACK  'STK'
        	DW 32 DUP('S')
STACKSG     ENDS

DATA    	SEGMENT
	ARY     	DW   1,2,3,4,5,6,7,8,9,10	;数组1
	COUNT   	DW   ($-ARY)/2		;数组1的元素个数
	SUM     	DW   ?			;数组1的和地址

	NUM     	DW   10,20,30,40,50		;数组2
	CT      	DW   ($-NUM)/2		;数组2的元素个数
	TOTAL   	DW   ?			;数组2的和地址

	TABLE   	DW 3 DUP(?)		;地址表
DATA    	ENDS

CODE1	SEGMENT
MAIN	PROC   FAR
        	ASSUME  CS:CODE1, DS:DATA, SS:STACKSG

        	PUSH DS
        	XOR AX,AX
        	PUSH AX

        	MOV AX,DATA
        	MOV DS,AX

        	;构造数组1的地址表
        	MOV TABLE,OFFSET ARY
        	MOV TABLE+2,OFFSET COUNT
        	MOV TABLE+4,OFFSET SUM

        	LEA BX,TABLE		;传递地址表首地址

        	CALL FAR PTR ARY_SUM

        	;构造数组2的地址表
        	MOV TABLE,OFFSET NUM
        	MOV TABLE+2,OFFSET CT
        	MOV TABLE+4,OFFSET TOTAL

        	LEA BX,TABLE		;传递地址表的首地址

        	CALL FAR PTR ARY_SUM	;段间调用数组求和子程序

        	RET
MAIN    	ENDP
CODE1   	ENDS

CODE2   	SEGMENT
        	ASSUME CS:CODE2
ARY_SUM      PROC   FAR		;数组求和子程序

        	PUSH AX			;保存寄存器
        	PUSH CX
        	PUSH SI
        	PUSH DI

        	MOV SI,[BX]		;取数组起始地址
        	MOV DI,[BX+2]		;取元素个数地址
        	MOV CX,[DI]		;取元素个数
        	MOV DI,[BX+4]		;取结果地址

        	XOR AX,AX		;清0累加器

NEXT:   	ADD AX,[SI]		;累加和
        	ADD SI,TYPE ARY		;修改地址指针
        	LOOP NEXT

        	MOV [DI],AX		;存和

        	POP DI			;恢复寄存器
        	POP SI
        	POP CX
        	POP AX

        	RET
ARY_SUM     ENDP
CODE2   	     ENDS
        	     END MAIN
