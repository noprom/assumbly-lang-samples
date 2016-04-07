DATA  SEGMENT
	PRT   DB  	  'Duplication','$'
	INS    DB 	  'Inserted!','$'
	X        DW 	   ?   			;为数据移动预留空间
	TAB   DW    889,754,589,546,52,31	;降序数组
	CT    EQU   ($-TAB)/2  ;元素个数
	N     DW    234		   	;要插入的数字
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
	 
	 LEA    DI,TAB		;装入表首址
	 MOV    AX,N		;要插入的数字
	 MOV    CX,CT		;个数
	 CLD
	 REPNZ  SCASW
	 JE     A			;找到转
	 MOV  SI,0
	 
 COMPARE:
 	CMP  TAB[SI],AX   		 ;比较
 	JL   B		    	 ;小于转
 	MOV  BX,TAB[SI]  		 ;元素前移为插入的数字腾位置
 	MOV  TAB[SI-2],BX
 	ADD  SI,2	   		 ;修改地址指针
 	JMP  SHORT COMPARE

 A:      	MOV  AH,9H
 	LEA  DX,PRT
 	INT  21H
 	JMP  EXIT
 
 B:      	MOV  TAB[SI-2],AX 		;插入元素
 	MOV  AH,9
 	LEA  DX,INS
 	INT  21H
 
 EXIT:   	RET
 
 MAIN    ENDP
 CODE    ENDS
                END  MAIN