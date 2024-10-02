.code
;-------------------------------------------------------------------------------------------------------------
Make_Sum proc
; int Make_Sum(int one_value, int another_value)
; Параметры:
; RCX - one_value
; RDX - another_value
; Возврат: RAX

	mov eax, ecx
	add eax, edx

	ret

Make_Sum endp
;-------------------------------------------------------------------------------------------------------------
Draw_Line proc
; extern "C" void Draw_Line(CHAR_INFO *screen_buffer, SPos pos, int len, CHAR_INFO symbol);
; Параметры:
; RCX - screen_buffer
; RDX - pos
; R8 - len
; R9 - symbol
; Возврат: RAX

	; неправильная реализация не очень эфективный цикл 
	; _put_symbol:	
		; mov [ rcx ], r9d
		; add rcx, 4
		; mov [ rcx ], r9d
		; dec r8 ; decrient 
		; jnz _put_symbol ; jump not zero last arif  r8

	push rax ; временое хранение регисторов которые мы хотим изменить
	push rcx
	push rdi

	; Выводим символы
	mov rdi, rcx ; подготовили адрес куда писать
	mov eax, r9d ; подготовили значение которе надо записать
	mov rcx, r8	; записываем в префикс повторения для rep 

	; это лучше но тоже не очень эфективное решение
	; _put_symbol:
	;	stosd
	;	dec r8 
	;	jnz _put_symbol

	rep stosd ; STOre String Dword

	pop rdi
	pop rcx
	pop rax

	ret

Draw_Line endp
;-------------------------------------------------------------------------------------------------------------
end