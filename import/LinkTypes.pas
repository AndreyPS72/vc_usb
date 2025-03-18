unit LinkTypes;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses StdCtrls;


Type
  TSign      = array [1..3]of AnsiChar; //сигнатура
  PArrByte   = ^TArrByte;
  TArrByte   = array [1..65000] of byte;
  TInt2      = smallint; //двухбайтный тип данных
  TWord2     = word; //двухбайтный тип данных
  PInt4      =^TInt4;
  TInt4      = integer;  //четырехбайтный тип данных
  TWord4     = LongWord;  //четырехбайтный тип данных
  PCRC       =^TCRC;     //тип данных для расчета CRC
  TCRC       = word;     //тип данных для расчета CRC
  TID        = LongWord; // ID файла во флешке



Const

  Sign: TSign        = ('V','C','#');  //сигнатура команды
  MaxNote            = 30;             //Длина примечания
  LinkNameMainModule = 'link.dll';     //имя библиотеки
  LinkNameIniFile    = 'link.ini';     //имя инишника
(*
  //номера функций в массиве функции RunLinkFlash
  prALLFunc           = 0;
  prDianaFunc         = 1;
  prR2000Func         = 2;
  prTestSKFunc        = 3;
  prVik3Func          = 4;
  prDiana8Func        = 5;
  prDiana2Rev1Func    = 6;
  prR400Func          = 7;
  prKorsarROSFunc     = 8;
  prVik3Rev1Func      = 9;
  prAR700Func         = 10;
  prDianaSFunc        = 11;
  prGanimedFunc       = 12;
  prTestSKRev2Func    = 13;
  prAMTest2Func       = 14;
  prCLTesterFunc      = 15;
  prAR200Func         = 16;
  prAR100Func         = 17;
  prDiana2Rev2Func    = 18;
  prKorsarFunc        = 19;
  prNiktaFunc         = 20;
  prAR700Rev2Func     = 21;
  prDiana8Rev1Func    = 22;
  prBalansSKFunc      = 23;
  prUltraTestFunc     = 24;
  prViana1Func        = 25;
  prViana4Func        = 26;
  prVV2Func           = 27;
  prDPKFunc           = 28;

  CountLinkPribor     = 28;             //число поддерживаемых приборов
*)

  //команды

        //тест прибора
        // param1    - не используется
        // param2    - не используется
        // param1dop - не используется
        // param2dop - не используется
  cmdTestPribor       = 1;

        // считать данные с прибора
        // param1    -   тип
        // param2    -   ID low16
        // param1dop -   ID high16 (0x00 или 0xFF - не используется, то есть =0)
        // param2dop -   0 - инфо по блокам,1.. - номер блока
  cmdReadData         = 2;

//notused  cmdWriteData        = 3; //записать блок данных
//notused  cmdReadFlash        = 4; //считать сектор flash
//notused  cmdWriteFlash       = 5; //записать сектор flash
//notused  cmdReadEEPROM       = 6; //считать EEPROM
//notused  cmdWriteEEPROM      = 7; //записать EEPROM
//notused  cmdReadFrame        = 8; // считать фрейм


        // получить список замеров
        // param1    - не используется
        // param2    - не используется
        // param1dop - не используется
        // param2dop - 0 число замеров, 1..-номер замера по порядку от 1 до числа замеров
  cmdReadListZamer    = 9;
  
  cmdReadRoute        = 10;


        // загрузить маршрут
        // param1    - 0 - инфо, 1 - дата; 2 - save
        // param2    - 0 - маршрут, 1..-номер точки маршрута
        // param1dop - 0
        // param2dop - 0
  cmdWriteRoute       = 11;

        //очистить данные
        // param1    - CountSector; //общее число секторов flash
        // param2    - Numer;       //номер прибора
        // param1dop - ByteSector;  //размер сектора flash
        // param2dop - 0
  cmdClearData        = 12; // удалить все данные из прибора

        //очистить ID
        // param1    - ID low16
        // param2    - 0
        // param1dop - ID high16 (0x00 или 0xFF - не используется, то есть =0)
        // param2dop - 0
  cmdClearID          = 13;

