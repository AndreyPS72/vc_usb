unit LinkTypesViana2;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses  LinkTypes
      ;




{$R-}




// Тип замера
const _Viana2_ztWaveform        = 0;     // Сигнал
const _Viana2_ztSpectrum        = 1;     // Спектр
const _Viana2_ztEnvelope        = 2;     // Огибающая
const _Viana2_ztEnvSpectrum     = 3;     // Спектр огибающей
const _Viana2_ztRMS             = 4;     // СКЗ
const _Viana2_ztRMSTable        = 5;     // Таблица СКЗ
const _Viana2_ztRUN_UP 			= 6;		// Разгон-Выбег

const _Viana2_ztCount           = 7;     // Количество
const _Viana2_ztVibro           = 4;
const _Viana2_ztWavSp           = 2;	// Только сигнал и спектр


//--- Размерность информации
const  _Viana2_eiAcceleration    = 0;   // Ускорение, м/с2
const  _Viana2_eiVelocity        = 1;   // Скорость, мм/с
const  _Viana2_eiDisplacement    = 2;   // Перемещение, мкм
const  _Viana2_eiVolt            = 3;   // Вольты, В
const  _Viana2_eiTemp            = 4;   // Температура, град C
const  _Viana2_eiFreq            = 5;   // Частота, Гц
const  _Viana2_eiAMPER 			= 6;			// Ток, А
const  _Viana2_eiUBAR 			= 7;			// микробар звукового давления для UHF микрофона
const  _Viana2_eiDB 			= 8;			// дециБелл
const  _Viana2_eiNONE 			= 9;			// о.е., нед надписи

const  _Viana2_eiCount           = 10; // Количество
const  _Viana2_eiVibro           = 3;


// Спектр, значение СКЗ - что показывать ? (Show Value)
const _Viana2_svPeak_True       = 0;	// Пик по сигналу    
const _Viana2_svPP_True         = 1;    // Пик-Пик, Размах по сигналу
const _Viana2_svRMS_True        = 2;    // СКЗ по сигналу без окна, только железные фильтры
const _Viana2_svRMS_Wnd         = 3;    // СКЗ по спектру с окном 10..1000Гц, для перемещения 10..300Гц
const _Viana2_svZERO_LINE       = 5;    // Смещение нулевой линии
const _Viana2_svGE 				= 6;		// Пик по каналу Acc Ge (Acc 500Hz..10kHz; SKF gE), м/с2
const _Viana2_svSUM2          	= 7;    // sum a^2
const _Viana2_svSUM4          	= 8;    // sum a^4
const _Viana2_svALLX 			= 9;		// Количество отсчётов в сигнале для расчёта

// для канала отметчика CH_TACH
const _Viana2_svFREQ 			= 10;		// Частота, Гц

// Для модального анализа CH_FRF = CH_1:
const _Viana2_svMODAL_FREQ1 	= 11;	// Natural Frequency 1-ой моды
const _Viana2_svMODAL_DLF1 		= 12;	// Damping Loss Factor 1-ой моды

const _Viana2_svRE1           	= 26;   // Real 1 гармоники (Peak)
const _Viana2_svIM1           	= 27;   // Image 1 гармоники (Peak)
const _Viana2_svRE2           	= 28;   // Real 2 гармоники (Peak)
const _Viana2_svIM2           	= 29;   // Image 2 гармоники (Peak)
const _Viana2_svRE3           	= 30;   // Real 3 гармоники (Peak)
const _Viana2_svIM3           	= 31;   // Image 3 гармоники (Peak)

const _Viana2_svCOUNT          	= 32;

// Вычисляемые через другие параметры
const _Viana2_svCALCULATED_MASK          	= 32;	// Маска, что значение вычисляемое через другие параметры

