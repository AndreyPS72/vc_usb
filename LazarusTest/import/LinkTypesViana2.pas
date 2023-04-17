unit LinkTypesViana2;

{$MODE DelphiUnicode}{$CODEPAGE UTF8}{$H+}

interface
uses  LinkTypes
      ;




{$R-}




// ��� ������
const _Viana2_ztWaveform        = 0;     // ������
const _Viana2_ztSpectrum        = 1;     // ������
const _Viana2_ztEnvelope        = 2;     // ���������
const _Viana2_ztEnvSpectrum     = 3;     // ������ ���������
const _Viana2_ztRMS             = 4;     // ���
const _Viana2_ztRMSTable        = 5;     // ������� ���
const _Viana2_ztRUN_UP 			= 6;		// ������-�����

const _Viana2_ztCount           = 7;     // ����������
const _Viana2_ztVibro           = 4;
const _Viana2_ztWavSp           = 2;	// ������ ������ � ������


//--- ����������� ����������
const  _Viana2_eiAcceleration    = 0;   // ���������, �/�2
const  _Viana2_eiVelocity        = 1;   // ��������, ��/�
const  _Viana2_eiDisplacement    = 2;   // �����������, ���
const  _Viana2_eiVolt            = 3;   // ������, �
const  _Viana2_eiTemp            = 4;   // �����������, ���� C
const  _Viana2_eiFreq            = 5;   // �������, ��
const  _Viana2_eiAMPER 			= 6;			// ���, �
const  _Viana2_eiUBAR 			= 7;			// �������� ��������� �������� ��� UHF ���������
const  _Viana2_eiDB 			= 8;			// ��������
const  _Viana2_eiNONE 			= 9;			// �.�., ��� �������

const  _Viana2_eiCount           = 10; // ����������
const  _Viana2_eiVibro           = 3;


// ������, �������� ��� - ��� ���������� ? (Show Value)
const _Viana2_svPeak_True       = 0;	// ��� �� �������    
const _Viana2_svPP_True         = 1;    // ���-���, ������ �� �������
const _Viana2_svRMS_True        = 2;    // ��� �� ������� ��� ����, ������ �������� �������
const _Viana2_svRMS_Wnd         = 3;    // ��� �� ������� � ����� 10..1000��, ��� ����������� 10..300��
const _Viana2_svZERO_LINE       = 5;    // �������� ������� �����
const _Viana2_svGE 				= 6;		// ��� �� ������ Acc Ge (Acc 500Hz..10kHz; SKF gE), �/�2
const _Viana2_svSUM2          	= 7;    // sum a^2
const _Viana2_svSUM4          	= 8;    // sum a^4
const _Viana2_svALLX 			= 9;		// ���������� �������� � ������� ��� �������

// ��� ������ ��������� CH_TACH
const _Viana2_svFREQ 			= 10;		// �������, ��

// ��� ���������� ������� CH_FRF = CH_1:
const _Viana2_svMODAL_FREQ1 	= 11;	// Natural Frequency 1-�� ����
const _Viana2_svMODAL_DLF1 		= 12;	// Damping Loss Factor 1-�� ����

const _Viana2_svRE1           	= 26;   // Real 1 ��������� (Peak)
const _Viana2_svIM1           	= 27;   // Image 1 ��������� (Peak)
const _Viana2_svRE2           	= 28;   // Real 2 ��������� (Peak)
const _Viana2_svIM2           	= 29;   // Image 2 ��������� (Peak)
const _Viana2_svRE3           	= 30;   // Real 3 ��������� (Peak)
const _Viana2_svIM3           	= 31;   // Image 3 ��������� (Peak)

const _Viana2_svCOUNT          	= 32;

// ����������� ����� ������ ���������
const _Viana2_svCALCULATED_MASK          	= 32;	// �����, ��� �������� ����������� ����� ������ ���������

const _Viana2_svPEAK_EQ 	= _Viana2_svPEAK_TRUE or _Viana2_svCALCULATED_MASK;	// ��� ������������� = svRMSTrue * M_SQRT2
const _Viana2_svPP_EQ 		= _Viana2_svPP_TRUE or _Viana2_svCALCULATED_MASK;		// ���-��� ���, ������ ������������� = svRMSTrue * M_SQRT2 * 2
const _Viana2_svRMS_WND2014 = _Viana2_svRMS_WND or _Viana2_svCALCULATED_MASK;	// ��� �� ������� �� �������� ����� �� ������ ���� 2954-2014
const _Viana2_svCREST_FACTOR = _Viana2_svSUM2 or _Viana2_svCALCULATED_MASK;	// ���-������ ����� svSum2
const _Viana2_svEXCESS 		= _Viana2_svSUM4 or _Viana2_svCALCULATED_MASK;			// ������� ����� svSum4 / svSum2
const _Viana2_svAMPL1 		= _Viana2_svRE1 or _Viana2_svCALCULATED_MASK;			// ���� 1 ��������� (Peak) (����� Re1 Im1)
const _Viana2_svPHASE1 		= _Viana2_svIM1 or _Viana2_svCALCULATED_MASK;			// ���� 1 ��������� (Degr) (����� Re1 Im1)
const _Viana2_svAMPL2 		= _Viana2_svRE2 or _Viana2_svCALCULATED_MASK;			// ���� 2 ��������� (Peak) (����� Re2 Im2)
const _Viana2_svPHASE2 		= _Viana2_svIM2 or _Viana2_svCALCULATED_MASK;			// ���� 2 ��������� (Degr) (����� Re2 Im2)
const _Viana2_svAMPL3 		= _Viana2_svRE3 or _Viana2_svCALCULATED_MASK;			// ���� 3 ��������� (Peak) (����� Re3 Im2)
const _Viana2_svPHASE3 		= _Viana2_svIM3 or _Viana2_svCALCULATED_MASK;			// ���� 3 ��������� (Degr) (����� Re3 Im2)

const _Viana2_svCOUNT_CALC 	= _Viana2_svCOUNT + _Viana2_svCALCULATED_MASK;




// ���������
const _Viana2_stateNone    = 0; // ��� ���������
const _Viana2_stateGreen   = 1;
const _Viana2_stateYellow  = 2;
const _Viana2_stateRed     = 3;
const _Viana2_stateUnknown = 4;	// ����������, �� ����������, ������ ��� �������� ==0
const _Viana2_stateCount   = 5;




// ����� �� ������������� (NormsVel)
const _Viana2_NORMS_VEL_COUNT = 13;
const _Viana2_NormsVel: array [0.._Viana2_NORMS_VEL_COUNT-1] of Single = ( 0.0,0.28,0.45,0.71,1.12,1.8,2.8,4.5,7.1,11.2,18.0,28.0,45.0 );



// TTable.DataFormat - ������ ������������� �������� � TTable.OffT
// MeasurementDataFormat
const _Viana2_dfINT16_VALUE 	= 0;		// int16_t, 2 ����� �� ������, ����� �������� �� TTable.Scale
const _Viana2_dfINT32_VALUE 	= 1;		// int32_t, 4 �����, ����� �������� �� TTable.Scale
const _Viana2_dfFLOAT_VALUE 	= 2;		// float, 4 �����, �������� ����������� �������� (������ ��� ������), TTable.Scale �� ������������
const _Viana2_dfDOUBLE_VALUE 	= 3;		// double, 8 ����, �������� ����������� �������� (������ ��� ������), TTable.Scale �� ������������
const _Viana2_dfMASK_VALUE 		= 7;		// ����� ����������� ���� ������
// �������������� �����:
const _Viana2_dfCOMLEX_VALUE 	= $40;		// complex, x2 ����, ��������, ����������� ������, Re+Im
const _Viana2_dfLOG_VALUE 		= $80;		// ���������� �������� ��������






// Max ������������ ��������� ����� �������
const _Viana2_CHANNEL_COUNT = 3;

// ��� �����, ������� ���� �� ������
const _Viana2_CH_1 = 0;		// ����� 1
const _Viana2_CH_2 = 1;		// ����� 2
const _Viana2_CH_TACH = 2;	// ��������

const _Viana2_CH_VIBRO = 2; // 2 �����������
const _Viana2_CH_COUNT = _Viana2_CHANNEL_COUNT;


const _Viana2_MAX_POINT_RECORDER = 512 * 1024; //������������ ����� ����� � ������ �������� ������


//const _Viana2_ADC_FREQUENCY = 25600.0;






// ��������� ��������� TMeasureSetup

// MeasurementMode: ��� �������� (������������� ���� � ������� ����) ?
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



// Path: ����� ���������� �����
const _Viana2_SETUP_MSP_DEFAULT = 0;	// SETUP_MSP_STD
const _Viana2_SETUP_MSP_STD	=1;	// ����������� 3Hz..10kHz
const _Viana2_SETUP_MSP_SLOW	=2;	// ��������� 0,5Hz..50Hz
const _Viana2_SETUP_MSP_ENV	=3;	// ��������� 500Hz..10kHz
const _Viana2_SETUP_MSP_UHF	=4;	// UHF ������ �� ������ ���������
const _Viana2_SETUP_MSP_COUNT	=4;
const _Viana2_SETUP_MSP_MUX = 5;	// ������������ ����� Mux


// Channels: ����� ������ ������������ � ���������
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
const _Viana2_SETUP_MSU_MUX = 4;	// ������������ ����� Mux


// Type: ��� ������
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

// dX: ������� ������������� � �������
const _Viana2_SETUP_DX_DEFAULT = 0;	// SETUP_DX_2560_HZ
const _Viana2_SETUP_DX_25600_HZ	= 1;	// 25600 ��
const _Viana2_SETUP_DX_6400_HZ = 2;	// 6400 ��
const _Viana2_SETUP_DX_2560_HZ = 3;	// 2560 ��
const _Viana2_SETUP_DX_640_HZ = 4;	// 640 ��
const _Viana2_SETUP_DX_256_HZ = 5;	// 256 ��
const _Viana2_SETUP_DX_COUNT		= 5;

// ������� ������� � �������
const _Viana2_SETUP_FN_DEFAULT = 0;	// SETUP_FN_1000_HZ
const _Viana2_SETUP_FN_10000_HZ = _Viana2_SETUP_DX_25600_HZ;	// 10000 ��
const _Viana2_SETUP_FN_2500_HZ = _Viana2_SETUP_DX_6400_HZ;	// 2500 ��
const _Viana2_SETUP_FN_1000_HZ = _Viana2_SETUP_DX_2560_HZ;	// 1000 ��
const _Viana2_SETUP_FN_250_HZ = _Viana2_SETUP_DX_640_HZ;		// 250 ��
const _Viana2_SETUP_FN_100_HZ = _Viana2_SETUP_DX_256_HZ;		// 100 ��
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


const _Viana2_SETUP_EXTERNAL_SENSOR	= 0;	// ������ ������� � �������
const _Viana2_SETUP_INTERNAL_DAC		= 1;	// ������ ������� � ����������� ��� - ������������ ��� ���������� ������

const _Viana2_SETUP_MODE_READ			= 0;	// ����� ���������
const _Viana2_SETUP_MODE_CALIBRATION	= 1;	// ����� ���������� - ������ ��� �������������


// ������ ������ MUX
const _Viana2_SETUP_MUX_STD_ACC	= 0; // std 3..10kHz
const _Viana2_SETUP_MUX_STD_VEL	= 1; // std 3..10kHz
const _Viana2_SETUP_MUX_STD_DISP	= 2; // std 3..10kHz
const _Viana2_SETUP_MUX_LINE_ACC	= 3; // std no filter
const _Viana2_SETUP_MUX_ENV_ACC	= 4; // env 0,5..10kHz
const _Viana2_SETUP_MUX_SLOW_ACC	= 5; // slow 0,5..50Hz
const _Viana2_SETUP_MUX_SLOW_VEL	= 6; // slow 0,5..50Hz
const _Viana2_SETUP_MUX_SLOW_DISP	= 7; // slow 0,5..50Hz
const _Viana2_SETUP_MUX_COUNT		= 8;


