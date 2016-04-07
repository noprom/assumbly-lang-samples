STACKSG     SEGMENT STACK 'S'
        	DW 64 DUP('ST')
STACKSG     ENDS

DATA    	SEGMENT
BUF    DB  30H,31H,32H,33H,34H,35H,36H,37H,38H,39H,41H,42H,43H,44H,45H,46H
				;有序表
COUNT   EQU $-BUF		;表项数
CHAR    DB  ?			;要查找的数
MARK    DW  0			;查找次数
PROMPT  DB  'NO FOUND$'	;没找到提示信息
DATA    	ENDS 

CODE	 SEGMENT
	ASSUME CS:CODE , DS:DATA , SS:STACKSG
MAIN  PROC  FAR

      MOV   AX,DATA
      MOV   DS,AX
      
      MOV   AH,1	 ;输入要查找数的字符
      INT   21H
      
      MOV   CHAR,AL ;保存要找的数
      
      LEA   SI,BUF	 ;表起始地址，初始化区间下限（左）
      MOV   CX,COUNT				
      MOV   DI,SI					
      ADD   DI,CX	 ;最后数的地址加1
    	                  	;初始化区间上限（右）
    	                  	
      MOV   DX,0	;初始化查找次数
      
      MOV BX,SI	;若下面判边界元素结果相等，则BX即指向找到的字符
      CMP  AL,[SI]	 ;判边界元素
      JB   NOFID   	 ;小于表中最小数转未找到
      JE   FOUND	 ;是表中最小数转找到
      
      MOV  BX,DI
      DEC   BX	;若下面判边界元素结果相等，则BX即指向找到的字符
      CMP  AL,[DI-1]	;判边界元素
      JA   NOFID	 ;大于表中最大数转未找到
      JE   FOUND	 ;是表中最大数转找到
      
      MOV  DX,1	 ;初始化查找次数
      
C1:   
      MOV  BX,SI	   ;循环入口
      ADD  BX,DI	
      SHR  BX,1	   ;折半
      
      CMP  BX,SI	   ;指针＝下限吗？（循环终止条件）
       JZ   NOFID	   ;若等于表示未找到，转
       
      CMP  AL,[BX]	   ;比较
       JZ   FOUND	   ;找到转
       JL   LESS	   ;可能在左半区，转
       MOV  SI,BX	   ;可能在右半区，调整下限
       JMP  SHORT NEXT
       
LESS:  
       MOV  DI,BX	   ;调整上限
       
NEXT:  
        INC  DX	 ;查找次数加1
       JMP  C1
       
NOFID: 
       LEA  DX,PROMPT  ;显示未找到提示信息
       MOV  AH,9     
       INT  21H      
       JMP  SHORT EXIT   

FOUND:  	
      MOV     MARK,DX  ;保存查找次数
      
      MOV     AH,2	     ;显示找到的数
      MOV     DL,[BX]
      INT     21H
      
      MOV	AX,MARK
      MOV     CL,10	
      DIV     CL 	;把查找次数转换成十进制数
      OR      AX,3030H	;转换成ASCII码
       
      MOV     DL,AL
      PUSH    AX
      MOV     AH,2	;显示查找次数的高位
      INT     21H
      
      POP     AX
      MOV     DL,AH
      MOV     AH,2	;显示查找次数的低位
      INT     21H
      
EXIT:  	
      MOV     AX,4C00H
      INT     21H
      
MAIN     	ENDP
CODE     	ENDS
         	END     MAIN
