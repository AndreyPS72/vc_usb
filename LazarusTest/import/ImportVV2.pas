{$R-}
(*

    Файл импорта для приборов VV2

*)
unit ImportVV2;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
  LCLIntf, LCLType, StdCtrls
  ;


// Для маршрутов: f - открытый файл; Offset - смещение в нем; Len - пока не используется;
// Если Name пустое, то оно собирается из даты
function DoImportVV2Part(f: integer; Offset, Len : longword; Name: UnicodeString; SrcList: TListBox):integer;

// Для простого файла замера
function DoImportVV2(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;


implementation
uses SysUtils
     , Math
     , Defs
     , ZamHdr
     , ImportDefs
     , LinkTypes
     , LinkUtil
     , LinkTypesVV2
{$IFDEF NeedImport}
     , DefDB
{$ENDIF}
     ;


const _VV2_MaxDataSize = _VV2_MaxChannelCount*_VV2_MaxPoint;

var
  Res: T_VV2_WaveRes;
  MeasData : array [0.._VV2_MaxDataSize-1] of T_VV2_OnePoint;





function DoImportVV2Part(f: integer; Offset, Len : longword; Name: UnicodeString; SrcList: TListBox):integer;
var
  ch, k: integer;
  DataLen: integer;
  Index: integer;
  IndexData: integer;
  Param: T_VV2_Parameters;

  Rec: PBufOneRec;
  sum: double;

const Str8521 ='Отметчик №%3.3d в %s от %s';
      Str8522 ='Замер    №%3.3d';


function GenerateName(Rec: PBufOneRec):UnicodeString;
var DT: TDateTime;
begin

   try
      DT:=EncodeDate(Rec^.ZDate[2],Rec^.ZDate[1],Rec^.ZDate[0])+EncodeTime(Rec^.ZTime[0],Rec^.ZTime[1],Rec^.ZTime[2],0);
   except
      DT:=Now;
   end;

{$IFDEF NeedImport}
    if (Rec^.IsStamper) then Result:=Format((str8521),[Param.Num,TimeToStr(DT),DateToStr(DT),GetShortNameByTip(Rec.Tip),GetNameByEdIzm(Rec.EdIzm)])
                        else Result:=Format((str8520),[Param.Num,TimeToStr(DT),DateToStr(DT),GetShortNameByTip(Rec.Tip),GetNameByEdIzm(Rec.EdIzm)]);
{$ELSE}
    if (Rec^.IsStamper) then Result:=Format(Str8521,[Param.Num,TimeToStr(DT),DateToStr(DT)])
                        else Result:=Format(Str8522,[Param.Num,TimeToStr(DT),DateToStr(DT)]);
{$ENDIF}
end;


label lExit;
begin
  result:=0;

  Rec:=nil;
  DataLen:=0;

try

  FileSeek(F,Offset,0);

  FileRead(F,Param,szT_VV2_Parameters);
  FileRead(F,Res,Param.DataLen[0]);
  DataLen:=Param.DataLen[1];
  if (DataLen>sizeof(MeasData)) then
     DataLen:=sizeof(MeasData);
  FileRead(F,MeasData,DataLen);

if (Res.Exist=_VV2_teNo) then begin
   Result:=0;
   Exit;
end;


if (Res.DataCRC<>CalcCRC(MeasData,DataLen)) then begin
   Result:=0;
   Exit;
end;

if (CheckCRC(Res,szT_VV2_WaveRes,Res.CRC)=False) then begin
   Result:=0;
   Exit;
end;



IndexData:=0;

for Index:=0 to _VV2_MaxChannelCount-1 do begin

    if (Res.CH[Index].Exist=_VV2_teNo) then begin
       continue;
    end;


    if (Res.CH[Index].Tip<>_VV2_ztWaveform) and
       (Res.CH[Index].Tip<>_VV2_ztSpectrum) and
       (Res.CH[Index].Tip<>_VV2_ztEnvelope) and
       (Res.CH[Index].Tip<>_VV2_ztEnvSpectrum) then begin
       continue;
    end;


    if (Res.CH[Index].EdIzm<>_VV2_eiAcceleration) and
       (Res.CH[Index].EdIzm<>_VV2_eiVelocity) and
       (Res.CH[Index].EdIzm<>_VV2_eiDisplacement) and
       (Res.CH[Index].EdIzm<>_VV2_eiVolt) then begin
       continue;
    end;


    CreateRec(Rec);

    if (Res.CH[Index].Tip=_VV2_ztSpectrum) then Rec^.Tip:=ztSpectr
    else if (Res.CH[Index].Tip=_VV2_ztEnvelope) then Rec^.Tip:=ztEnvelope
    else if (Res.CH[Index].Tip=_VV2_ztEnvSpectrum) then Rec^.Tip:=ztSpectrOgib
       else Rec^.Tip:=ztSignal;

    if (Res.CH[Index].EdIzm=_VV2_eiAcceleration) then Rec^.EdIzm:=eiAcceleration
    else if (Res.CH[Index].EdIzm=_VV2_eiVelocity) then Rec^.EdIzm:=eiVelocity
    else if (Res.CH[Index].EdIzm=_VV2_eiDisplacement) then Rec^.EdIzm:=eiDisplacement
    else begin
       Rec^.EdIzm:=eiVolt;
       Rec^.IsStamper:=True;
    end;

    if (Res.CH[Index].Tip=_VV2_ztEnvelope) or
       (Res.CH[Index].Tip=_VV2_ztEnvSpectrum) then begin
       Rec^.EdIzm:=eiVolt;
       Res.CH[Index].Scale:=Res.CH[Index].Scale/1e6;
    end;

    Rec^.X0:=0;
    Rec^.AllX:=Res.CH[Index].AllX;
    Rec^.dX:=Res.CH[Index].dX;
    Rec^.XN:=(Rec^.AllX-1)*Rec^.dX;
    Rec^.Ampl:=0;

       AllocRec(Rec);

       if (Rec^.Tip=ztSpectr) OR
          (Rec^.Tip=ztSpectrOgib) then begin
          // Спектр комплексный
          for k:=1 to Rec^.AllX do begin
            Rec^.Vals^[k]:=sqrt(sqr(MeasData[IndexData+k*2-2])+sqr(MeasData[IndexData+k*2-1])) *Res.CH[Index].Scale;
            if abs(Rec^.Vals^[k])>Rec^.Ampl then
               Rec^.Ampl:=abs(Rec^.Vals^[k]);
          end;
       end else begin
          for k:=1 to Rec^.AllX do begin
            Rec^.Vals^[k]:=MeasData[IndexData+k-1]*Res.CH[Index].Scale;
            if abs(Rec^.Vals^[k])>Rec^.Ampl then
               Rec^.Ampl:=abs(Rec^.Vals^[k]);
          end;
       end;

    if (Rec^.Tip=ztEnvelope) and (Rec^.AllX>0) then begin
          // Огибающую усадить на ноль
          sum:=0;
          for k:=1 to Rec^.AllX do begin
            sum:=sum+Rec^.Vals^[k];
          end;
          sum:=sum/Rec^.AllX;
          Rec^.Ampl:=0;
          for k:=1 to Rec^.AllX do begin
            Rec^.Vals^[k]:=Rec^.Vals^[k]-sum;
            if abs(Rec^.Vals^[k])>Rec^.Ampl then
               Rec^.Ampl:=abs(Rec^.Vals^[k]);
          end;
    end;

    Rec^.Option:=0;

    DateTimeMulti(Res.DT, Rec^.ZDate[2], Rec^.ZDate[1], Rec^.ZDate[0], Rec^.ZTime[0], Rec^.ZTime[1], Rec^.ZTime[2]);

    if Rec^.ZDate[2]<100 then
       Rec^.ZDate[2]:=Rec^.ZDate[2]+2000;

    if Name='' then SrcList.Items.AddObject(GenerateName(rec),TObject(rec))
               else SrcList.Items.AddObject(Name,TObject(rec));

    Result:=1;

    IndexData:=IndexData+Res.CH[Index].LenT div szT_VV2_OnePoint;

end;

Exit;

except
end;

  if Rec<>nil then
     DestroyRec(Rec);

end;





function DoImportVV2(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;
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

  Result:=DoImportVV2Part(F, 0, 0, '', SrcList);

  FileClose(f);

  DeleteFile(FileName);
  
except
end;
  
end;


end.

