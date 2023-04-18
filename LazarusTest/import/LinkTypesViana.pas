unit LinkTypesViana;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses  LinkTypes
      , DBox
      , ImportAuroraDefs
	  ;




{$R-}

Type TVibChnl = longword;         // номера виброканалов, используется как индекс буфера
const
  VC_A      =0;
  VC_V      =1;
  VC_S      =2;
  VC_Mark   =3;
  VC_TST_SIN  =4;
  VC_Ref      =5;
  VC_Amount =6;     // число физических каналов вибрации
  VC_TST_Mark =7;
  VC_None   =$ffffffff;


Type TMathMethodInt = longword;                 // перечисление всех Int выполняемых математических операций над данными ADC
const
  MMI_Min           = 0;
  MMI_Max           = 1;          // ПИК
  MMI_MinToMax      = 2;          // ПИК-ПИК
  MMI_RMS           = 3;          // СКЗ
  MMI_Avrg          = 4;          // осреднение
  MMI_Amount        = 4;


Type TDF_State = byte;
const
  DF_Undefined =0; // поток не задан
  DF_Inited    =1;    // настроены параметры потока
  DF_Active    =2;    // вызывалась хотя бы 1 раз
  DF_Stoped    =3;
//  DF_Idle,
//  DF_Modif,
//  DF_Delete


Type TFlowMode = byte;
const   FM_Circle   = 0;
        FM_Linear   = 1;
        FM_Unused   = $ff;


Type T_VarType = byte;
const
  VarT_None       = $00;        // по умолчанию для платформы
  VarT_U8         = $01;
  VarT_S8         = $02;
  VarT_U16        = $03;
  VarT_S16        = $04;
  VarT_U32        = $05;
  VarT_S32        = $06;
  VarT_Float      = $07;
  VarT_U64        = $08;
  VarT_S64        = $09;
  VarT_Double     = $0A;
  VarT_LongDouble = $0B;
  VarT_UnUsed     = $ff;





Type PFlow_Buf =^TFlow_Buf;
     TFlow_Buf = record
// задаваемые пользователем параметры
  Sa           : longword;           // начальный адрес буфера приема, НЕ изменяется при работе, только задается при инициации
  Ea           : longword;           // конечный  адрес буфера приема, НЕ изменяется при работе, только задается при инициации
  SampleSize   : Byte;   // размер в байтах
  SampleStep   : Byte;   // шаг по памяти в байтах
  MaxNumPWin   : word;   // количество частей на которое пользователь разделил поток
  NumPointWin  : longword;  // суммарное количество значений
// изменяемые компонентом параметры
  NxtNumPWin   : word;   // следующее окно
  CurNumPWin   : word;   // текущее окно
  LstNumPWin   : word;   // последнее окно над которым выполняли дейстия (отрисовка например)

    FlowMode    : TFlowMode;
    VarType     : T_VarType;

//  CurPoint     : longword;     // номер принимаемой точки в данный момент
  cPointA       : longword;      // адрес принимаемой точки в данный момент
  NumPointFrm  : longword;  // количество точек в кадре
  CountReadWin : integer; // количество считанных окон
//  StopRegime   : integer;

//  pSPoint      : pWord;


    pArg: pointer;         // пользовательские аргументы
// union {    unsigned int *pData;  }User;      // место расположения указателя на данные (например, для использования с ДиПам)

  Rsv          : array [0..7-1] of Byte;

  state        : TDF_State;      // состояние потока данных

end;




// type vibro signal in system international units
Type T_VS_SI = longword;
const
  VSI_MS2    = 0;
  VSI_MS     = 1;
  VSI_MKM    = 2;









const
MaxNumChMeasuring                  = 2;                     // всего каналов выводимых одновременно
DMA_byte_count                     = 1024*8;                     // число байт при разовой передаче по DMA
defultMaxMeasLengthPoint           = 11;
defultMaxNumAmpl                   = 12;
defultMaxNumFreq                   = 15;

MeasDataSize                       = 1024*1024*8; //10//*4          // статический буфер отводимый под данные измерения

Type TChMasName = array [0..VC_Amount-1] of TVibChnl;
     TChOffset = array [0..VC_Amount-1] of longword;

Type TInputSignal = longword;
const
    Internal_DAC =0;
    ISensors     =1;
    ESensors     =2;


Type TMeasuring = longword;
const
    Circle      = 0;
    Linear      = 1;


