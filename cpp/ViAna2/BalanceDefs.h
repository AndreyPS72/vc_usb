#ifndef _BalanceDefs_h_
#define _BalanceDefs_h_

// Использую стандартные типы данных для совместимости
#include <stdint.h>

#include "Measurement.h"
#include "Defs_Viana2.h"
#include "DrvFlash.h"


#define _USE_MATH_DEFINES
#include <math.h>


const uint32_t BALANCE_MAX_POINTS_PLANES = CH_VIBRO;	// До 2 точек измерения и до 2 плоскостей коррекции. Обязательно равны 2
//const uint32_t BALANCE_MAX_HARMONICS = 10;	// До 10 гармоник измерения
const uint32_t BALANCE_MAX_RUNS = 20;	// До 20 пусков: #0; 2 тестовых; Контрольный и т.д.
const uint32_t BALANCE_CALC_RUNS = BALANCE_MAX_POINTS_PLANES + 1;	// Пуски для расчёта: #0 + 2 тестовых


const uint32_t BALANCE_PLANE_1 = CH_1;
const uint32_t BALANCE_PLANE_2 = CH_2;

const uint32_t BALANCE_CALC_RUN_0 = 0;	// Пуски #0
const uint32_t BALANCE_CALC_RUN_TEST_1 = 1;	// Пуски #1
const uint32_t BALANCE_CALC_RUN_TEST_2 = 2;	// Пуски #2


//const uint16_t BALANCE_SETUP_VERSION = 0x7920;	// Версия настроек 2.0
//const uint16_t BALANCE_DATA_VERSION	= 0x5C20;	// Версия данных балансировки 2.0

const uint32_t BALANCE_NAME_LEN = 32;


// Настройки количества плоскостей и точек
const uint32_t BALANCE_CONFIGURATION_1X1 = 1;	// 1 плоскость коррекции x 1 точка измерения
const uint32_t BALANCE_CONFIGURATION_1X2 = 2;	// 1 плоскость коррекции x 2 точки измерения
const uint32_t BALANCE_CONFIGURATION_2X2 = 3;	// 2 плоскости коррекции x 2 точки измерения


// Настройки Диапазона Оборотной частоты
const uint32_t BALANCE_BAND_300_1000_RPM_5_17_HZ = 1;	// От 300 до 1000 rpm (5-17 Гц)
const uint32_t BALANCE_BAND_1K_4K_RPM_17_67_HZ = 2;	// От 1k до 4k rpm (17-67 Гц)
const uint32_t BALANCE_BAND_4K_30K_RPM_67_500_HZ = 3;	// От 4k до 30k rpm (67-500 Гц)


// Настройки Направления Вращения ротора
const uint32_t BALANCE_ROTATION_CLOCKWISE = 1;	// Ротор вращается по часовой стрелке
const uint32_t BALANCE_ROTATION_COUNTER_CLOCKWISE = 2;	// Ротор вращается против часовой стрелки



// Настройки Метода Балансировки Method
const uint32_t BALANCE_METHOD_BALANCING = 1;	// Балансировка (по 1 гармонике)
const uint32_t BALANCE_METHOD_VIBRATION_EQUALIZE = 2;	// Выравнивание вибрации по точкам
//const uint32_t BALANCE_METHOD_VIBRATION_REDUCTION = 3;	// Успокоение (по 10 гармоникам)


// Настройки Типа Расчёта (полный / по коэф) Calculation
const uint32_t BALANCE_CALCULATION_FULL = 1;	// полный
const uint32_t BALANCE_CALCULATION_COEFF = 2;	// по коэф



const uint32_t BALANCE_DEGREE_COUNT = 360 / 10 + 1;




typedef struct
{

	char Name[BALANCE_NAME_LEN]; // Наименование настроек

	uint32_t Configuration;	// Настройки количества плоскостей и точек

	uint32_t RPMBand;	// Диапазон Оборотной частоты

	uint32_t Units;	// Балансируем по MeasurementUnits::VELOCITY или MeasurementUnits::DISPLACEMENT

	uint32_t Rotation;	// Настройки Направления Вращения ротора

	int32_t TachAngle;	// Реальный Угол установки отметчика

	int32_t SensorAngle[CH_VIBRO];	// Реальный Угол установки датчика

	uint32_t Method;	// Настройки Метода Балансировки (Балансировка / Успокоение)

	uint32_t Calculation;	// Настройки Типа Расчёта (полный / по коэф)

	uint32_t Reserv[15];

} TBalanceSetup;

const size_t szTBalanceSetup = sizeof(TBalanceSetup);
static_assert(szTBalanceSetup == 128, "");








// Данные пуска по одному каналу (датчику)
typedef struct
{
	uint32_t Exist;

	// 1 = Ампл и Фазу 1-ой гармоники ввели вручную - доступнен расчёт только по 1-ой гармонике
	uint8_t ManualInput;
	uint8_t Reserv1[3];

	// Вибрация (СКЗ * sqrt2) для режима "Выравнивание", Пик
	float Vibration;

	// 1 гармоника, Пик, полярные координаты
	float Ampl;
	float Angle; // Угол в град

	uint32_t Reserv[7];

} TBalanceRunSensorVibrationData;
const size_t szTBalanceRunChannelData = sizeof(TBalanceRunSensorVibrationData);
static_assert(szTBalanceRunChannelData == 48, "");



