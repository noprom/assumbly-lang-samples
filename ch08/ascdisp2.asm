STK	  SEGMENT  STACK  'S'
	  DW  80  DUP(0)
STK	  ENDS

DATA	  SEGMENT
	COUNT	  DW	1	;COUNT为5秒的时间计数值
	CHAR	  DB	01H	;笑脸字符初始值
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
	  MOV     AH,25H		  ;设置新的1CH中断向量
	  MOV     AL,1CH
	  INT     21H
	  POP     DS

	  IN      AL,21H
	 AND     AL,11111100B	  ;增加键盘和定时器中断
	 OUT     21H,AL

	STI			  ;开中断

	;OTHER  FUNCTION
	MOV	AH,6		  ;蓝底白字清屏
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
	OR	AL,20H		;大写字母转化为小写
	CMP	AL,'q'		;是不是退出
	POP	AX		;恢复显示的字符
	JE	EXIT0		;退出

	INC	AL		;ASCII+1形成本次要显示的字符

	MOV	DX,0002H		;初始化行列号
	MOV	BH,0		;页号

PRINT10:
	INC	DH		;�кż�1
	CMP	DH,24		;�ѵ�������һ�У�
	JA	PRINT0
	ADD	DL,3		;�кż�3
	MOV	AH,2		;���ù���λ��
	INT	10H

	MOV	AH,9		;��ʾ�ַ�������
	MOV	BL,1FH		;���װ���
	MOV	CX,1
	INT	10H

	JMP	PRINT10		;������ʾ

EXIT0:
	POP     DX		;恢复1CH中断向量
        	POP     DS
        	MOV     AH,25H
        	MOV     AL,1CH
        	INT     21H

        	MOV	AH,6		  ;黑底白字清屏
	MOV	AL,0
	MOV	BH,07H
	MOV	CX,0
	MOV	DX,184FH
	INT	10H

        	MOV     AX,4C00H	  	;���ز���ϵͳ
        	INT     21H

MAIN	ENDP


INT_1CH PROC	FAR		;新的1CH中断处理子程序
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
        	PUSH	DX		;读取当前光标位置并且保存

        	MOV	AH,2		;设置光标与第一行最后一列

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
        	INT	10H		;恢复原来的光标操作

         	XOR	CHAR,00000011B	;笑脸字符取反,变为反色

         	MOV	COUNT,91	;5秒计数值重新初始化

EXIT:    	CLI			;关中断

	POP	DS
	POP	DX
	POP	CX
	POP	BX
         	POP	AX		;�ָ��Ĵ���

         	IRET			;�жϷ���

INT_1CH  ENDP
CODE       ENDS
         	END	MAIN
