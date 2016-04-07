STACKSG     SEGMENT STACK 'S'
        	DW 64 DUP('ST')
STACKSG     ENDS

DATA    	SEGMENT
BUF    DB  30H,31H,32H,33H,34H,35H,36H,37H,38H,39H,41H,42H,43H,44H,45H,46H
				;�����
COUNT   EQU $-BUF		;������
CHAR    DB  ?			;Ҫ���ҵ���
MARK    DW  0			;���Ҵ���
PROMPT  DB  'NO FOUND$'	;û�ҵ���ʾ��Ϣ
DATA    	ENDS 

CODE	 SEGMENT
	ASSUME CS:CODE , DS:DATA , SS:STACKSG
MAIN  PROC  FAR

      MOV   AX,DATA
      MOV   DS,AX
      
      MOV   AH,1	 ;����Ҫ���������ַ�
      INT   21H
      
      MOV   CHAR,AL ;����Ҫ�ҵ���
      
      LEA   SI,BUF	 ;����ʼ��ַ����ʼ���������ޣ���
      MOV   CX,COUNT				
      MOV   DI,SI					
      ADD   DI,CX	 ;������ĵ�ַ��1
    	                  	;��ʼ���������ޣ��ң�
    	                  	
      MOV   DX,0	;��ʼ�����Ҵ���
      
      MOV BX,SI	;�������б߽�Ԫ�ؽ����ȣ���BX��ָ���ҵ����ַ�
      CMP  AL,[SI]	 ;�б߽�Ԫ��
      JB   NOFID   	 ;С�ڱ�����С��תδ�ҵ�
      JE   FOUND	 ;�Ǳ�����С��ת�ҵ�
      
      MOV  BX,DI
      DEC   BX	;�������б߽�Ԫ�ؽ����ȣ���BX��ָ���ҵ����ַ�
      CMP  AL,[DI-1]	;�б߽�Ԫ��
      JA   NOFID	 ;���ڱ��������תδ�ҵ�
      JE   FOUND	 ;�Ǳ��������ת�ҵ�
      
      MOV  DX,1	 ;��ʼ�����Ҵ���
      
C1:   
      MOV  BX,SI	   ;ѭ�����
      ADD  BX,DI	
      SHR  BX,1	   ;�۰�
      
      CMP  BX,SI	   ;ָ�룽�����𣿣�ѭ����ֹ������
       JZ   NOFID	   ;�����ڱ�ʾδ�ҵ���ת
       
      CMP  AL,[BX]	   ;�Ƚ�
       JZ   FOUND	   ;�ҵ�ת
       JL   LESS	   ;�������������ת
       MOV  SI,BX	   ;�������Ұ�������������
       JMP  SHORT NEXT
       
LESS:  
       MOV  DI,BX	   ;��������
       
NEXT:  
        INC  DX	 ;���Ҵ�����1
       JMP  C1
       
NOFID: 
       LEA  DX,PROMPT  ;��ʾδ�ҵ���ʾ��Ϣ
       MOV  AH,9     
       INT  21H      
       JMP  SHORT EXIT   

FOUND:  	
      MOV     MARK,DX  ;������Ҵ���
      
      MOV     AH,2	     ;��ʾ�ҵ�����
      MOV     DL,[BX]
      INT     21H
      
      MOV	AX,MARK
      MOV     CL,10	
      DIV     CL 	;�Ѳ��Ҵ���ת����ʮ������
      OR      AX,3030H	;ת����ASCII��
       
      MOV     DL,AL
      PUSH    AX
      MOV     AH,2	;��ʾ���Ҵ����ĸ�λ
      INT     21H
      
      POP     AX
      MOV     DL,AH
      MOV     AH,2	;��ʾ���Ҵ����ĵ�λ
      INT     21H
      
EXIT:  	
      MOV     AX,4C00H
      INT     21H
      
MAIN     	ENDP
CODE     	ENDS
         	END     MAIN
