MOV	FLAG,0	  	;清0输入过程结束标志

INPUT:	IN	AL,STAT1		;读设备1状态
	TEST	AL,20H
	JZ	DEV2
	CALL	FAR PTR PROC1      ;执行设备1的数据输入
	
	CMP	FLAG,1	    	;设备1输入过程结束？
	JNZ	INPUT	    	;未结束转,继续进行设备1输入


DEV2:	IN	AL,STAT2		;读设备2状态
	TEST	AL,20H
	JZ	DEV3
	CALL	FAR PTR PROC2      ;执行设备2的数据输入
	
	CMP	FLAG,1	   	;设备2输入过程结束？
	JNZ	INPUT		;未结束转,继续进行设备1输入
	
	
DEV3:	IN	AL,STAT3		;读设备3状态
	TEST	AL,20H
	JZ	NO_INPUT
	CALL	FAR PTR PROC3      ;执行设备3的数据输入
	
NO_INPUT:
	CMP	FLAG,1		;设备3输入过程结束？
	JNZ	INPUT		;未结束转,继续进行设备1输入
		
		.
		.
		.