const _Viana2_svPEAK_EQ 	= _Viana2_svPEAK_TRUE or _Viana2_svCALCULATED_MASK;	// Пик эквивалентный = svRMSTrue * M_SQRT2
const _Viana2_svPP_EQ 		= _Viana2_svPP_TRUE or _Viana2_svCALCULATED_MASK;		// Пик-Пик Экв, Размах эквивалентный = svRMSTrue * M_SQRT2 * 2
const _Viana2_svRMS_WND2014 = _Viana2_svRMS_WND or _Viana2_svCALCULATED_MASK;	// СКЗ по спектру со странным окном по новому ГОСТ 2954-2014
const _Viana2_svCREST_FACTOR = _Viana2_svSUM2 or _Viana2_svCALCULATED_MASK;	// Пик-фактор через svSum2
const _Viana2_svEXCESS 		= _Viana2_svSUM4 or _Viana2_svCALCULATED_MASK;			// Эксцесс через svSum4 / svSum2
const _Viana2_svAMPL1 		= _Viana2_svRE1 or _Viana2_svCALCULATED_MASK;			// Ампл 1 гармоники (Peak) (через Re1 Im1)
const _Viana2_svPHASE1 		= _Viana2_svIM1 or _Viana2_svCALCULATED_MASK;			// Фаза 1 гармоники (Degr) (через Re1 Im1)
const _Viana2_svAMPL2 		= _Viana2_svRE2 or _Viana2_svCALCULATED_MASK;			// Ампл 2 гармоники (Peak) (через Re2 Im2)
const _Viana2_svPHASE2 		= _Viana2_svIM2 or _Viana2_svCALCULATED_MASK;			// Фаза 2 гармоники (Degr) (через Re2 Im2)
const _Viana2_svAMPL3 		= _Viana2_svRE3 or _Viana2_svCALCULATED_MASK;			// Ампл 3 гармоники (Peak) (через Re3 Im2)
const _Viana2_svPHASE3 		= _Viana2_svIM3 or _Viana2_svCALCULATED_MASK;			// Фаза 3 гармоники (Degr) (через Re3 Im2)

const _Viana2_svCOUNT_CALC 	= _Viana2_svCOUNT + _Viana2_svCALCULATED_MASK;




// Состояние
const _Viana2_stateNone    = 0; // Нет состояния
const _Viana2_stateGreen   = 1;
const _Viana2_stateYellow  = 2;
const _Viana2_stateRed     = 3;
const _Viana2_stateUnknown = 4;	// Неизвестно, не вычисленно, обычно для значения ==0
const _Viana2_stateCount   = 5;




// Нормы по виброскорости (NormsVel)
const _Viana2_NORMS_VEL_COUNT = 13;
const _Viana2_NormsVel: array [0.._Viana2_NORMS_VEL_COUNT-1] of Single = ( 0.0,0.28,0.45,0.71,1.12,1.8,2.8,4.5,7.1,11.2,18.0,28.0,45.0 );



// TTable.DataFormat - Формат представления отсчётов в TTable.OffT
// MeasurementDataFormat
const _Viana2_dfINT16_VALUE 	= 0;		// int16_t, 2 байта на отсчёт, нужно умножить на TTable.Scale
const _Viana2_dfINT32_VALUE 	= 1;		// int32_t, 4 байта, нужно умножить на TTable.Scale
const _Viana2_dfFLOAT_VALUE 	= 2;		// float, 4 байта, реальное амплитудное значение (сигнал или спектр), TTable.Scale не используется
const _Viana2_dfDOUBLE_VALUE 	= 3;		// double, 8 байт, реальное амплитудное значение (сигнал или спектр), TTable.Scale не используется
const _Viana2_dfMASK_VALUE 		= 7;		// маска определения типа данных
// Дополнительные Маски:
const _Viana2_dfCOMLEX_VALUE 	= $40;		// complex, x2 байт, например, комплексный спектр, Re+Im
const _Viana2_dfLOG_VALUE 		= $80;		// десятичный логарифм значения






// Max теоретически возможное число каналов
const _Viana2_CHANNEL_COUNT = 3;

// Тип входа, порядок окон на экране
const _Viana2_CH_1 = 0;		// канал 1
const _Viana2_CH_2 = 1;		// канал 2
const _Viana2_CH_TACH = 2;	// Отметчик

const _Viana2_CH_VIBRO = 2; // 2 виброканала
const _Viana2_CH_COUNT = _Viana2_CHANNEL_COUNT;


const _Viana2_MAX_POINT_RECORDER = 512 * 1024; //максимальное число точек в данных длинного замера


//const _Viana2_ADC_FREQUENCY = 25600.0;






