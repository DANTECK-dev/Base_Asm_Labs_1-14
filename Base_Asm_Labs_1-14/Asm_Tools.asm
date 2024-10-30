.code
;-------------------------------------------------------------------------------------------------------------
;#region Make_Sum
Make_Sum proc
; int Make_Sum(int one_value, int another_value)
; ���������:
; RCX - one_value
; RDX - another_value
; �������: RAX

	mov eax, ecx
	add eax, edx

	ret

Make_Sum endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Get_Pos_Address
Get_Pos_Address proc
; ���������:
; RCX - screen_buffer
; RDX - pos & len
; �������: RDI

					; 1. ��������� ����� ������						
					; address_offset = (pos.Y_Pos * pos.Screen_Width + pos.X_Pos) * 4 
						; 1.1 ��������� pos.Y_Pos * pos.Screen_Width
	mov rax, rdx
	shr rax, 16				; shift right AX = pos.Y_Pos
	movzx rax, ax			; RAX = AX = pos.Y_Pos ��������� �� ������ ������

	mov rbx, rdx
	shr rbx, 32				; BX = pos.Screen_Wight
	movzx rbx, bx			; RBX = BX = pos.Screen_Width ��������� bx �� rbx ��������� �� ������ ������

	imul rax, rbx			; RAX = RAX * RBX = pos.Y_Pos * pos.Screen_Width

						; 1.2 ������ pos.X_Pos � RAX
	movzx rbx, dx			; RBX = DX = pos.X_Pos ��������� dx �� rdx
	add rax, rbx			; RAX = pos.Y_Pos * pos.Screen_Width + pos.X_Pos = �������� � ��������

	shl rax, 2				; RAX = RAX * 4 ��������� �� 4 �� ������ = 4 �����

	mov rdi, rcx			; RDI = screen_buffer
	add rdi, rax			; RDI = screen_buffer + address_offset
	
	ret

Get_Pos_Address endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Draw_Start_Symbol
Draw_Start_Symbol proc
; �������� ��������� ������ � ��������, � ������� ���
; ���������:
; RDI - ������� ����� � ������ ����
; R8 - symbol
; �������: None

	push rax
	push rbx

	mov eax, r8d
	mov rbx, r8
	shr rbx, 32					; RBX = EBX = { symbol.Start_Symbol, symbol.End_Symbol}
	mov ax, bx					; EAX = { symbol.Attribytes, symbol.Start_Symbol}
	
	stosd						; ����� ���������� �������

	pop rbx
	pop rax

	ret

Draw_Start_Symbol endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Draw_End_Symbol
Draw_End_Symbol proc
; �������� �������� ������ � ��������, � ������� ���
; ���������:
; EAX = { symbol.Attribytes, symbol.Main_Symbol}
; RDI - ������� ����� � ������ ����
; R8 - symbol
; �������: None
	
	push rax
	push rbx

	mov eax, r8d
	mov rbx, r8
	shr rbx, 48					; RBX = BX = symbol.End_Symbol
	mov ax, bx					; EAX = { symbol.Attribytes, symbol.End_Symbol}
	
	stosd						; ����� ��������� ������� �������
	
	pop rbx
	pop rax

	ret

Draw_End_Symbol endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Get_Screen_Width_Size
Get_Screen_Width_Size proc
; ���������� ������ ������ � ������
; RDX - Spos pos ��� SArea_Pos area_pos
; ��������: R11 = pos.Screen_Width * 4

	mov r11, rdx
	shr r11, 32				; R11 = Pos
	movzx r11, r11w			; R11 = R11W = pos.Screen_Width
	shl r11, 2				; �������� �� 4 R11 * 4

	ret

