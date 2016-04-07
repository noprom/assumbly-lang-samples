DISPLAY	MACRO	FUNCTION,ADDRESS,CHAR
	
	MOV	AH,FUNCTION
	
	IFB	<ADDRESS>
		MOV	DL,'&CHAR'
	ELSE
		LEA	DX,ADDRESS
	ENDIF
		
	INT 21H
	
	ENDM

CODE	   SEGMENT
MAIN	   PROC	 FAR
	   ASSUME       CS:CODE,DS:CODE
	   MOV	 AX,CODE
	   MOV	 DS,AX
	   
	   DISPLAY  9,OP3         ;参数2不空,调用21H中断9号功能
	   DISPLAY  2,,E             ;参数2为空,调用21H中断2号功能
	   
	   MOV	 AX,4C00H
	   INT	 21H
	   
 OP3	   DB		 'ABC$'
 
 MAIN	   ENDP
 CODE         ENDS
	   END	 MAIN