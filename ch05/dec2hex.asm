STACKSG     SEGMENT STACK 'S'
        	DW 64 DUP('ST')
STACKSG     ENDS

DATA	SEGMENT
      CT	DB  0		;用以记录十进制位数
DATA	ENDS

CODE	 SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:STACKSG
MAIN  PROC  FAR
	
	MOV	AX,DATA
	MOV	DS,AX

	MOV	BX,0	; 用BX来存放输入的数据

;从键盘输入十进制数，并将其转换成二进制数

	MOV	AH, 2	;回车换行
	MOV	DL, 0DH
	INT	21H
	MOV	DL, 0AH
	INT	21H

NEWCHAR:
	MOV	AH,1
	INT	21H	;从键盘输入一位数字

	SUB	AL,30H	;将ASCII码转换为十进制数
	JL	BIN2HEX
	CMP	AL,9
	JG	BIN2HEX
	CBW		;将输入的此位十进制数放入AX
	
	XCHG	AX,BX
	MOV	CX,10	
	MUL	CX	;将BX中的数乘以10，乘积在
			;DX:AX中，但实际在AX中，因为
			;输入的数字要求小于65536
	XCHG	AX,BX	
	ADD	BX,AX
	
	INC	CT	
	JMP	NEWCHAR

;将BX中的二进制数以十六进制数的形式显示出来

BIN2HEX:	
;在用户输入完数字后，在数字后加上"D="
	
	PUSH	BX
	
	MOV	AH, 3	;读光标位置
	MOV	BH, 0
	INT	10H
	
	MOV	AH, 2	;设置光标到当前行的相应列
	MOV	DL,CT	
	INT	10H
	
	MOV	AH, 2	;显示'D='
	MOV	DL, 'D'
	INT	21H
	
	MOV	DL,'='
	INT	21H
	
	POP	BX
	MOV	CH,4	;一共四位十六进制数

ROTATE:
	MOV	CL,4
	ROL	BX,CL	;将BX的高四位移至低四位
	MOV	AL,BL
	AND	AL,0FH
	OR	AL,30H
	CMP	AL,3AH	;该十六进制位大于9?
	JL	PRINT
	ADD	AL,7

PRINT:
	MOV	AH,2
	MOV	DL,AL
	INT	21H
	
	DEC	CH
	JNZ	ROTATE
	
	MOV	DL,'H'	;在最后一个十六进制数字后加上'H'
	INT	21H
	
	MOV	AH, 2	;回车换行
	MOV	DL, 0DH
	INT	21H
	MOV	DL, 0AH
	INT	21H
	
	MOV	AX,4C00H
	INT	21H
	
MAIN	ENDP
CODE	ENDS
	END	MAIN
	
	