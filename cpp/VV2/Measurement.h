#ifndef Measurement_h_
#define Measurement_h_

#include "TypesDef.h"
#include "MeasurementTypes.h"

#include <stdint.h>

#define BITFLAG(b) (1UL<<(b))



//       uint32_t Exist; // 0=teNo -  ���; 1=teHard - ������ c ��������� ������; 2=teSoft - ���������������
#define teNo        (0)
#define teHard      (1)
#define teSoft      (2)

// ��������� ������������ ��� ���������� �� Flash, ���������� �� ������
typedef struct stTable
{

	uint32_t Exist; // 0=teNo -  ���; 1=teHard - ������ c ��������� ������; 2=teSoft - ���������������
	//       uint32_t State;
	_TDateTime DT;       //����� � ���� ���������� ������

	uint32_t Type;
	uint32_t Units;
	uint32_t AllX;

	float X0;
	float dX;
	float XN;

#ifdef __Viana2
	float AmplMax;   // ������������ �������� � �������
	float AmplMin;   // ����������� �������� � �������
#else
	int32_t Ampl;   // ������������ �������� � ��������
#endif
	float Scale;

	uint32_t OffT;			// �������� ������ ������ � ����� ��� ����� � ������
#ifdef __Viana2
	uint32_t OffTx64;		// ����� ��� ������ x64

	uint8_t Reserv1[2];
	uint8_t DataFormat;		// ������ ������������� �������� � OffT - MeasurementDataFormat::XXX
	uint8_t DrawOptions;	// ��� ������������ ������ - DrawGraphOptions::XXX
#endif
	
	// ����� ������ � ����� ��� � ������ � ������ - ����� ���� ����� 0. 
	// ��� ������� = AllX * szTOnePoint
	// ��� ������������ ������� = AllX * 2 * szTOnePoint
	uint32_t LenT;

	uint32_t Tick;           // Tick1024 ��� ����� ������� �������

#ifdef __Viana2
	uint32_t Reserv[6];
#else
	uint32_t Reserv[3];
#endif

} TTable;
const size_t szTTable = sizeof(TTable);




//typedef short* TShortArray;
typedef int32_t* TIntArray;
typedef float* TFloatArray;
typedef double* TDoubleArray;



void ShortArrayToFloat(TIntArray InArr, TFloatArray OutArr, int Count);
void ShortArrayToDouble(TIntArray InArr, TDoubleArray OutArr, int Count);


char* GetTypeName(uint32_t aType);
char* GetUnitsName(uint32_t aUnits);
void FormatValue(char* Str, uint32_t aUnits, float Value);
void FormatAngle(char* Str, int32_t aAngle);
char* AngleToStringF(char* Str, float fAngle);
char* AngleToString(char* Str, int32_t iAngle);
char* WeghtToString(char* Str, float fWeight);



float GetXVal(TTable* CH, uint32_t i);
float GetYVal(TTable* CH, uint32_t i);
int32_t GarmNear(TTable* CH, float aR, float dD);

void CopyCH(TTable* SrcCH, TTable* DstCH);


bool IsVibration(uint32_t aUnits);
bool IsVibration(TTable* CH);

bool IsWaveform(uint32_t aType); // true = �����-�� ������
bool IsSpectrum(uint32_t aType); // true = �����-�� ������
bool IsWaveformOrSpectrum(uint32_t aType);  // true = �����-�� ������ ���� ������ (�� ���)
bool IsEnvelopeData(uint32_t aType);  // true = ������ ��� ������ ���������






// �������� ������
void ClearMeas(void);
void ClearAvgValues(void);

TTable* GetTable(uint32_t aChan, uint32_t aType, uint32_t aUnits);
TTable* GetTable(uint32_t aChan, uint32_t aType);




// �������� �� ������, ���������� �� ���������� ����������
// ���� ���, �� ��������� �� ����
float GetValue(uint32_t aChan, uint32_t aUnits, uint32_t aSV);


// ������� (����������) �������� �� ������, �� ����������
// ���� ���, �� ��������� �� ����
float GetValueInstant(uint32_t aChan, uint32_t aUnits, uint32_t aSV);



// ��������� ��������� �� ��� ������������� � ������
uint32_t CalcState(float RMS, uint32_t NormIndexW, uint32_t NormIndexA);


extern float BearingTemp; // ����������� � ���� �������


float GetCurrentTempValue(void);
uint32_t CalcTempState(float aTemp);

