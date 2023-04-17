unit TestViewForm;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, TAGraph,
  TASeries, LinkTypes
  ;

type

  { TFormViewMeasurement }

  TFormViewMeasurement = class(TForm)
    ChartMeasurement: TChart;
    MeasurementSeries: TLineSeries;
    ListBoxData: TListBox;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ListBoxDataClick(Sender: TObject);
  private

  public
    function ShowFromFile(aDevice: TWord4; aFilePath: string): boolean;
    procedure ClearListObjects();

  end;

var
  FormViewMeasurement: TFormViewMeasurement;

implementation
uses ImportDefs
     , ImportViana2
     , ImportKorsar
     ;

{$R *.lfm}

{ TFormViewMeasurement }


procedure TFormViewMeasurement.FormClose(Sender: TObject;  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;

end;

procedure TFormViewMeasurement.FormDestroy(Sender: TObject);
begin
ClearListObjects();
end;



function TFormViewMeasurement.ShowFromFile(aDevice: TWord4; aFilePath: string): boolean;
var res: integer;
begin
  Result := False;
  if aFilePath = '' then
     Exit;

  ClearListObjects();

  if (aDevice = prViana2) then begin
     res := DoImportViana2(aFilePath, aDevice, ListBoxData);
  end else
  if (aDevice = prDiana2Rev2) then begin
     res := ImportKorsarM(aFilePath, aDevice, ListBoxData);
  end else
      res := 0;


   if  res = 1 then begin
      if ListBoxData.Items.Count >0 then begin
         ListBoxData.ItemIndex:=0;
         ListBoxDataClick(self);
      end;
   end;

end;



procedure TFormViewMeasurement.ClearListObjects();
var i: integer;
begin
for i := 0 to ListBoxData.Items.Count-1 do
    if ListBoxData.Items.Objects[i] <> nil then begin
       DestroyRec(PBufOneRec(ListBoxData.Items.Objects[i]));
       ListBoxData.Items.Objects[i] := nil;
    end;
ListBoxData.Items.Clear;
end;



procedure TFormViewMeasurement.ListBoxDataClick(Sender: TObject);
var Rec: PBufOneRec;
    k: integer;
begin

if ListBoxData.ItemIndex < 0 then
   Exit;

Rec := PBufOneRec(ListBoxData.Items.Objects[ListBoxData.ItemIndex]);

if Rec = nil then
   exit;

MeasurementSeries.Clear;
for k:=1 to Rec^.AllX do begin
    MeasurementSeries.AddXY(Rec^.X0 + Rec^.dX * k, Rec^.Vals^[k]);

end;
end;



end.

