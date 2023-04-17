unit LinkTypesVV2;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses  LinkTypes
      ;




{$R-}


// ��� ������
const _VV2_ztWaveform        = 0;     // ������
const _VV2_ztSpectrum        = 1;     // ������
const _VV2_ztEnvelope        = 2;     // ���������
const _VV2_ztEnvSpectrum     = 3;     // ������ ���������
const _VV2_ztRMS             = 4;     // ���

const _VV2_ztCount           = 4;     // ����������
const _VV2_ztVibro           = 4;


//--- ����������� ����������
const  _VV2_eiAcceleration    = 0;   // ���������, �/�2
const  _VV2_eiVelocity        = 1;   // ��������, ��/�
const  _VV2_eiDisplacement    = 2;   // �����������, ���
const  _VV2_eiVolt            = 3;   // ������, �
const  _VV2_eiTemp            = 4;   // �����������, ���� C

const  _VV2_eiCount           = 5; // ����������
const  _VV2_eiVibro           = 3;


// ������ - ��� ���������� ?
const _VV2_svPeak             = 0;     // ���
const _VV2_svPP               = 1;     // ���-���
const _VV2_svRMS              = 2;     // ���



// ���������
const _VV2_stateNone    = 0; // ����������
const _VV2_stateGreen   = 1;
const _VV2_stateYellow  = 2;
const _VV2_stateRed     = 3;
const _VV2_stateCount   = 4;







//       u32 Exist; // 0 -  ���; 1 - ������ c ��������� ������; 2 - ���������������
const _VV2_teNo       = 0;
const _VV2_teHard     = 1;
const _VV2_teSoft     = 2;

Type _T_VV2_DateTime = longword;
     _T_VV2_Time     = Longword;
     _T_VV2_Date     = Longword;

Type T_VV2_Table = record

       Exist      : longword; // 0 -  ���; 1 - ������ c ��������� ������; 2 - ���������������
       DT         : _T_VV2_DateTime;       //����� � ���� ���������� ������

       Tip        : longword;
       EdIzm      : longword;
       AllX       : longword;

       X0         : single;
       dX         : single;
       XN         : single;

       Ampl       : Longint;   // ������������ �������� � ��������
       Scale      : single;

       OffT       : longword;      // �������� ������ ������ � ����� ��� ����� � ������
       LenT       : longword;             // ����� ������ � ����� ��� � ������ � ������ - ����� ���� ����� 0
                             // ������ AllX*szTOnePoint

       Reserv     : array [0..3] of longword;

end;
const szT_VV2_Table = sizeof(T_VV2_Table);



(*
��� �������: int X[0],X[1],...,X[AllX-1]
��� ������������ �������: int Re[0],Im[0],Re[1],Im[1],...,Re[AllX-1],Im[AllX-1]
*)










// Max ������������ ��������� ����� �������
// 0 - ��������
// 1 - ����� ������  2 - ������� ������   3 - �������� ��� ���������
const _VV2_MaxChannelCount = 4;

// ��� �������
const _VV2_chStamp    = 0; // ��������
const _VV2_chHigh     = 1; // �� �����
const _VV2_chLow      = 2; // �� �����
const _VV2_chEnv      = 3; // UHF


const _VV2_chCurrentChannel = _VV2_chHigh; // ��� ������


const _VV2_MaxSensor = 2; // �������� ��� �������

// ��� �����
const _VV2_stExternalSensor = 0;
const _VV2_stInternalSensor = 1;
const _VV2_stNoSensor = 2;
const _VV2_stTestSinus = 3;


const _VV2_MaxPoint           = (8*1024);  //������������ ����� ����� � ������




Type T_VV2_OnePoint = longint;
const szT_VV2_OnePoint = sizeof(T_VV2_OnePoint);

Type T_VV2_OneChannelData = array [0.._VV2_MaxPoint-1] of T_VV2_OnePoint; // ������ ������ ������ ������
const szT_VV2_OneChannelData = sizeof(T_VV2_OneChannelData);








// ============ ��� ���������� �� Flash ===================



// ��������� ������ �� FLASH
Type T_VV2_Parameters = record
//�����

       fType       : longword;           //��� ������
       ID          : longword;           //������������� ������
       Num         : longword;           //����� ������

       // ���� � ����� ������
       Day,
       Month,
       Year,  //-2000
       Hour,
       Min,
       Sec     : byte;

       Directory : byte;
       align1 : byte;

       MeasType : longword;                   // ��� ��������

       Value : single;                   // �������� ��� RMS ���

//������ ������

       // Index: 0=Data, 1=Data2
       Data : array [0..3] of longword;                      // �������� ������ � �����
       DataLen : array [0..3] of longword;                   // ����� ������
       compressed : array [0..3] of byte;              // 0 - ��� ������, 1 - ZIP;

       reserved : array [0..7] of longword;

       empty: TCRC; // ��� ������������
       CRC: TCRC;
end;

const szT_VV2_Parameters = sizeof(T_VV2_Parameters);







Type T_VV2_WaveRes = record
  Exist      : longword; // 0 -  ���; 1 - ������ c ��������� ������; 2 - ���������������
  DT         : _T_VV2_DateTime;       //����� � ���� ���������� ������

  Tip        : longword;
  EdIzm      : longword;

  CH         : array [0.._VV2_MaxChannelCount-1] of T_VV2_Table ;

  RMS        : single;
  Temp       : single;

  Reserv     : array [0..15] of longword;

  DataCRC    : TCRC;
  CRC        : TCRC;