// Настройки измерения TMeasureSetup

// MeasurementMode: Что измеряем (Соответствует окну в главном меню) ?
const _Viana2_SETUP_MSM_WAVEFORM = 0;
const _Viana2_SETUP_MSM_RMS = 1;
const _Viana2_SETUP_MSM_ROUTE = 2;
const _Viana2_SETUP_MSM_BALANCE = 3;
const _Viana2_SETUP_MSM_RECORDER = 4;
const _Viana2_SETUP_MSM_RUNUP = 5;
const _Viana2_SETUP_MSM_ORBIT = 6;
const _Viana2_SETUP_MSM_MODAL = 7;
const _Viana2_SETUP_MSM_BEARINGS = 8;
const _Viana2_SETUP_MSM_UHF = 9;
const _Viana2_SETUP_MSM_CURRENT = 10;
const _Viana2_SETUP_MSM_COUNT = 11;



// Path: Какой аналоговый канал
const _Viana2_SETUP_MSP_DEFAULT = 0;	// SETUP_MSP_STD
const _Viana2_SETUP_MSP_STD	=1;	// стандартный 3Hz..10kHz
const _Viana2_SETUP_MSP_SLOW	=2;	// медленный 0,5Hz..50Hz
const _Viana2_SETUP_MSP_ENV	=3;	// Огибающая 500Hz..10kHz
const _Viana2_SETUP_MSP_UHF	=4;	// UHF датчик на канале отметчика
const _Viana2_SETUP_MSP_COUNT	=4;
const _Viana2_SETUP_MSP_MUX = 5;	// Определяется полем Mux


// Channels: какие каналы использовать в измерении
const _Viana2_SETUP_MSC_DEFAULT = 0; // SETUP_MSC_CH1
const _Viana2_SETUP_MSC_CH1  =1;
const _Viana2_SETUP_MSC_CH1T =2;
const _Viana2_SETUP_MSC_CH12 =3;
const _Viana2_SETUP_MSC_CH12T=4;
const _Viana2_SETUP_MSC_TACH =5;
const _Viana2_SETUP_MSC_SINUS=6;
const _Viana2_SETUP_MSC_CH_MIN = _Viana2_SETUP_MSC_CH1;
const _Viana2_SETUP_MSC_CH_MAX = _Viana2_SETUP_MSC_TACH;

// Units
const _Viana2_SETUP_MSU_DEFAULT = 0; // SETUP_MSU_VELOCITY
const _Viana2_SETUP_MSU_ACCELERATION = 1;
const _Viana2_SETUP_MSU_VELOCITY = 2;
const _Viana2_SETUP_MSU_DISPLACEMENT = 3;
const _Viana2_SETUP_MSU_COUNT = 3;
const _Viana2_SETUP_MSU_MUX = 4;	// Определяется полем Mux


// Type: Тип данных
const _Viana2_SETUP_MST_DEFAULT = 0;	// SETUP_MST_SPECTRUM1000
const _Viana2_SETUP_MST_SPECTRUM1000 = 1;
const _Viana2_SETUP_MST_SPECTRUM = 2;
const _Viana2_SETUP_MST_WAVEFORM = 3;
const _Viana2_SETUP_MST_COUNT = 3;

// AllX
const _Viana2_SETUP_ALLX_DEFAULT = 0; // SETUP_ALLX_1K
const _Viana2_SETUP_ALLX_128	= 1;
const _Viana2_SETUP_ALLX_1K	= 2;
const _Viana2_SETUP_ALLX_8K	= 3;
const _Viana2_SETUP_ALLX_64K	= 4;
const _Viana2_SETUP_ALLX_COUNT = 4;

const _Viana2_SETUP_ALLF_DEFAULT = 0; // SETUP_ALLF_400
const _Viana2_SETUP_ALLF_50		= 1;
const _Viana2_SETUP_ALLF_400		= 2;
const _Viana2_SETUP_ALLF_3200		= 3;
const _Viana2_SETUP_ALLF_25600 = 4;
const _Viana2_SETUP_ALLF_COUNT = 4;

