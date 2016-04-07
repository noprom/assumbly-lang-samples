STACKSG	     SEGMENT STACK 'STK'
        	DW 32 DUP('S')
STACKSG     ENDS

DATA	SEGMENT
MSG1    	DB   '1---------CREATE',0DH,0AH	;�˵�
        	DB   '2---------UPDATE',0DH,0AH
        	DB   '3---------DELETE',0DH,0AH
        	DB   '4---------PRINT',0DH,0AH
        	DB   '5---------QUIT',0DH,0AH,'$'
        	
MSG2    	DB   'INPUT SELECT:',0DH,0AH,'$'  	;ѡ����ʾ

JMP_TAB  DW CREATE			;��ַ����ת��
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
        	
REPEAT: 	MOV AX,0600H			;����
        	MOV CX,0
        	MOV DX,184FH
        	MOV BH,07
        	INT 10H

CURSOR: MOV AH,02		;���ù��
        	MOV BH,0
        	MOV DX,0400H
        	INT 10H
        	
        	LEA DX,MSG1		;��ʾ�˵�
        	MOV AH,9
        	INT 21H
        	LEA DX,MSG2		;��ʾѡ����ʾ
        	INT 21H

RDKB:   	MOV AH,1		;�ȴ�����ѡ���
        	INT 21H
        	
        	CMP AL,31H		;ѡ��Ϸ��Լ��
        	JB BEEP			;���Ƿ���ת��
        	CMP AL,35H
        	JA BEEP			;����Ĺ��ܺ�Ӧ��'31' - '35'֮��
        	
        	AND AL,0FH	   	 ;ASCII��ת��Ϊ��ѹ��BCD��
        	XOR AH,AH		;(AX)�����ܺ�
        	DEC AX			;�õ�����ֵ
        	ADD AX,AX		;i��λ������(AX)*2
        	LEA BX,JMP_TAB		;װ�����ַ
        	ADD BX,AX		;�õ������ַ
        	JMP [BX]			;�������ַת��

BEEP:   	
	MOV AH,3
	MOV BH,0
	INT 10H			;�����λ��
	
	CMP  DL, 0
	JZ  NOBACK		;������λ��0�У�
				;�����ٻ���һ��
	
	MOV AH,2
	DEC DL
	INT 10H			;�ù�����һ��
				;������һ������Ĺ��ܺ�
				;���Ǵ˴εĴ�������

NOBACK:
	MOV AH,14	 	;���徯��
        	MOV AL,7
        	INT 10H
        	JMP SHORT RDKB  		;ת����ѡ��
        	
CREATE: 	MOV AH,2		;�����ļ��ӹ���
        	MOV DL,'C'
        	INT 21H
        	
        	MOV AH,0
        	INT 16H			;�ȴ���������
        	
        	JMP REPEAT		;���ز˵�

UPDATE: MOV AH,2		;�޸��ļ��ӹ���
        	MOV DL,'U'
        	INT 21H
        	
        	MOV AH,0
        	INT 16H			;�ȴ���������
        	
        	JMP REPEAT		;���ز˵�
        	
DELETE: 	MOV AH,2		;ɾ���ļ��ӹ���
        	MOV DL,'D'
        	INT 21H
        	
        	MOV AH,0
        	INT 16H			;�ȴ���������
        	
        	JMP REPEAT		;���ز˵�
        	
PRINT:  	MOV AH,2		;��ʾ�ļ��ӹ���
        	MOV DL,'P'
        	INT 21H
        	
        	MOV AH,0
        	INT 16H			;�ȴ���������
        	
        	JMP REPEAT		;���ز˵�
        	
QUIT:   	RET			;���ز���ϵͳ

MAIN    	ENDP
CODE    	ENDS
        	END     MAIN

