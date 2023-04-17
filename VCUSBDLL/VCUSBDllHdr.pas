unit VCUSBDllHdr;

interface
uses Windows;

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

function VCUSBVersion(): DWORD;


function VCUSBInit(): HRESULT;cdecl;
function VCUSBDone(): HRESULT;cdecl;
function VCUSBWrite(pBuffer: pointer; cbBuffer: DWORD; var cbWritten: DWORD; uTimeout: DWORD): HRESULT;cdecl;
function VCUSBRead(pBuffer: pointer; cbBuffer: DWORD; var cbRead: DWORD; uTimeout: DWORD): HRESULT;cdecl;

function VCUSBInit2(pDev: pointer; NumDevice: integer): HRESULT;cdecl;
function VCUSBDone2(pDev: pointer): HRESULT;cdecl;
function VCUSBWrite2(Dev: pointer; pBuffer: pointer; cbBuffer: DWORD; var cbWritten: DWORD; uTimeout: DWORD): HRESULT;cdecl;
function VCUSBRead2(Dev: pointer; pBuffer: pointer; cbBuffer: DWORD; var cbRead: DWORD; uTimeout: DWORD): HRESULT;cdecl;

// Инициализация DLL - всегда вызывать один раз перед началом работы с USB
function InitUsb(): HRESULT;
// Освободить DLL
procedure DoneUsb();


// Оставлено для совместимости со старыми версиями
function  IsLibLoaded() : boolean;


const
  VCUSBDllFile='VCUSBDll.dll';
  LIBUSB0DllFile='libusb0.dll';

implementation
  uses SysUtils, ShlObj;

Type
  TVCUSBVersion = function : DWORD; cdecl;
  TVCUsbInit  = function : HRESULT; cdecl;
  TVCUsbDone  = function : HRESULT; cdecl;
  TVCUsbWrite = function(pBuffer: pointer; cbBuffer: DWORD; var cbWritten: DWORD; uTimeout: DWORD): HRESULT;cdecl;
  TVCUsbRead  = function(pBuffer: pointer; cbBuffer: DWORD; var cbRead: DWORD; uTimeout: DWORD): HRESULT;cdecl;
  TVCUsbInit2  = function (pDev: pointer; NumDevice: integer): HRESULT; cdecl;
  TVCUsbDone2  = function (pDev: pointer): HRESULT; cdecl;
  TVCUsbWrite2 = function(Dev: pointer; pBuffer: pointer; cbBuffer: DWORD; var cbWritten: DWORD; uTimeout: DWORD): HRESULT;cdecl;
  TVCUsbRead2  = function(Dev: pointer; pBuffer: pointer; cbBuffer: DWORD; var cbRead: DWORD; uTimeout: DWORD): HRESULT;cdecl;
Var
  Lib         : THandle  = 0;
  LVCUSBInit  : TFarProc = nil;
  LVCUSBDone  : TFarProc = nil;
  LVCUSBWrite : TFarProc = nil;
  LVCUSBRead  : TFarProc = nil;
  LVCUSBInit2 : TFarProc = nil;
  LVCUSBDone2 : TFarProc = nil;
  LVCUSBWrite2: TFarProc = nil;
  LVCUSBRead2 : TFarProc = nil;
  vVCUSBVersion : DWORD = VCUSB_VERSION_NONE;

//------------------------------------------------------------------------------

function GetSystemDir: string;
var
  Buffer: array[0..1023] of Char;
begin
  SetString(Result, Buffer, GetSystemDirectory(Buffer, SizeOf(Buffer)));
end;





function InitUsb(): HRESULT;
var
//  Name : array[0..255] of Char;
  LVCUSBVersion: TFarProc;
begin
  Result := S_DRIVER_NOT_FOUND;
