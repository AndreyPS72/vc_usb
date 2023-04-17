unit LinkPortClass;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

(*
//todo Для отладки
{$OPTIMIZATION OFF}
{$OPTIMIZATION NOREGVAR}
{$OPTIMIZATION UNCERTAIN}
{$OPTIMIZATION NOSTACKFRAME}
{$OPTIMIZATION NOPEEPHOLE}
{$OPTIMIZATION NOLOOPUNROLL}
{$OPTIMIZATION NOTAILREC}
{$OPTIMIZATION NOORDERFIELDS}
{$OPTIMIZATION NOFASTMATH}
{$OPTIMIZATION NOREMOVEEMPTYPROCS}
{$OPTIMIZATION NOCSE}
{$OPTIMIZATION NODFA}
*)

interface
uses LCLIntf, LCLType
//    , PortIO
//    , CommInt
//    , ScktComp
    , LinkTypes
    , LinkParamsDefs
    ;


type
    TLinkPort = class

    public
        IsOpen: boolean;

    public
        constructor Create(); virtual;
        destructor Destroy; override;

        function OpenPort(var aLinkParams: TLinkParameters): integer; virtual; { инициализация порта }
        procedure ClosePort(); virtual;

        // Послать aSendBuf, затем принять aGetBuf
		function SendGetBuffer(aSendBuf: pointer; aSendBufLen: LongWord;
							  aGetBuf: pointer; aGetBufLen: LongWord): integer; virtual;

        // Послать aCommand, затем принять aGetBuf
		function SendCommandGetBuffer(var aCommand: TCommand;
							  aGetBuf: pointer; aGetBufLen: LongWord): integer; virtual;

    private
        // Очистить приёмный буфер
		procedure FlushRX(); virtual;
        // послать буфер
		function SendBuffer(buf: pointer; Len: LongWord): integer; virtual;
        // принять буфер
        function GetBuffer(buf: pointer; Len: longword): integer; virtual;
        // Пауза между SendBuffer и GetBuffer для медленных интерфейсов
        procedure WaitPause(); virtual;

        procedure SetCommand(aCommand: longword; aID: TID); virtual;

        procedure SetInfoPribor(var Info: TInfoPribor); virtual;

    private
        function WaitIn(Count: Longword): boolean; virtual;
        function WaitOut(Count: Longword): boolean; virtual;

end;

(*
type
    TComLinkPort = class (TLinkPort)

    private
        ComPort: TComm;

    private
        function WaitIn(Count: Longword): boolean; override;
        function WaitOut(Count: Longword): boolean; override;

    public
        function OpenPort(var aLinkParams: TLinkParameters): integer; override;
        procedure ClosePort(); override;

    private
		procedure FlushRX(); override;
		function SendBuffer(buf: pointer; Len: LongWord): integer; override;
        function GetBuffer(buf: pointer; Len: longword): integer; override;
        procedure WaitPause(); override;

end;



type
    TLptLinkPort = class (TLinkPort)

    private
        DLPortIO: TDLPrinterPortIO;

    public
        function OpenPort(var aLinkParams: TLinkParameters): integer; override;
        procedure ClosePort(); override;

        function ReadByte(aAddr: word): Byte;
        procedure WriteByte(aAddr: word; aByte: Byte);

    private
		function SendBuffer(buf: pointer; Len: LongWord): integer; override;
        function GetBuffer(buf: pointer; Len: longword): integer; override;
        procedure WaitPause(); override;

end;
*)


type
    TUsbLinkPort = class (TLinkPort)

    private
    	ProtocolVersion: LongWord;

        function UsbRead(buf: pointer; Len: integer): integer;
        function UsbWrite(buf: pointer; Len: integer): integer;


    public
        constructor Create(); override;
        destructor Destroy; override;

        function OpenPort(var aLinkParams: TLinkParameters): integer; override;
        procedure ClosePort(); override;

		function SendCommandGetBuffer(var aCommand: TCommand;
							  aGetBuf: pointer; aGetBufLen: LongWord): integer; override;

    private
		procedure FlushRX(); override;
		function SendBuffer(buf: pointer; Len: LongWord): integer; override;
        function GetBuffer(buf: pointer; Len: longword): integer; override;

        procedure SetInfoPribor(var Info: TInfoPribor); override;

