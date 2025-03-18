// файл структурирования данных измерений (общее решение) DataBox
// под DataBox понимается совокупность данных собранная в непрерывном массиве памяти
// в процессе создания заголовки и данные могут располагаться в прерывном массиве, для их связи существуют поля указателей
// способ работы с DataBox:
// 1 создать  Create_DBox
// 2 приписать необходимую информацию Add_DBInfo
// 3 завершить создание   Lock_DBox
// результат = создан массив данных в памяти начиная с адреса DBox->pData размером DBox->DataSize, содержащий добавленную при создании информацию
// 4 присвоение указателя на DataBox,  Set_DBox
// 4 чтение информации,  Get_DBInfo


{$RANGECHECKS OFF}

unit DBox;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface

const DataBoxID    = $45adc346;    // идентификатор типа DataBox

Type T_DBoxType = longword;
const
  DBT_None                 = 0;
  DBT_Meas_Environment     = 1; // настройки прибора, при которых проводились измерения
  DBT_VibSignal            = 2; // вибросигнал
  DBT_Marker               = 3; // отметчик
  DBT_Balancing            = 4; // балансировочный
  DBT_VibTable             = 5; // таблица виброметра
  DBT_Spectr               = 6; // спектр сигнала
  DBT_Time                 = 7; // информация по времени замера
  DBT_Date                 = 8; // информация по дате замера
  DBT_Amount               = 9;
  DBT_Route                =10; // маршрут
  DBT_Balancing_Protocol   =11; // протокол  балансировки
  DBT_ParamBalanMeas       =12; // информация по баланс замеру (масса угол)
  DBT_Spectr_Env           =13; // разгон выбег  - спектр огибающей
  DBT_ParamEnv             =14; // параметры по огибающей
  DBT_DB                   =15; // структура подшипника
  DBT_RazgonVibeg          =16; // данные разгон выбега расчетные
  DBT_RecorderComment      =17; // речевой коммент
  DBT_TablePhaseShift      =18; // Belov данные калибровочной фазовой таблицы
  DBT_Unused               =$ffffffff;

  
// различные типы измерений
Type T_DC_Status = longword;
const
  DCS_Succsses        = 0;       // успешное выполнение
  DCS_ID_Wrong        = 1;       // некорректный идентификатор
  DCS_NotExist        = 2;       // замера с такими данными не существет
  DCS_FewData         = 3;       // недостаточный размер выделенной памяти
  DCS_UnRecognized    = 4;       // неизвестные данные (ошибка присвоения DataBox)
  DCS_NotExistCapsule = 5;        // капсулы с данными не существует


Type T_MStd_Status = longword;      // статус стандартного замера
const
  MS_NotExist      = 0;       // не существует
  MS_Creating      = 1;       // создается
  MS_Created       = 2;        // создан
  MS_Loaded        = 3;          // загружен


Type P_IncapsulateData =^T_IncapsulateData;
     T_IncapsulateData = record
  InfoSize    : longword;         // размер приписываемых данных в байтах
  TMD         : T_DBoxType;              // тип "канального" измерения, по нему определяется структура заголовка данных в вызывающей программе и оно же служит для поиска данных в DBox
  reserv      : array[0..2-1] of byte;
  iSameType   : byte;           // порядковый номер (index) вхождения типа TMD в DBox
  iSelf       : byte;           // сквозной номер (index) вхождения капсулы в DBox, бывший ID
  NextIncapsulate : longword;  // смещение следующего заголовка, если 0 то это последние данные канала
  InfoOffset  : longword;       // смещение данных заголовка
  pInfo       : PAnsiChar;            // указатель на текущий заголовок
  Caps_ID     : longword;
end;

const CapsuleID = $C0BAAB0C;


Type P_DBox_Std =^T_DBox_Std;
     T_DBox_Std = record
  Self_ID         : longword;          // уникальный идентификатор типа DataBoxID
  DataSize        : longword;         // размер DBox в байтах (при создании в этом поле допустимый размер, при чтении из внешнего носителя весь замер)
  pData           : PAnsiChar;            // указатель на память замера
  state           : T_MStd_Status;            // состояние объекта DBox
