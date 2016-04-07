STACKSG     SEGMENT STACK 'S'
        	DW 64 DUP('ST')
STACKSG     ENDS

DATA	SEGMENT
      CT	DB  0		;���Լ�¼ʮ����λ��
DATA	ENDS

CODE	 SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:STACKSG
MAIN  PROC  FAR
	
	MOV	AX,DATA
	MOV	DS,AX

	MOV	BX,0	; ��BX��������������

;�Ӽ�������ʮ��������������ת���ɶ�������

	MOV	AH, 2	;�س�����
	MOV	DL, 0DH
	INT	21H
	MOV	DL, 0AH
	INT	21H

NEWCHAR:
	MOV	AH,1
	INT	21H	;�Ӽ�������һλ����

	SUB	AL,30H	;��ASCII��ת��Ϊʮ������
	JL	BIN2HEX
	CMP	AL,9
	JG	BIN2HEX
	CBW		;������Ĵ�λʮ����������AX
	
	XCHG	AX,BX
	MOV	CX,10	
	MUL	CX	;��BX�е�������10���˻���
			;DX:AX�У���ʵ����AX�У���Ϊ
			;���������Ҫ��С��65536
	XCHG	AX,BX	
	ADD	BX,AX
	
	INC	CT	
	JMP	NEWCHAR

;��BX�еĶ���������ʮ������������ʽ��ʾ����

BIN2HEX:	
;���û����������ֺ������ֺ����"D="
	
	PUSH	BX
	
	MOV	AH, 3	;�����λ��
	MOV	BH, 0
	INT	10H
	
	MOV	AH, 2	;���ù�굽��ǰ�е���Ӧ��
	MOV	DL,CT	
	INT	10H
	
	MOV	AH, 2	;��ʾ'D='
	MOV	DL, 'D'
	INT	21H
	
	MOV	DL,'='
	INT	21H
	
	POP	BX
	MOV	CH,4	;һ����λʮ��������

ROTATE:
	MOV	CL,4
	ROL	BX,CL	;��BX�ĸ���λ��������λ
	MOV	AL,BL
	AND	AL,0FH
	OR	AL,30H
	CMP	AL,3AH	;��ʮ������λ����9?
	JL	PRINT
	ADD	AL,7

PRINT:
	MOV	AH,2
	MOV	DL,AL
	INT	21H
	
	DEC	CH
	JNZ	ROTATE
	
	MOV	DL,'H'	;�����һ��ʮ���������ֺ����'H'
	INT	21H
	
	MOV	AH, 2	;�س�����
	MOV	DL, 0DH
	INT	21H
	MOV	DL, 0AH
	INT	21H
	
	MOV	AX,4C00H
	INT	21H
	
MAIN	ENDP
CODE	ENDS
	END	MAIN
	
	