﻿STACKSG       SEGMENT    STACK  'S' 		;定义堆栈
	DW 128 DUP('ST')
STACKSG       ENDS


DATA    	SEGMENT	
	N1   	DW	3		;定义N1值
	RSLT1  	DW	?		;结果1
	
	N2   	DW	5		;定义N2值
	RSLT2  	DW	?		;结果2
DATA    	ENDS


CODE        SEGMENT
      ASSUME   CS:CODE , DS:DATA , SS:STACKSG
      
FRAME	  STRUC				;定义帧结构
       SAV_BP             DW     ?			;保存BP值
       SAV_CS_IP       DW 2 DUP(?)		;保存返回地址
       N	                DW     ?			;当前N值
       RSLT_ADDR    DW      ?			;结果地址
FRAME	   ENDS

MAIN    	PROC          FAR
        	
        	MOV	AX,DATA
        	MOV	DS,AX
        	
        	LEA	BX,RSLT1
        	PUSH	BX	 		  ;结果地址入栈
        	PUSH	N1  			  ;N值入栈
        	CALL	FAR  PTR  FACT		  ;调用递归子程序
        	
        	LEA	BX,RSLT2
        	PUSH	BX	 		  ;结果地址入栈
        	PUSH	N2  			  ;N值入栈
        	CALL	FAR  PTR  FACT		  ;调用递归子程序

R1:	MOV	AX,4C00H
        	INT	21H
        	
MAIN    	ENDP


FACT	PROC           FAR			;N！递归子程序

        	PUSH   BP			;保存BP值
        	MOV    BP,SP			;BP指向帧基地址
        	
        	PUSH   BX
        	PUSH   AX
        	
        	MOV    BX,[BP].RSLT_ADDR		;取结果地址
	MOV    AX,[BP].N			;取帧中N值
	
        	CMP    AX,0
        	JE     DONE 			 ;N＝0时退出子程序嵌套
        	
        	PUSH   BX			;为下一次调用压入结果地址
        	DEC    AX
        	PUSH   AX			;为下一次调用压入(N－1)值
        	CALL   FAR   PTR   FACT
        	
R2:	MOV	BX,[BP].RSLT_ADDR
        	MOV	AX,[BX]  			 ;取中间结果(N－1)!        	
        	MUL	[BP].N    			 ;N*（N－1）!
        	
        	JMP	SHORT RETURN
        	
DONE:   	MOV	AX,1      			;0!＝1

RETURN: 	
	MOV	[BX],AX   			;存中间结果
	
        	POP     AX
        	POP     BX
        	POP     BP
        	
        	RET     4
        	
FACT    	ENDP

CODE    	ENDS
        	END     MAIN