// dX: Частота семплирования в сигнале
const _Viana2_SETUP_DX_DEFAULT = 0;	// SETUP_DX_2560_HZ
const _Viana2_SETUP_DX_25600_HZ	= 1;	// 25600 Гц
const _Viana2_SETUP_DX_6400_HZ = 2;	// 6400 Гц
const _Viana2_SETUP_DX_2560_HZ = 3;	// 2560 Гц
const _Viana2_SETUP_DX_640_HZ = 4;	// 640 Гц
const _Viana2_SETUP_DX_256_HZ = 5;	// 256 Гц
const _Viana2_SETUP_DX_COUNT		= 5;

// Верхняя частота в спектре
const _Viana2_SETUP_FN_DEFAULT = 0;	// SETUP_FN_1000_HZ
const _Viana2_SETUP_FN_10000_HZ = _Viana2_SETUP_DX_25600_HZ;	// 10000 Гц
const _Viana2_SETUP_FN_2500_HZ = _Viana2_SETUP_DX_6400_HZ;	// 2500 Гц
const _Viana2_SETUP_FN_1000_HZ = _Viana2_SETUP_DX_2560_HZ;	// 1000 Гц
const _Viana2_SETUP_FN_250_HZ = _Viana2_SETUP_DX_640_HZ;		// 250 Гц
const _Viana2_SETUP_FN_100_HZ = _Viana2_SETUP_DX_256_HZ;		// 100 Гц
const _Viana2_SETUP_FN_COUNT = _Viana2_SETUP_DX_COUNT;



const _Viana2_SetupMeasAllX	: array [0.._Viana2_SETUP_ALLX_COUNT] of longword = ( 1024, 128, 1024, 8192, 65536 );
const _Viana2_SetupMeasdX	: array [0.._Viana2_SETUP_DX_COUNT] of single = (
	1.0 / 2560.0, 1.0 / 25600.0, 1.0 / 6400.0, 1.0 / 2560.0, 1.0 / 640.0, 1.0 / 256.0
);

const _Viana2_SetupMeasAllF 	: array [0.._Viana2_SETUP_ALLF_COUNT] of longword = ( 400, 50, 400, 3200, 25600 );
const _Viana2_SetupMeasFN		: array [0.._Viana2_SETUP_FN_COUNT] of single = ( 1000.0, 10000.0, 2500.0, 1000.0, 250.0, 100.0 );



// Avg
const _Viana2_SETUP_AVG_DEFAULT = 0;	// SETUP_AVG_4_STOP
const _Viana2_SETUP_AVG_NO			= 1;
const _Viana2_SETUP_AVG_4			= 2;
const _Viana2_SETUP_AVG_4_STOP		= 3;
const _Viana2_SETUP_AVG_10			= 4;
const _Viana2_SETUP_AVG_10_STOP	= 5;
const _Viana2_SETUP_AVG_999		= 6;
const _Viana2_SETUP_AVG_COUNT		= 6;
// AutoSave
const _Viana2_SETUP_AUTO_SAVE_DEFAULT = 0; // SETUP_AUTO_SAVE_NO
const _Viana2_SETUP_AUTO_SAVE_NO		= 1;
const _Viana2_SETUP_AUTO_SAVE			= 2;
const _Viana2_SETUP_AUTO_SAVE_COUNT	= 2;


const _Viana2_SETUP_EXTERNAL_SENSOR	= 0;	// Сигнал подаётся с датчика
const _Viana2_SETUP_INTERNAL_DAC		= 1;	// Сигнал подаётся с внутреннего ЦАП - используется для внутренних тестов

const _Viana2_SETUP_MODE_READ			= 0;	// Режим измерения
const _Viana2_SETUP_MODE_CALIBRATION	= 1;	// Режим калибровки - только для производителя


// Номера входов MUX
const _Viana2_SETUP_MUX_STD_ACC	= 0; // std 3..10kHz
const _Viana2_SETUP_MUX_STD_VEL	= 1; // std 3..10kHz
const _Viana2_SETUP_MUX_STD_DISP	= 2; // std 3..10kHz
const _Viana2_SETUP_MUX_LINE_ACC	= 3; // std no filter
const _Viana2_SETUP_MUX_ENV_ACC	= 4; // env 0,5..10kHz
const _Viana2_SETUP_MUX_SLOW_ACC	= 5; // slow 0,5..50Hz
const _Viana2_SETUP_MUX_SLOW_VEL	= 6; // slow 0,5..50Hz
const _Viana2_SETUP_MUX_SLOW_DISP	= 7; // slow 0,5..50Hz
const _Viana2_SETUP_MUX_COUNT		= 8;


