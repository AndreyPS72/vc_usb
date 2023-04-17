#ifndef _BalanceDefs_h_
#define _BalanceDefs_h_

// ��������� ����������� ���� ������ ��� �������������
#include <stdint.h>

#include "Measurement.h"
#include "Defs_Viana2.h"
#include "DrvFlash.h"


#define _USE_MATH_DEFINES
#include <math.h>


const uint32_t BALANCE_MAX_POINTS_PLANES = CH_VIBRO;	// �� 2 ����� ��������� � �� 2 ���������� ���������. ����������� ����� 2
//const uint32_t BALANCE_MAX_HARMONICS = 10;	// �� 10 �������� ���������
const uint32_t BALANCE_MAX_RUNS = 20;	// �� 20 ������: #0; 2 ��������; ����������� � �.�.
const uint32_t BALANCE_CALC_RUNS = BALANCE_MAX_POINTS_PLANES + 1;	// ����� ��� �������: #0 + 2 ��������


const uint32_t BALANCE_PLANE_1 = CH_1;
const uint32_t BALANCE_PLANE_2 = CH_2;

const uint32_t BALANCE_CALC_RUN_0 = 0;	// ����� #0
const uint32_t BALANCE_CALC_RUN_TEST_1 = 1;	// ����� #1
const uint32_t BALANCE_CALC_RUN_TEST_2 = 2;	// ����� #2


//const uint16_t BALANCE_SETUP_VERSION = 0x7920;	// ������ �������� 2.0
//const uint16_t BALANCE_DATA_VERSION	= 0x5C20;	// ������ ������ ������������ 2.0

const uint32_t BALANCE_NAME_LEN = 32;


// ��������� ���������� ���������� � �����
const uint32_t BALANCE_CONFIGURATION_1X1 = 1;	// 1 ��������� ��������� x 1 ����� ���������
const uint32_t BALANCE_CONFIGURATION_1X2 = 2;	// 1 ��������� ��������� x 2 ����� ���������
const uint32_t BALANCE_CONFIGURATION_2X2 = 3;	// 2 ��������� ��������� x 2 ����� ���������


// ��������� ��������� ��������� �������
const uint32_t BALANCE_BAND_300_1000_RPM_5_17_HZ = 1;	// �� 300 �� 1000 rpm (5-17 ��)
const uint32_t BALANCE_BAND_1K_4K_RPM_17_67_HZ = 2;	// �� 1k �� 4k rpm (17-67 ��)
const uint32_t BALANCE_BAND_4K_30K_RPM_67_500_HZ = 3;	// �� 4k �� 30k rpm (67-500 ��)


// ��������� ����������� �������� ������
const uint32_t BALANCE_ROTATION_CLOCKWISE = 1;	// ����� ��������� �� ������� �������
const uint32_t BALANCE_ROTATION_COUNTER_CLOCKWISE = 2;	// ����� ��������� ������ ������� �������



// ��������� ������ ������������ Method
const uint32_t BALANCE_METHOD_BALANCING = 1;	// ������������ (�� 1 ���������)
const uint32_t BALANCE_METHOD_VIBRATION_EQUALIZE = 2;	// ������������ �������� �� ������
//const uint32_t BALANCE_METHOD_VIBRATION_REDUCTION = 3;	// ���������� (�� 10 ����������)


// ��������� ���� ������� (������ / �� ����) Calculation
const uint32_t BALANCE_CALCULATION_FULL = 1;	// ������
const uint32_t BALANCE_CALCULATION_COEFF = 2;	// �� ����



const uint32_t BALANCE_DEGREE_COUNT = 360 / 10 + 1;




typedef struct
{

	char Name[BALANCE_NAME_LEN]; // ������������ ��������

	uint32_t Configuration;	// ��������� ���������� ���������� � �����

	uint32_t RPMBand;	// �������� ��������� �������

	uint32_t Units;	// ����������� �� MeasurementUnits::VELOCITY ��� MeasurementUnits::DISPLACEMENT

	uint32_t Rotation;	// ��������� ����������� �������� ������

	int32_t TachAngle;	// �������� ���� ��������� ���������

	int32_t SensorAngle[CH_VIBRO];	// �������� ���� ��������� �������

	uint32_t Method;	// ��������� ������ ������������ (������������ / ����������)

	uint32_t Calculation;	// ��������� ���� ������� (������ / �� ����)

	uint32_t Reserv[15];

} TBalanceSetup;

const size_t szTBalanceSetup = sizeof(TBalanceSetup);
static_assert(szTBalanceSetup == 128, "");








// ������ ����� �� ������ ������ (�������)
typedef struct
{
	uint32_t Exist;

	// 1 = ���� � ���� 1-�� ��������� ����� ������� - ��������� ������ ������ �� 1-�� ���������
	uint8_t ManualInput;
	uint8_t Reserv1[3];

	// �������� (��� * sqrt2) ��� ������ "������������", ���
	float Vibration;

	// 1 ���������, ���, �������� ����������
	float Ampl;
	float Angle; // ���� � ����

	uint32_t Reserv[7];

} TBalanceRunSensorVibrationData;
const size_t szTBalanceRunChannelData = sizeof(TBalanceRunSensorVibrationData);
static_assert(szTBalanceRunChannelData == 48, "");



// ������ � ������� �� ����� ���������
typedef struct
{
	uint32_t Exist;

	// ������������� �����, �������� ����������
	float Weight;
	float Angle; // ���� � ����

	uint32_t Reserv[5];

} TBalanceRunPlaneWeightData;
const size_t szTBalanceRunPlaneWeightData = sizeof(TBalanceRunPlaneWeightData);
static_assert(szTBalanceRunPlaneWeightData == 32, "");





