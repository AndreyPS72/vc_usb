#ifndef ViAna4_type_h
#define ViAna4_type_h

#include "Flows\Data_Flow_type.h"
//#include "components\Image\MultiChannelADC\MultiChannelADC_type.h"
#include "KIT\core\FS\FS_type.h"
#include "KIT\Utils\Analize\Vibration\Balancing\Balancing_type.h"
#include "KIT\Utils\Signals\core\Signal_type.h"
#include "KIT\UTILs\Protocols\VC_Atlant\VC_Atlant_Devices_type.h"

#define defultMaxNumAmpl    12
#define defultMaxNumFreq    15
#define MaxNumFRPoints      25  // максимальное количество точек АЧХ
#define NumAmplPoint        25  // количество калибровочных точек амплитуды
#define NumPhasePoint       25  // количество калибровочных точек сдвига фаз (частот)
#define NumFilterFreq       10  // количество частот фильтра MAX7404, для которых проводится калибровка
#define NumCalInterval      32  // число калибровочных интервалов
#define BearingTitleLen     24
#define CountNamePlace      4

typedef enum {
  st_wait_start	=0,
  st_start			=1,
  st_run				=2,
  st_wait_stop	=3,    //  ожидание осанова дочитывание данных
  st_stop				=4,   //полный останов
  st_stop_end		=5,
  st_wait_calc	=6,
  st_calc				=7,
  st_calc_end		=8,
  st_open				=9,
	st_unused			=0xffffffff
}stop_Type;
typedef	enum {
  defRegimeGraphSign       =0,  //    сигнал                   //!!!!местами не менять, порядок использ в ChangeMeasTypeSign
  defRegimeGraphSpektr     =1,  //    спектр  
  defRegimeGraphWSignal    =2,  //1    восстановленный сигнал сигнал->БПФ+спектральное окно -> восстановление формы сигнала
  defRegimeGraphEnv        =3,  //4,   график огибающей         //!!!пока для отладки оставлю в просмотре
  defRegimeGraphPulse      =4,  //3,   параметры огибающей  
  defRegimeParamPulse      =5,  //3,   параметры огибающей  
  defRegimeGraphSpektrPulse=6,  //2,   спектр огибающей  
  defRegimeSignalSpektr    =7,  //5    смешанные типы графиков
  defMaxTypeGraphBearing   =defRegimeGraphSpektrPulse,//defRegimeParamPulse,//defRegimeGraphSpektrEnv, //defRegimeGraphEnv,//defRegimeParamEnv, //  defRegimeParamEnv //defRegimeGraphEnv
  defMaxTypeGraphMeas      =defRegimeGraphSpektr,
  defMaxTypeUnUsed         =0xff
} T_TypeGraph;
typedef enum{
   dModeX_Oborot,
   dModeX_Time,
   dModeX_None
}T_ModeX_RV;
typedef	enum{
  SS_Normal   =0,
  SS_TestSin  =1,
  SS_UnUsed   =0xff
} T_SourceSignal;
typedef	enum{
  S_Int     =0,
  S_Ext     =1,
  S_UnUsed  =0xff
} T_Sensor;
typedef	enum {
  WFM_RS9110		=(unsigned int )(('R'<<0)|('S'<<8)|('9'<<16)|('1'<<24)),
  WFM_ESP8266		=(unsigned int )(('E'<<0)|('S'<<8)|('P'<<16)|('7'<<24)),
  WFM__UnUsed   =0xffffffff
} T_WiFiModule;
typedef	enum {
  HSCH_PWM        =(unsigned int )(('H'<<0)|('P'<<8)|('W'<<16)|('M'<<24)),
  HSCH_DAC_LT3467 =(unsigned int )(('H'<<0)|('D'<<8)|('A'<<16)|('C'<<24)),
  HSCH_DAC_LT1618 =(unsigned int )(('H'<<0)|('D'<<8)|('A'<<16)|('2'<<24)),
  HSCH__UnUsed    =0xffffffff
} T_HighligthSCH;
typedef enum{
  RegimeMeas        ,
  RegimeResult      ,  
  RegimeLoad        ,
  RegimeSomeChange
}T_TyPeRegimeGHP;
typedef	struct	T_CalPoint_REC{
  float  Freq;   // генерируемая частота в герцах
  float  AVolt;  // амплитуда в вольтах
 // short  fADC;   // дискретизация сигнала в герцах
} T_CalPoint;
typedef unsigned int  TChIntParam [MaxNumChMeasuring_V4];
typedef T_CalPoint TAFC[V4_Mark][MaxNumFRPoints];//typedef	T_ACPoint  TACMEMS_Point[NumMemsPoint];
typedef	struct	TransCh_REC {
  float         Vin;  // вход канала
  short         In;   // вход канала
  short         Out;  // выход канала (АЦП)
} T_TransCh;   // описание переходной характеристики канала
typedef	struct	TVibroFeatures_REC {                      // CD - channel data
  unsigned short  CD_Offset [V4_Amount];                  // смещение данных в канале
  unsigned short  Noise_PtoP[V4_Amount];                  // уровень шума в канале
  T_TransCh       CD_Ampl   [V4_Mark] [NumCalInterval+1]; // "амплитудные калибровочные точки" каналов
  short           CD_Phase  [V4_Mark] [NumFilterFreq] [NumPhasePoint]; // "отставание" каналов (время сдвига выходной синусоиды относительно входной, при различных частотах)
  T_CalPoint      CPP       [V4_Mark] [NumFilterFreq] [NumPhasePoint]; // калибровочные точки для фазы
  short           FilterFreq1[NumFilterFreq];                          // калибровочные частоты для фильтра
  short           CalibrFreq[NumPhasePoint];                          // калибровочные частоты, на которых записывается фазовый сдвиг (должны быть одинаковыми для A,V,S - текущая реализация)
} TVibroFeatures;  // характеристики вибрационных каналов
typedef	struct	ServConst_REC{
  // физика устройства
  unsigned short  CRC;
  float           AChCor    [MaxCountChan_V4];              // A, поправочные коэффициенты каналов
  float           VChCor    [MaxCountChan_V4];              // V
  float           SChCor    [MaxCountChan_V4];              // S
  float           ExtSensCor[MaxCountChan_V4];          // внешнего датчика
  unsigned short  DevNum;
  int             BrdMCK;           // частота PLL
  TVibroFeatures  VibFeat;
}TServConst;                           // задается при производстве
typedef	struct	ServConst_Dop_REC {
  TAFC            AFC                       ;
  float           PhA_Shft[MaxCountChan_V4] ; // сдвиг фазы A
  float           PhV_Shft[MaxCountChan_V4] ; // сдвиг фазы V
  float           PhS_Shft[MaxCountChan_V4] ; // сдвиг фазы S
  T_WiFiModule    WiFiModule                ; // Belov
  unsigned int    Board_ver                 ; // Belov
  T_HighligthSCH  HighligthSCH              ; // Belov
  float           KoefY                     ; // Belov, калибровочный коэффициент для отображения амплитуды тока
  char            Reserv[100-4-4-4-4]       ;
  unsigned short  CRC                       ;
}TServConst_Dop;
typedef	struct	ServConst_A_REC{
  TServConst SC;
  TServConst_Dop SC_Dop;
}TServConst_A;
typedef unsigned char T_IPx4[4];


