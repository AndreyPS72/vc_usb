
{------------- Общие для всех описания ----------------------------}

unit DEFS;

{$MODE DelphiUnicode}
{$CODEPAGE UTF8}
{$H+}

interface
uses IniFiles, LCLIntf, LCLType, Forms, Zamhdr;

const IniDir     = 'ini';
      BaseDir    = 'base';
      PspDir     = 'psp';

      AtlantIniName = 'main.ini';
      UserIniName = 'config.ini';
      PreobrIniName  = 'transform.ini';
      SensorsIniName = 'sensors.ini';

      CfgExt     = '.fkf';
      MtdExt     = '.mtd';
      ZamerSym   = 'm';
      RouteSym   = 'r';
      RazgonVibegExt = '.vib';
      StanDirFile = 'unit_d.inf';
      AgrDirFile  = 'unit_a.inf';
      LongNotesName = 'lnotes.txt';

var IniDirName : UnicodeString;
    BaseDirName : UnicodeString;
    PspDirName : UnicodeString;

const MaxNameLength    = 60;
      MaxShortNameLength = 6;
      MaxDirNameLength = 60;
      MaxOneDirNameLength = 12;

Type TName       = UnicodeString;
     TShortName  = UnicodeString;
     TDirName    = UnicodeString;
     TOneDirName = UnicodeString;


{ Поддержка разных языков }
var   DateFormat : UnicodeString;
      TimeFormat : UnicodeString;
      ZeroDate   : UnicodeString;
      ZeroTime   : UnicodeString;


{--------------------- Описание доступа к БД --------------------------}

const MaxClassLevel    = 12;{ Max число уровней - с запасом }
      MaxClasesOnLevel = 9; { Max число разнородных классов на уровне - с запасом }

       { Уровень 1 - программа }
Type TClassLevel    = 1..MaxClassLevel;
     TClasesOnLevel = (LevelClass1,LevelClass2,LevelClass3,LevelClass4,LevelClass5,
                       LevelClass6,LevelClass7,LevelClass8,LevelClass9);

{ Маска для поиска по Eof, GetCurrentChild, Skip }     
Type TLevelMask = set of TClasesOnLevel;

const AllLevelMask : TLevelMask = [LevelClass1..LevelClass9];


Type TInTekData = ( { Входит ли данный узел с DBLevel в TekData }
                    tdIn,     { Да  - распахнуть узел }
                    tdNo,     { Нет }
                    tdLast);  { Последний - выбрать узел }

           { Obj1.Compare(Obj2) }
Type TCompareResult = (crLess,  { 1<2 }
                       crEqual, { 1=2 }
                       crMore); { 1>2 }

         { Значение, возвращаемое окнами }
Type TRetVal = (rvOk,rvCancel);


         { Поддержка механизма регистрации процедур }
Type TChangedInfo = { Что изменилось }
                    ({ciCreate,}
//                     ciCreateChild,        // Добавляется новый Child
                     ciDestroy,            // Удаляется объект
//                     ciDestroyChild,       // Удаляется Child: Info - Child
                     ciChangeName,         { Info - ^UnicodeString }
//                     ciChangeDir,          { Info - ^UnicodeString }
//                     ciChangePointer,
                     ciNewStamps           { Новые отсчеты - перерисовать }
                    );

{ Что делать с деревом после выполнения Click }
Type TClickedRet = (crNothing,         { Ничего }
                    crRefreshTree,     { Обновить всё дерево }
//                    crRefreshObjectsDown,  { Обновить объекты текущий и ниже }
//                    crRefreshObjectsAll,    { Обновить все объекты }
                    crRefreshCurrent   { Только текущий }
                    );

{ Тип процедуры для регистрации True - разрегистрировались }
Type TMethodForRegister = function (aChangedInfo:TChangedInfo;Info:pointer): boolean of object;



     { Описания констант для классо-зависимые функций }
Type TClassInfo = integer;
const ciEditName          = 1; { Длина Name текущего Level }
      ciNewClassName      = 2; { Длина Name нижнего нового Level }
      ciDelClass          = 3;
      ciEditDir           = 4;
      ciNewClassDir       = 5;

       { Множество операций, доступных над классом }
Type  TOperMask = (omVisible          , { Видно в дереве }
                   omNew              ,
                   omEdit             ,
                   omDelete           ,
                   omAxsView          , { Может смотреться непосредственно или
                                          его Child }
                   omAxsViewImmediatly, { Может смотреться непосредственно }
                   omReadDAC          , { Читать замер (для Конфига) }
                   omMarkable         , { Можно пометить }
                   omDiag               { Можно диагностировать }
                  );
      TOperMaskSet = set of TOperMask;

       { Тип инфы при получении имени для замеров }