end;


(*
type
    TEthernetLinkPort = class (TLinkPort)

    private
        ClientSocket: TClientSocket;
        EthernetDelay: Longword;

    public
        function OpenPort(var aLinkParams: TLinkParameters): integer; override;
        procedure ClosePort(); override;

    private
        function WaitIn(Count: Longword): boolean; override;
    private
		procedure FlushRX(); override;
		function SendBuffer(buf: pointer; Len: LongWord): integer; override;
        function GetBuffer(buf: pointer; Len: longword): integer; override;

		procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
end;
*)


type
    TFileLinkPort = class (TLinkPort)

    private
        FlashDirName: UnicodeString;
        FlashFilePos: LongWord;
        FlashFileID: LongWord;
        Command: LongWord;

		FlashFileHandle: Integer;

    private
        procedure CheckFileOpened();


    public
        function OpenPort(var aLinkParams: TLinkParameters): integer; override;
        procedure ClosePort(); override;

		function SendCommandGetBuffer(var aCommand: TCommand;
							  aGetBuf: pointer; aGetBufLen: LongWord): integer; override;
    private
		function SendBuffer(buf: pointer; Len: LongWord): integer; override;
        function GetBuffer(buf: pointer; Len: longword): integer; override;

        procedure SetCommand(aCommand: longword; aID: TID); override;

		function GetFlashFileName(): UnicodeString; virtual;

end;





implementation
uses SysUtils
	, Forms
    , StrUtils
    , LazFileUtils
    , LinkDefs
    , VCUSBHdr
{$IFDEF WINDOWS}
    , WinSock
{$ENDIF}
    , LinkUtil
    ;


{ TLinkPort }

constructor TLinkPort.Create();
begin
inherited Create();

IsOpen:= False;

end;


destructor TLinkPort.Destroy;
begin

IsOpen:= False;

inherited;

end;


function TLinkPort.OpenPort(var aLinkParams: TLinkParameters): integer;
begin
    Result := LinkResultOk;

end;

procedure TLinkPort.ClosePort;
begin

IsOpen:= False;
end;

function TLinkPort.WaitIn(Count: Longword): boolean;
begin
    Result := StopLink;
end;

function TLinkPort.WaitOut(Count: Longword): boolean;
begin
    Result := StopLink;
end;


function TLinkPort.SendBuffer(buf: pointer; Len: LongWord): integer;
begin

    Result := ErrorUnknown;

    if StopLink then
    	Result := ErrorLinkStoping;

end;


function TLinkPort.GetBuffer(buf: pointer; Len: longword): integer;
begin

    Result := ErrorUnknown;
    if StopLink then
    	Result := ErrorLinkStoping;

end;



// Послать aSendBuf, затем принять aGetBuf
function TLinkPort.SendGetBuffer(aSendBuf: pointer; aSendBufLen: LongWord;
							  aGetBuf: pointer; aGetBufLen: LongWord): integer;
begin

	FlushRX();

    Result := SendBuffer(aSendBuf, aSendBufLen);

    if Result <> LinkResultOk then
    	Exit;

    WaitPause();

    Result := GetBuffer(aGetBuf, aGetBufLen);

end;



// Послать aCommand, затем принять aGetBuf
function TLinkPort.SendCommandGetBuffer(var aCommand: TCommand;
							  aGetBuf: pointer; aGetBufLen: LongWord): integer;
begin

Result := SendGetBuffer(@aCommand, szTCommand, aGetBuf, aGetBufLen);

end;



procedure TLinkPort.SetInfoPribor(var Info: TInfoPribor);
begin

end;




procedure TLinkPort.SetCommand(aCommand: longword; aID: TID);
begin

end;


procedure TLinkPort.WaitPause;
begin
end;


procedure TLinkPort.FlushRX();
begin

end;


