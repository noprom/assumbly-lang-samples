STACKSG     SEGMENT STACK 'S'
	DW 64 DUP('ST')
STACKSG     ENDS

DATA    	SEGMENT
	X       DW   12H,34H,56H,78H,90H
	          DW   0ABH,0CDH,0EFH,0F1H,023H
	Y       DW   9,8,7,6,5,4,3,2,1,0
	Z       DW   10 DUP(?)
            RULE     DW   0000000011011100B		;逻辑尺
DATA    	ENDS

CODE	SEGMENT
	ASSUME  CS:CODE , DS:DATA , SS:STACKSG
MAIN  PROC  FAR
	
	MOV   AX,DATA
	MOV   DS,AX
	
	MOV   BX,0			;地址指针
	MOV   CX,10			;循环次数
	MOV   DX,RULE			;逻辑尺

NEXT: 	MOV   AX,X[BX]  			;取X中的一个数
	SHR   DX,1	   	                  ;逻辑尺右移一位
	JC    SUBS     			;分支判断并实现转移
	ADD     AX,Y[BX]	   		 ;两数加
	JMP     SHORT  RESULT

SUBS:   	SUB     AX,Y[BX]  			;两数减

RESULT: 	MOV     Z[BX],AX			;存结果

        	ADD     BX,2	   		;修改地址指针
        	LOOP    NEXT
        	
        	MOV     AX,4C00H
        	INT     21H
        	
MAIN    	ENDP
CODE    	ENDS
	END     MAIN