STACKSG	   SEGMENT  STACK 'S'
	DW  64  DUP('ST')
STACKSG   ENDS
	
DATA	SEGMENT
    BUFFER   DB  60 ,? ,60  DUP(?)	;���뻺����
    PRINT	    DB  'To input:  ' ,'$'		;����ַ���
DATA	ENDS

CODE	SEGMENT
	ASSUME CS:CODE,DS:DATA,SS:STACKSG
MAIN	PROC	FAR
	
	MOV	AX ,DATA
	MOV	DS ,AX
	
	MOV	AH ,9		;���һ����ʾ��Ϣ
	LEA	DX ,PRINT
	INT	21H
	
	MOV	AH ,0AH		;����һ���ַ�
	LEA	DX ,BUFFER
	INT	21H
	
	MOV	AX ,4C00H
	INT	21H
	
MAIN	ENDP
CODE	ENDS
	END	MAIN
