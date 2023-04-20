unit LinkUtil;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses
     Classes
    ,LinkTypes
    ,Zamhdr
     ;


//расчет CRC
function CalcCRC(var Buf;Len:longint):word;
function CheckCRC(var Buf; Len : TInt2; var aCRC : TCRC): boolean;


function CreateNewDir(Dir:UnicodeString):boolean;
function NormalNameIni(NameIni:UnicodeString): UnicodeString;
procedure NormalNameIni_C(NameIni:PAnsiChar);
procedure NormalFilePath(NameIni, path: PAnsiChar);
function FileExistsPChar(const szPath: PAnsiChar): boolean;


function GetNamePribor(pribor:integer):UnicodeString;

function ErrorToStr(res:integer):UnicodeString;

// -1 - Date1<Date2
// 0 - Date1=Date2
// 1 - Date1>Date2
function DateTimeMegaCompare(Date1, Date2 :TDateTimeMega): integer;
function DateMegaToStr(Date:TDateTimeMega):UnicodeString;
function TimeMegaToStr(Date:TDateTimeMega):UnicodeString;


//перевод тип данных прибора в строку
function TypesToStr(Pribor : Tint4; Types:byte):UnicodeString;
function ArrayToStr(buf: PByte):UnicodeString;


function StrInt2(const Num:integer; Col:byte ):UnicodeString;


procedure DateTimeMulti(DT:_TDateTime; var year:word; var month:word; var day:word; var hour:word; var min:word; var sec:word);

procedure TranslateDateTime(DT: TDateTime;var Date:TZamDate;var Time:TZamTime);

procedure DelayWithSleep(MSecs: Longword);


implementation
uses SysUtils, LCLIntf, LCLType, LMessages, Forms
     , LinkLang
{$IFDEF WINDOWS}
     , Windows
{$ENDIF}
     , NEWDateTime
     , LConvEncoding
     , LazFileUtils
     ;

function CalcCRC(var Buf;Len:longint):word;
var
   i:longint;
   CRC:word;
   Dop:byte;
begin
  CRC:=$AAAA;
  for i:=1 to Len do begin
    Dop:=0;
    if (CRC and $8000)<>0 then Dop:=1;
    CRC:=((CRC and $7FFF) shl 1)+Dop;
    CRC:=CRC xor TArrByte(Buf)[i];
  end;
  Result:=CRC;
end;

function CheckCRC(var Buf; Len : TInt2; var aCRC : TCRC): boolean;
var
   CRC : TCRC;
begin
CRC:=aCRC;
aCRC:=0;
Result:= CRC=CalcCRC(Buf,Len);
aCRC:=CRC;
end;




function StrInt2(const Num:integer; Col:byte ):UnicodeString;
 Var St : UnicodeString;
     i  : integer;
 Begin
   Str(Num:Col,St);
   for i:=1 to Length(St) do if St[i]=' ' then St[i]:='0';
   StrInt2:=St;
 End;



function DateMegaToStr(Date:TDateTimeMega):UnicodeString;
begin
  result:=StrInt2(Date.tm_day,2)+'.'+
          StrInt2(Date.tm_month,2)+'.'+
          StrInt2(Date.tm_year,2);
end;

function TimeMegaToStr(Date:TDateTimeMega):UnicodeString;
begin
  result:=StrInt2(Date.tm_hh,2)+':'+
          StrInt2(Date.tm_mm,2)+':'+
          StrInt2(Date.tm_sec,2);

end;