Type TStrTip = (stFull          , { 60 символов }
                stShort         , {  4 символа  }
                stStantion      ,
                stCeh           ,
                stPodrazd       ,
                stUchastok      ,
                stMesto         ,
                stAgregat       ,
                stZamer         ,
                stFullPoint     , {  точка }
                stShortPoint    , {  2 символа - точка }
                stFullNapr      , {  направление }
                stShortNapr     , {  1 символ  - направление }
                stFullPointNapr , {  точка-направление }
                stShortPointNapr, {  точка-направление }
                stProg
                );

       { Для GetParent() }
const plProgram       = 1;
      plPspFile       = 2;
      plNameSet       = 2;
      plStantion      = 2;
      plCeh           = 3;
      plPodrazd       = 4;
      plUchastok      = 5;
      plMesto         = 6;
      plAgregat       = 7;
      plZamer         = 8;
      plConfig        = 8;
      plMetodik       = 8;
      plRoute         = 8;
      plRaschet       = 8;
      plProtocol      = 8;
      plRazgonVibeg   = 8;
      plVChanel       = 9;
      plPoint         = 9;
      plNapr          =10;
      plNaprPreobr    =11;

const MaxAvailStantionLevel = plMesto;


Type PBufRec =^TBufRec;
     TBufRec = record    { один блок в буфере }
        Tip      : longint;       { тип сигнала }
        EdIzm    : longint;       { единицы измерения }
        ZDate    : TDateTime; { Дата замера.}
        SKZ      : double; { СКЗ.}
        Ampl     : double; { Максимальная амплитуда сигнала.}
        Faza     : double; { Общая фаза замера }
        X0       : double; { начальное значение по Х.}
        XN       : double; { конечное значение по Х.}
        dX       : double; { шаг по X.}
        Option   : byte; { 1-синхронный сигнал}
        AllX     : longint; { Количество отсчетов }
        Power    : double;
        Obor     : double; { Оборотная частота в Гц }
        Angle    : double; { угол отметчика }
        Offset   : double;
end;

Type  TGroupInfo = class
     public
     Prefix:UnicodeString;
     Prog:Integer;
end;

const MaxTechParam = 50;
Type PTechParamRec = ^TTechParamRec;
     TTechParamRec = record
       Params: array [1..MaxTechParam] of UnicodeString;
       Notes : UnicodeString;
     end;
     PTechParamVals =^TTechParamVals;
     TTechParamVals = record
       Params: array [1..MaxTechParam] of double;
       Notes : AnsiString;
     end;

Type PTileTransfer =^TTileTransfer;
     TTileTransfer = record
       ParentHor : boolean;
       ParentKol,
       SelfKol  : integer;
end;


const KolZamerType = 10;
Type TTypeName = record
       ZamerType : longint;
       Name      : UnicodeString;
end;

const TypeNames : array [1..KolZamerType] of TTypeName =
      ((ZamerType : ztSKZ         ; Name : 'СКЗ'),
       (ZamerType : ztSignal      ; Name : 'Сигнал'),
       (ZamerType : ztSpectr      ; Name : 'Спектр БПФ'),
       (ZamerType : ztSpectrPower ; Name : 'Спектр мощности'),
       (ZamerType : ztSpectrFurie ; Name : 'Спектр по Фурье'),
       (ZamerType : ztEnvelope    ; Name : 'Огибающая'),
       (ZamerType : ztSpectrOgib  ; Name : 'Спектр огибающей'),
       (ZamerType : ztGarmon      ; Name : 'Гармоники'),
       (ZamerType : ztKepstr      ; Name : 'Кепстр'),
       (ZamerType : ztPowerBand   ; Name : 'Мощность в полосе')
       );

Type TShortTypeName = record
       ZamerType : longint;
       Name      : UnicodeString;
end;

const ShortTypeNames : array [1..KolZamerType] of TShortTypeName =
      ((ZamerType : ztSKZ         ; Name : 'СКЗ'),
       (ZamerType : ztSignal      ; Name : 'CИ'),
       (ZamerType : ztSpectr      ; Name : 'СП'),
       (ZamerType : ztSpectrPower ; Name : 'СПМ'),
       (ZamerType : ztSpectrFurie ; Name : 'СПФ'),
       (ZamerType : ztEnvelope    ; Name : 'ОГ'),
       (ZamerType : ztSpectrOgib  ; Name : 'СПО'),
       (ZamerType : ztGarmon      ; Name : 'ГАР'),
       (ZamerType : ztKepstr      ; Name : 'КЕП'),
       (ZamerType : ztPowerBand   ; Name : 'МП')
       );