//notused  cmdOverload         = 14;
//notused  cmdGetPicture       = 15;

//notused  cmdReadListType     = 15; // получить список замеров определенного типа
        // param1    - тип замера
        // param2    - не используется
        // param1dop - не используется
        // param2dop - 0 число замеров, 1..-номер замера по порядку от 1 до числа замеров

//notused  cmdWriteDSPProgram  = 16; // загрузить программу DSP
        // param1    -
        // param1dop -
        // param2    - размер
        // param2dop -

//notused  cmdWriteImageFile   = 17; //загрузить файл картинок
        // param1    -
        // param1dop -
        // param2    - размер
        // param2dop -

    // param1    - номер замера 1..N
    cmdReadRMS          = 18; // загрузить замер СКЗ для ПО Аврора

//notused  cmdWriteDiagPsp     = 19; //загрузить файл паспорта
        // param1    -
        // param1dop -
        // param2    - размер
        // param2dop -


  //----------------------------------------------------------------------------
  // идентификаторы поддерживаемых приборов,
  // номера функций в массиве функции RunLinkFlash
  //----------------------------------------------------------------------------
Type TDeviceID = byte;
const
  prNone              = 0;
  prALL               = 5;
  prDiana             = 10; // *
  prDiana2Rev1        = 11;
  prDiana2Rev2        = 12;
  prKorsar            = 20;
  prNikta             = 30;
  prR2000             = 40; // *
  prTestSK            = 50; // *
  prTestSKRev2        = 51;
  prVIK3              = 60; // *
  prVIK3Rev1          = 61; // *
  prDiana8            = 70; // *
  prDiana8Rev1        = 71;
  prDiana2M           = 80; //
  prR400              = 90;
  prKorsarROS         = 100;
  prAR700             = 110;
  prAR700Rev2         = 111;
  prAR700_2           = 111;
  prDianaS            = 120;
  prGanimed           = 130;
  prGanimed3          = 131;
  prAMTest2           = 140;
  prCLTester          = 150;
  prAR200             = 160;
  prAR100             = 170;
  prBalansSK          = 180;
  prUltraTest         = 190;
  prViana1            = 200;
  prDPK               = 210;
  prVV2               = 220;
  prViana2            = 230;
  prViana4            = 240;
  prVS3D              = 243;

  equDspTypeMainProgram       = 1;
  equDspTypePrecessionProgram = 2;

  //константы для определения типа данных FAT
  equFatTypeData      = 0;
  equFatTypeConfig    = 1;
  equFatTypeStat      = 2;
  equFatTypeImpulse   = 3;
  equFatTypeAgregat   = 4;  //*
  equFatTypeRoute     = 5;
  equFatTypeBreak     = 6;  //*
  equFatTypePower     = 7;
  equFatTypeRoot      = 8;
  equFatTypeDir       = 9;
  equFatTypeObj       = 10; //*
  equFatTypeDsp       = 11;
  equFatTypeRazgon    = 12;

  equFatTypeAll       = 14; //*
  equFatTypeFilter    = 15; //*
  equFatTypePribor    = 16;
  equFatTypePrecession= 17;  //прецессия вала
  equFatTypeImage     = 18;
  equFatTypeRMS       = 19;

  equFatTypeCircled   = 20;
  equFatTypePermanent = 21;
  equFatTypeVibrometer= 22;


  equFatTypeW         = 23;
  equFatTypeI         = 24;
  equFatTypeMPT       = 25;


  equFatTypeVoltage   = 26; //напряжение
  equFatTypeCurrent   = 27; //ток

  equFatTypeAcoustic  = 28; //акустические данные



  equFatTypeNone      = $FF;


  //----- константы для определения типа сигнала (Vik3, Diana2M (revision 1))
  equTypeNone         =  0;
  equTypeSpectr       =  1;
  equTypeSignal       =  2;
  //константы для определения единиц измерения (Vik3, Diana2M (revision 1))
  equEINone                 =  0;  //не определены          (точки АЦП)
  equEIAcceleration         =  1;  //Виброускорение         (м/с2)
  equEIVelocity             =  2;  //Виброскорость          (мм/с)
  equEIDisplacement         =  3;  //Виброперемещение       (мм/с)
  equEIVolt                 =  4;  //Напряжение             (В)
  equEIAmp                  =  5;  //Ток                    (А)
  equEIRelativeDisplacement =  6;  //относитальное смещение (мкм)
  //константы для определения граничных частот (Vik3, Diana2M (revision 1))
  equLoFreq0          =  0;  //по умолчанию
  equLoFreq10         =  1;  //10 Гц
  equLoFreq5          =  2;  // 5 Гц
  equLoFreq3          =  3;  // 3 Гц
  //константы для определения граничных частот (Vik3, Diana2M (revision 1))
  equHiFreq10000      =  1;  //10000 Гц
  equHiFreq7000       =  2;  // 7000 Гц
  equHiFreq5000       =  3;  // 5000 Гц
  equHiFreq4000       =  4;  // 4000 Гц
  equHiFreq2500       =  5;  // 2500 Гц
  equHiFreq2000       =  6;  // 2000 Гц
  equHiFreq1000       =  7;  // 1000 Гц
  equHiFreq350        =  8;  //  435 Гц
  equHiFreq100        =  9;  //  100 Гц
  //константы для определения числа линий в спектре (Vik3, Diana2M (revision 1))
  equLines200         =  1;
  equLines400         =  2;
  equLines800         =  3;
  equLines1600        =  4;
  equLines3200        =  5;