function TypesToStr(Pribor : Tint4; Types:byte):UnicodeString;
begin
  result:='';
  if Types=equFatTypeData    then begin
                                    case Pribor of
                                       prR2000 : result:=LinkUtilSignal;
                                    else
                                                 result:=LinkUtilZamer;
                                    end;
                                  end
  else if Types=equFatTypeConfig  then begin
                                    result:=LinkUtilConfig;
                                  end
  else if Types=equFatTypeStat    then begin
                                    result:=LinkUtilStat;
                                  end
  else if Types=equFatTypeImpulse then begin
                                    result:=LinkUtilImpulse;
                                  end
  else if Types=equFatTypeObj     then begin
                                    result:=LinkUtilTrial;
                                  end
  else if Types=equFatTypePower   then begin
                                    result:=LinkUtilPower;
                                  end
  else if Types=equFatTypeRoute   then begin
                                    result:=LinkUtilRoute;
                                  end
  else if Types=equFatTypeRazgon  then begin
                                    result:=LinkUtilRazgon;
                                  end
  else if Types=equFatTypeDsp     then begin
                                    result:=LinkUtilDSP;
                                  end
  else if Types=equFatTypeImage   then begin
                                    result:=LinkUtilImage;
                                  end

  else if Types=equFatTypeRMS     then begin
                                    result:=LinkUtilZamerRMS;
                                  end
  else if Types=equFatTypeVibrometer then begin
                                    result:=LinkUtilDataVibrometer;
                                  end

    else if Types=equFatTypeW        then begin
                                    result:=LinkUtilTypeW;
                                  end
    else if Types=equFatTypeI        then begin
                                    result:=LinkUtilTypeI;
                                  end
    else if Types=equFatTypeMPT      then begin
                                    result:=LinkUtilTypeMPT;
                                  end
    else if Types=equFatTypeVoltage      then begin
                                    result:=LinkUtilVoltage;
                                  end
    else if Types=equFatTypeCurrent      then begin
                                    result:=LinkUtilCurrent;
                                  end

    else if Types=equFatTypeAcoustic   then begin
                                     result:=LinkUtilZamer;
                                  end;
end;

function ArrayToStr(buf: PByte):UnicodeString;
var
  s : AnsiString;
begin
  s:=AnsiString(PAnsiChar(buf));
  result:=Trim(CP1251ToUTF8(s));
end;


function ErrorToStr(res:integer):UnicodeString;
begin
  case res of
    ErrorUnknown            (*  0*):  result:=ErrorInternalStr;
    LinkResultOk                   :  result:=ErrorOkStr;

    ErrorLoadHeaderRoute    (*-40*):  result:=ErrorLoadHeaderRouteStr;
    ErrorLoadPointRoute     (*-41*):  result:=ErrorLoadPointRouteStr;
    ErrorLenNameRoute       (*-43*):  result:=ErrorLenNameRouteStr;
    ErrorInitDbfFile        (*-44*):  result:=ErrorInitDbfFileStr;
    ErrorFileRoute          (*-45*):  result:=ErrorFileRouteStr;
    ErrorRouteCRC           (*-46*):  result:=ErrorFileRouteStr;
    ErrorPointCRC           (*-47*):  result:=ErrorPointCRCStr;
    ErrorLoadPoint          (*-48*):  result:=ErrorLoadPointStr;
    ErrorTmpFileRoute       (*-49*):  result:=ErrorTmpFileRouteStr;
    ErrorLenFreq            (*-50*):  result:=ErrorLenFreqStr;
    ErrorValueFreq          (*-51*):  result:=ErrorValueFreqStr;

    ErrorSearchPribor       (*-60*):  result:=ErrorSearchPriborStr;
    ErrorInitPort           (*-61*):  result:=ErrorInitPortStr;
    ErrorDataRead           (*-62*):  result:=ErrorDataReadStr;
    ErrorCreateTmpFile      (*-63*):  result:=ErrorCreateTmpFileStr;
    ErrorCRC                (*-64*):  result:=ErrorCRCStr;
    ErrorClearData          (*-65*):  result:=ErrorClearDataStr;
    ErrorPathIniFile        (*-66*):  result:=ErrorPathIniFileStr;
    ErrorIOIniFile          (*-67*):  result:=ErrorIOIniFileStr;
    ErrorDeleteTmpFile      (*-68*):  result:=ErrorDeleteTmpFileStr;
    ErrorLinkStoping        (*-69*):  result:=ErrorLinkStopingStr;

    ErrorSearchRoute        (*-70*):  result:=ErrorSearchRouteStr;
    ErrorDeviceNotResponded (*-71*):  result:=ErrorDeviceNotRespondedStr;
    ErrorDownloadLinkList   (*-72*):  result:=ErrorDownloadLinkListStr;
    ErrorLinkListEmpty      (*-73*):  result:=ErrorLinkListEmptyStr;
    ErrorReadBreakUser      (*-74*):  result:=ErrorReadBreakUserStr;
    ErrorSecondReadBreakUser(*-75*):  result:=ErrorSecondReadBreakUserStr;
    ErrorCreateTempDir      (*-76*):  result:=ErrorCreateTempDirStr;
    ErrorCreateTempFile     (*-78*):  result:=ErrorCreateTempFileStr;
    ErrorProcessingData     (*-79*):  result:=ErrorProcessingDataStr;
    ErrorFunctionReading    (*-80*):  result:=ErrorFunctionReadingStr;
    ErrorDataAlreadyReading (*-81*):  result:=ErrorDataAlreadyReadingStr;
    ErrorInitDriverLPT      (*-82*):  result:=ErrorInitDriverLPTStr;
    ErrorInitDriverUSB      (*-83*):  result:=ErrorInitDriverUSBStr;
    ErrorInitAddrLPT        (*-84*):  result:=ErrorInitAddrLPTStr;

    ErrorCreateClass        (*-200*): result:=ErrorCreateClassStr;
    ErrorClassAlreadyExist  (*-201*): result:=ErrorClassAlreadyExistStr;
    ErrorReadRouteFunction  (*-202*): result:=ErrorReadRouteFunctionStr;
    ErrorTransRouteFunction (*-203*): result:=ErrorTransRouteFunctionStr;

  else                                result:=ErrorUnknownStr;
  end;