Type TEdIzmName = record
       ZamerEdIzm : longint;
       Name       : UnicodeString;
end;

const KolZamerEdIzm = 9;
const EdIzmNames : array [1..KolZamerEdIzm] of TEdIzmName =
      ((ZamerEdIzm : eiAcceleration         ; Name : 'Виброускорение'),
       (ZamerEdIzm : eiVelocity             ; Name : 'Виброскорость'),
       (ZamerEdIzm : eiDisplacement         ; Name : 'Виброперемещение'),
       (ZamerEdIzm : eiVolt                 ; Name : 'Напряжение'),
       (ZamerEdIzm : eiAmper                ; Name : 'Ток'),
       (ZamerEdIzm : eiOhm                  ; Name : 'Сопротивление'),
       (ZamerEdIzm : eiVt                   ; Name : 'Мощность'),
       (ZamerEdIzm : eiTemp                 ; Name : 'Температура'),
       (ZamerEdIzm : eiForce                ; Name : 'Сила')
       );


   { Таблица преобразований по проекциям :
     Tip откуда
     EdIzm откуда
     Tip куда
     EdIzm куда
     до 4 шагов
     Число - преобразования }
const MaxPreobrStep=4;
Type PPreobrTable =^TPreobrTable;
     TPreobrTable = array [1..KolZamerType,1..KolZamerEdIzm,1..KolZamerType,1..KolZamerEdIzm,1..MaxPreobrStep] of byte;

     PCanPreobrType =^TCanPreobrType;
     TCanPreobrType = array [1..KolZamerType,1..KolZamerType] of boolean;
     PCanPreobrEdIzm =^TCanPreobrEdIzm;
     TCanPreobrEdIzm = array [1..KolZamerEdIzm,1..KolZamerEdIzm] of boolean;

var PreobrTable    : TPreobrTable;
    CanPreobrType  : TCanPreobrType;
    CanPreobrEdIzm : TCanPreobrEdIzm;

       { Проверяет - есть ли уже такой путь и наименование }
Type TUniceResult = ( urUnice,      { Уникальный }
                      urPathExist,  { Такой путь уже есть }
                      urNameExist   { Такое наименование уже есть }
                    );

{ Для паспортов }
const poNotAllowEdit   = 1; { 1 - нельзя редактировать }
      poFreeFormat     = 2; { 2 - свободный формат (можно подключать .nam) }

{--------------------- Описание настроек на программу -----------------------}


const MaxProgram = 20;
         { К какой программе привязаны замеры }
Type TProgramType = 1..MaxProgram;

Type TControlProgramSet = set of TProgramType;

       { Константы программ }
const ptNone    = 0;
      ptPallada = 1;
      ptAriadna = 2;
      ptCHIPDD  = 3;
      ptDiana   = 4;
      ptVesta   = 5;
      ptTestSK  = 6;
      ptNikta   = 7;
      ptAjax    = 8;
      ptTair    = 9;
      ptAurora  = 10;
      ptBalansSK= 11;
      ptGanimed = 12;


Type PProgramSetupInfo =^TProgramSetupInfo;
     TProgramSetupInfo = array [TProgramType] of record
       ProgramName     : TName;       { Полное имя программы }
       ProgramIni      : TDirName;    { IniFile }
       ProgramSection  : UnicodeString;  { Section in Main.Ini }
(*       ReadFunction    : integer;      { Маски - поддерживает ли
                                         чтение, балансировку, выбег, центровку. }
       ExternalProgPif ,               { Внешняя прога }
       ExternalProgParam : UnicodeString;
*)
end;

const MaxZamInt = 15000;



{-------------- Описание настроек на прибор/плату АЦП --------------}

Type TDACType = integer;

const dtE330    = 1;
      dtL1221   = 2;
      dtE330I   = 3;
      dtDAQ700  = 4;
      dtL1250   = 5;
      dtE330I16 = 6;
      dtE440    = 7;
      dtMC804   = 8;
      dtE440i32 = 9;
      dtNone    = 10;

