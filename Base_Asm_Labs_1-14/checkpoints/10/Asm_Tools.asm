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
	call Get_Pos_Address	; RDI = ������� ������� � ������ screen_buffer � ������� pos
	
	mov r10, rdi			; ��������� ����� ������

						; 2. ���������� ��������� ������� ������
	mov r11, rdx
	shr r11, 32				; R11 = Pos
	movzx r11, r11w			; R11 = R11W = pos.Screen_Width
	shl r11, 2				; �������� �� 4 R11 * 4
	
						; 3. ������� �����
	mov rax, r8				; RAX = EAX = symbol

	and rax, 0ffffh			; �������� ����� 6 ����� RAX
							; �������� ����� ���������� � ����� = 0 00 00 00 00 00 00 ff ff ff

	mov rbx, 16				; ������� �������
	; mov rcx, 0			; ��������� ���������
	xor rcx, rcx			; RCX = 0 ������� ���������
	_external_rainbow:

		mov rcx, 16			; ��������� �������
		_internal_rainbow:

			stosd
			add rax, 010000h	; ��� �������� �� 16 ��������, ��� ��������� �����

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
end