end;


function GetConstLoFreq(LoFreq:double):integer;
begin
  if LoFreq<=0.1 then result:=equLoFreq0
  else if LoFreq<=3 then result:=equLoFreq3
  else if LoFreq<=5 then result:=equLoFreq5
  else if LoFreq<=10 then result:=equLoFreq10
  else result:=equLoFreq0;
end;

function GetConstHiFreq(HiFreq:double):integer;
begin
  if HiFreq<=100 then result:=equHiFreq100
  else if HiFreq<=350 then result:=equHiFreq350
  else if HiFreq<=1000 then result:=equHiFreq1000
  else if HiFreq<=2000 then result:=equHiFreq2000
  else if HiFreq<=2500 then result:=equHiFreq2500
  else if HiFreq<=4000 then result:=equHiFreq4000
  else if HiFreq<=5000 then result:=equHiFreq5000
  else if HiFreq<=7000 then result:=equHiFreq7000
  else if HiFreq<=10000 then result:=equHiFreq10000
  else result:=equHiFreq1000;
end;

function GetConstLines(Lines:double):integer;
begin
  if Lines<=200 then result:=equLines200
  else if Lines<=400 then result:=equLines400
  else if Lines<=800 then result:=equLines800
  else if Lines<=1600 then result:=equLines1600
  else if Lines<=3200 then result:=equLines3200
  else result:=equLines400;
end;


function CreateNewDir(Dir:UnicodeString):boolean;
var
  s : UnicodeString;
  i,j : integer;
begin
  result:=DirectoryExists(Dir);
  if result then Exit;

  s:=Dir;
  i:=1;
  while true do begin
    s:=ExtractFileDir(s);
    if DirectoryExists(s) then begin
      while i<>0 do begin
        s:=Dir; for j:=1 to i-1 do s:=ExtractFileDir(s);
        result:=CreateDir(s);
        i:=i-1;
        if result=false then exit;
      end;
      exit;
    end;
    if i>=99 then begin
      Exit;
    end;
    i:=i+1;
  end;
end;



