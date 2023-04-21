{$RANGECHECKS OFF}
(*

    Файл импорта для приборов Viana1

*)
unit ImportViana1;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
  LCLIntf, LCLType, StdCtrls
  ;


// Для маршрутов: f - открытый файл; Offset - смещение в нем; Len - пока не используется;
// Если Name пустое, то оно собирается из даты
function DoImportViana1Part(f: integer; Offset, Len : longword; Name: UnicodeString; SrcList: TListBox):integer;

// Для простого файла замера
function DoImportViana1(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;


implementation
uses SysUtils
     , Math
     , Defs
     , ZamHdr
     , ImportDefs
     , LinkTypes
     , LinkUtil
     , LinkTypesViana, DBox
{$IFDEF NeedImport}
     , DefDB
     , StrConst
     , LinkLang
{$ENDIF}
     ;


Type
  PArrBuf   = ^TArrBuf;
  TArrBuf   = array [1..20000000] of smallint;


// Для маршрутов: f - открытый файл; Offset - смещение в нем; Len - пока не используется;
// Если Name пустое, то оно собирается из даты
function DoImportViana1Part(f: integer; Offset, Len : longword; Name: UnicodeString; SrcList: TListBox):integer;

var
  status: T_DC_Status ;
//  StdMeas: T_DBox_Std;
  pStdMeas: P_DBox_Std;
  vMSP: TMeasSigParams;
  ID : longword;
//todo  Addr : PtrUInt;
  Addr : Longword;
  bt: T_DBoxType ;
  pSPointU16: pWordArray;
  pSPointS16: PSmallintArray;
  Date : T_Date;
  Time : T_Time;

  size: longword;
  Mem: pointer;
  Rec: PBufOneRec;
  ch, k: integer;
  MarkerExists: Boolean;

label lExit;


const Str8521 ='Отметчик №%3.3d в %s от %s';
      Str8523 ='Замер №%3.3d в %s от %s';


function GenerateName(Rec: PBufOneRec):UnicodeString;
var DT: TDateTime;
begin

{$IFDEF NeedImport}
if (Rec^.IsStamper) then Result:=(DelphinStr17)+IntToStr(vMSP.Number)+' '+LinkProtokolMarker+' ['+GetShortNameByTip(Rec.Tip)+', '+GetNameByEdIzm(Rec.EdIzm)+']'
   else Result:=(DelphinStr17)+' '+IntToStr(vMSP.Number)+' ['+GetShortNameByTip(Rec.Tip)+', '+GetNameByEdIzm(Rec.EdIzm)+']';
{$ELSE}
  try
     DT:=EncodeDate(Rec^.ZDate[2],Rec^.ZDate[1],Rec^.ZDate[0])+EncodeTime(Rec^.ZTime[0],Rec^.ZTime[1],Rec^.ZTime[2],0);
  except
     DT:=Now;
  end;

    if (Rec^.IsStamper) then Result:=Format(Str8521,[vMSP.Number,TimeToStr(DT),DateToStr(DT)])
                        else Result:=Format(Str8523,[vMSP.Number,TimeToStr(DT),DateToStr(DT)]);
{$ENDIF}

end;

begin
  result:=0;
  if not Assigned(SrcList) then Exit;


Assert(sizeof(T_DBoxType)=4);
Assert(sizeof(TFlowMode)=1);
Assert(sizeof(T_VarType)=1);
Assert(sizeof(TVibChnl)=4);
Assert(sizeof(TStatSigParams)=128);
Assert(sizeof(TFlow_Buf)=48);
Assert(sizeof(TMeasSigParams)=512);



//      FlushFileBuffers(F);

  if Len=0 then begin
     size:=FileSeek(F,0,2)-Offset; // До конца файла
  end else size:=Len;
  if (size=0) then begin
     Exit;
  end;

  FileSeek(F,Offset,0);

  Mem:=nil;
  Rec:=nil;

try

  Mem:=GetMem(size);
  FileRead(F,Mem^,size);

(*
  status:=Create_DBox(
                    pStdMeas,                 // указатель на настраиваемый DBox
                    DBT_Meas_Environment,     // тип первой "информации"
                    sizeof(TMeasSigParams),   // её размер
                    Mem,    // указатель на информацию в ОЗУ
                    @StdMeas,// выделяемое под DBox место1
                    size          // размер выделяемого места
                    );
  if (status<>DCS_Succsses) then
     goto lExit;
*)
  status:=Set_DBox(pStdMeas, PAnsiChar(PtrUInt(Mem)+9), size-9);
  if (status<>DCS_Succsses) then begin
     goto lExit;
  end;

  status:=Get_DBInfo(                      // получить данные заголовка
                    pStdMeas,              // указатель на просматриваемый замер
                    DBT_Meas_Environment, // тип "канального" измерения,
                    0,                    // номер замера
                    ID,                  // возвращаемый ID
                    @vMSP,
                    sizeof(TMeasSigParams),
                    Addr
                    );
  if (status<>DCS_Succsses) then begin
     goto lExit;
  end;

  if vMSP.StcPrms.NumCh<=0 then begin
     goto lExit;
  end;

  status:=Get_DBInfo(                      // получить данные заголовка
                    pStdMeas,              // указатель на просматриваемый замер
                    DBT_Date,
                    0,                    // номер замера
                    ID,                  // возвращаемый ID
                    @Date,
                    sizeof(T_Date),
                    Addr
                    );
  if (status<>DCS_Succsses) then begin
     goto lExit;
  end;

  status:=Get_DBInfo(                      // получить данные заголовка
                    pStdMeas,              // указатель на просматриваемый замер
                    DBT_Time,
                    0,                    // номер замера
                    ID,                  // возвращаемый ID
                    @Time,
                    sizeof(T_Time),
                    Addr
                    );
  if (status<>DCS_Succsses) then begin
     goto lExit;
  end;



    MarkerExists:=False;
    for ch:=0 to vMSP.StcPrms.NumCh-1 do begin
        if (vMSP.StcPrms.Channels[ch]=VC_Mark) then
            MarkerExists:=True;
    end;


  for ch:=0 to vMSP.StcPrms.NumCh-1 do begin
     if ((vMSP.StcPrms.Channels[ch]=VC_A) OR
         (vMSP.StcPrms.Channels[ch]=VC_V) OR
         (vMSP.StcPrms.Channels[ch]=VC_S) OR
         (vMSP.StcPrms.Channels[ch]=VC_Mark))
        then begin

//        vMSP.Meas_Buf[ch].state       :=DF_Stoped;

        if (vMSP.StcPrms.Channels[ch]=VC_Mark) then bt:=DBT_Marker
           else if vMSP.MeasType=DBT_Spectr then bt:=DBT_Spectr
                   else bt:=DBT_VibSignal;

        status:=Get_DBInfo(                // получить данные заголовка
                          pStdMeas,       // указатель на просматриваемый замер
                          bt,  // тип "канального" измерения,
                          0,              // номер замера
                          ID,            // возвращаемый ID
                          nil,
                          Longword(vMSP.Meas_Buf[ch].SampleStep)*Longword(vMSP.Meas_Buf[ch].NumPointWin),
                          Addr
                          );

        if (status=DCS_Succsses) then begin

          CreateRec(Rec);
          if (vMSP.StcPrms.Channels[ch]=VC_A) then Rec^.EdIzm:=eiAcceleration
          else if (vMSP.StcPrms.Channels[ch]=VC_V) then Rec^.EdIzm:=eiVelocity
          else if (vMSP.StcPrms.Channels[ch]=VC_S) then Rec^.EdIzm:=eiDisplacement
          else begin Rec^.EdIzm:=eiVolt; Rec^.IsStamper:=True; end;

         if (vMSP.StcPrms.Channels[ch]=VC_Mark) then Rec^.Tip:=ztSignal
           else if vMSP.MeasType=DBT_Spectr then Rec^.Tip:=ztSpectr
                   else Rec^.Tip:=ztSignal;

  //        Rec^.dX:=vMSP.StcPrms.Frequency_by_channel;

          Rec^.X0:=0;
          if Rec^.Tip=ztSpectr then begin
             Rec^.AllX:=vMSP.Meas_Buf[ch].NumPointWin;
             Rec^.dX:=vMSP.StcPrms.Freq_discretization;
             Rec^.XN:=(Rec^.AllX-1)*Rec^.dX;
          end else begin
             Rec^.AllX:=vMSP.Meas_Buf[ch].NumPointWin;
             Rec^.dX:=vMSP.StcPrms.Time_discretization;
             Rec^.XN:=(Rec^.AllX-1)*Rec^.dX;
          end;
(*
          vMSP.Meas_Buf[ch].Sa          :=Addr;
          vMSP.Meas_Buf[ch].Ea          :=Longword(vMSP.Meas_Buf[ch].Sa)+Longword(vMSP.Meas_Buf[ch].SampleStep)*Longword(vMSP.Meas_Buf[ch].NumPointWin);
          vMSP.Meas_Buf[ch].pSPoint     :=pWord(vMSP.Meas_Buf[ch].Sa);
*)

          if vMSP.StcPrms.Koef[ch]=0 then
             vMSP.StcPrms.Koef[ch]:=1.0;
          AllocRec(Rec);

          if Rec^.Tip=ztSpectr then
             vMSP.StcPrms.DataOffsets[ch]:=0;

          if (vMSP.Meas_Buf[ch].VarType=VarT_U16) or
             (vMSP.Meas_Buf[ch].VarType=VarT_None) then begin

                pSPointU16 :=PWordArray(Addr);//vMSP.Meas_Buf[ch].pSPoint);
                for k:=1 to Rec^.AllX do begin
                    Rec^.Vals^[k]:=vMSP.StcPrms.Koef[ch]*(Integer(pSPointU16^[k-1])-Integer(vMSP.StcPrms.DataOffsets[ch]));
                end;

          end else
          if vMSP.Meas_Buf[ch].VarType=VarT_S16 then begin

                pSPointS16 :=PSmallintArray(Addr);
                for k:=1 to Rec^.AllX do begin
                    Rec^.Vals^[k]:=vMSP.StcPrms.Koef[ch]*(Integer(pSPointS16^[k-1])-Integer(vMSP.StcPrms.DataOffsets[ch]));
                end;

          end else
                for k:=1 to Rec^.AllX do begin
                    Rec^.Vals^[k]:=0;
                end;


          Rec^.Ampl:=0;
          for k:=1 to Rec^.AllX do begin
                   if abs(Rec^.Vals^[k])>Rec^.Ampl then
                      Rec^.Ampl:=abs(Rec^.Vals^[k]);
          end;

          if MarkerExists then Rec^.Option:=opSynhro
            else Rec^.Option:=0;

          Rec^.ZDate[0]:=Date.Day;
          Rec^.ZDate[1]:=Date.Month;
          Rec^.ZDate[2]:=(Date.Year mod 100)+2000;
          Rec^.ZTime[0]:=Time.Hour;
          Rec^.ZTime[1]:=Time.Minute;
          Rec^.ZTime[2]:=Time.Second;

          if Name='' then SrcList.Items.AddObject(GenerateName(rec),TObject(rec))
                     else SrcList.Items.AddObject(Name,TObject(rec));

        end;
     end;
  end;
  result:=1;

  if (Mem<>nil) then
     FreeMem(Mem);
  Exit;


lExit:

except
end;

  if Rec<>nil then
     DestroyRec(Rec);
  if (Mem<>nil) then
     FreeMem(Mem);

end;







// Для простого файла замера
function DoImportViana1(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;
var
  f: integer;
begin

  Result:=0;

try

  if not Assigned(SrcList) then begin
     Exit;
  end;

  if not FileExists(FileName) then begin
     Exit;
  end;

  f:=FileOpen(FileName,fmOpenRead or fmShareDenyWrite);
  if f<0 then begin
    Exit;
  end;

  Result:=DoImportViana1Part(F, 0, 0, '', SrcList);

  FileClose(f);

  DeleteFile(FileName);

except
end;

end;



end.


