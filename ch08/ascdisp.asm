STK	  SEGMENT  STACK  'S'
	  DW  80  DUP(0)
STK	  ENDS

DATA	  SEGMENT
	COUNT	  DW	1	;COUNTΪ5���ʱ�����ֵ
	CHAR	  DB	01H	;���ж��ӳ�������ʾ��Ц���ַ���ʼֵ
DATA	  ENDS

CODE	  SEGMENT
	  ASSUME	CS:CODE,DS:DATA,SS:STK
MAIN	  PROC    FAR

	  MOV     AX,DATA
	  MOV     DS,AX
	  
	  MOV     AH,35H		;ȡԭ1CH�ж�����
	  MOV     AL,1CH
	  INT     21H
	  
	  PUSH    ES		;����ԭ1CH�ж�����
	  PUSH    BX
	  
	  PUSH    DS
	  MOV     DX,SEG INT_1CH
	  MOV     DS,DX
	  LEA     DX,INT_1CH
	  MOV     AH,25H		  ;������1CH�ж�����
	  MOV     AL,1CH
	  INT     21H
	  POP     DS
	  
	  IN      AL,21H
	 AND     AL,11111100B	  ;������̺Ͷ�ʱ���ж�
	 OUT     21H,AL
	 
	STI			  ;���ж�
	
	;OTHER  FUNCTION
	MOV	AH,6		  ;�����װ�������
	MOV	AL,0
	MOV	BH,1FH
	MOV	CX,0
	MOV	DX,184FH
	INT	10H
	
	MOV	AL,0
PRINT0:
	PUSH	AX		;������ʾ���ַ�
	MOV	AH,1		;�ȴ�����
	INT	21H
	OR	AL,20H		;��д��ĸת��ΪСд
	CMP	AL,'q'		;�˳���
	POP	AX		;�ָ���ʾ���ַ�
	JE	EXIT0		;���˳���ת
	
	INC	AL		;ASCIIֵ��1�γɱ���Ҫ
				;��ʾ���ַ�
	MOV	DX,0002H		;��ʼ���С��к�
	MOV	BH,0		;ҳ��

PRINT10:
	INC	DH		;�кż�1
	CMP	DH,24		;�ѵ�������һ�У�
	JA	PRINT0
	ADD	DL,3		;�кż�3
	MOV	AH,2		;���ù��λ��
	INT	10H
	
	MOV	AH,9		;��ʾ�ַ�������
	MOV	BL,1FH		;���װ���
	MOV	CX,1
	INT	10H
	
	JMP	PRINT10		;������ʾ
	
EXIT0:  
	POP     DX		;�ָ�1CH�ж�����
        	POP     DS
        	MOV     AH,25H
        	MOV     AL,1CH
        	INT     21H
        	
        	MOV	AH,6		  ;�Ժڵװ�������
	MOV	AL,0
	MOV	BH,07H
	MOV	CX,0
	MOV	DX,184FH
	INT	10H
        	
        	MOV     AX,4C00H	  	;���ز���ϵͳ
        	INT     21H
        	
MAIN	ENDP


INT_1CH PROC	FAR		;��1CH�жϴ����ӳ���
        	PUSH	AX		;����Ĵ���
        	PUSH	BX
        	PUSH	CX
        	PUSH	DX
        	PUSH	DS
        
        	STI			;���ж�
        
        	MOV	AX,DATA
        	MOV	DS,AX
        
        	DEC	COUNT
       	JNZ	EXIT
        
        	MOV	AH,3
        	MOV	BH,0
        	INT	10H
        	PUSH	DX		;����ǰ���λ�ò�����
        	
        	MOV	AH,2		;�����ڵ�һ��
        				;���һ��
        	MOV	BH,0
        	MOV	DH,0
       	 MOV	DL,79
        	INT	10H
        	
        	MOV	AH,0EH
 	MOV	BH,0
         	MOV	AL,CHAR		;��ʾЦ���ַ�
         	INT	10H
         	
         	MOV	AH,2
         	MOV	BH,0
        	POP	DX
        	INT	10H		;�ָ�ԭ���λ��
         	
         	XOR	CHAR,00000011B	;Ц���ַ���,�Է�ɫ��ʾ
         	
         	MOV	COUNT,91	;5�����ֵ���³�ʼ��
         	
EXIT:    	CLI			;���ж�

	POP	DS
	POP	DX
	POP	CX
	POP	BX
         	POP	AX		;�ָ��Ĵ���
         	
         	IRET			;�жϷ���

INT_1CH  ENDP
CODE       ENDS
         	END	MAIN	