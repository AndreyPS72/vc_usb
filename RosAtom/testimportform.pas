unit TestImportForm;

{$MODE DelphiUnicode}
{$CODEPAGE UTF8}
{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, EditBtn, IniPropStorage, XMLPropStorage, LinkTypes, ImportDefs
  ;

type

  { TFormRosAtomImport }

  TFormRosAtomImport = class(TForm)
    ButtonStop: TButton;
    ButtonDownloadMeasurements: TButton;
    ButtonClose: TButton;
    ButtonDeviceInfo: TButton;
    ButtonGetList: TButton;
    DirectoryEditPath: TDirectoryEdit;
    IniPropStorage1: TIniPropStorage;
    LogText: TListBox;
    pbBar: TProgressBar;
    RadioGroupPort: TRadioGroup;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonDeviceInfoClick(Sender: TObject);
    procedure ButtonGetListClick(Sender: TObject);
    procedure ButtonDownloadMeasurementsClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RadioButtonUSBChange(Sender: TObject);
  private
    procedure ClearListObjects();

    procedure ShowDeviceInfo();

    function TestPribor(): boolean;
    function GetMeasurementsList(): boolean;
    procedure AddMeasurementToClipboard(aTitle: string; pntr: PLinkList);
    function AddFromFile(aTitle: string; aFilePath: string): boolean;
    // Вычислить данные и вернуть строку
    function GetDataString(Rec: PBufOneRec): string;

  public

  end;

var
  FormRosAtomImport: TFormRosAtomImport;

implementation
uses LinkParamsDefs
    , LinkPortClass
    , LinkTestPort
    , LConvEncoding
    , Clipbrd
    , ImportViana2
    , ImportKorsar
    , ImportViana1
    , ImportViana4
    , ImportDPK
    , ImportVV2
    , Zamhdr
    , rFFT
    ;


resourcestring
  PriborName =                    'Наименование прибора             = %s';
  PriborType =                    'Тип прибора                      = %d';
  PriborSerial =                  'Серийный номер прибора           = %d';
  PriborProgVersion =             'Версия програмного обеспечения   = %1d.%2.2d';
  PriborLinkVersion =             'Версия протокола обмена          = %1d.%2.2d';
  PriborFlash =                   'Размер FLASH                     = %.1f кБ';
  PriborEeprom =                  'Размер EEPROM                    = %.1f кБ';


var
  Info: TInfoPribor;

{$R *.lfm}

{ TFormRosAtomImport }

procedure TFormRosAtomImport.ButtonCloseClick(Sender: TObject);
begin
  Close();
end;



procedure TFormRosAtomImport.ShowDeviceInfo();
begin

  ClearListObjects();

  try
    LogText.Items.Add(Format(PriborType, [Info.Pribor]));
    if (Info.Pribor = prViana1) then LogText.Items.Add(Format(PriborName, ['ViAna-1']))
    else if (Info.Pribor = prViana2) then LogText.Items.Add(Format(PriborName, ['ViAna-2']))
    else if (Info.Pribor = prViana4) then LogText.Items.Add(Format(PriborName, ['ViAna-4']))
    else if (Info.Pribor = prDPK) then LogText.Items.Add(Format(PriborName, ['ДПК-Вибро']))
    else if (Info.Pribor = prDiana2Rev2) then LogText.Items.Add(Format(PriborName, ['Диана-2М']))
    else if (Info.Pribor = prVV2) then LogText.Items.Add(Format(PriborName, ['Vibro Vision-2']))
    else if (Info.Pribor = prKorsar) then LogText.Items.Add(Format(PriborName, ['Корсар']))
    ;

    if
      (Info.Pribor = prDiana) or
      (Info.Pribor = prDiana2Rev1) or
      (Info.Pribor = prDiana2Rev2) or
      (Info.Pribor = prDiana8Rev1) or
      (Info.Pribor = prDianaS) or
      (Info.Pribor = prNikta) or
      (Info.Pribor = prAR700) or
      (Info.Pribor = prAR700Rev2) or
      (Info.Pribor = prVik3) or
      (Info.Pribor = prVik3Rev1) or
      (Info.Pribor = prKorsarROS) or
      (Info.Pribor = prTestSK) or
      (Info.Pribor = prTestSKRev2) or
      (Info.Pribor = prAR200) or
      (Info.Pribor = prAR100) or
      (Info.Pribor = prBalansSK) or
      (Info.Pribor = prUltraTest) or
      (Info.Pribor = prViana1) or
      (Info.Pribor = prViana4) or
      (Info.Pribor = prVS3D) or
      (Info.Pribor = prDPK) or
      (Info.Pribor = prVV2) or
      (Info.Pribor = prViana2) then
    begin
      if Info.Numer > 0 then
      begin
        LogText.Items.Add(Format(PriborSerial, [Info.Numer]));
      end;
    end;

    LogText.Items.Add(Format(PriborProgVersion, [Info.Version div 100, Info.Version mod 100]));

    LogText.Items.Add(Format(PriborLinkVersion, [Info.Protokol div 100, Info.Protokol mod 100]));

    LogText.Items.Add(Format(PriborFlash, [Info.Flash / 1024.0]));

    if (Info.Pribor = prDiana) or (Info.Pribor = prVik3) or
      (Info.Pribor = prVik3Rev1) or (Info.Pribor = prKorsarROS) or
      (Info.Pribor = prTestSK) or (Info.Pribor = prTestSKRev2) then
    begin
      LogText.Items.Add(Format(PriborEeprom, [Info.EEPROM / 1024.0]));
    end;

  except
  end;

end;






function TFormRosAtomImport.TestPribor(): boolean;
begin

  Result := (SendCommandRepeat(cmdTestPribor, 0, 0, 0, 0, @Info, szTInfoPriborFull) = LinkResultOk);

end;



procedure TFormRosAtomImport.ButtonDeviceInfoClick(Sender: TObject);
var res: boolean;
begin

  StopLink := False;
  ClearListObjects();

  res := TestPribor();

  if res then
     ShowDeviceInfo();

end;







function ListFirstFrame(Frame:TLinkFrame):Longint; stdcall;
begin
    result:=ErrorUnknown;
try
    begin
        FormRosAtomImport.pbBar.Min:=0;
        FormRosAtomImport.pbBar.Max:=Frame.Count;
        FormRosAtomImport.pbBar.Position:=0;
    end;

    Application.ProcessMessages;

    if ((Frame.Count = 0) or
    	(Frame.Length = 0)) then
        result := ErrorUnknown
    else
    	result := LinkResultOk;

except
end;
end;


function GetDateTimeMegaStr(var aDT: TDateTimeMega): string;
var DT: TDateTime;
begin
Result:='';
try
     DT := EncodeDate(aDT.tm_year, aDT.tm_month, aDT.tm_day) +
           EncodeTime(aDT.tm_hh, aDT.tm_mm, aDT.tm_sec, 0);

     Result:=DateToStr(DT)+' '+TimeToStr(DT);

except
end;

end;

function GetIDFromList(pntr: PLinkList): TID;
begin
// ID_High==0xFF или 0x00 - не используем
if (pntr^.ID_High<>$FF) then Result:=(TID(pntr^.ID_High) SHL 16) OR TID(pntr^.ID_Low)
                        else Result:=TID(pntr^.ID_Low);

end;


function GetNoteFromList(pntr: PLinkList): string;
begin
Result:= CP1251ToUTF8(AnsiString(PAnsiChar(@pntr^.Note)));
end;



function LinkListToStr(pntr: PLinkList): string;
begin

if pntr^.Types = equFatTypeDir then Result:= GetNoteFromList(pntr)// + ' #' + IntToStr(GetIDFromList(pntr))
else if pntr^.Types = equFatTypeData then Result:= '    Замер #'+IntToStr(pntr^.Numer) + ' ' + GetDateTimeMegaStr(pntr^.DateTime)
else Result:= '??? '+IntToStr(pntr^.Types);

end;




procedure AddItemToList(pntr: PLinkList);
var i: integer;
    pntrParent: PLinkList;
begin
if pntr^.UpLevel <= 0 then begin
    // Parent==0 -> Просто добавить
    FormRosAtomImport.LogText.Items.AddObject(LinkListToStr(pntr), TObject(pntr));
end else begin
    // Найти уже добавленного Parent и добавить к нему
    for i := 0 to FormRosAtomImport.LogText.Items.Count-1 do
        if FormRosAtomImport.LogText.Items.Objects[i] <> nil then begin
           pntrParent:=PLinkList(FormRosAtomImport.LogText.Items.Objects[i]);
           if GetIDFromList(pntrParent) = pntr^.UpLevel then begin
              FormRosAtomImport.LogText.Items.InsertObject(i+1, LinkListToStr(pntr), TObject(pntr));
              Exit;
           end;
        end;
    // Не нашли Parent
    FreeMem(pntr);
end;
end;





function ListReadingFrame(Buf: pointer; BufLen: Longword; FrameNumber: Longint): Longint; stdcall;
var
  pntr: PLinkList;
begin
  result:=ErrorUnknown;

try
    if GetIDFromList(@PFrameList(buf)^.List) = 0 then
       Exit;
(*
    len:=BufLen-
       SizeOf(PFrameList(buf)^.Sign)-
       SizeOf(PFrameList(buf)^.Numer)-
       SizeOf(PFrameList(buf)^.CRC);
*)
    pntr := GetMem(sizeof(TLinkList));
    Move(PFrameList(buf)^.List, pntr^, sizeof(TLinkList));

    if (pntr^.Types = equFatTypeDir) or
       (pntr^.Types = equFatTypeData) then // Только эти типы скачиваем
       AddItemToList(pntr)
    else
        FreeMem(pntr);

    FormRosAtomImport.pbBar.StepIt();

    Application.ProcessMessages;

    result:=LinkResultOk;

except
end;

end;

function ListEndReading(): Longint; stdcall;
begin
     Result:=LinkResultOk;
     FormRosAtomImport.pbBar.Position:=0;

end;


var TmpFilePath: string = '';
    TmpFileHandle: THandle = 0;

// FrameNumber = 1 to Frame.Count
function DataReadingFrame109(Buf: pointer; BufLen: Longword; FrameNumber: Longint): Longint; stdcall;
begin
    result := ErrorUnknown;
    try
        if FrameNumber = 1 then begin
            TmpFilePath := GetTempFileName();
            TmpFileHandle := FileCreate(TmpFilePath);

        end;

        FileWrite(TmpFileHandle, PArrByte(buf)^[SizeOf(TSign) + sizeof(word) + 1], BufLen - SizeOf(TSign) - sizeof(word) - sizeof(TCRC));

        FormRosAtomImport.pbBar.StepIt();

        Application.Processmessages;
        Result := LinkResultOk;
    except
    end;
end;





function TFormRosAtomImport.GetMeasurementsList(): boolean;
var res, i: integer;
begin
  Result := False;

  if Info.Pribor = 0 then
     TestPribor();

  res:= StartReadCommand(cmdReadListZamer,
                    0,0,0,
                    ListFirstFrame, ListReadingFrame, ListEndReading);

  if LogText.Items.Count>0 then begin
     LogText.ItemIndex:=0;
     // Выбрать все
     for i := 0 to LogText.Items.Count-1 do
         LogText.Selected[i] := true;
  end;

  Result := (res = LinkResultOk);
end;






procedure TFormRosAtomImport.ButtonGetListClick(Sender: TObject);
begin
    StopLink := False;
    ClearListObjects();

    GetMeasurementsList();

end;



var OutString: string;





procedure TFormRosAtomImport.ButtonDownloadMeasurementsClick(Sender: TObject);
var WaveMeas: PLinkList;
    i: integer;
    AddSubDir, isMeas: boolean;
begin

StopLink := False;

OutString := ''#9'Уск СКЗ'#9'Скор СКЗ'#9'Пер СКЗ'#9'100 Гц Скор СКЗ'#9'150 Гц Скор СКЗ'#9'200 Гц Скор СКЗ'#9'100 Гц Уск СКЗ'#9'150 Гц Уск СКЗ'#9'200 Гц Уск СКЗ'#13;

AddSubDir := false;
i:=0;
while i<LogText.count do begin
  isMeas :=Pos('Замер #', LogText.Items.Strings[i])>0;

  if isMeas then begin
     if (LogText.selected[i] or AddSubDir) then begin

         WaveMeas:=PLinkList(LogText.Items.Objects[i]);
         if (WaveMeas^.Types = equFatTypeData) then
            AddMeasurementToClipboard(LogText.Items.Strings[i], WaveMeas);
     end;

  end else begin
     AddSubDir := LogText.selected[i]; // весь подкаталог
  end;


  inc(i);
end;

Clipboard.AsText:=OutString;

end;




procedure TFormRosAtomImport.ButtonStopClick(Sender: TObject);
begin
StopLink := True;
end;




procedure TFormRosAtomImport.FormCreate(Sender: TObject);
begin

    FillChar(Info, szTInfoPribor, 0);

    SetDefaultLinkParams(LinkParams);

    if InitPort() <> LinkResultOk then begin
       CreateMessageDialog('No lib_usb', mtError,[mbOk]);
	   Exit;
    end;

end;


procedure TFormRosAtomImport.ClearListObjects();
var i: integer;
    pntr: PLinkList;
begin
for i := 0 to LogText.Items.Count-1 do
    if LogText.Items.Objects[i] <> nil then begin
       pntr:=PLinkList(LogText.Items.Objects[i]);
       Freemem(pntr);
       LogText.Items.Objects[i] := nil;

    end;
LogText.Items.Clear;
end;



procedure TFormRosAtomImport.FormDestroy(Sender: TObject);
begin
StopLink := True;
Application.ProcessMessages;
ClearListObjects();
DonePort();
end;






procedure TFormRosAtomImport.AddMeasurementToClipboard(aTitle: string; pntr: PLinkList);
var res: integer;
begin

res:= StartReadCommand(cmdReadData,
                pntr^.Types, pntr^.ID_Low, pntr^.ID_High,
                ListFirstFrame, DataReadingFrame109, ListEndReading);

if (TmpFileHandle > 0) then begin
   FileClose(TmpFileHandle);
end;

if (res = LinkResultOk) and
   (TmpFileHandle > 0) then begin

   AddFromFile(aTitle, TmpFilePath);

end;

TmpFileHandle := 0;
if TmpFilePath <> '' then begin
   DeleteFile(TmpFilePath);
   TmpFilePath := '';
end;

end;




function TFormRosAtomImport.AddFromFile(aTitle: string; aFilePath: string): boolean;
var res: integer;
    ListBoxData: TListBox;
    Rec: PBufOneRec;
    i: integer;
begin
  Result := False;

if aFilePath = '' then
   Exit;

  ListBoxData := TListBox.Create(nil);


  if (Info.Pribor = prViana2) then begin
     res := DoImportViana2(aFilePath, Info.Pribor, ListBoxData);
  end else
  if (Info.Pribor = prDiana2Rev2) then begin
     res := ImportKorsarM(aFilePath, Info.Pribor, ListBoxData);
  end else
  if (Info.Pribor = prKorsar) then begin
     res := ImportKorsarM(aFilePath, Info.Pribor, ListBoxData);
  end else
  if (Info.Pribor = prViana1) then begin
     res := DoImportViana1(aFilePath, Info.Pribor, ListBoxData);
  end else
  if (Info.Pribor = prViana4) then begin
     res := DoImportViana4(aFilePath, Info.Pribor, ListBoxData);
  end else
  if (Info.Pribor = prDPK) then begin
     res := DoImportDPK(aFilePath, Info.Pribor, ListBoxData);
  end else
  if (Info.Pribor = prVV2) then begin
     res := DoImportVV2(aFilePath, Info.Pribor, ListBoxData);
  end else
      res := 0;

  Result := ListBoxData.Items.Count > 0;

  for i := 0 to ListBoxData.Items.Count-1 do begin
      // В каждом замере м.б. несколько каналов
      Rec := PBufOneRec(ListBoxData.Items.Objects[i]);
      if Rec = nil then
         continue;
      OutString := OutString + aTitle + #9+ GetDataString(Rec)+#13;

      DestroyRec(Rec);
      ListBoxData.Items.Objects[i] := nil;
  end;

  ListBoxData.Destroy;

end;





var re: TReal64ArrayZeroBased;
    Count: integer;

// Вычислить данные и вернуть строку
function TFormRosAtomImport.GetDataString(Rec: PBufOneRec): string;
var i, pos: integer;
    dF: double;

  function HarmIndex(F0, dF: double; aFreq: double): integer;
  begin
       Result:=Round((aFreq - F0) / dF);
  end;


  function GetVal(aEdIzm: integer; aIndex: integer): double;
  var scale: double;
  begin
       Result:= 0.0;
       if Rec^.EdIzm = aEdIzm then Result:=re[aIndex];

       scale := (1000.0 / 2.0 / PI / (aIndex * dF));
       if Rec^.EdIzm = eiAcceleration then begin
          if aEdIzm = eiVelocity then result := re[aIndex] * scale
          else if aEdIzm = eiDisplacement then result := re[aIndex] * scale * scale;
       end else
       if Rec^.EdIzm = eiVelocity then begin
          if aEdIzm = eiAcceleration then result := re[aIndex] / scale
          else if aEdIzm = eiDisplacement then result := re[aIndex] * scale;
       end else
       if Rec^.EdIzm = eiDisplacement then begin
          if aEdIzm = eiAcceleration then result := re[aIndex] / scale / scale
          else if aEdIzm = eiVelocity then result := re[aIndex] / scale;
       end;
  end;




  // СКЗ по спектру от 10 до 1000 Гц
  function GetRMS(aEdIzm: integer): double;
  var index0, indexN, i: integer;
      rms: double;
  begin
       rms:= 0.0;

       index0:=Round(10.0 / dF);
       if index0 < 1 then
          index0 := 1;
       indexN:=Round(1000.0 / dF);
       if indexN >= Count then
          indexN := Count - 1;

       for i:=index0 to indexN do begin
           rms:=rms+sqr(GetVal(aEdIzm, i));
       end;

       Result := sqrt(rms/2.0);

  end;








// OutString := ''#9'Уск СКЗ'#9'Скор СКЗ'#9'Пер СКЗ'#9'100 Гц Скор СКЗ'#9'150 Гц Скор СКЗ'#9'200 Гц Скор СКЗ'#9'100 Гц Уск СКЗ'#9'150 Гц Уск СКЗ'#9'200 Гц Уск СКЗ'#13;
  function MeasString(): string;
  begin

       Result := FloatToStr(GetRMS(eiAcceleration))+#9+
                 FloatToStr(GetRMS(eiVelocity))+#9+
                 FloatToStr(GetRMS(eiDisplacement))+#9;

      pos:=HarmIndex(0.0, dF, 100.0);
      if (pos>0) and (pos<Rec^.AllX) then Result := Result + FloatToStr(GetVal(eiVelocity, pos) * 0.7071067811865475) + #9
      else Result := Result + '' + #9;

      pos:=HarmIndex(0.0, dF, 150.0);
      if (pos>0) and (pos<Rec^.AllX) then Result := Result + FloatToStr(GetVal(eiVelocity, pos) * 0.7071067811865475) + #9
      else Result := Result + '' + #9;

      pos:=HarmIndex(0.0, dF, 200.0);
      if (pos>0) and (pos<Rec^.AllX) then Result := Result + FloatToStr(GetVal(eiVelocity, pos) * 0.7071067811865475) + #9
      else Result := Result + '' + #9;

      pos:=HarmIndex(0.0, dF, 100.0);
      if (pos>0) and (pos<Rec^.AllX) then Result := Result + FloatToStr(GetVal(eiAcceleration, pos) * 0.7071067811865475) + #9
      else Result := Result + '' + #9;

      pos:=HarmIndex(0.0, dF, 150.0);
      if (pos>0) and (pos<Rec^.AllX) then Result := Result + FloatToStr(GetVal(eiAcceleration, pos) * 0.7071067811865475) + #9
      else Result := Result + '' + #9;

      pos:=HarmIndex(0.0, dF, 200.0);
      if (pos>0) and (pos<Rec^.AllX) then Result := Result + FloatToStr(GetVal(eiAcceleration, pos) * 0.7071067811865475) + #9
      else Result := Result + '' + #9;
  end;



begin

Result := '';

if Rec^.Len <= 0 then
   Exit;

if (Rec^.EdIzm <> eiAcceleration) and
   (Rec^.EdIzm <> eiVelocity) and
   (Rec^.EdIzm <> eiDisplacement) then
   Exit;

if Rec^.Tip = ztSignal then begin
   // FFT
   Count:=Rec^.AllX;
   dF := 1.0/(Rec^.dX*Count);
   for i := 1 to Count do begin
       re[i-1]:=Rec^.Vals^[i];
   end;
   RealFFT_WindowHamming(@re, Count);

end else
if Rec^.Tip = ztSpectr then begin

   Count:=Rec^.AllX;
   dF := Rec^.dX;
   for i := 1 to Count do begin
       re[i-1]:=Rec^.Vals^[i];
   end;
end else
    Exit;

Result := Result + MeasString() + #9;

end;





procedure TFormRosAtomImport.RadioButtonUSBChange(Sender: TObject);
var intf: TLinkInterface;
begin

DonePort();
if RadioGroupPort.ItemIndex<>0 then begin
   LinkParams.LinkInterface:= stFile;
   LinkParams.FlashDirName := DirectoryEditPath.Directory;
end else LinkParams.LinkInterface:= stUsbPort;
InitPort();
end;






end.


