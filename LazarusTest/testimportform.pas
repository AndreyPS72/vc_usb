unit TestImportForm;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls
  , LinkTypes
  , ImportAuroraDefs
  ;

type

  { TFormTestImport }

  TFormTestImport = class(TForm)
    ButtonGetList1: TButton;
    ButtonStop: TButton;
    ButtonViewMeasurement: TButton;
    ButtonClose: TButton;
    ButtonDeviceInfo: TButton;
    ButtonGetList: TButton;
    LogText: TListBox;
    pbBar: TProgressBar;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonDeviceInfoClick(Sender: TObject);
    procedure ButtonGetList1Click(Sender: TObject);
    procedure ButtonGetListClick(Sender: TObject);
    procedure ButtonViewMeasurementClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ClearListObjects();

    procedure ShowDeviceInfo();

    function TestPribor(): boolean;
    function GetMeasurementsList(): boolean;
    function GetRMSMeasurementsList(): boolean;
    function ShowMeasurementGraph(aDevice: TWord4; pntr: PLinkList): boolean;
    function ShowMeasurementRMS(aDevice: TWord4; pntr: PKorsarFrameWrite): boolean;

  public

  end;

var
  FormTestImport: TFormTestImport;

implementation
uses LinkParamsDefs
     , LinkTestPort
     , LConvEncoding
     , TestViewForm
     , TestViewRMSForm
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

{ TFormTestImport }

procedure TFormTestImport.ButtonCloseClick(Sender: TObject);
begin
  Close();
end;



procedure TFormTestImport.ShowDeviceInfo();
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






function TFormTestImport.TestPribor(): boolean;
begin

  Result := (SendCommandRepeat(cmdTestPribor, 0, 0, 0, 0, @Info, szTInfoPriborFull) = LinkResultOk);

end;



procedure TFormTestImport.ButtonDeviceInfoClick(Sender: TObject);
var res: boolean;
begin

  StopLink := False;
  ClearListObjects();

  res := TestPribor();

  if res then
     ShowDeviceInfo();

end;



procedure TFormTestImport.ButtonGetList1Click(Sender: TObject);
begin
StopLink := False;
ClearListObjects();

GetRMSMeasurementsList();

end;




function ListFirstFrame(Frame:TLinkFrame):Longint; stdcall;
begin
    result:=ErrorUnknown;
try
    begin
        FormTestImport.pbBar.Min:=0;
        FormTestImport.pbBar.Max:=Frame.Count;
        FormTestImport.pbBar.Position:=0;
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
else if pntr^.Types = equFatTypeData then Result:= '    Measurement #'+IntToStr(pntr^.Numer) + ' ' + GetDateTimeMegaStr(pntr^.DateTime)
else Result:= '??? '+IntToStr(pntr^.Types);

end;




procedure AddItemToList(pntr: PLinkList);
var i: integer;
    pntrParent: PLinkList;
begin
if pntr^.UpLevel <= 0 then begin
    // Parent==0 -> Просто добавить
    FormTestImport.LogText.Items.AddObject(LinkListToStr(pntr), TObject(pntr));
end else begin
    // Найти уже добавленного Parent и добавить к нему
    for i := 0 to FormTestImport.LogText.Items.Count-1 do
        if FormTestImport.LogText.Items.Objects[i] <> nil then begin
           pntrParent:=PLinkList(FormTestImport.LogText.Items.Objects[i]);
           if GetIDFromList(pntrParent) = pntr^.UpLevel then begin
              FormTestImport.LogText.Items.InsertObject(i+1, LinkListToStr(pntr), TObject(pntr));
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

    FormTestImport.pbBar.StepIt();

    Application.ProcessMessages;

    result:=LinkResultOk;

except
end;

end;

function ListEndReading(): Longint; stdcall;
begin
     Result:=LinkResultOk;
     FormTestImport.pbBar.Position:=0;

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

        FormTestImport.pbBar.StepIt();

        Application.Processmessages;
        Result := LinkResultOk;
    except
    end;
end;





function TFormTestImport.GetMeasurementsList(): boolean;
var res: integer;
begin
  Result := False;

  if Info.Pribor = 0 then
     TestPribor();

  res:= StartReadCommand(cmdReadListZamer,
                    0,0,0,
                    ListFirstFrame, ListReadingFrame, ListEndReading);

  Result := (res = LinkResultOk);
