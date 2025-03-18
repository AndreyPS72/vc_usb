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
#define MaxNumFRPoints      25  // ������������ ���������� ����� ���
#define NumAmplPoint        25  // ���������� ������������� ����� ���������
#define NumPhasePoint       25  // ���������� ������������� ����� ������ ��� (������)
#define NumFilterFreq       10  // ���������� ������ ������� MAX7404, ��� ������� ���������� ����������
#define NumCalInterval      32  // ����� ������������� ����������
#define BearingTitleLen     24
#define CountNamePlace      4

typedef enum {
  st_wait_start	=0,
  st_start			=1,
  st_run				=2,
  st_wait_stop	=3,    //  �������� ������� ����������� ������
  st_stop				=4,   //������ �������
  st_stop_end		=5,
  st_wait_calc	=6,
  st_calc				=7,
  st_calc_end		=8,
  st_open				=9,
	st_unused			=0xffffffff
}stop_Type;
typedef	enum {
  defRegimeGraphSign       =0,  //    ������                   //!!!!������� �� ������, ������� ������� � ChangeMeasTypeSign
  defRegimeGraphSpektr     =1,  //    ������  
  defRegimeGraphWSignal    =2,  //1    ��������������� ������ ������->���+������������ ���� -> �������������� ����� �������
  defRegimeGraphEnv        =3,  //4,   ������ ���������         //!!!���� ��� ������� ������� � ���������
  defRegimeGraphPulse      =4,  //3,   ��������� ���������  
  defRegimeParamPulse      =5,  //3,   ��������� ���������  
  defRegimeGraphSpektrPulse=6,  //2,   ������ ���������  
  defRegimeSignalSpektr    =7,  //5    ��������� ���� ��������
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
  float  Freq;   // ������������ ������� � ������
  float  AVolt;  // ��������� � �������
 // short  fADC;   // ������������� ������� � ������
} T_CalPoint;
typedef unsigned int  TChIntParam [MaxNumChMeasuring_V4];
typedef T_CalPoint TAFC[V4_Mark][MaxNumFRPoints];//typedef	T_ACPoint  TACMEMS_Point[NumMemsPoint];
typedef	struct	TransCh_REC {
  float         Vin;  // ���� ������
  short         In;   // ���� ������
  short         Out;  // ����� ������ (���)
} T_TransCh;   // �������� ���������� �������������� ������
typedef	struct	TVibroFeatures_REC {                      // CD - channel data
  unsigned short  CD_Offset [V4_Amount];                  // �������� ������ � ������
  unsigned short  Noise_PtoP[V4_Amount];                  // ������� ���� � ������
  T_TransCh       CD_Ampl   [V4_Mark] [NumCalInterval+1]; // "����������� ������������� �����" �������
  short           CD_Phase  [V4_Mark] [NumFilterFreq] [NumPhasePoint]; // "����������" ������� (����� ������ �������� ��������� ������������ �������, ��� ��������� ��������)
  T_CalPoint      CPP       [V4_Mark] [NumFilterFreq] [NumPhasePoint]; // ������������� ����� ��� ����
  short           FilterFreq1[NumFilterFreq];                          // ������������� ������� ��� �������
  short           CalibrFreq[NumPhasePoint];                          // ������������� �������, �� ������� ������������ ������� ����� (������ ���� ����������� ��� A,V,S - ������� ����������)
} TVibroFeatures;  // �������������� ������������ �������
typedef	struct	ServConst_REC{
  // ������ ����������
  unsigned short  CRC;
  float           AChCor    [MaxCountChan_V4];              // A, ����������� ������������ �������
  float           VChCor    [MaxCountChan_V4];              // V
  float           SChCor    [MaxCountChan_V4];              // S
  float           ExtSensCor[MaxCountChan_V4];          // �������� �������
  unsigned short  DevNum;
  int             BrdMCK;           // ������� PLL
  TVibroFeatures  VibFeat;
}TServConst;                           // �������� ��� ������������
typedef	struct	ServConst_Dop_REC {
  TAFC            AFC                       ;
  float           PhA_Shft[MaxCountChan_V4] ; // ����� ���� A
  float           PhV_Shft[MaxCountChan_V4] ; // ����� ���� V
  float           PhS_Shft[MaxCountChan_V4] ; // ����� ���� S
  T_WiFiModule    WiFiModule                ; // Belov
  unsigned int    Board_ver                 ; // Belov
  T_HighligthSCH  HighligthSCH              ; // Belov
  float           KoefY                     ; // Belov, ������������� ����������� ��� ����������� ��������� ����
  char            Reserv[100-4-4-4-4]       ;
  unsigned short  CRC                       ;
}TServConst_Dop;
typedef	struct	ServConst_A_REC{
  TServConst SC;
  TServConst_Dop SC_Dop;
}TServConst_A;
typedef unsigned char T_IPx4[4];