(*
  //----- константы для определения типа сигнала (Diana8, Diana2M (revision 2))
  ztOther             = 0; { Прочее - непонятный тип }
  ztSKZ               = 1; { СКЗ }
  ztSignal            = 2; { Сигнал }
  ztSpectr            = 4; { Спектр }
  ztSpectrPower       = 8; { Спектр мощности }
  ztSpectrFurie       = 16; { Спектр по Фурье }
  ztSpectrOgib        = 32; { Спектр огибающей }
  ztGarmon            = 64; { Гармоники }
  ztKepstr            = 128; { Кепстр }
  ztPowerBand         = 256; { Мощность в полосе }
  ztAny               = $FFFF; { Любой }
  //константы для определения единиц измерения (Diana8, Diana2M (revision 2))
  eiDisplacement      = 1; { Перемещение, мкм }
  eiVelocity          = 2; { Скорость, мм/с}
  eiAcceleration      = 4; { Ускорение, м/с2 }
  eiVolt              = 16; { Вольты, В }
  eiAmp               = 32; { Амперы, А }
  eiOm                = 64; { Омы, Ом }
  eiNikta             = 128; { Комплексный замер для Nikt-ы }
  eiDinamo            = 256; { Динамограмма, Тонны }
  eiVT                = 512; { Ваттметрграмма, }
  eiAny               = $FFFF; { Любая }
*)
  //----------------------------------------------------------------------------
  //коды ошибок
  //----------------------------------------------------------------------------
  ErrorUnknown           =   0;

  LinkResultOk            =   1;
  ErrorClassAlreadyExist  =   2; //объект уже существует

  ErrorLoadHeaderRoute    = -40; //ошибка при загрузке заголовка маршрута
  ErrorLoadPointRoute     = -41; //ошибка при загрузке точки маршрута
  ErrorLenNameRoute       = -43; //неправильная длина имени маршрута
  ErrorInitDbfFile        = -44; //ошибка при инициализации DBF файла
  ErrorFileRoute          = -45; //ошибка при чтении файла маршрута
  ErrorRouteCRC           = -46; //ошибка CRC в заголовке маршрута
  ErrorPointCRC           = -47; //ошибка CRC в заголовке точки маршрута
  ErrorLoadPoint          = -48; //ошибка при считывании данных по точке маршрута
  ErrorTmpFileRoute       = -49; //не могу найти временный файл маршрута
  ErrorLenFreq            = -50; //неправильное кол-во граничных частот
  ErrorValueFreq          = -51; //неправильное значение граничных частот

  ErrorSearchPribor       = -60; //Прибор не найден
  ErrorInitPort           = -61; //Ошибка при инициализации порта
  ErrorDataRead           = -62; //Ошибка при чтении данных
  ErrorCreateTmpFile      = -63; //Ошибка при создании временного файла
  ErrorCRC                = -64; //Ошибка при расчете контрольной суммы
  ErrorClearData          = -65; //Ошибка при очистке памяти прибора
  ErrorPathIniFile        = -66; //Не могу найти ini-файл
  ErrorIOIniFile          = -67; //Ошибка ввода/вывода при работе с ini-файлом
  ErrorDeleteTmpFile      = -68; //Ошибка при удалении временного файла
  ErrorLinkStoping        = -69; //операция остановлена пользователем
  ErrorSearchRoute        = -70; //маршрут не найден
  ErrorDeviceNotResponded = -71; //Прибор не отвечает
  ErrorDownloadLinkList   = -72; //ошибка при считывании списока замеров
  ErrorLinkListEmpty      = -73; //список замеров пуст
  ErrorReadBreakUser      = -74; //считывание прервано пользователем
  ErrorSecondReadBreakUser= -75; //повторное считывание отменено пользователем
  ErrorCreateTempDir      = -76; //Ошибка при создании временной папки
  ErrorCreateTempFile     = -78; //Ошибка при создании временного файла
  ErrorProcessingData     = -79; //Ошибка при обработке данных
  ErrorFunctionReading    = -80; //Не определена функция для считывания данных
  ErrorDataAlreadyReading = -81; //Данные уже считаны
  ErrorInitDriverLPT      = -82; //Ошибка при инициализации драйвера LPT порта
  ErrorInitDriverUSB      = -83; //Ошибка при инициализации драйвера USB порта
  ErrorInitAddrLPT        = -84; //Не могу найти базовый адрес LTP порта

  ErrorCreateClass        = -200; //ошибка при создании объекта ImportDlg
  ErrorReadRouteFunction  = -202; //неопределена функция для считывания маршрута
  ErrorTransRouteFunction = -203; //неопределена функция для трансляции маршрута

