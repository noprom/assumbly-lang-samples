INPUT:	IN	AL,STAT1		;读设备1状态
	TEST	AL,20H		;输入数据就绪？
	JZ	DEV2		;未就绪转
	CALL	FAR PTR PROC1      ;执行设备1数据输入

DEV2:	IN	AL,STAT2		;读设备2状态
	TEST	AL,20H		;输入数据就绪？
	JZ	DEV3		;未就绪转
	CALL	FAR PTR PROC2      ;执行设备2数据输入
	
DEV3:	IN	AL,STAT3		;读设备3状态
	TEST	AL,20H		;输入数据就绪？
	JZ	NO_INPUT	;未就绪转
	CALL	FAR PTR PROC3      ;执行设备3数据输入
	
NO_INPUT:	.
		.
		.