#include "stdint.h"
// fixed width data length
#include "stddef.h"
#include "trap.h"
#include "print.h"
#include "debug.h"
#include "memory.h"

void KMain(void){

    init_idt();
    init_memory();
    init_kvm();

}