MOV	FLAG,0	  	;��0������̽�����־

INPUT:	IN	AL,STAT1		;���豸1״̬
	TEST	AL,20H
	JZ	DEV2
	CALL	FAR PTR PROC1      ;ִ���豸1����������
	
	CMP	FLAG,1	    	;�豸1������̽�����
	JNZ	INPUT	    	;δ����ת,���������豸1����


DEV2:	IN	AL,STAT2		;���豸2״̬
	TEST	AL,20H
	JZ	DEV3
	CALL	FAR PTR PROC2      ;ִ���豸2����������
	
	CMP	FLAG,1	   	;�豸2������̽�����
	JNZ	INPUT		;δ����ת,���������豸1����
	
	
DEV3:	IN	AL,STAT3		;���豸3״̬
	TEST	AL,20H
	JZ	NO_INPUT
	CALL	FAR PTR PROC3      ;ִ���豸3����������
	
NO_INPUT:
	CMP	FLAG,1		;�豸3������̽�����
	JNZ	INPUT		;δ����ת,���������豸1����
		
		.
		.
		.
