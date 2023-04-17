#ifndef _DEFS_VIANA2_H
#define _DEFS_VIANA2_H



// Max ������������ ��������� ����� �������
const uint32_t CHANNEL_COUNT = 3UL;

// ��� �����, ������� ���� �� ������
const uint32_t CH_1 = 0UL;		// ����� 1
const uint32_t CH_2 = 1UL;		// ����� 2
const uint32_t CH_TACH = 2UL;	// ��������

const uint32_t CH_VIBRO = 2UL; // 2 �����������
const uint32_t CH_COUNT = CHANNEL_COUNT;


const uint32_t MAX_POINT = 64UL * 1024UL;  //������������ ����� ����� � ������ �������� ������
const uint32_t MAX_POINT_RECORDER = 512UL * 1024UL;  //������������ ����� ����� � ������ �������� ������, �.�. >= MAX_POINT * 2


const float ADC_FREQUENCY = 25602.4102f; // ������������ ������������� ������� ���������� ���


#endif 

