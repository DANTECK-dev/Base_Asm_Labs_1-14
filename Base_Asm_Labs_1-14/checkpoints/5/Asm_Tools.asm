.code

Make_Sum proc
; int Make_Sum(int one_value, int another_value)
; RCX - one_value
; RDX - another_value
; Возврат: RAX

	mov eax, ecx
	add eax, edx

	ret

Make_Sum endp

end