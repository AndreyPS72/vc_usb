unit TestImportForm;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls
  , LinkTypes
  ;

type

  { TFormTestImport }

  TFormTestImport = class(TForm)
    ButtonStop: TButton;
    ButtonGetMeasurement: TButton;
    ButtonClose: TButton;
    ButtonDeviceInfo: TButton;
    ButtonGetList: TButton;
    LogText: TListBox;
    pbBar: TProgressBar;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonDeviceInfoClick(Sender: TObject);
    procedure ButtonGetListClick(Sender: TObject);
    procedure ButtonGetMeasurementClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ClearListObjects();

    procedure ShowDeviceInfo();

    function TestPribor(): boolean;
    function GetMeasurementsList(): boolean;
    function ShowMeasurementGraph(aDevice: TWord4; pntr: PLinkList): boolean;

  public

  end;

var
  FormTestImport: TFormTestImport;

implementation
uses LinkParamsDefs
     , LinkTestPort
     , LConvEncoding
     , TestViewForm
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
    else if (Info.Pribor = prVV2) then LogText.Items.Add(Format(PriborName, ['Vibro Vision-2']));

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
     DT := EncodeDate(aDT.tm_year, aDT.tm_month, aDT.tm_day) +
           EncodeTime(aDT.tm_hh, aDT.tm_mm, aDT.tm_sec, 0);

     Result:=DateToStr(DT)+' '+TimeToStr(DT);

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



procedure TFormTestImport.ButtonGetListClick(Sender: TObject);
begin
    StopLink := False;
    ClearListObjects();

    GetMeasurementsList();

end;

procedure TFormTestImport.ButtonGetMeasurementClick(Sender: TObject);
var pntr: PLinkList;
begin
if FormTestImport.LogText.ItemIndex < 0 then
   Exit;

StopLink := False;

pntr:=PLinkList(LogText.Items.Objects[FormTestImport.LogText.ItemIndex]);
if (pntr^.Types = equFatTypeData) then
   ShowMeasurementGraph(Info.Pribor, pntr);
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

