STACK SEGMENT STACK 'S'

  DW 64 DUP('ST')
STACK ENDS

DATA SEGMENT
    ARY     	DW   5,7,1,4,3,6,9,8,2		;数组，流程图中为A
    CT      	EQU  ($-ARY)/2	      	;元素个数
DATA ENDS

CODE SEGMENT
  ASSUME   CS:CODE, DS:DATA, SS:STACK
MAIN PROC    FAR

        	MOV     AX,DATA
        	MOV     DS,AX

        	MOV     DI,CT-1		;初始化外循环次数

LOP1:	MOV     CX,DI		;置内循环次数
	MOV     BX,0	 	;置地址指针

LOP2:	MOV     AX,ARY[BX]
	CMP     AX,ARY[BX+2]	;两数比较
	JGE     CONT	    	;次序正确转

	XCHG    AX,ARY[BX+2]	;次序不正确互换位置
	MOV     ARY[BX],AX

CONT:	ADD     BX,2	 	;修改地址指针
	LOOP    LOP2	 	;内循环控制

	DEC     DI  	 	;修改外循环次数
	JNZ      LOP1	 	;外循环控制

	MOV     AX,4C00H
	INT     21H

MAIN    	ENDP
CODE    	ENDS
        	END     MAIN
