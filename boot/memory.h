#ifndef _MEMORY_H_
#define _MEMORY_H_

#include "stdint.h"

// stores memory info retreived from BIOS
struct E820 {
    uint64_t address;
    uint64_t length;
    uint32_t type;
} __attribute__((packed));

struct FreeMemRegion {
    uint64_t address;
    uint64_t length;
};

void init_memory(void);



#endif