// Описание подшипника
typedef struct stBearingRec {

  char Title[BearingTitleLen];

  float          DIn;    // Внутренний диаметр
  float          DOut;   // Наружный диаметр
  float          DBall;  // Диаметр тел качения
  unsigned int   NBall;  // Число тел качения
  float          Betta;  // Угол контакта тел и дорожек качения, град

  float FTF;    // Частота сепаратора
  float BPFO;   // Частота перекатывания тел качения по внешней обойме
  float BPFI;   // Частота перекатывания тел качения по внутренней обойме
  float BSF;    // Частота перекатывания тел качения
} TBearingRec;
typedef	struct	ServVarbl_REC{
  unsigned short    CRC                                                 ;
  char              DeviceSettingMenu_Protokol_RM                       ;
  float             ExtSensorSensivity  [MaxCountChan_V4]               ; // чувствительность внешнего датчика mV/g
  unsigned int      ExtSensorNum        [MaxCountChan_V4]               ; // номер внешнего датчика
  float             User_PhShft         [MaxCountChan_V4]               ; // пользовательский сдвиг фаз
  float             FW_Ver                                              ;
  unsigned char     HightLigth                                          ; // яркость подсветки
  // интерфейс устройства                 
  float             MassVal             [MaxCountChan_V4]               ;
  float             MassAngle           [MaxCountChan_V4]               ;
  unsigned char     AnalizeMenu_AnalizeType_lstbx                       ;
  unsigned char     DeviceSettingMenu_highligth_lstbx                   ;
  unsigned char     DeviceSettingMenu_poweroff_lstbx                    ;
  unsigned char     DeviceSettingMenu_EdIzmMark_RM                      ;
  unsigned char     TypeEdIzm_Meas                                      ;
  unsigned char     nUse                                                ; //-------------
  unsigned char     TypeCalc_Vibrometer                                 ;
  unsigned char     BlnsMenuInMode_lstbx                                ;
  //измерение сигналов              
  unsigned char     MeasMenu_BandWidth_lstbx                            ;
  unsigned char     MeasMenu_NumPoint_lstbx                             ;
  unsigned char     MeasMenu_RegisrtationMode_lstbx                     ;
  unsigned char     MeasMenu_EnableChan[MaxCountChannel]                ;
  unsigned char     MeasMenu_Aver_lstbx                                 ;
  unsigned char     MeasingMenu_Scale                                   ;
  unsigned char     MathTypeResult_MeasSig[3]                           ;
  unsigned char     VisibleHarm                                         ;
  //цифровой магнитофон             
  unsigned char     ParamDR_TimeReg_RM                                  ;
  unsigned char     ParamDR_BandWidth_RM                                ;
  //параметры РАЗГОН-ВЫБЕГ              
  unsigned char     EnableGraph_RV[MaxCountChan_V4]                        ;             
  unsigned char     ParamRV_OborotBeg_RM                                ; // no used
  unsigned char     ParamRV_OborotEnd_RM                                ; // no used
  unsigned char     ParamRV_TimeReg_RM                                  ;
  unsigned char     ParamRV_EdIzm_RM                                    ;
  unsigned char     EnableTypeGraph_RV                                  ;
  unsigned char     ModeX_RV                                            ;
  //параметры Диагности по подшипникам              
  unsigned char     ParamMeasBearing_BandWidth_lstbx                    ;
  unsigned char     ParamMeasBearing_NumPoint_lstbx                     ;
  unsigned char     ParamMeasBearing_Aver_lstbx                         ;
  unsigned char     ParamMeasBearing_EnableChan[MaxCountChannel]        ;
  char              TypeWindowWidth                                     ; // тип ширины окна (1\3 октавы 1\2 октавы 1 октава) Используется в режиме спектра огиб
  T_TypeGraph       TypeGraphBear                                       ;
  int               BegFreqSpectr                                       ;
  unsigned char     Aver2                                               ; // спектра огиб усреднения
  TBearingRec       DB                                                  ;
  //балансировка              
  unsigned char     SetupBalans_BandWidth_RM                            ;
  unsigned char     SetupBalans_NumPoint_RM                             ;
  unsigned char     SetupBalans_EdIzm_RM                                ;
  unsigned char     SetupBalans_CountPl_RM                              ;
  int               NumFileSave                                         ;
  int               NumNormValue_Balans                                 ;
  //виброметр             
  int 							NumNormValue_Vibrometr                              ;
  //векторный кальк             
  char 							CalcFunc_Num                                        ;
  // служебные параметры
  // служебные параметры
  unsigned int      NextMeasNumber                                      ; // номер следующего измерения (сигнала, спектра или балансировочного замера)
  unsigned int      LstVTblNumber                                       ; // номер последнего сделанного измерения (таблица виброметра)
  unsigned char     IP[4]                                               ; //IP адрес прибора
  unsigned char     Mac_Addres[6]                                       ;
  char 							GateWay[4]                                          ; //= {0, 0, 0, 0};
  char 							NetMask[4]                                          ; // = {255, 255, 255, 0};
  float 					  SensCurrent                                         ;
  char 							ParamSC_FreqSeti_RM                                 ;
  float 					  ParamSCFreqMotor_inum                               ;
  float 						ParamSCINOM_inum                                    ;
  char 							nuse                                                ; //----------------------------------EdIzmMark;//0- Гц 1 - оборот\ мин
  int 							NumFileSaveBalans                                   ;
  char 							SetupBalans_TypeBalans_RM                           ;
  char 							TypeShowBalansTable                                 ;
  unsigned char     ParamRV_TypeRegime_RM                               ;
  u32 							TreeActFile_MainArchive                             ;
  int 							TreeActFile_BalansMeasArchive                       ;
  int 							TreeActFile_BalansProtocolArchive                   ;
  int 							TreeActFile_VibroTableArchive                       ;
  u32 							RegimeWork                                          ;
  unsigned char 		NumMainGCFrame                                      ;
  unsigned char 		Volume                                              ;
  //свободные колебания
  unsigned char     ParamMA_BandWidth_RM                                ;
  unsigned char     ParamMA_NumPoint_RM                                 ;
  unsigned char     ParamMA_TypeEdIzm                                   ;
  unsigned char     ParamMA_EnableChan[MaxCountChan_V4]                 ;
  //траектория движения
  unsigned char     cTrajectory_Settings_Place_RM_CurIndex[CountNamePlace]  ;
  unsigned char     Trajectory_Settings_BandWidth_RM                        ;
  unsigned char     Trajectory_Settings_NumPoint_RM                         ;
  //парам прибора
  unsigned char     DeviceSettingMenu_WiFiOnOff_RM                      ;
  unsigned char     TypeEdIzm_Meas_Spectr1000                           ;
  char 						  Change                                              ;
	char 						  Reserv0[2]                                          ;
	//TXMAC 					  RCS_MAC[MaxCountChan];		// MAC адреса подключаемых датчиков, поканально
  T_IPx4 					  RCS_IP    [MaxCountChan_V4*2]                          ; // MAC адреса подключаемых датчиков, поканально
	char 						  RCS_Axis  [MaxCountChan_V4]                            ; // ось чувствительности измерения ВНИМАНИЕ выравнивание будет зависеть от MaxCountChan	
  unsigned char     DeviceSettingMenu_EtheOnOff_RM                      ;
  unsigned char     DeviceSettingMenu_SensorsUse_RM                     ; // используемые датчики
  unsigned char     SetupBalans_PhasePresent_RM                         ; 
  unsigned char     ViMeterSettings_Sensors_RM                          ;
  unsigned char     SetupBalans_AutoSave_RM                             ;
  unsigned char     Rsv1[3]                                             ;
  int               iUserBearing                                        ; // не используется
  char              Reserv    [200-26-6-1-4-2-1-1-1-2-MaxCountChan_V4*8-1*MaxCountChan_V4-1-1-1-1-1-3-4];  // !!! Belov
}TServVarbl;                           // обновляется в течении работы устройства