end;

Type P_CapsuleInfo =^T_CapsuleInfo;
     T_CapsuleInfo = record
  Caps : P_IncapsulateData;
  Addr : longword;     // адрес данных капсулы
  status : T_DC_Status;
end;




Var CapsInfo : T_CapsuleInfo;

function Set_DBox(                                  // укажем на DataBox
                      var DBox: P_DBox_Std;          // присваиваемый DataBox
                      BufData: PAnsiChar;       // буфер данных DataBox
                      BufSize: longword        // размер
                      ): T_DC_Status;
function Create_DBox(                                   // начинаем заполнение структуры замера
                        var DBox: P_DBox_Std;          // создаваемый DataBox
                        TMD : T_DBoxType;             // тип приписываемых данных
                        InfoSize : longword;        // размер заголовка данных в байтах
                        pDataInfo : PAnsiChar;       // данные заголовка TMD
                        BufData : PAnsiChar;         // буфер для хранения данных DataBox
                        BufSize : longword          // размер отводимый под замер
                        ): T_DC_Status;

function Add_DBInfo(                                    // добавим к данные существующему DBox
                        var DBox: P_DBox_Std;              // модифицируемый DBox
                        TMD : T_DBoxType;             // тип данных
                        InfoSize : longword;        // размер заголовка данных в байтах
                        pDataInfo : PAnsiChar        // данные заголовка TMD типа измерения
                        ): T_DC_Status ;
function Get_DBInfo(                                    // получить данные TMD из DBox
                        var DBox: P_DBox_Std;              // обрабатываемый DBox
                        TMD : T_DBoxType;             // тип данных
                        ID : longword;              // номер данных
                        var ID_ret : longword;          // возвращаемый ID
                        destBuf : pointer;         // буфер приемник данных
                        maxsize : longword;            // максимальный размер принимаемых данных
                        var Addr : longword             // возвращает адрес данных на носителе
                        ) : T_DC_Status ; stdcall;
function Lock_DBox (var DBox: P_DBox_Std) : T_DC_Status ;                  // завершить формирование DBox


function Get_DB_Capsule(                        // получить капсулу TMD из DBox
                              pDBox:P_DBox_Std;// обрабатываемый DBox
                              TMD:T_DBoxType;  // тип данных (обязательно знать для извлечения)
                              iAfter:longword// номер начиная с которого требуется вернуть капсулу
                                ):P_CapsuleInfo;

implementation




function Set_DBox(                                  // укажем на DataBox
                      var DBox: P_DBox_Std;          // присваиваемый DataBox
                      BufData: PAnsiChar;       // буфер данных DataBox
                      BufSize: longword        // размер
                      ): T_DC_Status;
begin
 DBox:=P_DBox_Std(BufData);
 DBox^.state     := MS_NotExist;
  Result:=DCS_UnRecognized;
  if (DBox^.Self_ID<>DataBoxID) then Exit;

  DBox^.DataSize  :=BufSize;
  DBox^.pData     :=BufData+sizeof(T_DBox_Std);
  DBox^.state     :=MS_Loaded;
  Result:=DCS_Succsses;
end;

function Create_DBox(                                   // начинаем заполнение структуры замера
                        var DBox: P_DBox_Std;          // создаваемый DataBox
                        TMD : T_DBoxType;             // тип приписываемых данных
                        InfoSize : longword;        // размер заголовка данных в байтах
                        pDataInfo : PAnsiChar;       // данные заголовка TMD
                        BufData : PAnsiChar;         // буфер для хранения данных DataBox
                        BufSize : longword          // размер отводимый под замер
                        ): T_DC_Status;
var vHeader : T_IncapsulateData;
begin
 DBox:=P_DBox_Std(BufData);
 DBox^.Self_ID   :=DataBoxID;
 DBox^.DataSize  :=BufSize;
 DBox^.pData     :=@(BufData[sizeof(T_DBox_Std)]);
 DBox^.state     :=MS_Creating;

 Result:=DCS_FewData;
 if (BufSize<InfoSize+sizeof(T_IncapsulateData)) then Exit;

  vHeader.TMD            :=TMD;
  vHeader.InfoSize       :=InfoSize;
  vHeader.iSelf          :=0;
  vHeader.NextIncapsulate:=0;
  vHeader.InfoOffset     :=sizeof(T_IncapsulateData);
  vHeader.pInfo          :=pDataInfo;

  Move(vHeader, DBox^.pData^, sizeof(T_IncapsulateData)); // данные инкапсуляции заголовка
  Move(pDataInfo^, DBox^.pData[sizeof(T_IncapsulateData)], InfoSize); // данные заголовка

  Result:=DCS_Succsses;