(*
{ TComLinkPort }

function TComLinkPort.OpenPort(var aLinkParams: TLinkParameters): integer;
begin
    Result := inherited OpenPort(aLinkParams);

    try

    	ComPort := TComm.Create(nil);

        case aLinkParams.Port of
            2: ComPort.DeviceName := 'COM2';
            3: ComPort.DeviceName := 'COM3';
            4: ComPort.DeviceName := 'COM4';
        else ComPort.DeviceName := 'COM1';
        end;

        ComPort.Parity := aLinkParams.Parity;
        ComPort.StopBits := aLinkParams.StopBits;
        ComPort.DataBits := aLinkParams.DataBits;
        ComPort.FlowControl := aLinkParams.FlowControl;
        ComPort.BaudRate := aLinkParams.BaudRate;
        ComPort.ReadBufSize := aLinkParams.ReadBufSize;
        ComPort.WriteBufSize := aLinkParams.WriteBufSize;

        ComPort.Open;
        IsOpen:= true;

    except
    end;

end;



procedure TComLinkPort.ClosePort();
begin

    try
        if (ComPort <> nil) then begin
            ComPort.PurgeIn;
            ComPort.PurgeOut;
            ComPort.Close;
            ComPort.Destroy;
        end;
    except
    end;
    ComPort := nil;

    inherited;
end;



function TComLinkPort.WaitIn(Count: Longword): boolean;
var
    FirstTickCount, Now, MSecs, w: Longword;
begin
    Result := inherited WaitIn(Count);
    if Result then
        Exit;

    try
        if StopLink then Exit;
        FirstTickCount := GetTickCount;
        MSecs := Count * 3 + FirstTickCount + 300;
        DelayWithSleep(10);
        repeat
            DelayWithSleep(1);
            Now := GetTickCount;
            w := ComPort.InQueCount;
            if w >= Count then begin
                Result := True;
                Exit;
            end;
            if StopLink then Exit;
        until (Now >= MSecs) or (Now < FirstTickCount);
    except
    end;

end;


function TComLinkPort.WaitOut(Count: Longword): boolean;
var
    FirstTickCount, Now, MSecs: Longword;
begin
    Result := inherited WaitOut(Count);
    if Result then
        Exit;

    try
        FirstTickCount := GetTickCount;
        MSecs := Count + FirstTickCount + 300;
        DelayWithSleep(10);
        repeat
            DelayWithSleep(1);
            Now := GetTickCount;
            if ComPort.OutQueCount = 0 then begin
                Result := True;
                Exit;
            end;
            if StopLink then Exit;
        until (Now >= MSecs) or (Now < FirstTickCount);
    except
    end;

end;



procedure TComLinkPort.FlushRX();
begin

	inherited FlushRX();

    try
        ComPort.PurgeIn;
        ComPort.PurgeOut;

    except
    end;
end;


function TComLinkPort.SendBuffer(buf: pointer; Len: LongWord): integer;
begin

	Result:=inherited SendBuffer(buf, Len);

    if StopLink then
        Exit;

    try

        ComPort.Write(Buf^, Len);
        WaitOut(Len);

        if StopLink then begin
            result := ErrorLinkStoping;
            Exit;
        end;

        result := LinkResultOk;
    except
    end;

end;





function TComLinkPort.GetBuffer(buf: pointer; Len: longword): integer;
begin

	Result:=inherited GetBuffer(buf, Len);

    if StopLink then
        Exit;

    try

        WaitIn(Len);
        if StopLink then begin
            result := ErrorLinkStoping;
            Exit;
        end;

        ComPort.Read(Buf^, Len);

        if CalcCRC(Buf^, Len - 2) <> ((PArrByte(Buf)^[Len - 1]) + PArrByte(Buf)^[Len] shl 8) then
            result := ErrorCRC
        else
        	result := LinkResultOk;

        ComPort.PurgeIn();
        DelayWithSleep(60);

    except
    end;

end;



procedure TComLinkPort.WaitPause;
begin
  inherited;
  DelayWithSleep(1);
end;

{ TLptLinkPort }

function TLptLinkPort.OpenPort(var aLinkParams: TLinkParameters): integer;
var b: Byte;
begin
    Result := inherited OpenPort(aLinkParams);

    try
        DLPortIO := TDLPrinterPortIO.Create(nil);

        //установить порт
        DLPortIO.LPTNumber := aLinkParams.LptPort;
        //считать адрес
        aLinkParams.LptPortAddres := DLPortIO.LPTBasePort;

        if aLinkParams.LptPortAddres = 0 then begin
            case aLinkParams.LptPort of
                1: aLinkParams.LptPortAddres := $378;
                2: aLinkParams.LptPortAddres := $278;
            end;
        end;
        // Open the DriverLINX driver
        DLPortIO.OpenDriver();

        if DLPortIO.ActiveHW and
        	(aLinkParams.LptPortAddres <> 0) then begin
            b := PortReadByte(aLinkParams.LptPortAddres + $402);
            b := (b and $0F) or (3 shl 4);
            PortWriteByte(aLinkParams.LptPortAddres + $402, b);
            IsOpen := True;
            result := LinkResultOk;
        end else begin
            case aLinkParams.LptPortAddres of
                0: result := ErrorInitPort;
            else
                result := ErrorInitDriverLPT;
            end;
        end;

    except
    end;

end;



procedure TLptLinkPort.ClosePort;
begin

        try
            if DLPortIO <> nil then begin
                DLPortIO.CloseDriver();
                DLPortIO.Destroy;
            end;
        except
        end;
        DLPortIO := nil;

  	inherited;
end;





function TLptLinkPort.SendBuffer(buf: pointer; Len: LongWord): integer;
begin

	Result:=inherited SendBuffer(buf, Len);

    if StopLink then
        Exit;

    try

        if not LPTWriteBlock(Buf^, Len) then
        	Exit;

        result := LinkResultOk;
    except
    end;

end;

function TLptLinkPort.GetBuffer(buf: pointer; Len: longword): integer;
begin

	Result:=inherited GetBuffer(buf, Len);

    if StopLink then
        Exit;

    try

        if not LPTReadBlock(buf^, Len) then begin
            if StopLink then
            	result := ErrorLinkStoping;
            Exit;
        end;

        if CalcCRC(Buf^, Len - 2) <> ((PArrByte(Buf)^[Len - 1]) + PArrByte(Buf)^[Len] shl 8) then
            result := ErrorCRC
        else
        	result := LinkResultOk;

    except
    end;

end;

function TLptLinkPort.ReadByte(aAddr: word): Byte;
begin
	if (DLPortIO <> nil) and
    	IsOpen and
        (not StopLink) then begin
            Result:= DLPortIO.Port[aAddr];
    end
    else
    	Result:= 0;
end;

procedure TLptLinkPort.WriteByte(aAddr: word; aByte: Byte);
begin
	if (DLPortIO <> nil) and
    	IsOpen and
        (not StopLink) then begin
            DLPortIO.Port[aAddr] := aByte;
    end
end;


procedure TLptLinkPort.WaitPause;
begin
  inherited;
  DelayWithSleep(1);
end;
*)



