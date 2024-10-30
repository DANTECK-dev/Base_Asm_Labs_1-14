#pragma once

#include "Panel.h"

//------------------------------------------------------------------------------------------------------------
class AsCommander
{
public:
	~AsCommander();

	bool Init();
	bool Draw();

private:
	HANDLE Std_Handle = 0;
	HANDLE Screen_Buffer_Handle = 0;
	CONSOLE_SCREEN_BUFFER_INFO Screen_Buffer_Info{};
	CHAR_INFO* Screen_Buffer = 0;
	APanel* Left_Panel = 0;
	APanel* Right_Panel = 0;
};
