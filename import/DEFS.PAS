
{------------- Общие для всех описания ----------------------------}

unit DEFS;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses IniFiles, LCLIntf, LCLType, Forms, Zamhdr;

const IniDir     = 'ini';
      BaseDir    = 'base';
      PspDir     = 'psp';

      AtlantIniName = 'main.ini';
      UserIniName = 'config.ini';
      PreobrIniName  = 'transform.ini';

      ZamerFirstSymbol   = 'm';
      RouteFirstSymbol   = 'r';

      // Для старой Delphi7 Win-версии v1..v4
      PlantDirFile_v1 = 'unit_d.inf';
      ObjectDirFile_v1  = 'unit_a.inf';
      PspExt_v1    = '.psp';
      NameExt_v1   = '.nam';
      MtdExt     = '.mtd';
      CfgExt     = '.fkf';
      RazgonVibegExt = '.vib';
      LongNotesName = 'lnotes.txt';
      SensorsIniName = 'sensors.ini';

      // Для новой Lazarus Unicode-версии v8
      PlantDirFile_v8 = 'plant.infx';
      ObjectDirFile_v8  = 'object.infx';
      PspExt_v8     = '.pspx';
      NameExt_v8    = '.namx';


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
Type TClassInfo = (
      ciEditName          , { Длина Name текущего Level }
      ciNewClassName      , { Длина Name нижнего нового Level }
      ciDelClass          ,
      ciEditDir           ,
      ciNewClassDir
      );

       { Множество операций, доступных над классом }
Type  TOperMask = (omVisible          , { Видно в дереве }
                   omNew              ,
                   omEdit             ,
                   omDelete           ,
                   omAxsView          , { Может смотреться непосредственно или его Child }
                   omAxsViewImmediatly, { Может смотреться непосредственно }
                   omReadDAC          , { Читать замер (для Конфига) }
                   omMarkable         , { Можно пометить }
                   omDiag               { Можно диагностировать }
                  );
      TOperMaskSet = set of TOperMask;

Type TViewInfoParam = (
         ipViewRMS,   // Просмотр СКЗ
         ipViewInfo   // Просмотр инфы
         );

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
        Option   : longword; { 1-синхронный сигнал}
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
Type PTechParamStrings = ^TTechParamStrings;
     TTechParamStrings = record
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

const MaxPointsWave     = 64*1024*1024;
      MaxPointsSpectrum = 64*1024*400;


// Описание агрегата

const MaxPoint  = 14;              // до 14 точек = 1..14
      MaxAxe    = 3;               // 3 оси = В-П-О = 1-2-3
      MaxOrder  = MaxPoint*MaxAxe; // Теоретически возможное число сигналов в замере для всех программ = 42
      MaxMech   = 6;               // до 6 механизмов на агрегате
      MaxTechParamPsp = 14;        // Количество строк технологических параметров в паспорте


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


Type PNameSetNode =^TNameSetNode;
     TNameSetNode = record
     FullName   : TName;
     ShortName  : TShortName;
     IsPoint    : boolean;
     Point      ,
     Napr       : integer;
end;



{----------------------------------------------------------------------}

const ProgramIniFile : TMemIniFile = nil; { Ini с настройками программы. ReadOnly }
const UserIniFile : TMemIniFile = nil; { Ini для сохранения настроек пользователя }
var ProgramSetupInfo : TProgramSetupInfo;


const MaxStantionLevels : array [0..MaxProgram] of integer =
      (plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,
       plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,plStantion,
       plStantion,plStantion,plStantion,plStantion,plStantion);

{----------------------------------------------------------------------}

// Формат отчёта
const rmInternal      = 0;
      rmOO            = 1;
{$IFDEF WINDOWS}
      rmWord          = 2;
{$ENDIF}
      rmError         = -1;
      rmAny           = rmInternal;

{ Что печатать }
const ppGrid      = $0001; { Сетку }
      ppPointer   = $0002; { Указатели }
      ppText      = $0004; { Подписи }
      ppSignal    = $0008; { Сам сигнал }
      ppTechParams= $0010; { TParams }
      ppLongNotes = $0020; { LongNotes }


const MetricSystem: boolean = True;

const CalibrationMode: boolean = False;

// Сортировка замеров в дереве
// False - старые замеры выше
// True - новые замеры выше
const NewMeasurementsFirst: boolean = True;



implementation


end.