// Текущие настройки чтения
Type _Viana2_TMeasureSetup = record

	Changed	: longword;	// 1 = MeasureSetup изменился, передать в Hardware

	MeasurementMode	: longword;	// Что измеряем, SETUP_MSM_xxx

	// Все параметры от 1 до N - соответствуют позиции скроллера в настройке
	Path	: longword;		// SETUP_MSP_xxx
	Channels	: longword;	// SETUP_MSC_xxx
	Units	: longword;		// SETUP_MSU_xxx
	Types	: longword;		// SETUP_MST_xxx

	dX	: longword;		// SETUP_DX_xxx или SETUP_FN_xxx
	AllX	: longword;		// SETUP_ALLX_xxx или SETUP_ALLF_xxx

	Avg	: longword;		// SETUP_AVG_xxx
	AutoSave	: longword;	// SETUP_AUTO_SAVE_xxx


	// Эти только для внутреннего использования:
	InternalDAC	: longword; // Переключение канала: 0 - Вход с датчиков, 1 - DAC
	CalibrationMode	: longword; // 0 - Работа, 1 - Калибровка

							  // Для тестирования и калибровки
	FreqSin	: single;	// Частота, Гц
	AmplSin	: single;	// Амплитуда ЦАП, мВольт

	// Если (Path == SETUP_MSP_MUX) или (Units == SETUP_MSU_MUX), то канал MUX берётся из этого поля
	Mux	: longword;	// SETUP_MUX_xxx

	Reserv	: longword;

end;
const sz_Viana2_TMeasureSetup = sizeof(_Viana2_TMeasureSetup); // 64








const FILE_VERSION_VIANA2_0100    = $C710; // Новая версия файла 1.0
const FILE_VERSION_VIANA2_CURRENT = FILE_VERSION_VIANA2_0100;




//       u32 Exist; // 0 -  нет; 1 - сигнал c железного канала; 2 - преобразованный
const _Viana2_teNo       = 0;
const _Viana2_teHard     = 1;
const _Viana2_teSoft     = 2;

Type _Viana2_TDateTime = longword;
     _Viana2_TTime     = Longword;
     _Viana2_TDate     = Longword;

Type _Viana2_TTable = record

       Exist      : longword; // 0 -  нет; 1 - сигнал c железного канала; 2 - преобразованный
       DT         : _Viana2_TDateTime;       //Время и дата проведения замера

       Types      : longword;
       Units      : longword;
       AllX       : longword;

       X0         : single;
       dX         : single;
       XN         : single;


		AmplMax	: single;   // Максимальное значение в сигнале
		AmplMin	: single;   // Минимальное значение в сигнале

       Scale      : single;

       OffT       : longword;	// Смещение данных канала в файле или адрес в памяти
       OffTx64	  : longword;	// Запас для адреса x64

        Reserv1		: array [0..1] of byte;
        DataFormat	: byte;		// Формат представления отсчётов в OffT - MeasurementDataFormat::XXX
        DrawOptions	: byte;	// Как отрисовывать график - DrawGraphOptions::XXX

        // Длина данных в файле или в памяти в байтах - может быть равна 0. 
        // Для сигнала = AllX * szTOnePoint
        // Для комплексного спектра = AllX * 2 * szTOnePoint
		LenT       : longword;

		Tick		: longword;           // Tick1024 для учета быстрых замеров

		Reserv		: array [0..6-1] of longword;

end;
const sz_Viana2_TTable = sizeof(_Viana2_TTable); // 88



(*
Для сигнала: float X[0],X[1],...,X[AllX-1]
Для комплексного спектра: float Re[0],Im[0],Re[1],Im[1],...,Re[AllX-1],Im[AllX-1]
*)



