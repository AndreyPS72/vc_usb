#ifndef _DateTime_h_
#define _DateTime_h_

#include "typesdef.h"

#pragma pack(1)
typedef struct StDateTime {
       u8 DSec,Sec,Min,Hour;
       u16 Year;
       u8 Month,Day;
} TStDateTime;
#define szStDateTime sizeof(struct StDateTime)
#pragma pack()


#endif
