#ifndef _setup_h
#define _setup_h

#include "Protocol.h"

//---

#define equVersion  223   //версия программы
#define equProtocol 100   //версия протокола обмена
#define equNumer    1     //порядковый(серийный) номер прибора
#define equBuild    1     //порядковый номер сборки


//---
#define MaxChannels           (5)     //максимальное число каналов регистрации АЦП
#define MaxCalibrationChannel (9)     //максимальное число калиброванных каналов
#define MaxPoint              (4096)  //максимальное общее число точек
#define MaxChValue            (8)     //максимальное число каналов данных
#define MaxAveraging          (9)     //максимальное число усреднений

//--- типы каналов данных
#define chNone 0  //нет канала
#define chF    1  //ускорение без фильтров
#define chA    2  //ускорение
#define chV    3  //скорость
#define chS    4  //перемещение
#define chM    5  //отметчик
#define chRe   6  //действительная часть спектра
#define chIm   7  //мнимая часть спектра
#define chAv   8  //усреднение

//---названия каналов регистрации для хранения калибровочных коэффициентов
#define caA1Pik   0
#define caA1Rms   1
#define caA1PtP   2
#define caV1Pik   3
#define caV1Rms   4
#define caV1PtP   5
#define caS1Pik   6
#define caS1Rms   7
#define caS1PtP   8
#define caVolt    9

//--- флаги регистрируемых каналов
#define chNoFilter      8
#define chAcceleration  4
#define chVelocity      2
#define chDisplacement  1
#define chVolt          16

//--- распределение памяти при регистрации
#define TypeMemExcess        0 //Эксцесс
#define TypeMemVibrometer    1 //виброметр
#define TypeMemSignal        2 //сигнал
#define TypeMemSpectr        3 //спектр
#define TypeMemSpectr1000    4 //спектр до 100Гц
#define TypeMemSpectrOgib    5 //спектр огибающей
#define TypeMemBalans        6 //балансировка
#define TypeMemRazgon        7 //разгон
#define TypeMemVibeg         8 //выбег

//-- типы замера
#define      ztOther           (unsigned int)0 // Прочее - непонятный тип
#define      ztSKZ             (unsigned int)1 // СКЗ
#define      ztSignal          (unsigned int)2 // Сигнал
#define      ztSpectr          (unsigned int)4 // Спектр
#define      ztSpectrPower     (unsigned int)8 // Спектр мощности
#define      ztSpectrFurie     (unsigned int)16 // Спектр по Фурье
#define      ztSpectrOgib      (unsigned int)32 // Спектр огибающей
#define      ztGarmon          (unsigned int)64 // Гармоники
#define      ztKepstr          (unsigned int)128 // Кепстр
#define      ztPowerBand       (unsigned int)256 // Мощность в полосе
#define      ztAny             (unsigned int)(0xFFFF) // Любой

// StampType - Тип записи отсчетов
#define      stLin       0 // Линейный: для сигнала A1,A2...
                           // для спектра: A1,A2,... F1,F2...
#define      stComplex   1 // Комплексный для спектра Re1,Im1,Re2,Im2... - пока нет


//------------------------------------------------------------------------------
//--- число регистрируемых типов данных
#ifdef __version_plus
#define MaxParametersRegistration 3
#else
#define MaxParametersRegistration 5
#endif
//--- текущие параметры регистрации
#define TypeRegSignal         0
#define TypeRegSpectr         1
#define TypeRegSpectr1000     2
#define TypeRegBalans         3
#define TypeRegFreeVibrations 4
#define TypeRegRazgon         5
#define TypeRegVibeg          6
#define TypeRegSpectrOgib     7
#define TypeRegMP             8

//------------------------------------------------------------------------------
//
//  Описание структур виброметра
//
//------------------------------------------------------------------------------

#pragma pack(1)

//------------------------------------------------------------------------------
typedef struct stSens {
        float a,b;
}TSens;

//--- структура одной точки виброметра
typedef struct stVibroOnePoint {
  float PIK[3];
  float RMS[3];
  float PtP[3];
  float EXC;
  u32   Exist;
}TVibroOnePoint;

//--- структура виброметра
typedef struct stVibroValue {
  TVibroOnePoint Point[42];            //точки в формате 1ВПО, 2ВПО ...
  //TSens Sens[MaxCalibrationChannel+1]; //чувствительность для м/с2, мм/c, мкм, вольты
  char           PeakFactor[4];        //пик фактор
  char           Ch[4];                //номер канала данных
  char           Comment[38];
  u16            Freq;
  short          CountPoint;
  TCRC           CRC;
}TVibroValue;

#pragma pack()


typedef struct stVibroAverPoint {
  float PIK[MaxAveraging];
  float RMS[MaxAveraging];
  float PtP[MaxAveraging];
}TVibroAverPoint;