// ��������� IAR Project Option -> Language 1 -> C++ dialect == C++
#include <complex>
using namespace std;
typedef complex<float> TComplex;

// ������ ��������
typedef struct
{
	uint32_t Exist;

	// �������� ������ �� ������
	TComplex Vibration[BALANCE_CALC_RUNS][CH_VIBRO];
	TComplex TestWeights[BALANCE_CALC_RUNS][BALANCE_MAX_POINTS_PLANES];

	TComplex Coeff[BALANCE_MAX_POINTS_PLANES][CH_VIBRO]; // ���� �������

	TComplex CalcWeights[BALANCE_MAX_POINTS_PLANES]; // ����������� ����� �� ����������

	TComplex CalcVibration[CH_VIBRO];	// ���������� �������� �� ��������

} TBalanceCalculation;
const size_t szTBalanceCalculation = sizeof(TBalanceCalculation);
static_assert(szTBalanceCalculation == 164, "");





// ���� ���� � �������
typedef struct
{
	uint32_t Exist;
	_TDateTime DT;		//����� � ���� ���������� ������

	int32_t RunNumber; // ����� �����
	int32_t CalcNumber; // ����� ����� � ��������; 0..2

	TID ID;		// id ������

	uint32_t Units;

	float Freq;	// �������, �� 
	TBalanceRunSensorVibrationData	VibrationData[CH_VIBRO];
	TBalanceRunPlaneWeightData		WeightData[BALANCE_MAX_POINTS_PLANES];

	uint32_t Reserv[17];

} TBalanceRunData;
const size_t szTBalanceRunData = sizeof(TBalanceRunData);
static_assert(szTBalanceRunData == 256, "");





// ������ �� ������������
// ����������� � ����
typedef struct
{

	uint32_t Exist;	// 0=teNo -  ���; 1=teHard - ������ c ��������� ������; 2=teSoft - ���������������
	uint32_t Version;
	_TDateTime DT;		//����� � ���� ���������� ������������

	TBalanceSetup BalanceSetup;	// ���������

	uint32_t RunCount;	// ���������� ������
	TBalanceRunData	RunData[BALANCE_MAX_RUNS];	// �����: #0; 2 ��������; �����������

	TBalanceCalculation BalanceCalculation; // �������

	TID FramID; // ������������ ID ����� ��� ����������/�������������� �� FRAM

	uint32_t Reserv[177];

	TCRC Align; // ��� ������������
	TCRC CRC;

} TBalanceData;
const size_t szTBalanceData = sizeof(TBalanceData);
static_assert(szTBalanceData == 6144, ""); // 24*256





// ������ � ������� Plane.Values[]
const uint32_t BALANCE_INDEX_VIBRATION_AMPL = 0;	// ��������� ������� �����
const uint32_t BALANCE_INDEX_VIBRATION_ANGLE = 1;	// ���� ������� �����
const uint32_t BALANCE_INDEX_WEIGHT_MASS = 2;	// ����� �����
const uint32_t BALANCE_INDEX_WEIGHT_ANGLE = 3;	// ���� �����

const uint32_t BALANCE_INDEX_MASK_ANGLE = 1;	// ��� ������� ����� ����� ���� ���
const uint32_t BALANCE_INDEX_COUNT = 4;



// ��� �������� � ����� � ������
const uint32_t BALANCE_MASK_DRAW_VIBRATION_AMPL = (1UL << BALANCE_INDEX_VIBRATION_AMPL);
const uint32_t BALANCE_MASK_DRAW_VIBRATION_ANGLE = (1UL << BALANCE_INDEX_VIBRATION_ANGLE);
const uint32_t BALANCE_MASK_DRAW_VIBRATION = (BALANCE_MASK_DRAW_VIBRATION_AMPL | BALANCE_MASK_DRAW_VIBRATION_ANGLE);
const uint32_t BALANCE_MASK_DRAW_WEIGHT_MASS = (1UL << BALANCE_INDEX_WEIGHT_MASS);
const uint32_t BALANCE_MASK_DRAW_WEIGHT_ANGLE = (1UL << BALANCE_INDEX_WEIGHT_ANGLE);
const uint32_t BALANCE_MASK_DRAW_WEIGHT = (BALANCE_MASK_DRAW_WEIGHT_MASS | BALANCE_MASK_DRAW_WEIGHT_ANGLE);
const uint32_t BALANCE_MASK_DRAW_TACH = (1UL << 6);
const uint32_t BALANCE_MASK_DRAW_SENSOR = (1UL << 7);


// ������ ���� ��������
const uint32_t BALANCE_INPUT_VIBRATION = (1UL << 0);
const uint32_t BALANCE_INPUT_WEIGHTS = (1UL << 1);




typedef enum
{
	BALANCE_RESULT_OK = 1UL,
	BALANCE_RESULT_ERROR_SMALL_VIBRATION,
	BALANCE_RESULT_ERROR_SMALL_CALC,
	BALANCE_RESULT_ERROR_ZERO_WEIGHT,
	BALANCE_RESULT_ERROR_SMALL_COEFF,
	BALANCE_RESULT_ERROR_NO_RUN_MARKED,
} TBalanceResult;





// ������������
extern TBalanceData* BalanceRef;

void SwitchBalanceRefToRead(void);
void SwitchBalanceRefToView(void);

// �������� � ��������� ��-���������
void ZeroBalanceSetup(TBalanceSetup* aBalanceSetup);

bool ClearBalanceMeas(void);

#endif