// ������� ��������� ������
Type _Viana2_TMeasureSetup = record

	Changed	: longword;	// 1 = MeasureSetup ���������, �������� � Hardware

	MeasurementMode	: longword;	// ��� ��������, SETUP_MSM_xxx

	// ��� ��������� �� 1 �� N - ������������� ������� ��������� � ���������
	Path	: longword;		// SETUP_MSP_xxx
	Channels	: longword;	// SETUP_MSC_xxx
	Units	: longword;		// SETUP_MSU_xxx
	Types	: longword;		// SETUP_MST_xxx

	dX	: longword;		// SETUP_DX_xxx ��� SETUP_FN_xxx
	AllX	: longword;		// SETUP_ALLX_xxx ��� SETUP_ALLF_xxx

	Avg	: longword;		// SETUP_AVG_xxx
	AutoSave	: longword;	// SETUP_AUTO_SAVE_xxx


	// ��� ������ ��� ����������� �������������:
	InternalDAC	: longword; // ������������ ������: 0 - ���� � ��������, 1 - DAC
	CalibrationMode	: longword; // 0 - ������, 1 - ����������

							  // ��� ������������ � ����������
	FreqSin	: single;	// �������, ��
	AmplSin	: single;	// ��������� ���, ������

	// ���� (Path == SETUP_MSP_MUX) ��� (Units == SETUP_MSU_MUX), �� ����� MUX ������ �� ����� ����
	Mux	: longword;	// SETUP_MUX_xxx

	Reserv	: longword;

end;
const sz_Viana2_TMeasureSetup = sizeof(_Viana2_TMeasureSetup); // 64








const FILE_VERSION_VIANA2_0100    = $C710; // ����� ������ ����� 1.0
const FILE_VERSION_VIANA2_CURRENT = FILE_VERSION_VIANA2_0100;




//       u32 Exist; // 0 -  ���; 1 - ������ c ��������� ������; 2 - ���������������
const _Viana2_teNo       = 0;
const _Viana2_teHard     = 1;
const _Viana2_teSoft     = 2;

Type _Viana2_TDateTime = longword;
     _Viana2_TTime     = Longword;
     _Viana2_TDate     = Longword;

Type _Viana2_TTable = record

       Exist      : longword; // 0 -  ���; 1 - ������ c ��������� ������; 2 - ���������������
       DT         : _Viana2_TDateTime;       //����� � ���� ���������� ������

       Types      : longword;
       Units      : longword;
       AllX       : longword;

       X0         : single;
       dX         : single;
       XN         : single;


		AmplMax	: single;   // ������������ �������� � �������
		AmplMin	: single;   // ����������� �������� � �������

       Scale      : single;

       OffT       : longword;	// �������� ������ ������ � ����� ��� ����� � ������
       OffTx64	  : longword;	// ����� ��� ������ x64

        Reserv1		: array [0..1] of byte;
        DataFormat	: byte;		// ������ ������������� �������� � OffT - MeasurementDataFormat::XXX
        DrawOptions	: byte;	// ��� ������������ ������ - DrawGraphOptions::XXX

        // ����� ������ � ����� ��� � ������ � ������ - ����� ���� ����� 0. 
        // ��� ������� = AllX * szTOnePoint
        // ��� ������������ ������� = AllX * 2 * szTOnePoint
		LenT       : longword;

		Tick		: longword;           // Tick1024 ��� ����� ������� �������

		Reserv		: array [0..6-1] of longword;

end;
const sz_Viana2_TTable = sizeof(_Viana2_TTable); // 88



(*
��� �������: float X[0],X[1],...,X[AllX-1]
��� ������������ �������: float Re[0],Im[0],Re[1],Im[1],...,Re[AllX-1],Im[AllX-1]
*)