// ���������� ������� ������������ �����; -1 = �� �����
int32_t GetVibroChannel(void);






// �������� � ������� CH �� ������� aLeft �� aRight-1 ������������ � ����������� ��������
void WaveformMinMax(TTable* CH, int32_t aLeft, int32_t aRight, float* aMin, float* aMax);

// �������� � ������� CH �� ������� aLeft �� aRight-1 ������������ �������� (��� ������ = *Num; Num ����� ������ = NULL)
float SpectrumMax(TTable* CH, int32_t aLeft, int32_t aRight, int32_t* Num);










// �������� �����
#define ADCFreqUHF (186915) // Hz

//_______________________________________________________________
// Envelope




// ������ ��������� 1 ���, 1024 �������
#define ENV_FREQ (1000)
#define ENV_COUNT (1024)
// ����� �� 2 ������� + �����
#define MaxDataBufEnvLen (ENV_COUNT*3)


//  ���������
typedef struct stEnvelopeRes
{
	uint32_t Exist;
	uint32_t Version;
	_TDateTime DT;       //����� � ���� ���������� ������

	uint32_t Type;
	uint32_t AllX;
#ifdef __Viana2
	uint32_t Align;
	uint32_t DataBufx64;		// ����� ��� ������ x64
#endif
	s16* DataBuf;
	float Scale;
	float dX; // ��� �� X � ��
	int32_t FilterFreq;

	uint32_t MinEnv, MaxEnv, Avg;
	float dBm, dBc;
	float LR, HR;
	float SPM1; // dBm / dBc
	float SPM2; // LR / HR

	float SPM1NormRed, SPM1NormYellow;
	uint32_t State1;

	float
		SPM2NormHRYellowX1,
		SPM2NormDeltaYellowY1,
		SPM2NormHRYellowX2,
		SPM2NormDeltaYellowY2,

		SPM2NormHRRedX1,
		SPM2NormDeltaRedY1,
		SPM2NormHRRedX2,
		SPM2NormDeltaRedY2;

	uint32_t State2;
	uint32_t COND;
	char CODE;

	char Reserv1[3];

	float SV2; // sum v^2
	float SV4; // sum v^4
	float RMS; //  ��� ���������
	float CrestFactor; //  ���-������
	float Excess; // �������
	uint32_t StateCrestFactor;
	uint32_t StateExcess;

	uint32_t Tick;            // Tick ��� ����� ������� �������

	float gE; // gE 0,5-10 ���
	uint32_t StateGE;

	uint32_t Reserv[20];

} TEnvelopeRes;
const size_t szTEnvelopeRes = sizeof(TEnvelopeRes);
static_assert(szTEnvelopeRes == 256U, "");


extern TEnvelopeRes Env;

// �������� ����� � �������
#define AirSpeed 340.0 // m/sec

// ������ ������� ���������
void CalcEnvelopeSpectrum(TEnvelopeRes* Env);







// ============ ��� ���������� �� Flash ===================

// ������������ ����������� ��������� �� ������
// � 0 ������ �� �������
// � ��������� ������� ��������� �����������
// � ������������� ������� ����
// ��� ������ K9F2G08U0A
#define MaxMeasurements (16384-3)



// ��������� ������ �� FLASH
typedef struct stParameters
{
	//�����

	uint32_t        Type;           //��� ������ (u8)
	uint32_t        ID;             //������������� ������
	uint32_t        Num;            //����� ������

	// ���� � ����� ������
	//Date of measurement
	u8  Day;
	u8  Month;
	u8  Year;  //-2000
	//Time of measurement
	u8  Hour;
	u8  Min;
	u8  Sec;

	u8 NotUsed;//Directory;

	u8 align1;

	uint32_t MeasType;                   // ��� ��������

	float Value;                   // �������� ��� RMS ���

	//������ ������

	// Index: 0=Data, 1=Data2
	uint32_t Data[4];                   // �������� ������, ��� �������� � �����
	uint32_t DataLen[4];                // ����� ������, ��� �����
	u8 compressed[4];              // 0 - ��� ������, 1 - ZIP;

	uint32_t reserved[8];

	TCRC empty; // ��� ������������
	TCRC CRC;
} TParameters;

#define szstParameters sizeof(struct stParameters)
#define szParameters szstParameters
const size_t szTParameters = sizeof(TParameters);	// 100 bytes
static_assert(szTParameters == 100, "");


#endif


