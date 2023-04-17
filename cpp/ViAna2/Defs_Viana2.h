#ifndef _DEFS_VIANA2_H
#define _DEFS_VIANA2_H



// Max теоретически возможное число каналов
const uint32_t CHANNEL_COUNT = 3UL;

// Тип входа, порядок окон на экране
const uint32_t CH_1 = 0UL;		// канал 1
const uint32_t CH_2 = 1UL;		// канал 2
const uint32_t CH_TACH = 2UL;	// Отметчик

const uint32_t CH_VIBRO = 2UL; // 2 виброканала
const uint32_t CH_COUNT = CHANNEL_COUNT;


const uint32_t MAX_POINT = 64UL * 1024UL;  //максимальное число точек в данных простого замера
const uint32_t MAX_POINT_RECORDER = 512UL * 1024UL;  //максимальное число точек в данных длинного замера, д.б. >= MAX_POINT * 2


const float ADC_FREQUENCY = 25602.4102f; // Определяется дискретностью таймера прерывания АЦП


#endif 

