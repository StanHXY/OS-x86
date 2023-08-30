#ifndef _LIB_H_
#define _LIB_H_

#include <stddef.h>

// dst, value, length
void memset(void* dst, char value, int size);

// dst, src, length
void memmove(void* dst, void* src, int size);

// dst, src, length
void memcpy(void* dst, void* src, int size);


int memcmp(void* src1, void* src2, int size);

#endif