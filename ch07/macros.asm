;-----------------------------------
;功能：保存寄存器DX、CX、BX、AX
;-----------------------------------
PUSHREG      MACRO
	PUSH  DX
	PUSH  CX
	PUSH  BX
	PUSH  AX
	     ENDM

;-----------------------------------
;功能：恢复寄存器AX、BX、CX、DX
;-----------------------------------
POPREG	MACRO
	POP  AX
	POP  BX
	POP  CX
	POP  DX
	ENDM

;-----------------------------------
;功能：清屏
;-----------------------------------
CLRSCRN    MACRO
	PUSHREG
	MOV  AH,6
	MOV  AL,0
	MOV  BH,1FH
	MOV  CX,0
	MOV  DX,184FH
	INT  10H
	POPREG
	     ENDM

;-----------------------------------
;功能：置光标
;入口参数：DH:DL 行,列  出口参数：无
;-----------------------------------
CURSOR	  MACRO
	PUSH  AX
	PUSH  BX
	MOV   AH,2
	XOR   BH,BH
	INT   10H
	POP   BX
	POP   AX
	  ENDM

;-----------------------------------------
;功能：在指定位置显示指定颜色的字符
;入口参数：X:行,Y:列,CHAR:字符,ATTRIB:颜色
;出口参数：无
;-----------------------------------------
PUTC	  MACRO	X,Y,CHAR,ATTRIB
	PUSHREG
	MOV  DH,X
	MOV  DL,Y
	CURSOR
	MOV  AH,09H
	MOV  AL,CHAR
	MOV  BH,0
	MOV  BL,ATTRIB
	MOV  CX,1
	INT  10H
	POPREG
	  ENDM

;-----------------------------------------
;功能:在指定位置显示指定颜色的字符串
;入口参数:以$结束的字符串变量S ；出口参数:无
;-----------------------------------------
PUTS	  MACRO ROW,COL,S,ATTRIB
	LOCAL  EXIT5
	LOCAL  LOOP10

	PUSHREG
	MOV    DH,ROW
	MOV    DL,COL
	CURSOR
	LEA      BX,S
	MOV    CX,80

LOOP10:	MOV   AL,[BX]
	CMP   AL,'$'
	JE    EXIT5
	PUTC  DH,DL,AL,ATTRIB
	INC   DL
	INC   BX
	LOOP  LOOP10

EXIT5:	POPREG
	   ENDM


DATA	SEGMENT
	STR   DB  'PRINT A STRING.$'
DATA 	ENDS

CODE 	SEGMENT
	ASSUME	CS:CODE,DS:DATA
MAIN  	PROC  FAR

	MOV   AX,DATA
	MOV   DS,AX

	CLRSCRN			;清屏
	MOV   DH,10H
	MOV   DL,20H
	PUTC  DH,DL,'$',1EH		;兰底黄＄

	PUTC  DH,21H,STR,1FH		;兰底白色字符P
					;(STR变量中第一个字符)

	INC   DH				 ;行号加1
	PUTS  DH,DL,STR,1FH		 ;用兰底白字显示字符串
					 ;PRINT A STRING.

	MOV   AX,4C00H
	INT   21H
MAIN	ENDP
CODE	ENDS
	END   MAIN