end;
const szT_VV2_WaveRes = sizeof(T_VV2_WaveRes);








// ������� ����� � �������

const _VV2_CurrentWaveMagic = $68FC452E;

Type T_VV2_CurrentWave = record
  Magic           : longword;     // 0x68FC452E
  Device          : longword;    // prVV2          = 220
  Align           : array [0..13] of longword; // ������ �� 64 ����

  Wave            : T_VV2_WaveRes;
  Data            : array [0.._VV2_MaxPoint-1] of T_VV2_OnePoint;

  Reserv          : array [0..7] of longword;

  CRCAlign        : TCRC;
  CRC             : TCRC;
end;
const szT_VV2_CurrentWave = sizeof(T_VV2_CurrentWave);






//------------------------------ �������� VV-2 ------------------------------


//---------- �������� �������� ----------
const NameRoute_V2   = 64;   //����� ����� � �������� (� ������� = 60)
      MaxRouteNode_V2 = 1024;
      RouteVersion_V2 = $200; // ������ ��������� 2.00


// TRouteNode_V2.Exists
const rneFlagNone   = 0; // �� ��������� - �� ������������
      rneFlagFilled = 1; // ��������� ���������
      rneFlagReaded = 3; // rneFilled + ������ ������

// ������ 0xFFFFFFFF, ����� ����� ���� ���������� �� Flash  ��� ��������
const rneNone   = $FFFFFFFF; // �� ��������� - �� ������������
      rneFilled = (rneNone xor rneFlagFilled); // ��������� ���������
      rneReaded = (rneNone xor rneFlagReaded); // rneFilled + ������ ������



//---------- ��������� ������� ----------
Type TRouteNode_V2 = record

      Exists       : longword;    // rneXXX
      DataID       : longint;    // ������������� ������ �� Flash ��� 0 ��� -1, ���� ���

      Name         : array [0..NameRoute_V2-1] of AnsiChar;

      Order        : longword;      //�� �������; ��� ����� ������ ���� >0 ; ��� ������� � ������� = 0

// ������ ��� �����
      Tip          : longword;        //��� ������� (������/������)
      EdIzm        : longword;      //������� ���������
      Channel      : longword;    //����� 1..N; 0 - ��-���������
      Lines        : longint;      //����� ����� � �������
      LoFreq       : longint;     //������ ��������� �������, ��
      HiFreq       : longint;     //������� ��������� �������, ��
      NAverg       : longint;     //����� ����������, ������ ��� ������� (����� �� �������������� ��������)
      Stamper      : longword;    // 1 - ����� �� ��������� (����� �� �������������� ��������)


      Deep         : longint;
      Parent       : longint;      // ������ ������
      ChildCount   : longint;  // ����� ������������
      Expanded     : longword;    // ���� ������ ������� (��� ��������� ������)
      Marked       : longword;      // ���� ������ ������� (�� �������)

      //  ��� ��������� �������� � �������� � �������
      ID           : longword;        // ������������� �����
      Offset       : longword;        // �������� � ��������� �����
      Len          : longword;        // ����� � ��������� �����

      Reserv       : array [0..3] of longword;

      Align        : TCRC;
      CRC          : TCRC;
end;



//---------- ��������� ��������� �������� ----------
Type TRouteHdr_V2 = record

      Version      : longword;       // 0x200 ��� ���� ������

      Name         : array [0..NameRoute_V2-1] of AnsiChar;

      Count        : longint;         // ����� ��������� Node

      Reserv       : array [0..15] of longword;

      Align        : TCRC;
      CRC          : TCRC;
end;


//---------- ������� ----------
Type TRoute_V2 = record

     Hdr       : TRouteHdr_V2;           //��������� ��������

     Node      : array [0..MaxRouteNode_V2-1] of TRouteNode_V2;    // �������� ��������

end;


const szTRouteNode_V2 = sizeof(TRouteNode_V2);
      szTRouteHdr_V2  = sizeof(TRouteHdr_V2);
      szTRoute_V2     = sizeof(TRoute_V2); // ~140��






//------------------------------ ����� ��� ������ ------------------------------


// ����� ��� ��� ������
const _VV2_CellMaxPoints       = 14; // �����
const _VV2_CellMaxAxes         = 3; // �����������


// ������ 512���� ��� ����������� �����������
Type T_VV2_RMSDiag = record
  Reserv : array [0..128-1] of longword;
end;
const szT_VV2_RMSDiag = sizeof(T_VV2_RMSDiag); // 512 bytes



Type T_VV2_RMSRes = record
     //Exist   : longword;
     Exist   : word;
     Version : word;
     DT      : _TDateTime;       //����� � ���� ���������� ������

     CH      : longword;

     Value : array[0.._VV2_CellMaxPoints-1,0.._VV2_CellMaxAxes-1,0..2] of single;
     Temp  : array[0.._VV2_CellMaxPoints-1,0.._VV2_CellMaxAxes-1] of single;

     PointReaded : array [0.._VV2_CellMaxPoints-1] of byte; // ������� ����� ��� ������ �����, �������� �� �����: 1 - �; 2 - �; 4 - �;
     MeasNum     : byte; // ����� ��������� �����*����������� 0..42; ���� >1 - ���������� �������, ����<=1 - ���������� RMS
     Align       : byte;

     Reserv      : array [0..12-1] of longword;

     Diag        : T_VV2_RMSDiag;

     empty       : TCRC; // ��� ������������
     CRC         : TCRC;
end;

const szT_VV2_RMSRes = sizeof(T_VV2_RMSRes);



implementation


end.


