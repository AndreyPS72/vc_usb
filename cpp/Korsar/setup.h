#ifndef _setup_h
#define _setup_h

#include "Protocol.h"

//---

#define equVersion  223   //������ ���������
#define equProtocol 100   //������ ��������� ������
#define equNumer    1     //����������(��������) ����� �������
#define equBuild    1     //���������� ����� ������


//---
#define MaxChannels           (5)     //������������ ����� ������� ����������� ���
#define MaxCalibrationChannel (9)     //������������ ����� ������������� �������
#define MaxPoint              (4096)  //������������ ����� ����� �����
#define MaxChValue            (8)     //������������ ����� ������� ������
#define MaxAveraging          (9)     //������������ ����� ����������

//--- ���� ������� ������
#define chNone 0  //��� ������
#define chF    1  //��������� ��� ��������
#define chA    2  //���������
#define chV    3  //��������
#define chS    4  //�����������
#define chM    5  //��������
#define chRe   6  //�������������� ����� �������
#define chIm   7  //������ ����� �������
#define chAv   8  //����������

//---�������� ������� ����������� ��� �������� ������������� �������������
#define caA1Pik   0
#define caA1Rms   1
#define caA1PtP   2
#define caV1Pik   3
#define caV1Rms   4
#define caV1PtP   5
#define caS1Pik   6
#define caS1Rms   7
#define caS1PtP   8
#define caVolt    9

//--- ����� �������������� �������
#define chNoFilter      8
#define chAcceleration  4
#define chVelocity      2
#define chDisplacement  1
#define chVolt          16

//--- ������������� ������ ��� �����������
#define TypeMemExcess        0 //�������
#define TypeMemVibrometer    1 //���������
#define TypeMemSignal        2 //������
#define TypeMemSpectr        3 //������
#define TypeMemSpectr1000    4 //������ �� 100��
#define TypeMemSpectrOgib    5 //������ ���������
#define TypeMemBalans        6 //������������
#define TypeMemRazgon        7 //������
#define TypeMemVibeg         8 //�����

//-- ���� ������
#define      ztOther           (unsigned int)0 // ������ - ���������� ���
#define      ztSKZ             (unsigned int)1 // ���
#define      ztSignal          (unsigned int)2 // ������
#define      ztSpectr          (unsigned int)4 // ������
#define      ztSpectrPower     (unsigned int)8 // ������ ��������
#define      ztSpectrFurie     (unsigned int)16 // ������ �� �����
#define      ztSpectrOgib      (unsigned int)32 // ������ ���������
#define      ztGarmon          (unsigned int)64 // ���������
#define      ztKepstr          (unsigned int)128 // ������
#define      ztPowerBand       (unsigned int)256 // �������� � ������
#define      ztAny             (unsigned int)(0xFFFF) // �����

// StampType - ��� ������ ��������
#define      stLin       0 // ��������: ��� ������� A1,A2...
                           // ��� �������: A1,A2,... F1,F2...
#define      stComplex   1 // ����������� ��� ������� Re1,Im1,Re2,Im2... - ���� ���


//------------------------------------------------------------------------------
//--- ����� �������������� ����� ������
#ifdef __version_plus
#define MaxParametersRegistration 3
#else
#define MaxParametersRegistration 5
#endif
//--- ������� ��������� �����������
#define TypeRegSignal         0
#define TypeRegSpectr         1
#define TypeRegSpectr1000     2
#define TypeRegBalans         3
#define TypeRegFreeVibrations 4
#define TypeRegRazgon         5
#define TypeRegVibeg          6
#define TypeRegSpectrOgib     7
#define TypeRegMP             8

//------------------------------------------------------------------------------
//
//  �������� �������� ����������
//
//------------------------------------------------------------------------------

#pragma pack(1)

//------------------------------------------------------------------------------
typedef struct stSens {
        float a,b;
}TSens;

//--- ��������� ����� ����� ����������
typedef struct stVibroOnePoint {
  float PIK[3];
  float RMS[3];
  float PtP[3];
  float EXC;
  u32   Exist;
}TVibroOnePoint;

//--- ��������� ����������
typedef struct stVibroValue {
  TVibroOnePoint Point[42];            //����� � ������� 1���, 2��� ...
  //TSens Sens[MaxCalibrationChannel+1]; //���������������� ��� �/�2, ��/c, ���, ������
  char           PeakFactor[4];        //��� ������
  char           Ch[4];                //����� ������ ������
  char           Comment[38];
  u16            Freq;
  short          CountPoint;
  TCRC           CRC;
}TVibroValue;

#pragma pack()


typedef struct stVibroAverPoint {
  float PIK[MaxAveraging];
  float RMS[MaxAveraging];
  float PtP[MaxAveraging];
}TVibroAverPoint;

