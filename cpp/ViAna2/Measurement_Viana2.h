#ifndef _MEASUREMENT_VIANA2_H
#define _MEASUREMENT_VIANA2_H

#include "Defs_Viana2.h"
#include "MeasurementTypes.h"
#include "Measurement.h"
#include "MeasureSetupDefs.h"
#include "BalanceDefs.h"
#include <stdint.h>





#define FILE_VERSION_VIANA2_0100    0xC710 // Новая версия файла 1.0
#define FILE_VERSION_VIANA2_CURRENT FILE_VERSION_VIANA2_0100




static_assert(szTTable == 88, "");



typedef struct stOneChannel
{

	uint32_t Exist; // 0=teNo -  нет; 1=teHard - сигнал c железного канала; 2=teSoft - преобразованный
	uint32_t Align1;

	float ValueInstant[ShowValue::COUNT];	// Посчитанные по сигналу/спектру текущее (мгновенное) значение Peak, P-P, RMS, Zero, ...
	uint32_t ValueHarmonicsCalculatedTick; // Tick1024 последнего посчитанного RE1..IM3. Они считаются долго, так что вычисляем только по запросу
	uint32_t ValueInstantCalculated;	// Флажки, какие из ValueInstant посчитаны

	float ValueAvg[ShowValue::COUNT]; // Усреднённые по посчитанным по сигналу/спектру Peak, P-P, RMS, Zero, ...
	uint32_t ValueAvgCalculatedTick; // Tick1024 последнего усреднённого замера из ValueInstant в ValueAvg
	uint32_t ValueAvgCalculated;	// Флажки, какие из ValueAvg посчитаны

	TTable Table[MeasurementType::WAV_SP];

	uint32_t Reserv[14];

} TOneChannel;
const size_t szTOneChannel = sizeof(TOneChannel);
static_assert(szTOneChannel == 512, "");



// Структура для записи в файл, без причины не менять
typedef struct
{

	uint16_t Exist;	// 0=teNo -  нет; 1=teHard - сигнал c железного канала; 2=teSoft - преобразованный
	uint16_t Version;
	
	_TDateTime DT;       // Время и дата начала начала замера
	uint32_t LastDataTick;  // Tick1024 начала замера или последнее добавление сегмента для длинных замеров (и для учета замеров короче 1 сек) 
	uint32_t Align1;

	TMeasureSetup MeasSetup; //  Что измеряем ? чтобы знать, как обрабатывать

	uint32_t Count;          // Число каналов вибрации
	uint32_t Channels;       // Маска подключенных датчиков

	// Что записано в замере
	uint32_t Type;
	uint32_t Units;

	float FreqTach;    // Частота по отметчику

	float TempValue;    // Температура, град Цельсия

	// Усреднений Сколько / Из скольки
	uint32_t SpectrumAvg;
	uint32_t SpectrumAvgMax;

	float FHP;          // Верхняя частота фильтра
	float FLP;          // Нижняя частота фильтра

	// Таблицы Каналов с Сигналами-Спектрами
	TOneChannel CH[CHANNEL_COUNT]; 

	uint32_t Reserv[65];

	TCRC Align; // Для выравнивания
	TCRC CRC;

} TMeas;
const size_t szTMeas = sizeof(TMeas);
static_assert(szTMeas == 1920, "");	// 8 * 256 - 128


/*
Для сигнала: float X[0],X[1],...,X[AllX-1]
Для комплексного спектра: float Re[0],Im[0],Re[1],Im[1],...,Re[AllX-1],Im[AllX-1]
*/



typedef float TOnePoint;	// Отсчёты хранятся в float
const size_t szTOnePoint = sizeof(TOnePoint);

//typedef TOnePoint TOneChannelData[MAX_POINT]; // Массив данных одного канала
//const size_t szTOneChannelData = sizeof(TOneChannelData);

typedef TOnePoint TOneChannelRecorder[MAX_POINT_RECORDER + MAX_POINT]; // Массив данных одного канала (Сигнал + Спектр)
const size_t szTOneChannelRecorder = sizeof(TOneChannelRecorder);



#define WAVEFORM(CH,i) (assert((i) >= 0 && (i) < (int)(CH)->AllX), ((TOnePoint*)((CH)->OffT))[(i)]) // Отсчёт сигнала или REAL спектра
#define SPECTRUM_REAL_AMPL(CH,i) (assert((i) >= 0 && (i) < (int)(CH)->AllX), ((TOnePoint*)((CH)->OffT))[(i)]) // Ампл REAL спектра

