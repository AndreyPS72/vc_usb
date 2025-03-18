{$R-}
(*

    Файл импорта для приборов Корсар7 и Диана2М Rev2
    Последние исправление: 19.06.2009

*)
unit ImportKorsar;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
  LCLIntf, LCLType
  , StdCtrls
  , ImportDefs
  , LinkTypes
  ;

(*
const
htDataCommon      = 1;
htDataVibration   = 2;
htDataVibrometer  = 3;
htDataElectrical  = 4;


type
PHdr =^THdr;
THdr = record
  ID  : TInt4;             //Идентификатор замера
  Num : TInt4;            //Номер замера
  DateTime : TInt4;       //Время и дата проведения замера
  Option  : TInt4;         //Флажки замера
  Table : TInt4;          //число таблиц данных в приборе
  Next : TInt4;           //смещение первой таблицы
  CRC : TCRC;            //CRC заголовка
end;

THdrTable = record
  Types : TInt2;           //тип данных
  Reserv : TInt2;         //не используется
  Offset : TInt4;         //смещение данных таблицы
  Next : Tint4;           //смещение следующей таблицы
  CRC : TCRC;            //CRC
end;

TTableVibration = record
    Tip : TInt2;              // Тип замера ztXXXXX
    EdIzm : TInt2;            // Размерность информации eiXXXX
    AllX : TInt4;             // Число отсчетов
    X0 : double;               // Нач. значение, мс или Гц
    dX : double;               // Шаг, мс или Гц
    XN : double;               // Кон. значение, мс или Гц
    SKZ : double;              // СКЗ
    Freq : double;             // Частота первой гармоники или частота отметчика фазы
    Phase : double;            // Фазовая погрешность
    A1 : array[1..5]of double;            // Амплитуда первых 5-и гармоник или 0
    F1 : array[1..5]of double;            // Фаза первых 5-и гармоник
    ScaleA : double;           // Множитель приведения Double = Integer * Scale
    ScaleB : double;           // Смещение
    StampType : TInt4;        // Тип записи отсчетов - пока только stLin
    OffT : TInt4;             // Смещение данных таблицы в файле в файле
    LenT : TInt4;             // Длина даных таблицы в файле - может быть равна 0
    Option : TInt4;           // Флажки опций замера
    ch0 : byte;              // номер канала данных (исключительно для прибора)
    ch1 : byte;              // не используется
    ch2 : byte;              // не используется
    ch3 : byte;              // не используется
    Reserv : array[1..4]of TInt4;        // не используется
    CRC : TCRC;
end;

//данные по грузам для балансировки (максимум 8-ми плоскостная балансировка)
TBalansData = record
    Mass : array[1..8]of single;
    Faza : array[1..8]of single;
end;

TZamerData = record
    TypeReg  : TInt2;                // Тип регистрации
    EdIzm    : TInt2;                // основные единицы измерения (перекрывается значением из таблицы канала)
    Launch   : TInt2;                // запуск регистрации (по отметчику, свободный, ...)
    Averages : TInt2;                // число усреднений
    Point    : TInt4;                // основное число точек в замере (перекрывается значением из таблицы канала)
    Freq     : double;               // Частота регистрации
    FHP      : double;               // фильтр высоких частот
    FLP      : double;               // фильтр низких частот
    Option   : TInt4;                // Флажки опций замера
    Balans   : TBalansData;          // Для балансировки
    Comment  : array[1..40]of byte;  // Примечание
    Reserv   : array[1..10]of TInt4; // не используется
    CRC      : TCRC;
end;
*)