Get_Screen_Width_Size endp
;#endregion
;-------------------------------------------------------------------------------------------------------------
;#region Draw_Line_Horizontal
Draw_Line_Horizontal proc
; extern "C" void Draw_Line_Horizontal(CHAR_INFO *screen_buffer, SPos pos,  ASymbol symbol);
; ���������:
; RCX - screen_buffer
; RDX - pos & len
; R8 - symbol
; R9 - -
; �������: none

	

	push rax					; �������� �������� ���������� ������� �� ����� ��������
	push rbx
	push rcx
	push rdi

							; 1. ��������� ����� ������
	call Get_Pos_Address		; RDI = ������� ������� � ������ screen_buffer � ������� pos

	call Draw_Start_symbol	; 2. �������� ��������� ������ � ��������, � ������� ���

							; 3. ������� ������� ������� symbol.Main_Symbol
	mov eax, r8d				; ����������� �������� ������ ���� ��������
	mov rcx, rdx 
	shr rcx, 48					; RCX = CX = pos.Len

	rep stosd					; STOre String Dword

	call Draw_End_Symbol	; 4. �������� �������� ������ � ��������, � ������� ���

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
; ���������:
; RCX - screen_buffer
; RDX - pos & len
; R8 - symbol
; R9 - -
; �������: none

	push rax	
	push rcx	
	push rdi	
	push r11	

							; 1. ��������� ����� ������
	call Get_Pos_Address		; RDI = ������� ������� � ������ screen_buffer � ������� pos

							; 2. ���������� ��������� ������� ������
	mov r11, rdx
	shr r11, 32					; R11 = Pos
	movzx r11, r11w				; R11 = R11W = pos.Screen_Width
	dec r11
	shl r11, 2					; �������� �� 4 R11 * 4

	call Draw_Start_symbol	; 3. �������� ��������� ������ � ��������, � ������� ���

	add rdi, r11				; ���������� ���������

	mov rcx, rdx			; 4. ���������� � �����
	shr rcx, 48					; RCX = CX = pos.Len

	mov eax, r8d				; EAX = symbol

	_vertical:					; ����� ������� 
		stosd
		add rdi, r11			; ������� ������ �� ���������
	loop _vertical

							
	call Draw_End_Symbol	; 5. �������� �������� ������ � ��������, � ������� ���

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
; ���������:
; RCX - screen_buffer
; RDX - pos & len
; R8 - symbol
; R9 - -
; �������: none

	push rax
	push rbx
	push rcx
	push rdi
	push r10
	push r11

								; 1. ��������� ����� ������
	call Get_Pos_Address			; RDI = ������� ������� � ������ screen_buffer � ������� pos
									
	
	mov r10, rdi					; ��������� ����� ������

						
	call Get_Screen_Width_Size	; 2. ���������� ��������� ������� ������
									; R11 = pos.Screen_Width * 4 = ������ ������ � ������
	
								; 3. ������� �����
	mov rax, r8						; RAX = EAX = symbol

	and rax, 0ffffh					; �������� ����� 6 ����� RAX
									; �������� ����� ���������� � ����� = 0 00 00 00 00 00 00 ff ff ff

	mov rbx, 16						; ������� �������
	; mov rcx, 0					; ��������� ���������
	xor rcx, rcx					; RCX = 0 ������� ���������
	_external_rainbow:

		mov cl, 16					; ��������� �������
		_internal_rainbow:

			stosd
			add rax, 010000h		; ��� �������� �� 16 ��������, ��� ��������� �����

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
; ���������:
; RCX - screen_buffer
; RDX - area_pos
; R8 - symbol
; R9 - -
; �������: None

	push rax
	push rbx
	push rcx
	push rdi
	push r10
	push r11

						; 1. ��������� ����� ������
	call Get_Pos_Address	; RDI = ������� ������� � ������ screen_buffer � ������� pos
	
	mov r10, rdi			; ��������� ����� ������

	call Get_Screen_Width_Size	; 2. ���������� ��������� ������� ������
									; R11 = pos.Screen_Width * 4 = ������ ������ � ������
	
						; 3. ������� �����
	mov rax, r8			; RAX = R8D = symbol

	mov rbx, rdx
	shr rbx, 48				; BH = area_pos.Height, BL = area_pos.Width

	; mov rcx, 0			; ��������� ���������
	xor rcx, rcx			; RCX = 0 ������� ���������
	_loop_fill:

		mov cl, bl			; ��������� �������
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
; ���������:
; RCX - screen_buffer
; RDX - pos
; R8 - str
; R9 - -
; �������: RAX - ����� ������� str

	push rbx
	push rdi
	push r8
	
						; 1. ��������� ����� ������
	call Get_Pos_Address	; RDI = ������� ������� � ������ screen_buffer � ������� pos

	mov rax, rdx
	shr rax, 32				; ������� �������� EAX = pos.Atribute

	xor rbx, rbx			; RBX = 0 

	_main_loop:
		mov ax, [ r8 ]		; AL - ��������� ������ �� ������ 

		cmp ax, 0			; ��������� ����� ���� = 0 �� ���� je
		je _exit			; jump is equals

		add r8, 2			; ��������� ��������� �� �������� ������

		stosd
		inc rbx				; ���������� �������� ����� �����
	jmp _main_loop			; ���������� �����, ���� ������ �������� �������


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
; ���������:
; RCX - screen_buffer
; RDX - pos
; R8 - str
; R9 - limit
; �������: RAX - ����� ������� str

	push rax
	push rcx
	push rdi
	push r8
	push r9
	
						; 1. ��������� ����� ������
	call Get_Pos_Address	; RDI = ������� ������� � ������ screen_buffer � ������� pos

	mov rax, rdx
	shr rax, 32				; ������� �������� EAX = pos.Atribute

	xor rbx, rbx			; RBX = 0 

	_main_loop:
		mov ax, [ r8 ]		; AL - ��������� ������ �� ������ 

		cmp ax, 0			; ��������� ����� ���� ����� 0 �� ���� je
		je _fill_spaces		; jump equals

		add r8, 2			; ��������� ��������� �� �������� ������

		stosd

		dec r9
		cmp r9, 0

		inc rbx				; ���������� �������� ����� �����
		je _exit			; ���������� �����, ���� ������ �������� �������

	jmp _main_loop
	 
	_fill_spaces:
		mov ax, 020h		; ��������� ���������
		mov rcx, r9			; ���-�� ����������� ��������

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