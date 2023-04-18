#ifndef __link_h
#define __link_h

#include "protocol.h"
#include "DateTime.h"
#include "SetupData.h"


#pragma pack(1)


//�������
#define cmdTestPribor    1
        //���� �������
        // param1    - �� ������������
        // param2    - �� ������������
        // param1dop - �� ������������
        // param2dop - �� ������������
#define cmdReadData      2
        //������� ������ � �������
        // param1    -   ���
        // param2    -   ID low16
        // param1dop -   ID high16 (0x00 ��� 0xFF - �� ������������, �� ���� =0)
        // param2dop -   0 - ���� �� ������,1.. - ����� �����
#define cmdWriteData     3
#define cmdReadFlash     4
        //������� ������ FAT
        // param1    -   �� ������������
        // param2    -   ID
        // param1dop -   �� ������������
        // param2dop -   0 - ���� �� ������,1.. - ����� �����
#define cmdWriteFlash    5
#define cmdReadEEPROM    6
        //
#define cmdWriteEEPROM   7
        //��������� Eeprom � ������
        // param1    -   �� ������������
        // param2    -   �� ������������
        // param1dop -   0 - ������� ����, 1 - �������� � ����
        // param2dop -   0 - ���� �� ������,1.. - ����� �����
#define cmdReadFrame     8
#define cmdReadListZamer 9
        // �������� ������ �������
        // param1    - �� ������������
        // param2    - �� ������������
        // param1dop - �� ������������
        // param2dop - 0 ����� �������, 1..-����� ������ �� ������� �� 1 �� ����� �������

#define cmdReadRoute     10
#define cmdWriteRoute    11
        // ��������� �������
        // param1    - 0 - ����, 1 - ����
        // param2    - 0 - �������,1..-����� ����� ��������
        // param1dop - 0 - ������� ����, 1 - �������� � ����
        // param2dop - 1

#define cmdClearData     12
        //�������� ������
        // param1    - CountSector; //����� ����� �������� flash
        // param2    - Numer;       //����� �������
        // param1dop - ByteSector;  //������ ������� flash
        // param2dop - 0

#define cmdClearID       13
        //�������� ID
        // param1    - ID low16
        // param2    - 0
        // param1dop - ID high16 (0x00 ��� 0xFF - �� ������������, �� ���� =0)
        // param2dop - 0

#define cmdOverload      14
        //����������� ����������
        // param1    -
        // param2    -
        // param1dop -
        // param2dop -

#define cmdReadListType  15
        // �������� ������ ������� ������������� ����
        // param1    - ��� ������
        // param2    - �� ������������
        // param1dop - �� ������������
        // param2dop - 0 ����� �������, 1..-����� ������ �� ������� �� 1 �� ����� �������

#define cmdWriteDSPProgram 16
        // ��������� ��������� DSP
        // param1    -
        // param1dop -
        // param2    - ������
        // param2dop -

#define cmdWriteImageFile   17
        //��������� ���� ��������
        // param1    -
        // param1dop -
        // param2    - ������
        // param2dop -

#define cmdReadRMS          18
        //������� ��������� RMS
        // param1    - ���������� �����
        // param1dop - �� ������������
        // param2    - �� ������������
        // param2dop - �� ������������

#define cmdGetPicture  19

#define cmdReadCurrentMeasurement 20
        // ������� ������� ����� � �������
        // param1    - ������: prVV2 = 220
        // param2    - �����: chHigh, chEnv
        // param1dop - ���: ztWaveform, ztSpectrum, ztEnvelope, ztEnvSpectrum
        // param2dop - ��.���.: eiAcceleration, eiVelocity, eiDisplacement

// ������� ����� �������
#define cmdReadScreen 21

// ������� ������� � ������
#define cmdPutKey 22



// �������������� ��������
#define prDiana         10
#define prDianaRev1     11
#define prKorsar        20
#define prNikta         30
#define prR2000         40
#define prTestSK        50
#define prVik3          60
#define prVik3Rev1      61
#define prDiana8        70
#define prDiana2M       80
#define prR400          90
#define prKorsarROS     100
#define prAR200         160
#define prAR700Rev2     111
#define prDianaS        120
#define prGanimed       130
#define prGanimed3      131
#define prAMTest2       140
#define prCLTester      150
#define prAR200         160
#define prAR100         170
#define prBalansSK      180
#define prUltratest     190
#define prViana1        200
#define prDPK           210
#define prVV2           220
#define prViana2        230
#define prViana4        240




//������ ���������
typedef __packed struct {char sign[3];} TSign;
const size_t szTSign = sizeof(TSign);
static_assert(szTSign == 3, "");


//������ �������
typedef __packed struct stCommand {
  TSign Sign;
  u8   Command;    // 1 ����
  u16  Param1;
  u16  Param1dop;
  u16  Param2;     // 2 �����
  u16  Param2dop;  // 2 �����
  TCRC CRC;        // 2 �����
}TCommand;
const size_t szTCommand = sizeof(TCommand);
static_assert(szTCommand == 14, "");


