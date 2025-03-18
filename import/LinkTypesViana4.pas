unit LinkTypesViana4;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses  LinkTypes
      ,LinkUtil
      ,LCLIntf, LCLType, LMessages
      ,ImportDefs
      ,DBox
      ,LinkTypesViana
      ;




{$R-}

Type TVibChnl = byte;         // номера виброканалов, используется как индекс буфера
const
  VC_A1      =0;
  VC_A2      =1;
  VC_A3      =2;
  VC_A4      =3;
  VC_V1      =4;
  VC_V2      =5;
  VC_V3      =6;
  VC_V4      =7;
  VC_S1      =8;
  VC_S2      =9;
  VC_S3      =10;
  VC_S4      =11;
  VC_Mark   =12;
  VC_TST_SIN   =13;
//  VC_Amount =14;     // число физических каналов вибрации
  VC_None   =$ff;






Type PFlow_Buf_Viana4 =^TFlow_Buf_Viana4;
     TFlow_Buf_Viana4 = record

  Sa	: longword;                                            // начальный адрес буфера приема, НЕ изменяется при работе, только задается при инициации
  Ea	: longword;                                            // конечный  адрес буфера приема, НЕ изменяется при работе, только задается при инициации
  SampleSize	: Byte;                                    // размер в байтах
  SampleStep	: Byte;                                    // шаг по памяти в байтах
  Part_Max	: word;                                      // MaxNumPWin  ; // количество частей на которое пользователь разделил поток
  NumPointWin	: longword;                                  // суммарное количество значений

  Part_Nxt	: word;                                     // NxtNumPWin  ; // следующее окно
  Part_Cur  : word;                                   // CurNumPWin  ; // текущее окно
  Part_Lst  : word;                                   // LstNumPWin  ; // последнее окно над которым выполняли дейстия (отрисовка например)

  SelfNum	: Byte;                                      // Belov доразвитие, собственный номер в массиве потоков
  VarType	: T_VarType;                                      // Belov доразвитие, тип данных в потоке

  MathObj	: longword;                                      //unsigned int    CurPoint    ; // !!! номер принимаемой точки в данный момент
  Part_Points	: longword;                                 // NumPointFrm ; // количество точек в кадре
  CountReadWin	: Integer;                                 // количество считанных окон
  UserArg	: longword;                                      //short*     pSPoint     ;

  Rsv    	: Byte;
  DF_Type   : Byte;                                   // способ обработки данных в потоке
  FlowMode  : Byte;                                   // режим работы потока данных
  state     : Byte;                                   // состояние потока данных

end;





const
MaxNumChMeasuring_Viana4                  = 40;                     // всего каналов выводимых одновременно

Type TChMasName_Viana4 = array [0..MaxNumChMeasuring_Viana4-1] of TVibChnl;


Type PCalcMeasValue =^TCalcMeasValue;
     TCalcMeasValue = record
  PIK: single;
  RMS: single;
  PtP: single;
end;

Type PCalcMarkValue =^TCalcMarkValue;
     TCalcMarkValue = record
 VoltageMark: single;
 FreqMarker: single;
end;

Type PStatSigParams_Viana4 =^TStatSigParams_Viana4;
     TStatSigParams_Viana4 = record
// ---------------------          задаваемые пользователем параметры
  Enable_of_channels : array[0..MaxNumChMeasuring_Viana4-1] of byte;     // On каналов
  Channels : TChMasName_Viana4;                                   //наименования каналов
  DataOffsets        : array [0..MaxNumChMeasuring_Viana4-1] of word;      // смещение данных в измерительном канале
  Koef               : array [0..MaxNumChMeasuring_Viana4-1] of single;    // коэффициенты преобразования из (данные - DataOffsets)*Koef -> вибропараметр из Channels
  Freq_of_filter     : single;                            // частота фильтрации входного сигнала
  Frequency_by_channel :array [0..MaxNumChMeasuring_Viana4-1] of single;                      // частота измерения поканально
  NumPoint_by_channel : longword;                       // число снимаемых точек на 1 канал
  // ----------------------        зависимые, вычисляемые параметры
  Time_discretization : single;                       // (dS)
  Freq_discretization : single;                       // (dH)
  Reserv: array[0..200-1] of byte;
end;   // статичекие, постоянные переменные в течении измерения

Type PMeasSigParams_Viana4 =^TMeasSigParams_Viana4;
     TMeasSigParams_Viana4 = record
  // независимые параметры
  StcPrms           : TStatSigParams_Viana4;
  // зависимые параметры
  Meas_Buf          : array [0..MaxNumChMeasuring_Viana4-1] of TFlow_Buf_Viana4;    // данные каналов
  Number            : longword;
  MeasType          : T_DBoxType;                       // тип измерения
  //параметры расчетные
  CalcMeasValue     : array [0..MaxNumChMeasuring_Viana4-1] of TCalcMeasValue;   //по каналам вибрации
  CalcMarkValue     : TCalcMarkValue;                //отметчик
  Reserv : array [0..256-1] of Byte;
end;   // описание условий измерения







implementation


end.


