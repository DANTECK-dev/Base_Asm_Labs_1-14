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
Draw_Line_Horizontal proc
; extern "C" void Draw_Line_Horizontal(CHAR_INFO *screen_buffer, SPos pos,  CHAR_INFO symbol);
; Параметры:
; RCX - screen_buffer
; RDX - pos & len
; R8 - symbol
; R9 - -
; Возврат: RAX

	

	push rax			; временое хранение регисторов которые мы хотим изменить
	push rcx
	push rdi

					; 1. address_offset = (pos.Y_Pos * pos.Screen_Width + pos.X_Pos) * 4 ; Вычисляем адрес вывода
					; 1.1 Вычисляем pos.Y_Pos * pos.Screen_Width
	mov rax, rdx
	shr rax, 16			; shift right AX = pos.Y_Pos
	movzx rax, ax		; RAX = AX = pos.Y_Pos обнуление не нужнух байтов

	mov rbx, rdx
	shr rbx, 32			; BX = pos.Screen_Wight
	movzx rbx, bx		; RBX = BX = pos.Screen_Width расширяем bx до rbx обнуление не нужнух байтов

	imul rax, rbx		; RAX = RAX * RBX = pos.Y_Pos * pos.Screen_Width

					; 1.2 Доавим pos.X_Pos к RAX
	movzx rbx, dx		; RBX = DX = pos.X_Pos расширяем dx до rdx
	add rax, rbx		; RAX = pos.Y_Pos * pos.Screen_Width + pos.X_Pos = смещения в символах

	shl rax, 2			; RAX = RAX * 4 Умножение на 4 тк символ = 4 байта

	mov rdi, rcx		; RDI = screen_buffer
	add rdi, rax		; RDI = screen_buffer + addres_offset

					; 2. Выводим символы 
	mov eax, r8d		; подготовили значение которе надо записать
	mov rcx, rdx 
	shr rcx, 48			; RCX = CX = pos.Len

	rep stosd			; STOre String Dword

	pop rdi
	pop rcx
	pop rax

	ret

Draw_Line_Horizontal endp
;-------------------------------------------------------------------------------------------------------------
end