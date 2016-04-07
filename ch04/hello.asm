.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
printf PROTO C:ptr sbyte, :VARARG

.data
szMsg byte "Hello World!", 0ah, 0dh

.code
start:
    invoke printf, offset szMsg
	ret
end start
