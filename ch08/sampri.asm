INPUT:	IN	AL,STAT1		;���豸1״̬
	TEST	AL,20H		;�������ݾ�����
	JZ	DEV2		;δ����ת
	CALL	FAR PTR PROC1      ;ִ���豸1��������

DEV2:	IN	AL,STAT2		;���豸2״̬
	TEST	AL,20H		;�������ݾ�����
	JZ	DEV3		;δ����ת
	CALL	FAR PTR PROC2      ;ִ���豸2��������
	
DEV3:	IN	AL,STAT3		;���豸3״̬
	TEST	AL,20H		;�������ݾ�����
	JZ	NO_INPUT	;δ����ת
	CALL	FAR PTR PROC3      ;ִ���豸3��������
	
NO_INPUT:	.
		.
		.