Type _Viana2_TOneChannel = record

	Exist		: longword; // 0=teNo -  нет; 1=teHard - сигнал c железного канала; 2=teSoft - преобразованный
	Align1		: longword;

    ValueInstant: array [0.._Viana2_svCOUNT-1] of single;	// Посчитанные по сигналу/спектру текущее (мгновенное) значение Peak, P-P, RMS, Zero, ...
	ValueHarmonicsCalculatedTick : longword; // Tick1024 последнего посчитанного RE1..IM3. Они считаются долго, так что вычисляем только по запросу
	ValueInstantCalculated	: longword;	// Флажки, какие из ValueInstant посчитаны

	ValueAvg	: array [0.._Viana2_svCOUNT-1] of single; // Усреднённые по посчитанным по сигналу/спектру Peak, P-P, RMS, Zero, ...
	ValueAvgCalculatedTick : longword;
	ValueAvgCalculated		: longword;	// Флажки, какие из ValueAvg посчитаны

	Table: array [0.._Viana2_ztWavSp-1] of _Viana2_TTable;

	Reserv: array [0..14-1] of longword;
end;
const sz_Viana2_TOneChannel = sizeof(_Viana2_TOneChannel); // 512


Type _Viana2_TOnePoint = single;	// Отсчёты хранятся в float
const sz_Viana2_TOnePoint = sizeof(_Viana2_TOnePoint);

Type _Viana2_TOneChannelData = array [0.._Viana2_MAX_POINT_RECORDER-1] of _Viana2_TOnePoint; // Массив данных одного канала
const sz_Viana2_TOneChannelData = sizeof(_Viana2_TOneChannelData);





// Структура для записи в файл, без причины не менять
Type _Viana2_TMeas = record

	Exist		: word;	// 0=teNo -  нет; 1=teHard - сигнал c железного канала; 2=teSoft - преобразованный
	Version		: word;
	DT			: _Viana2_TDateTime;       //Время и дата проведения замера

	LastDataTick: longword;  // Tick1024 начала замера или последнее добавление сегмента для длинных замеров (и для учета замеров короче 1 сек)
	Align1		: longword;

	MeasSetup	: _Viana2_TMeasureSetup; //  Что измеряем ? чтобы знать, как обрабатывать

	Count		: longword;          // Число каналов вибрации
	Channels	: longword;       // Маска подключенных датчиков

	// Что записано в замере
	Types		: longword;
	Units		: longword;

	FreqTach	: single;    // Частота по отметчику

	TempValue	: single;    // Температура, град Цельсия

	// Усреднений Сколько / Из скольки
	SpectrumAvg	: longword;
	SpectrumAvgMax: longword;

	FHP	: single;          // Верхняя частота фильтра
	FLP	: single;          // Нижняя частота фильтра

	// Таблицы Каналов с Сигналами-Спектрами
	CH	: array [0.._Viana2_CHANNEL_COUNT-1] of _Viana2_TOneChannel;

	Reserv: array [0..65-1] of longword;

	Align	: TCRC; // Для выравнивания
	CRC		: TCRC;

end;
const sz_Viana2_TMeas = sizeof(_Viana2_TMeas); // 1920








// Замер СКЗ для Авроры
const _Viana2_AURORA_CELL_MAX_POINTS   = 14; // Точек
const _Viana2_AURORA_CELL_MAX_AXES     = 3; // Направлений

const _Viana2_POINT_READED_MASK     = $07; // Прочитаны ВПО


Type _Viana2_TRMSMeasurement = record

	Exist		: word;	// 0=teNo -  нет; 1=teHard - сигнал c железного канала; 2=teSoft - преобразованный
	Version		: word;
	DT			: _Viana2_TDateTime;       //Время и дата проведения замера

	MeasSetup	: _Viana2_TMeasureSetup; //  Что измеряем ? чтобы знать, как обрабатывать

  	Value      	: array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1, 0.._Viana2_eiVIBRO-1] of single;
  	Temp       	: array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1] of single;

	PointReaded	: array [0.._Viana2_AURORA_CELL_MAX_POINTS-1] of byte; // Битовая маска для каждой точки, прочитан ли канал: 1 - В; 2 - П; 4 - О;
	Align2		: word;

    // Поля для Viana2 вместо Diag
  	ValueViewMode : array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1, 0.._Viana2_eiVIBRO-1] of byte;	// Что лежит в Value, например, svRMS
	Align3		: word;

  	RMSVelocityValue : array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1] of single; // Значения RMS Vel для вычисления состояния

	// Поля для Viana2 вместо Diag
	Channel	: array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1] of byte; // С какого канала измерено значение (CH_1 или CH_2)
	Align4	: word;

	Reserv: array [0..44-1] of longword;

	Align	: TCRC; // Для выравнивания
	CRC		: TCRC;

