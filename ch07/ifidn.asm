IDT	MACRO  OPD	  	;定义宏

	IFIDN	<OPD>,<ADD>
		ADD AX,1	  	;1 若<OPD>＝<ADD>则汇编
	ENDIF

	IFIDNI	<OPD>,<ADD>
		ADD AX,2	  	;2 忽略大小写时
				;若<OPD>＝<ADD>则汇编
	ENDIF

	IFDIF	<OPD>,<ADD>
		ADD AX,3	   	;3 若<OPD>≠<ADD>则汇编
	ENDIF
	
	IFDIFI	<OPD>,<add>
		ADD AX,4	   	;4 忽略大小写时
				;若<OPD>≠<ADD>则汇编
	ENDIF
	
	ENDM
	

CODE	 SEGMENT
MAIN	 PROC	FAR
	 ASSUME	CS:CODE,DS:CODE
	 
	 MOV	 AX,CODE
	 MOV	 DS,AX
	 
	 .LALL
	 idt	 ADD		;第一次调用
	 IDT	 add		;第二次调用
	 IDT	 SUB		;第三次调用
	 
	 MOV	 AX,4C00H
	 INT	 21H
MAIN	 ENDP
CODE	 ENDS
	 END	 MAIN