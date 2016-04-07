STACKSG	     SEGMENT STACK 'STK'
        	DW 32 DUP('S')
STACKSG     ENDS

DATA	SEGMENT
MSG1    	DB   '1---------CREATE',0DH,0AH	;菜单
        	DB   '2---------UPDATE',0DH,0AH
        	DB   '3---------DELETE',0DH,0AH
        	DB   '4---------PRINT',0DH,0AH
        	DB   '5---------QUIT',0DH,0AH,'$'
        	
MSG2    	DB   'INPUT SELECT:',0DH,0AH,'$'  	;选择提示

JMP_TAB  DW CREATE			;地址表（跳转表）
        	 DW UPDATE
        	 DW DELETE
        	 DW PRINT
        	 DW QUIT
DATA    	ENDS

CODE    	SEGMENT
MAIN    	PROC FAR
        	ASSUME  CS:CODE , DS:DATA
        	
        	PUSH DS
        	XOR AX,AX
        	PUSH AX
        	
        	MOV AX,DATA
        	MOV DS,AX
        	
REPEAT: 	MOV AX,0600H			;清屏
        	MOV CX,0
        	MOV DX,184FH
        	MOV BH,07
        	INT 10H

CURSOR: MOV AH,02		;设置光标
        	MOV BH,0
        	MOV DX,0400H
        	INT 10H
        	
        	LEA DX,MSG1		;显示菜单
        	MOV AH,9
        	INT 21H
        	LEA DX,MSG2		;显示选择提示
        	INT 21H

RDKB:   	MOV AH,1		;等待输入选择号
        	INT 21H
        	
        	CMP AL,31H		;选择合法性检查
        	JB BEEP			;若非法则转移
        	CMP AL,35H
        	JA BEEP			;输入的功能号应在'31' - '35'之间
        	
        	AND AL,0FH	   	 ;ASCII码转换为非压缩BCD码
        	XOR AH,AH		;(AX)＝功能号
        	DEC AX			;得到索引值
        	ADD AX,AX		;i项位移量＝(AX)*2
        	LEA BX,JMP_TAB		;装入表首址
        	ADD BX,AX		;得到表项地址
        	JMP [BX]			;按表项地址转移

BEEP:   	
	MOV AH,3
	MOV BH,0
	INT 10H			;读光标位置
	
	CMP  DL, 0
	JZ  NOBACK		;如果光标位于0列，
				;则不用再回退一格
	
	MOV AH,2
	DEC DL
	INT 10H			;让光标回退一格
				;即让下一次输入的功能号
				;覆盖此次的错误输入

NOBACK:
	MOV AH,14	 	;响铃警告
        	MOV AL,7
        	INT 10H
        	JMP SHORT RDKB  		;转重新选择
        	
CREATE: 	MOV AH,2		;建立文件子功能
        	MOV DL,'C'
        	INT 21H
        	
        	MOV AH,0
        	INT 16H			;等待键盘输入
        	
        	JMP REPEAT		;返回菜单

UPDATE: MOV AH,2		;修改文件子功能
        	MOV DL,'U'
        	INT 21H
        	
        	MOV AH,0
        	INT 16H			;等待键盘输入
        	
        	JMP REPEAT		;返回菜单
        	
DELETE: 	MOV AH,2		;删除文件子功能
        	MOV DL,'D'
        	INT 21H
        	
        	MOV AH,0
        	INT 16H			;等待键盘输入
        	
        	JMP REPEAT		;返回菜单
        	
PRINT:  	MOV AH,2		;显示文件子功能
        	MOV DL,'P'
        	INT 21H
        	
        	MOV AH,0
        	INT 16H			;等待键盘输入
        	
        	JMP REPEAT		;返回菜单
        	
QUIT:   	RET			;返回操作系统

MAIN    	ENDP
CODE    	ENDS
        	END     MAIN