const MaxChanel = 33; { Теоретически возможное число каналов в шелезяке 32+Отм }
      MaxPoint  = 14;
      MaxNapr   = 3;
      MaxOrder  = MaxPoint*MaxNapr; { Теоретически возможное число каналов в замере
                          для всех программ }
      MaxCikl   = 20; { Max число циклов чтения }
      MaxOrderAndCikl = MaxOrder+MaxCikl; { Max число Orders в замере =
                                            Max число каналов для чтения }

{ Число элементов массива поддерживаемых чисел отсчетов }
const NumStampCount = 16;

// Маски TDACInfo.Option
const   dioStamperAnyChannel    = 2; // dtE440i32: Отметчик можно подключать на любой канал, а не только на 33
        dioRadioSensor          = 4; // Умеет читать радиодатчики

       { Параметры из Ini }
Type TDACInfo = record
       DACType           : TDACType;
       DACVer            : integer;      { Версия :) }
       DACName           : TName;       { Полное имя АЦП }
//       DACDll            : TDirName;     { Имя Dll, управляющей АЦП }
       DACBIOS           : TDirName;     { BIOS для АЦП }
       DACIniName        : TDirName;     { IniFile }
       Address           : word;         { Адрес платы }
       IRQ	             : word;         { IRQ платы }
       Device            : integer;      { Номер устройства }
       ChanelCount       : integer;      { Число каналов }
       MinRateMem        : double; { Min мкС / на канал при чтении в память }
       MinRateDisk       : double; { Min мкС / на канал при чтении на диск }
       OneRead           : boolean; { Поддерживает ли одиночное чтение }
       Vibeg             : boolean; { Поддерживает ли длинное чтение на диск }
       Centrovka         : boolean; { Поддерживает ли центровку }
       Option            : word; { Разные флажки }
       Mirror            : boolean; { Зеркальное отображение каналов }
       RandomSelect      : boolean; { Можно ли выбирать отдельные каналы или только количество }
       KoefUsil          : integer; { Коэф усиления для LCard }

                     { Массив поддерживаемых чисел отсчетов }
       StampCount      : array [1..NumStampCount] of longint;
       FilterEnabled   : boolean;
       DACChannels     : array [1..MaxChanel] of integer;
       InputIntegr     : boolean;
       ChanelVolt      : word;
       PowerOnDelay    : longint; // Задержка на устаканивание после включения питания
       TimeDelay       : longint; // Задержка после старта в мс (используется для радиодатчиков)
end;

      { Операции на АЦП  }
Type TDACAction = (daStarted,      { Идет чтение }
                   daStoped,       { Стоит }
                   daReady         { Данные готовы }
                  );

      { Крюк при измерении/ для внешнего запуска }
Type TDACProcedure = procedure (var Action : TDACAction; Persent : double) of object;

    { Параметры, устанавливаемые пользователем }
Type TDACLoadingInfo = record

end;

Type TOrdersC = array [0..MaxOrder] of integer; { Номера каналов при чтении с платы
                                                  на каждую точку, включая отметчик=0
                                                  итератор по номерам Order }
     TOrdersP = array [1..MaxChanel] of integer; { Номера точек при чтении с платы
                                                   на каждый канал  0 - отметчик
                                                                   -1 - не используется
                                                   итератор по номерам Channel }

Type  { Интерфейсы для Dll }
     TInitDACObject = function(aIniFile:UnicodeString;aMainForm:TForm) :pointer;

const cInitDACObject   = 'InitDACObject';

const MaxPointsWave     = 64*1024*1024;
      MaxPointsSpectrum = 64*1024*400;

{----------------------------------------------------------------------}
{ Структура имен баз и замеров }


{ Наименования Level-ов с падежами и маленькой первой буквой }
{
const ulStantion = 1;
      ulCeh      = 2;
      ulPodrazd  = 3;
      ulAgregat  = 4;
Type TUpperLevel = ulStantion..ulAgregat;
}
Type TPadej = (pdImen,pdRod,pdDat,pdVin,pdTvor,pdPredl,chMnoj); // 6 падежей ед.числа + твор множ. числа
Type TFirstSymbol = (fsUpper,fsLover);

Type POneNodeObject =^TOneNodeObject;
     TOneNodeObject = packed record
     FullName   : TName;
     ShortName  : TShortName;
     IsPoint    : boolean;
     Point      ,
     Napr       : integer;
end;

Type PNamesNodeArray =^TNamesNodeArray;
     TNamesNodeArray = array [1..MaxOrder] of TOneNodeObject;


{----------------------------------------------------------------------}
{ Для конфигов }