function NormalNameIni(NameIni:UnicodeString): UnicodeString;
begin
  if NameIni='' then begin
    NameIni:=IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+LinkNameIniFile;
  end;
  Result:=NameIni;
end;


procedure NormalNameIni_C(NameIni:PAnsiChar);
begin
  if StrLen(NameIni)=0 then begin
     StrPCopy(NameIni,IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+LinkNameIniFile);
  end;
end;


procedure NormalFilePath(NameIni, path: PAnsiChar);
var s:UnicodeString;
begin
s:=StrPas(NameIni);
s:=ExtractFilePath(s);
StrPCopy(path,s);
end;



function FileExistsPChar(const szPath: PAnsiChar): boolean;
begin
Result:= FileExists(AnsiString(szPath));
end;



function GetNamePribor(pribor:integer):UnicodeString;
begin
  Case pribor of
    prDiana      : result:=prDianaStr; 
    prKorsar     : result:=prKorsarStr;
    prAMTest2    : result:=prAMTest2Str;
    prNikta      : result:=prNiktaStr;
    prR2000      : result:=prR2000Str;
    prTestSK     : result:=prTestSKStr;
    prTestSKRev2 : result:=prTestSKRev2Str;
    prVik3       : result:=prVik3Str;
    prVik3Rev1   : result:=prVik3Rev1Str;
    prDiana8     : result:=prDiana8Str;
    prDiana2Rev1 : result:=prDiana2Rev1Str;
    prDiana2Rev2 : result:=prDiana2Rev2Str;
    prDiana8Rev1 : result:=prDiana8Rev1Str;
    prR400       : result:=prR400Str;
    prKorsarROS  : result:=prKorsarROSStr;
    prAR700      : result:=prAR700Str;
    prAR700Rev2  : result:=prAR700Rev2Str;
    prDianaS     : result:=prDianaSStr;
    prGanimed    : result:=prGanimedStr;
    prCLTester   : result:=prCLTesterStr;
    prAR200      : result:=prAR200Str;
    prAR100      : result:=prAR100Str;
    prBalansSK   : result:=prBalansSKStr;
    prUltraTest  : result:=prUltraTestStr;
    prViana1     : result:=prViana1Str;
    prViana4     : result:=prViana4Str;
    prVS3D       : result:=prVS3DStr;
    prVV2        : result:=prVV2Str;
    prDPK        : result:=prDPKStr;
    prViana2     : result:=prViana2Str;

    else           result:=prUnknownStr;
  end;
end;





// -1 - Date1<Date2
// 0 - Date1=Date2
// 1 - Date1>Date2
function DateTimeMegaCompare(Date1, Date2 :TDateTimeMega): integer;
begin
if Date1.tm_year<Date2.tm_year then Result:=-1
else if Date1.tm_year>Date2.tm_year then Result:=1
else if Date1.tm_month<Date2.tm_month then Result:=-1
else if Date1.tm_month>Date2.tm_month then Result:=1
else if Date1.tm_day<Date2.tm_day then Result:=-1
else if Date1.tm_day>Date2.tm_day then Result:=1
else if Date1.tm_hh<Date2.tm_hh then Result:=-1
else if Date1.tm_hh>Date2.tm_hh then Result:=1
else if Date1.tm_mm<Date2.tm_mm then Result:=-1
else if Date1.tm_mm>Date2.tm_mm then Result:=1
else if Date1.tm_sec<Date2.tm_sec then Result:=-1
else if Date1.tm_sec>Date2.tm_sec then Result:=1
else if Date1.tm_dsec<Date2.tm_dsec then Result:=-1
else if Date1.tm_dsec>Date2.tm_dsec then Result:=1
else Result:=0;
end;


const
// Секунд в сутках
_TSecPerDay  = _TTime(86400);
// Days between 1/1/0001 and 01/01/2000
_TDateDelta = _TDate(730119);

