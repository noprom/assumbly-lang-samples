STACKSG     SEGMENT STACK 'S'
	DW 64 DUP('ST')
STACKSG     ENDS

DATA    	SEGMENT
	X       DW   12H,34H,56H,78H,90H
	          DW   0ABH,0CDH,0EFH,0F1H,023H
	Y       DW   9,8,7,6,5,4,3,2,1,0
	Z       DW   10 DUP(?)
            RULE     DW   0000000011011100B		;�߼���
DATA    	ENDS

CODE	SEGMENT
	ASSUME  CS:CODE , DS:DATA , SS:STACKSG
MAIN  PROC  FAR
	
	MOV   AX,DATA
	MOV   DS,AX
	
	MOV   BX,0			;��ַָ��
	MOV   CX,10			;ѭ������
	MOV   DX,RULE			;�߼���

NEXT: 	MOV   AX,X[BX]  			;ȡX�е�һ����
	SHR   DX,1	   	                  ;�߼�������һλ
	JC    SUBS     			;��֧�жϲ�ʵ��ת��
	ADD     AX,Y[BX]	   		 ;������
	JMP     SHORT  RESULT

SUBS:   	SUB     AX,Y[BX]  			;������

RESULT: 	MOV     Z[BX],AX			;����

        	ADD     BX,2	   		;�޸ĵ�ַָ��
        	LOOP    NEXT
        	
        	MOV     AX,4C00H
        	INT     21H
        	
MAIN    	ENDP
CODE    	ENDS
	END     MAIN