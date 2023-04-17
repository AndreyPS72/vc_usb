#ifndef _zamer_h
#define _zamer_h

#include "typesdef.h"
#include "DateTime.h"
#include "drvflash.h"

// Max теоретически возможное число каналов
// 0 - отметчик
// 1..8 - каналы
#define MaxChannel 8
// С отметчиком
#define MaxChannelO (MaxChannel+1)

typedef struct Hdr {
  u32        ID;             //Идентификатор замера
  u32        Num;            //Номер замера
  _TDateTime DateTime;       //Время и дата проведения замера
  u32        Parent;         //Указатель на верхний уровень, 0 - нет верхнего уровня
  u32        Table;          //число таблиц данных в приборе
  u32        Next;           //смещение первой таблицы
  TCRC       CRC;            //CRC заголовка
}THdr;


//------------------------------------------------------------------------------
#define htDataCommon     1
#define htDataVibration  2
#define htDataVibrometer 3
#define htDataElectrical 4
#define htDataRoute      5

typedef struct HdrTable {
  u16        Type;           //тип данных
  u16        Reserv;         //не используется
  u32        Offset;         //смещение данных таблицы
  u32        Next;           //смещение следующей таблицы
  TCRC       CRC;            //CRC
}THdrTable;

//------------------------------------------------------------------------------
typedef struct TableVibration {
    u16    Tip;              // Тип замера ztXXXXX
    u16    EdIzm;            // Размерность информации eiXXXX
    u32    AllX;             // Число отсчетов
    double X0;               // Нач. значение, мс или Гц
    double dX;               // Шаг, мс или Гц
    double XN;               // Кон. значение, мс или Гц
    double SKZ;              // СКЗ
    double Freq;             // Частота первой гармоники или частота отметчика фазы
    double Phase;            // Фазовая погрешность
    double A1[5];            // Амплитуда первых 5-и гармоник или 0
    double F1[5];            // Фаза первых 5-и гармоник
    double ScaleA;           // Множитель приведения Double = Integer * Scale
    double ScaleB;           // Смещение
    u32    StampType;        // Тип записи отсчетов - пока только stLin
    u32    OffT;             // Смещение данных таблицы в файле в файле
    u32    LenT;             // Длина даных таблицы в файле - может быть равна 0
    u32    Option;           // Флажки опций замера
    u8     ch0;              // номер канала данных (исключительно для прибора)
    u8     ch1;              // не используется
    u8     ch2;              // не используется
    u8     ch3;              // не используется

    u16    Reserv[8];        // для сигнала отметчика в токовой конфигурации имеем следующие параметры
                             // 0 - INOM, номинальный ток двигателя * 10, А
                             // 1 - FreqMotor, оборотная частота двигателя * 10, об/мин
                             // 2 - FreqSeti,частота сети * 10, Гц

    TCRC   CRC;
}TTableVibration;

//данные по грузам для балансировки (максимум 8-ми плоскостная балансировка)
typedef struct BalansData {
    float Mass[8];
    float Faza[8];
}TBalansData;

typedef struct ZamerData {
    u16         TypeReg;      // Тип регистрации
    u16         EdIzm;        // основные единицы измерения (перекрывается значением из таблицы канала)
    u16         Launch;       // запуск регистрации (по отметчику, свободный, ...)
    u16         Averages;     // число усреднений
    u32         Point;        // основное число точек в замере (перекрывается значением из таблицы канала)
    float       Freq;         // Частота регистрации
    float       FHP;          // фильтр высоких частот
    float       FLP;          // фильтр низких частот
    u32         Option;       // Флажки опций замера
    TBalansData Balans;       // Для балансировки
    u8          Comment[40];  // Примечание
    u32         Reserv[10];   // не используется
    TCRC        CRC;
}TZamerData;


void SetNewTable(THdrTable *TH, u32 Type, u32 Offset, u32 Len);
s32 SaveZamerHeader(TFile *f,THdr *Hdr);
s32 SaveZamerData(TFile *f,u32 Offset, THdrTable *TH, TZamerData *ZD);
s32 SaveZamerTableVibration(TFile *f, u32 Offset, THdrTable *HT, TTableVibration *TV, void *Buf, u32 Len);



s32 LoadZamerHeader(u32 index,THdr *Hdr);
s32 LoadTable(TFile *f, u32 Offset, THdrTable *TH);
s32 LoadZamerData(TFile *f,u32 Offset, TZamerData *ZD);
s32 LoadZamerTableVibration(TFile *f, u32 Offset, TTableVibration *TV);
s32 LoadZamerTableData(TFile *f, u32 Offset, void *Buf, u32 Len);

u32 GetLastNumer(char Types);


#endif
