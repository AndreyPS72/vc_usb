unit LinkTypesVV2;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses  LinkTypes
      ;




{$R-}


// Тип замера
const _VV2_ztWaveform        = 0;     // Сигнал
const _VV2_ztSpectrum        = 1;     // Спектр
const _VV2_ztEnvelope        = 2;     // Огибающая
const _VV2_ztEnvSpectrum     = 3;     // Спектр огибающей
const _VV2_ztRMS             = 4;     // СКЗ

const _VV2_ztCount           = 4;     // Количество
const _VV2_ztVibro           = 4;


//--- Размерность информации
const  _VV2_eiAcceleration    = 0;   // Ускорение, м/с2
const  _VV2_eiVelocity        = 1;   // Скорость, мм/с
const  _VV2_eiDisplacement    = 2;   // Перемещение, мкм
const  _VV2_eiVolt            = 3;   // Вольты, В
const  _VV2_eiTemp            = 4;   // Температура, град C

const  _VV2_eiCount           = 5; // Количество
const  _VV2_eiVibro           = 3;


// Спектр - что показывать ?
const _VV2_svPeak             = 0;     // Пик
const _VV2_svPP               = 1;     // Пик-Пик
const _VV2_svRMS              = 2;     // СКЗ



// Состояние
const _VV2_stateNone    = 0; // Неизвестно
const _VV2_stateGreen   = 1;
const _VV2_stateYellow  = 2;
const _VV2_stateRed     = 3;
const _VV2_stateCount   = 4;







//       u32 Exist; // 0 -  нет; 1 - сигнал c железного канала; 2 - преобразованный
const _VV2_teNo       = 0;
const _VV2_teHard     = 1;
const _VV2_teSoft     = 2;

Type _T_VV2_DateTime = longword;
     _T_VV2_Time     = Longword;
     _T_VV2_Date     = Longword;

Type T_VV2_Table = record

       Exist      : longword; // 0 -  нет; 1 - сигнал c железного канала; 2 - преобразованный
       DT         : _T_VV2_DateTime;       //Время и дата проведения замера

       Tip        : longword;
       EdIzm      : longword;
       AllX       : longword;

       X0         : single;
       dX         : single;
       XN         : single;

       Ampl       : Longint;   // Максимальное значение в отсчетах
       Scale      : single;

       OffT       : longword;      // Смещение данных канала в файле или адрес в памяти
       LenT       : longword;             // Длина данных в файле или в памяти в байтах - может быть равна 0
                             // Обычно AllX*szTOnePoint

       Reserv     : array [0..3] of longword;

end;
const szT_VV2_Table = sizeof(T_VV2_Table);



(*
Для сигнала: int X[0],X[1],...,X[AllX-1]
Для комплексного спектра: int Re[0],Im[0],Re[1],Im[1],...,Re[AllX-1],Im[AllX-1]
*)










// Max теоретически возможное число каналов
// 0 - отметчик
// 1 - внутр датчик  2 - внешний датчик   3 - микрофон для огибающей
const _VV2_MaxChannelCount = 4;

// Тип датчика
const _VV2_chStamp    = 0; // Отметчик
const _VV2_chHigh     = 1; // ВЧ канал
const _VV2_chLow      = 2; // НЧ канал
const _VV2_chEnv      = 3; // UHF


const _VV2_chCurrentChannel = _VV2_chHigh; // Для работы


const _VV2_MaxSensor = 2; // Доступны два датчика

// Тип входа
const _VV2_stExternalSensor = 0;
const _VV2_stInternalSensor = 1;
const _VV2_stNoSensor = 2;
const _VV2_stTestSinus = 3;


const _VV2_MaxPoint           = (8*1024);  //максимальное число точек в данных




Type T_VV2_OnePoint = longint;
const szT_VV2_OnePoint = sizeof(T_VV2_OnePoint);

Type T_VV2_OneChannelData = array [0.._VV2_MaxPoint-1] of T_VV2_OnePoint; // Массив данных одного канала
const szT_VV2_OneChannelData = sizeof(T_VV2_OneChannelData);








// ============ Для сохранения во Flash ===================



// Заголовок замера во FLASH
Type T_VV2_Parameters = record
//Шапка

       fType       : longword;           //Тип замера
       ID          : longword;           //Идентификатор замера
       Num         : longword;           //Номер замера

       // Дата и время замера
       Day,
       Month,
       Year,  //-2000
       Hour,
       Min,
       Sec     : byte;

       Directory : byte;
       align1 : byte;

       MeasType : longword;                   // Что записано

       Value : single;                   // Значение для RMS мкВ

//Данные замера

       // Index: 0=Data, 1=Data2
       Data : array [0..3] of longword;                      // Смещение Данных в файле
       DataLen : array [0..3] of longword;                   // Длина данных
       compressed : array [0..3] of byte;              // 0 - без сжатия, 1 - ZIP;

       reserved : array [0..7] of longword;

       empty: TCRC; // Для выравнивания
       CRC: TCRC;
end;

const szT_VV2_Parameters = sizeof(T_VV2_Parameters);







Type T_VV2_WaveRes = record
  Exist      : longword; // 0 -  нет; 1 - сигнал c железного канала; 2 - преобразованный
  DT         : _T_VV2_DateTime;       //Время и дата проведения замера

  Tip        : longword;
  EdIzm      : longword;

  CH         : array [0.._VV2_MaxChannelCount-1] of T_VV2_Table ;

  RMS        : single;
  Temp       : single;

  Reserv     : array [0..15] of longword;

  DataCRC    : TCRC;
  CRC        : TCRC;
