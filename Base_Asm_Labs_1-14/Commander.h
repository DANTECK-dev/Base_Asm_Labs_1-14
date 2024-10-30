#pragma once

#include "Panel.h"


// AMenu_Item
//------------------------------------------------------------------------------------------------------------
class AMenu_Item
{
public:
	AMenu_Item(unsigned short x_pos, unsigned short y_pos, unsigned short len, const wchar_t* key, const wchar_t* name);

	void Draw(CHAR_INFO* screen_buffer, unsigned short screen_width);

	unsigned short X_Pos;
	unsigned short Y_Pos;
	unsigned short Len;
	const wchar_t* Key, * Name;
};

//------------------------------------------------------------------------------------------------------------
class AsCommander
{
public:
	~AsCommander();

	bool Init();
	bool Draw();

private:
	void Add_Next_Menu_Item(int& index, int& x_pos, int x_step, const wchar_t* key, const wchar_t* name);
	void Build_Menu();

	HANDLE Std_Handle = 0;
	HANDLE Screen_Buffer_Handle = 0;
	CONSOLE_SCREEN_BUFFER_INFO Screen_Buffer_Info{};
	CHAR_INFO* Screen_Buffer = 0;

	APanel* Left_Panel = 0;
	APanel* Right_Panel = 0;

	AMenu_Item* Menu_Items[10]{};
};