#define   ID_BALANS_ELEMENT       (('I'<<0)|('D'<<8)|('E'<<16)|('L'<<24))
typedef struct stParamBalans{
  float             MassVal       [MaxCountChan_V4] ; // установленная масса (при балансировочном пуске)
  float             MassAngle     [MaxCountChan_V4] ; // установленная масса (при балансировочном пуске)
  float             Circle_Freq                     ; // частота вращения вала (Гц)
  float             Harm1_Ampl    [MaxCountChan_V4] ; // амплитуда и фаза первой гармоники в сигнале
  float             Harm1_Phase   [MaxCountChan_V4] ;
  // Belov добавление
  int               My_Addition_ID                  ;
  int               AngleMark                       ; // угол положения отметчика
  int               Direct_Motor                    ; // направление вращения вала
  int               Rsv                             ;
  int               AngleSens     [MaxCountChan_V4] ; // угол положения датчика    
}TCalcParamBalans;

typedef	struct	MeasSigParams_REC{
  // независимые параметры
  TStatSigParams_V4   StcPrms;    //условия создания измерения
  // зависимые параметры
  TFlow_Buf           Meas_Buf[MaxNumChMeasuring_V4];    // данные каналов
  unsigned int        Number;                         // номер замера (сквозная номерация для измерений всех типов)
  T_DBoxType          MeasType;                       // тип измерения
  //параметры расчетные
  TCalcMeasValue      CalcMeasValue[MaxNumChMeasuring_V4];   //по каналам вибрации
  TCalcMarkValue      CalcMarkValue;                //отметчик
  char                reserv[256];                     // резерв
} TMeasSigParams;   // описание условий измерения (структура заголовок в замере)

