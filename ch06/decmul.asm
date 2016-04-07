CR      EQU 0DH
LF      EQU 0AH

STACKSG    SEGMENT   STACK   'S'
        	DW 64 DUP('ST')
STACKSG   ENDS

DATA    	SEGMENT
	PROMPT1   DB   CR,LF,'INPUT NUM1:$'
	PROMPT2   DB   CR,LF,'INPUT NUM2:$'         
	ASCIN1  	    DB   5 , ? , 5 DUP(?)
	ASCIN2  	    DB   5 , ? , 5 DUP(?)
	BIN1    	    DW	?		;乘数1二进制值
	BIN2    	    DW	?		;乘数2二进制值
	RSLTHI  	    DW	0		;32位二进制乘积的高16位
	RSLTLO  	    DW	0		;32位二进制乘积的低16位
	ASCOUT0     DB	CR,LF,'RESULT:'
	ASC_OUT     DB	10 DUP(0),'$'
DATA    	ENDS

CODE    	SEGMENT
	ASSUME CS:CODE,DS:DATA,SS:STACKSG
MAIN    	PROC    FAR

        	MOV     AX,DATA
        	MOV     DS,AX
        	
        	LEA      DX,PROMPT1
        	CALL    DISP
        	
        	LEA      DX,ASCIN1
        	CALL    INPUT		;输入乘数1
        	
	LEA      DX,PROMPT2
        	CALL    DISP            
        	
        	LEA      DX,ASCIN2
        	CALL    INPUT		;输入乘数2
        	
        	LEA      SI,ASCIN1+1		;建立乘数1缓冲区的地址指针
	CALL  ASC_BIN		;把乘数1转换成二进制数
	MOV   BIN1,AX		;存乘数1的二进制值
	
	LEA   SI,ASCIN2+1		;建立乘数2缓冲区的地址指针
	CALL  ASC_BIN		;把乘数2转换成二进制数
	MOV   BIN2,AX		;存乘数2的二进制值
	
	MOV   AX,BIN1
	MUL   BIN2		;乘数1*乘数2，结果为32位二进制数
	
	MOV   RSLTLO,AX  		;保存结果的低16位
	MOV   RSLTHI,DX  		;保存结果的高16位
	CALL  BIN_ASC		;调用32位二进制数转换成
				;十进制数子程序
	LEA   DX,ASCOUT0
	CALL  DISP	    	;显示十进制乘积
		
	MOV   AX,4C00H
	INT   21H
	
MAIN	ENDP


DISP    	PROC			;显示字符串子程序
        	MOV     AH,9
        	INT     21H
        	RET
DISP    	ENDP


INPUT   	PROC			;输入字符串子程序
        	MOV     AH,0AH
        	INT     21H
        	RET
INPUT   	ENDP


ASC_BIN 	PROC

;十进制数转换成16位二进制数子程序
;SI指向十进制数缓冲区，其中第一个字节存放要转
;换的十进制位数，从第二个字节开始存放着十进制
;数的ASCII码。AX中存放转换结果。

        	XOR   AX,AX
        	MOV   CL,[SI]
        	XOR   CH,CH     		;CX中为十进制位数      
        	INC   SI
        	JCXZ  M2

M1:     	MOV     	BX,10
        	MUL     	BX  		;(AX)乘以10
        	            
        	MOV     	BL,[SI]		;得到一位十进制数的ASCII码
        	INC    	SI	    	;修改地址指针
        	AND     	BX,000FH		;把十进制数的ASCII码转换成十进制数
        	
        	ADD     	AX,BX
	LOOP    	M1              
	
M2:     	RET

ASC_BIN 	ENDP


BIN_ASC 	PROC

;32位二进制数转换成十进制数子程序

        	LEA     	DI,ASC_OUT+9	;DI指向十进制数串的个位
        	MOV     	BX,10
        	
C0:     	MOV     	DX,0
        	MOV     	AX,RSLTHI	;用48位中的高32位除以10
        	CMP     	AX,0		;C0循环退出条件
        	JE      	C1	
        	
        	DIV     	BX		;商在AX中，余数在DX中
        	MOV     	RSLTHI,AX
	MOV     	AX,RSLTLO	;将高32位做除法得出的余数(DX中)
				;与低16位(AX中)拼成32位数，再
				;除以10	
        	DIV     	BX
        	MOV     	RSLTLO,AX
        	OR      	DL,30H		;DX中的余数即为本位十进制值
        	MOV     	[DI],DL
        	DEC     	DI
        	JMP     	SHORT  C0

C1:     	MOV     	AX,RSLTLO
C2:     	CMP     	AX,0		;C2循环退出条件
        	JZ      	C3
        	MOV     	DX,0
        	DIV     	BX		;DX中为余数，即为本位十进制值
        				;AX中为商，作为下次被除数的低16位
        	OR      	DL,30H
        	MOV     	[DI],DL
        	DEC     	DI
        	JMP     	SHORT  C2
        	
C3:     	RET

BIN_ASC 	ENDP


CODE    	ENDS
        	END     	MAIN

        	
        	