end;

function Add_DBInfo(                                    // добавим к данные существующему DBox
                        var DBox: P_DBox_Std;              // модифицируемый DBox
                        TMD : T_DBoxType;             // тип данных
                        InfoSize : longword;        // размер заголовка данных в байтах
                        pDataInfo : PAnsiChar        // данные заголовка TMD типа измерения
                        ): T_DC_Status ;
var pInfo : P_IncapsulateData;
    vInfo : T_IncapsulateData;
begin
  pInfo:=P_IncapsulateData(DBox^.pData);

  while(pInfo^.NextIncapsulate<>0) do    // переходим к последнему присоедененному инкапсулированному заголовку
    pInfo   := P_IncapsulateData(DBox^.pData+pInfo^.NextIncapsulate);

  // проверим достаточно ли места в текущем DataBox
  Result:=DCS_FewData;
  if (DBox^.DataSize< pInfo^.InfoOffset+    // смещение последней капсулы
                      pInfo^.InfoSize+      // размер заголовка последнейй капсулы
                      sizeof(T_IncapsulateData)+// размер капсулы для текущего пополнения
                      InfoSize                // размер текущего пополнения
                ) then Exit;
  DBox^.state              :=MS_Creating;
  // находим место куда будет помещены данные заголовка инкапсуляции
  pInfo^.NextIncapsulate :=pInfo^.InfoOffset+pInfo^.InfoSize;
  // вычисляем заголовок инкапсуляции
  vInfo.TMD            :=TMD;
  vInfo.InfoSize       :=InfoSize;
  vInfo.iSelf          :=pInfo^.iSelf+1;
  vInfo.NextIncapsulate:=0;
  vInfo.InfoOffset     :=pInfo^.NextIncapsulate+sizeof(T_IncapsulateData);
  vInfo.pInfo          :=pDataInfo;

  Move(vInfo, DBox^.pData[pInfo^.NextIncapsulate], sizeof(T_IncapsulateData));      // данные инкапсуляции заголовка
  Move(pDataInfo^, DBox^.pData[vInfo.InfoOffset], InfoSize);    // данные заголовка

  Result:=DCS_Succsses;
end;

function GetNextCapsule(pDBox : P_DBox_Std;pHeaderPrev:P_IncapsulateData
                                    ) :P_IncapsulateData;       // получить капсулу следующую за pHeaderPrev в pDBox
begin
  if (pDBox^.Self_ID<>DataBoxID) then Result:=nil
  else
    if(pHeaderPrev^.NextIncapsulate<>0) then Result:= P_IncapsulateData(@(pDBox^.pData[pHeaderPrev^.NextIncapsulate]))
    else                                     Result:= pHeaderPrev;
end;

function CapsuleData(pHeader:P_IncapsulateData):longword; // вернуть адрес данных капсулы pHeader
begin
  Result:=longword(pHeader)+sizeof(T_IncapsulateData);
end;

function Get_DBInfo(                                    // получить данные TMD из DBox
                        var DBox: P_DBox_Std;              // обрабатываемый DBox
                        TMD : T_DBoxType;             // тип данных
                        ID : longword;              // номер данных
                        var ID_ret : longword;          // возвращаемый ID
                        destBuf : pointer;         // буфер приемник данных
                        maxsize : longword;            // максимальный размер принимаемых данных
                        var Addr : longword             // возвращает адрес данных на носителе
                        ) : T_DC_Status ; stdcall;
var pHeader : P_IncapsulateData;
    ZeroPos : integer;
    data : longword;
    label lFind;
