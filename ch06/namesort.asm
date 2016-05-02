STACKSG     SEGMENT   STACK   'STK'
        	DW 16 DUP('S')
STACKSG    ENDS

DATA    	SEGMENT

	;人名输入缓冲区
	MAXNLEN     DB	 21	     ;人名中包含的最大字符数
	NAMELEN     DB        ?	     ;人名中包含的字符数
	NAMEFLD     DB        21 DUP (?)    ;人名（实际上不超过20个字符）

	CRLF	       DB	13,10,'$'
	ENDADDR      DW	?

	MSG1	       DB	'Name:','$'
	MSG2	       DB      13,10,'Sorted names:',13,10,'$'

	CT	       DB      0	    ;输入的名字个数
	NAMETAB      DB      30  DUP(20  DUP(' '))   ;名字表
	NAMESAV      DB      20 DUP(?),13,10,'$'
	SWAPPED       DB      0

DATA    	ENDS

CODE   	SEGMENT
MAIN    	PROC    FAR
        	ASSUME  CS:CODE, DS:DATA , SS:STACKSG

        	MOV AX,DATA
        	MOV DS,AX
        	MOV ES,AX

        	CLD
        	LEA   DI,NAMETAB		;ES:DI指向NAMETAB

LOP:
	CALL    READ		;输入人名
	CMP     NAMELEN,0                   ;是否继续输入人名？
	JZ          COMPLETE
	CALL     STORE
	CMP      CT,30		;是否已输入了30个名字？
	JE          COMPLETE
	JMP       LOP

COMPLETE:
	CMP      CT,1
	JB          EXIT
	JE          DISPLAY
	CALL     SORT
DISPLAY:
	CALL     DISP
EXIT:
	MOV      AX,4C00H
	INT         21H

MAIN    	ENDP


READ	PROC   NEAR	                ;输入人名

	MOV	AH,9
	LEA	DX,MSG1	                ;显示提示
	INT	21H

	MOV	AH,0AH
	LEA	DX,MAXNLEN	;输入人名
	INT	21H

	MOV	AH,9
	LEA	DX,CRLF
	INT	21H

	MOV	BH,0
	MOV	BL,NAMELEN	;名字长度
	MOV	CX,21
	SUB	CX,BX		;计算NAMEFLD中剩余
				;字符数
CLEAR:
	MOV	NAMEFLD[BX],' '	;将剩余字符设为空格
	INC	BX
	LOOP	CLEAR

	RET

READ	ENDP


STORE	PROC	NEAR

	INC	CT
	CLD
	LEA	SI,NAMEFLD	;DS:SI指向NAMEFLD
				;ES:DI已指向NAMETAB中
				;某个名字的起始地址
	MOV	CX,10
	REP	MOVSW		;一次传10个字，即20个字节，
				;正好是一个名字

	RET

STORE	ENDP


SORT	PROC	NEAR		;气泡排序法对人名排序

	SUB	DI,20		;DI指向倒数第一个人名
	MOV	ENDADDR,DI

LOP1:	MOV	SWAPPED,0	;设交换标志为0

	SUB	ENDADDR,20	;循环刚开始时，ENDADDR指向
				;倒数第二个人名
	MOV	DI, OFFSET NAMETAB
	CMP	ENDADDR, DI
	JB	SORTED

	LEA	SI,NAMETAB	;SI指向第一个人名
LOP2:	MOV	CX,20
	MOV	DI,SI
	ADD	DI,20		;DI指向下一个人名
	MOV	AX,DI
	MOV	BX,SI		;在EXCHANGE子程序中
				;会用到

	REPE	CMPSB		;比较当前名字和下一个名字
	JBE	NOX		;若小于或等于下一个，不交换
	CALL	EXCHANGE	;否则交换
NOX:
	MOV	SI,AX		;SI指向下一个人名
	CMP	SI,ENDADDR
	JBE	LOP2
	CMP	SWAPPED,0	;该轮比较过程中是否有交换？
	JNZ	LOP1

SORTED:
	RET

SORT	ENDP


EXCHANGE      PROC      NEAR

	MOV	CX,10
	LEA	DI,NAMESAV
	MOV	SI,BX
	REP	MOVSW		;把前一个名字传送到NAMESAV，
				;传送完毕后SI指向后一个名字位置

	MOV	CX,10
	MOV	DI,BX		;DI指向前一个名字位置
	REP	MOVSW		;把后一个名字传到前一个名字位置，
				;传送完后DI指向后一个名字位置

	MOV	CX,10
	LEA	SI,NAMESAV
	REP	MOVSW		;把前一个名字传到后一个名字位置
				;完成前后名字交换

	MOV	SWAPPED,1	;表示产生了名字交换

	RET

EXCHANGE     ENDP


DISP	     PROC    NEAR

	MOV	AH,9
	LEA	DX,MSG2
	INT	21H

	LEA	SI,NAMETAB

LOPDISP:
	LEA	DI,NAMESAV
	MOV	CX,10
	REP	MOVSW		;把NAMETAB中的名字逐个
				;传送到NAMESAV中

	MOV	AH,9
	LEA	DX,NAMESAV	;将NAMESAV中的名字显示出来
	INT	21H

	DEC	CT
	JNZ	LOPDISP

	RET

DISP	      ENDP

CODE	      ENDS
	      END	MAIN
