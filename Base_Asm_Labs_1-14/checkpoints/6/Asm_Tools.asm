.code
;-------------------------------------------------------------------------------------------------------------
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
;-------------------------------------------------------------------------------------------------------------
Draw_Line proc
; extern "C" void Draw_Line(CHAR_INFO *screen_buffer, SPos pos, int len, CHAR_INFO symbol);
; ���������:
; RCX - screen_buffer
; RDX - pos
; R8 - len
; R9 - symbol
; �������: RAX

	; ������������ ���������� �� ����� ���������� ���� 
	; _put_symbol:	
		; mov [ rcx ], r9d
		; add rcx, 4
		; mov [ rcx ], r9d
		; dec r8 ; decrient 
		; jnz _put_symbol ; jump not zero last arif  r8

	push rax ; �������� �������� ���������� ������� �� ����� ��������
	push rcx
	push rdi

	; ������� �������
	mov rdi, rcx ; ����������� ����� ���� ������
	mov eax, r9d ; ����������� �������� ������ ���� ��������
	mov rcx, r8	; ���������� � ������� ���������� ��� rep 

	; ��� ����� �� ���� �� ����� ���������� �������
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