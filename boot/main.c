#include "stdint.h"
// fixed width data length
#include "stddef.h"

void KMain(void){

    char* p = (char*)0xb8000;
    
    p[0] = 'C';
    p[1] = 0xa; // green

}