end;
const szT_VV2_WaveRes = sizeof(T_VV2_WaveRes);








// Текущий замер с прибора

const _VV2_CurrentWaveMagic = $68FC452E;

Type T_VV2_CurrentWave = record
  Magic           : longword;     // 0x68FC452E
  Device          : longword;    // prVV2          = 220
  Align           : array [0..13] of longword; // добить до 64 байт

  Wave            : T_VV2_WaveRes;
  Data            : array [0.._VV2_MaxPoint-1] of T_VV2_OnePoint;

  Reserv          : array [0..7] of longword;

  CRCAlign        : TCRC;
  CRC             : TCRC;
end;
const szT_VV2_CurrentWave = sizeof(T_VV2_CurrentWave);






//------------------------------ Маршруты VV-2 ------------------------------


//---------- Описание констант ----------
const NameRoute_V2   = 64;   //Длина имени в маршруте (В Атланте = 60)
      MaxRouteNode_V2 = 1024;
      RouteVersion_V2 = $200; // Версия маршрутов 2.00


// TRouteNode_V2.Exists
const rneFlagNone   = 0; // Не заполнено - не использовать
      rneFlagFilled = 1; // Параметры заполнены
      rneFlagReaded = 3; // rneFilled + Считан сигнал

// Флажки 0xFFFFFFFF, чтобы можно было дописывать во Flash  без стирания
const rneNone   = $FFFFFFFF; // Не заполнено - не использовать
      rneFilled = (rneNone xor rneFlagFilled); // Параметры заполнены
      rneReaded = (rneNone xor rneFlagReaded); // rneFilled + Считан сигнал



//---------- Структура Элемент ----------
Type TRouteNode_V2 = record

      Exists       : longword;    // rneXXX
      DataID       : longint;    // идентификатор замера во Flash или 0 или -1, если нет

      Name         : array [0..NameRoute_V2-1] of AnsiChar;

      Order        : longword;      //Из Атланта; для точек должно быть >0 ; для станций и прочего = 0

// Только для точек
      Tip          : longword;        //тип сигнала (сигнал/спектр)
      EdIzm        : longword;      //единицы измерения
      Channel      : longword;    //Канал 1..N; 0 - по-умолчанию
      Lines        : longint;      //число линий в спектре
      LoFreq       : longint;     //нижняя граничная частота, Гц
      HiFreq       : longint;     //верхняя граничная частота, Гц
      NAverg       : longint;     //число усреднений, только для спектра (может не использоваться прибором)
      Stamper      : longword;    // 1 - старт по отметчику (может не использоваться прибором)


      Deep         : longint;
      Parent       : longint;      // Индекс предка
      ChildCount   : longint;  // Число подэлементов
      Expanded     : longword;    // Узел дерева раскрыт (для поддержки дерева)
      Marked       : longword;      // Узел дерева отмечен (на будущее)

      //  Для поддержки передачи и разборки в Атланте
      ID           : longword;        // идентификатор точки
      Offset       : longword;        // смещение в скачанном файле
      Len          : longword;        // длина в скачанном файле

      Reserv       : array [0..3] of longword;

      Align        : TCRC;
      CRC          : TCRC;
end;



//---------- Заголовок структуры маршрута ----------
Type TRouteHdr_V2 = record

      Version      : longword;       // 0x200 для этой версии

      Name         : array [0..NameRoute_V2-1] of AnsiChar;

      Count        : longint;         // Число элементов Node

      Reserv       : array [0..15] of longword;

      Align        : TCRC;
      CRC          : TCRC;
end;


//---------- Маршрут ----------
Type TRoute_V2 = record

     Hdr       : TRouteHdr_V2;           //заголовок маршрута

     Node      : array [0..MaxRouteNode_V2-1] of TRouteNode_V2;    // элементы маршрута

end;


const szTRouteNode_V2 = sizeof(TRouteNode_V2);
      szTRouteHdr_V2  = sizeof(TRouteHdr_V2);
      szTRoute_V2     = sizeof(TRoute_V2); // ~140Кб






//------------------------------ Замер для Авроры ------------------------------


// Замер СКЗ для Авроры
const _VV2_CellMaxPoints       = 14; // Точек
const _VV2_CellMaxAxes         = 3; // Направлений


// Резерв 512байт для Авроровской диагностики
Type T_VV2_RMSDiag = record
  Reserv : array [0..128-1] of longword;
end;
const szT_VV2_RMSDiag = sizeof(T_VV2_RMSDiag); // 512 bytes



Type T_VV2_RMSRes = record
     //Exist   : longword;
     Exist   : word;
     Version : word;
     DT      : _TDateTime;       //Время и дата проведения замера

     CH      : longword;

     Value : array[0.._VV2_CellMaxPoints-1,0.._VV2_CellMaxAxes-1,0..2] of single;
     Temp  : array[0.._VV2_CellMaxPoints-1,0.._VV2_CellMaxAxes-1] of single;

     PointReaded : array [0.._VV2_CellMaxPoints-1] of byte; // Битовая маска для каждой точки, прочитан ли канал: 1 - В; 2 - П; 4 - О;
     MeasNum     : byte; // Число считанных точек*направлений 0..42; Если >1 - показываем таблицу, Если<=1 - показываем RMS
     Align       : byte;

     Reserv      : array [0..12-1] of longword;

     Diag        : T_VV2_RMSDiag;

     empty       : TCRC; // Для выравнивания
     CRC         : TCRC;
end;

const szT_VV2_RMSRes = sizeof(T_VV2_RMSRes);



implementation


end.