begin
  pHeader:=P_IncapsulateData(DBox^.pData);
  //eader:=GetFirstCapsule(pDBox);
  
  if (pHeader=nil) then begin Result:=DCS_UnRecognized; Exit;end;
  
  
  Result:=DCS_NotExist;
  ZeroPos:=1;
  while((pHeader^.NextIncapsulate<>0) OR (ZeroPos<>0)) do begin
    if ((pHeader^.NextIncapsulate=0) AND (ZeroPos<>0)) then ZeroPos:=0;
    if (pHeader^.Caps_ID<>CapsuleID)then begin  Result:= DCS_ID_Wrong; break;end;     // если ошиблись с капсулой
    if (pHeader^.TMD<>TMD) or(ID>pHeader^.iSelf) // если текущий инкапсулированный заголовок не совпадает с запращиваемым или
    then   pHeader :=GetNextCapsule(DBox, pHeader)
    else goto lFind;             // иначе извлечь данные текущего заголовка
  end;
  Result:=DCS_NotExistCapsule;
  Exit;

lFind:
  data:=CapsuleData(pHeader);
  {if (Addr <>0) then }Addr   :=data;
  {if (ID_ret<>0)then }ID_ret :=pHeader^.iSelf;
  if (pHeader^.InfoSize<=maxsize) then
  begin
    if (destBuf<>nil) then
      Move(PAnsiChar(data)^,destBuf^, pHeader^.InfoSize);
    Result:= DCS_Succsses;
  end
  else Result:= DCS_FewData;
end;




function Lock_DBox (var DBox: P_DBox_Std) : T_DC_Status ;                  // завершить формирование DBox
var pHeader : P_IncapsulateData;
begin
  pHeader:=P_IncapsulateData(DBox^.pData);

  while(pHeader^.NextIncapsulate<>0) do
    pHeader :=P_IncapsulateData(DBox^.pData[pHeader^.NextIncapsulate]);

  DBox^.state     :=MS_Created;
  DBox^.DataSize  :=pHeader^.InfoOffset+pHeader^.InfoSize;

  Result:=DCS_Succsses;
end;

function Get_DB_Capsule(                        // получить капсулу TMD из DBox
                              pDBox:P_DBox_Std;// обрабатываемый DBox
                              TMD:T_DBoxType;  // тип данных (обязательно знать для извлечения)
                              iAfter:longword// номер начиная с которого требуется вернуть капсулу
                                ):P_CapsuleInfo;
Var  pHeader: P_IncapsulateData;
     ZeroPos : word;
label lFind;
begin
  //T_IncapsulateData  *pHeader=GetFirstCapsule(pDBox);
  pHeader:=P_IncapsulateData(pDBox^.pData);

  if (pHeader=nil) then
  begin
    CapsInfo.status:=DCS_UnRecognized; // если ошиблись с капсулой
    Result:= @CapsInfo;  exit;
  end;

  CapsInfo.Caps:=pHeader;
  CapsInfo.Addr:=0;
  ZeroPos:=1;
  while((pHeader^.NextIncapsulate<>0)or(ZeroPos>0)) do
  begin
    if ((pHeader^.NextIncapsulate=0)and(ZeroPos>0))then ZeroPos:=0;
    if (pHeader^.Caps_ID<>CapsuleID) then
    begin
      CapsInfo.status:=DCS_ID_Wrong; // если ошиблись с капсулой
      Result:= @CapsInfo;  exit;
    end;

    if (                          // перейти к следующему заголовку
        (pHeader^.TMD<>TMD)or     // если текущий инкапсулированный заголовок не совпадает с запращиваемым или
        (iAfter>pHeader^.iSelf)   // и требуемый идентификатор больше текущего
            )  then
    begin
      pHeader :=GetNextCapsule(pDBox, pHeader);
      CapsInfo.Caps :=pHeader;
    end
    else goto lFind;             // иначе извлечь данные текущего заголовка
  end;
  CapsInfo.status:=DCS_NotExistCapsule; // если ошиблись с капсулой
  Result:= @CapsInfo;

lFind:
  CapsInfo.Addr   :=CapsuleData(pHeader);
  CapsInfo.status :=DCS_Succsses;
  Result:= @CapsInfo;
end;




end.