{ TUsbLinkPort }


constructor TUsbLinkPort.Create();
begin
    inherited;

    InitUSB();

    ProtocolVersion := 0;

end;


destructor TUsbLinkPort.Destroy;
begin

  DoneUSB();

  inherited;

end;


function TUsbLinkPort.OpenPort(var aLinkParams: TLinkParameters): integer;
begin
    Result := inherited OpenPort(aLinkParams);

    try

        if VCUSBInit() = S_OK then begin
        	Result := LinkResultOk;
            IsOpen:= true;
        end else begin
            result := ErrorInitDriverUSB;
        end;
    except
    end;

end;


procedure TUsbLinkPort.ClosePort();
begin

	try
    	if IsOpen then begin
			VCUSBDone();
    		DelayWithSleep(1);
        end;

    except
    end;

    inherited;

end;


function TUsbLinkPort.UsbRead(buf: pointer; Len: integer): integer;
var
    buf_tmp: array[1..64] of byte;
    cbCount: DWORD;
begin
    result := ErrorUnknown;

    if (ProtocolVersion = 201) or (ProtocolVersion = 202) then begin
        if VCUSBRead(Buf, Len, cbCount, DEFAULT_TIMEOUT) <> S_OK then
        	Exit;

    end else begin

        if (len div 64) > 0 then begin
            if VCUSBRead(Buf, (Len div 64) * 64, cbCount, DEFAULT_TIMEOUT) <> S_OK then
            	Exit;
            if StopLink then begin
            	result := ErrorLinkStoping;
                exit;
            end;
        end;
        FillChar(buf_tmp, 64, 0);
        if VCUSBRead(@buf_tmp, 64, cbCount, DEFAULT_TIMEOUT) <> S_OK then begin
            if (ProtocolVersion = 0) then begin
                // Может это новый прибор (>2.00) с невыровненным ответом ?
                if VCUSBRead(Buf, Len, cbCount, DEFAULT_TIMEOUT) <> S_OK then
                    Exit;
            end
            else Exit;
        end else
            move(buf_tmp, PArrByte(Buf)^[(Len div 64) * 64 + 1], len mod 64);
    end;

    result := LinkResultOk;
