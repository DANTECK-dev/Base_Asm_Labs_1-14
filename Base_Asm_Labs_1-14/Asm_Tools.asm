.code
;-------------------------------------------------------------------------------------------------------------
;#region Make_Sum
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
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Get_Pos_Address
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
	add rdi, rax			; RDI = screen_buffer + address_offset
	
	ret

Get_Pos_Address endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Draw_Start_Symbol
Draw_Start_Symbol proc
; Получаем стартовый символ и атрибуты, и выводим его
; Параметры:
; RDI - текущий адрес в буфере окна
; R8 - symbol
; Возврат: None

	push rax
	push rbx

	mov eax, r8d
	mov rbx, r8
	shr rbx, 32					; RBX = EBX = { symbol.Start_Symbol, symbol.End_Symbol}
	mov ax, bx					; EAX = { symbol.Attribytes, symbol.Start_Symbol}
	
	stosd						; Вывод стартового символа

	pop rbx
	pop rax

	ret

Draw_Start_Symbol endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Draw_End_Symbol
Draw_End_Symbol proc
; Получаем конечный символ и атрибуты, и выводим его
; Параметры:
; EAX = { symbol.Attribytes, symbol.Main_Symbol}
; RDI - текущий адрес в буфере окна
; R8 - symbol
; Возврат: None
	
	push rax
	push rbx

	mov eax, r8d
	mov rbx, r8
	shr rbx, 48					; RBX = BX = symbol.End_Symbol
	mov ax, bx					; EAX = { symbol.Attribytes, symbol.End_Symbol}
	
	stosd						; Вывод конечного символа символа
	
	pop rbx
	pop rax

	ret

Draw_End_Symbol endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Get_Screen_Width_Size
Get_Screen_Width_Size proc
; Вычисление ширину экрана в байтах
; RDX - Spos pos или SArea_Pos area_pos
; Возврата: R11 = pos.Screen_Width * 4

	mov r11, rdx
	shr r11, 32				; R11 = Pos
	movzx r11, r11w			; R11 = R11W = pos.Screen_Width
	shl r11, 2				; умножаем на 4 R11 * 4

	ret

Get_Screen_Width_Size endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Draw_Line_Horizontal
Draw_Line_Horizontal proc
; extern "C" void Draw_Line_Horizontal(CHAR_INFO *screen_buffer, SPos pos,  ASymbol symbol);
; Параметры:
; RCX - screen_buffer
; RDX - pos & len
; R8 - symbol
; R9 - -
; Возврат: none

	

	push rax					; временое хранение регисторов которые мы хотим изменить
	push rbx
	push rcx
	push rdi

							; 1. Вычисляем адрес вывода
	call Get_Pos_Address		; RDI = позиция символа в буфере screen_buffer в позиции pos

	call Draw_Start_symbol	; 2. Получаем стартовый символ и атрибуты, и выводим его

							; 3. Выводим главные символы symbol.Main_Symbol
	mov eax, r8d				; подготовили значение которе надо записать
	mov rcx, rdx 
	shr rcx, 48					; RCX = CX = pos.Len

	rep stosd					; STOre String Dword

	call Draw_End_Symbol	; 4. Получаем конечный символ и атрибуты, и выводим его

	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

Draw_Line_Horizontal endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Draw_Line_Vertical
Draw_Line_Vertical proc
; extern "C" void Draw_Line_Vertical(CHAR_INFO *screen_buffer, SPos pos,  ASymbol symbol);
; Параметры:
; RCX - screen_buffer
; RDX - pos & len
; R8 - symbol
; R9 - -
; Возврат: none

	push rax	
	push rcx	
	push rdi	
	push r11	

							; 1. Вычисляем адрес вывода
	call Get_Pos_Address		; RDI = позиция символа в буфере screen_buffer в позиции pos

							; 2. Вычисление коррекции позиции вывода
	mov r11, rdx
	shr r11, 32					; R11 = Pos
	movzx r11, r11w				; R11 = R11W = pos.Screen_Width
	dec r11
	shl r11, 2					; умножаем на 4 R11 * 4

	call Draw_Start_symbol	; 3. Получаем стартовый символ и атрибуты, и выводим его

	add rdi, r11				; Прибавляем коррекцию

	mov rcx, rdx			; 4. Подготовка к циклу
	shr rcx, 48					; RCX = CX = pos.Len

	mov eax, r8d				; EAX = symbol

	_vertical:					; вывод символа 
		stosd
		add rdi, r11			; Перенос строки на следующий
	loop _vertical

							
	call Draw_End_Symbol	; 5. Получаем конечный символ и атрибуты, и выводим его

	pop r11
	pop rdi
	pop rcx
	pop rax

	ret

