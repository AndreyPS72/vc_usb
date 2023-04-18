#ifndef __link_h
#define __link_h

#include "protocol.h"
#include "DateTime.h"
#include "SetupData.h"


#pragma pack(1)


//команды
#define cmdTestPribor    1
        //тест прибора
        // param1    - не используется
        // param2    - не используется
        // param1dop - не используется
        // param2dop - не используется
#define cmdReadData      2
        //считать данные с прибора
        // param1    -   тип
        // param2    -   ID low16
        // param1dop -   ID high16 (0x00 или 0xFF - не используется, то есть =0)
        // param2dop -   0 - инфо по блокам,1.. - номер блока
#define cmdWriteData     3
#define cmdReadFlash     4
        //считать сектор FAT
        // param1    -   не используется
        // param2    -   ID
        // param1dop -   не используется
        // param2dop -   0 - инфо по блокам,1.. - номер блока
#define cmdWriteFlash    5
#define cmdReadEEPROM    6
        //
#define cmdWriteEEPROM   7
        //загрузить Eeprom в прибор
        // param1    -   не используется
        // param2    -   не используется
        // param1dop -   0 - грузить блок, 1 - записать в блок
        // param2dop -   0 - инфо по блокам,1.. - номер блока
#define cmdReadFrame     8
#define cmdReadListZamer 9
        // получить список замеров
        // param1    - не используется
        // param2    - не используется
        // param1dop - не используется
        // param2dop - 0 число замеров, 1..-номер замера по порядку от 1 до числа замеров

#define cmdReadRoute     10
#define cmdWriteRoute    11
        // загрузить маршрут
        // param1    - 0 - инфо, 1 - дата
        // param2    - 0 - маршрут,1..-номер точки маршрута
        // param1dop - 0 - грузить блок, 1 - записать в блок
        // param2dop - 1

#define cmdClearData     12
        //очистить данные
        // param1    - CountSector; //общее число секторов flash
        // param2    - Numer;       //номер прибора
        // param1dop - ByteSector;  //размер сектора flash
        // param2dop - 0

#define cmdClearID       13
        //очистить ID
        // param1    - ID low16
        // param2    - 0
        // param1dop - ID high16 (0x00 или 0xFF - не используется, то есть =0)
        // param2dop - 0

#define cmdOverload      14
        //перегрузить контроллер
        // param1    -
        // param2    -
        // param1dop -
        // param2dop -

#define cmdReadListType  15
        // получить список замеров определенного типа
        // param1    - тип замера
        // param2    - не используется
        // param1dop - не используется
        // param2dop - 0 число замеров, 1..-номер замера по порядку от 1 до числа замеров

#define cmdWriteDSPProgram 16
        // загрузить программу DSP
        // param1    -
        // param1dop -
        // param2    - размер
        // param2dop -

#define cmdWriteImageFile   17
        //загрузить файл картинок
        // param1    -
        // param1dop -
        // param2    - размер
        // param2dop -

#define cmdReadRMS          18
        //считать структуру RMS
        // param1    - порядковый номер
        // param1dop - не используется
        // param2    - не используется
        // param2dop - не используется

#define cmdGetPicture  19

#define cmdReadCurrentMeasurement 20
        // считать текущий замер с прибора
        // param1    - Прибор: prVV2 = 220
        // param2    - Канал: chHigh, chEnv
        // param1dop - Тип: ztWaveform, ztSpectrum, ztEnvelope, ztEnvSpectrum
        // param2dop - Ед.изм.: eiAcceleration, eiVelocity, eiDisplacement

// Считать экран прибора
#define cmdReadScreen 21

// Послать клавишу в прибор
#define cmdPutKey 22



// идентификаторы приборов
#define prDiana         10
#define prDianaRev1     11
#define prKorsar        20
#define prNikta         30
#define prR2000         40
#define prTestSK        50
#define prVik3          60
#define prVik3Rev1      61
#define prDiana8        70
#define prDiana2M       80
#define prR400          90
#define prKorsarROS     100
#define prAR200         160
#define prAR700Rev2     111
#define prDianaS        120
#define prGanimed       130
#define prGanimed3      131
#define prAMTest2       140
#define prCLTester      150
#define prAR200         160
#define prAR100         170
#define prBalansSK      180
#define prUltratest     190
#define prViana1        200
#define prDPK           210
#define prVV2           220
#define prViana2        230
#define prViana4        240




//формат сигнатуры
typedef __packed struct {char sign[3];} TSign;
const size_t szTSign = sizeof(TSign);
static_assert(szTSign == 3, "");


//формат команды
typedef __packed struct stCommand {
  TSign Sign;
  u8   Command;    // 1 байт
  u16  Param1;
  u16  Param1dop;
  u16  Param2;     // 2 байта
  u16  Param2dop;  // 2 байта
  TCRC CRC;        // 2 байта
}TCommand;
const size_t szTCommand = sizeof(TCommand);
static_assert(szTCommand == 14, "");