end;



function TUsbLinkPort.UsbWrite(buf: pointer; Len: integer): integer;
var
    buf_tmp: array[1..64] of byte;
    cbCount: DWORD;
begin
    result := ErrorUnknown;

    if (ProtocolVersion = 201) or (ProtocolVersion = 202) then begin
        if VCUSBWrite(Buf, Len, cbCount, DEFAULT_TIMEOUT) <> S_OK then begin
        	Exit;
        end;
    end else begin
        if (len div 64) > 0 then begin
            if VCUSBWrite(Buf, (Len div 64) * 64, cbCount, DEFAULT_TIMEOUT) <> S_OK then begin
            	Exit;
            end;
            if StopLink then begin
            	result := ErrorLinkStoping;
                exit;
            end;
        end;
        FillChar(buf_tmp, 64, 0);
        move(PArrByte(Buf)^[(Len div 64) * 64 + 1], buf_tmp, len mod 64);
        if VCUSBWrite(@buf_tmp, 64, cbCount, DEFAULT_TIMEOUT) <> S_OK then begin
        	Exit;
        end;

    end;

    Result := LinkResultOk;
end;




procedure TUsbLinkPort.FlushRX();
var Buf: array [1..64] of byte;
	cbCount: DWORD;
begin
	inherited FlushRX();

    if VCUSBVersion() < VCUSB_VERSION222 then
    	Exit;

	try

        while VCUSBRead(@Buf, 64, cbCount, 1) = S_OK do begin
        	Application.ProcessMessages();
    		if StopLink then
        		Exit;
        end;

        while VCUSBRead(@Buf, 1, cbCount, 1) = S_OK do begin
        	Application.ProcessMessages();
    		if StopLink then
        		Exit;
        end;

    except
    end;

end;





function TUsbLinkPort.SendBuffer(buf: pointer; Len: LongWord): integer;
begin

	Result:=inherited SendBuffer(buf, Len);

    if StopLink then
        Exit;

    try

        Result := UsbWrite(Buf, Len);

    except
    end;

end;

function TUsbLinkPort.GetBuffer(buf: pointer; Len: longword): integer;
begin

	Result:=inherited GetBuffer(buf, Len);

    if StopLink then
        Exit;

    try

        if UsbRead(Buf, Len) <> LinkResultOk then begin
            if StopLink then
            	result := ErrorLinkStoping
            else
            	result := ErrorDeviceNotResponded;
            exit;
        end;

        if CalcCRC(Buf^, Len - 2) <> ((PArrByte(Buf)^[Len - 1]) + PArrByte(Buf)^[Len] shl 8) then
            result := ErrorCRC
        else
        	result := LinkResultOk;

    except
    end;

end;

procedure TUsbLinkPort.SetInfoPribor(var Info: TInfoPribor);
begin
  inherited;

  ProtocolVersion:= Info.Protokol;
end;



function TUsbLinkPort.SendCommandGetBuffer(var aCommand: TCommand;
  aGetBuf: pointer; aGetBufLen: LongWord): integer;
begin

Result := inherited SendCommandGetBuffer(aCommand, aGetBuf, aGetBufLen);

