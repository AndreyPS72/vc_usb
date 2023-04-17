// Прослойка на Lazarus к lib_usb.sys
unit VCUSBHdr;

{$MODE DelphiUnicode}
{$CODEPAGE UTF8}
{$H+}

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


interface

const S_OK =0;
      S_FALSE =1;
      S_DLL_NOT_FOUND =2;
      S_DRIVER_NOT_FOUND =3;

const DEFAULT_TIMEOUT = 500;  // Milliseconds


// Версия драйвера VCUSBVersion()
const VCUSB_VERSION_NONE = 0; 	// 0 - Нет VCUSBDLL.DLL - не смог определить

      VCUSB_VERSION1 = $100; 	// 0x100 - Старая версия 2009 года
      VCUSB_VERSION2 = $200; 	// 0x200 - Новая версия, через libusb0.dll и libusb-win32
      VCUSB_VERSION210 = $210;	// 0x210 - Новая версия, через libusb.sys
      VCUSB_VERSION222 = $222;	// 0x222 - Новая версия, через libusb.sys v1.0.22 2018-08-24
      VCUSB_VERSION223 = $223;	// 0x223 - Новая версия, через libusb.sys v1.0.23 2019-08-28

      VCUSB_VERSION230 = $230;	// 0x230 - без прослойки vcusbdll.dll

function VCUSBVersion(): DWORD;

function VCUSBInit(): HRESULT;
function VCUSBDone(): HRESULT;
function VCUSBWrite(pBuffer: pointer; cbBuffer: DWORD; var cbWritten: DWORD; uTimeout: DWORD): HRESULT;
function VCUSBRead(pBuffer: pointer; cbBuffer: DWORD; var cbRead: DWORD; uTimeout: DWORD): HRESULT;



// Инициализация - всегда вызывать один раз перед началом работы с USB
function InitUsb(): HRESULT;
// Освободить
procedure DoneUsb();

// Оставлено для совместимости со старыми версиями
function  IsLibLoaded() : boolean;


implementation
uses LCLType
     , SysUtils
//     , LazFileUtils
     , LibUsbDyn, LibUsbOop
     ;



var vVCUSBVersion: DWORD;


function InitUsb(): HRESULT;
var v: Plibusb_version;
begin
  Result := S_FALSE;
  vVCUSBVersion := VCUSB_VERSION_NONE;

  // Init USB library
  if USBLib_Init()=false then begin
  //   if USBLib_Init(ctGetRuntimesCPUOSDir(true)+cnlibusbFile)=false then begin
        Result := S_DRIVER_NOT_FOUND;
        Exit;
  end;

  v := TLibUsbContext.GetVersion();
  if (v^.major >= 1) then begin
     vVCUSBVersion := VCUSB_VERSION230;//(v^.major shl 16) or v^.minor;

     Result := S_OK;
  end;
end;



procedure DoneUsb();
begin
USBLib_Free();
end;



function IsLibLoaded() : boolean;
begin
Result:=true;
end;


// Версия драйвера
function VCUSBVersion(): DWORD;
begin
Result:=vVCUSBVersion;
end;








// DEVICE SETUP (User configurable)

const
     // Device vendor and product id.
     VC_USB_VID       = $0441; // vendor ID
     VC_USB_PID       = $51C9; // Product ID

     // Device endpoint(s)
     EP_IN     = $81;
     EP_OUT    = $02;

//     EP_IN_USA 0x86
//     EP_OUT_USA 0x05



// Внутренний буфер
      BUF_SIZE  = 512;


var
  PacketSize : Longword; // 64 для  USB 1.1; 512 для USB 2.0
  PacketSizeMask : Longword; // 63 для  USB 1.1; 511 для USB 2.0

  ReadBufCount : integer;
  ReadBuf : array [0..BUF_SIZE-1] of byte;
//  WriteBufCount : integer;
  WriteBuf : array [0..BUF_SIZE-1] of byte;

  fContext    : TLibUsbContext;
  fDevice     : TLibUsbDevice;
  fInterface : TLibUsbInterface;
  fEPIn       : TLibUsbBulkInEndpoint;
  fEPOut      : TLibUsbBulkOutEndpoint;



function VCUSBInit(): HRESULT;
begin

Result := S_FALSE;

try

  // create context
  fContext := nil;
  fDevice := nil;
  fInterface := nil;
  fEPIn := nil;
  fEPOut := nil;
  fContext := TLibUsbContext.Create();
  if (fContext = nil) then
     Exit;
  fDevice := TLibUsbDevice.Create(fContext, VC_USB_VID, VC_USB_PID);
  if (fDevice = nil) then
     Exit;

  PacketSize := 64;
  if (fContext.GetDeviceDescriptor(fDevice.Device).bcdUSB >= $0200) then
     PacketSize := 512;
  PacketSizeMask := PacketSize - 1;

  fInterface       := TLibUsbInterface.Create(fDevice, fDevice.FindInterface);
  fEPIn            := TLibUsbBulkInEndpoint. Create(fInterface, fInterface.FindEndpoint(EP_IN));
  fEPOut           := TLibUsbBulkOutEndpoint.Create(fInterface, fInterface.FindEndpoint(EP_OUT));

  ReadBufCount := 0;
//  WriteBufCount := 0;

  Result := S_OK;

except
  VCUSBDone();
End;

