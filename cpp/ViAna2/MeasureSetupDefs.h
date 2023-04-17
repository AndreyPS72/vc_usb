#ifndef __MEASURESETUPDEFS_H
#define __MEASURESETUPDEFS_H

#include <stdint.h>


// MeasurementMode: ��� �������� (������������� ���� � ������� ����) ?
const uint32_t SETUP_MSM_WAVEFORM = 0;
const uint32_t SETUP_MSM_RMS = 1;
const uint32_t SETUP_MSM_ROUTE = 2;
const uint32_t SETUP_MSM_BALANCE = 3;
const uint32_t SETUP_MSM_RECORDER = 4;
const uint32_t SETUP_MSM_RUNUP = 5;
const uint32_t SETUP_MSM_ORBIT = 6;
const uint32_t SETUP_MSM_MODAL = 7;
const uint32_t SETUP_MSM_BEARINGS = 8;
const uint32_t SETUP_MSM_UHF = 9;
const uint32_t SETUP_MSM_CURRENT = 10;
const uint32_t SETUP_MSM_COUNT = 11;



// Path: ����� ���������� �����
const uint32_t SETUP_MSP_DEFAULT = 0;	// SETUP_MSP_STD
const uint32_t SETUP_MSP_STD	=1;	// ����������� 3Hz..10kHz
const uint32_t SETUP_MSP_SLOW	=2;	// ��������� 0,5Hz..50Hz
const uint32_t SETUP_MSP_ENV	=3;	// ��������� 500Hz..10kHz
const uint32_t SETUP_MSP_UHF	=4;	// UHF ������ �� ������ ���������
const uint32_t SETUP_MSP_COUNT	=4;
const uint32_t SETUP_MSP_MUX = 5;	// ������������ ����� Mux


// Channels: ����� ������ ������������ � ���������
const uint32_t SETUP_MSC_DEFAULT = 0; // SETUP_MSC_CH1
const uint32_t SETUP_MSC_CH1  =1;
const uint32_t SETUP_MSC_CH1T =2;
const uint32_t SETUP_MSC_CH12 =3;
const uint32_t SETUP_MSC_CH12T=4;
const uint32_t SETUP_MSC_TACH =5;
const uint32_t SETUP_MSC_SINUS=6;
const uint32_t SETUP_MSC_CH_MIN = SETUP_MSC_CH1;
const uint32_t SETUP_MSC_CH_MAX = SETUP_MSC_TACH;

// Units
const uint32_t SETUP_MSU_DEFAULT = 0; // SETUP_MSU_VELOCITY
const uint32_t SETUP_MSU_ACCELERATION = 1;
const uint32_t SETUP_MSU_VELOCITY = 2;
const uint32_t SETUP_MSU_DISPLACEMENT = 3;
const uint32_t SETUP_MSU_COUNT = 3;
const uint32_t SETUP_MSU_MUX = 4;	// ������������ ����� Mux


// Type: ��� ������
const uint32_t SETUP_MST_DEFAULT = 0;	// SETUP_MST_SPECTRUM1000
const uint32_t SETUP_MST_SPECTRUM1000 = 1;
const uint32_t SETUP_MST_SPECTRUM = 2;
const uint32_t SETUP_MST_WAVEFORM = 3;
const uint32_t SETUP_MST_COUNT = 3;

// AllX
const uint32_t SETUP_ALLX_DEFAULT = 0; // SETUP_ALLX_1K
const uint32_t SETUP_ALLX_128	= 1;
const uint32_t SETUP_ALLX_1K	= 2;
const uint32_t SETUP_ALLX_8K	= 3;
const uint32_t SETUP_ALLX_64K	= 4;
const uint32_t SETUP_ALLX_COUNT = 4;

const uint32_t SETUP_ALLF_DEFAULT = 0; // SETUP_ALLF_400
const uint32_t SETUP_ALLF_50		= 1;
const uint32_t SETUP_ALLF_400		= 2;
const uint32_t SETUP_ALLF_3200		= 3;
const uint32_t SETUP_ALLF_25600 = 4;
const uint32_t SETUP_ALLF_COUNT = 4;

// dX: ������� ������������� � ������� 
const uint32_t SETUP_DX_DEFAULT = 0;	// SETUP_DX_2560_HZ
const uint32_t SETUP_DX_25600_HZ	= 1;	// 25600 ��
const uint32_t SETUP_DX_6400_HZ = 2;	// 6400 ��
const uint32_t SETUP_DX_2560_HZ = 3;	// 2560 ��
const uint32_t SETUP_DX_640_HZ = 4;	// 640 ��
const uint32_t SETUP_DX_256_HZ = 5;	// 256 ��
const uint32_t SETUP_DX_COUNT		= 5;