//описание структуры информации о приборе
typedef __packed struct stInfoPribor {
  TSign Sign;       //сигнатура
  u32 Pribor;      //тип прибора
  u32 Numer;       //номер прибора
  u32 Version;     //версия програмного обеспечения прибора
  u32 Protokol;    //версия протокола обмена
  u32 Flash;       //размер flash
  u32 EEPROM;      //размер EEPROM
  u32 CountClaster;//число данных секторов fat
  u16  ByteClaster; //размер сектора fat
  u16  HideClaster; //число скрытых секторов fat
  u16  FreeClaster; //число свободных кластеров FAT
  u16  AllClaster;  //всего секторов fat
  char Data[9];
  TCRC CRC;
  char Align64[14]; // Добивка до 64 байт для совместимости с USB 1.1 и USB 2.0
}TInfoPribor;
const size_t szTInfoPribor = sizeof(TInfoPribor);
static_assert(szTInfoPribor == 64, "");

//описание структуры отсылаемого фрейма
typedef __packed struct stLinkFrame {
  TSign        Sign;
  u16          Numer;
  u8           Types;
  u16          Count;
  u16          Length;
  TCRC         CRC;
} TLinkFrame;
const size_t szTLinkFrame = sizeof(TLinkFrame);
static_assert(szTLinkFrame == 12, "");


//описание структуры принимаемого фрейма
typedef __packed struct stFrameWrite {
  TSign        Sign;
  u16          Numer;
  char         Types;
  char         Data[512];
  TCRC         CRC;
}TFrameWrite;
const size_t szTFrameWrite = sizeof(TFrameWrite);
static_assert(szTFrameWrite == 520, "");



typedef __packed struct stLinkList  //всего 64 байта
{
    u16 ID_Low;                // ссылка на данные - младшее слово, если ID>64k
    u16 Numer;                 //порядковый номер
    u16 Type;                  //Тип данных
    struct {
         char DSec,Sec,Min,Hour;
         u16 Year;
         char Month,Day;
    } DateTime;

    //s16 UpLevel;               //Ссылка на верхний уровень, если есть
    //u16 Size;
    s32 UpLevel;               //Ссылка на верхний уровень, если есть
    char Note[30];
    u16 ID_High;               // ссылка на данные - старшее слово, если ID>64k
    char reserv[14];
} TLinkList;
const size_t szTLinkList = sizeof(TLinkList);
static_assert(szTLinkList == 64, "");

//
typedef __packed struct stFrameList {
  TSign            Sign;
  u16              Numer;
  TLinkList        List;
  TCRC             CRC;
} TFrameList;
const size_t szTFrameList = sizeof(TFrameList);
static_assert(szTFrameList == 71, "");


//структура для совместимости со старыми маршрутами
typedef __packed struct stLinkHdr {
  char ID_Meas;            //Идентификатор замера
  u16  Num;                //Номер замера
  //Время и дата проведения замера
  char DSec,Sec,Min,Hour;
  u16  Year;
  char Month,Day;

  char Note[30];          //Примечание
  u16  Option;            // Для Диана-8
  TCRC CRC;
} TLinkHdr;
const size_t szTLinkHdr = sizeof(TLinkHdr);
static_assert(szTLinkHdr == 45, "");




typedef u32 (*fFirstFrame)(TCommand  *cmd, TLinkFrame *Frame);
typedef u32 (*fNextFrame)(TCommand  *cmd, u8 *buf,u32 Length);


typedef __packed struct Hdr {
  u32        ID;             //Идентификатор замера
  u32        Num;            //Номер замера
  _TDateTime DateTime;       //Время и дата проведения замера
  u32        Option;         //Флажки замера
  u32        Table;          //число таблиц данных в приборе
  u32        Next;           //смещение первой таблицы
  TCRC       CRC;            //CRC заголовка
} THdr;
const size_t szTHdr = sizeof(THdr);
static_assert(szTHdr == 26, "");





//_______________________________________________________________

// структура одной точки виброметра
typedef __packed struct stVibroOnePoint {
  float PIK[3];
  float RMS[3];
  float PtP[3];
  float EXC;
  u32   Exist;
} TVibroOnePoint;
const size_t szTVibroOnePoint = sizeof(TVibroOnePoint);
static_assert(szTVibroOnePoint == 44, "");

// структура виброметра
typedef __packed struct stVibroValue {
  TVibroOnePoint Point[42];            //точки в формате 1ВПО, 2ВПО ...
  char           PeakFactor[4];        //пик фактор
  char           Ch[4];                //номер канала данных
  char           Comment[38];
  u16            Freq;
  short          CountPoint;
  TCRC           CRC;
} TVibroValue;
const size_t szTVibroValue = sizeof(TVibroValue);
static_assert(szTVibroValue == 44*42+52, "");





void InitCommunication(void);

void SetDeviceBusy(void);
void SetDeviceNoBusy(void);


int ScanMessages(void);


#pragma pack()



// Переменные, которые выставляются в 1 при изменениях в связи файлов и маршрутов
// Их можно отслеживать в нужных местах, обновлять деревья и сбрасывать в 0 
extern u8 RefreshFileSystem;
extern u8 RefreshRouteTree;



#endif



