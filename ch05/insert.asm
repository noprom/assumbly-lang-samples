DATA  SEGMENT
	PRT   DB  	  'Duplication','$'
	INS    DB 	  'Inserted!','$'
	X        DW 	   ?   			;Ϊ�����ƶ�Ԥ���ռ�
	TAB   DW    889,754,589,546,52,31	;��������
	CT    EQU   ($-TAB)/2  ;Ԫ�ظ���
	N     DW    234		   	;Ҫ���������
DATA  ENDS

CODE  SEGMENT
MAIN  PROC    FAR
	ASSUME  CS:CODE , DS:DATA
	
	PUSH   DS
	SUB    AX,AX
	PUSH   AX
	 
	 MOV    AX,DATA
	 MOV    DS,AX
	 MOV    ES,AX
	 
	 LEA    DI,TAB		;װ�����ַ
	 MOV    AX,N		;Ҫ���������
	 MOV    CX,CT		;����
	 CLD
	 REPNZ  SCASW
	 JE     A			;�ҵ�ת
	 MOV  SI,0
	 
 COMPARE:
 	CMP  TAB[SI],AX   		 ;�Ƚ�
 	JL   B		    	 ;С��ת
 	MOV  BX,TAB[SI]  		 ;Ԫ��ǰ��Ϊ�����������λ��
 	MOV  TAB[SI-2],BX
 	ADD  SI,2	   		 ;�޸ĵ�ַָ��
 	JMP  SHORT COMPARE

 A:      	MOV  AH,9H
 	LEA  DX,PRT
 	INT  21H
 	JMP  EXIT
 
 B:      	MOV  TAB[SI-2],AX 		;����Ԫ��
 	MOV  AH,9
 	LEA  DX,INS
 	INT  21H
 
 EXIT:   	RET
 
 MAIN    ENDP
 CODE    ENDS
                END  MAIN