//  if FileSearch(LIBUSB0DllFile,GetSystemDir())='' then Exit;
  if not FileExists(GetSystemDir+'\'+LIBUSB0DllFile) then Exit;


  DoneUsb;
  Result := S_DLL_NOT_FOUND;
  if not FileExists(VCUSBDllFile) then Exit;
  Result := S_FALSE;
//  StrPCopy(Name,VCUSBDllFile);
//  Lib:=LoadLibrary(Name);
  Lib:=LoadLibrary(VCUSBDllFile);
  if Lib<HINSTANCE_ERROR then Exit;
  LVCUSBInit  := GetProcAddress(Lib,'VCUSBInit');
  if LVCUSBInit=nil then LVCUSBInit  := GetProcAddress(Lib,'_VCUSBInit');
  LVCUSBDone  := GetProcAddress(Lib,'VCUSBDone');
  if LVCUSBDone=nil then LVCUSBDone  := GetProcAddress(Lib,'_VCUSBDone');
  LVCUSBWrite := GetProcAddress(Lib,'VCUSBWrite');
  if LVCUSBWrite=nil then LVCUSBWrite := GetProcAddress(Lib,'_VCUSBWrite');
  LVCUSBRead  := GetProcAddress(Lib,'VCUSBRead');
  if LVCUSBRead=nil then LVCUSBRead  := GetProcAddress(Lib,'_VCUSBRead');
  LVCUSBInit2  := GetProcAddress(Lib,'VCUSBInit2');
  if LVCUSBInit2=nil then LVCUSBInit2  := GetProcAddress(Lib,'_VCUSBInit2');
  LVCUSBDone2  := GetProcAddress(Lib,'VCUSBDone2');
  if LVCUSBDone2=nil then LVCUSBDone2  := GetProcAddress(Lib,'_VCUSBDone2');
  LVCUSBWrite2 := GetProcAddress(Lib,'VCUSBWrite2');
  if LVCUSBWrite2=nil then LVCUSBWrite2 := GetProcAddress(Lib,'_VCUSBWrite2');
  LVCUSBRead2  := GetProcAddress(Lib,'VCUSBRead2');
  if LVCUSBRead2=nil then LVCUSBRead2  := GetProcAddress(Lib,'_VCUSBRead2');

  vVCUSBVersion := VCUSB_VERSION1;
  LVCUSBVersion := GetProcAddress(Lib,'VCUSBVersion');
  if LVCUSBVersion=nil then LVCUSBVersion  := GetProcAddress(Lib,'_VCUSBVersion');
  if LVCUSBVersion<>nil then
     vVCUSBVersion:=TVCUSBVersion(LVCUSBVersion)();

  Result := S_OK;
end;



//------------------------------------------------------------------------------
// Версия драйвера
// 0x100 - Старая версия 2009 года
// 0x200 и дальше - Новая версия, через libusb0.dll
function VCUSBVersion(): DWORD;
begin
Result:=vVCUSBVersion;
end;


//------------------------------------------------------------------------------
procedure DoneUsb();
begin
  if Lib>HINSTANCE_ERROR then
     FreeLibrary(Lib);
  Lib:=0;
  LVCUSBInit  := nil;
  LVCUSBDone  := nil;
  LVCUSBWrite := nil;
  LVCUSBRead  := nil;
  LVCUSBInit2 := nil;
  LVCUSBDone2 := nil;
  LVCUSBWrite2:= nil;
  LVCUSBRead2 := nil;
  vVCUSBVersion := VCUSB_VERSION_NONE;
end;


//------------------------------------------------------------------------------
function IsLibLoaded() : boolean;
begin
Result:=(Lib>HINSTANCE_ERROR);
if Result then
   Exit;
Result:=(InitUsb()=S_OK);
end;


//------------------------------------------------------------------------------
function VCUSBInit(): HRESULT;
begin
  if Assigned(LVCUSBInit) then begin result := TVCUSBInit(LVCUSBInit); end
  else                         begin result := S_FALSE; end;
end;

//------------------------------------------------------------------------------
function VCUSBDone(): HRESULT;
begin
  if Assigned(LVCUSBDone) then begin result := TVCUSBDone(LVCUSBDone); end
  else                         begin result := S_FALSE; end;
end;

//------------------------------------------------------------------------------
function VCUSBWrite(pBuffer: pointer; cbBuffer: DWORD; var cbWritten: DWORD; uTimeout: DWORD): HRESULT;
begin
  if Assigned(LVCUSBWrite) then begin result := TVCUSBWrite(LVCUSBWrite)(pBuffer,cbBuffer,cbWritten,uTimeout); end
  else                          begin result  := S_FALSE; end;
end;

//------------------------------------------------------------------------------
function VCUSBRead(pBuffer: pointer; cbBuffer: DWORD; var cbRead: DWORD; uTimeout: DWORD): HRESULT;
begin
  if Assigned(LVCUSBRead) then begin result := TVCUSBRead(LVCUSBRead)(pBuffer,cbBuffer,cbRead,uTimeout); end
  else                         begin result := S_FALSE; end;
end;

//------------------------------------------------------------------------------
function VCUSBInit2(pDev: pointer; NumDevice: integer): HRESULT;
begin
  if Assigned(LVCUSBInit2) then begin result := TVCUSBInit2(LVCUSBInit2)(pDev,NumDevice); end
  else                          begin result := S_FALSE; end;
end;

//------------------------------------------------------------------------------
function VCUSBDone2(pDev: pointer): HRESULT;
begin
  if Assigned(LVCUSBDone2) then begin result := TVCUSBDone2(LVCUSBDone2)(pDev); end
  else                          begin result := S_FALSE; end;
end;

//------------------------------------------------------------------------------
function VCUSBWrite2(Dev: pointer; pBuffer: pointer; cbBuffer: DWORD; var cbWritten: DWORD; uTimeout: DWORD): HRESULT;
begin
  if Assigned(LVCUSBWrite2) then begin result := TVCUSBWrite2(LVCUSBWrite2)(Dev,pBuffer,cbBuffer,cbWritten,uTimeout); end
  else                           begin result  := S_FALSE; end;
end;

//------------------------------------------------------------------------------
function VCUSBRead2(Dev: pointer; pBuffer: pointer; cbBuffer: DWORD; var cbRead: DWORD; uTimeout: DWORD): HRESULT;
begin
  if Assigned(LVCUSBRead2) then begin result := TVCUSBRead2(LVCUSBRead2)(Dev,pBuffer,cbBuffer,cbRead,uTimeout); end
  else                          begin result := S_FALSE; end;
end;

//------------------------------------------------------------------------------

initialization

finalization
  DoneUsb();
end.

