#ifndef _MEASUREMENT_VIANA2_H
#define _MEASUREMENT_VIANA2_H

#include "Defs_Viana2.h"
#include "MeasurementTypes.h"
#include "Measurement.h"
#include "MeasureSetupDefs.h"
#include "BalanceDefs.h"
#include <stdint.h>





#define FILE_VERSION_VIANA2_0100    0xC710 // ����� ������ ����� 1.0
#define FILE_VERSION_VIANA2_CURRENT FILE_VERSION_VIANA2_0100




static_assert(szTTable == 88, "");



typedef struct stOneChannel
{

	uint32_t Exist; // 0=teNo -  ���; 1=teHard - ������ c ��������� ������; 2=teSoft - ���������������
	uint32_t Align1;

	float ValueInstant[ShowValue::COUNT];	// ����������� �� �������/������� ������� (����������) �������� Peak, P-P, RMS, Zero, ...
	uint32_t ValueHarmonicsCalculatedTick; // Tick1024 ���������� ������������ RE1..IM3. ��� ��������� �����, ��� ��� ��������� ������ �� �������
	uint32_t ValueInstantCalculated;	// ������, ����� �� ValueInstant ���������

	float ValueAvg[ShowValue::COUNT]; // ���������� �� ����������� �� �������/������� Peak, P-P, RMS, Zero, ...
	uint32_t ValueAvgCalculatedTick; // Tick1024 ���������� ����������� ������ �� ValueInstant � ValueAvg
	uint32_t ValueAvgCalculated;	// ������, ����� �� ValueAvg ���������

	TTable Table[MeasurementType::WAV_SP];

	uint32_t Reserv[14];

} TOneChannel;
const size_t szTOneChannel = sizeof(TOneChannel);
static_assert(szTOneChannel == 512, "");



// ��������� ��� ������ � ����, ��� ������� �� ������
typedef struct
{

	uint16_t Exist;	// 0=teNo -  ���; 1=teHard - ������ c ��������� ������; 2=teSoft - ���������������
	uint16_t Version;
	
	_TDateTime DT;       // ����� � ���� ������ ������ ������
	uint32_t LastDataTick;  // Tick1024 ������ ������ ��� ��������� ���������� �������� ��� ������� ������� (� ��� ����� ������� ������ 1 ���) 
	uint32_t Align1;

	TMeasureSetup MeasSetup; //  ��� �������� ? ����� �����, ��� ������������

	uint32_t Count;          // ����� ������� ��������
	uint32_t Channels;       // ����� ������������ ��������

	// ��� �������� � ������
	uint32_t Type;
	uint32_t Units;

	float FreqTach;    // ������� �� ���������

	float TempValue;    // �����������, ���� �������

	// ���������� ������� / �� �������
	uint32_t SpectrumAvg;
	uint32_t SpectrumAvgMax;

	float FHP;          // ������� ������� �������
	float FLP;          // ������ ������� �������

	// ������� ������� � ���������-���������
	TOneChannel CH[CHANNEL_COUNT]; 

	uint32_t Reserv[65];

	TCRC Align; // ��� ������������
	TCRC CRC;

} TMeas;
const size_t szTMeas = sizeof(TMeas);
static_assert(szTMeas == 1920, "");	// 8 * 256 - 128


/*
��� �������: float X[0],X[1],...,X[AllX-1]
��� ������������ �������: float Re[0],Im[0],Re[1],Im[1],...,Re[AllX-1],Im[AllX-1]
*/



typedef float TOnePoint;	// ������� �������� � float
const size_t szTOnePoint = sizeof(TOnePoint);

//typedef TOnePoint TOneChannelData[MAX_POINT]; // ������ ������ ������ ������
//const size_t szTOneChannelData = sizeof(TOneChannelData);

typedef TOnePoint TOneChannelRecorder[MAX_POINT_RECORDER + MAX_POINT]; // ������ ������ ������ ������ (������ + ������)
const size_t szTOneChannelRecorder = sizeof(TOneChannelRecorder);



#define WAVEFORM(CH,i) (assert((i) >= 0 && (i) < (int)(CH)->AllX), ((TOnePoint*)((CH)->OffT))[(i)]) // ������ ������� ��� REAL �������
#define SPECTRUM_REAL_AMPL(CH,i) (assert((i) >= 0 && (i) < (int)(CH)->AllX), ((TOnePoint*)((CH)->OffT))[(i)]) // ���� REAL �������

#define SPECTRUM_RE(CH,i) (assert((i) >= 0 && (i) < (int)(CH)->AllX), ((TOnePoint*)((CH)->OffT))[(i)<<1]) // RE ������������ �������
#define SPECTRUM_IM(CH,i) (assert((i) >= 0 && (i) < (int)(CH)->AllX), ((TOnePoint*)((CH)->OffT))[((i)<<1)+1]) // IM ������������ �������
#define SPECTRUM_PHASE(CH,i) (arctan2f(SPECTRUM_IM(CH,i),SPECTRUM_RE(CH,i))) // ���������� ���� ������������ ����� ������������ ������� � ���

TOnePoint SPECTRUM_COMPLEX_AMPL2(TTable* CH, uint32_t i); // ���������� ����^2 ������������ ����� ������������ �������
TOnePoint SPECTRUM_COMPLEX_AMPL(TTable* CH, uint32_t i); // ���������� ���� ������������ ����� ������������ �������






// ����� ��� ��� ������
const uint32_t AURORA_CELL_MAX_POINTS = 14; // �����
const uint32_t AURORA_CELL_MAX_AXES = 3; // �����������

const uint32_t POINT_READED_MASK = 0x07; // ��������� ���


typedef struct
{
	uint16_t Exist;
	uint16_t Version;
	_TDateTime DT;       //����� � ���� ���������� ������

	TMeasureSetup MeasSetup; //  ��� �������� ? ����� �����, ��� ������������

	float Value[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES][MeasurementUnits::VIBRO]; // �������� � ������������ � ValueViewMode
	float Temp[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES];

	uint8_t PointReaded[AURORA_CELL_MAX_POINTS]; // ������� ����� ��� ������ �����, �������� �� �����: 1 - �; 2 - �; 4 - �;
	uint16_t Align2;

	// ���� ��� Viana2 ������ Diag
	uint8_t ValueViewMode[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES][MeasurementUnits::VIBRO]; // ��� ����� � Value, ��������, svRMS
	uint16_t Align3;

	float RMSVelocityValue[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES]; // �������� RMS Vel ��� ���������� ���������

	// ���� ��� Viana2 ������ Diag
	uint8_t Channel[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES]; // � ������ ������ �������� �������� (CH_1 ��� CH_2)
	uint16_t Align4;

	uint32_t Reserv[44];

	TCRC Align; // ��� ������������
	TCRC CRC;

} TRMSMeasurementViana2;
const size_t szTRMSMeasurementViana2 = sizeof(TRMSMeasurementViana2);
static_assert(szTRMSMeasurementViana2 == 1280, "");










// ���������� ����������:

// ����� Waveform/Spectrum
extern TMeas* MeasRef;
extern TOnePoint* MeasDataRef;

void SwitchMeasRefToRead(void);
void SwitchMeasRefToView(void);


// ����� RMS
extern TRMSMeasurementViana2* RMSRef;

void SwitchRMSRefToRead(void);
void SwitchRMSRefToView(void);


void ClearRMSMeas(void);


// ����� � ������� MeasData
// ���������� Table.OffT ����� ��� �������
uint32_t GetMeasDataAddr(uint32_t aChannel, uint32_t aType);


// true - ����� ����
bool IsMeasurementExists(void);

// ����+�����+Tick1024 ���������� ���������� ������
uint64_t MeasurementTime(void);

TOneChannel* GetChannel(uint32_t aChan);


float AddAvgValue(uint32_t ch, uint32_t sv, float aValue);


// ����������� MeasRead � MeasView
// ���������� ����� ������� �������� � ������
uint32_t CopySpectrumMeasurementToView(u32 aType, u32 aUnits);


float AccTodB(float aAcc); // �/�2 � ��
float dBToAcc(float dB); // �� � �/�2

// ������ ���������� �� ������� ���������
void CalculateEnvelopeRes_Viana2(uint32_t aChan, TEnvelopeRes* Env);


// ��������� ��� ValueInstant � ValueAvg, 
// ����� RE1..IM3 - ��� ����������� �� ���������� �������, ������-��� ��������
void ValueInstantToValueAvg(uint32_t aChan);


// ��������� ���� � ���� ��������� 1..3 ��������
// ��������� � ValueInstant[ShowValue::REx, IMx]
bool CalcAmplPhaseChannel(uint32_t aChan, float aFreq);

// ��������� �������������� � ������ ����� ��������� Freq
bool CalcAmplPhaseComplex(TTable* CH, float Freq, float* Re, float* Im);


#endif
