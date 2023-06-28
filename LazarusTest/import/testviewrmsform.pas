unit TestViewRMSForm;

{$mode DelphiUnicode}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, Buttons, LinkTypes, ImportAuroraDefs
  ;

type

  { TFormViewRMS }

  TFormViewRMS = class(TForm)
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    RadioGroupUnits: TRadioGroup;
    RadioGroupView: TRadioGroup;
    StringGridRMS: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure RadioGroupUnitsClick(Sender: TObject);
  private
         RMS: TKorsarFrameWrite;

  public
    function ShowRMS(aDevice: TWord4; pntr: pointer): boolean;

  end;

var
  FormViewRMS: TFormViewRMS;

implementation

{$R *.lfm}

{ TFormViewRMS }

procedure TFormViewRMS.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:=caHide;

end;



function TFormViewRMS.ShowRMS(aDevice: TWord4; pntr: pointer): boolean;
begin
  Result:=False;
  if pntr = nil then
     Exit;

  Move(pntr^, RMS, szTKorsarFrameWrite);
  RadioGroupUnitsClick(Self);

end;


procedure TFormViewRMS.RadioGroupUnitsClick(Sender: TObject);
var i, row, col: integer;
    v: single;

function GetVal: string;
begin
  Result := '';
  if RMS.Data.Point[i].Exist=0 then
     Exit;

  v := 0;
  if RadioGroupView.ItemIndex=3 then begin
     v := RMS.Data.Point[i].EXC;
  end else begin

    case RadioGroupUnits.ItemIndex of
    0: // Acc
       case RadioGroupView.ItemIndex of
       0: v := RMS.Data.Point[i].PIK[1];
       1: v := RMS.Data.Point[i].RMS[1];
       2: v := RMS.Data.Point[i].PtP[1];
       end;

    1: // Vel
       case RadioGroupView.ItemIndex of
       0: v := RMS.Data.Point[i].PIK[2];
       1: v := RMS.Data.Point[i].RMS[2];
       2: v := RMS.Data.Point[i].PtP[2];
       end;

    2: // Disp
       case RadioGroupView.ItemIndex of
       0: v := RMS.Data.Point[i].PIK[3];
       1: v := RMS.Data.Point[i].RMS[3];
       2: v := RMS.Data.Point[i].PtP[3];
       end;

    end;
  end;

    Result:=Format('%6.1f', [v]);

end;

begin
  StringGridRMS.RowCount:=4;
  StringGridRMS.ColCount:=15;
  for i:=1 to 14 do begin
    StringGridRMS.Cells[i,0]:=IntToStr(i);
  end;
  StringGridRMS.Cells[0,1]:='Верт';
  StringGridRMS.Cells[0,2]:='Поп';
  StringGridRMS.Cells[0,3]:='Осев';

  for i:=1 to 42 do begin
    row:=((i-1) mod 3) + 1;
    col:=((i-1) div 3) + 1;

    StringGridRMS.Cells[col,row] := GetVal();
  end;

end;


end.