//------------------------------------------------------------------------------
//
//  структура параметров типа регистрации
//
//------------------------------------------------------------------------------
typedef struct stParametersRegistration {
  u16 TypeReg;    //тип регистрации
  u16 EdIzm;      //единицы измерения
  u16 Launch;     //запуск регистрации (по отметчику, свободный, ...)
  u16 FHP;        //фильтр верхних частот
  u16 FLP;        //фильтр нижних частот
  u16 StopwayBeg; //начальное значеное оборотов при разгон/выбеге
  u16 StopwayEnd; //конечное значеное оборотов приразгон/выбеге
  u16 Point;      //число точек регистрации
  u16 Aver;       //число усреднений
  u16 Band;       //номер полосы фильтра
  u16 Porog;      //порог запуска
  u16 Reserv[4];  //на будующее чтобы не портить старые данные в структуре
}TParametersRegistration;

//------------------------------------------------------------------------------
//
//  Внимание следующие структуры хранятся в памяти программ поэтому их размер
//  не может превышать константы EFC_PAGE_SIZE из файла EFC.H
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
//  структура параметров датчика
//
//------------------------------------------------------------------------------
typedef struct stSensor {
        u32    Tip;
        u32    Numer;
        float  Sens;
}TSensor;

//------------------------------------------------------------------------------
//
//структура нулевой линии канала и уровня шума
//
//------------------------------------------------------------------------------
/*
typedef struct stLine {
        float Line,Max,Min,Rms;
}TLine;
*/

//------------------------------------------------------------------------------
//
//  структура калибровочных коэффициентов
//
//------------------------------------------------------------------------------
typedef struct stCalibration {
        u16   Line;           //нулевая линия
        //float a,b,c;          //расчетные коэффициенты
        float Point[CalibrationPoint];//значение в точках
        float Ampl[CalibrationPoint];//реальное значение

}TCalibration;


//------------------------------------------------------------------------------
//
//  Структура калибровочных коэффициентов и внутренних настроек прибора
//  Параметры не доступны для настройки рядовому пользователю
//
//------------------------------------------------------------------------------
typedef struct stCalibrationSetupInfo{
        u32          Version;                         //версия программы
        u32          Protocol;                        //версия протокола обмена
        u32          Numer;                           //порядковый(серийный) номер прибора
        u32          Build;                           //порядковый номер сборки
        //TLine        Ch[MaxCalibrationChannel];       //нулевая линия
        TCalibration Coeff[MaxCalibrationChannel];    //коэффициэнты калибровки
        float        Sens;
        char         reserv[94];
        TCRC         CRC;                             //контрольная сумма
}TCalibrationSetupInfo;


//------------------------------------------------------------------------------
//
// Глобальные, редко настраиваемые параметры
//
//------------------------------------------------------------------------------
typedef struct stGlobalSetupInfo{
        u8       PowerOff;            //Power Off
        u8       LightOff;            //Light Off
        u8       PeakFactor[3];       //просмотр параметров пик/скз/рахмах
        u8       LCDShimValue;        //
        u8       SystemEdIzm;         //система измерения
        u8       ShowSens;            //вид отображения оборотной частоты 1-об/мин, 2-Гц
        TSensor  Sensor;              //параметры датчика
        float    NormExc;             //норма на эксцесс
        float    NormRMS;             //норма на скз
        char     Volume;              //громкость
        char     Window;
        u16      Freq;                //граничная частота в спектре для извратного виброметра
        char     reserv[12];
        TCRC     CRC;
}TGlobalSetupInfo;


//------------------------------------------------------------------------------
//
//
//
//------------------------------------------------------------------------------
typedef struct stSetupInfo{
        //--- виброметр
        u32 vCurrentPoint; // текущий вид виброиерта
        //--- регитсрация сигналов
        u32 TypeReg;      // тип регистрации
        TParametersRegistration Regs[MaxParametersRegistration]; // параметры регистрации
        char Reserv[40];
        TCRC CRC;
}TSetupInfo;

//------------------------------------------------------------------------------
//
//   Константы для расположение данных во фрам
//
//------------------------------------------------------------------------------
#define FramSetupInfoEnable        1

//------------------------------------------------------------------------------
//
//  Описание функций
//
//------------------------------------------------------------------------------

char  GetVibrometerMaxAveraging(void);

int   GetShowSpectrEdIzm(int EdIzm);
void  SetShowSpectrEdIzm(int EdIzm, u8 Factor);

s16  *ChAddr(char Ch);
void  SetChAddr(char Ch, s16 *Addr);
void  ClearDataArray(void);
void  RemapMemory(int Type);


s32   LoadBalansInfo(u32 count);
s32   SaveBalansInfo(u32 count);

s32   LoadSetupInfo(void);
void  SaveSetupInfo(void);

s32   LoadGlobalSetupInfo(void);
void  SaveGlobalSetupInfo(void);

s32   LoadCalibrationSetupInfo(void);
void  SaveCalibrationSetupInfo(void);

void  SetSensChannel(void);

u32   LoadSetup(void);

void GetSensChannel(u32 index, s32 point, float *a,float *b);
float CalculateChannelValue(u32 index, float aVal);


//------------------------------------------------------------------------------
//
//  Вснешние переменные
//
//------------------------------------------------------------------------------

extern s16 DataArray[5*MaxPoint];
extern TSens Sens3[MaxCalibrationChannel+1];


extern TSetupInfo SetupInfo;
extern TGlobalSetupInfo GlobalSetupInfo;
extern TCalibrationSetupInfo CalibrationSetupInfo;


#endif
