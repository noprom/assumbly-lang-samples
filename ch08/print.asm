;入口参数：AL中为要输出的字符
;出口参数：AH=打印机状态字节，位值＝1为真，含义如下：
;位0：超时；位2、位1：不用；位3：I/O错；位4：联机
;位5：纸用完；位6：应答；位7：闲

PRINT	PROC
	PUSH	DX
	
	MOV	BL,10	   ;设置超时值
	XOR	CX,CX	   ;清0 CX
	
	MOV	DX,378H
	OUT	DX,AL	   ;输出字符到数据端口
	
	INC	DX	   ;状态端口
B3:	IN              AL,DX	   ;读状态字节
	MOV         AH,AL	   ;状态也送入AH
	TEST         AL,80H	   ;打印机忙？
	JNZ           B4	   ;闲则转移
	LOOP       B3	   ;否则继续测试
	DEC          BL	   ;超时计数器减1
	JNZ           B3	   ;等到不忙
	                                        ;若已超时
	OR            AH,1	   ;置超时标志
	AND         AH,0F9H	   ;清0其它错误标志
	JMP          B7	   ;转到退出

B4:	MOV	AL,0DH	   ;置选通为高
	INC	DX	   ;控制端口
	OUT	DX,AL	   ;输出选通信号（瞬时）
	JMP	＄＋2	   ;延时,保证有足够选通时间
	MOV	AL,0CH	   ;使选通信号为低
	OUT          DX,AL	   ;输出低选通信号
	
B7:	POP          DX
	XOR          AH,48H	   ;取反应答位和错误位，使返回的状态
			   ;信息符合要求
	RET
PRINT	ENDP
	