// Данные с массами по одной плоскости
typedef struct
{
	uint32_t Exist;

	// Установленная масса, полярные координаты
	float Weight;
	float Angle; // Угол в град

	uint32_t Reserv[5];

} TBalanceRunPlaneWeightData;
const size_t szTBalanceRunPlaneWeightData = sizeof(TBalanceRunPlaneWeightData);
static_assert(szTBalanceRunPlaneWeightData == 32, "");





// Требуется IAR Project Option -> Language 1 -> C++ dialect == C++
#include <complex>
using namespace std;
typedef complex<float> TComplex;

// Расчёт вибрации
typedef struct
{
	uint32_t Exist;

	// Исходные данные по пускам
	TComplex Vibration[BALANCE_CALC_RUNS][CH_VIBRO];
	TComplex TestWeights[BALANCE_CALC_RUNS][BALANCE_MAX_POINTS_PLANES];

	TComplex Coeff[BALANCE_MAX_POINTS_PLANES][CH_VIBRO]; // Коэф влияния

	TComplex CalcWeights[BALANCE_MAX_POINTS_PLANES]; // Расчитанные массы по плоскостям

	TComplex CalcVibration[CH_VIBRO];	// Остаточная вибрация по датчикам

} TBalanceCalculation;
const size_t szTBalanceCalculation = sizeof(TBalanceCalculation);
static_assert(szTBalanceCalculation == 164, "");





// Один пуск с данными
typedef struct
{
	uint32_t Exist;
	_TDateTime DT;		//Время и дата проведения замера

	int32_t RunNumber; // Номер пуска
	int32_t CalcNumber; // Номер пуска в расчётах; 0..2

	TID ID;		// id замера

	uint32_t Units;

	float Freq;	// Частота, Гц 
	TBalanceRunSensorVibrationData	VibrationData[CH_VIBRO];
	TBalanceRunPlaneWeightData		WeightData[BALANCE_MAX_POINTS_PLANES];

	uint32_t Reserv[17];

} TBalanceRunData;
const size_t szTBalanceRunData = sizeof(TBalanceRunData);
static_assert(szTBalanceRunData == 256, "");





// Данные по балансировке
// Сохраняются в файл
typedef struct
{

	uint32_t Exist;	// 0=teNo -  нет; 1=teHard - сигнал c железного канала; 2=teSoft - преобразованный
	uint32_t Version;
	_TDateTime DT;		//Время и дата проведения балансировки

	TBalanceSetup BalanceSetup;	// Настройки

	uint32_t RunCount;	// Количество пусков
	TBalanceRunData	RunData[BALANCE_MAX_RUNS];	// Пуски: #0; 2 тестовых; Контрольный

	TBalanceCalculation BalanceCalculation; // Расчёты

	TID FramID; // записывается ID файла при сохранении/восстановлении из FRAM

	uint32_t Reserv[177];

	TCRC Align; // Для выравнивания
	TCRC CRC;

} TBalanceData;
const size_t szTBalanceData = sizeof(TBalanceData);
static_assert(szTBalanceData == 6144, ""); // 24*256





// Индекс в массиве Plane.Values[]
const uint32_t BALANCE_INDEX_VIBRATION_AMPL = 0;	// Амплитуда тяжелой точки
const uint32_t BALANCE_INDEX_VIBRATION_ANGLE = 1;	// Угол тяжелой точки
const uint32_t BALANCE_INDEX_WEIGHT_MASS = 2;	// Масса груза
const uint32_t BALANCE_INDEX_WEIGHT_ANGLE = 3;	// Угол груза

const uint32_t BALANCE_INDEX_MASK_ANGLE = 1;	// Все индексы углов имеют этот бит
const uint32_t BALANCE_INDEX_COUNT = 4;



// Что рисовать в схеме и панели
const uint32_t BALANCE_MASK_DRAW_VIBRATION_AMPL = (1UL << BALANCE_INDEX_VIBRATION_AMPL);
const uint32_t BALANCE_MASK_DRAW_VIBRATION_ANGLE = (1UL << BALANCE_INDEX_VIBRATION_ANGLE);
const uint32_t BALANCE_MASK_DRAW_VIBRATION = (BALANCE_MASK_DRAW_VIBRATION_AMPL | BALANCE_MASK_DRAW_VIBRATION_ANGLE);
const uint32_t BALANCE_MASK_DRAW_WEIGHT_MASS = (1UL << BALANCE_INDEX_WEIGHT_MASS);
const uint32_t BALANCE_MASK_DRAW_WEIGHT_ANGLE = (1UL << BALANCE_INDEX_WEIGHT_ANGLE);
const uint32_t BALANCE_MASK_DRAW_WEIGHT = (BALANCE_MASK_DRAW_WEIGHT_MASS | BALANCE_MASK_DRAW_WEIGHT_ANGLE);
const uint32_t BALANCE_MASK_DRAW_TACH = (1UL << 6);
const uint32_t BALANCE_MASK_DRAW_SENSOR = (1UL << 7);


// Ручной ввод значений
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





// Балансировка
extern TBalanceData* BalanceRef;

void SwitchBalanceRefToRead(void);
void SwitchBalanceRefToView(void);

// Сбросить в параметры по-умолчанию
void ZeroBalanceSetup(TBalanceSetup* aBalanceSetup);

bool ClearBalanceMeas(void);

#endif