Draw_Line_Vertical endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Show_Colors
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
	call Get_Pos_Address			; RDI = позиция символа в буфере screen_buffer в позиции pos
									
	
	mov r10, rdi					; Сохраняем копию адреса

						
	call Get_Screen_Width_Size	; 2. Вычисление коррекции позиции вывода
									; R11 = pos.Screen_Width * 4 = Ширина экрана в байтах
	
								; 3. Готовим циклы
	mov rax, r8						; RAX = EAX = symbol

	and rax, 0ffffh					; обнуляем левые 6 байфт RAX
									; значение чисел начинаются с цифры = 0 00 00 00 00 00 00 ff ff ff

	mov rbx, 16						; внешний счетчик
	; mov rcx, 0					; медленное обнуление
	xor rcx, rcx					; RCX = 0 быстрое обнуление
	_external_rainbow:

		mov cl, 16					; внутрений счетчик
		_internal_rainbow:

			stosd
			add rax, 010000h		; Шаг атрибута на 16 разрядов, для изменения цвета

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
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Clear_Area
Clear_Area proc
; extern "C" void Clear_Area(CHAR_INFO* screen_buffer, SArea_Pos area_pos, ASymbol symbol);
; Параметры:
; RCX - screen_buffer
; RDX - area_pos
; R8 - symbol
; R9 - -
; Возврат: None

	push rax
	push rbx
	push rcx
	push rdi
	push r10
	push r11

						; 1. Вычисляем адрес вывода
	call Get_Pos_Address	; RDI = позиция символа в буфере screen_buffer в позиции pos
	
	mov r10, rdi			; Сохраняем копию адреса

	call Get_Screen_Width_Size	; 2. Вычисление коррекции позиции вывода
									; R11 = pos.Screen_Width * 4 = Ширина экрана в байтах
	
						; 3. Готовим циклы
	mov rax, r8			; RAX = R8D = symbol

	mov rbx, rdx
	shr rbx, 48				; BH = area_pos.Height, BL = area_pos.Width

	; mov rcx, 0			; медленное обнуление
	xor rcx, rcx			; RCX = 0 быстрое обнуление
	_loop_fill:

		mov cl, bl			; внутрений счетчик
		rep stosd

		add r10, r11
		mov rdi, r10

		dec bh
	jnz _loop_fill

	pop r11
	pop r10
	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

Clear_Area endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Draw_Limited_Text
Draw_Text proc
; extern "C" void Draw_Text(CHAR_INFO* screen_buffer, SText_Pos pos, wchar_t *str);
; Параметры:
; RCX - screen_buffer
; RDX - pos
; R8 - str
; R9 - -
; Возврат: RAX - длина стороки str

	push rbx
	push rdi
	push r8
	
						; 1. Вычисляем адрес вывода
	call Get_Pos_Address	; RDI = позиция символа в буфере screen_buffer в позиции pos

	mov rax, rdx
	shr rax, 32				; Старшая половина EAX = pos.Atribute

	xor rbx, rbx			; RBX = 0 

	_main_loop:
		mov ax, [ r8 ]		; AL - очередной символ из строки 

		cmp ax, 0			; Сравнение битов если = 0 то флаг je
		je _exit			; jump is equals

		add r8, 2			; Переводим указатель на следущий символ

		stosd
		inc rbx				; Прибавляем счетчикк длины слова
	jmp _main_loop			; Прекращаем вывод, если строка достигла предела


_exit:
	mov rax, rbx

	pop r8
	pop rdi
	pop rbx

	ret

Draw_Text endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Draw_Limited_Text
Draw_Limited_Text proc
; extern "C" void Draw_Limited_Text(CHAR_INFO* screen_buffer, SText_Pos pos, wchar_t str, unsigned short limit);
; Параметры:
; RCX - screen_buffer
; RDX - pos
; R8 - str
; R9 - limit
; Возврат: RAX - длина стороки str

	push rax
	push rcx
	push rdi
	push r8
	push r9
	
						; 1. Вычисляем адрес вывода
	call Get_Pos_Address	; RDI = позиция символа в буфере screen_buffer в позиции pos

	mov rax, rdx
	shr rax, 32				; Старшая половина EAX = pos.Atribute

	xor rbx, rbx			; RBX = 0 

	_main_loop:
		mov ax, [ r8 ]		; AL - очередной символ из строки 

		cmp ax, 0			; Сравнение байта если равно 0 то флаг je
		je _fill_spaces		; jump equals

		add r8, 2			; Переводим указатель на следущий символ

		stosd

		dec r9
		cmp r9, 0

		inc rbx				; Прибавляем счетчикк длины слова
		je _exit			; Прекращаем вывод, если строка достигла предела

	jmp _main_loop
	 
	_fill_spaces:
		mov ax, 020h		; Заполняем пробелами
		mov rcx, r9			; Кол-во оставшиехся пробелов

		rep stosd

_exit:
	mov rax, rbx

	pop r9
	pop r8
	pop rdi
	pop rcx
	pop rax

	ret

Draw_Limited_Text endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
end