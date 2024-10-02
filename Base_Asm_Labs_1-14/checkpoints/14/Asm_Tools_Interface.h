#pragma once

#include <windows.h>
#include "Common.h"

extern "C"
{
    int     Make_Sum(int one_value, int another_value);
    void    Draw_Line_Horizontal(CHAR_INFO* screen_buffer, SPos pos, ASymbol symbol);
    void    Draw_Line_Vertical(CHAR_INFO* screen_buffer, SPos pos, ASymbol symbol);
    void    Show_Colors(CHAR_INFO* screen_buffer, SPos pos, CHAR_INFO symbol);
    void    Clear_Area(CHAR_INFO* screen_buffer, SArea_Pos area_pos, ASymbol symbol);
    int     Draw_Text(CHAR_INFO* screen_buffer, SText_Pos pos, const wchar_t* str);
    int     Draw_Limited_Text(CHAR_INFO* screen_buffer, SText_Pos pos, const wchar_t* str, unsigned short limit);
}
//------------------------------------------------------------------------------------------------------------
