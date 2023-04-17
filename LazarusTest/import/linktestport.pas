unit LinkTestPort;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

uses
  Classes, SysUtils
  , LinkTypes
  ;



function InitPort(): integer; { инициализация порта }
procedure PortClose();
procedure FillCommand(aCommand: byte;
	aParam1, aParam2: TWord2;
    aParam1dop, aParam2dop: TWord2;
    var Command: TCommand);
function SendCommandRepeat(
	aCommand: byte;
    aParam1, aParam2: TWord2;
    aParam1dop, aParam2dop: TWord2;
	buf: pointer; Len: integer
    ): integer;
function StartReadCommand(
	Command: byte;
    Param1, Param2, Param1dop, Param2dop: TWord4;
    FirstFrameCallback: TFirstFrameCallback;
    ReadingFrameCallback: TReadingFrameCallback;
    EndReadingCallback: TEndReadingCallback): integer;


procedure DelayWithSleep(MSecs: Longword);
function CalcCRC(var Buf;Len:longint):word;
function CheckCRC(var Buf; Len : TInt2; var aCRC : TCRC): boolean;


var StopLink: boolean = False;



implementation
uses Forms
     , LinkParamsDefs
     , LinkPortClass
     ;


var
   LinkPort: TLinkPort = nil;





function InitPort(): integer; { инициализация порта }
begin

    Result := ErrorInitPort;

    if LinkParams.LinkInterface = stUsbPort then begin

    	if (LinkPort<>nil) and
        	not (LinkPort is TUsbLinkPort) then begin
            PortClose();
        end;

    	if LinkPort=nil then
        	LinkPort := TUsbLinkPort.Create();

        Result := LinkPort.OpenPort(LinkParams);

    end
(*
    else
    if LinkParams.LinkInterface = stEthernetPort then begin

    	if (LinkPort<>nil) and
        	not (LinkPort is TEthernetLinkPort) then
        	FreeAndNil(LinkPort);

    	if LinkPort=nil then
        	LinkPort := TEthernetLinkPort.Create();

        Result := LinkPort.OpenPort(LinkParams);

    end
*)
    else
    if LinkParams.LinkInterface = stFile then begin

    	if (LinkPort<>nil) and
        	not (LinkPort is TFileLinkPort) then
        	FreeAndNil(LinkPort);

    	if LinkPort=nil then
        	LinkPort := TFileLinkPort.Create();

        Result := LinkPort.OpenPort(LinkParams);

    end;

end;


procedure PortClose();
begin

	if (LinkPort<>nil) then
		LinkPort.ClosePort();
    FreeAndNil(LinkPort);

end;




function CalcCRC(var Buf;Len:longint):word;
var
   i:longint;
   CRC:word;
   Dop:byte;
begin
  CRC:=$AAAA;
  for i:=1 to Len do begin
    Dop:=0;
    if (CRC and $8000)<>0 then Dop:=1;
    CRC:=((CRC and $7FFF) shl 1)+Dop;
    CRC:=CRC xor TArrByte(Buf)[i];
  end;
  Result:=CRC;
end;

function CheckCRC(var Buf; Len : TInt2; var aCRC : TCRC): boolean;
var
   CRC : TCRC;
begin
CRC:=aCRC;
aCRC:=0;
Result:= CRC=CalcCRC(Buf,Len);
aCRC:=CRC;
end;



procedure FillCommand(aCommand: byte;
	aParam1, aParam2: TWord2;
    aParam1dop, aParam2dop: TWord2;
    var Command: TCommand);
begin
    Command.Sign := Sign;
    Command.Command := aCommand;
    Command.Param1 := aParam1;
    Command.Param2 := aParam2;
    Command.Param1dop := aParam1dop;
    Command.Param2dop := aParam2dop;
    Command.CRC := CalcCRC(Command, szTCommand - 2);
end;



procedure DelayWithSleep(MSecs: Longword);
var
  FirstTickCount, Now: Longword;
begin

if MSecs<=1 then begin
    Application.ProcessMessages;
    Sleep(1);
    Exit;
end;

FirstTickCount := GetTickCount64() AND $FFFFFFFF;
repeat
    Application.ProcessMessages;
    { allowing access to other controls, etc. }
    Sleep(1);
    Now := GetTickCount64() AND $FFFFFFFF;
until (Now - FirstTickCount >= MSecs);

end;



function SendCommandRepeat(
	aCommand: byte;
    aParam1, aParam2: TWord2;
    aParam1dop, aParam2dop: TWord2;
	buf: pointer; Len: integer
    ): integer;
var
    RepeatNum: integer;
    Command: TCommand;
begin
    //послать команду прибору и получить ответ

    result := ErrorUnknown;

    if (LinkPort = nil) then
    	Exit;

    FillCommand(aCommand, aParam1, aParam2, aParam1dop, aParam2dop, Command);

    RepeatNum := 0;
    repeat
        if StopLink then begin
            result := ErrorLinkStoping;
            Exit;
        end;
        FillChar(Buf^, Len, 0);

    	Result := LinkPort.SendCommandGetBuffer(Command, Buf, Len);

        if Result <> LinkResultOk then begin

        	inc(RepeatNum);
        	if (RepeatNum >= LinkParams.RepeatCount) then begin
            	result := ErrorDataRead;
            	Exit;
        	end;
            DelayWithSleep(10); //todo
        end;
        Application.ProcessMessages();

    until Result = LinkResultOk;
end;



var tmpbuf: array[1..64 * 1024] of Byte;

function StartReadCommand(
	Command: byte;
    Param1, Param2, Param1dop, Param2dop: TWord4;
    FirstFrameCallback: TFirstFrameCallback;
    ReadingFrameCallback: TReadingFrameCallback;
    EndReadingCallback: TEndReadingCallback): integer;
var Frame: TLinkFrame;
    i: integer;
begin
    result := ErrorUnknown;

    try

        //послать команду прибору и получить ответ
        result := SendCommandRepeat(Command,
            Param1, Param2, Param1dop, Param2dop,
            @Frame, SizeOf(Frame));
        if result <> LinkResultOk then begin
            abort;
        end;

        if (not Assigned(FirstFrameCallback)) or
            (FirstFrameCallback(Frame) = LinkResultOk) then begin
            //считать все фреймы с прибора

            for i := 1 to Frame.Count do begin
                result := SendCommandRepeat(Command,
                    Param1, Param2, Param1dop, i,
                    @tmpbuf, Frame.Length);
                if result <> LinkResultOk then begin
                    abort;
                end;
                if (Assigned(ReadingFrameCallback)) then
                    ReadingFrameCallback(@tmpbuf, Frame.Length, i);

                if StopLink then begin
                    result := ErrorLinkStoping;
                    Exit;
                end;

                Application.ProcessMessages();
            end;

            if (Assigned(EndReadingCallback)) then
                EndReadingCallback();

            result := LinkResultOk;
        end else begin
            result := ErrorClassAlreadyExist;
        end;
    except
    end;

end;




end.