#define SPECTRUM_RE(CH,i) (assert((i) >= 0 && (i) < (int)(CH)->AllX), ((TOnePoint*)((CH)->OffT))[(i)<<1]) // RE комплексного спектра
#define SPECTRUM_IM(CH,i) (assert((i) >= 0 && (i) < (int)(CH)->AllX), ((TOnePoint*)((CH)->OffT))[((i)<<1)+1]) // IM комплексного спектра
#define SPECTRUM_PHASE(CH,i) (arctan2f(SPECTRUM_IM(CH,i),SPECTRUM_RE(CH,i))) // Возвращает Фазу спектральной линии комплексного спектра в рад

TOnePoint SPECTRUM_COMPLEX_AMPL2(TTable* CH, uint32_t i); // Возвращает Ампл^2 спектральной линии комплексного спектра
TOnePoint SPECTRUM_COMPLEX_AMPL(TTable* CH, uint32_t i); // Возвращает Ампл спектральной линии комплексного спектра






// Замер СКЗ для Авроры
const uint32_t AURORA_CELL_MAX_POINTS = 14; // Точек
const uint32_t AURORA_CELL_MAX_AXES = 3; // Направлений

const uint32_t POINT_READED_MASK = 0x07; // Прочитаны ВПО


typedef struct
{
	uint16_t Exist;
	uint16_t Version;
	_TDateTime DT;       //Время и дата проведения замера

	TMeasureSetup MeasSetup; //  Что измеряем ? чтобы знать, как обрабатывать

	float Value[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES][MeasurementUnits::VIBRO]; // Значения в соответствии с ValueViewMode
	float Temp[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES];

	uint8_t PointReaded[AURORA_CELL_MAX_POINTS]; // Битовая маска для каждой точки, прочитан ли канал: 1 - В; 2 - П; 4 - О;
	uint16_t Align2;

	// Поля для Viana2 вместо Diag
	uint8_t ValueViewMode[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES][MeasurementUnits::VIBRO]; // Что лежит в Value, например, svRMS
	uint16_t Align3;

	float RMSVelocityValue[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES]; // Значения RMS Vel для вычисления состояния

	// Поля для Viana2 вместо Diag
	uint8_t Channel[AURORA_CELL_MAX_POINTS][AURORA_CELL_MAX_AXES]; // С какого канала измерено значение (CH_1 или CH_2)
	uint16_t Align4;

	uint32_t Reserv[44];

	TCRC Align; // Для выравнивания
	TCRC CRC;

} TRMSMeasurementViana2;
const size_t szTRMSMeasurementViana2 = sizeof(TRMSMeasurementViana2);
static_assert(szTRMSMeasurementViana2 == 1280, "");










// Глобальные переменные:

// Замер Waveform/Spectrum
extern TMeas* MeasRef;
extern TOnePoint* MeasDataRef;

void SwitchMeasRefToRead(void);
void SwitchMeasRefToView(void);


// Замер RMS
extern TRMSMeasurementViana2* RMSRef;

void SwitchRMSRefToRead(void);
void SwitchRMSRefToView(void);


void ClearRMSMeas(void);


// Адрес в массиве MeasData
// Прсваивать Table.OffT через эту функцию
uint32_t GetMeasDataAddr(uint32_t aChannel, uint32_t aType);


// true - замер есть
bool IsMeasurementExists(void);

// Дата+Время+Tick1024 последнего обновления замера
uint64_t MeasurementTime(void);

TOneChannel* GetChannel(uint32_t aChan);


float AddAvgValue(uint32_t ch, uint32_t sv, float aValue);


// Скопировать MeasRead в MeasView
// Возвращает длину массива отсчётов в байтах
uint32_t CopySpectrumMeasurementToView(u32 aType, u32 aUnits);


float AccTodB(float aAcc); // м/с2 в дБ
float dBToAcc(float dB); // дБ в м/с2

// Расчет параметров по сигналу огибающей
void CalculateEnvelopeRes_Viana2(uint32_t aChan, TEnvelopeRes* Env);


// Усреднить все ValueInstant в ValueAvg, 
// кроме RE1..IM3 - они вычисляются по отдельному запросу, потому-что медленно
void ValueInstantToValueAvg(uint32_t aChan);


// Посчитать Ампл и Фазу гармоники 1..3 Герцелем
// Сохранить в ValueInstant[ShowValue::REx, IMx]
bool CalcAmplPhaseChannel(uint32_t aChan, float aFreq);

// Вычисляет действительную и мнимую часть гармоники Freq
bool CalcAmplPhaseComplex(TTable* CH, float Freq, float* Re, float* Im);


#endif