end;



function VCUSBDone(): HRESULT;
begin

Result := S_FALSE;
try
  FreeAndNil(fEPOut);
  FreeAndNil(fEPIn);
  FreeAndNil(fInterface);
  FreeAndNil(fDevice);
  FreeAndNil(fContext);
  Result := S_OK;
except
end;

end;




function VCUSBWrite(pBuffer: pointer; cbBuffer: DWORD; var cbWritten: DWORD; uTimeout: DWORD): HRESULT;
var
  actual_length: integer;

begin

Result := S_FALSE;
try

  if (fDevice = nil) then begin
    Exit;
  end;
(*
  cbWritten := 0;

  if ((cbBuffer and PacketSizeMask) > 0) and
  	(cbBuffer <= PacketSize) then begin
   // Добить до кратного bUSB->PacketSize размера
  	if (cbBuffer > BUF_SIZE) then
  		cbBuffer := BUF_SIZE;
  	Move(pBuffer^, WriteBuf, cbBuffer);
    actual_length := cbBuffer;

  	if (cbBuffer and PacketSizeMask) > 0 then begin
  		actual_length := (cbBuffer and not PacketSizeMask) + PacketSize;
        FillChar(WriteBuf[cbBuffer], actual_length - cbBuffer, 0);
  	end;

    cbWritten := fEPOut.Send(WriteBuf, actual_length, uTimeout);
  end else
*)
  begin

    // Длинный пакет нельзя выровнять
    cbWritten := fEPOut.Send(pBuffer^, cbBuffer, uTimeout);
  end;

  if (cbWritten <= 0) then
     Exit;

  Result := S_OK;
except
end;

end;


function VCUSBRead(pBuffer: pointer; cbBuffer: DWORD; var cbRead: DWORD; uTimeout: DWORD): HRESULT;
var
   Transfered, Remaining, actual_length, len : integer;

begin

Result := S_FALSE;
cbRead := 0;

try

  if (fDevice = nil) then begin
    Exit;
  end;


  actual_length := fEPIn.Recv(PByteArray(pBuffer)^, cbBuffer, uTimeout);
  if (actual_length > 0) then begin
		cbRead := actual_length;
		Result := S_OK;
  end;

(*
  cbRead := 0;

  Transfered := 0;
  Remaining := cbBuffer;
  len := Remaining;


  if (cbBuffer > PacketSize) then begin
  	// Длинный пакет - не влазит -> не выравниваем, программа сама должна позаботиться о выравнивании на 64/512

  	len := ReadBufCount;
  	if (len > 0) then begin
  		// Если есть данные в буфере - скопировать их
        Move(ReadBuf, pBuffer, len);
  		ReadBufCount := 0;
  		dec(Remaining, len);
  		Transfered := len;
  	end;

    actual_length := fEPIn.Recv(PByteArray(pBuffer)^[Transfered], Remaining , uTimeout);
  	if (actual_length > 0) then begin
  		cbRead := Transfered + actual_length;
  		Result := S_OK;
        Exit;
  	end else
  		Exit;
  end;

  // Короткий пакет - буферизируем и выравниваем
  if (ReadBufCount > 0) then begin

  	// Если есть данные в буфере - скопировать их
  	if (len > ReadBufCount) then
  		len := ReadBufCount;
    Move(ReadBuf, pBuffer, len);
  	inc(Transfered, len);
  	dec(Remaining, len);
  	if (ReadBufCount = len) then begin
  		ReadBufCount := 0;
  	end else begin
  		dec(ReadBufCount, len);
        Move(PByteArray(pBuffer)^[len], ReadBuf, ReadBufCount);
  	end;
  end;

  while (Remaining > 0) do begin

  	// Остальное дочитать
  	len := Remaining;
  	// Читаем за раз не больше BUF_SIZE и выровненный на bUSB->PacketSize
  	if (len > BUF_SIZE) then
  		len := BUF_SIZE;
  	if (len < PacketSize) then
  		len := PacketSize;
  	if (len and PacketSizeMask)>0 then begin

  		len := ((len div PacketSize) + 1) * PacketSize;
  	end;
  	if (len <= Remaining) then begin
  		// Читаем в вых буфер
        actual_length := fEPIn.Recv(PByteArray(pBuffer)^[Transfered], len, uTimeout);

  		if (actual_length <= 0) then
  			Exit;
  		inc(Transfered, actual_length);
  		dec(Remaining, actual_length);

  	end else begin
  		// Читаем во временный буфер

        actual_length := fEPIn.Recv(ReadBuf, len, uTimeout);
		if (actual_length <= 0) then
			Exit;
        if (actual_length >= Remaining) then begin
  		    if (Remaining > cbBuffer - Transfered) then
  			    Remaining := cbBuffer - Transfered;
            Move(ReadBuf, PByteArray(pBuffer)^[Transfered], Remaining);
  		    inc(Transfered, Remaining);

  		    len := actual_length - Remaining;
  		    if (len > 0) then begin
                Move(ReadBuf[Remaining], ReadBuf[ReadBufCount], len);
  		    end;
            Remaining := 0;
        end;

    end;
  end;

  Result := S_OK;
*)
except
end;

end;






initialization
    fEPOut:= nil;
    fEPIn:= nil;
    fInterface:= nil;
    fDevice:= nil;
    fContext:= nil;

end.

