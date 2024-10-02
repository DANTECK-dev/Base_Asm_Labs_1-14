#include "Panel.h"



//AFile_Descriptor
//------------------------------------------------------------------------------------------------------------
AFile_Descriptor::AFile_Descriptor(unsigned int attribute, unsigned int size_low, unsigned int size_high, wchar_t* file_name)
    : Attribute(attribute), File_Name(file_name)
{
    File_Size = ((unsigned long long)size_low << 32) | (unsigned long long)size_high;
}

// APanel
//------------------------------------------------------------------------------------------------------------
APanel::APanel(unsigned short x_pos, unsigned short y_pos, unsigned short width, unsigned short height, CHAR_INFO *screen_buffer, unsigned short screen_width)
: X_Pos(x_pos), Y_Pos(y_pos), Width(width), Height(height), Screen_Buffer(screen_buffer), Screen_Width(screen_width) {}

void APanel::Draw()
{
    Draw_Panels();
    Draw_Files();
}

void APanel::Get_Directory_Files()
{
    HANDLE search_handle;
    WIN32_FIND_DATAW find_data{};

    search_handle = FindFirstFile(L"*.*", &find_data);

    while (FindNextFileW(search_handle, &find_data))
    {
        AFile_Descriptor* file_descriptor = new AFile_Descriptor(find_data.dwFileAttributes, find_data.nFileSizeLow, find_data.nFileSizeHigh, find_data.cFileName);
        Files.push_back(file_descriptor);
    }
}

void APanel::Draw_Panels()
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
}

void APanel::Draw_Files()
{
    unsigned short attributes;
    int x_offeset = 0;
    int y_offeset = 2;

    for (auto* file : Files)
    {
        if (file->Attribute & FILE_ATTRIBUTE_DIRECTORY)
            attributes = 0xc3;
        else
            attributes = 0xc0;

        SText_Pos pos(X_Pos + 1 + x_offeset, Y_Pos + y_offeset, Screen_Width, attributes);
        Draw_Text(Screen_Buffer, pos, file->File_Name.c_str());

        ++y_offeset;

        if (y_offeset >= Height - 5)
        {
            if (x_offeset == 0)
            {
                x_offeset += Width / 2;
                y_offeset = 2;
            }
            else
                break;
        }
    }
}