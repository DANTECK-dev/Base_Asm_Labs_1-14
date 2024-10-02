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
Get_Pos_Address proc
; Параметры:
; RCX - screen_buffer
; RDX - pos & len
; Возврат: RDI

					; 1. Вычисляем адрес вывода						
					; address_offset = (pos.Y_Pos * pos.Screen_Width + pos.X_Pos) * 4 
						; 1.1 Вычисляем pos.Y_Pos * pos.Screen_Width
	mov rax, rdx
	shr rax, 16				; shift right AX = pos.Y_Pos
	movzx rax, ax			; RAX = AX = pos.Y_Pos обнуление не нужнух байтов

	mov rbx, rdx
	shr rbx, 32				; BX = pos.Screen_Wight
	movzx rbx, bx			; RBX = BX = pos.Screen_Width расширяем bx до rbx обнуление не нужнух байтов

	imul rax, rbx			; RAX = RAX * RBX = pos.Y_Pos * pos.Screen_Width

						; 1.2 Доавим pos.X_Pos к RAX
	movzx rbx, dx			; RBX = DX = pos.X_Pos расширяем dx до rdx
	add rax, rbx			; RAX = pos.Y_Pos * pos.Screen_Width + pos.X_Pos = смещения в символах

	shl rax, 2				; RAX = RAX * 4 Умножение на 4 тк символ = 4 байта

	mov rdi, rcx			; RDI = screen_buffer
	add rdi, rax			; RDI = screen_buffer + addres_offset
	
	ret

Get_Pos_Address endp
;-------------------------------------------------------------------------------------------------------------
Draw_Line_Horizontal proc
; extern "C" void Draw_Line_Horizontal(CHAR_INFO *screen_buffer, SPos pos,  CHAR_INFO symbol);
; Параметры:
; RCX - screen_buffer
; RDX - pos & len
; R8 - symbol
; R9 - -
; Возврат: none

	

	push rax			; временое хранение регисторов которые мы хотим изменить
	push rbx
	push rcx
	push rdi

							; 1. Вычисляем адрес вывода
	call Get_Pos_Address	; RDI = позиция символа в буфере screen_buffer в позиции pos

					; 2. Выводим символы 
	mov eax, r8d		; подготовили значение которе надо записать
	mov rcx, rdx 
	shr rcx, 48			; RCX = CX = pos.Len

	rep stosd			; STOre String Dword

	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

Draw_Line_Horizontal endp
;-------------------------------------------------------------------------------------------------------------
Draw_Line_Vertical proc
; extern "C" void Draw_Line_Vertical(CHAR_INFO *screen_buffer, SPos pos,  CHAR_INFO symbol);
; Параметры:
; RCX - screen_buffer
; RDX - pos & len
; R8 - symbol
; R9 - -
; Возврат: none

	push rax	
	push rcx	
	push rdi	
	push r10	
	push r11	

							; 1. Вычисляем адрес вывода
	call Get_Pos_Address		; RDI = позиция символа в буфере screen_buffer в позиции pos

	mov r10, rdi				; Сохраняем копию адреса

							; 2. Вычисление коррекции позиции вывода
	mov r11, rdx
	shr r11, 32					; R11 = Pos
	movzx r11, r11w				; R11 = R11W = pos.Screen_Width
	dec r11
	shl r11, 2					; умножаем на 4 R11 * 4

	mov rcx, rdx			; 3. Подготовка к циклу
	shr rcx, 48					; RCX = CX = pos.Len

	mov eax, r8d				; EAX = symbol

	_vertical:					; вывод символа 
		stosd
		add rdi, r11				; Перенос строки на следующий
	loop _vertical

	pop r11
	pop r10
	pop rdi
	pop rcx
	pop rax

	ret

Draw_Line_Vertical endp
;-------------------------------------------------------------------------------------------------------------
Show_Colors proc
; extern "C" void Show_Colors(CHAR_INFO* screen_buffer, SPos pos, CHAR_INFO symbol);
; Параметры:
; RCX - screen_buffer
; RDX - pos & len
; R8 - symbol
; R9 - -
; Возврат: none

	push rax
	push rbx
	push rcx
	push rdi
	push r10
	push r11

						; 1. Вычисляем адрес вывода
	call Get_Pos_Address	; RDI = позиция символа в буфере screen_buffer в позиции pos
	
	mov r10, rdi			; Сохраняем копию адреса

						; 2. Вычисление коррекции позиции вывода
	mov r11, rdx
	shr r11, 32				; R11 = Pos
	movzx r11, r11w			; R11 = R11W = pos.Screen_Width
	shl r11, 2				; умножаем на 4 R11 * 4
	
						; 3. Готовим циклы
	mov rax, r8				; RAX = EAX = symbol

	and rax, 0ffffh			; обнуляем левые 6 байфт RAX
							; значение чисел начинаются с цифры = 0 00 00 00 00 00 00 ff ff ff

	mov rbx, 16				; внешний счетчик
	; mov rcx, 0			; медленное обнуление
	xor rcx, rcx			; RCX = 0 быстрое обнуление
	_external_rainbow:

		mov rcx, 16			; внутрений счетчик
		_internal_rainbow:

			stosd
			add rax, 010000h	; Шаг атрибута на 16 разрядов, для изменения цвета

		loop _internal_rainbow

	add r10, r11
	mov rdi, r10

	dec rbx
	jnz _external_rainbow

	pop r11
	pop r10
	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

Show_Colors endp
;-------------------------------------------------------------------------------------------------------------
end