if Result = LinkResultOk then begin
    if aCommand.Command = cmdTestPribor then
        SetInfoPribor(PInfoPribor(aGetBuf)^);

end;

end;



(*
//function IsUserAnAdmin():boolean; external 'shell32' name 'IsUserAnAdmin';


{ TEthernetLinkPort }


procedure TEthernetLinkPort.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
ErrorCode:=0;

end;



function TEthernetLinkPort.OpenPort(var aLinkParams: TLinkParameters): integer;
var opt: ULONG;
begin
    Result := inherited OpenPort(aLinkParams);

	EthernetDelay := aLinkParams.EthDelay;

    Result := ErrorInitPort;
    try
        if (ClientSocket = nil) then begin
            ClientSocket := TClientSocket.Create(nil);
            ClientSocket.OnError := ClientSocketError;
        end else
            ClientSocket.Active := False;

        ClientSocket.Address := aLinkParams.IP;
        ClientSocket.Port := aLinkParams.EthernetPort; // 21173
        try

            ClientSocket.Active := True;

			opt := 1;
			setsockopt(ClientSocket.Socket.SocketHandle, IPPROTO_TCP, TCP_NODELAY, @opt, sizeof(opt));

			opt := 1;
			setsockopt(ClientSocket.Socket.SocketHandle, SOL_SOCKET, SO_REUSEADDR, @opt, sizeof(opt));

            DelayWithSleep(1);

            IsOpen:= true;
            result := LinkResultOk;
        except
        end;
    except
    end;

end;




procedure TEthernetLinkPort.ClosePort;
begin

        try
            if (ClientSocket <> nil) then begin
                ClientSocket.Active := False;
                DelayWithSleep(1);
                ClientSocket.Destroy;
            end;
        except
        end;
        ClientSocket := nil;

  inherited;

end;


var tmpbufflush: array[0..1024 - 1] of byte;

procedure TEthernetLinkPort.FlushRX();
var lenrx: integer;
begin

    if StopLink then
    	Exit;

    Application.ProcessMessages();
    lenrx := ClientSocket.Socket.ReceiveLength;
    while lenrx > 0 do begin
        if lenrx > sizeof(tmpbufflush) then
            lenrx := sizeof(tmpbufflush);
        ClientSocket.Socket.ReceiveBuf(tmpbufflush, lenrx);
        lenrx := ClientSocket.Socket.ReceiveLength;
        Application.ProcessMessages();
        if StopLink then begin
            Exit;
        end;
    end;
end;


function TEthernetLinkPort.SendBuffer(buf: pointer;
  Len: LongWord): integer;
begin

	Result:=inherited SendBuffer(buf, Len);

    if StopLink then
        Exit;

    try
        ClientSocket.Socket.SendBuf(Buf^, Len);

        result := LinkResultOk;
    except
    end;

end;



function TEthernetLinkPort.GetBuffer(buf: pointer; Len: longword): integer;
begin

	Result:=inherited GetBuffer(buf, Len);

    if StopLink then
        Exit;

    try

        WaitIn(Len);
        if StopLink then begin
            result := ErrorLinkStoping;
            Exit;
        end;

        if ClientSocket.Socket.ReceiveBuf(buf^, Len) < Integer(Len) then begin
            if StopLink then
            	result := ErrorLinkStoping;
            Exit;
        end;


        if CalcCRC(Buf^, Len - 2) <> ((PArrByte(Buf)^[Len - 1]) + PArrByte(Buf)^[Len] shl 8) then
            result := ErrorCRC
        else
        	result := LinkResultOk;

    except
    end;

end;




function TEthernetLinkPort.WaitIn(Count: Longword): boolean;
var
    First, Now: Longword;
begin
    Result := inherited WaitIn(Count);
    if Result then
        Exit;

	try
        First := GetTickCount;
        Now := First;
    	Application.ProcessMessages();
        while (ClientSocket.Socket.ReceiveLength < Integer(Count)) and
            (Now<(First + EthernetDelay)) and
            (First <= Now) do begin
            if StopLink then begin
                Exit;
            end;
            DelayWithSleep(1);
            Now := GetTickCount;
        end;

        if ClientSocket.Socket.ReceiveLength >= Integer(Count) then begin
        	Result := True;
        end;
    except
    end;

end;
*)