//-----------------------------------------
// LinkPriborDiana2M
//-----------------------------------------

Type
  TDateTimeMega = packed record
     tm_dsec         ,//
     tm_sec          ,// секунды        0..59
     tm_mm           ,// минуты         0..59
     tm_hh           :byte;// часы           0..23
     tm_year         :word;// год        1900-4000
     tm_month        :byte;// месяц          1..12
     tm_day          :byte;// число          1..31
  end;
Type
_TDateTime = Longword;
_TTime = Longword;
_TDate = Longword;
Type
  PCommand =^TCommand;
  TCommand = packed record
    Sign      : TSign;
    Command   : byte;  // 1 байт
    Param1    : word;  // 2 байта
    Param1dop : word;  // 2 байта
    Param2    : word;  // 2 байта
    Param2dop : word;  // 2 байта
    CRC       : word;  // 2 байта
  end;

const
    szTCommand = SizeOf(TCommand);

Type
  //структура информации о приборе - всего 50 полезных байт
  PInfoPribor =^TInfoPribor;
  TInfoPribor = packed record
    Sign        : TSign; //сигнатура
    Pribor      : TWord4; //тип прибора
    Numer       : TWord4; //
    Version     : TWord4; //версия програмного обеспечения прибора
    Protokol    : TWord4; //версия протокола обмена
    Flash       : TWord4; //размер flash
    EEPROM      : TWord4; //размер EEPROM
    CountClaster: TWord4; //число секторов fat
    ByteClaster : TWord2;  //размер сектора fat
    HideClaster : TWord2;
    FreeClaster : TWord2;
    AllClaster  : TWord2;
    Data        : array [1..9] of byte;
    CRC         : TCRC;