Type TSensorType = (
      stStamper,
      stAcceleration,
      stVolt        ,
      stDisplacement,
      stDisplacementMils,
      stAmp         ,
      stRashod      ,
      stAccLowFreq  ,
      stVelocity    ,
      stRadioSensor
      );


{ Операция над каналом }
const ocNone  = 0;
      ocMulti = 1;
      ocMinus = 2;
      ocPlus  = 3;
Type TOperChanel = ocNone..ocPlus;

Type TOneOrder = record
        Used     : boolean;
        SensorId : UnicodeString;
        SensorType : TSensorType;
        SensorEdIZm : integer;
        SensorScale : double;
        OperChanel : TOperChanel;
        Cikl     : integer;
        Chanel   : integer;
        Angle    : integer;
        Comment  : UnicodeString;
        fEdIzm   : longint;
        Koef     : double;
end;

const ctReadOne = 1;
      ctBalans  = 2;
      ctVibeg   = 4;      // Циклическое чтение
      ctCentrovka = 8;
      ctRazgonVibeg = 16; // Разгон-Выбег

const tzFree      = 1; { Свободный запуск }
      tzOtmetch   = 2; { По отметчику }
      tzOwner     = 3; { Внешний, с задержкой }
      tzFront     = 4; { Внешний, по превышению уровня с канала }

      avNone      = 0; { Нет усреднения }
      avAverage   = 1; { Арифметическое }
      avAverageLast = 2; { По последним N замерам }

Type TConfigRec = record
        Name        : TDirName;
        Comment     : TName;
        ConfigTip   : integer;
        CiklCount   : integer;
        ChanelCount : integer;
        OrderCount  : integer;
        fStart      : integer;
        StartDelay  : double;
        AvgTip      : integer;
        AvgCount    : integer;
        Tip         : integer;
        EdIzm       : integer;
        DX          ,
        XN          : double;
        AllX        : longint;
        F0          ,
        FN          : double;
        AllSpectr   : longint;
        Orders      : array [0..MaxOrder] of TOneOrder;
        Protokol    : TOneDirName;
        StartChannel: integer;
        StartPorog  : integer;
        VibegPause  : TDateTime;
        RazgonVibegObor: integer;
        IsFastRazgonVibeg: boolean;
end;

{----------------------------------------------------------------------}
{ Контроль питания }
const EnablePowerMeasurement : boolean = True;
      MaxPower : double = 5.0;
      MinPower : double = 4.2;
      PowerInterval : integer = 180;
      BadPersent : integer = 20;

      EnableRead : boolean = False;

{----------------------------------------------------------------------}

const AtlantIniFile : TMemIniFile = nil; { Ini с настройками программы. ReadOnly }
const UserIniFile : TMemIniFile = nil; { Ini для сохранения настроек пользователя }
var ProgramSetupInfo : TProgramSetupInfo;

const MaxStantionLevels : array [0..MaxProgram] of integer =
      (plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,
       plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,
       plStantion,plStantion,plStantion,plStantion,plStantion);

{----------------------------------------------------------------------}
{ Параметры рабочей области экрана }
const ScreenLeft=4;
      ScreenTop=70;
      ScreenWidth:LongInt=792;
      ScreenHeight:LongInt=450;

{ Что печатать }
const ppGrid      = $0001; { Сетку }
      ppPointer   = $0002; { Указатели }
      ppText      = $0004; { Подписи }
      ppSignal    = $0008; { Сам сигнал }
      ppTechParams= $0010; { TParams }
      ppLongNotes = $0020; { LongNotes }

Const Row=2;
      Col=5;
      ElemWidth           =40;
      ElemHeight          =70;
Const StartSteelConst     =10100;
      StartCoilConst      =10200;
      StartInvertElemConst=10300;
      StartElemConst      =10000;

{----------------------------------------------------------------------}
{ Параметры просмотра спектра }
const ssSpectrSKZ=0;
      ssSpectrAmpl=1;
      ssSpectrPik2Pik=2;

      ssVelocityMmS=0;
      ssVelocityInchesS=1;

const SpectrViewMode: integer = ssSpectrAmpl;
const SpectrViewModeA: integer = ssSpectrAmpl;
const SpectrViewModeS: integer = ssSpectrAmpl;
const MetricSystem: boolean = True;
const VelocityViewMode: integer = ssVelocityMmS;


const CalibrationMode: boolean = False;

// Сортировка замеров в дереве
// False - старые замеры выше
// True - новые замеры выше
const NewMeasurementsFirst: boolean = True;



implementation


end.