Type _Viana2_TOneChannel = record

	Exist		: longword; // 0=teNo -  ���; 1=teHard - ������ c ��������� ������; 2=teSoft - ���������������
	Align1		: longword;

    ValueInstant: array [0.._Viana2_svCOUNT-1] of single;	// ����������� �� �������/������� ������� (����������) �������� Peak, P-P, RMS, Zero, ...
	ValueHarmonicsCalculatedTick : longword; // Tick1024 ���������� ������������ RE1..IM3. ��� ��������� �����, ��� ��� ��������� ������ �� �������
	ValueInstantCalculated	: longword;	// ������, ����� �� ValueInstant ���������

	ValueAvg	: array [0.._Viana2_svCOUNT-1] of single; // ���������� �� ����������� �� �������/������� Peak, P-P, RMS, Zero, ...
	ValueAvgCalculatedTick : longword;
	ValueAvgCalculated		: longword;	// ������, ����� �� ValueAvg ���������

	Table: array [0.._Viana2_ztWavSp-1] of _Viana2_TTable;

	Reserv: array [0..14-1] of longword;
end;
const sz_Viana2_TOneChannel = sizeof(_Viana2_TOneChannel); // 512


Type _Viana2_TOnePoint = single;	// ������� �������� � float
const sz_Viana2_TOnePoint = sizeof(_Viana2_TOnePoint);

Type _Viana2_TOneChannelData = array [0.._Viana2_MAX_POINT_RECORDER-1] of _Viana2_TOnePoint; // ������ ������ ������ ������
const sz_Viana2_TOneChannelData = sizeof(_Viana2_TOneChannelData);





// ��������� ��� ������ � ����, ��� ������� �� ������
Type _Viana2_TMeas = record

	Exist		: word;	// 0=teNo -  ���; 1=teHard - ������ c ��������� ������; 2=teSoft - ���������������
	Version		: word;
	DT			: _Viana2_TDateTime;       //����� � ���� ���������� ������

	LastDataTick: longword;  // Tick1024 ������ ������ ��� ��������� ���������� �������� ��� ������� ������� (� ��� ����� ������� ������ 1 ���)
	Align1		: longword;

	MeasSetup	: _Viana2_TMeasureSetup; //  ��� �������� ? ����� �����, ��� ������������

	Count		: longword;          // ����� ������� ��������
	Channels	: longword;       // ����� ������������ ��������

	// ��� �������� � ������
	Types		: longword;
	Units		: longword;

	FreqTach	: single;    // ������� �� ���������

	TempValue	: single;    // �����������, ���� �������

	// ���������� ������� / �� �������
	SpectrumAvg	: longword;
	SpectrumAvgMax: longword;

	FHP	: single;          // ������� ������� �������
	FLP	: single;          // ������ ������� �������

	// ������� ������� � ���������-���������
	CH	: array [0.._Viana2_CHANNEL_COUNT-1] of _Viana2_TOneChannel;

	Reserv: array [0..65-1] of longword;

	Align	: TCRC; // ��� ������������
	CRC		: TCRC;

end;
const sz_Viana2_TMeas = sizeof(_Viana2_TMeas); // 1920








// ����� ��� ��� ������
const _Viana2_AURORA_CELL_MAX_POINTS   = 14; // �����
const _Viana2_AURORA_CELL_MAX_AXES     = 3; // �����������

const _Viana2_POINT_READED_MASK     = $07; // ��������� ���


Type _Viana2_TRMSMeasurement = record

	Exist		: word;	// 0=teNo -  ���; 1=teHard - ������ c ��������� ������; 2=teSoft - ���������������
	Version		: word;
	DT			: _Viana2_TDateTime;       //����� � ���� ���������� ������

	MeasSetup	: _Viana2_TMeasureSetup; //  ��� �������� ? ����� �����, ��� ������������

  	Value      	: array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1, 0.._Viana2_eiVIBRO-1] of single;
  	Temp       	: array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1] of single;

	PointReaded	: array [0.._Viana2_AURORA_CELL_MAX_POINTS-1] of byte; // ������� ����� ��� ������ �����, �������� �� �����: 1 - �; 2 - �; 4 - �;
	Align2		: word;

    // ���� ��� Viana2 ������ Diag
  	ValueViewMode : array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1, 0.._Viana2_eiVIBRO-1] of byte;	// ��� ����� � Value, ��������, svRMS
	Align3		: word;

  	RMSVelocityValue : array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1] of single; // �������� RMS Vel ��� ���������� ���������

	// ���� ��� Viana2 ������ Diag
	Channel	: array [0.._Viana2_AURORA_CELL_MAX_POINTS-1, 0.._Viana2_AURORA_CELL_MAX_AXES-1] of byte; // � ������ ������ �������� �������� (CH_1 ��� CH_2)
	Align4	: word;

	Reserv: array [0..44-1] of longword;

	Align	: TCRC; // ��� ������������
	CRC		: TCRC;

