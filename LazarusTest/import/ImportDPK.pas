unit ImportDPK;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
    LCLIntf, LCLType, StdCtrls
    ;


// Для простого файла замера
function DoImportDPK(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;




implementation
uses SysUtils
     , Math
     , Defs
     , ZamHdr
     , ImportDefs
     , LinkTypes
     , LinkUtil
{$IFDEF NeedImport}
     , DefDB
{$ENDIF}
     ;








{$R-}



// Тип замера
const _DPK_RMS_DataType           = 0;
const _DPK_Signal_DataType        = 1;     // Сигнал
const _DPK_Spectr_DataType        = 2;     // Спектр
const _DPK_Exc_DataType           = 3;
const _DPK_Count_DataType         = 4;
const _DPK_Lift_DataType          = 4;


//--- Размерность информации
const  _DPK_eiAcceleration    = 0;   // Ускорение, м/с2
const  _DPK_eiVelocity        = 1;   // Скорость, мм/с
const  _DPK_eiDisplacement    = 2;   // Перемещение, мкм
const  _DPK_eiVibro           = 3;


const  _DPK_HighRange         = 0; // 10 - 1000 Hz
const  _DPK_LowRange          = 1; // 1 - 200 Hz




//Заголовок замера
Type T_DPK_Header = record
  ID           : word;
  MiddleLine   : word;
  Types        : byte;		// 0b - rms, 1b - signal, 2b - spectrum, 3b - exc
  Range        : byte;		// 0 - 10-1000Hz, 1 - 1-200Hz
  Parameter    : byte; 	    // 0 - A, 1 - V, 2 - S
  res1         : byte;
  Duration     : single;
  Coef         : single;
  AdcCount     : word;
  SpectrCount  : word;
  FreqReg      : longword;

  // Дата замера - добавлена 28.05.18
    Year          : Word;
    Month,
    Day,
    Hour,
    Minute,
    Second,
    mSecond     : byte;

  reserved     : array [0..24-1] of byte;
  CRC          : array [0.._DPK_Count_DataType-1] of word;
end;


Type T_DPK_RMS      = single;
	 T_DPK_Wave     = array [0..2048-1] of word; // Если Types = 1
     T_DPK_Spectr   = array [0..400-1] of word;  // Если Types = 2
     T_DPK_Exc      = single;


Type T_DPK_AtlantHdr = packed record
  ID           : longword;             //Идентификатор замера
  Num          : longword;            //Номер замера
  DateTime     : longword;       //Время и дата проведения замера
  Option       : longword;         //Флажки замера
  Table        : longword;          //число таблиц данных в приборе
  Next         : longword;           //смещение первой таблицы
  CRC          : TCRC;          //CRC заголовка
end;


Type T_DPK_Data = record
	Header        : T_DPK_Header;
	RMS           : T_DPK_RMS;
	AdcBuf        : T_DPK_Wave;
    SpectrAmplx10 : T_DPK_Spectr;
	Exc           : T_DPK_Exc;
end;




const szT_DPK_AtlantHdr      = sizeof(T_DPK_AtlantHdr);
const szT_DPK_Header         = sizeof(T_DPK_Header);
const szT_DPK_RMS            = sizeof(T_DPK_RMS);
const szT_DPK_Wave           = sizeof(T_DPK_Wave);
const szT_DPK_Spectrum       = sizeof(T_DPK_Spectr);
const szT_DPK_Exc            = sizeof(T_DPK_Exc);
const szT_DPK_Data           = sizeof(T_DPK_Data);





function DoImportDPKPart(f: integer; Offset, Len : longword; Name: UnicodeString; SrcList: TListBox):integer;

var Data : T_DPK_Data;
    Hdr: T_DPK_AtlantHdr;

const Str8522 ='Замер №%3.3d в %s от %s';


function GenerateName(Rec: PBufOneRec):UnicodeString;
var DT: TDateTime;
begin

{$IFDEF NeedImport}
   Result:=Format((str8522),[Hdr.Num,GetShortNameByTip(Rec.Tip),GetNameByEdIzm(Rec.EdIzm)]);
{$ELSE}
  try
     DT:=EncodeDate(Rec^.ZDate[2],Rec^.ZDate[1],Rec^.ZDate[0])+EncodeTime(Rec^.ZTime[0],Rec^.ZTime[1],Rec^.ZTime[2],0);
  except
     DT:=Now;
  end;

  Result:=Format(Str8522,[Hdr.Num,TimeToStr(DT),DateToStr(DT)]);
{$ENDIF}


end;


var
  k, count: integer;
  i, j, countNoisy : integer;

  Rec: PBufOneRec;

  tTip : integer;
  DT   : TDateTime;
  MSec : word;
  IsLift: boolean;


begin
  Result:=0;

  Rec:=nil;

  FillChar(Data,szT_DPK_Data,0);

try

  FileSeek(F,Offset,0);

  FileRead(F,Hdr,szT_DPK_AtlantHdr);

  FileRead(F,Data,szT_DPK_Data);

  tTip:=0;
  if (Data.Header.Types AND (1 shl _DPK_Signal_DataType))<>0 then begin
     tTip:=ztSignal;
     if CalcCRC(Data.AdcBuf,szT_DPK_Wave)<>Data.Header.CRC[_DPK_Signal_DataType] then
        Exit;
  end;
  if (Data.Header.Types AND (1 shl _DPK_Spectr_DataType))<>0 then begin
     tTip:=ztSpectr;
     if CalcCRC(Data.SpectrAmplx10,szT_DPK_Spectrum)<>Data.Header.CRC[_DPK_Spectr_DataType] then
        Exit;
  end;

  IsLift:=False;
  if (Data.Header.Types AND (1 shl _DPK_Lift_DataType))<>0 then begin
     tTip:=ztSignal;
     IsLift:=True;
     if CalcCRC(Data.AdcBuf,szT_DPK_Wave)<>Data.Header.CRC[_DPK_Signal_DataType] then
        Exit;
  end;



  if tTip=0 then
     Exit;

  CreateRec(Rec);
  Rec^.Tip:=tTip;

  if (Data.Header.Parameter=_DPK_eiAcceleration) then Rec^.EdIzm:=eiAcceleration
  else if (Data.Header.Parameter=_DPK_eiDisplacement) then Rec^.EdIzm:=eiDisplacement
  else Rec^.EdIzm:=eiVelocity;


  Rec^.X0:=0;

  if Rec^.Tip=ztSignal then begin
     if (IsLift) then begin
        count:=0;
        for k:=0 to Data.Header.AdcCount-1 do begin
            if (Data.AdcBuf[k]>32768) then count:=count+(Data.AdcBuf[k] - 32768)
                                      else inc(count);
        end;
        Rec^.AllX:=count;
        Rec^.dX:=1.0/Data.Header.FreqReg;
     end else begin
        count:=Data.Header.AdcCount;//2048;
        Rec^.AllX:=count;
        Rec^.dX:=Data.Header.Duration/(count-1);
     end;
     Rec^.XN:=Rec^.dX*(Rec^.AllX-1);
  end else begin
    Rec^.AllX:=Data.Header.SpectrCount;
    if Data.Header.Range=_DPK_LowRange then Rec^.dX:=2.5
                                       else Rec^.dX:=1.0;
    Rec^.XN:=(Rec^.AllX-1)*Rec^.dX;
  end;
  Rec^.Ampl:=0;

  AllocRec(Rec);

  if Rec^.Tip=ztSignal then begin
     i:=1;
     for k:=0 to Data.Header.AdcCount-1 do begin
         if (IsLift) and
            (Data.AdcBuf[k] > 32768) then begin
               countNoisy := (Data.AdcBuf[k] - 32768);
               for j:=1 to countNoisy do begin
                   Rec^.Vals^[i]:=0;
                   inc(i);
               end;
         end else begin
            Rec^.Vals^[i]:=(Integer((Data.AdcBuf[k]) - Integer(Data.Header.MiddleLine)) * Data.Header.Coef);
            if abs(Rec^.Vals^[i])>Rec^.Ampl then
               Rec^.Ampl:=abs(Rec^.Vals^[i]);
            inc(i);
         end;
     end;
  end else begin
     for k:=1 to Rec^.AllX do begin
         Rec^.Vals^[k]:=Integer(Data.SpectrAmplx10[k-1])/10.0;
         if abs(Rec^.Vals^[k])>Rec^.Ampl then
            Rec^.Ampl:=abs(Rec^.Vals^[k]);
     end;
  end;

    Rec^.Option:=0;


    if (Data.Header.Year<2018) or
       (Data.Header.Year>2099) then begin
        DT:=Now();
        DecodeDate(DT, Rec^.ZDate[2], Rec^.ZDate[1], Rec^.ZDate[0]);
        DecodeTime(DT, Rec^.ZTime[0], Rec^.ZTime[1], Rec^.ZTime[2],MSec);
    end else begin
        Rec^.ZDate[2]:=Data.Header.Year;
        Rec^.ZDate[1]:=Data.Header.Month;
        Rec^.ZDate[0]:=Data.Header.Day;
        Rec^.ZTime[0]:=Data.Header.Hour;
        Rec^.ZTime[1]:=Data.Header.Minute;
        Rec^.ZTime[2]:=Data.Header.Second;
    end;

    if Rec^.ZDate[2]<100 then
       Rec^.ZDate[2]:=Rec^.ZDate[2]+2000;

    if Name='' then SrcList.Items.AddObject(GenerateName(rec),TObject(rec))
               else SrcList.Items.AddObject(Name,TObject(rec));

    Result:=1;

  Exit;

except
end;

  if Rec<>nil then
     DestroyRec(Rec);

end;








function DoImportDPK(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;
var
  f: integer;
begin

  Result:=0;

try
  if not Assigned(SrcList) then Exit;

  if not FileExists(FileName) then Exit;

  f:=FileOpen(FileName,fmOpenRead or fmShareDenyWrite);
  if f<0 then
    Exit;

  Result:=DoImportDPKPart(F, 0, 0, '', SrcList);

  FileClose(f);

  DeleteFile(FileName);

except
end;

end;







end.


