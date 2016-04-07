﻿WWidth = 42		;窗口宽度
WLeftTopLine = 10	;左上角行号
WLeftTopRow = 18	;左上角列号
WRightBottomLine = 15	;右下角行号
WRightBottomRow = WLeftTopRow + WWidth - 1
			;右下角行号
Color = 70H		;白色背景黑色前景
CR = 0DH		;回车
LF = 0AH		;换行

STACKSG SEGMENT STACK 'S'
	DW 64 DUP('ST')
	
STACKSG	ENDS

DATA SEGMENT
STRING	DB 'This is an example to call interrupt 10H.'
			;要显示的字符串
CT	EQU  $ - STRING	;串长
DATA ENDS

CODE	SEGMENT
	ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACKSG
MAIN	PROC	FAR
	MOV	AX, DATA
	MOV	DS, AX
	MOV	ES, AX	;ES、DS指向同一个段
	
	MOV	AH, 0	;置显示模式为80*25彩色文本方式
	MOV	AL, 3
	INT	10H
	
	MOV	AH, 6	;清全屏
	MOV	AL, 0
	MOV	BH, 1FH ;设置为蓝底白字
	MOV	CX, 0
	MOV	DX, 184FH
	INT	10H
	
	MOV	AH, 0	;等待按任意键
	INT	16H
	
	MOV	AH, 6	;开窗口，并设置为白底黑字
	MOV	AL, 0
	MOV	BH, Color
	MOV	CH, WLeftTopLine
	MOV	CL, WLeftTopRow
	MOV	DH, WRightBottomLine
	MOV	DL, WRightBottomRow
	INT	10H
	
	MOV	AH, 2	;设置光标到窗口左下角
	MOV	BH, 0
	MOV	DH, WRightBottomLine
	MOV	DL, WLeftTopRow
	INT	10H
	
	MOV	AH, 0	;等待按任意键
	INT	16H
	
	MOV	AH, 9	;在当前光标位置显示一个黑底黄*
	MOV	AL, '*'
	MOV	BH, 0
	MOV	BL, 0EH
	MOV	CX,1
	INT	10H
	
	MOV	AH, 0	;等待按任意键
	INT	16H
	
	MOV	AH, 0EH	;显示回车
	MOV	AL, CR
	INT	10H
	
	MOV	AH, 0EH	;显示换行
	MOV	AL, LF
	INT	10H
	
	MOV	AH, 0	;等待按任意键
	INT	16H
	
	MOV	AH, 3	;读光标位置
	MOV	BH, 0
	INT	10H	;返回光标的当前行位置在DH中
	
	CMP	DH, WRightBottomLine+1
			;光标当前位置是窗口底行的下一行？
	JNE	L1	;不是则跳转
	
	MOV	AH, 6	;是，则整个窗口上卷一行
	MOV	AL, 1
	MOV	BH, Color
	MOV	CH, WLeftTopLine
	MOV	CL, WLeftTopRow
	MOV	DH, WRightBottomLine
	MOV	DL, WRightBottomRow
	INT	10H
	
	MOV	AH, 2	;设置光标到窗口左下角
	MOV	BH, 0
	MOV	DH, WRightBottomLine
	MOV	DL, WLeftTopRow
	INT	10H
	
	MOV	AH, 0	;等待按任意键
	INT	16H
	
L1:	MOV	AH, 9	;显示STRING变量中的第一个字符T
	MOV	AL, STRING
	MOV	BH, 0
	MOV	BL, 4FH	;红底白字
	MOV	CX, 1
	INT 	10H
	
	MOV	AH, 0	;等待按任意键
	INT	16H
	
	MOV	AH, 13H	;显示STRING变量中剩下的串
	MOV	AL, 01
	MOV	BH, 0
	MOV	BL, Color	;白底黑字
	MOV	CX, CT - 1
	MOV	DH, WRightBottomLine
	MOV	DL, WLeftTopRow + 1
	LEA	BP, STRING + 1
	INT	10H
	
	MOV	AH, 0	;等待按任意键
	INT	16H
	
	MOV	AX, 4C00H
	INT	21H
MAIN	ENDP
CODE	ENDS
	END	MAIN	
		 
	