MonthDays:array[0..1,0..11] of byte=
 ((31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
  (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));


procedure DivMod(Dividend:Longword; Divisor:Longword; var Result:Longword; var Remainder:Longword);
begin
Result    := Dividend div Divisor;
Remainder := Dividend mod Divisor;
end;

procedure DoUnPackDateTime(DateTime: _TDateTime ; var Date:_TDate; var Time:_TTime );
begin
DivMod(DateTime,_TSecPerDay,Date,Time);
end;

procedure DecodeTime(Time:_TTime; var Hour:word; var Min:word; var Sec:word);
var
  _hour,_min,_sec: Longword;

begin
DivMod(Time, 60, _min, _sec);
DivMod(_min, 60, _hour, _min);
Hour:=_hour;
Min:=_min;
Sec:=_sec;
end;


function IsLeapYear(Year:TInt2):boolean;
begin
result:= (((Year mod 4) = 0) and (((Year mod 100) <> 0) or ((Year mod 400) = 0)));
end;

procedure DecodeDate(Date:_TDate; var Year:word; var Month:word; var Day:word);
var
  D1,D4,D100,D400 : Longword;
  Y, M, D, I, T : Longword;
//AnsiChar *DayTable;

begin
  D1 := 365;
  D4 := D1 * 4 + 1;
  D100 := D4 * 25 - 1;
  D400 := D100 * 4 + 1;

  T := Date+_TDateDelta;

  if (T = 0) then begin
    Year := 0;
    Month := 0;
    Day := 0;
  end else begin
    dec(T);
    Y := 1;
    while (T >= D400) do
      begin
      T:= T-D400;
      Y:= Y+400;
      end;
    DivMod(T, D100, I, D);
    if (I = 4) then
      begin
      dec(I);
      D := D+D100;
      end;
    Y := Y+(I * 100);
    DivMod(D, D4, I, D);
    Y := Y+(I * 4);
    DivMod(D, D1, I, D);
    if (I = 4) then
      begin
      dec(I);
      D := D+D1;
      end;
    Y := Y+I;
    //DayTable = (AnsiChar*)&MonthDays[IsLeapYear(Y)];
    M := 1;
    while (1>0) do
      begin
      //I := DayTable[M-1];
      I := MonthDays[byte(IsLeapYear(Y))][M-1];

      if (D < I) then break;
      D:= D-I;
      inc(M);
      end;
    Year := Y;
    Month := M;
    Day := D + 1;
    end;
end;



procedure DateTimeMulti(DT:_TDateTime; var year:word; var month:word; var day:word; var hour:word; var min:word; var sec:word);
var
Date:_TDate;
Time:_TTime;
begin
DoUnPackDateTime(DT,Date,Time);
DecodeTime(Time,Hour,Min,Sec);
DecodeDate(Date,Year,Month,Day);
end;




procedure TranslateDateTime(DT: TDateTime; var Date:ZamHdr.TZamDate; var Time:ZamHdr.TZamTime);
var Year, Month, Day,m: Word;
begin
try
   SysUtils.DecodeDate(DT,Year, Month, Day);
   Date[1]:=Year;
   Date[2]:=Month;
   Date[3]:=Day;
except
   Date[1]:=1980;
   Date[2]:=1;
   Date[3]:=1;
end;
try
   SysUtils.DecodeTime(DT,Year, Month, Day,m);
   Time[1]:=Year;
   Time[2]:=Month;
   Time[3]:=Day;
except
   Time[1]:=0;
   Time[2]:=0;
   Time[3]:=0;
end;
end;






procedure DelayWithSleep(MSecs: Longword);
var
  FirstTickCount, Now: Longword;
begin

if MSecs<=1 then begin
    Application.ProcessMessages;
    Sleep(1);
    Exit;
end;

FirstTickCount := GetTickCount64() AND $FFFFFFFF;
repeat
    Application.ProcessMessages;
    { allowing access to other controls, etc. }
    Sleep(1);
    Now := GetTickCount64() AND $FFFFFFFF;
until (Now - FirstTickCount >= MSecs);

end;





end.

