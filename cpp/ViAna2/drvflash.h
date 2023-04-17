#ifndef _drvflash_h_
#define _drvflash_h_

#include "typesdef.h"

#ifndef DEBUG_FLASH
#define dbg_printf(...)
#else
#define dbg_printf printf(...)
#endif

/*

  Внимание !!! Все структуры данного модуля обязательно должны быть упакованными

*/
#pragma pack(1)


// Разрешить поддержку ECC-флешки
//#define ECC_FLASH_ENABLED


//опциональные константы
#define f_init  0x01
#define f_open  0x02

//константы для сортировки
#define stForward 0 //новые в начале
#define stBack    1 //старые в начале

//константы для выбора блока данных
#define id_expanded_main    0x00
#define id_expanded_program 0x01
#define id_expanded_hide    0x02

//константы для определения идентификатора FAT TIndexFat.block_type
#define id_block_free       0xFF
#define id_block_first      0xFE
#define id_block_middle     0xFC
#define id_block_end        0xF8
#define id_block_one        0xF0
#define id_block_bad        0xC0
#define id_block_del        0x00

//константы для функций чтения/записи
#define fmRead   0x0001 //разрешить запись
#define fmWrite  0x0002 //разрешить чтение
#define fmResize 0x0004 //разрешение изменения размера файла

//константы для определения типа
#define equFatTypeData       0   //просто данные
#define equFatTypeConfig     1   //конфигурация
#define equFatTypeStat       2   //статистика
#define equFatTypeImpulse    3   //импулс
#define equFatTypeAgregat    4   //агрегат
#define equFatTypeRoute      5   //маршрут
#define equFatTypeBreak      6   //выключатель
#define equFatTypePower      7   //мощность
#define equFatTypeRoot       8   //корневой каталог
#define equFatTypeDir        9   //директорий
#define equFatTypeObj        10  //объект
#define equFatTypeDsp        11  //файл ДСП
#define equFatTypeRazgon     12  //разгон-выбег

#define equFatTypeAll        14  //обозначение всех типов данных
#define equFatTypeFilter     15  //данные фильтров
#define equFatTypePribor     16  //
#define equFatTypePrecession 17  //прецессия вала
#define equFatTypeImage      18  //файл картинок
#define equFatTypeRMS        19

#define equFatTypeCircled    20
#define equFatTypePermanent  21
#define equFatTypeVibrometer 22

#define equFatTypeW         23
#define equFatTypeI         24
#define equFatTypeMPT       25

#define equFatTypeVoltage   26 // Напряжение
#define equFatTypeCurrent   27 // Ток

#define equFatTypeAcoustic   28

#define equFatTypeBalance	29  // Балансировка по вибрации

#define equFatTypeNone       0xFF





// Тип - индекс в FLASH
// уникальный для каждого элемента FLASH, у нас совпадает с flash.cpp->NStr
// Д.б. больше 0; Если==0 - неопределен 
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

//структура для индексации данных замера при однократной записи во flash с ecc 
typedef struct stIdxFat
{
u32       idx;     //номер страницы во flash
TIndexFat info;    //структура TIndexFat
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
//для ecc флэшки
TIdxFat  *idx;       //кеширование отложеной записи структур индексов fat
u32      *page;      //страницы, уже записанные во flash (0 - нет записи, 1 - страница записана)
TIdxBuf  *lo_b;      //кеширование отложеной записи структур файла
TIdxBuf  *hi_b;

} TFile;
#define szTFile sizeof(TFile)

/*
Не используется ?
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

//Инициализация
    s32  InitDrvFlash(void);
    void f_open_clear_flash(void);
    bool OpenFlash(void);

//Стирание данных
    bool ClearFlash(void);
    u32  FreeBlockFlash(void);
    u32  FreeFlash(void);
    u32  SizeFlash(void);
    bool FileDelete(TID id);
    bool FileDeleteTestBlock(TID id);

//Чтение запись данных

    // Создание нового файла с данными Type==equFatTypeData
    int  FileCreate(TFile *f, TID UpLevel, u16 Attr, u32 Size,_TDateTime *Date);
    // Создание нового файла с заданным типом
    int  FileCreate(TFile *f, u8 dtype, TID UpLevel, u16 Attr, u32 Size,_TDateTime *Date);
    int  DirCreate(TFile *f, TID UpLevel, u16 Attr, u32 Size, _TDateTime *aDate);
    s32  FileClose(TFile *f);

    int  FileOpen(TFile *f,TID id, unsigned int Mode);
    long FileRead(TFile *f, u8 *buf, u32 offset,u32 count);
    
    s32 f_write_page_ecc(TFile *f, u32 page, u8 *buf);
    long FileWrite(TFile *f, u8 *buf, u32 offset,u32 count);
  
    bool f_delete_file_tfile_test_block_ecc(TFile *f);

    u32  FileAttr(TID id);

    // Возвращает сколько байт файл занимает во FLASH
    // Реальный размер файла узнать нельзя
    s32  FileSize(TFile *f);

//Утилиты
    bool  FlashRebildFreeBlock(void);
    s32   f_rebild_block_ecc(s32 *buf);

    bool  CreateList(u32 *buf,_TDateTime *date, u32 *count,u8 direction);
    void  SortList(u32 *buf,_TDateTime *date,u32 count,u8 direction);

    s32   TestFlashMiddleLevel(void);

    
    bool f_get_index(TID index, TIndexFat *info);
    
    
#pragma pack()

#endif

