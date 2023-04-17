#ifndef _MEASUREMENTTYPES_H_
#define _MEASUREMENTTYPES_H_

#include <stdint.h>




// Тип замера (Measurement Type)
namespace MeasurementType
{
	const uint32_t WAVEFORM = 0UL;		// Сигнал
	const uint32_t SPECTRUM = 1UL;		// Спектр
	const uint32_t ENVELOPE = 2UL;		// Огибающая
	const uint32_t ENV_SPECTRUM = 3UL;	// Спектр огибающей
	const uint32_t RMS = 4UL;			// СКЗ
	const uint32_t RMS_TABLE = 5UL;		// Таблица СКЗ
	const uint32_t RUN_UP = 6UL;		// Разгон-Выбег

	const uint32_t COUNT = 7UL;			// Количество
	const uint32_t VIBRO = 4UL;
	const uint32_t WAV_SP = 2UL;		// Только сигнал и спектр
}


// Размерность информации (Measurement Units)
namespace MeasurementUnits
{
	const uint32_t ACCELERATION = 0UL;	// Ускорение, м/с2
	const uint32_t VELOCITY = 1UL;		// Скорость, мм/с
	const uint32_t DISPLACEMENT = 2UL;	// Перемещение, мкм
	const uint32_t VOLT = 3UL;			// Вольты, В, Отметчик
	const uint32_t TEMP = 4UL;			// Температура, град C
	const uint32_t FREQ = 5UL;			// Частота, Гц
	const uint32_t AMPER = 6UL;			// Ток, А
	const uint32_t UBAR = 7UL;			// микробар звукового давления для UHF микрофона
	const uint32_t DB = 8UL;			// дециБелл
	const uint32_t NONE = 9UL;			// о.е., нед надписи

	const uint32_t COUNT = 10UL;			// Количество
	const uint32_t VIBRO = 3UL;
}


// Спектр, значение СКЗ - что показывать ? (Show Value)
namespace ShowValue
{
	const uint32_t PEAK_TRUE = 0UL;	// Пик по сигналу
	const uint32_t PP_TRUE = 1UL;	// Пик-Пик, Размах по сигналу
	const uint32_t RMS_TRUE = 2UL;	// СКЗ по сигналу без окна, только железные фильтры
	const uint32_t RMS_WND = 3UL;	// СКЗ по спектру с окном 10..1000Гц, для перемещения 10..300Гц
									// Для ViAna-2 всегда СКЗ ВИБРОСКОРОСТИ в диапазоне 10..1000Гц

	const uint32_t ZERO_LINE = 5UL;	// Смещение нулевой линии
	const uint32_t GE = 6UL;		// Пик по каналу Acc Ge (Acc 500Hz..10kHz; SKF gE), м/с2
	const uint32_t SUM2 = 7UL;		// sum a^2
	const uint32_t SUM4 = 8UL;		// sum a^4
	const uint32_t ALLX = 9UL;		// Количество отсчётов в сигнале для расчёта

	// для канала отметчика CH_TACH
	const uint32_t FREQ = 10UL;		// Частота, Гц

	// Для модального анализа CH_FRF = CH_1:
	const uint32_t MODAL_FREQ1 = 11UL;	// Natural Frequency 1-ой моды
	const uint32_t MODAL_DLF1 = 12UL;	// Damping Loss Factor 1-ой моды

	// Для синусоид (последние по индексу, так как усредняются по хитрому, а не в ValueInstantToValueAvg() ):
	const uint32_t RE1 = 26UL;		// Real 1 гармоники (Peak)
	const uint32_t IM1 = 27UL;		// Image 1 гармоники (Peak)
	const uint32_t RE2 = 28UL;		// Real 2 гармоники (Peak)
	const uint32_t IM2 = 29UL;		// Image 2 гармоники (Peak)
	const uint32_t RE3 = 30UL;		// Real 3 гармоники (Peak)
	const uint32_t IM3 = 31UL;		// Image 3 гармоники (Peak)


	const uint32_t COUNT = 32UL;

	// Вычисляемые через другие параметры
	const uint32_t CALCULATED_MASK = 32UL;		// Маска, что значение вычисляемое через другие параметры

