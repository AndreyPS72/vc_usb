unit ImportDefs;

{$MODE DelphiUnicode}
{$CODEPAGE UTF8}
{$H+}

interface

{$R-}

uses Zamhdr, LCLIntf, LCLType, Classes;


// Для совместимости с x64 указателями
Type  TTagTableRecord_x64 = record
        NumT     : TTagNum;
        LenT     : Tu32;
        PntrT    : Pointer;
end;
Type TLocalTagTable_x64 = array [1..LocalTagTableKol] of TTagTableRecord_x64;



Type PBufOneRec =^TBufOneRec;
     TBufOneRec = record
       Name : UnicodeString;
       Tip ,
       EdIzm ,
       Option ,
       AllX
           : integer;
       SKZ ,
       Faza ,
       Ampl ,
       X0 ,
       dX ,
       XN
           : double;

       ZDate,
       ZTime : array [0..2] of word;

       IsStamper: boolean;
       Len: integer;

       Vals: PRealArray;

       LTT_x64  : TLocalTagTable_x64; // Таблица для дополнительных данных, передаваемых с замером. Например, ФЧХ, голос.

end;


//структура отметчика
Type POtmet =^TOtmet;
     TOtmet = record

        Channel: integer; // Канал отметчика

        int_fi, // первый пик в отметчике
        int_la, // последний пик в отметчике
        int_k  // число периодов отметчика
            : integer;
        min, max: double;
        Freq, // оборот.частота, отсчетов на период
        Phase // смещение начальной фазы RealPhase=(int_fi-Phase)/Freq*360
            : double;
        FreqHz, // оборот.частота, Гц
        PhaseDegr // RealPhase=(int_fi-Phase)/Freq*360
            : double;
end;




// Массив для передачи из DLL
const MaxBufOneRec = 1024;

Type PBufOneRecArray =^TBufOneRecArray;
     TBufOneRecArray = array [0..MaxBufOneRec-1] of PBufOneRec;


procedure CreateRec(var Rec: PBufOneRec);
procedure DestroyRec(Rec: PBufOneRec);

// Резервирует память под AllX отсчетов
procedure AllocRec(Rec: PBufOneRec);
procedure FreeRec(Rec: PBufOneRec);

// Резервирует память под дополнительные данные замера
procedure AddLocalTag(Rec: PBufOneRec; aTag : TTagNum; aBuf: pointer; aLen : Longword);
function  GetLocalTag(Rec: PBufOneRec; aTag : TTagNum; var aLen : Longword): Pointer;


procedure SetDateRec(Rec: PBufOneRec; DT: TDateTime);
// <0	Rec1^.DT < Rec2^.DT
// =0	Rec1^.DT = Rec2^.DT
// >0	Rec1^.DT > Rec2^.DT
function CompareRecDates(Rec1, Rec2: PBufOneRec): integer;




implementation
uses SysUtils;

procedure CreateRec(var Rec: PBufOneRec);
begin
new(Rec);
FillChar(Rec^,SizeOf(TBufOneRec),0);
end;


procedure DestroyRec(Rec: PBufOneRec);
begin
FreeRec(Rec);
Dispose(Rec);
end;


procedure AllocRec(Rec: PBufOneRec);
begin
Rec.Len:=Rec^.AllX*sizeof(TReal64);
Rec.Vals:=GetMem(Rec.Len);
end;


procedure FreeRec(Rec: PBufOneRec);
var i: integer;
begin

try
for i:=1 to LocalTagTableKol do begin
    if (Rec^.LTT_x64[i].NumT<>0) and
       (Rec^.LTT_x64[i].PntrT<>nil) and
       (Rec^.LTT_x64[i].LenT<>0) then begin
        FreeMem(Rec^.LTT_x64[i].PntrT);
    end;
end;
except
end;
FillChar(Rec^.LTT_x64, SizeOf(TLocalTagTable_x64),0);


if (Rec^.Len>0) and (Rec^.Vals<>nil) then begin
   FreeMem(Rec^.Vals);
   Rec^.Vals:=nil;
   Rec^.Len:=0;
end;
end;



procedure AddLocalTag(Rec: PBufOneRec; aTag : TTagNum; aBuf: pointer; aLen : Longword);
var i, LT: integer;
    BufDst: pointer;
begin

LT:=0;
for i:=1 to LocalTagTableKol do begin
    if (Rec^.LTT_x64[i].NumT=0) then begin
        LT:=i;
        break;
    end;
end;
if LT=0 then
    Exit;

try
    GetMem(BufDst,aLen);
    Move(aBuf^,BufDst^,aLen);
    Rec^.LTT_x64[i].NumT:=aTag;
    Rec^.LTT_x64[i].PntrT:=BufDst;
    Rec^.LTT_x64[i].LenT:=aLen;
except
    Exit;
end;

end;



function  GetLocalTag(Rec: PBufOneRec; aTag : TTagNum; var aLen: Longword): Pointer;
var i: integer;
begin
Result:=nil;
for i:=1 to LocalTagTableKol do begin
    if (Rec^.LTT_x64[i].NumT=aTag) then begin
        Result:=Rec^.LTT_x64[i].PntrT;
        aLen:=Rec^.LTT_x64[i].LenT;
        Exit;
    end;
end;
end;


procedure SetDateRec(Rec: PBufOneRec; DT: TDateTime);
var MSec: word;
begin
DecodeDate(DT,Rec.ZDate[2],Rec.ZDate[1],Rec.ZDate[0]);
DecodeTime(DT,Rec.ZTime[0],Rec.ZTime[1],Rec.ZTime[2], MSec);
end;



// <0	Rec1^.DT < Rec2^.DT
// =0	Rec1^.DT = Rec2^.DT
// >0	Rec1^.DT > Rec2^.DT
function CompareRecDates(Rec1, Rec2: PBufOneRec): integer;
var DT1, DT2: TDateTime;
begin
if Rec1=nil then DT1:=0
    else begin
        DT1:=EncodeDate(Rec1^.ZDate[2],Rec1^.ZDate[1],Rec1^.ZDate[0]) + EncodeTime(Rec1^.ZTime[0],Rec1^.ZTime[1],Rec1^.ZTime[2], 0);
    end;
if Rec2=nil then DT2:=0
    else begin
        DT2:=EncodeDate(Rec2^.ZDate[2],Rec2^.ZDate[1],Rec2^.ZDate[0]) + EncodeTime(Rec2^.ZTime[0],Rec2^.ZTime[1],Rec2^.ZTime[2], 0);
    end;
if DT1<DT2 then Result:=-1
else if DT1>DT2 then Result:=1
else Result:=0;
end;







end.

