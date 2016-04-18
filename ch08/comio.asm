COM_I	PROC	FAR
	PUSH	DX
	
	MOV	DX,3FDH		;状态端口号	
COM_I0:	IN	AL,DX		;读状态信息
	TEST	AL,1		;输入数据就绪？
	JZ	COM_I0		;未就绪继续查询
	
	MOV	DX,3F8H		;从数据端口接收一个字符			
	IN	AL,DX
	
	POP	DX
	RET
COM_I	ENDP


COM_O	PROC	FAR
	PUSH	DX
		
	PUSH	AX	   	;保存要输出的字符
	MOV	DX,3FDH	
COM_O1:	IN	AL,DX	   	;读状态信息
	TEST	AL,20H		;发送保持寄存器为空？
	JZ	COM_O1  	;不空继续查询
	
	POP	AX
	MOV	DX,3F8H
	OUT	DX,AL	   	;输出一个字符
		
	POP	DX
	RET
COM_O	ENDP