//параметры SPI
Type PSPI_Master =^TSPI_Master;
     TSPI_Master = record
  T_Buf : TFlow_Buf;           // параметры буфера данных
  R_Buf : TFlow_Buf;           // параметры буфера данных
  PointNumber: word;           // число отсчетов принимаемых данных по PDC
//  TDF_State       state;
end;


Type PStatSigParams =^TStatSigParams;
     TStatSigParams = record
  // ---------------------          задаваемые пользователем параметры
  NumCh              : Byte;                                     // число каналов
  Channels           : TChMasName;
  DataOffsets        : array [0..VC_Amount-1] of word;      // смещение данных в измерительном канале
  Koef               : array [0..VC_Amount-1] of single;    // коэффициенты преобразования из (данные - DataOffsets)*Koef -> вибропараметр из Channels
  Mean               : longword;                                      // усреднение
  Freq_of_filter     : single;                            // частота фильтрации входного сигнала
  Frequency_by_channel : single;                      // частота измерения поканально
  NumPoint_by_channel : longword;                       // число снимаемых точек на 1 канал
  Type_of_measuring  : TMeasuring;                         // тип измерения
  InputSignal        : TInputSignal;                               // внутренний ЦАП или внешний датчики
  // ----------------------        зависимые, вычисляемые параметры
  Data_Meas_sz        : longword;                              // размер выделенного массива под измерение после необходимых проверок
  Time_discretization : single;                       // (dS)
  Freq_discretization : single;                       // (dH)
  NumPoint_of_measuring : longword;                     // число снимаемых точек суммарное
  Time_of_measuring   : single;                         // время измерения
  // дополнительные параметры
  MassVal             : single;                                      // установленная масса (при балансировочном пуске)
  MassAngle           : single;                                      // установленная масса (при балансировочном пуске)
  CircleFreq          : single;                                // частота вращения вала (Гц)
  Harm1_Ampl          : single;                                // амплитуда и фаза первой гармоники в сигнале (если замер балансировочный)
  Harm1_Phase         : single;

end;   // статичекие, постоянные переменные в течении измерения

Type PMeasSigParams =^TMeasSigParams;
     TMeasSigParams = record
  // независимые параметры
  StcPrms           : TStatSigParams;
  // зависимые параметры
  Ext_Buf_Adr       : longword;                    // адрес внешнего буфера, куда можно размещать данные
  Ext_Buf_Sz        : longword;                     // размер внешнего буфера в байтах
  Meas_Buf          : array [0..MaxNumChMeasuring-1] of TFlow_Buf;    // данные каналов
  CurCh             : Byte;                          // текущий принимаемый канал
  NumCh             : Byte;                          // всего измерительных каналов
  ID                : longword;                             // идентификатор запуска измерения (для различия разных измерений)
  Number            : longword;
  MeasType          : T_DBoxType;                       // тип измерения
  sFreq             : single;                          // начальная частота для спектра
  eFreq             : single;                          // конечная частота
  FlowMode          : TFlowMode;
  Reserv            : array [0..255-1] of Byte;
end;   // описание условий измерения

Type PSaveSig =^TSaveSig;
     TSaveSig = record
  // независимые параметры
  StcPrms       : TStatSigParams;                         // существовавшие условия при измерении
  MeasOffset    : array [0..MaxNumChMeasuring-1] of longword;  // смещение данных
  FullSize      : longword;                        // размер замера = заголовок замера + буферы данных (определяется во время преобразования)
  DataSize      : longword;                        // размер данных
  CRC           : word;
  MeasData      : array [0..(MeasDataSize div 4)-1] of word;        // данные измерения
end;                                       // описание условий измерения

Type PAmplitude_Value =^TAmplitude_Value;
     TAmplitude_Value = record
  MaxNumAmpl : SmallInt;                   // максимальное количество амплитуд
  cur_Ampl   : SmallInt;
  AmplArray  : array [0..defultMaxNumAmpl-1] of word;
end;

Type PPoint_Value =^TPoint_Value;
     TPoint_Value = record
  MaxNumPoint : SmallInt;
  cur_Point   : SmallInt;
  MeasLengthPoint : array [0..defultMaxMeasLengthPoint-1] of longword;
end;

Type PFreq_Value =^TFreq_Value;
     TFreq_Value = record       // частота прихода данных
  MaxNumFreq     : SmallInt;
  cur_Freq       : SmallInt;
  FreqArray      : array [0..defultMaxNumFreq-1] of SmallInt;
end;

