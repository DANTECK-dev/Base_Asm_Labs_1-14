#include <windows.h>
#include <stdio.h>

//------------------------------------------------------------------------------------------------------------
struct SPos
{
    SPos(unsigned short x_pos, unsigned short y_pos, unsigned short screen_width, unsigned short len)
        : X_Pos(x_pos), Y_Pos(y_pos), Screen_Width(screen_width), Len(len) {}

    unsigned short X_Pos;
    unsigned short Y_Pos;
    unsigned short Screen_Width;
    unsigned short Len;
};
//------------------------------------------------------------------------------------------------------------
extern "C"
{
    int Make_Sum(int one_value, int another_value);
    void Draw_Line_Horizontal(CHAR_INFO* screen_buffer, SPos pos, CHAR_INFO symbol);
    void Draw_Line_Vertical(CHAR_INFO* screen_buffer, SPos pos, CHAR_INFO symbol);
    void Show_Colors(CHAR_INFO* screen_buffer, SPos pos, CHAR_INFO symbol);
}

//------------------------------------------------------------------------------------------------------------
int main(void)
{
    HANDLE std_handle, screen_buffer_handle;
    SMALL_RECT srctWriteRect;
    CONSOLE_SCREEN_BUFFER_INFO screen_buffer_info{};
    CHAR_INFO *screen_buffer;
    COORD screen_buffer_pos{};
    int screen_buffer_size;

    // Get a handle to the STDOUT screen buffer to copy from and create a new screen buffer to copy to.
    std_handle = GetStdHandle(STD_OUTPUT_HANDLE);
    screen_buffer_handle = CreateConsoleScreenBuffer(GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, 0, CONSOLE_TEXTMODE_BUFFER, 0);
    if (std_handle == INVALID_HANDLE_VALUE || screen_buffer_handle == INVALID_HANDLE_VALUE)
    {
        printf("CreateConsoleScreenBuffer failed - (%d)\n", GetLastError());
        return 1;
    }

    // Make the new screen buffer the active screen buffer.
    if (! SetConsoleActiveScreenBuffer(screen_buffer_handle) )
    {
        printf("SetConsoleActiveScreenBuffer failed - (%d)\n", GetLastError());
        return 1;
    }

    if (! GetConsoleScreenBufferInfo(screen_buffer_handle, &screen_buffer_info) )
    {
        printf("GetConsoleScreenBufferInfo failed - (%d)\n", GetLastError());
        return 1;
    }

    screen_buffer_size = (int)screen_buffer_info.dwSize.X * (int)screen_buffer_info.dwSize.Y;
    screen_buffer = new CHAR_INFO[screen_buffer_size];
    memset(screen_buffer, 0, screen_buffer_size * sizeof(CHAR_INFO));

    // Set the destination rectangle.

    srctWriteRect.Top = 10;    // top lt: row 10, col 0
    srctWriteRect.Left = 0;
    srctWriteRect.Bottom = 11; // bot. rt: row 11, col 79
    srctWriteRect.Right = 79;

    // Copy from the temporary buffer to the new screen buffer.

    //screen_buffer[0].Char.UnicodeChar = L'W';
    //screen_buffer[0].Attributes = 0x50;

    CHAR_INFO symbol{};
    symbol.Char.UnicodeChar = L'X';
    symbol.Attributes = 0xb0;    

    SPos pos0(20, 10, screen_buffer_info.dwSize.X, 10);

    Draw_Line_Horizontal(screen_buffer, pos0, symbol);

    symbol.Attributes = 0xcb;
    SPos pos1(20, 12, screen_buffer_info.dwSize.X, 10);
    Draw_Line_Horizontal(screen_buffer, pos1, symbol);

    symbol.Attributes = 0x0c;
    SPos pos2(20, 14, screen_buffer_info.dwSize.X, 10);
    Draw_Line_Horizontal(screen_buffer, pos2, symbol);

    symbol.Attributes = 0xbc;
    SPos pos3(20, 16, screen_buffer_info.dwSize.X, 10);
    //Draw_Line_Horizontal(screen_buffer, pos3, symbol);

    Draw_Line_Vertical(screen_buffer, pos3, symbol);

    SPos pos(0, 10, screen_buffer_info.dwSize.X, 10);
    Show_Colors(screen_buffer, pos, symbol);

    if (! WriteConsoleOutput(screen_buffer_handle, screen_buffer, screen_buffer_info.dwSize, screen_buffer_pos, &screen_buffer_info.srWindow) )
    {
        printf("WriteConsoleOutput failed - (%d)\n", GetLastError());
        return 1;
    }

    Sleep(150*1000);

    // Restore the original active screen buffer.

    if (! SetConsoleActiveScreenBuffer(std_handle))
    {
        printf("SetConsoleActiveScreenBuffer failed - (%d)\n", GetLastError());
        return 1;
    }

    return 0;
}
//------------------------------------------------------------------------------------------------------------
