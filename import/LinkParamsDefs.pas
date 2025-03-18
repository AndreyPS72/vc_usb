unit LinkParamsDefs;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
  Classes, SysUtils
  , LinkTypes
  ;


Type

    TLinkInterface = (stComPort, stLptPort, stUsbPort, stEthernetPort, stFile);


    TLinkParameters = record

    LinkInterface: TLinkInterface;

    TypePribor : UnicodeString;     // текущий прибор

    ImportFunc : array [TDeviceID] of TImportLink;
//    Import : TImportLink;
//    Count : integer;

    ComDelay     : Longword;
    RepeatCount  : integer;

    Port         : byte;
(*
    Parity       : TParity;
    StopBits     : TStopbits;
    DataBits     : TDatabits;
    FlowControl  : TFlowControl;
    BaudRate     : TBaudrate;

    LPTDosDriverEnable : boolean;
*)
    ReadBufSize  : integer;
    WriteBufSize : integer;

    IP              : UnicodeString;
    EthernetPort    : integer;
    EthDelay        : Longword;
(*
    LptPort         : integer;
    LptDelay        : Longword;
    LptPortAddres   : Longword;
*)
    FlashDirName	: UnicodeString;	// Директорий для чтения из файла

    NameIni,
    PathTmp 		: UnicodeString;

end;



var LinkParams   : TLinkParameters;

procedure SetDefaultLinkParams(var Params: TLinkParameters);
procedure LoadIniLinkParams(NameIni : UnicodeString; var Params: TLinkParameters);
procedure SaveIniLinkParams(NameIni : UnicodeString; var Params: TLinkParameters);


implementation
uses IniFiles
  , LazFileUtils
  , DEFS
  ;




procedure SetDefaultLinkParams(var Params: TLinkParameters);
begin

FillChar(Params, SizeOf(TLinkParameters),0);

  Params.Port:=1;
(*
  Params.Parity:= paNone;
  Params.StopBits:=sb10;
  Params.DataBits:=da8;
  Params.FlowControl := fcNone;
  Params.BaudRate  := br9600;
*)
  Params.LinkInterface  := stUsbPort;

  Params.ReadBufSize:=9216;
  Params.WriteBufSize:=9216;
(*
  Params.LptPort:=1;
  Params.LptDelay         := 250;
  Params.LptPortAddres    := $378;
*)

  Params.IP      := '192.168.0.1';
  Params.EthernetPort := 21173;
  Params.EthDelay         := 3000;

  Params.ComDelay     := 5000;
  Params.RepeatCount  := 3;

  Params.NameIni  := CreateAbsolutePath(LinkNameIniFile, IniDirName);

  Params.FlashDirName := CreateAbsolutePath('\', ExtractFileDir(ParamStr(0)));

end;




procedure LoadIniLinkParams(NameIni : UnicodeString; var Params: TLinkParameters);
var
  ini : TMemIniFile;
  band : integer;
begin

SetDefaultLinkParams(Params);

if Length(NameIni)=0 then
    NameIni:=Params.NameIni;

ini:=TMemIniFile.Create(NameIni);
try

    Params.NameIni  := NameIni;

    Params.Port:=ini.ReadInteger('Main','ComPort',1);
    if (Params.Port<1) or (Params.Port>5) then Params.Port:=3;
(*
  band:=ini.ReadInteger('Main','BaudRate',0);
  if (band<0)or(band>Length(BaudRateArray)-1) then band:=0;
  Params.BaudRate:=BaudRateByIndex(band);


  Params.LptPort:=ini.ReadInteger('Main','LptPort',1);
  if (Params.LptPort<1)or(Params.LptPort>4) then Params.LptPort:=1;

{$IFDEF NeedImport}
  Params.LPTDosDriverEnable:=ini.ReadBool('Main','LptDosDriver',false) and IsLptDosDriver();
{$ELSE}
  Params.LPTDosDriverEnable:=False;
{$ENDIF}
*)

  Params.LinkInterface:=TLinkInterface(ini.ReadInteger('Main','Status',ord(stUSBPort)));
  if (Params.LinkInterface<>stComPort) and
     (Params.LinkInterface<>stLptPort) and
     (Params.LinkInterface<>stUsbPort) and
     (Params.LinkInterface<>stEthernetPort) and
     (Params.LinkInterface<>stFile) then Params.LinkInterface:=stUSBPort;

  Params.RepeatCount    := ini.ReadInteger('Parameters','RepeatCount',3);
  Params.ComDelay       := 5000;
  Params.IP             := ini.ReadString('Main','IP','192.168.0.1');
  Params.EthernetPort   := ini.ReadInteger('Main','EthernetPort', 21173);

  Params.PathTmp:=CreateAbsolutePath('TEMP', ExtractFileDir(ParamStr(0)));
  Params.FlashDirName := ini.ReadString('Main','FlashDir', ExtractFileDir(ParamStr(0)));


  ini.destroy;

except
end;
end;




procedure SaveIniLinkParams(NameIni : UnicodeString; var Params: TLinkParameters);
var
  ini : TMemIniFile;
begin

if Length(NameIni)=0 then
    NameIni:=Params.NameIni;

ini:=TMemIniFile.Create(NameIni);
try

     ini.WriteInteger('Main','Status',ord(Params.LinkInterface));

     ini.WriteInteger('Main','ComPort',Params.Port);
(*
     ini.WriteInteger('Main','BaudRate',BaudRateIndex(Params.BaudRate));
     ini.WriteInteger('Main','LptPort',Params.LptPort);
     ini.WriteBool   ('Main','LptDosDriver',Params.LPTDosDriverEnable);
*)
     ini.WriteString('Main','IP',Params.IP);
  	 ini.WriteInteger('Main','EthernetPort', Params.EthernetPort);
  	 ini.WriteString('Main','FlashDir',Params.FlashDirName);

     ini.WriteInteger('Parameters','RepeatCount',Params.RepeatCount);

     ini.UpdateFile;
  	 ini.destroy;

except
end;
end;


end.