Type PGraphSysContol =^TGraphSysContol;
     TGraphSysContol = record
  //TSpeedParam          SpeedProc;
  Point                  : TPoint_Value;                                                  // !!! независимый параметр, точнее зависимы от того что предыдущие программисты написали функцию BPF так, что необходимо использовать кратную степень 2 числа обрабатываемых точек
  AmplVal                : TAmplitude_Value;                                                // масштабный коэффециент, эмпирическо самодурство
  Freq_Value             : TFreq_Value;                                             // независимый параметр, причины - объективная независимость + самодурство выбора
  GraphPart              : array [0..defultMaxMeasLengthPoint-1,0..defultMaxNumFreq-1] of word;          // !!! эмпирические коэффициенты, характеризеум нагрузку проца
  TimeArray              : array [0..defultMaxMeasLengthPoint-1,0..defultMaxNumFreq-1] of Single;  // зависимый параметр, Time_Value=MeasLengthPoint/Freq_Value
end;

Type P_SingleMeasData =^T_SingleMeasData;
     T_SingleMeasData = record
  Name         : TVibChnl;                 // канал
  Size         : Byte;                 // число байт на один отсчет
  MemAdrStep   : Byte;           // разница в адресах между соседними отсчетами канала
  NumPoint_by_channel : longword;  // число снимаемых точек на 1 канал
  fType        : T_VS_SI;                 // размерность
  //unsigned int      Offset;               // смещение данных в замере относительно поля начала
end;               // одиночный канал

Type P_ConditionMeas =^T_ConditionMeas;
     T_ConditionMeas = record
  Number_of_channels   : Byte;                        // число каналов
  Name                 : TVibChnl;                                      // канал
  Mean                 : longword;                                      // усреднение
  LFreqFltr            : Single;                            // частота фильтрации входного сигнала
  HFreqFltr            : Single;
  Frequency_by_channel : Single;                      // частота измерения поканально
  //unsigned int      Data_Meas_sz;                              // размер выделенного массива под измерение после необходимых проверок
  Time_discretization  : Single;                       // (dS)
  Freq_discretization  : Single;                       // (dH)
  NumPoint_of_measuring: longword;                     // число снимаемых точек суммарное
  Time_of_measuring    : Single;                         // время измерения
  data                 : longword;
end;                              // условия в которых проводилось изерение




Type P_Time =^T_Time;
     T_Time = record
  Hour,
  Minute,
  Second,
  DSec : byte;
end;

Type P_Date =^T_Date;
     T_Date = record
  Day,
  Week,
  Month: Byte;
  Year: word;
  Rsv: array [0..2] of Byte;
end;

Type T_NewTimeData = Byte;
const
  NTD_Second  =1 SHL 0;
  NTD_Minute  =1 SHL 1;
  NTD_Hour    =1 SHL 2;
  NTD_Day     =1 SHL 3;
  NTD_Week    =1 SHL 4;
  NTD_Month   =1 SHL 5;
  NTD_Year    =1 SHL 6;


Type PSysTime =^TSysTime;
     TSysTime = record
  Data : T_Date;     // системнаяя дата
  Time : T_Time;     // системное время
  NewData : T_NewTimeData;  // обновление данных в соответствующем поле
  Intvl : longword;    // интервал, обновляется при обновлении данных (использовать как информацию об обновлении значений)
end;




// Замер СКЗ для Авроры
const
   Viana_CellMaxX       = 14;// Точек
   Viana_CellMaxY       = 3; // Направлений

Type PVibroTable =^TVibroTable;
     TVibroTable = record
  Val : array [0..Viana_CellMaxY-1,0..Viana_CellMaxX-1] of single; // Точки и напраления переставлены местами !
  VCh : TVibChnl;                      // используемый вибропараметр
  TypeMath : TMathMethodInt;                 // тип расчета для вибропараметра
end;



Type
  PSmallintArray = ^TSmallintArray;
  TSmallintArray = array[0..16383] of Smallint;





// таблица 14(x) * 3 (y) перечсчет в индексы точек : номер точки из таблицы * x + y = номер точки из Point
type  stVibroValue = record
  Point      : array[0..42-1] of TVibroOnePoint;      // точки в формате 1ВПО, 2ВПО ...
  PeakFactor  : array[0..4-1] of byte; {TMathAvrora}       // пик фактор тип расчета для AVS, пример PeakFactor[A]=Amplituda=0
  Ch         :array[0..4-1] of byte;       // номер канала АЦП данных (только для Дианы2М)
  Comment    :array[0..38-1] of AnsiChar;
  Freq : word;                 // частота регистрации прибора
  CountPoint : smallint;           // количество отсчетов регистрации
  CRC : word;
end;






implementation


end.