// ������� ������� � �������
const uint32_t SETUP_FN_DEFAULT = 0;	// SETUP_FN_1000_HZ
const uint32_t SETUP_FN_10000_HZ = SETUP_DX_25600_HZ;	// 10000 ��
const uint32_t SETUP_FN_2500_HZ = SETUP_DX_6400_HZ;	// 2500 ��
const uint32_t SETUP_FN_1000_HZ = SETUP_DX_2560_HZ;	// 1000 ��
const uint32_t SETUP_FN_250_HZ = SETUP_DX_640_HZ;		// 250 ��
const uint32_t SETUP_FN_100_HZ = SETUP_DX_256_HZ;		// 100 ��
const uint32_t SETUP_FN_COUNT = SETUP_DX_COUNT;



const uint32_t SetupMeasAllX[SETUP_ALLX_COUNT + 1] = { 1024, 128, 1024, 8192, 65536 };
const float SetupMeasdX[SETUP_DX_COUNT + 1] = { 
	1.0f / 2560.0f, 1.0f / 25600.0f, 1.0f / 6400.0f, 1.0f / 2560.0f, 1.0f / 640.0f, 1.0f / 256.0f
};

const uint32_t SetupMeasAllF[SETUP_ALLF_COUNT + 1] = { 400, 50, 400, 3200, 25600 };
const float SetupMeasFN[SETUP_FN_COUNT + 1] = { 1000.0f, 10000.0f, 2500.0f, 1000.0f, 250.0f, 100.0f };



// Avg
const uint32_t SETUP_AVG_DEFAULT = 0;	// SETUP_AVG_4_STOP
const uint32_t SETUP_AVG_NO			= 1;
const uint32_t SETUP_AVG_4			= 2;
const uint32_t SETUP_AVG_4_STOP		= 3;
const uint32_t SETUP_AVG_10			= 4;
const uint32_t SETUP_AVG_10_STOP	= 5;
const uint32_t SETUP_AVG_999		= 6;
const uint32_t SETUP_AVG_COUNT		= 6;
// AutoSave
const uint32_t SETUP_AUTO_SAVE_DEFAULT = 0; // SETUP_AUTO_SAVE_NO
const uint32_t SETUP_AUTO_SAVE_NO		= 1;
const uint32_t SETUP_AUTO_SAVE			= 2;
const uint32_t SETUP_AUTO_SAVE_COUNT	= 2;


const uint32_t SETUP_EXTERNAL_SENSOR	= 0;	// ������ ������� � �������
const uint32_t SETUP_INTERNAL_DAC		= 1;	// ������ ������� � ����������� ��� - ������������ ��� ���������� ������

const uint32_t SETUP_MODE_READ			= 0;	// ����� ���������
const uint32_t SETUP_MODE_CALIBRATION	= 1;	// ����� ���������� - ������ ��� �������������


// ������ ������ MUX
const uint32_t SETUP_MUX_STD_ACC	= 0; // std 3..10kHz
const uint32_t SETUP_MUX_STD_VEL	= 1; // std 3..10kHz
const uint32_t SETUP_MUX_STD_DISP	= 2; // std 3..10kHz
const uint32_t SETUP_MUX_LINE_ACC	= 3; // std no filter
const uint32_t SETUP_MUX_ENV_ACC	= 4; // env 0,5..10kHz
const uint32_t SETUP_MUX_SLOW_ACC	= 5; // slow 0,5..50Hz
const uint32_t SETUP_MUX_SLOW_VEL	= 6; // slow 0,5..50Hz
const uint32_t SETUP_MUX_SLOW_DISP	= 7; // slow 0,5..50Hz
const uint32_t SETUP_MUX_COUNT		= 8; 



// ������� ��������� ������
typedef struct
{
	uint32_t Changed;	// 1 = MeasureSetup ���������, �������� � Hardware

	uint32_t MeasurementMode;	// ��� ��������, SETUP_MSM_xxx

	// ��� ��������� �� 1 �� N - ������������� ������� ��������� � ���������
	uint32_t Path;		// SETUP_MSP_xxx
	uint32_t Channels;	// SETUP_MSC_xxx
	uint32_t Units;		// SETUP_MSU_xxx
	uint32_t Type;		// SETUP_MST_xxx

	uint32_t dX;		// SETUP_DX_xxx ��� SETUP_FN_xxx
	uint32_t AllX;		// SETUP_ALLX_xxx ��� SETUP_ALLF_xxx

	uint32_t Avg;		// SETUP_AVG_xxx
	uint32_t AutoSave;	// SETUP_AUTO_SAVE_xxx


	// ��� ������ ��� ����������� �������������:

	uint32_t InternalDAC; // ������������ ������: 0 - ���� � ��������, 1 - DAC
	uint32_t CalibrationMode; // 0 - ������, 1 - ����������
	
							  // ��� ������������ � ����������
	float FreqSin;	// �������, ��
	float AmplSin;	// ��������� ���, ������

	// ���� (Path == SETUP_MSP_MUX) ��� (Units == SETUP_MSU_MUX), �� ����� MUX ������ �� ����� ����
	uint32_t Mux;	// SETUP_MUX_xxx

	uint32_t Reserv[1];

} TMeasureSetup;
const size_t szTMeasureSetup = sizeof(TMeasureSetup);
static_assert(szTMeasureSetup == 64, "");




#endif