// �������� ����������
typedef struct stBearingRec {

  char Title[BearingTitleLen];

  float          DIn;    // ���������� �������
  float          DOut;   // �������� �������
  float          DBall;  // ������� ��� �������
  unsigned int   NBall;  // ����� ��� �������
  float          Betta;  // ���� �������� ��� � ������� �������, ����

  float FTF;    // ������� ����������
  float BPFO;   // ������� ������������� ��� ������� �� ������� ������
  float BPFI;   // ������� ������������� ��� ������� �� ���������� ������
  float BSF;    // ������� ������������� ��� �������
} TBearingRec;
typedef	struct	ServVarbl_REC{
  unsigned short    CRC                                                 ;
  char              DeviceSettingMenu_Protokol_RM                       ;
  float             ExtSensorSensivity  [MaxCountChan_V4]               ; // ���������������� �������� ������� mV/g
  unsigned int      ExtSensorNum        [MaxCountChan_V4]               ; // ����� �������� �������
  float             User_PhShft         [MaxCountChan_V4]               ; // ���������������� ����� ���
  float             FW_Ver                                              ;
  unsigned char     HightLigth                                          ; // ������� ���������
  // ��������� ����������                 
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
  //��������� ��������              
  unsigned char     MeasMenu_BandWidth_lstbx                            ;
  unsigned char     MeasMenu_NumPoint_lstbx                             ;
  unsigned char     MeasMenu_RegisrtationMode_lstbx                     ;
  unsigned char     MeasMenu_EnableChan[MaxCountChannel]                ;
  unsigned char     MeasMenu_Aver_lstbx                                 ;
  unsigned char     MeasingMenu_Scale                                   ;
  unsigned char     MathTypeResult_MeasSig[3]                           ;
  unsigned char     VisibleHarm                                         ;
  //�������� ����������             
  unsigned char     ParamDR_TimeReg_RM                                  ;
  unsigned char     ParamDR_BandWidth_RM                                ;
  //��������� ������-�����              
  unsigned char     EnableGraph_RV[MaxCountChan_V4]                        ;             
  unsigned char     ParamRV_OborotBeg_RM                                ; // no used
  unsigned char     ParamRV_OborotEnd_RM                                ; // no used
  unsigned char     ParamRV_TimeReg_RM                                  ;
  unsigned char     ParamRV_EdIzm_RM                                    ;
  unsigned char     EnableTypeGraph_RV                                  ;
  unsigned char     ModeX_RV                                            ;
  //��������� ��������� �� �����������              
  unsigned char     ParamMeasBearing_BandWidth_lstbx                    ;
  unsigned char     ParamMeasBearing_NumPoint_lstbx                     ;
  unsigned char     ParamMeasBearing_Aver_lstbx                         ;
  unsigned char     ParamMeasBearing_EnableChan[MaxCountChannel]        ;
  char              TypeWindowWidth                                     ; // ��� ������ ���� (1\3 ������ 1\2 ������ 1 ������) ������������ � ������ ������� ����
  T_TypeGraph       TypeGraphBear                                       ;
  int               BegFreqSpectr                                       ;
  unsigned char     Aver2                                               ; // ������� ���� ����������
  TBearingRec       DB                                                  ;
  //������������              
  unsigned char     SetupBalans_BandWidth_RM                            ;
  unsigned char     SetupBalans_NumPoint_RM                             ;
  unsigned char     SetupBalans_EdIzm_RM                                ;
  unsigned char     SetupBalans_CountPl_RM                              ;
  int               NumFileSave                                         ;
  int               NumNormValue_Balans                                 ;
  //���������             
  int 							NumNormValue_Vibrometr                              ;
  //��������� �����             
  char 							CalcFunc_Num                                        ;
  // ��������� ���������
  // ��������� ���������
  unsigned int      NextMeasNumber                                      ; // ����� ���������� ��������� (�������, ������� ��� ���������������� ������)
  unsigned int      LstVTblNumber                                       ; // ����� ���������� ���������� ��������� (������� ����������)
  unsigned char     IP[4]                                               ; //IP ����� �������
  unsigned char     Mac_Addres[6]                                       ;
  char 							GateWay[4]                                          ; //= {0, 0, 0, 0};
  char 							NetMask[4]                                          ; // = {255, 255, 255, 0};
  float 					  SensCurrent                                         ;
  char 							ParamSC_FreqSeti_RM                                 ;
  float 					  ParamSCFreqMotor_inum                               ;
  float 						ParamSCINOM_inum                                    ;
  char 							nuse                                                ; //----------------------------------EdIzmMark;//0- �� 1 - ������\ ���
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
  //��������� ���������
  unsigned char     ParamMA_BandWidth_RM                                ;
  unsigned char     ParamMA_NumPoint_RM                                 ;
  unsigned char     ParamMA_TypeEdIzm                                   ;
  unsigned char     ParamMA_EnableChan[MaxCountChan_V4]                 ;
  //���������� ��������
  unsigned char     cTrajectory_Settings_Place_RM_CurIndex[CountNamePlace]  ;
  unsigned char     Trajectory_Settings_BandWidth_RM                        ;
  unsigned char     Trajectory_Settings_NumPoint_RM                         ;
  //����� �������
  unsigned char     DeviceSettingMenu_WiFiOnOff_RM                      ;
  unsigned char     TypeEdIzm_Meas_Spectr1000                           ;
  char 						  Change                                              ;
	char 						  Reserv0[2]                                          ;
	//TXMAC 					  RCS_MAC[MaxCountChan];		// MAC ������ ������������ ��������, ����������
  T_IPx4 					  RCS_IP    [MaxCountChan_V4*2]                          ; // MAC ������ ������������ ��������, ����������
	char 						  RCS_Axis  [MaxCountChan_V4]                            ; // ��� ���������������� ��������� �������� ������������ ����� �������� �� MaxCountChan	
  unsigned char     DeviceSettingMenu_EtheOnOff_RM                      ;
  unsigned char     DeviceSettingMenu_SensorsUse_RM                     ; // ������������ �������
  unsigned char     SetupBalans_PhasePresent_RM                         ; 
  unsigned char     ViMeterSettings_Sensors_RM                          ;
  unsigned char     SetupBalans_AutoSave_RM                             ;
  unsigned char     Rsv1[3]                                             ;
  int               iUserBearing                                        ; // �� ������������
  char              Reserv    [200-26-6-1-4-2-1-1-1-2-MaxCountChan_V4*8-1*MaxCountChan_V4-1-1-1-1-1-3-4];  // !!! Belov
}TServVarbl;                           // ����������� � ������� ������ ����������

#define   ID_BALANS_ELEMENT       (('I'<<0)|('D'<<8)|('E'<<16)|('L'<<24))
typedef struct stParamBalans{
  float             MassVal       [MaxCountChan_V4] ; // ������������� ����� (��� ��������������� �����)
  float             MassAngle     [MaxCountChan_V4] ; // ������������� ����� (��� ��������������� �����)
  float             Circle_Freq                     ; // ������� �������� ���� (��)
  float             Harm1_Ampl    [MaxCountChan_V4] ; // ��������� � ���� ������ ��������� � �������
  float             Harm1_Phase   [MaxCountChan_V4] ;
  // Belov ����������
  int               My_Addition_ID                  ;
  int               AngleMark                       ; // ���� ��������� ���������
  int               Direct_Motor                    ; // ����������� �������� ����
  int               Rsv                             ;
  int               AngleSens     [MaxCountChan_V4] ; // ���� ��������� �������    
}TCalcParamBalans;

typedef	struct	MeasSigParams_REC{
  // ����������� ���������
  TStatSigParams_V4   StcPrms;    //������� �������� ���������
  // ��������� ���������
  TFlow_Buf           Meas_Buf[MaxNumChMeasuring_V4];    // ������ �������
  unsigned int        Number;                         // ����� ������ (�������� ��������� ��� ��������� ���� �����)
  T_DBoxType          MeasType;                       // ��� ���������
  //��������� ���������
  TCalcMeasValue      CalcMeasValue[MaxNumChMeasuring_V4];   //�� ������� ��������
  TCalcMarkValue      CalcMarkValue;                //��������
  char                reserv[256];                     // ������
} TMeasSigParams;   // �������� ������� ��������� (��������� ��������� � ������)

typedef struct Point_REC{
  u16 x,y;
}T_Point;