end;
const sz_Viana2_TRMSMeasurement = sizeof(_Viana2_TRMSMeasurement); // 1280













(*
//------------------------------ Маршруты Viana2 ------------------------------


//---------- Описание констант ----------
const NameRoute_V2   = 64;   //Длина имени в маршруте (В Атланте = 60)
      MaxRouteNode_V2 = 1024;
      RouteVersion_V2 = $200; // Версия маршрутов 2.00


// TRouteNode_V2.Exists
const rneFlagNone   = 0; // Не заполнено - не использовать
      rneFlagFilled = 1; // Параметры заполнены
      rneFlagReaded = 3; // rneFilled + Считан сигнал

// Флажки 0xFFFFFFFF, чтобы можно было дописывать во Flash  без стирания
const rneNone   = $FFFFFFFF; // Не заполнено - не использовать
      rneFilled = (rneNone xor rneFlagFilled); // Параметры заполнены
      rneReaded = (rneNone xor rneFlagReaded); // rneFilled + Считан сигнал



//---------- Структура Элемент ----------
Type TRouteNode_V2 = record

      Exists       : longword;    // rneXXX
      DataID       : longint;    // идентификатор замера во Flash или 0 или -1, если нет

      Name         : array [0..NameRoute_V2-1] of AnsiChar;

      Order        : longword;      //Из Атланта; для точек должно быть >0 ; для станций и прочего = 0

// Только для точек
      Tip          : longword;        //тип сигнала (сигнал/спектр)
      EdIzm        : longword;      //единицы измерения
      Channel      : longword;    //Канал 1..N; 0 - по-умолчанию
      Lines        : longint;      //число линий в спектре
      LoFreq       : longint;     //нижняя граничная частота, Гц
      HiFreq       : longint;     //верхняя граничная частота, Гц
      NAverg       : longint;     //число усреднений, только для спектра (может не использоваться прибором)
      Stamper      : longword;    // 1 - старт по отметчику (может не использоваться прибором)


      Deep         : longint;
      Parent       : longint;      // Индекс предка
      ChildCount   : longint;  // Число подэлементов
      Expanded     : longword;    // Узел дерева раскрыт (для поддержки дерева)
      Marked       : longword;      // Узел дерева отмечен (на будущее)

      //  Для поддержки передачи и разборки в Атланте
      ID           : longword;        // идентификатор точки
      Offset       : longword;        // смещение в скачанном файле
      Len          : longword;        // длина в скачанном файле

      Reserv       : array [0..3] of longword;

      Align        : TCRC;
      CRC          : TCRC;
end;



//---------- Заголовок структуры маршрута ----------
Type TRouteHdr_V2 = record

      Version      : longword;       // 0x200 для этой версии

      Name         : array [0..NameRoute_V2-1] of AnsiChar;

      Count        : longint;         // Число элементов Node

      Reserv       : array [0..15] of longword;

      Align        : TCRC;
      CRC          : TCRC;
end;


//---------- Маршрут ----------
Type TRoute_V2 = record

     Hdr       : TRouteHdr_V2;           //заголовок маршрута

     Node      : array [0..MaxRouteNode_V2-1] of TRouteNode_V2;    // элементы маршрута

end;


const szTRouteNode_V2 = sizeof(TRouteNode_V2);
      szTRouteHdr_V2  = sizeof(TRouteHdr_V2);
      szTRoute_V2     = sizeof(TRoute_V2); // ~140Кб

*)




implementation



initialization

assert(sz_Viana2_TMeasureSetup = 64);
assert(sz_Viana2_TTable = 88);
assert(sz_Viana2_TOneChannel = 512);
assert(sz_Viana2_TMeas = 1920);
assert(sz_Viana2_TRMSMeasurement = 1280);

end.


