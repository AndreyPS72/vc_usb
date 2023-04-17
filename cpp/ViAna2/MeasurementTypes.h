#ifndef _MEASUREMENTTYPES_H_
#define _MEASUREMENTTYPES_H_

#include <stdint.h>




// ��� ������ (Measurement Type)
namespace MeasurementType
{
	const uint32_t WAVEFORM = 0UL;		// ������
	const uint32_t SPECTRUM = 1UL;		// ������
	const uint32_t ENVELOPE = 2UL;		// ���������
	const uint32_t ENV_SPECTRUM = 3UL;	// ������ ���������
	const uint32_t RMS = 4UL;			// ���
	const uint32_t RMS_TABLE = 5UL;		// ������� ���
	const uint32_t RUN_UP = 6UL;		// ������-�����

	const uint32_t COUNT = 7UL;			// ����������
	const uint32_t VIBRO = 4UL;
	const uint32_t WAV_SP = 2UL;		// ������ ������ � ������
}


// ����������� ���������� (Measurement Units)
namespace MeasurementUnits
{
	const uint32_t ACCELERATION = 0UL;	// ���������, �/�2
	const uint32_t VELOCITY = 1UL;		// ��������, ��/�
	const uint32_t DISPLACEMENT = 2UL;	// �����������, ���
	const uint32_t VOLT = 3UL;			// ������, �, ��������
	const uint32_t TEMP = 4UL;			// �����������, ���� C
	const uint32_t FREQ = 5UL;			// �������, ��
	const uint32_t AMPER = 6UL;			// ���, �
	const uint32_t UBAR = 7UL;			// �������� ��������� �������� ��� UHF ���������
	const uint32_t DB = 8UL;			// ��������
	const uint32_t NONE = 9UL;			// �.�., ��� �������

	const uint32_t COUNT = 10UL;			// ����������
	const uint32_t VIBRO = 3UL;
}


// ������, �������� ��� - ��� ���������� ? (Show Value)
namespace ShowValue
{
	const uint32_t PEAK_TRUE = 0UL;	// ��� �� �������
	const uint32_t PP_TRUE = 1UL;	// ���-���, ������ �� �������
	const uint32_t RMS_TRUE = 2UL;	// ��� �� ������� ��� ����, ������ �������� �������
	const uint32_t RMS_WND = 3UL;	// ��� �� ������� � ����� 10..1000��, ��� ����������� 10..300��
									// ��� ViAna-2 ������ ��� ������������� � ��������� 10..1000��

	const uint32_t ZERO_LINE = 5UL;	// �������� ������� �����
	const uint32_t GE = 6UL;		// ��� �� ������ Acc Ge (Acc 500Hz..10kHz; SKF gE), �/�2
	const uint32_t SUM2 = 7UL;		// sum a^2
	const uint32_t SUM4 = 8UL;		// sum a^4
	const uint32_t ALLX = 9UL;		// ���������� �������� � ������� ��� �������

	// ��� ������ ��������� CH_TACH
	const uint32_t FREQ = 10UL;		// �������, ��

	// ��� ���������� ������� CH_FRF = CH_1:
	const uint32_t MODAL_FREQ1 = 11UL;	// Natural Frequency 1-�� ����
	const uint32_t MODAL_DLF1 = 12UL;	// Damping Loss Factor 1-�� ����

	// ��� �������� (��������� �� �������, ��� ��� ����������� �� �������, � �� � ValueInstantToValueAvg() ):
	const uint32_t RE1 = 26UL;		// Real 1 ��������� (Peak)
	const uint32_t IM1 = 27UL;		// Image 1 ��������� (Peak)
	const uint32_t RE2 = 28UL;		// Real 2 ��������� (Peak)
	const uint32_t IM2 = 29UL;		// Image 2 ��������� (Peak)
	const uint32_t RE3 = 30UL;		// Real 3 ��������� (Peak)
	const uint32_t IM3 = 31UL;		// Image 3 ��������� (Peak)


	const uint32_t COUNT = 32UL;

	// ����������� ����� ������ ���������
	const uint32_t CALCULATED_MASK = 32UL;		// �����, ��� �������� ����������� ����� ������ ���������

	const uint32_t PEAK_EQ = PEAK_TRUE | CALCULATED_MASK;	// ��� ������������� = svRMSTrue * M_SQRT2
	const uint32_t PP_EQ = PP_TRUE | CALCULATED_MASK;		// ���-��� ���, ������ ������������� = svRMSTrue * M_SQRT2 * 2
	const uint32_t RMS_WND2014 = RMS_WND | CALCULATED_MASK;	// ��� �� ������� �� �������� ����� �� ������ ���� 2954-2014 // ���� �� ������
	const uint32_t CREST_FACTOR = SUM2 | CALCULATED_MASK;	// ���-������ ����� svSum2
	const uint32_t EXCESS = SUM4 | CALCULATED_MASK;			// ������� ����� svSum4 / svSum2
	const uint32_t AMPL1 = RE1 | CALCULATED_MASK;			// ���� 1 ��������� (Peak) (����� Re1 Im1)
	const uint32_t PHASE1 = IM1 | CALCULATED_MASK;			// ���� 1 ��������� (Degr) (����� Re1 Im1)
	const uint32_t AMPL2 = RE2 | CALCULATED_MASK;			// ���� 2 ��������� (Peak) (����� Re2 Im2)
	const uint32_t PHASE2 = IM2 | CALCULATED_MASK;			// ���� 2 ��������� (Degr) (����� Re2 Im2)
	const uint32_t AMPL3 = RE3 | CALCULATED_MASK;			// ���� 3 ��������� (Peak) (����� Re3 Im2)
	const uint32_t PHASE3 = IM3 | CALCULATED_MASK;			// ���� 3 ��������� (Degr) (����� Re3 Im2)

	const uint32_t COUNT_CALC = COUNT + CALCULATED_MASK;
}


// ��������� - �������� (Machine State)
namespace MachineState
{
	const uint32_t NONE = 0UL;		// ��� ���������; ColorNavy
	const uint32_t GREEN = 1UL;
	const uint32_t YELLOW = 2UL;
	const uint32_t RED = 3UL;
	const uint32_t UNKNOWN = 4UL;		// ����������, �� ����������, ������ ��� �������� ==0; ����� ����
	const uint32_t COUNT = 5UL;
}



// ����� �� ������������� (NormsVel)
const uint32_t NORMS_VEL_COUNT = 13;
const float NormsVel[NORMS_VEL_COUNT] = { 0.0f,0.28f,0.45f,0.71f,1.12f,1.8f,2.8f,4.5f,7.1f,11.2f,18.0f,28.0f,45.0f };




// TTable.DataFormat - ������ ������������� �������� � TTable.OffT
namespace MeasurementDataFormat
{
	const uint8_t INT16_VALUE = 0;		// int16_t, 2 ����� �� ������, ����� �������� �� TTable.Scale
	const uint8_t INT32_VALUE = 1;		// int32_t, 4 �����, ����� �������� �� TTable.Scale
	const uint8_t FLOAT_VALUE = 2;		// float, 4 �����, �������� ����������� �������� (������ ��� ������), TTable.Scale �� ������������
	const uint8_t DOUBLE_VALUE = 3;		// double, 8 ����, �������� ����������� �������� (������ ��� ������), TTable.Scale �� ������������
	const uint8_t MASK_VALUE = 0x07;	// ����� ����������� ���� ������

										// �������������� �����:
	const uint8_t COMLEX_VALUE = 0x40;	// complex, x2 ����, ��������, ����������� ������, Re+Im
	const uint8_t LOG_VALUE = 0x80;		// ���������� �������� ��������
}


// TTable.DrawOptions - ��� ������������ ������
namespace DrawGraphOptions
{
	// ��� �������� ������
	const uint8_t DRAW_GRAPH_AS_LINE = 0;		// �������� ������ (������, �-�, Log ������)
	const uint8_t DRAW_GRAPH_AS_HISTOGRAM = 1;	// �������� ���������� (������� ������)
	const uint8_t DRAW_GRAPH_AS_MASK = 1;

	// ������� �� ��� Y
	const uint8_t DRAW_Y_AXE_SYMMETRICAL = 0 << 2; // AmplMin = -AmplMax (������)
	const uint8_t DRAW_Y_AXE_POSITIVE = 1 << 2; // AmplMin = 0 (������� ������)
	const uint8_t DRAW_Y_AXE_MINMAX = 2 << 2; // ��������� ���� AmplMin � AmplMax (Log ������)
	const uint8_t DRAW_Y_AXE_MASK = 3 << 2;
}



// ���� ����� ��������������� � ������
namespace SpectrumWindow
{
	const uint8_t NONE = 0;		//  ���� �� ���������
	const uint8_t HAMMING = 1;	//  ���� ��������, ��������� ��������� �� 1.8556668
	const uint8_t BLACKMAN_HARRIS = 2;	// ���� Blackman-Harris, �� ������� ���� ����� ����� 0.05 ��

	const uint8_t EXP = 7;		//  ��������������� ���������� ���� ��� ���������� �������
}


#endif


