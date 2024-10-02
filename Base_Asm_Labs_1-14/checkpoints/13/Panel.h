#pragma once

#include <windows.h>
#include <stdio.h>
#include "Asm_Tools_Interface.h"
#include <string>
#include <vector>

// AFile_Descriptor
//------------------------------------------------------------------------------------------------------------
class AFile_Descriptor
{
public:
    AFile_Descriptor(unsigned int attribute, unsigned int size_low, unsigned int size_high, wchar_t* file_name);

    unsigned int Attribute;
    unsigned long long File_Size;
    std::wstring File_Name;
};

// APanel
//------------------------------------------------------------------------------------------------------------
class APanel
{
public:
    APanel(unsigned short x_pos, unsigned short y_pos, unsigned short width, unsigned short height, CHAR_INFO* screen_buffer, unsigned short screen_width);

    void Draw();
    void Get_Directory_Files();

private:
    void Draw_Panels();
    void Draw_Files();
    unsigned short  X_Pos, Y_Pos;
    unsigned short  Width, Height;
    unsigned short  Screen_Width;
    CHAR_INFO*      Screen_Buffer;

    std::vector<AFile_Descriptor*> Files;
};
//------------------------------------------------------------------------------------------------------------
