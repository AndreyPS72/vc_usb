unit NEWDateTime;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses SysUtils;

type StDateTime = record
     Sec,Min,Hour:byte;
     Year:word;
     Month,Day:byte;
end;

function UnpackDateTimeToDT(DateTime:longword): System.TDateTime;


implementation


(* The MonthDays array can be used to quickly find the number of
  days in a month:  MonthDays[IsLeapYear(Y), M]      *)

// Days between 1/1/0001 and 01/01/2000
const  _TDateDelta=730119;
// Секунд в сутках
const  _TSecPerDay=24*60*60;

const MonthDays:array [0..1,0..11] of byte=
    ((31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
     (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));

//----- DivMod -----
procedure DivMod(Dividend:longword;Divisor:longword; var Result:longword; var Remainder:longword);
begin
  Result   := Dividend div Divisor;
  Remainder:= Dividend mod Divisor;
end;

//----- IsLeapYear -----
function IsLeapYear(Year:word): byte;
begin
 if ((Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0))) then
 result:=1 else result:=0;
end;

//----- IsDate -----
function IsDate(Year :word; Month:word; Day:word): byte;
begin
 if ((Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
    (Day >= 1) and (Day <= MonthDays[IsLeapYear(Year),Month-1])) then result:=1
 else result:=0;
end;         

//----- IsTime ----- 
function IsTime(Hour:word;Min:word;Sec:word): byte;
begin
  if ( (Hour<24) and (Min < 60) and (Sec < 60) ) then result:=1
   else result:=0;  
end;
//---------------------------------------------           
function EncodeDate(Year:word; Month:word; Day:word): longword;

 var
 i:longword;
 a:byte;
begin
 Result:=0; 
 a:=IsLeapYear(Year);
 if (IsDate(Year,Month,Day)=1) then
 begin
   for i:=1 to Month-1 do
       Day:=Day+MonthDays[a,i-1];
   i:=Year-1;
   Result:=i*365 + i div 4 - i div 100 + i div 400 + Day - _TDateDelta;
 end;
end;

procedure DecodeDate(Date:longword; var Year:word; var Month:word; var Day:word);
var
  D1,D4,D100,D400,Y,M,D,I,T:longword;
  a: byte;
begin
  D1:=365;
  D4:=D1*4+1;
  D100:=D4*25-1;
  D400:=D100*4+1;
  T:=Date+_TDateDelta;
  if (T=0) then
  begin
    Year:=0;
    Month:=0;
    Day:=0;
  end
  else
  begin
    T:=T-1;
    Y:=1;
    while (T >= D400) do
    begin
      T:=T-D400;
      Y:=Y+400;
    end;
    DivMod(T,D100,I,D);
    if (I=4) then
    begin
      I:=I-1;
      D:=D+D100;
    end;
    Y:=Y+(I*100);
    DivMod(D,D4,I,D);
    Y:=Y+(I*4);
    DivMod(D,D1,I,D);
    if (I=4) then
    begin
      I:=I-1;
      D:=D+D1;
    end;
    Y:=Y+I;
    a:=IsLeapYear(Y);
    M:=1;
    while (1>0) do
    begin
      I:=MonthDays[a,M-1];
      if (D<I) then break;
      D:=D-I;
      M:=M+1;
    end;
    Year:=Y;
    Month:=M;
    Day:=D+1;
  end;
end;

function EncodeTime(Hour:word; Min:word; Sec:word): longword;
begin
  result:=0;
 if (IsTime(Hour,Min,Sec)=1) then
  result:=(longword(Hour)*60*60)+(longword(Min)*60)+(longword(Sec));
end;

procedure DecodeTime(Time:longword;var Hour:word;var Min:word;var Sec:word);
var
 _hour,_min,_sec:longword;
begin
 DivMod(Time,60,_min,_sec);
 DivMod(_min,60,_hour,_min);
 Hour:=_hour;
 Min:=_min;
 Sec:=_sec;
end;


function DoPackDateTime(Date:longword;Time:longword): longword;
begin
 result:=Date*_TSecPerDay+Time;
end;

procedure DoUnPackDateTime(DateTime:longword;var Date:longword;var Time:longword);
begin
 DivMod(DateTime,_TSecPerDay,Date,Time);
end;

function UnpackDateTime(DateTime:longword): StDateTime;
var
  t:StDateTime;
  Date:longword;
  Time:longword;
  Hour,Min,Sec, Year,Month,Day:word;
begin
  DoUnPackDateTime(DateTime,Date,Time);
  DecodeTime(Time,Hour,Min,Sec);
  DecodeDate(Date,Year,Month,Day);
  t.Sec:=Sec;
  t.Min:=Min;
  t.Hour:=Hour;
  t.Year:=Year;
  t.Month:=Month;
  t.Day:=Day;
  result:=t;
end;


function UnpackDateTimeToDT(DateTime:longword): System.TDateTime;
var
  Date:longword;
  Time:longword;
  Hour,Min,Sec, Year,Month,Day:word;
begin
  DoUnPackDateTime(DateTime,Date,Time);
  DecodeTime(Time,Hour,Min,Sec);
  DecodeDate(Date,Year,Month,Day);
  Result:=SysUtils.EncodeDate(Year,Month,Day)+SysUtils.EncodeTime(Hour,Min,Sec,0);
end;


end.


