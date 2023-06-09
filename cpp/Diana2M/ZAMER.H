#ifndef _zamer_h
#define _zamer_h

#include "typesdef.h"
#include "DateTime.h"
#include "drvflash.h"

// Max ������������ ��������� ����� �������
// 0 - ��������
// 1..8 - ������
#define MaxChannel 8
// � ����������
#define MaxChannelO (MaxChannel+1)

typedef struct Hdr {
  u32        ID;             //������������� ������
  u32        Num;            //����� ������
  _TDateTime DateTime;       //����� � ���� ���������� ������
  u32        Parent;         //��������� �� ������� �������, 0 - ��� �������� ������
  u32        Table;          //����� ������ ������ � �������
  u32        Next;           //�������� ������ �������
  TCRC       CRC;            //CRC ���������
}THdr;


//------------------------------------------------------------------------------
#define htDataCommon     1
#define htDataVibration  2
#define htDataVibrometer 3
#define htDataElectrical 4
#define htDataRoute      5

typedef struct HdrTable {
  u16        Type;           //��� ������
  u16        Reserv;         //�� ������������
  u32        Offset;         //�������� ������ �������
  u32        Next;           //�������� ��������� �������
  TCRC       CRC;            //CRC
}THdrTable;

//------------------------------------------------------------------------------
typedef struct TableVibration {
    u16    Tip;              // ��� ������ ztXXXXX
    u16    EdIzm;            // ����������� ���������� eiXXXX
    u32    AllX;             // ����� ��������
    double X0;               // ���. ��������, �� ��� ��
    double dX;               // ���, �� ��� ��
    double XN;               // ���. ��������, �� ��� ��
    double SKZ;              // ���
    double Freq;             // ������� ������ ��������� ��� ������� ��������� ����
    double Phase;            // ������� �����������
    double A1[5];            // ��������� ������ 5-� �������� ��� 0
    double F1[5];            // ���� ������ 5-� ��������
    double ScaleA;           // ��������� ���������� Double = Integer * Scale
    double ScaleB;           // ��������
    u32    StampType;        // ��� ������ �������� - ���� ������ stLin
    u32    OffT;             // �������� ������ ������� � ����� � �����
    u32    LenT;             // ����� ����� ������� � ����� - ����� ���� ����� 0
    u32    Option;           // ������ ����� ������
    u8     ch0;              // ����� ������ ������ (������������� ��� �������)
    u8     ch1;              // �� ������������
    u8     ch2;              // �� ������������
    u8     ch3;              // �� ������������

    u16    Reserv[8];        // ��� ������� ��������� � ������� ������������ ����� ��������� ���������
                             // 0 - INOM, ����������� ��� ��������� * 10, �
                             // 1 - FreqMotor, ��������� ������� ��������� * 10, ��/���
                             // 2 - FreqSeti,������� ���� * 10, ��

    TCRC   CRC;
}TTableVibration;

//������ �� ������ ��� ������������ (�������� 8-�� ����������� ������������)
typedef struct BalansData {
    float Mass[8];
    float Faza[8];
}TBalansData;

typedef struct ZamerData {
    u16         TypeReg;      // ��� �����������
    u16         EdIzm;        // �������� ������� ��������� (������������� ��������� �� ������� ������)
    u16         Launch;       // ������ ����������� (�� ���������, ���������, ...)
    u16         Averages;     // ����� ����������
    u32         Point;        // �������� ����� ����� � ������ (������������� ��������� �� ������� ������)
    float       Freq;         // ������� �����������
    float       FHP;          // ������ ������� ������
    float       FLP;          // ������ ������ ������
    u32         Option;       // ������ ����� ������
    TBalansData Balans;       // ��� ������������
    u8          Comment[40];  // ����������
    u32         Reserv[10];   // �� ������������
    TCRC        CRC;
}TZamerData;


void SetNewTable(THdrTable *TH, u32 Type, u32 Offset, u32 Len);
s32 SaveZamerHeader(TFile *f,THdr *Hdr);
s32 SaveZamerData(TFile *f,u32 Offset, THdrTable *TH, TZamerData *ZD);
s32 SaveZamerTableVibration(TFile *f, u32 Offset, THdrTable *HT, TTableVibration *TV, void *Buf, u32 Len);



s32 LoadZamerHeader(u32 index,THdr *Hdr);
s32 LoadTable(TFile *f, u32 Offset, THdrTable *TH);
s32 LoadZamerData(TFile *f,u32 Offset, TZamerData *ZD);
s32 LoadZamerTableVibration(TFile *f, u32 Offset, TTableVibration *TV);
s32 LoadZamerTableData(TFile *f, u32 Offset, void *Buf, u32 Len);

u32 GetLastNumer(char Types);


#endif
