CR      	EQU 0DH
LF      	EQU 0AH
BEEP    	EQU 07H
BACK    	EQU 08H

CODE    	SEGMENT
        	ORG	 100H
        	ASSUME CS:CODE,DS:CODE

MAIN    PROC    NEAR

START:
	MOV	AX,CS
        	MOV	DS,AX
        	LEA	DX,ZDIV
        	MOV	AX,2500H		;设置0号中断向量
        	INT	21H

        	LEA	DX,SIGNON
        	MOV	AH,9
        	INT	21H

	MOV	DX,((PGM_LEN+15)/16)+10H
				;计算要驻留的节数

        	MOV	AX,3100H		;结束并驻留
       	 INT	21H
MAIN    ENDP


ZDIV    PROC    FAR
        	PUSH	AX		;保存寄存器
	PUSH	BX
        	PUSH	CX
        	PUSH	DX
        	PUSH	DS

        	STI			;开中断

 	MOV	AX,CS
        	MOV	DS,AX

ZDIV0:      LEA	DX,WARN
        	MOV	AH,9
        	INT	21H

ZDIV1:  	MOV	AH,1		;等待选择
        	INT	21H

        	SUB	AL,20H		;小写字母转换为大写
        	CMP	AL,'C'
        	JE	ZDIV3		;若为C转
        	CMP	AL,'Q'
        	JE	ZDIV2		;若为Q转结束

        	LEA	DX,BAD		;否则
        	MOV	AH,9
        	INT	21H
        	JMP	ZDIV0

ZDIV2:  	MOV	AX,4CFFH
        	INT	21H

ZDIV3:  	LEA	DX,CRLF
        	MOV	AH,9
        	INT	21H

        	CLI			;关中断

	POP	DS		;恢复寄存器
	POP	DX
	POP	CX
	POP	BX
        	POP	AX

        	IRET			;中断返回
ZDIV    ENDP

SIGNON      DB  CR,LF,'Divide by zero interrupt handler installed',CR,LF,'$'
WARN	   DB  CR,LF,'Divide by zero detected.'
	   DB  CR,LF,'Continue or Quit (C/Q)?$'
BAD	   DB  BEEP,BACK,' ',BACK,'$'
CRLF	   DB  CR,LF,'$'

PGM_LEN  EQU $-START		;以字节为单位的程序长度

CODE	   ENDS
	   END MAIN