typedef struct Point_REC{
  u16 x,y;
}T_Point;

typedef struct {                                            // структурва служебных параметров прибора (не нужны во фрамке)
  float               BandWidth                           ;
  float               Discretization                      ;
  unsigned int        CountPoint                          ;
  unsigned int        CountLine                           ;
  Type_EdIzm          EdIzm                               ; //  единицы измерения A V S
  //unsigned short      EdIzm                               ; //  единицы измерения A V S Belov
  char                Mean                                ;
  char                CountAver                           ;
  char                CountAver2                          ;
  unsigned char       Enable[MaxNumChMeasuring_V4]           ;
  int                 GlobIndFirst                        ; //  первый включенный канал, если -1 то все выкл
  //служебные поля меняются в работе определенного режима
  int                 RegimeWork_FrameMeas                ; //  режим работы фрейма регистрации сигналов
  char                RegimeADC                           ; 
  unsigned short      SpectrGraphOffset                   ; //  сдвиг значений данных для спектра
  char                Type                                ; //  в рег диагн подшипн - тип расчетного спектра (0 - ампл, 1- комплекс)
  int                 CountPoint_PDT                      ; 
  float               MinFreqCalcRMS                      ; 
  float               MaxFreqCalcRMS                      ; 
  char                Meas_Sig_paramsID                   ; //  есть ли данные для сохранения !!!объединить
  char                CheckSave                           ; //  есть ли данные для сохранения !!!объединить
  char                SaveComment                         ; //  флаг записи речевого комментария
  volatile stop_Type  StopRegime                          ; 
  int                 StartStopRegistration               ; //  необходимо ли сразу запускать рег
  int                 VisibleChan                         ; //  видимость графиков каналов  VisibleChan=MaxCountChannel режим, когда на экране все включенные в регистрацию каналы, иначе по 1
  int                 NumNormValue                        ;
  //всякие флаги для работы в различных режимах (свалила все в кучу)
  char                ControlRedraw                       ; //  контроль ожидания перерисовки
  char                VisibleHarm                         ;     
  char                flReVisGraph                        ; //  флаг переиницализации видимости графика (прокрутка)
  char                flReInitGraph     [MaxCountChannel] ; //  флаг переиницализации графика при переключении сигнал-спектр
  char                flCalcSpectr      [MaxCountChan_V4] ; //  спектр по данным был посчитан
  T_TypeGraph         ChanMeasing_Regime[MaxCountChannel] ; //  тип отображения данных по каналу defRegimeGraphSign...  
  int                 ScaleCtrlIndex                      ; //  тип масштабирования графика
  char                CountMathTypeResult                 ;     
  char                Recalc_FLabel_Arch                  ; //  смена типа расчета
  char                flControlStateFrame                 ; //  флаг для обозначения первого вызова конторлирующего объекта фрейма, хорошо бы его вынести в параметры фрейма
  //vibrometr
  int                 CurColorNorm                        ; //  текущий цвет цифр
  int                 PredX                               ; //  текущая позиция ячейки в таблице
  int                 PredY                               ; //  текущая позиция ячейки в таблице
  //bearing Regime
  char                flSaveOctave[3]                     ; //  флаг сохранения спектра огибающей расчитанного по октавам
  char                TypeWindowWidth                     ; //  тип ширины окна (1\3 октавы 1\2 октавы 1 октава) Используется в режиме спектра огиб
  char               LoadBearing_DB_percent              ; 
  char                Rsvp[3];
  int                 BearDBReady                         ; //  флаг распаковки базы подшипников
  T_Point             GlobPosRamka                        ; //  x- позиция курсора рамки  y- ширина
  float               BegFreqSpectr                       ;
  float               EndFreqSpectr                       ;
   //для свободных колебаний
  int                 OffsetNullLine[MaxCountChan_V4]     ;
  int                 CountPoint_Wait                     ;
  int                 CountPoint_Save                     ;
  //разгон выбег
  int                 RegimeRazgonVibeg                   ;
  T_ModeX_RV          ModeX_RV                            ; //  тп шкалы по Х(время обороты)
  int                 sizeWin                             ; //  минимальный шаг для поиска следующей точки
  int                 MaxCountPoint_RV                    ;
  int                 CurPointCalcRV                      ;
  char                CalcRV_percent                      ;
  char                RsvRVp[3]                           ;
  int                 CountPoint_RV                       ;
  int                 TempCountPoint_RV                   ;
  float               DeltaFreq                           ; //  приращение по частоте достаточного, чтобы получить новую точку
  //траектория движения
  int                 indP1                               ;
  int                 indP2                               ;
  int                 indV1                               ;
  int                 indV2                               ;
  // балансировка
  char                RegimeInputValue                    ;
  char                ModeLoadedBalans                    ;
  char                flSetNewValue_Table_Manual          ;
  T_TyPeRegimeGHP     lstRegimeGHP                        ;
  T_TyPeRegimeGHP     RegimeGHP                           ;
  char                Starting                            ; // - номер пуска
  int                 GlobActiveObj                       ;
  //спектр токa
  float               ResultBPF                           ;
  char                Firmware_Write_percent              ;
  char                RsvWp[3]                            ;
  char                Firmware_Read_percent               ;
  char                RsvRp[3]                            ;
  T_FileType          ViewData                            ; //  в режиме просмотр, различение типа просматриваемого сигнала
  unsigned int        lstFileIndex                        ;
  unsigned int        curFileIndex                        ; //  индекс текущего файла
  char                BusyDevice                          ;
} MeasSigParams_Frame;



#endif
