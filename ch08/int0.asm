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
        	MOV	AX,2500H		;����0���ж�����
        	INT	21H
        	
        	LEA	DX,SIGNON
        	MOV	AH,9
        	INT	21H
	
	MOV	DX,((PGM_LEN+15)/16)+10H	
				;����Ҫפ���Ľ���
				
        	MOV	AX,3100H		;������פ��
       	 INT	21H
MAIN    ENDP


ZDIV    PROC    FAR
        	PUSH	AX		;����Ĵ���
	PUSH	BX
        	PUSH	CX
        	PUSH	DX
        	PUSH	DS
        	
        	STI			;���ж�
        	
 	MOV	AX,CS
        	MOV	DS,AX
        
ZDIV0:      LEA	DX,WARN
        	MOV	AH,9
        	INT	21H

ZDIV1:  	MOV	AH,1		;�ȴ�ѡ��
        	INT	21H
        
        	SUB	AL,20H		;Сд��ĸת��Ϊ��д
        	CMP	AL,'C'
        	JE	ZDIV3		;��ΪCת
        	CMP	AL,'Q'
        	JE	ZDIV2		;��ΪQת����
        	
        	LEA	DX,BAD		;����
        	MOV	AH,9
        	INT	21H
        	JMP	ZDIV0
        	
ZDIV2:  	MOV	AX,4CFFH
        	INT	21H
        	
ZDIV3:  	LEA	DX,CRLF
        	MOV	AH,9
        	INT	21H
        
        	CLI			;���ж�
	
	POP	DS		;�ָ��Ĵ���
	POP	DX
	POP	CX
	POP	BX			
        	POP	AX
        		
        	IRET			;�жϷ���
ZDIV    ENDP

SIGNON      DB  CR,LF,'Divide by zero interrupt handler installed',CR,LF,'$'
WARN	   DB  CR,LF,'Divide by zero detected.'
	   DB  CR,LF,'Continue or Quit (C/Q)?$'
BAD	   DB  BEEP,BACK,' ',BACK,'$'
CRLF	   DB  CR,LF,'$'

PGM_LEN  EQU $-START		;���ֽ�Ϊ��λ�ĳ��򳤶�

CODE	   ENDS
	   END MAIN