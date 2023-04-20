{$R-}
(*

    Файл импорта для приборов Viana-2

*)
unit ImportViana2;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
  LCLIntf, LCLType, StdCtrls
  ;


// Для маршрутов: f - открытый файл; Offset - смещение в нем; Len - пока не используется;
// Если Name пустое, то оно собирается из даты
function DoImportViana2Part(f: integer; Offset, Len : longword; Name: UnicodeString; SrcList: TListBox):integer;

// Для простого файла замера
function DoImportViana2(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;


implementation
uses SysUtils
     , Math
     , Defs
     , ZamHdr
     , ImportDefs
     , LinkTypes
     , LinkUtil
     , LinkTypesViana2
     , LinkTypesVV2
{$IFDEF NeedImport}
     , DefDB
{$ENDIF}
     ;


const _Viana2_MaxDataSize = _Viana2_CHANNEL_COUNT * _Viana2_MAX_POINT_RECORDER;

var
  MeasHdr: _Viana2_TMeas;
  MeasData : array [0.._Viana2_MaxDataSize-1] of _Viana2_TOnePoint;





function DoImportViana2Part(f: integer; Offset, Len : longword; Name: UnicodeString; SrcList: TListBox):integer;
var
  k, typ: integer;
  DataLen: integer;
  Index: integer;
  IndexData: integer;
  Param: T_VV2_Parameters;

  Rec: PBufOneRec;

const Str8521 ='Отметчик №%3.3d в %s от %s';
      Str8523 ='Канал %1.1d  №%3.3d в %s от %s';


function GenerateName(Rec: PBufOneRec; Ch: longword):UnicodeString;
var DT: TDateTime;
begin

   try
      DT:=EncodeDate(Rec^.ZDate[2],Rec^.ZDate[1],Rec^.ZDate[0])+EncodeTime(Rec^.ZTime[0],Rec^.ZTime[1],Rec^.ZTime[2],0);
   except
      DT:=Now;
   end;

{$IFDEF NeedImport}
    if (Rec^.IsStamper) then Result:=Format((str8521),[Param.Num,TimeToStr(DT),DateToStr(DT),GetShortNameByTip(Rec.Tip),GetNameByEdIzm(Rec.EdIzm)])
                        else Result:=Format((str8523),[Ch+1,Param.Num,TimeToStr(DT),DateToStr(DT),GetShortNameByTip(Rec.Tip),GetNameByEdIzm(Rec.EdIzm)]);
{$ELSE}
    if (Rec^.IsStamper) then Result:=Format(Str8521,[Param.Num,TimeToStr(DT),DateToStr(DT)])
                        else Result:=Format(Str8523,[Ch+1,Param.Num,TimeToStr(DT),DateToStr(DT)]);
{$ENDIF}
end;


begin
  result:=0;

  Rec:=nil;
  DataLen:=0;

try

  FileSeek(F,Offset,0);

  FileRead(F,Param,szT_VV2_Parameters);
  FileRead(F,MeasHdr,Param.DataLen[0]);
  DataLen:=Param.DataLen[1];
  if (DataLen>sizeof(MeasData)) then
     DataLen:=sizeof(MeasData);
  FileRead(F,MeasData,DataLen);

if (MeasHdr.Exist=_Viana2_teNo) then begin
   Result:=0;
   Exit;
end;


if (CheckCRC(MeasHdr,sz_Viana2_TMeas,MeasHdr.CRC)=False) then begin
   Result:=0;
   Exit;
end;



IndexData:=0;

for Index:=0 to _Viana2_CHANNEL_COUNT-1 do begin

    if (MeasHdr.CH[Index].Exist=_Viana2_teNo) then begin
       continue;
    end;

    typ:=_Viana2_ztWaveform;
    if (MeasHdr.CH[Index].Table[typ].Exist=_Viana2_teNo) then begin
    	typ:=_Viana2_ztSpectrum;
    	if (MeasHdr.CH[Index].Table[typ].Exist=_Viana2_teNo) then
        	continue;
    end;

    if (MeasHdr.CH[Index].Table[typ].Types>_Viana2_ztEnvSpectrum) then
       continue;


    if (MeasHdr.CH[Index].Table[typ].Units>=_Viana2_eiCount) then
       continue;


    CreateRec(Rec);

    if (MeasHdr.CH[Index].Table[typ].Types=_Viana2_ztSpectrum) then Rec^.Tip:=ztSpectr
    else if (MeasHdr.CH[Index].Table[typ].Types=_Viana2_ztEnvelope) then Rec^.Tip:=ztEnvelope
    else if (MeasHdr.CH[Index].Table[typ].Types=_Viana2_ztEnvSpectrum) then Rec^.Tip:=ztSpectrOgib
       else Rec^.Tip:=ztSignal;

    if (MeasHdr.CH[Index].Table[typ].Units=_Viana2_eiAcceleration) then Rec^.EdIzm:=eiAcceleration
    else if (MeasHdr.CH[Index].Table[typ].Units=_Viana2_eiVelocity) then Rec^.EdIzm:=eiVelocity
    else if (MeasHdr.CH[Index].Table[typ].Units=_Viana2_eiDisplacement) then Rec^.EdIzm:=eiDisplacement
    else Rec^.EdIzm:=eiVolt;

    if (Index = _Viana2_CH_TACH) then begin
        if (MeasHdr.MeasSetup.MeasurementMode = _Viana2_SETUP_MSM_UHF) or
            (MeasHdr.MeasSetup.Path = _Viana2_SETUP_MSP_UHF)
        then begin
            Rec^.EdIzm:=eiVolt;
        end
        else
        if (MeasHdr.MeasSetup.MeasurementMode = _Viana2_SETUP_MSM_CURRENT)
        then begin
           Rec^.EdIzm:=_Viana2_eiAMPER;
        end
    else begin
       Rec^.EdIzm:=eiVolt;
       Rec^.IsStamper:=True;
    end;
    end;


    Rec^.X0:=MeasHdr.CH[Index].Table[typ].X0;
    Rec^.AllX:=MeasHdr.CH[Index].Table[typ].AllX;
    Rec^.dX:=MeasHdr.CH[Index].Table[typ].dX;
    Rec^.XN:= Rec^.X0 + (Rec^.AllX-1)*Rec^.dX;
    Rec^.Ampl:=0;

    AllocRec(Rec);

    if (MeasHdr.CH[Index].Table[typ].DataFormat and _Viana2_dfCOMLEX_VALUE) <> 0 then begin
      // комплексный спектр -> переводим в амплитудный
      for k:=1 to Rec^.AllX do begin
        Rec^.Vals^[k]:=sqrt(sqr(MeasData[IndexData+k*2-2])+sqr(MeasData[IndexData+k*2-1])) *MeasHdr.CH[Index].Table[typ].Scale;
        if abs(Rec^.Vals^[k])>Rec^.Ampl then
           Rec^.Ampl:=abs(Rec^.Vals^[k]);
      end;
    end else begin
      for k:=1 to Rec^.AllX do begin
        if (MeasHdr.CH[Index].Table[typ].DataFormat and _Viana2_dfLOG_VALUE) <> 0
        then Rec^.Vals^[k]:=Power(10.0, MeasData[IndexData+k-1])*MeasHdr.CH[Index].Table[typ].Scale // Логарифмический формат = 10^Val
        else Rec^.Vals^[k]:=MeasData[IndexData+k-1]*MeasHdr.CH[Index].Table[typ].Scale;
        if abs(Rec^.Vals^[k])>Rec^.Ampl then
           Rec^.Ampl:=abs(Rec^.Vals^[k]);
      end;
    end;

    Rec^.Option:=0;

    DateTimeMulti(MeasHdr.DT, Rec^.ZDate[2], Rec^.ZDate[1], Rec^.ZDate[0], Rec^.ZTime[0], Rec^.ZTime[1], Rec^.ZTime[2]);

    if Rec^.ZDate[2]<100 then
       Rec^.ZDate[2]:=Rec^.ZDate[2]+2000;

    if Name='' then SrcList.Items.AddObject(GenerateName(rec, Index),TObject(rec))
               else SrcList.Items.AddObject(Name,TObject(rec));

    Result:=1;

    IndexData:=IndexData+MeasHdr.CH[Index].Table[typ].LenT div sz_Viana2_TOnePoint;

end;

Exit;

except
end;

  if Rec<>nil then
     DestroyRec(Rec);

end;





function DoImportViana2(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;
var
  f: integer;
begin

  Result:=0;

try
  if not Assigned(SrcList) then Exit;

  if not FileExists(FileName) then Exit;

  f:=FileOpen(FileName, fmOpenRead or fmShareDenyWrite);
  if f<0 then
    Exit;

  Result:=DoImportViana2Part(F, 0, 0, '', SrcList);

  FileClose(f);

  DeleteFile(FileName);
  
except
end;
  
end;


end.