end;
const sz_Viana2_TRMSMeasurement = sizeof(_Viana2_TRMSMeasurement); // 1280













(*
//------------------------------ �������� Viana2 ------------------------------


//---------- �������� �������� ----------
const NameRoute_V2   = 64;   //����� ����� � �������� (� ������� = 60)
      MaxRouteNode_V2 = 1024;
      RouteVersion_V2 = $200; // ������ ��������� 2.00


// TRouteNode_V2.Exists
const rneFlagNone   = 0; // �� ��������� - �� ������������
      rneFlagFilled = 1; // ��������� ���������
      rneFlagReaded = 3; // rneFilled + ������ ������

// ������ 0xFFFFFFFF, ����� ����� ���� ���������� �� Flash  ��� ��������
const rneNone   = $FFFFFFFF; // �� ��������� - �� ������������
      rneFilled = (rneNone xor rneFlagFilled); // ��������� ���������
      rneReaded = (rneNone xor rneFlagReaded); // rneFilled + ������ ������



//---------- ��������� ������� ----------
Type TRouteNode_V2 = record

      Exists       : longword;    // rneXXX
      DataID       : longint;    // ������������� ������ �� Flash ��� 0 ��� -1, ���� ���

      Name         : array [0..NameRoute_V2-1] of AnsiChar;

      Order        : longword;      //�� �������; ��� ����� ������ ���� >0 ; ��� ������� � ������� = 0

// ������ ��� �����
      Tip          : longword;        //��� ������� (������/������)
      EdIzm        : longword;      //������� ���������
      Channel      : longword;    //����� 1..N; 0 - ��-���������
      Lines        : longint;      //����� ����� � �������
      LoFreq       : longint;     //������ ��������� �������, ��
      HiFreq       : longint;     //������� ��������� �������, ��
      NAverg       : longint;     //����� ����������, ������ ��� ������� (����� �� �������������� ��������)
      Stamper      : longword;    // 1 - ����� �� ��������� (����� �� �������������� ��������)


      Deep         : longint;
      Parent       : longint;      // ������ ������
      ChildCount   : longint;  // ����� ������������
      Expanded     : longword;    // ���� ������ ������� (��� ��������� ������)
      Marked       : longword;      // ���� ������ ������� (�� �������)

      //  ��� ��������� �������� � �������� � �������
      ID           : longword;        // ������������� �����
      Offset       : longword;        // �������� � ��������� �����
      Len          : longword;        // ����� � ��������� �����

      Reserv       : array [0..3] of longword;

      Align        : TCRC;
      CRC          : TCRC;
end;



//---------- ��������� ��������� �������� ----------
Type TRouteHdr_V2 = record

      Version      : longword;       // 0x200 ��� ���� ������

      Name         : array [0..NameRoute_V2-1] of AnsiChar;

      Count        : longint;         // ����� ��������� Node

      Reserv       : array [0..15] of longword;

      Align        : TCRC;
      CRC          : TCRC;
end;


//---------- ������� ----------
Type TRoute_V2 = record

     Hdr       : TRouteHdr_V2;           //��������� ��������

     Node      : array [0..MaxRouteNode_V2-1] of TRouteNode_V2;    // �������� ��������

end;


const szTRouteNode_V2 = sizeof(TRouteNode_V2);
      szTRouteHdr_V2  = sizeof(TRouteHdr_V2);
      szTRoute_V2     = sizeof(TRoute_V2); // ~140��

*)




implementation



initialization

assert(sz_Viana2_TMeasureSetup = 64);
assert(sz_Viana2_TTable = 88);
assert(sz_Viana2_TOneChannel = 512);
assert(sz_Viana2_TMeas = 1920);
assert(sz_Viana2_TRMSMeasurement = 1280);

end.


