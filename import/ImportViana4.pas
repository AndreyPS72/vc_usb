{$R-}
(*

    Файл импорта для приборов Viana4

*)
unit ImportViana4;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
    LCLIntf, LCLType, StdCtrls
    ;

// Для маршрутов: f - открытый файл; Offset - смещение в нем; Len - пока не используется;
// Если Name пустое, то оно собирается из даты
function DoImportViana4Part(f: integer; Offset, Len : longword; Name: UnicodeString; SrcList: TListBox):integer;

// Для простого файла замера
function DoImportViana4(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;


implementation
uses SysUtils
     , Math
     , Defs
     , ZamHdr
     , ImportDefs
     , LinkTypes
     , LinkUtil
     , LinkTypesViana
     , LinkTypesViana4
     , DefsPhaseTable
     , DBox
{$IFDEF NeedImport}
     , DefDB
     , StrConst
     , LinkLang
{$ENDIF}
     ;


Type
  PArrBuf   = ^TArrBuf;
  TArrBuf   = array [1..20000000] of smallint;

var Export_Table_PhaseShift: T_Table_PhaseShift;


// Для маршрутов: f - открытый файл; Offset - смещение в нем; Len - пока не используется;
// Если Name пустое, то оно собирается из даты
function DoImportViana4Part(f: integer; Offset, Len : longword; Name: UnicodeString; SrcList: TListBox):integer;

var
  status: T_DC_Status ;
//  StdMeas: T_DBox_Std;
  pStdMeas: P_DBox_Std;
  vMSP: TMeasSigParams_Viana4;
  ID : longword;
//todo  Addr : PtrInt;
  Addr : Longword;
  bt: T_DBoxType ;
  Date : T_Date;
  Time : T_Time;

  size: longword;
  Mem: pointer;
  Rec: PBufOneRec;
  ch, k: integer;
  pCI_Sig : P_CapsuleInfo;
  iAfter : integer;
  FileID, FileNum : longword;
  MarkerExists: boolean;


  Recs: array [0..MaxNumChMeasuring_Viana4-1] of PBufOneRec;
  iCh, NChannels, nPoints, iPoint : longword;
  pPoint: pWord;
  pSPoint: pSmallInt;
  i, Addr1 : longword;
  DataOffset :Integer;


label lExit;


const Str8521 ='Отметчик №%3.3d в %s от %s';
      Str8523 ='Канал %1.1d  №%3.3d в %s от %s';


function GenerateName(Rec: PBufOneRec):UnicodeString;
var DT: TDateTime;
begin
{$IFDEF NeedImport}
if (Rec^.IsStamper) then Result:=(DelphinStr17)+' '+IntToStr(FileNum)+' '+LinkProtokolMarker+' ['+GetShortNameByTip(Rec.Tip)+', '+GetNameByEdIzm(Rec.EdIzm)+']'
   else Result:=(DelphinStr17)+' '+IntToStr(FileNum)+' #'+IntToStr(ch+1)+' ['+GetShortNameByTip(Rec.Tip)+', '+GetNameByEdIzm(Rec.EdIzm)+']';
{$ELSE}
  try
     DT:=EncodeDate(Rec^.ZDate[2],Rec^.ZDate[1],Rec^.ZDate[0])+EncodeTime(Rec^.ZTime[0],Rec^.ZTime[1],Rec^.ZTime[2],0);
  except
     DT:=Now;
  end;

    if (Rec^.IsStamper) then Result:=Format(Str8521,[vMSP.Number,TimeToStr(DT),DateToStr(DT)])
                        else Result:=Format(Str8523,[ch+1, vMSP.Number, TimeToStr(DT),DateToStr(DT)]);
{$ENDIF}
end;

begin
  result:=0;

  if not Assigned(SrcList) then Exit;

  if Len=0 then begin
     size:=LongWord(FileSeek(F,0,2))-Offset; // До конца файла
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

  Move(Mem^,FileID,sizeof(longword));
  Move(PAnsiChar(PtrUInt(Mem)+4)^,FileNum,sizeof(longword));

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
  if (status<>DCS_Succsses) then goto lExit;

  status:=Get_DBInfo(                      // получить данные заголовка
                    pStdMeas,              // указатель на просматриваемый замер
                    DBT_Meas_Environment, // тип "канального" измерения,
                    0,                    // номер замера
                    ID,                  // возвращаемый ID
                    @vMSP,
                    sizeof(TMeasSigParams_Viana4),
                    Addr
                    );
  if (status<>DCS_Succsses) then goto lExit;

//  if vMSP.StcPrms.NumCh<=0 then goto lExit;

  status:=Get_DBInfo(                      // получить данные заголовка
                    pStdMeas,              // указатель на просматриваемый замер
                    DBT_Date,
                    0,                    // номер замера
                    ID,                  // возвращаемый ID
                    @Date,
                    sizeof(T_Date),
                    Addr
                    );
  if (status<>DCS_Succsses) then goto lExit;

  status:=Get_DBInfo(                      // получить данные заголовка
                    pStdMeas,              // указатель на просматриваемый замер
                    DBT_Time,
                    0,                    // номер замера
                    ID,                  // возвращаемый ID
                    @Time,
                    sizeof(T_Time),
                    Addr
                    );
  if (status<>DCS_Succsses) then goto lExit;



    MarkerExists:=False;
	NChannels:=0;
    for ch:=0 to MaxNumChMeasuring_Viana4-1 do begin
        if (vMSP.StcPrms.Channels[ch]=VC_Mark) then
            MarkerExists:=True;
		if (vMSP.StcPrms.Enable_of_channels[ch]>0) then
        	Inc(NChannels);
    end;

    ID:=0;
  iAfter:=0;
  for ch:=0 to MaxNumChMeasuring_Viana4-1 do begin
     if ((vMSP.StcPrms.Enable_of_channels[ch]>0))
        then begin

        vMSP.Meas_Buf[ch].state       :=DF_Stoped;

        if (vMSP.StcPrms.Channels[ch]=VC_Mark) then bt:=DBT_Marker
           else if vMSP.MeasType=DBT_Spectr then bt:=DBT_Spectr
                   else bt:=DBT_VibSignal;

        if bt=DBT_Marker then
          pCI_Sig:=Get_DB_Capsule(pStdMeas, DBT_Marker,0)
        else
        begin
          pCI_Sig:=Get_DB_Capsule(pStdMeas, bt, iAfter);
          if (pCI_Sig.Addr<>0)then iAfter:=pCI_Sig.Caps^.iSelf+1;
        end;
        Addr:=pCI_Sig.Addr;
        (*
        if bt=DBT_Marker
           then
           Get_DBInfo(                // получить данные заголовка
                          pStdMeas,       // указатель на просматриваемый замер
                          bt,  // тип "канального" измерения,
                          0,              // номер замера
                          ID,            // возвращаемый ID
                          nil,
                          Longword(vMSP.Meas_Buf[ch].SampleStep)*Longword(vMSP.Meas_Buf[ch].NumPointWin),
                          Addr
                          )
           else status:=Get_DBInfo(                // получить данные заголовка
                          pStdMeas,       // указатель на просматриваемый замер
                          bt,  // тип "канального" измерения,
                          ID+1,              // номер замера
                          ID,            // возвращаемый ID
                          nil,
                          Longword(vMSP.Meas_Buf[ch].SampleStep)*Longword(vMSP.Meas_Buf[ch].NumPointWin),
                          Addr
                          );
         *)
       // if (status=DCS_Succsses) then begin
       if (pCI_Sig.Addr<>0) then begin

          CreateRec(Rec);
          if (vMSP.StcPrms.Channels[ch]=VC_A1) then Rec^.EdIzm:=eiAcceleration
          else if (vMSP.StcPrms.Channels[ch]=VC_A2) then Rec^.EdIzm:=eiAcceleration
          else if (vMSP.StcPrms.Channels[ch]=VC_A3) then Rec^.EdIzm:=eiAcceleration
          else if (vMSP.StcPrms.Channels[ch]=VC_A4) then Rec^.EdIzm:=eiAcceleration
          else if (vMSP.StcPrms.Channels[ch]=VC_V1) then Rec^.EdIzm:=eiVelocity
          else if (vMSP.StcPrms.Channels[ch]=VC_V2) then Rec^.EdIzm:=eiVelocity
          else if (vMSP.StcPrms.Channels[ch]=VC_V3) then Rec^.EdIzm:=eiVelocity
          else if (vMSP.StcPrms.Channels[ch]=VC_V4) then Rec^.EdIzm:=eiVelocity
          else if (vMSP.StcPrms.Channels[ch]=VC_S1) then Rec^.EdIzm:=eiDisplacement
          else if (vMSP.StcPrms.Channels[ch]=VC_S2) then Rec^.EdIzm:=eiDisplacement
          else if (vMSP.StcPrms.Channels[ch]=VC_S3) then Rec^.EdIzm:=eiDisplacement
          else if (vMSP.StcPrms.Channels[ch]=VC_S4) then Rec^.EdIzm:=eiDisplacement
          else begin Rec^.EdIzm:=eiVolt; Rec^.IsStamper:=True; end;

         if (vMSP.StcPrms.Channels[ch]=VC_Mark) then Rec^.Tip:=ztSignal
           else if vMSP.MeasType=DBT_Spectr then Rec^.Tip:=ztSpectr
                   else Rec^.Tip:=ztSignal;

  //        Rec^.dX:=vMSP.StcPrms.Frequency_by_channel;

          Rec^.X0:=0;
          if Rec^.Tip=ztSpectr then begin
             Rec^.AllX	:=vMSP.Meas_Buf[ch].NumPointWin;
             Rec^.dX	:=vMSP.StcPrms.Freq_discretization;
             Rec^.XN	:=(Rec^.AllX-1)*Rec^.dX;
          end else begin
             Rec^.AllX	:=vMSP.Meas_Buf[ch].NumPointWin;
             Rec^.dX	:=vMSP.StcPrms.Time_discretization;
             Rec^.XN	:=(Rec^.AllX-1)*Rec^.dX;
          end;

          Rec^.ZDate[0]:=Date.Day;
          Rec^.ZDate[1]:=Date.Month;
          Rec^.ZDate[2]:=(Date.Year mod 100)+2000;
          Rec^.ZTime[0]:=Time.Hour;
          Rec^.ZTime[1]:=Time.Minute;
          Rec^.ZTime[2]:=Time.Second;
		  if MarkerExists then 	Rec^.Option:=opSynhro
          else 					Rec^.Option:=0;

		  if (pCI_Sig.Caps^.InfoSize=0) or (pCI_Sig.Caps^.InfoSize=$FFFFFFFF) then begin	// неопределенная длина

			  vMSP.Meas_Buf[ch].Sa          :=Addr;
//			  vMSP.Meas_Buf[ch].pSPoint     :=pWord(Addr);

			  nPoints:=0;//(Longword(Mem)+size - Addr - 64) div NChannels div sizeof(word);

              Addr1 := Addr;
              i:=0;
              while i<size do begin
                	if (PAnsiChar(Addr1+0)^='T') and
                       (PAnsiChar(Addr1+1)^='H') and
                       (PAnsiChar(Addr1+2)^='E') and
                       (PAnsiChar(Addr1+3)^=' ') and
                       (PAnsiChar(Addr1+4)^='E') and
                       (PAnsiChar(Addr1+5)^='N') and
                       (PAnsiChar(Addr1+6)^='D') then begin
			  			nPoints:=i div NChannels div sizeof(word);
                        Break;
                    end;

              		Inc(i);
                	Inc(Addr1);
              end;



			  if vMSP.StcPrms.Koef[ch]=0 then vMSP.StcPrms.Koef[ch]:=1.0;
			  // вычисление размеров, заполнение статических данных
			  // можно добавить какую-нибудь кратность

			  // тут нужно выделить место для NChannels объектов Recs
			  for iCh:=0 to NChannels-1 do // заполним записи
				begin
					CreateRec(Recs[iCh]);
                    Recs[iCh]^ := Rec^;
					Recs[iCh]^.AllX	:=nPoints;
					Recs[iCh]^.XN	:=(Recs[iCh]^.AllX-1)*Recs[iCh]^.dX;
					Recs[iCh]^.Ampl	:=0;
					AllocRec(Recs[iCh]);
				end;

			    vMSP.Meas_Buf[ch].Ea          :=Longword(vMSP.Meas_Buf[ch].Sa)+Longword(vMSP.Meas_Buf[ch].SampleStep)*nPoints;

                if (vMSP.Meas_Buf[ch].VarType=VarT_S16) then begin
			    	pSPoint     					:= PSmallInt(Addr);
                    for iPoint:=1 to nPoints do begin// пока не добрались до конца файла

                        for iCh:=0 to MaxNumChMeasuring_Viana4-1 do // цикл по имеющимся каналам
                        begin
                            if (vMSP.StcPrms.Enable_of_channels[iCh]>0) then // для разрешенного канала считываем очередную точку
                            begin
                                Recs[iCh]^.Vals^[iPoint]:=vMSP.StcPrms.Koef[iCh]*(Integer(pSPoint^) - Integer(vMSP.StcPrms.DataOffsets[iCh]));
                                if Recs[iCh]^.Ampl < abs(Recs[iCh]^.Vals^[iPoint]) then
                                    Recs[iCh]^.Ampl:=abs(Recs[iCh]^.Vals^[iPoint]);
                                Inc(pSPoint);
                            end;
                        end;

                    end;

                end else begin
			    	pPoint     					:= pWord(Addr);
                    for iPoint:=1 to nPoints do begin// пока не добрались до конца файла

                        for iCh:=0 to MaxNumChMeasuring_Viana4-1 do // цикл по имеющимся каналам
                        begin
                            if (vMSP.StcPrms.Enable_of_channels[iCh]>0) then // для разрешенного канала считываем очередную точку
                            begin
                                Recs[iCh]^.Vals^[iPoint]:=vMSP.StcPrms.Koef[iCh]*(Integer(pPoint^) - Integer(vMSP.StcPrms.DataOffsets[iCh]));
                                if Recs[iCh]^.Ampl < abs(Recs[iCh]^.Vals^[iPoint]) then
                                    Recs[iCh]^.Ampl:=abs(Recs[iCh]^.Vals^[iPoint]);
                                Inc(pPoint);
                            end;
                        end;

                    end;
                end;


			    // конец разбора всех данных
			    // переложить Recs[NChannels] куда надо
			  	for iCh:=0 to NChannels-1 do begin
            		if Name='' then SrcList.Items.AddObject(GenerateName(Recs[iCh]),TObject(Recs[iCh]))
                    	   	   else SrcList.Items.AddObject(Name,TObject(Recs[iCh]));
                end;

			    // выйти из цикла перебора по ch
			    break;

		  end else begin							// известная длина
                vMSP.Meas_Buf[ch].Sa          :=Addr;
                vMSP.Meas_Buf[ch].Ea          :=Longword(vMSP.Meas_Buf[ch].Sa)+Longword(vMSP.Meas_Buf[ch].SampleStep)*Longword(vMSP.Meas_Buf[ch].NumPointWin);
//                vMSP.Meas_Buf[ch].pSPoint     :=pWord(Addr);
                if vMSP.StcPrms.Koef[ch]=0 then
                 	vMSP.StcPrms.Koef[ch]:=1.0;
                AllocRec(Rec);
                Rec^.Ampl:=0;

                DataOffset :=Integer(vMSP.StcPrms.DataOffsets[ch]);
                if (vMSP.Meas_Buf[ch].VarType=VarT_S16) then begin

			  		pSPoint     					:=PSmallInt(Addr);
                    for k:=1 to Rec^.AllX do begin
                       Rec^.Vals^[k]:=vMSP.StcPrms.Koef[ch]*(Integer(pSPoint^)-DataOffset);
                       if abs(Rec^.Vals^[k])>Rec^.Ampl then
                          Rec^.Ampl:=abs(Rec^.Vals^[k]);
                    	Inc(pSPoint);
                    end;

                end else begin

			  		pPoint     					:=PWord(Addr);
                    for k:=1 to Rec^.AllX do begin
                       Rec^.Vals^[k]:=vMSP.StcPrms.Koef[ch]*(Integer(pPoint^)-DataOffset);
                       if abs(Rec^.Vals^[k])>Rec^.Ampl then
                          Rec^.Ampl:=abs(Rec^.Vals^[k]);
                       Inc(pPoint);
                    end;
                end;

		  end;

			// Импорт таблицы ФЧХ
			FillChar(Export_Table_PhaseShift, szT_Table_PhaseShift, 0);
			status:=Get_DBInfo(pStdMeas, DBT_TablePhaseShift,  ID, ID, @Export_Table_PhaseShift, szT_Table_PhaseShift, Addr);
			if (status=DCS_Succsses) then begin
				AddLocalTag(Rec, lttPhaseTable, @Export_Table_PhaseShift, szT_Table_PhaseShift);
				inc(ID);
			end;	
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
function DoImportViana4(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;
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

  Result:=DoImportViana4Part(F, 0, 0, '', SrcList);

  FileClose(f);

  DeleteFile(FileName);

except
end;

end;



end.


