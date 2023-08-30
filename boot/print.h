#ifndef _PRINT_H_
#define _PRINT_H_

#define LINE_SIZE 160 // 80 characters each line in text mode, each character takes 2 bytes

struct ScreenBuffer
{
    char* buffer;
    int column;
    int row;
};

int printk(const char* format, ...);




#endif