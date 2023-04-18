#ifndef __HandleMeasurement_h
#define __HandleMeasurement_h

#include "Measurement.h"




// ����� ��� ��� ������
#define CellMaxPoints       14 // �����
#define CellMaxAxes          3 // �����������

#define PointReadedMask     0x07 // ��������� ���


#define stateColorGreen   ColorDarkGreen
#define stateColorYellow  GetColor24to16(0xA8A800)
#define stateColorRed     ColorRed



#define FileVersionVV2_0000    0x0000
#define FileVersionVV2_0200    0x0200 // ����� ������ �����
#define FileVersionVV2_Current FileVersionVV2_0200


// ������ 512���� ��� ����������� �����������
typedef struct stRMSDiag {
  u32    Reserv[128];
} TRMSDiag;
#define szTRMSDiag sizeof(TRMSDiag) // 512 bytes


typedef struct stRMSRes {
  u16 Exist;
  u16 Version;
  _TDateTime DT;       //����� � ���� ���������� ������

  u32 CH;
  float Value[CellMaxPoints][CellMaxAxes][MU_VIBRO]; // ���� ������������ Value[0][0][]; �������� ����������� (���) !
  float Temp[CellMaxPoints][CellMaxAxes];

  u8 PointReaded[CellMaxPoints]; // ������� ����� ��� ������ �����, �������� �� �����: 1 - �; 2 - �; 4 - �;
  u8 MeasNum; // ����� ��������� �����*����������� 0..42
  u8 Align;

  u32    Reserv[12];
  
  TRMSDiag Diag;

  TCRC empty; // ��� ������������
  TCRC CRC;
} TRMSRes;

#define szTRMSRes sizeof(TRMSRes) // ~1264 bytes





// � ������ ������ 0x0000 ������ CH[] ����� �� ������� chHigh ��� chLow, chEnv
// � ����� ������ 0x0200 ������ CH[] ����� �� ����� ������: chStamp, chHigh, chLow, chEnv

typedef struct stWaveRes {
  u16 Exist;
  u16 Version;
  _TDateTime DT;       //����� � ���� ���������� ������

  u32 Type;
  u32 Units;

  TTable CH[MAX_CHANNEL_COUNT];

  float RMS;
  float Temp;
  float Freq;

  u32    Reserv[15];

  TCRC DataCRC;
  TCRC CRC;
} TWaveRes;
#define szTWaveRes sizeof(TWaveRes)







#endif