//�������� ��������� ���������� � �������
typedef __packed struct stInfoPribor {
  TSign Sign;       //���������
  u32 Pribor;      //��� �������
  u32 Numer;       //����� �������
  u32 Version;     //������ ����������� ����������� �������
  u32 Protokol;    //������ ��������� ������
  u32 Flash;       //������ flash
  u32 EEPROM;      //������ EEPROM
  u32 CountClaster;//����� ������ �������� fat
  u16  ByteClaster; //������ ������� fat
  u16  HideClaster; //����� ������� �������� fat
  u16  FreeClaster; //����� ��������� ��������� FAT
  u16  AllClaster;  //����� �������� fat
  char Data[9];
  TCRC CRC;
  char Align64[14]; // ������� �� 64 ���� ��� ������������� � USB 1.1 � USB 2.0
}TInfoPribor;
const size_t szTInfoPribor = sizeof(TInfoPribor);
static_assert(szTInfoPribor == 64, "");

//�������� ��������� ����������� ������
typedef __packed struct stLinkFrame {
  TSign        Sign;
  u16          Numer;
  u8           Types;
  u16          Count;
  u16          Length;
  TCRC         CRC;
} TLinkFrame;
const size_t szTLinkFrame = sizeof(TLinkFrame);
static_assert(szTLinkFrame == 12, "");


//�������� ��������� ������������ ������
typedef __packed struct stFrameWrite {
  TSign        Sign;
  u16          Numer;
  char         Types;
  char         Data[512];
  TCRC         CRC;
}TFrameWrite;
const size_t szTFrameWrite = sizeof(TFrameWrite);
static_assert(szTFrameWrite == 520, "");



typedef __packed struct stLinkList  //����� 64 �����
{
    u16 ID_Low;                // ������ �� ������ - ������� �����, ���� ID>64k
    u16 Numer;                 //���������� �����
    u16 Type;                  //��� ������
    struct {
         char DSec,Sec,Min,Hour;
         u16 Year;
         char Month,Day;
    } DateTime;

    //s16 UpLevel;               //������ �� ������� �������, ���� ����
    //u16 Size;
    s32 UpLevel;               //������ �� ������� �������, ���� ����
    char Note[30];
    u16 ID_High;               // ������ �� ������ - ������� �����, ���� ID>64k
    char reserv[14];
} TLinkList;
const size_t szTLinkList = sizeof(TLinkList);
static_assert(szTLinkList == 64, "");

//
typedef __packed struct stFrameList {
  TSign            Sign;
  u16              Numer;
  TLinkList        List;
  TCRC             CRC;
} TFrameList;
const size_t szTFrameList = sizeof(TFrameList);
static_assert(szTFrameList == 71, "");


//��������� ��� ������������� �� ������� ����������
typedef __packed struct stLinkHdr {
  char ID_Meas;            //������������� ������
  u16  Num;                //����� ������
  //����� � ���� ���������� ������
  char DSec,Sec,Min,Hour;
  u16  Year;
  char Month,Day;

  char Note[30];          //����������
  u16  Option;            // ��� �����-8
  TCRC CRC;
} TLinkHdr;
const size_t szTLinkHdr = sizeof(TLinkHdr);
static_assert(szTLinkHdr == 45, "");




typedef u32 (*fFirstFrame)(TCommand  *cmd, TLinkFrame *Frame);
typedef u32 (*fNextFrame)(TCommand  *cmd, u8 *buf,u32 Length);


typedef __packed struct Hdr {
  u32        ID;             //������������� ������
  u32        Num;            //����� ������
  _TDateTime DateTime;       //����� � ���� ���������� ������
  u32        Option;         //������ ������
  u32        Table;          //����� ������ ������ � �������
  u32        Next;           //�������� ������ �������
  TCRC       CRC;            //CRC ���������
} THdr;
const size_t szTHdr = sizeof(THdr);
static_assert(szTHdr == 26, "");





//_______________________________________________________________

// ��������� ����� ����� ����������
typedef __packed struct stVibroOnePoint {
  float PIK[3];
  float RMS[3];
  float PtP[3];
  float EXC;
  u32   Exist;
} TVibroOnePoint;
const size_t szTVibroOnePoint = sizeof(TVibroOnePoint);
static_assert(szTVibroOnePoint == 44, "");

// ��������� ����������
typedef __packed struct stVibroValue {
  TVibroOnePoint Point[42];            //����� � ������� 1���, 2��� ...
  char           PeakFactor[4];        //��� ������
  char           Ch[4];                //����� ������ ������
  char           Comment[38];
  u16            Freq;
  short          CountPoint;
  TCRC           CRC;
} TVibroValue;
const size_t szTVibroValue = sizeof(TVibroValue);
static_assert(szTVibroValue == 44*42+52, "");





void InitCommunication(void);

void SetDeviceBusy(void);
void SetDeviceNoBusy(void);


int ScanMessages(void);


#pragma pack()



// ����������, ������� ������������ � 1 ��� ���������� � ����� ������ � ���������
// �� ����� ����������� � ������ ������, ��������� ������� � ���������� � 0 
extern u8 RefreshFileSystem;
extern u8 RefreshRouteTree;



#endif