typedef struct {                                            // ���������� ��������� ���������� ������� (�� ����� �� ������)
  float               BandWidth                           ;
  float               Discretization                      ;
  unsigned int        CountPoint                          ;
  unsigned int        CountLine                           ;
  Type_EdIzm          EdIzm                               ; //  ������� ��������� A V S
  //unsigned short      EdIzm                               ; //  ������� ��������� A V S Belov
  char                Mean                                ;
  char                CountAver                           ;
  char                CountAver2                          ;
  unsigned char       Enable[MaxNumChMeasuring_V4]           ;
  int                 GlobIndFirst                        ; //  ������ ���������� �����, ���� -1 �� ��� ����
  //��������� ���� �������� � ������ ������������� ������
  int                 RegimeWork_FrameMeas                ; //  ����� ������ ������ ����������� ��������
  char                RegimeADC                           ; 
  unsigned short      SpectrGraphOffset                   ; //  ����� �������� ������ ��� �������
  char                Type                                ; //  � ��� ����� ������� - ��� ���������� ������� (0 - ����, 1- ��������)
  int                 CountPoint_PDT                      ; 
  float               MinFreqCalcRMS                      ; 
  float               MaxFreqCalcRMS                      ; 
  char                Meas_Sig_paramsID                   ; //  ���� �� ������ ��� ���������� !!!����������
  char                CheckSave                           ; //  ���� �� ������ ��� ���������� !!!����������
  char                SaveComment                         ; //  ���� ������ �������� �����������
  volatile stop_Type  StopRegime                          ; 
  int                 StartStopRegistration               ; //  ���������� �� ����� ��������� ���
  int                 VisibleChan                         ; //  ��������� �������� �������  VisibleChan=MaxCountChannel �����, ����� �� ������ ��� ���������� � ����������� ������, ����� �� 1
  int                 NumNormValue                        ;
  //������ ����� ��� ������ � ��������� ������� (������� ��� � ����)
  char                ControlRedraw                       ; //  �������� �������� �����������
  char                VisibleHarm                         ;     
  char                flReVisGraph                        ; //  ���� ���������������� ��������� ������� (���������)
  char                flReInitGraph     [MaxCountChannel] ; //  ���� ���������������� ������� ��� ������������ ������-������
  char                flCalcSpectr      [MaxCountChan_V4] ; //  ������ �� ������ ��� ��������
  T_TypeGraph         ChanMeasing_Regime[MaxCountChannel] ; //  ��� ����������� ������ �� ������ defRegimeGraphSign...  
  int                 ScaleCtrlIndex                      ; //  ��� ��������������� �������
  char                CountMathTypeResult                 ;     
  char                Recalc_FLabel_Arch                  ; //  ����� ���� �������
  char                flControlStateFrame                 ; //  ���� ��� ����������� ������� ������ ��������������� ������� ������, ������ �� ��� ������� � ��������� ������
  //vibrometr
  int                 CurColorNorm                        ; //  ������� ���� ����
  int                 PredX                               ; //  ������� ������� ������ � �������
  int                 PredY                               ; //  ������� ������� ������ � �������
  //bearing Regime
  char                flSaveOctave[3]                     ; //  ���� ���������� ������� ��������� ������������ �� �������
  char                TypeWindowWidth                     ; //  ��� ������ ���� (1\3 ������ 1\2 ������ 1 ������) ������������ � ������ ������� ����
  char               LoadBearing_DB_percent              ; 
  char                Rsvp[3];
  int                 BearDBReady                         ; //  ���� ���������� ���� �����������
  T_Point             GlobPosRamka                        ; //  x- ������� ������� �����  y- ������
  float               BegFreqSpectr                       ;
  float               EndFreqSpectr                       ;
   //��� ��������� ���������
  int                 OffsetNullLine[MaxCountChan_V4]     ;
  int                 CountPoint_Wait                     ;
  int                 CountPoint_Save                     ;
  //������ �����
  int                 RegimeRazgonVibeg                   ;
  T_ModeX_RV          ModeX_RV                            ; //  �� ����� �� �(����� �������)
  int                 sizeWin                             ; //  ����������� ��� ��� ������ ��������� �����
  int                 MaxCountPoint_RV                    ;
  int                 CurPointCalcRV                      ;
  char                CalcRV_percent                      ;
  char                RsvRVp[3]                           ;
  int                 CountPoint_RV                       ;
  int                 TempCountPoint_RV                   ;
  float               DeltaFreq                           ; //  ���������� �� ������� ������������, ����� �������� ����� �����
  //���������� ��������
  int                 indP1                               ;
  int                 indP2                               ;
  int                 indV1                               ;
  int                 indV2                               ;
  // ������������
  char                RegimeInputValue                    ;
  char                ModeLoadedBalans                    ;
  char                flSetNewValue_Table_Manual          ;
  T_TyPeRegimeGHP     lstRegimeGHP                        ;
  T_TyPeRegimeGHP     RegimeGHP                           ;
  char                Starting                            ; // - ����� �����
  int                 GlobActiveObj                       ;
  //������ ���a
  float               ResultBPF                           ;
  char                Firmware_Write_percent              ;
  char                RsvWp[3]                            ;
  char                Firmware_Read_percent               ;
  char                RsvRp[3]                            ;
  T_FileType          ViewData                            ; //  � ������ ��������, ���������� ���� ���������������� �������
  unsigned int        lstFileIndex                        ;
  unsigned int        curFileIndex                        ; //  ������ �������� �����
  char                BusyDevice                          ;
} MeasSigParams_Frame;



#endif
