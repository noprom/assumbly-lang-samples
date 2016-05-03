STK	  SEGMENT  STACK  'S'
	  DW  80  DUP(0)
STK	  ENDS

DATA	  SEGMENT
	COUNT	  DW	1	;COUNT为5秒的时间计数值
	CHAR	  DB	01H	;在中断子程序中显示的笑脸字符初始值
DATA	  ENDS

CODE	  SEGMENT
	  ASSUME	CS:CODE,DS:DATA,SS:STK
MAIN	  PROC    FAR

	  MOV     AX,DATA
	  MOV     DS,AX

	  MOV     AH,35H		;取原1CH中断向量
	  MOV     AL,1CH
	  INT     21H

	  PUSH    ES		;保存原1CH中断向量
	  PUSH    BX

	  PUSH    DS
	  MOV     DX,SEG INT_1CH
	  MOV     DS,DX
	  LEA     DX,INT_1CH
	  MOV     AH,25H		  ;设置新1CH中断向量
	  MOV     AL,1CH
	  INT     21H
	  POP     DS

	  IN      AL,21H
	 AND     AL,11111100B	  ;增设键盘和定时器中断
	 OUT     21H,AL

	STI			  ;开中断

	;OTHER  FUNCTION
	MOV	AH,6		  ;以蓝底白字清屏
	MOV	AL,0
	MOV	BH,1FH
	MOV	CX,0
	MOV	DX,184FH
	INT	10H

	MOV	AL,0
PRINT0:
	PUSH	AX		;保存显示的字符
	MOV	AH,1		;等待输入
	INT	21H
	OR	AL,20H		;大写字母转换为小写
	CMP	AL,'q'		;退出？
	POP	AX		;恢复显示的字符
	JE	EXIT0		;若退出则转

	INC	AL		;ASCII值加1形成本次要
				;显示的字符
	MOV	DX,0002H		;初始化行、列号
	MOV	BH,0		;页号

PRINT10:
	INC	DH		;行号加1
	CMP	DH,24		;已到最下面一行？
	JA	PRINT0
	ADD	DL,3		;列号加3
	MOV	AH,2		;设置光标位置
	INT	10H

	MOV	AH,9		;显示字符和属性
	MOV	BL,1FH		;蓝底白字
	MOV	CX,1
	INT	10H

	JMP	PRINT10		;继续显示

EXIT0:
	POP     DX		;恢复1CH中断向量
        	POP     DS
        	MOV     AH,25H
        	MOV     AL,1CH
        	INT     21H

        	MOV	AH,6		  ;以黑底白字清屏
	MOV	AL,0
	MOV	BH,07H
	MOV	CX,0
	MOV	DX,184FH
	INT	10H

        	MOV     AX,4C00H	  	;返回操作系统
        	INT     21H

MAIN	ENDP


INT_1CH PROC	FAR		;新1CH中断处理子程序
        	PUSH	AX		;保存寄存器
        	PUSH	BX
        	PUSH	CX
        	PUSH	DX
        	PUSH	DS

        	STI			;开中断

        	MOV	AX,DATA
        	MOV	DS,AX

        	DEC	COUNT
       	JNZ	EXIT

        	MOV	AH,3
        	MOV	BH,0
        	INT	10H
        	PUSH	DX		;读当前光标位置并保存

        	MOV	AH,2		;设光标于第一行
        				;最后一列
        	MOV	BH,0
        	MOV	DH,0
       	 MOV	DL,79
        	INT	10H

        	MOV	AH,0EH
 	MOV	BH,0
         	MOV	AL,CHAR		;显示笑脸字符
         	INT	10H

         	MOV	AH,2
         	MOV	BH,0
        	POP	DX
        	INT	10H		;恢复原光标位置

         	XOR	CHAR,00000011B	;笑脸字符求反,以反色显示

         	MOV	COUNT,91	;5秒计数值重新初始化

EXIT:    	CLI			;关中断

	POP	DS
	POP	DX
	POP	CX
	POP	BX
         	POP	AX		;恢复寄存器

         	IRET			;中断返回

INT_1CH  ENDP
CODE       ENDS
         	END	MAIN