{ TFileLinkPort }

function TFileLinkPort.OpenPort(var aLinkParams: TLinkParameters): integer;
begin

    if IsOpen then
    	ClosePort();

    Result := inherited OpenPort(aLinkParams);

    FlashDirName:= aLinkParams.FlashDirName;
    FlashFilePos:= 0;
    FlashFileID:= 0;
    FlashFileHandle := -1;
    Command:= 0;

end;


procedure TFileLinkPort.ClosePort;
begin                                       

        try
            if (FlashFileHandle > 0) then begin
            	FileClose(FlashFileHandle);
            end;
        except
        end;
        FlashFileHandle := -1;

  inherited;

end;



function TFileLinkPort.GetFlashFileName(): UnicodeString;
begin
if FlashFileID=$FFFFFFFF then Result:= CreateAbsolutePath('info.bin', FlashDirName)
	else Result:= CreateAbsolutePath(IntToStr(FlashFileID)+'.bin', FlashDirName);
end;



procedure TFileLinkPort.CheckFileOpened;
var FlashFileName: UnicodeString;
begin

if FlashFileHandle > 0 then
	Exit;

FlashFileName := GetFlashFileName();

FlashFileHandle := FileOpen(FlashFileName, fmOpenRead or fmShareDenyNone);

FlashFilePos:= 0;

end;




function TFileLinkPort.GetBuffer(buf: pointer; Len: longword): integer;
begin

	Result:=inherited GetBuffer(buf, Len);

    if StopLink then
        Exit;

    try

    	CheckFileOpened();

        FlashFilePos:=FileSeek(FlashFileHandle, FlashFilePos, 0);

        if FileRead(FlashFileHandle, buf^, Len) < Integer(Len) then begin
            if StopLink then
            	result := ErrorLinkStoping;
            Exit;
        end;
        FlashFilePos := FlashFilePos + Len;


        if CalcCRC(Buf^, Len - 2) <> ((PArrByte(Buf)^[Len - 1]) + PArrByte(Buf)^[Len] shl 8) then
            result := ErrorCRC
        else
        	result := LinkResultOk;

    except
    end;

end;


function TFileLinkPort.SendBuffer(buf: pointer; Len: LongWord): integer;
begin

	result := LinkResultOk;

    // только чтение из файла
(*
	Result:=inherited SendBuffer(buf, Len);

    if StopLink then
        Exit;

    try

    	CheckFileOpened();

        FlashFilePos:=FileSeek(FlashFileHandle, FlashFilePos, 0);
        FileWrite(FlashFileHandle, Buf^, Len);
        FlashFilePos := FlashFilePos + Len;

        result := LinkResultOk;
    except
    end;
*)
end;



procedure TFileLinkPort.SetCommand(aCommand: longword; aID: TID);
begin
  inherited;

  if (Command <> aCommand) or
  	 (FlashFileID<>aID) then begin
        try
            if (FlashFileHandle > 0) then begin
            	FileClose(FlashFileHandle);
            end;
        except
        end;
        FlashFileHandle := -1;

        Command := aCommand;
        FlashFileID := aID;
  end;

  if Command = cmdTestPribor then
		FlashFileID := $FFFFFFFF;

end;


// Послать aCommand, затем принять aGetBuf
function TFileLinkPort.SendCommandGetBuffer(var aCommand: TCommand;
							  aGetBuf: pointer; aGetBufLen: LongWord): integer;
begin

if aCommand.Command = cmdReadData then begin
    if (aCommand.Param1dop<>$FF)   then SetCommand(cmdReadData, (TID(aCommand.Param1dop) SHL 16) OR TID(aCommand.Param2))
                        else SetCommand(cmdReadData, TID(aCommand.Param2));
end
    else SetCommand(aCommand.Command, 0);

Result := inherited SendCommandGetBuffer(aCommand, aGetBuf, aGetBufLen);

end;


end.


