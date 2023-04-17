#ifndef _drvflash_h_
#define _drvflash_h_

#include "typesdef.h"

#ifndef DEBUG_FLASH
#define dbg_printf(...)
#else
#define dbg_printf printf(...)
#endif

/*

  �������� !!! ��� ��������� ������� ������ ����������� ������ ���� ������������

*/
#pragma pack(1)


// ��������� ��������� ECC-������
//#define ECC_FLASH_ENABLED


//������������ ���������
#define f_init  0x01
#define f_open  0x02

//��������� ��� ����������
#define stForward 0 //����� � ������
#define stBack    1 //������ � ������

//��������� ��� ������ ����� ������
#define id_expanded_main    0x00
#define id_expanded_program 0x01
#define id_expanded_hide    0x02

//��������� ��� ����������� �������������� FAT TIndexFat.block_type
#define id_block_free       0xFF
#define id_block_first      0xFE
#define id_block_middle     0xFC
#define id_block_end        0xF8
#define id_block_one        0xF0
#define id_block_bad        0xC0
#define id_block_del        0x00

//��������� ��� ������� ������/������
#define fmRead   0x0001 //��������� ������
#define fmWrite  0x0002 //��������� ������
#define fmResize 0x0004 //���������� ��������� ������� �����

//��������� ��� ����������� ����
#define equFatTypeData       0   //������ ������
#define equFatTypeConfig     1   //������������
#define equFatTypeStat       2   //����������
#define equFatTypeImpulse    3   //������
#define equFatTypeAgregat    4   //�������
#define equFatTypeRoute      5   //�������
#define equFatTypeBreak      6   //�����������
#define equFatTypePower      7   //��������
#define equFatTypeRoot       8   //�������� �������
#define equFatTypeDir        9   //����������
#define equFatTypeObj        10  //������
#define equFatTypeDsp        11  //���� ���
#define equFatTypeRazgon     12  //������-�����

#define equFatTypeAll        14  //����������� ���� ����� ������
#define equFatTypeFilter     15  //������ ��������
#define equFatTypePribor     16  //
#define equFatTypePrecession 17  //��������� ����
#define equFatTypeImage      18  //���� ��������
#define equFatTypeRMS        19

#define equFatTypeCircled    20
#define equFatTypePermanent  21
#define equFatTypeVibrometer 22

#define equFatTypeW         23
#define equFatTypeI         24
#define equFatTypeMPT       25

#define equFatTypeVoltage   26 // ����������
#define equFatTypeCurrent   27 // ���

#define equFatTypeAcoustic   28

#define equFatTypeBalance	29  // ������������ �� ��������

#define equFatTypeNone       0xFF





// ��� - ������ � FLASH
// ���������� ��� ������� �������� FLASH, � ��� ��������� � flash.cpp->NStr
// �.�. ������ 0; ����==0 - ����������� 
typedef u32 TID;


typedef struct stIndexFat
{
u8       block_type;
_TDateTime date;
u8       bad;
u8       attr;
u8       type;
u32      seek;
u32      prev;
} TIndexFat;

//��������� ��� ���������� ������ ������ ��� ����������� ������ �� flash � ecc 
typedef struct stIdxFat
{
u32       idx;     //����� �������� �� flash
TIndexFat info;    //��������� TIndexFat
}TIdxFat;

typedef struct stIdxBuf
{
u16 i;
u16 offset;
u8  buf[512];
}TIdxBuf;

typedef struct stFile
{
u8   fm;
TID  id;
u16  count;
_TDateTime date;
//��� ecc ������
TIdxFat  *idx;       //����������� ��������� ������ �������� �������� fat
u32      *page;      //��������, ��� ���������� �� flash (0 - ��� ������, 1 - �������� ��������)
TIdxBuf  *lo_b;      //����������� ��������� ������ �������� �����
TIdxBuf  *hi_b;

} TFile;
#define szTFile sizeof(TFile)

/*
�� ������������ ?
typedef struct stFatExtraData
{
u32 f_end_id;
_TDateTime f_end_date;

u32 f_first_id;
_TDateTime f_first_date;
} TFatExtraData;

#ifndef __emulator
  #define f_extra_data ((TFatExtraData *)FatExtraBuf)
#else
  extern TFatExtraData *f_extra_data;
#endif
*/


typedef struct stFatInfo
{
  u8  option;
  TID beg_block;
  TID end_block;
  u32 b_free; 
  u32 b_first;
  u32 b_middle;
  u32 b_null;
  u32 b_bad;
} TFatInfo;
  
  
extern TFatInfo f_inf;

//�������������
    s32  InitDrvFlash(void);
    void f_open_clear_flash(void);
    bool OpenFlash(void);

//�������� ������
    bool ClearFlash(void);
    u32  FreeBlockFlash(void);
    u32  FreeFlash(void);
    u32  SizeFlash(void);
    bool FileDelete(TID id);
    bool FileDeleteTestBlock(TID id);

//������ ������ ������

    // �������� ������ ����� � ������� Type==equFatTypeData
    int  FileCreate(TFile *f, TID UpLevel, u16 Attr, u32 Size,_TDateTime *Date);
    // �������� ������ ����� � �������� �����
    int  FileCreate(TFile *f, u8 dtype, TID UpLevel, u16 Attr, u32 Size,_TDateTime *Date);
    int  DirCreate(TFile *f, TID UpLevel, u16 Attr, u32 Size, _TDateTime *aDate);
    s32  FileClose(TFile *f);

    int  FileOpen(TFile *f,TID id, unsigned int Mode);
    long FileRead(TFile *f, u8 *buf, u32 offset,u32 count);
    
    s32 f_write_page_ecc(TFile *f, u32 page, u8 *buf);
    long FileWrite(TFile *f, u8 *buf, u32 offset,u32 count);
  
    bool f_delete_file_tfile_test_block_ecc(TFile *f);

    u32  FileAttr(TID id);

    // ���������� ������� ���� ���� �������� �� FLASH
    // �������� ������ ����� ������ ������
    s32  FileSize(TFile *f);

//�������
    bool  FlashRebildFreeBlock(void);
    s32   f_rebild_block_ecc(s32 *buf);

    bool  CreateList(u32 *buf,_TDateTime *date, u32 *count,u8 direction);
    void  SortList(u32 *buf,_TDateTime *date,u32 count,u8 direction);

    s32   TestFlashMiddleLevel(void);

    
    bool f_get_index(TID index, TIndexFat *info);
    
    
#pragma pack()

#endif

