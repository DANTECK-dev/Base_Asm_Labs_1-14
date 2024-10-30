#include "Panel.h"

// ASymbol
//------------------------------------------------------------------------------------------------------------
ASymbol::ASymbol(wchar_t main_symbol, unsigned short attributes, wchar_t start_symbol, wchar_t end_symbol)
    : Main_Symbol(main_symbol), Attributes(attributes), Start_Symbol(start_symbol), End_Symbol(end_symbol) {}

// SPos
//------------------------------------------------------------------------------------------------------------
SPos::SPos(unsigned short x_pos, unsigned short y_pos, unsigned short screen_width, unsigned short len)
    : X_Pos(x_pos), Y_Pos(y_pos), Screen_Width(screen_width), Len(len) {}

// APanel
//------------------------------------------------------------------------------------------------------------
APanel::APanel(unsigned short x_pos, unsigned short y_pos, unsigned short width, unsigned short height, CHAR_INFO* screen_buffer, unsigned short screen_width)
    : X_Pos(x_pos), Y_Pos(y_pos), Width(width), Height(height), Screen_Buffer(screen_buffer), Screen_Width(screen_width)
{

}

void APanel::Draw()
{

    //ASymbol vert_symbol(L'?', 0xc0, L'?', L'?');
    //vert_symbol.Char.UnicodeChar = L'?';
    //vert_symbol.Attributes = 0xc0;

    //SPos vert_pos(0, 1, Screen_Width, Height - 2);

    // 1.   Горизонтальные линии
    // 1.1. Верхние линии
    {
        ASymbol symbol(L'?', 0xc0, L'?', L'?');
        SPos position(1, 0, Screen_Width, Width - 2);
        Draw_Line_Horizontal(Screen_Buffer, position, symbol);
    }

    // 1.2. Нижняя линия
    {
        ASymbol symbol(L'?', 0xc0, L'?', L'?');
        SPos position(1, Height - 1, Screen_Width, Width - 2);
        Draw_Line_Horizontal(Screen_Buffer, position, symbol);
    }

    // 2.   Вертикальная линия
    // 2.1. Левая линия
    {
        ASymbol symbol(L'?', 0xc0, L'?', L'?');
        SPos position(1, 1, Screen_Width, Height - 4);
        Draw_Line_Vertical(Screen_Buffer, position, symbol);
    }

    // 2.2. Правая линия
    {
        ASymbol symbol(L'?', 0xc0, L'?', L'?');
        SPos position(Width, 1, Screen_Width, Height - 4);
        Draw_Line_Vertical(Screen_Buffer, position, symbol);
    }

    // 3. Средняя горизонтальные линия
    {
        ASymbol symbol(L'?', 0xc0, L'?', L'?');
        SPos position(1, Height - 3, Screen_Width, Width - 2);
        Draw_Line_Horizontal(Screen_Buffer, position, symbol);
    }

    // 4. Средняя вертикальная линия
    {
        ASymbol symbol(L'?', 0xc0, L'?', L'?');
        SPos position(Width / 2, 0, Screen_Width, Height - 4);
        Draw_Line_Vertical(Screen_Buffer, position, symbol);
    }

    //symbol.Char.UnicodeChar = L'?';
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