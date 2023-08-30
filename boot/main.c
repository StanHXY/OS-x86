#include "stdint.h"
// fixed width data length
#include "stddef.h"
#include "trap.h"
#include "print.h"

void KMain(void){

    char* string = "Hello";
    int64_t value = 0x12345ABD;

    init_idt();

    printk("%s/n", string);
    printk("Equal to %x", value);

}