function ImportKorsarM(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;
function TransPointDiana2MRev2(f:integer; Hdr:THdr; Table:THdrTable; offset:TInt4): PBufOneRec;


implementation
uses SysUtils
    , DEFS
    , LinkUtil
    , NEWDateTime
    , Zamhdr
{$IFDEF NeedImport}
    , DefDB
    , StrConst
    , LinkLang
{$ENDIF}
    ;


Type
  PArrBuf   = ^TArrBuf;
  TArrBuf   = array [1..20000000] of smallint;

function TransPointDiana2MRev2(f:integer; Hdr:THdr; Table:THdrTable; offset:TInt4):PBufOneRec;
var
  k : integer;
  flag: Boolean;
  Rec : PBufOneRec;
  TableVibration : TTableVibration;
  buf : PArrBuf;
  DT : TDateTime;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;

begin
    Rec:=nil;
    if Table.Types=htDataVibration then
    begin
      FileSeek(f,Table.Offset+offset,0);
      FileRead(f,TableVibration,sizeof(TableVibration));
      flag:=CheckCRC(TableVibration,SizeOf(TableVibration),TableVibration.CRC);
      FileSeek(f,TableVibration.OffT+offset,0);

      buf:=GetMem(TableVibration.LenT);

      FileRead(f,buf^,TableVibration.LenT);
      CreateRec(Rec);
      Rec.Tip:=TableVibration.Tip;

      case TableVibration.EdIzm of
          4: begin Rec.EdIzm := eiAcceleration; end;// Ускорение, м/с2
          2: begin Rec.EdIzm := eiVelocity;     end;// Скорость, мм/с
          1: begin Rec.EdIzm := eiDisplacement; end;// Перемещение, мкм
         16: begin Rec.EdIzm := eiVolt; Rec.IsStamper:=True; end;// Вольты, В
         32: begin Rec.EdIzm := eiAmper; end;// Амперы, А
       1024: begin Rec.EdIzm := eiForce; end;// ньютоны
      end;

      DT:=UnpackDateTimeToDT(Hdr.DateTime);
      DecodeDate(DT,Year, Month, Day);
      DecodeTime(DT,Hour, Min, Sec, MSec);

      Rec.ZDate[0]:=Day;
      Rec.ZDate[1]:=Month;
      Rec.ZDate[2]:=(Year mod 100)+2000;
      Rec.ZTime[0]:=Hour;
      Rec.ZTime[1]:=Min;
      Rec.ZTime[2]:=Sec;
      Rec.Option:=0;

      Rec.AllX:=TableVibration.AllX;
      if Rec.Tip=ztSignal then Rec.dX:=TableVibration.dX/1000
                          else Rec.dX:=TableVibration.dX;

      Rec.X0:=0;
      Rec.XN:=Rec.AllX*Rec.dX-Rec.dX;

      Rec.Option:=Rec.Option or opSynhro;

      Rec.Ampl:=0;
      Rec.Faza:=0;

      AllocRec(Rec);
      Rec.Ampl:=1e-3;

      if (TableVibration.ScaleA=0) then
         TableVibration.ScaleA:=1.0;
      for k:=1 to Rec.AllX do  begin
           Rec.Vals^[k]:=buf^[k]*TableVibration.ScaleA;
           if abs(Rec.Vals^[k])>Rec.Ampl then Rec.Ampl:=abs(Rec.Vals^[k]);
      end;
      FreeMem(buf);
    end;

result:=Rec;
end;



const Str8521 ='Отметчик №%3.3d в %s от %s';
      Str8523 ='Канал %1.1d  №%3.3d в %s от %s';



function ImportKorsarM(FileName: UnicodeString; aDevice: Longint; SrcList: TListBox): Longint; stdcall;
var
  f,i,next,k : integer;
  Rec, Rec2: PBufOneRec;
  Hdr : THdr;
  Table : THdrTable;
  TableVibration,TableVibration2,TableVibration3 : TTableVibration;
  ZamerData : TZamerData;

  //buf,
  buf2,buf3 : array[1..16*1024] of smallint;

  buf : PArrBuf;

  DT : TDateTime;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;

  flag: boolean;

begin
  result:=0;
  if not Assigned(SrcList) then Exit;

  f:=FileOpen(FileName,fmOpenRead);

  FileRead(f,Hdr,SizeOf(Hdr));
  flag:=CheckCRC(Hdr,SizeOf(Hdr),Hdr.CRC);

  if Hdr.Table=0 then
  begin
    FileClose(f);
    DeleteFile(FileName);
    Exit;
  end;

  next:=Hdr.Next;
  for i:=1 to Hdr.Table do
  begin
    FileSeek(f,next,0);
    FileRead(f,Table,SizeOf(Table));
    flag:=CheckCRC(Table,SizeOf(Table),Table.CRC);
    next:=Table.Next;
    if Table.Types=htDataCommon then
    begin
      FileSeek(f,Table.Offset,0);
      FileRead(f,ZamerData,sizeof(ZamerData));
      flag:=CheckCRC(ZamerData,SizeOf(ZamerData),ZamerData.CRC);
    end else
    if Table.Types=htDataVibration then
    begin
      FileSeek(f,Table.Offset,0);
      FileRead(f,TableVibration,sizeof(TableVibration));
      flag:=CheckCRC(TableVibration,SizeOf(TableVibration),TableVibration.CRC);

      FileSeek(f,TableVibration.OffT,0);

      buf:=GetMem(TableVibration.LenT);

      FileRead(f,buf^,TableVibration.LenT);
      CreateRec(Rec);
      Rec.Tip:=TableVibration.Tip;

      case TableVibration.EdIzm of
        4: begin Rec.EdIzm :=eiAcceleration; end;// Ускорение, м/с2
        2: begin Rec.EdIzm :=eiVelocity;     end;// Скорость, мм/с
        1: begin Rec.EdIzm :=eiDisplacement; end;// Перемещение, мкм
       16: begin Rec.EdIzm :=eiVolt; Rec.IsStamper:=True;  end;// Вольты, В
       32: begin Rec.EdIzm :=eiAmper; end;// Амперы, А
       1024: begin Rec.EdIzm :=eiForce; end;// ньютоны
      end;

      DT:=UnpackDateTimeToDT(Hdr.DateTime);
      DecodeDate(DT,Year, Month, Day);
      DecodeTime(DT,Hour, Min, Sec, MSec);

      Rec.ZDate[0]:=Day;
      Rec.ZDate[1]:=Month;
      Rec.ZDate[2]:=(Year mod 100)+2000;
      Rec.ZTime[0]:=Hour;
      Rec.ZTime[1]:=Min;
      Rec.ZTime[2]:=Sec;
      Rec.Option:=0;

      Rec.AllX:=TableVibration.AllX;
      if Rec.Tip=ztSignal then Rec.dX:=TableVibration.dX/1000
                          else Rec.dX:=TableVibration.dX;

      Rec.X0:=0;
      Rec.XN:=Rec.AllX*Rec.dX-Rec.dX;

      Rec.Option:=Rec.Option or opSynhro;

      Rec.Ampl:=0;
      Rec.Faza:=0;

      AllocRec(Rec);
      Rec.Ampl:=1e-3;

      if (TableVibration.ScaleA=0) then
         TableVibration.ScaleA:=1.0;
      for k:=1 to Rec.AllX do begin
           Rec.Vals^[k]:=buf^[k]*TableVibration.ScaleA;
           if abs(Rec.Vals^[k])>Rec.Ampl then Rec.Ampl:=abs(Rec.Vals^[k]);
      end;

{$IFDEF NeedImport}
      if (Rec.IsStamper) then SrcList.Items.AddObject((DelphinStr17)+IntToStr(Hdr.Num)+' '+LinkProtokolMarker+' ['+GetShortNameByTip(Rec.Tip)+', '+GetNameByEdIzm(Rec.EdIzm)+']',TObject(rec))
        else SrcList.Items.AddObject((DelphinStr17)+IntToStr(Hdr.Num)+
             (DelphinStr18)+' '+IntToStr(TableVibration.ch1)+
             ' ['+GetShortNameByTip(Rec.Tip)+', '+GetNameByEdIzm(Rec.EdIzm)+']',TObject(Rec));

{$ELSE}
          if (Rec^.IsStamper) then SrcList.Items.AddObject(Format(Str8521,[Hdr.Num,TimeToStr(DT),DateToStr(DT)]),TObject(Rec))
                              else SrcList.Items.AddObject(Format(Str8523,[i,Hdr.Num,TimeToStr(DT),DateToStr(DT)]),TObject(Rec));
{$ENDIF}


      FreeMem(buf);

    end
{$IFDEF NeedImport}
    else
    if Table.Types=htDataElectrical then
    begin
      FileSeek(f,Table.Offset,0);
      FileRead(f,TableVibration,sizeof(TableVibration));
      FileSeek(f,TableVibration.OffT,0);

      buf:=GetMem(TableVibration.LenT);

      FileRead(f,buf^,TableVibration.LenT);
      CreateRec(Rec);
      DT:=UnpackDateTimeToDT(Hdr.DateTime);
      DecodeDate(DT,Year, Month, Day);
      DecodeTime(DT,Hour, Min, Sec, MSec);
      Rec.ZDate[0]:=Day;
      Rec.ZDate[1]:=Month;
      Rec.ZDate[2]:=(Year mod 100)+2000;
      Rec.ZTime[0]:=Hour;
      Rec.ZTime[1]:=Min;
      Rec.ZTime[2]:=Sec;
      Rec.X0:=0;
      Rec.Option:=0;
      Rec.Option:=Rec.Option or opSynhro;
      Rec.Ampl:=0;
      Rec.Faza:=0;
      Rec.Tip:=ztSignal;
      case TableVibration.EdIzm of
          4: begin Rec.EdIzm :=eiAcceleration; end;// Ускорение, м/с2
          2: begin Rec.EdIzm :=eiVelocity;     end;// Скорость, мм/с
          1: begin Rec.EdIzm :=eiDisplacement; end;// Перемещение, мкм
         16: begin Rec.EdIzm :=eiVolt; Rec.IsStamper:=True;  end;// Вольты, В
         32: begin Rec.EdIzm :=eiAmper; end;// Амперы, В
        512: begin Rec.EdIzm :=eiVT; end;// ватты
      end;
      Rec.AllX:=TableVibration.AllX;
      Rec.dX:=TableVibration.dX/1000;
      Rec.XN:=Rec.AllX*Rec.dX-Rec.dX;
      AllocRec(Rec);
      Rec.Ampl:=1e-3;

      if (TableVibration.ScaleA=0) then
         TableVibration.ScaleA:=1.0;
      for k:=1 to Rec.AllX do begin
           Rec.Vals^[k]:=buf^[k]*TableVibration.ScaleA;
           if abs(Rec.Vals^[k])>Rec.Ampl then Rec.Ampl:=abs(Rec.Vals^[k]);
      end;
      
      if TableVibration.Tip=512 then // если замер с МПТ
      begin
        //считываем данные по каналу датчика поля
        FileSeek(f,next,0);
        FileRead(f,Table,SizeOf(Table));
        next:=Table.Next;
        FileSeek(f,Table.Offset,0);
        FileRead(f,TableVibration2,sizeof(TableVibration2));
        FileSeek(f,TableVibration2.OffT,0);
        FileRead(f,buf2,TableVibration2.LenT);
        //считываем данные по отметкам
        FileSeek(f,next,0);
        FileRead(f,Table,SizeOf(Table));
        FileSeek(f,Table.Offset,0);
        FileRead(f,TableVibration3,sizeof(TableVibration3));
        FileSeek(f,TableVibration3.OffT,0);
        FileRead(f,buf3,TableVibration3.LenT);
        Rec.Tip:=ztSignal;
        Rec.AllX:=TableVibration3.AllX;
        if Rec.AllX>0 then
        begin
          AllocRec(Rec);
          for k:=1 to Rec.AllX do
          begin
            Rec.Vals^[k]:=buf3[k];
          end;
        end;
        SrcList.Items.AddObject((DelphinStr17)+IntToStr(Hdr.Num)+' ['+GetShortNameByTip(Rec.Tip)+', '+GetNameByEdIzm(Rec.EdIzm)+']',TObject(Rec));

        CreateRec(Rec);
        DT:=UnpackDateTimeToDT(Hdr.DateTime);
        DecodeDate(DT,Year, Month, Day);
        DecodeTime(DT,Hour, Min, Sec, MSec);
        Rec.ZDate[0]:=Day;
        Rec.ZDate[1]:=Month;
        Rec.ZDate[2]:=(Year mod 100)+2000;
        Rec.ZTime[0]:=Hour;
        Rec.ZTime[1]:=Min;
        Rec.ZTime[2]:=Sec;

        Rec.X0:=0;
        Rec.Option:=0;
        Rec.Option:=Rec.Option or opSynhro;
        Rec.Ampl:=0;
        Rec.Faza:=0;
        case TableVibration2.EdIzm of
            4: begin Rec.EdIzm :=eiAcceleration; end;// Ускорение, м/с2
            2: begin Rec.EdIzm :=eiVelocity;     end;// Скорость, мм/с
            1: begin Rec.EdIzm :=eiDisplacement; end;// Перемещение, мкм
           16: begin Rec.EdIzm :=eiVolt; end;// Вольты, В
           32: begin Rec.EdIzm :=eiAmper; end;// Амперы, В
          512: begin Rec.EdIzm :=eiVT; end;// ватты
        end;
        Rec.AllX:=TableVibration2.AllX;
        Rec.dX:=TableVibration2.dX/1000;
        Rec.XN:=Rec.AllX*Rec.dX-Rec.dX;
        AllocRec(Rec);
        Rec.Ampl:=1e-3;
        for k:=1 to Rec.AllX do
        begin
          Rec.Vals^[k]:=buf^[k]*TableVibration2.ScaleA;
          if abs(Rec.Vals^[k])>Rec.Ampl then Rec.Ampl:=abs(Rec.Vals^[k]);
        end;
        Rec.Tip:=ztSignal;
        Rec.AllX:=TableVibration3.AllX;
        if Rec.AllX>0 then begin
          Rec.IsStamper:=True;
          AllocRec(Rec);
          for k:=1 to Rec.AllX do
          begin
            Rec.Vals^[k]:=buf3[k];
          end;
        end;
        SrcList.Items.AddObject((DelphinStr17)+IntToStr(Hdr.Num)+' ['+GetShortNameByTip(Rec.Tip)+', '+GetNameByEdIzm(Rec.EdIzm)+']',TObject(Rec));
        break; // выходим из цикла раскладки
      end else
      if TableVibration.Tip=1024 then // если замер с ваттметрграммой
      begin
        CreateRec(Rec2);
        Rec2^:=Rec^;
        Rec2.Tip:=ztSignal;
        //считываем данные по отметкам
        FileSeek(f,next,0);
        FileRead(f,Table,SizeOf(Table));
        next:=Table.Next;
        FileSeek(f,Table.Offset,0);
        FileRead(f,TableVibration2,sizeof(TableVibration2));
        FileSeek(f,TableVibration2.OffT,0);
        FileRead(f,buf2,TableVibration2.LenT);
        Rec2.IsStamper:=True;
        Rec2.EdIzm:=eiVolt;
        if TableVibration2.AllX>0 then  begin
          AllocRec(Rec2);
          for k:=1 to TableVibration2.AllX do begin
            Rec2.Vals^[buf2[k]]:=MaxIntStamp;
          end;
          Rec2.Ampl:=1.0;
          SrcList.Items.AddObject((DelphinStr17)+IntToStr(Hdr.Num)+' ['+GetShortNameByTip(Rec2.Tip)+', '+GetNameByEdIzm(Rec2.EdIzm)+']',TObject(Rec2));
        end else
          FreeRec(Rec2);

      end;
      SrcList.Items.AddObject((DelphinStr17)+IntToStr(Hdr.Num)+' ['+GetShortNameByTip(Rec.Tip)+', '+GetNameByEdIzm(Rec.EdIzm)+']',TObject(Rec));
      FreeMem(buf);
    end;
{$ENDIF}
  end;
  FileClose(f);
  DeleteFile(FileName);
  result:=1;
end;

end.

