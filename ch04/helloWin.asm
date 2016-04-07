.386
.model flat,stdcall
option casemap:none
MessageBoxA PROTO :dword, :dword, :dword, :dword
MessageBox equ <MessageBoxA>
;include 语句区域
includelib user32.lib
NULL equ 0
MB_OK equ 0
.const
    ;此处添加一些常量定义
    szTitle byte 'Hi!',0
    szMsg	byte 'Hello World!',0

.code ;代码段开始
start: 
   invoke MessageBox,
   			NULL,				;HWND hWnd
   			offset szMsg,
   			offset szTitle,
   			MB_OK
   	ret
end start;  代码段结束