//    Align64     : array[1..14]of byte; // Добивка до 64 байт, но полезного только 50 байт
  end;

const
    szTInfoPribor = 50;
    szTInfoPriborFull = SizeOf(TInfoPribor);


Type
  //нулевой фрейм
  PLinkFrame =^TLinkFrame;
  TLinkFrame = packed record
    Sign        : TSign; //сигнатура
    Numer       : word;  //номер
    Types       : byte;  //тип
    Count       : TWord2; //число фреймов
    Length      : TWord2; //длина одного фрейма
    CRC         : TCRC;  //CRC
  end;

const
	szTLinkFrame = SizeOf(TLinkFrame);


Type
  PFrameWrite =^TFrameWrite;
  TFrameWrite = packed record
    Sign  : TSign;
    Numer : word;
    Types : byte;
//    Data  : array[1..8*1024]of byte;
    Data  : array[1..512]of byte;
    CRC   : word;
  end;

const
    szTFrameWrite = SizeOf(TFrameWrite);


Type
  PLinkList = ^TLinkList;
  TLinkList = packed record
    ID_Low    : word;          // ссылка на данные - младшее слово, если ID>64k
    Numer     : word;          // порядковый номер
    Types     : word;          // Тип данных
    DateTime  : TDateTimeMega; // Дата и время

    UpLevel   : TInt4;         //Ссылка на верхний уровень, если есть; Для старого протокола (старая Диана-2М) ограничено 32к

    Note      : array[1..30] of AnsiChar;
    ID_High   : word;          // ссылка на данные - старшее слово, если ID>64k
    Reserv    : array[1..14] of byte;
  end;

  PListRecord = ^TListRecord;
  TListRecord = packed record
    Rec : PLinkList;
    Reading : boolean;
  end;


  PFrameList =^TFrameList;
  TFrameList = packed record
    Sign     : TSign;
    Numer    : word;
    List     : TLinkList;
    CRC      : word;
  end;

  // Для протокола v2.02
  PFrameList202 =^TFrameList202;
  TFrameList202 = packed record
    Sign     : TSign;
    Numer    : word;
    List     : TLinkList;
    CRC      : word;
    Reserv    : array[1..512-71] of byte; // Добивка до 512 байт
  end;

Type
//  TFirstFrame   = function(Frame:TFrame):integer;
//  TReadingFrame = procedure(var buf;Numer:integer);
//  TEndReading   = procedure;
  TFirstFrameCallback   = function (Frame:TLinkFrame): Longint; stdcall;
  TReadingFrameCallback = function (Buf: pointer; BufLen: Longword; FrameNumber: Longint): Longint; stdcall;
  TEndReadingCallback   = function (): Longint; stdcall;




PHdrZamer  =^THdrZamer;
THdrZamer  = packed record
  FatType  : byte;                 //Идентификатор замера
  Num      : word;                 //Номер замера
  DateTime : TDateTimeMega;        //Время и дата проведения замера
  Note     : array[1..30]of byte;  //Примечание
  Reserv   : word;
  CRC      : TCRC;
end;

PHdrZamerPlusSign =^THdrZamerPlusSign;
THdrZamerPlusSign = packed record
  Sign : array [1..3] of AnsiChar;
  i    : word;
  Hdr  : THdrZamer;
end;


