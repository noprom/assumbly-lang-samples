COM_I	PROC	FAR
	PUSH	DX
	
	MOV	DX,3FDH		;״̬�˿ں�	
COM_I0:	IN	AL,DX		;��״̬��Ϣ
	TEST	AL,1		;�������ݾ�����
	JZ	COM_I0		;δ����������ѯ
	
	MOV	DX,3F8H		;�����ݶ˿ڽ���һ���ַ�			
	IN	AL,DX
	
	POP	DX
	RET
COM_I	ENDP


COM_O	PROC	FAR
	PUSH	DX
		
	PUSH	AX	   	;����Ҫ������ַ�
	MOV	DX,3FDH	
COM_O1:	IN	AL,DX	   	;��״̬��Ϣ
	TEST	AL,20H		;���ͱ��ּĴ���Ϊ�գ�
	JZ	COM_O1  	;���ռ�����ѯ
	
	POP	AX
	MOV	DX,3F8H
	OUT	DX,AL	   	;���һ���ַ�
		
	POP	DX
	RET
COM_O	ENDP