//------------------------------------------------------------------------------
//
//  ��������� ���������� ���� �����������
//
//------------------------------------------------------------------------------
typedef struct stParametersRegistration {
  u16 TypeReg;    //��� �����������
  u16 EdIzm;      //������� ���������
  u16 Launch;     //������ ����������� (�� ���������, ���������, ...)
  u16 FHP;        //������ ������� ������
  u16 FLP;        //������ ������ ������
  u16 StopwayBeg; //��������� �������� �������� ��� ������/������
  u16 StopwayEnd; //�������� �������� �������� ���������/������
  u16 Point;      //����� ����� �����������
  u16 Aver;       //����� ����������
  u16 Band;       //����� ������ �������
  u16 Porog;      //����� �������
  u16 Reserv[4];  //�� �������� ����� �� ������� ������ ������ � ���������
}TParametersRegistration;

//------------------------------------------------------------------------------
//
//  �������� ��������� ��������� �������� � ������ �������� ������� �� ������
//  �� ����� ��������� ��������� EFC_PAGE_SIZE �� ����� EFC.H
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
//  ��������� ���������� �������
//
//------------------------------------------------------------------------------
typedef struct stSensor {
        u32    Tip;
        u32    Numer;
        float  Sens;
}TSensor;

//------------------------------------------------------------------------------
//
//��������� ������� ����� ������ � ������ ����
//
//------------------------------------------------------------------------------
/*
typedef struct stLine {
        float Line,Max,Min,Rms;
}TLine;
*/

//------------------------------------------------------------------------------
//
//  ��������� ������������� �������������
//
//------------------------------------------------------------------------------
typedef struct stCalibration {
        u16   Line;           //������� �����
        //float a,b,c;          //��������� ������������
        float Point[CalibrationPoint];//�������� � ������
        float Ampl[CalibrationPoint];//�������� ��������

}TCalibration;


//------------------------------------------------------------------------------
//
//  ��������� ������������� ������������� � ���������� �������� �������
//  ��������� �� �������� ��� ��������� �������� ������������
//
//------------------------------------------------------------------------------
typedef struct stCalibrationSetupInfo{
        u32          Version;                         //������ ���������
        u32          Protocol;                        //������ ��������� ������
        u32          Numer;                           //����������(��������) ����� �������
        u32          Build;                           //���������� ����� ������
        //TLine        Ch[MaxCalibrationChannel];       //������� �����
        TCalibration Coeff[MaxCalibrationChannel];    //������������ ����������
        float        Sens;
        char         reserv[94];
        TCRC         CRC;                             //����������� �����
}TCalibrationSetupInfo;


//------------------------------------------------------------------------------
//
// ����������, ����� ������������� ���������
//
//------------------------------------------------------------------------------
typedef struct stGlobalSetupInfo{
        u8       PowerOff;            //Power Off
        u8       LightOff;            //Light Off
        u8       PeakFactor[3];       //�������� ���������� ���/���/������
        u8       LCDShimValue;        //
        u8       SystemEdIzm;         //������� ���������
        u8       ShowSens;            //��� ����������� ��������� ������� 1-��/���, 2-��
        TSensor  Sensor;              //��������� �������
        float    NormExc;             //����� �� �������
        float    NormRMS;             //����� �� ���
        char     Volume;              //���������
        char     Window;
        u16      Freq;                //��������� ������� � ������� ��� ���������� ����������
        char     reserv[12];
        TCRC     CRC;
}TGlobalSetupInfo;


//------------------------------------------------------------------------------
//
//
//
//------------------------------------------------------------------------------
typedef struct stSetupInfo{
        //--- ���������
        u32 vCurrentPoint; // ������� ��� ����������
        //--- ����������� ��������
        u32 TypeReg;      // ��� �����������
        TParametersRegistration Regs[MaxParametersRegistration]; // ��������� �����������
        char Reserv[40];
        TCRC CRC;
}TSetupInfo;

//------------------------------------------------------------------------------
//
//   ��������� ��� ������������ ������ �� ����
//
//------------------------------------------------------------------------------
#define FramSetupInfoEnable        1

//------------------------------------------------------------------------------
//
//  �������� �������
//
//------------------------------------------------------------------------------

char  GetVibrometerMaxAveraging(void);

int   GetShowSpectrEdIzm(int EdIzm);
void  SetShowSpectrEdIzm(int EdIzm, u8 Factor);

s16  *ChAddr(char Ch);
void  SetChAddr(char Ch, s16 *Addr);
void  ClearDataArray(void);
void  RemapMemory(int Type);


s32   LoadBalansInfo(u32 count);
s32   SaveBalansInfo(u32 count);

s32   LoadSetupInfo(void);
void  SaveSetupInfo(void);

s32   LoadGlobalSetupInfo(void);
void  SaveGlobalSetupInfo(void);

s32   LoadCalibrationSetupInfo(void);
void  SaveCalibrationSetupInfo(void);

void  SetSensChannel(void);

u32   LoadSetup(void);

void GetSensChannel(u32 index, s32 point, float *a,float *b);
float CalculateChannelValue(u32 index, float aVal);


//------------------------------------------------------------------------------
//
//  �������� ����������
//
//------------------------------------------------------------------------------

extern s16 DataArray[5*MaxPoint];
extern TSens Sens3[MaxCalibrationChannel+1];


extern TSetupInfo SetupInfo;
extern TGlobalSetupInfo GlobalSetupInfo;
extern TCalibrationSetupInfo CalibrationSetupInfo;


#endif