end;





function TFormTestImport.GetRMSMeasurementsList(): boolean;
var res: integer;
    num: integer;
    Frame: TKorsarFrameWrite;
    DT: TDateTime;
    pntr: pointer;
begin
  Result := False;

  if Info.Pribor = 0 then
     TestPribor();

  num:=1; // Перебираем номера замеров
  while num<=999 do begin
      res := SendCommandRepeat(cmdReadRMS, num, 0, 0, 0, @Frame, szTKorsarFrameWrite);
      if res <> LinkResultOk then
          break;
      if Frame.result<>1 then
         break;

      DT:=EncodeDate(Frame.Year+2000, Frame.Month, Frame.Day) + EncodeTime(Frame.Hour, Frame.Min, Frame.Sec,0);
      pntr := GetMem(szTKorsarFrameWrite);
      Move(Frame, pntr^, szTKorsarFrameWrite);
      LogText.Items.AddObject('    RMS #'+IntToStr(num)+ ' ' + DateTimeToStr(DT), pntr);

      inc(num);
  end;

  Result := LogText.Items.Count > 0;
end;




function TFormTestImport.ShowMeasurementGraph(aDevice: TWord4; pntr: PLinkList): boolean;
var res: integer;
begin

     Result := False;

     if Info.Pribor = 0 then
        TestPribor();

     res:= StartReadCommand(cmdReadData,
                     pntr^.Types, pntr^.ID_Low, pntr^.ID_High,
                     ListFirstFrame, DataReadingFrame109, ListEndReading);

     if (TmpFileHandle > 0) then begin
        FileClose(TmpFileHandle);
     end;

     if (res = LinkResultOk) and
        (TmpFileHandle > 0) then begin
        FormViewMeasurement.ShowFromFile(aDevice, TmpFilePath);
        FormViewMeasurement.Show();
     end;

     TmpFileHandle := 0;
     if TmpFilePath <> '' then begin
        DeleteFile(TmpFilePath);
        TmpFilePath := '';
     end;
     Result := (res = LinkResultOk);
end;




function TFormTestImport.ShowMeasurementRMS(aDevice: TWord4; pntr: PKorsarFrameWrite): boolean;
begin

     Result := False;
     if aDevice <> prKorsar then
        Exit;

     FormViewRMS.ShowRMS(aDevice, pntr);
     FormViewRMS.Show();

end;



procedure TFormTestImport.ButtonGetListClick(Sender: TObject);
begin
    StopLink := False;
    ClearListObjects();

    GetMeasurementsList();

end;

procedure TFormTestImport.ButtonViewMeasurementClick(Sender: TObject);
var WaveMeas: PLinkList;
    RMSMeas: PKorsarFrameWrite;
begin
if FormTestImport.LogText.ItemIndex < 0 then
   Exit;

StopLink := False;

if Pos('RMS', LogText.Items.Strings[FormTestImport.LogText.ItemIndex])>0 then begin
   // Просмотр замера СКЗ для ПО Аврора
   RMSMeas:=PKorsarFrameWrite(LogText.Items.Objects[FormTestImport.LogText.ItemIndex]);
   ShowMeasurementRMS(Info.Pribor, RMSMeas);

end else
    if Pos('Measurement', LogText.Items.Strings[FormTestImport.LogText.ItemIndex])>0 then begin
        // Просмотр сигнала/спектра для ПО Атлант
        WaveMeas:=PLinkList(LogText.Items.Objects[FormTestImport.LogText.ItemIndex]);
        if (WaveMeas^.Types = equFatTypeData) then
           ShowMeasurementGraph(Info.Pribor, WaveMeas);
    end;
end;

procedure TFormTestImport.ButtonStopClick(Sender: TObject);
begin
StopLink := True;
end;




procedure TFormTestImport.FormCreate(Sender: TObject);
begin

    FillChar(Info, szTInfoPribor, 0);

    SetDefaultLinkParams(LinkParams);

    if InitPort() <> LinkResultOk then begin
       CreateMessageDialog('No lib_usb', mtError,[mbOk]);
	   Exit;
    end;

end;


procedure TFormTestImport.ClearListObjects();
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



procedure TFormTestImport.FormDestroy(Sender: TObject);
begin
StopLink := True;
Application.ProcessMessages;
ClearListObjects();
DonePort();
end;



end.

