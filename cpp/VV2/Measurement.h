#ifndef Measurement_h_
#define Measurement_h_

#include "TypesDef.h"
#include "MeasurementTypes.h"

#include <stdint.h>

#define BITFLAG(b) (1UL<<(b))



//       uint32_t Exist; // 0=teNo -  нет; 1=teHard - сигнал c железного канала; 2=teSoft - преобразованный
#define teNo        (0)
#define teHard      (1)
#define teSoft      (2)

// Структура используется для сохранения во Flash, желательно не менять
typedef struct stTable
{

	uint32_t Exist; // 0=teNo -  нет; 1=teHard - сигнал c железного канала; 2=teSoft - преобразованный
	//       uint32_t State;
	_TDateTime DT;       //Время и дата проведения замера

	uint32_t Type;
	uint32_t Units;
	uint32_t AllX;

	float X0;
	float dX;
	float XN;

#ifdef __Viana2
	float AmplMax;   // Максимальное значение в сигнале
	float AmplMin;   // Минимальное значение в сигнале
#else
	int32_t Ampl;   // Максимальное значение в отсчетах
#endif
	float Scale;

	uint32_t OffT;			// Смещение данных канала в файле или адрес в памяти
#ifdef __Viana2
	uint32_t OffTx64;		// Запас для адреса x64

	uint8_t Reserv1[2];
	uint8_t DataFormat;		// Формат представления отсчётов в OffT - MeasurementDataFormat::XXX
	uint8_t DrawOptions;	// Как отрисовывать график - DrawGraphOptions::XXX
#endif
	
	// Длина данных в файле или в памяти в байтах - может быть равна 0. 
	// Для сигнала = AllX * szTOnePoint
	// Для комплексного спектра = AllX * 2 * szTOnePoint
	uint32_t LenT;

	uint32_t Tick;           // Tick1024 для учета быстрых замеров

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

bool IsWaveform(uint32_t aType); // true = Какой-то сигнал
bool IsSpectrum(uint32_t aType); // true = Какой-то спектр
bool IsWaveformOrSpectrum(uint32_t aType);  // true = Какой-то сигнал либо спектр (не СКЗ)
bool IsEnvelopeData(uint32_t aType);  // true = Сигнал или спектр огибающей






// Сбросить замеры
void ClearMeas(void);
void ClearAvgValues(void);

TTable* GetTable(uint32_t aChan, uint32_t aType, uint32_t aUnits);
TTable* GetTable(uint32_t aChan, uint32_t aType);




// Значение по каналу, усреднённое по нескольким измерениям
// Если нет, то посчитать на ходу
float GetValue(uint32_t aChan, uint32_t aUnits, uint32_t aSV);


// Текущее (мгновенное) значение по каналу, не усреднённое
// Если нет, то посчитать на ходу
float GetValueInstant(uint32_t aChan, uint32_t aUnits, uint32_t aSV);



// Посчитать Состояние по СКЗ виброскорости и нормам
uint32_t CalcState(float RMS, uint32_t NormIndexW, uint32_t NormIndexA);


extern float BearingTemp; // Температура в град Цельсия


float GetCurrentTempValue(void);
uint32_t CalcTempState(float aTemp);

// Возвращает текущий подключенный канал; -1 = не нашел
int32_t GetVibroChannel(void);






// Выбирает в сигнале CH от отсчёта aLeft до aRight-1 максимальное и минимальное значения
void WaveformMinMax(TTable* CH, int32_t aLeft, int32_t aRight, float* aMin, float* aMax);

// Выбирает в спектре CH от отсчёта aLeft до aRight-1 максимальное значение (его индекс = *Num; Num можно делать = NULL)
float SpectrumMax(TTable* CH, int32_t aLeft, int32_t aRight, int32_t* Num);










// Измерено точно
#define ADCFreqUHF (186915) // Hz

//_______________________________________________________________
// Envelope




// Делаем огибающую 1 кГц, 1024 отсчета
#define ENV_FREQ (1000)
#define ENV_COUNT (1024)
// Буфер на 2 секунды + запас
#define MaxDataBufEnvLen (ENV_COUNT*3)


//  Огибающая
typedef struct stEnvelopeRes
{
	uint32_t Exist;
	uint32_t Version;
	_TDateTime DT;       //Время и дата проведения замера

	uint32_t Type;
	uint32_t AllX;
#ifdef __Viana2
	uint32_t Align;
	uint32_t DataBufx64;		// Запас для адреса x64
#endif
	s16* DataBuf;
	float Scale;
	float dX; // Шаг по X в мс
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
	float RMS; //  СКЗ ускорения
	float CrestFactor; //  Пик-фактор
	float Excess; // Эксцесс
	uint32_t StateCrestFactor;
	uint32_t StateExcess;

	uint32_t Tick;            // Tick для учета быстрых замеров

	float gE; // gE 0,5-10 кГц
	uint32_t StateGE;

	uint32_t Reserv[20];

} TEnvelopeRes;
const size_t szTEnvelopeRes = sizeof(TEnvelopeRes);
static_assert(szTEnvelopeRes == 256U, "");


extern TEnvelopeRes Env;

// Скорость звука в воздухе
#define AirSpeed 340.0 // m/sec

// Расчет спектра огибающей
void CalcEnvelopeSpectrum(TEnvelopeRes* Env);







// ============ Для сохранения во Flash ===================

// определяется количеством кластеров во флешке
// в 0 ничего не пишется
// в последний пишется структура директориев
// в предпоследний шаблоны схем
// Для флешки K9F2G08U0A
#define MaxMeasurements (16384-3)



// Заголовок замера во FLASH
typedef struct stParameters
{
	//Шапка

	uint32_t        Type;           //Тип замера (u8)
	uint32_t        ID;             //Идентификатор замера
	uint32_t        Num;            //Номер замера

	// Дата и время замера
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

	uint32_t MeasType;                   // Что записано

	float Value;                   // Значение для RMS мкВ

	//Данные замера

	// Index: 0=Data, 1=Data2
	uint32_t Data[4];                   // Смещение Данных, Доп Смещение в файле
	uint32_t DataLen[4];                // Длина данных, Доп Длина
	u8 compressed[4];              // 0 - без сжатия, 1 - ZIP;

	uint32_t reserved[8];

	TCRC empty; // Для выравнивания
	TCRC CRC;
} TParameters;

#define szstParameters sizeof(struct stParameters)
#define szParameters szstParameters
const size_t szTParameters = sizeof(TParameters);	// 100 bytes
static_assert(szTParameters == 100, "");


#endif


