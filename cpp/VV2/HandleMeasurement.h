#ifndef __HandleMeasurement_h
#define __HandleMeasurement_h

#include "Measurement.h"




// Замер СКЗ для Авроры
#define CellMaxPoints       14 // Точек
#define CellMaxAxes          3 // Направлений

#define PointReadedMask     0x07 // Прочитаны ВПО


#define stateColorGreen   ColorDarkGreen
#define stateColorYellow  GetColor24to16(0xA8A800)
#define stateColorRed     ColorRed



#define FileVersionVV2_0000    0x0000
#define FileVersionVV2_0200    0x0200 // Новая версия файла
#define FileVersionVV2_Current FileVersionVV2_0200


// Резерв 512байт для Авроровской диагностики
typedef struct stRMSDiag {
  u32    Reserv[128];
} TRMSDiag;
#define szTRMSDiag sizeof(TRMSDiag) // 512 bytes


typedef struct stRMSRes {
  u16 Exist;
  u16 Version;
  _TDateTime DT;       //Время и дата проведения замера

  u32 CH;
  float Value[CellMaxPoints][CellMaxAxes][MU_VIBRO]; // Пока используется Value[0][0][]; Значения Амплитудные (Пик) !
  float Temp[CellMaxPoints][CellMaxAxes];

  u8 PointReaded[CellMaxPoints]; // Битовая маска для каждой точки, прочитан ли канал: 1 - В; 2 - П; 4 - О;
  u8 MeasNum; // Число считанных точек*направлений 0..42
  u8 Align;

  u32    Reserv[12];
  
  TRMSDiag Diag;

  TCRC empty; // Для выравнивания
  TCRC CRC;
} TRMSRes;

#define szTRMSRes sizeof(TRMSRes) // ~1264 bytes





// В старой версии 0x0000 каналы CH[] лежат по порядку chHigh или chLow, chEnv
// В новой версии 0x0200 каналы CH[] лежат на своих местах: chStamp, chHigh, chLow, chEnv

typedef struct stWaveRes {
  u16 Exist;
  u16 Version;
  _TDateTime DT;       //Время и дата проведения замера

  u32 Type;
  u32 Units;

  TTable CH[MAX_CHANNEL_COUNT];

  float RMS;
  float Temp;
  float Freq;

  u32    Reserv[15];

  TCRC DataCRC;
  TCRC CRC;
} TWaveRes;
#define szTWaveRes sizeof(TWaveRes)







#endif


