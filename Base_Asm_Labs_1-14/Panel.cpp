#include "Panel.h"

//------------------------------------------------------------------------------------------------------------
APanel::APanel(unsigned short x_pos, unsigned short y_pos, unsigned short width, unsigned short height, CHAR_INFO *screen_buffer, unsigned short screen_width)
: X_Pos(x_pos), Y_Pos(y_pos), Width(width), Height(height), Screen_Buffer(screen_buffer), Screen_Width(screen_width)
{

}

void APanel::Draw()
{
    CHAR_INFO symbol{};
    symbol.Char.UnicodeChar = L'X';
    symbol.Attributes = 0xb0;

    SPos pos0(20, 10, Screen_Width, 10);

    Draw_Line_Horizontal(Screen_Buffer, pos0, symbol);

    symbol.Attributes = 0xcb;
    SPos pos1(20, 12, Screen_Width, 10);
    Draw_Line_Horizontal(Screen_Buffer, pos1, symbol);

    symbol.Attributes = 0x0c;
    SPos pos2(20, 14, Screen_Width, 10);
    Draw_Line_Horizontal(Screen_Buffer, pos2, symbol);

    symbol.Attributes = 0xbc;
    SPos pos3(20, 16, Screen_Width, 10);
    //Draw_Line_Horizontal(Screen_Buffer, pos3, symbol);

    Draw_Line_Vertical(Screen_Buffer, pos3, symbol);

    SPos pos(0, 10, Screen_Width, 10);
    Show_Colors(Screen_Buffer, pos, symbol);
}