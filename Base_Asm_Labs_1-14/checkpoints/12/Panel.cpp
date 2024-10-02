#include "Panel.h"




// APanel
//------------------------------------------------------------------------------------------------------------
APanel::APanel(unsigned short x_pos, unsigned short y_pos, unsigned short width, unsigned short height, CHAR_INFO *screen_buffer, unsigned short screen_width)
: X_Pos(x_pos), Y_Pos(y_pos), Width(width), Height(height), Screen_Buffer(screen_buffer), Screen_Width(screen_width) {}

void APanel::Draw()
{
    ASymbol symbol(L' ', 0xc0, L' ', L' ');
    SArea_Pos area_pos(X_Pos + 1, Y_Pos + 1, Screen_Width, Width - 2, Height - 2);
    Clear_Area(Screen_Buffer, area_pos, symbol);
    
    // 1.   Горизонтальные линии
    // 1.1. Верхние линии
    {
        ASymbol symbol(L'═', 0xc0, L'╔', L'╗');
        SPos position(X_Pos, Y_Pos, Screen_Width, Width - 2);
        Draw_Line_Horizontal(Screen_Buffer, position, symbol);
    }

    // 1.2. Нижняя линия
    {
        ASymbol symbol(L'═', 0xc0, L'╚', L'╝');
        SPos position(X_Pos, Y_Pos + Height - 1, Screen_Width, Width - 2);
        Draw_Line_Horizontal(Screen_Buffer, position, symbol);
    }

    // 2.   Вертикальная линия
    // 2.1. Левая линия
    {
        ASymbol symbol(L'║', 0xc0, L'║', L'║');
        SPos position(X_Pos, Y_Pos + 1, Screen_Width, Height - 4);
        Draw_Line_Vertical(Screen_Buffer, position, symbol);
    }
    
    // 2.2. Правая линия
    {
        ASymbol symbol(L'║', 0xc0, L'║', L'║');
        SPos position(X_Pos + Width - 1, Y_Pos + 1, Screen_Width, Height - 4);
        Draw_Line_Vertical(Screen_Buffer, position, symbol);
    }

    // 3. Средняя горизонтальные линия
    {
        ASymbol symbol(L'─', 0xc0, L'╟', L'╢');
        SPos position(X_Pos, Y_Pos + Height - 3, Screen_Width, Width - 2);
        Draw_Line_Horizontal(Screen_Buffer, position, symbol);
    }

    // 4. Средняя вертикальная линия
    {
        ASymbol symbol(L'║', 0xc0, L'╦', L'╨');
        SPos position(X_Pos + (Width / 2), Y_Pos, Screen_Width, Height - 4);
        Draw_Line_Vertical(Screen_Buffer, position, symbol);
    }

    //symbol.Char.UnicodeChar = L'─';
    //pos.Y_Pos = Height - 3;
    //Draw_Line_Horizontal(Screen_Buffer, pos, symbol);
    //
    //symbol.Attributes = 0xcb;
    //SPos pos1(20, 12, Screen_Width, 10);
    //Draw_Line_Horizontal(Screen_Buffer, pos1, symbol);
    //
    //symbol.Attributes = 0x0c;
    //SPos pos2(20, 14, Screen_Width, 10);
    //Draw_Line_Horizontal(Screen_Buffer, pos2, symbol);
    //
    //symbol.Attributes = 0xbc;
    //SPos pos3(20, 16, Screen_Width, 10);
    ////Draw_Line_Horizontal(Screen_Buffer, pos3, symbol);
    //
    //Draw_Line_Vertical(Screen_Buffer, pos3, symbol);
    
    ////SPos pos(0, 10, Screen_Width, 10);
    //Show_Colors(Screen_Buffer, pos, symbol);
}