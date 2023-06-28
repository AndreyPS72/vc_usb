unit ImportAuroraDefs;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses LinkTypes;


type
  u32 = longword;
  u16 = word;

//--- структура одной точки виброметра
  PVibroOnePoint =^TVibroOnePoint;
  TVibroOnePoint = packed record
    PIK,
    RMS,
    PtP   : array[1..3] of single;
    EXC   : single;
    Exist : u32;
  end;

//--- структура виброметра
  PVibroValue =^TVibroValue;
  TVibroValue = packed record
    Point      : array[1..42] of TVibroOnePoint;
    PeakFactor : array[1..4] of byte; //пик фактор
    Ch         : array[1..4] of byte; //номер канала данных
    Comment    : array[1..38] of AnsiChar;
    Freq       : u16;
    CountPoint : u16;
    CRC        : TCRC;
  end;

  PKorsarFrameWrite =^TKorsarFrameWrite;
  TKorsarFrameWrite = packed record
    Sign   : TSign;
    result : byte;
    Hour, Min, Sec,
    Year, Month, Day : byte;
    Data   : TVibroValue;
    Rezerv : word;
    CRC    : TCRC;
  end;

const
  szTVibroOnePoint = sizeof(TVibroOnePoint);
  szTVibroValue = sizeof(TVibroValue);
  szTKorsarFrameWrite = sizeof(TKorsarFrameWrite);


implementation

initialization
Assert(szTVibroOnePoint = 44);
Assert(szTVibroValue = 1900);
Assert(szTKorsarFrameWrite = 1914);

end.