Type
//TImportLink = function(Name:UnicodeString):integer;
TImportLink = function (FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;
(*
TRunLink    = function(AOwner: TComponent; NameIni,PathTmp:UnicodeString; func:array of TImportLink):integer;
TSetLink    = function(NameIni:UnicodeString; Pribor,Types : integer):integer;
TUploadCommand = function (Command:byte;Param1,Param2:TInt4;
                           sFirst : TFirstFrame;
                           sRead  : TReadingFrame;
                           sEnd   : TEndReading;
                           var Buf; LenBuf:integer):integer;

TUploadLinkRoute = function(X,Y           : integer;
                            Hdr           : PVik3RouteMain;
                            Point         : PVik3ArrayRoutePoint;
                            FirstFrame    : TFirstFrame;
                            ReadFrame     : TReadingFrame;
                            EndFrame      : TEndReading
                            ):integer;
*)


//тип данных для реализации отображения прогресса чтения/записи
//TImportComment     = procedure(comment:UnicodeString);
TImportComment     = function (Comment: PAnsiChar): Longint; stdcall;
//TImportProgressBar = procedure(Min,Max,Progress:integer);
TImportProgressBar = function (Min,Max,Progress: Longint): Longint; stdcall;

(*
TImportRecord = record
  ID : integer;
  Import : TImportLink;
end;
*)

Type PImportRecord =^TImportRecord;
     TImportRecord = record
  ID : Longint;
  Import : TImportLink;
end;

Type PImportRecordArray =^TImportRecordArray;
     TImportRecordArray = array [TDeviceID] of TImportRecord;

Type PTypesArray =^TTypesArray;
     TTypesArray = array [TDeviceID] of Longint;

//-----------------------------------------
// Структура данных для Дианы
//-----------------------------------------
TInfoDiana2M = packed record
  ID                     : byte;       //Идентификатор замера
  Num                    : word;       //Номер замера
  DateTime               : TDateTimeMega; //Время и дата проведения замера
  Note                   : array[1..30]of byte;           //Примечание
  Reserv                 : word;
  CRC                    : word;

  Channels               : byte;  //Байт состояния каналов замера:
  Types                  : byte;  //Тип хранимого сигнала:
  EdIzm                  : byte; //Размерность сигнала:

  LenSignal              : single;
  LenSpektr              : single;
  CountSignal            : word;
  CountSpektr            : word;

  Scale    : array [1..8] of single;
  ScaleBPF : array [1..8] of single;
  gAmpl    : array [1..8] of single; //Амплитуда первой гармоники.
  gFaza    : array [1..8] of single; //Фаза первой гармоники.
  RMS      : array [1..8] of single;
  Max      : array [1..8] of smallint;
  Min      : array [1..8] of smallint;
  PikF     : AnsiChar;
  Mass     : array [1..2] of single;
  Faza     : array [1..2] of single;
  Obor     : single;              //Оборотная частота.
  Begin_Faza : word;        //Угол установки отметчика
  Options : word;

  LoFreq   : single;  //нижняя граничная частота в спектре
  Sens     : single;  //чувствительность датчика при регистрации по маршруту
  Reserved : array[1..2]of byte;
end;



//-----------------------------------------
// Структура данных для AR700
//-----------------------------------------
TInfoAR700 = record
  ID           :byte;                   //Идентификатор замера
  Num          :word;                   //Номер замера
  DateTime     :TDateTimeMega;          //Время и дата проведения замера
  Note         :array [1..16] of byte;  //Примечание
  Option       :word;                   // Для Диана-8
  CRC          :word;

  Channel      :byte;  //какие каналы были включены
  Count        :longword;   //число точек на канал
  Count3D      :longword; //число точек 3D
  Types        :byte;     //тип хранимой информации
  Coordinate   :array[1..4,1..3] of smallint; // координаты 4 датчиков
  Size         :array[1..3] of smallint;   //размеры бака
  Speed        :single;   //скорость звука в определенной среде
  Dx           :Single;      //шаг по времени
  ScaleDat     :array [1..5] of Single;   //коэффициент по Y у 5 датчиков
  Percent      :smallint;// порог срабатывания сигнала
  Dopusk       :word;
  Shum         :array[1..4] of byte;
  ModeShum     :byte;
end;


TInfoAR700_2 = record
  ID           :longword;                   //Идентификатор замера
  Num          :longword;                   //Номер замера
  DateTime     :longword;          //Время и дата проведения замера
  CRC          :word;

  Channel      :byte;  //какие каналы были включены
  Count        :longword;   //число точек на канал
  Count3D      :longword; //число точек 3D
  Types        :byte;     //тип хранимой информации
  Coordinate   :array[1..4,1..3] of smallint; // координаты 4 датчиков
  Size         :array[1..3] of smallint;   //размеры бака
  Speed        :single;   //скорость звука в определенной среде
  Dx           :Single;      //шаг по времени
  ScaleDat     :array [1..5] of Single;   //коэффициент по Y у 5 датчиков
  Percent      :smallint;// порог срабатывания сигнала
  Dopusk       :word;
  Shum         :array[1..4] of byte;
  ModeShum     :byte;

  Sync:byte;     // была ли включена синхронизация
  Freq:single;   // частота сети (для вывода синусоиды)
  Shift:single;  // сдвиг синусоиды в секундах

  Rezerv       :array[0..54] of byte; // резерв
end;




//------------------------------------------------------------------------------
TTableAcoustic =record
    Tip:   word;              // Тип замера ztXXXXX
    EdIzm: word;            // Размерность информации eiXXXX
    AllX:  longword;             // Число отсчетов
    X0:    double;               // Нач. значение, c
    dX:    double;               // Шаг, c
    XN:    double;               // Кон. значение, с
    dY:    double;               // коэффициент пересчета по Y
    OffT:  longword;             // Смещение данных таблицы в файле в файле
    LenT:  longword;             // Длина даных таблицы в файле - может быть равна 0
    Option:longword;           // Флажки опций замера
    Reserv:array[0..49] of longword;       // не используется
    CRC:   word;
end;




Type
//-----------------------------------------
// Структура заголовка данных DSP для Дианы
//-----------------------------------------

TInfoDspDiana2M = packed record
  CountStructMemory : word;
  LenMemory         : word;
  LenData           : word;
  CRC               : word;
end;

Const
  DefaultDateTimeMega : TDateTimeMega = (
     tm_dsec  : 0;
     tm_sec   : 0;
     tm_mm    : 0;
     tm_hh    : 0;
     tm_year  : 0;
     tm_month : 0;
     tm_day   : 0;
  );

  DefaultLinkList : TLinkList = (
    ID_Low    : 0;
    Numer     : 0;
    Types     : 0;
    DateTime  : (tm_dsec  : 0;  tm_sec   : 0;  tm_mm    : 0;     tm_hh    : 0;
                 tm_year  : 0;  tm_month : 0;  tm_day   : 0;);

    UpLevel   : 0;
//    Size      : 0;
    Note      : '';
    ID_High   : 0;
    Reserv    : (0,0,0,0,0,0,0,0,0,0, 0,0,0,0);
    );



(*******************************************************************************


    Типы данных для приборов Диана-2М и Корсар 7


*******************************************************************************)

const
htDataCommon      = 1;
htDataVibration   = 2;
htDataVibrometer  = 3;
htDataElectrical  = 4;

type
PHdr =^THdr;
THdr = record
  ID  : TInt4;             //Идентификатор замера
  Num : TInt4;            //Номер замера
  DateTime : TInt4;       //Время и дата проведения замера
  Option  : TInt4;         //Флажки замера
  Table : TInt4;          //число таблиц данных в приборе
  Next : TInt4;           //смещение первой таблицы
  CRC : TCRC;            //CRC заголовка
  Align : TCRC;            //CRC заголовка
end;


THdrTable = record
  Types : TWord2;           //тип данных
  Reserv : TWord2;         //не используется
  Offset : TInt4;         //смещение данных таблицы
  Next : Tint4;           //смещение следующей таблицы
  CRC : TCRC;            //CRC
  Align : TCRC;            //CRC заголовка
end;

TTableVibration = record
    Tip : TWord2;              // Тип замера ztXXXXX
    EdIzm : TWord2;            // Размерность информации eiXXXX
    AllX : TInt4;             // Число отсчетов
    X0 : double;               // Нач. значение, мс или Гц
    dX : double;               // Шаг, мс или Гц
    XN : double;               // Кон. значение, мс или Гц
    SKZ : double;              // СКЗ
    Freq : double;             // Частота первой гармоники или частота отметчика фазы
    Phase : double;            // Фазовая погрешность
    A1 : array[1..5]of double;            // Амплитуда первых 5-и гармоник или 0
    F1 : array[1..5]of double;            // Фаза первых 5-и гармоник
    ScaleA : double;           // Множитель приведения Double = Integer * Scale
    ScaleB : double;           // Смещение
    StampType : TInt4;        // Тип записи отсчетов - пока только stLin
    OffT : TInt4;             // Смещение данных таблицы в файле в файле
    LenT : TInt4;             // Длина даных таблицы в файле - может быть равна 0
    Option : TInt4;           // Флажки опций замера
    ch0 : byte;              // номер канала данных (исключительно для прибора)
    ch1 : byte;              // не используется
    ch2 : byte;              // не используется
    ch3 : byte;              // не используется
    Reserv : array[1..4]of TInt4;        // не используется
    CRC : TCRC;
end;

//данные по грузам для балансировки (максимум 8-ми плоскостная балансировка)
TBalansData = record
    Mass : array[1..8]of single;
    Faza : array[1..8]of single;
end;

TZamerData = record
    TypeReg : TWord2;      // Тип регистрации
    EdIzm : TWord2;        // основные единицы измерения (перекрывается значением из таблицы канала)
    Launch : TWord2;       // запуск регистрации (по отметчику, свободный, ...)
    Averages : TInt2;     // число усреднений
    Point : TInt4;        // основное число точек в замере (перекрывается значением из таблицы канала)
    (*
    Freq : double;         // Частота регистрации
    FHP : double;          // фильтр высоких частот
    FLP : double;          // фильтр низких частот
    *)
    Freq : single;         // Частота регистрации
    FHP : single;          // фильтр высоких частот
    FLP : single;          // фильтр низких частот
    Option : TInt4;       // Флажки опций замера
    Balans : TBalansData;       // Для балансировки
    Comment : array[1..40]of byte;  // Примечание
    Reserv : array[1..10]of TInt4;   // не используется
    CRC : TCRC;
end;


function ImportRecord(aID : integer;aImport : TImportLink):TImportRecord;




implementation


function ImportRecord(aID : integer;aImport : TImportLink):TImportRecord;
begin
  result.ID     := aID;
  result.Import := aImport;
end;





initialization
Assert(sizeof(TSign) = 3);
Assert(sizeof(TCommand) = 14);
Assert(szTInfoPribor = 50);
//Assert(szTInfoPriborFull = 64);
Assert(sizeof(TLinkFrame) = 12);
Assert(sizeof(TFrameWrite) = 520);
Assert(sizeof(TLinkList) = 64);
Assert(sizeof(TFrameList) = 71);
Assert(sizeof(TFrameList202) = 512);
//Assert(sizeof(TLinkHdr) = 45);
Assert(sizeof(THdr) = 28);
Assert(sizeof(THdrTable) = 16);
//Assert(sizeof(TVibroOnePoint) = 44);
//Assert(sizeof(TVibroValue) = 44*42+52);

end.

