/*
  � ���� ����� ������� ��� ���� ���������� ���� ������
  ���� ���� ��������� � ��������� ����� protocol.h
*/
#ifndef _typesdef_h_
#define _typesdef_h_

typedef signed char s8;
typedef unsigned char u8;
typedef const unsigned char cu8;

typedef signed short s16;
typedef unsigned short u16;

typedef signed long s32;
typedef unsigned long u32;

typedef signed long long s64;
typedef unsigned long long u64;

typedef unsigned long _TDateTime;
typedef unsigned long _TDate;
typedef unsigned long _TTime;

typedef unsigned short TCRC;

typedef unsigned long KEY;

// ���������� X ��� Y �� ������
// signed - �.�. ����� ���� �� ��������� ������
typedef signed long TCOORD;

#ifndef __emulator
typedef unsigned long DWORD;
typedef void *PVOID;
#endif


// ��� ������������� � C# 
typedef unsigned long uint;


#endif
