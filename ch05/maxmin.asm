STACKSG     SEGMENT STACK 'STK'
       	DW 32 DUP('S')
STACKSG     ENDS

DATA    	SEGMENT
      BUFFER  DW 500,30,56,77,999,67,433,5675,0,9999		;无序表
                  	     DW 3455,6578,32766,8,0,32560,45,889,5665,09
      CN      	     DW    ($-BUFFER)/2	;元素个数
      MAX         DW    ?			;存放最大数单元
      MIN          DW    ? 		;存放最小数单元
DATA    	ENDS

CODE    	SEGMENT
MAIN    	PROC FAR
        	ASSUME  CS:CODE , DS:DATA
        	
        	PUSH DS
        	XOR AX,AX
        	PUSH AX
        	
        	MOV AX,DATA
        	MOV DS,AX
        	
        	LEA SI,BUFFER	 ;初始化地址指针
        	MOV CX,CN	 ;元素个数
        	MOV AX,[SI]	 ;取第一数
        	DEC CX
        	MOV MAX,AX	 ;初始化最大数
        	MOV MIN,AX	 ;初始化最小数
        	
COMP:	ADD SI,2		 ;修改地址指针
	MOV AX,[SI]	;取下一个数
	CMP AX,MAX	;与当前的最大数比较
	JL NEXT		;若小于转NEXT
	JE LOP		;若等于转LOP
	MOV MAX,AX	;若大于则把此数作为
			;最大数保存
	JMP SHORT LOP
NEXT:	CMP AX,MIN	;与当前的最小数比较
   	JGE LOP		;若大于等于转
   	MOV MIN,AX	;若小于则把此数作为
   			;最小数保存
LOP:	 LOOP COMP	;决定循环继续还是终止

	RET

MAIN 	ENDP
CODE 	ENDS
    	END     MAIN