	const uint32_t PEAK_EQ = PEAK_TRUE | CALCULATED_MASK;	// Пик эквивалентный = svRMSTrue * M_SQRT2
	const uint32_t PP_EQ = PP_TRUE | CALCULATED_MASK;		// Пик-Пик Экв, Размах эквивалентный = svRMSTrue * M_SQRT2 * 2
	const uint32_t RMS_WND2014 = RMS_WND | CALCULATED_MASK;	// СКЗ по спектру со странным окном по новому ГОСТ 2954-2014 // пока не считаю
	const uint32_t CREST_FACTOR = SUM2 | CALCULATED_MASK;	// Пик-фактор через svSum2
	const uint32_t EXCESS = SUM4 | CALCULATED_MASK;			// Эксцесс через svSum4 / svSum2
	const uint32_t AMPL1 = RE1 | CALCULATED_MASK;			// Ампл 1 гармоники (Peak) (через Re1 Im1)
	const uint32_t PHASE1 = IM1 | CALCULATED_MASK;			// Фаза 1 гармоники (Degr) (через Re1 Im1)
	const uint32_t AMPL2 = RE2 | CALCULATED_MASK;			// Ампл 2 гармоники (Peak) (через Re2 Im2)
	const uint32_t PHASE2 = IM2 | CALCULATED_MASK;			// Фаза 2 гармоники (Degr) (через Re2 Im2)
	const uint32_t AMPL3 = RE3 | CALCULATED_MASK;			// Ампл 3 гармоники (Peak) (через Re3 Im2)
	const uint32_t PHASE3 = IM3 | CALCULATED_MASK;			// Фаза 3 гармоники (Degr) (через Re3 Im2)

	const uint32_t COUNT_CALC = COUNT + CALCULATED_MASK;
}


// Состояние - светофор (Machine State)
namespace MachineState
{
	const uint32_t NONE = 0UL;		// Нет состояния; ColorNavy
	const uint32_t GREEN = 1UL;
	const uint32_t YELLOW = 2UL;
	const uint32_t RED = 3UL;
	const uint32_t UNKNOWN = 4UL;		// Неизвестно, не вычисленно, обычно для значения ==0; Серый цвет
	const uint32_t COUNT = 5UL;
}



// Нормы по виброскорости (NormsVel)
const uint32_t NORMS_VEL_COUNT = 13;
const float NormsVel[NORMS_VEL_COUNT] = { 0.0f,0.28f,0.45f,0.71f,1.12f,1.8f,2.8f,4.5f,7.1f,11.2f,18.0f,28.0f,45.0f };




// TTable.DataFormat - Формат представления отсчётов в TTable.OffT
namespace MeasurementDataFormat
{
	const uint8_t INT16_VALUE = 0;		// int16_t, 2 байта на отсчёт, нужно умножить на TTable.Scale
	const uint8_t INT32_VALUE = 1;		// int32_t, 4 байта, нужно умножить на TTable.Scale
	const uint8_t FLOAT_VALUE = 2;		// float, 4 байта, реальное амплитудное значение (сигнал или спектр), TTable.Scale не используется
	const uint8_t DOUBLE_VALUE = 3;		// double, 8 байт, реальное амплитудное значение (сигнал или спектр), TTable.Scale не используется
	const uint8_t MASK_VALUE = 0x07;	// маска определения типа данных

										// Дополнительные Маски:
	const uint8_t COMLEX_VALUE = 0x40;	// complex, x2 байт, например, комплексный спектр, Re+Im
	const uint8_t LOG_VALUE = 0x80;		// десятичный логарифм значения
}


// TTable.DrawOptions - Как отрисовывать график
namespace DrawGraphOptions
{
	// Как рисовать график
	const uint8_t DRAW_GRAPH_AS_LINE = 0;		// Рисовать линией (Сигнал, Р-В, Log Спектр)
	const uint8_t DRAW_GRAPH_AS_HISTOGRAM = 1;	// Рисовать столбиками (обычный Спектр)
	const uint8_t DRAW_GRAPH_AS_MASK = 1;

	// Пределы по оси Y
	const uint8_t DRAW_Y_AXE_SYMMETRICAL = 0 << 2; // AmplMin = -AmplMax (Сигнал)
	const uint8_t DRAW_Y_AXE_POSITIVE = 1 << 2; // AmplMin = 0 (обычный Спектр)
	const uint8_t DRAW_Y_AXE_MINMAX = 2 << 2; // Учитывать поля AmplMin и AmplMax (Log Спектр)
	const uint8_t DRAW_Y_AXE_MASK = 3 << 2;
}



// Окно перед преобразованием в Спектр
namespace SpectrumWindow
{
	const uint8_t NONE = 0;		//  Окно не требуется
	const uint8_t HAMMING = 1;	//  Окно Хемминга, Результат домножить на 1.8556668
	const uint8_t BLACKMAN_HARRIS = 2;	// Окно Blackman-Harris, на спектре тока видно линии 0.05 Гц

	const uint8_t EXP = 7;		//  Экспоненциально затухающее окно для модального анализа
}


#endif


