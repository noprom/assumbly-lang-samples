STACKSG     SEGMENT STACK 'STK'
       	DW 32 DUP('S')
STACKSG     ENDS

DATA    	SEGMENT
      BUFFER  DW 500,30,56,77,999,67,433,5675,0,9999		;�����
                  	     DW 3455,6578,32766,8,0,32560,45,889,5665,09
      CN      	     DW    ($-BUFFER)/2	;Ԫ�ظ���
      MAX         DW    ?			;����������Ԫ
      MIN          DW    ? 		;�����С����Ԫ
DATA    	ENDS

CODE    	SEGMENT
MAIN    	PROC FAR
        	ASSUME  CS:CODE , DS:DATA
        	
        	PUSH DS
        	XOR AX,AX
        	PUSH AX
        	
        	MOV AX,DATA
        	MOV DS,AX
        	
        	LEA SI,BUFFER	 ;��ʼ����ַָ��
        	MOV CX,CN	 ;Ԫ�ظ���
        	MOV AX,[SI]	 ;ȡ��һ��
        	DEC CX
        	MOV MAX,AX	 ;��ʼ�������
        	MOV MIN,AX	 ;��ʼ����С��
        	
COMP:	ADD SI,2		 ;�޸ĵ�ַָ��
	MOV AX,[SI]	;ȡ��һ����
	CMP AX,MAX	;�뵱ǰ��������Ƚ�
	JL NEXT		;��С��תNEXT
	JE LOP		;������תLOP
	MOV MAX,AX	;��������Ѵ�����Ϊ
			;���������
	JMP SHORT LOP
NEXT:	CMP AX,MIN	;�뵱ǰ����С���Ƚ�
   	JGE LOP		;�����ڵ���ת
   	MOV MIN,AX	;��С����Ѵ�����Ϊ
   			;��С������
LOP:	 LOOP COMP	;����ѭ������������ֹ

	RET

MAIN 	ENDP
CODE 	ENDS
    	END     MAIN