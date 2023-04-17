#ifndef ROUTE_H
#define ROUTE_H

#include "Protocol.h"
#include "SysUtil.h"




#define EnableRoute


//------------------------------ Маршруты из Дианы-2М ------------------------------

//---------- Описание констант ----------
#define NameRoute_V1          16   //Длина имени маршрута


// Константы из Атланта
#define ztWaveformAtlant 2 // Сигнал
#define ztSpectrumAtlant 4 // Спектр
#define ztEnvelopeAtlant 0x200 // Огибающая
#define ztEnvSpectrumAtlant  32 // Спектр огибающей

#define eiAccelerationAtlant 4 // Ускорение, м/с2
#define eiVelocityAtlant     2 // Скорость, мм/с
#define eiDisplacementAtlant 1 // Перемещение, мкм
#define eiVoltAtlant         16 // Вольты, В



//---------- Структура параметров сигнала ----------
typedef struct stRouteSignalParameters_V1
{
	u16   Type;        //тип сигнала (сигнал/спектр)
	u16   Units;      //единицы измерения
	u16   Lines;      //число линий в спектре
	u16   LoFreq;     //нижняя граничная частота
	u16   HiFreq;     //верхняя граничная частота
	u16   NAverg;     //число усреднений, только для спектра (может не использоваться прибором)
	char  Stamper;    //старт по отметчику (может не использоваться прибором)
	char  reserv[20];
} TRouteSignalParameters_V1;

//---------- Структура точки ----------
typedef struct stRoutePoint_V1
{
	u16    Order;
	char   Station[NameRoute_V1];        //----- станция -----
	char   Shop[NameRoute_V1];           //----- Цех -----
	char   Department[NameRoute_V1];     //----- подразделение -----
	char   Agregat[NameRoute_V1];        //----- агрегат -----
	char   Point[NameRoute_V1];          //----- точка -----
	TRouteSignalParameters_V1 Param;     //массив из трех структур параметров сигналов
	char   Reserv[4];
} TRoutePoint_V1;

//---------- Заголовок структуры маршрута ----------
typedef struct stRouteMain_V1
{
	char Name[NameRoute_V1];
	u16  CountStation;    //число станций в маршруте
	u16  CountShop;       //число цехов в маршруте
	u16  CountDepartment; //число подразделений в маршруте
	u16  CountAgregat;    //число агрегатов в маршруте
	u16  CountPoint;
	char Version;
	char Reserv[59];
	TCRC CRC;
} TRouteMain_V1;

//---------- Полная структура точки ----------
typedef struct stRoutePointFull_V1
{
	char        ID;        //идентификатор точки
	TRoutePoint_V1 Point;     //структура точки
	u16         DataID;    //указатель на идентификатор замера
	char        Reserv[4];
	u16         CRC;         //CRC
} TRoutePointFull_V1;


#define MaxRoutePoint_V1 255

typedef struct stReceptionRoute_V1
{
	char             Enable;        //указывает что идет прием маршрута
	TRouteMain_V1       Hdr;           //заголовок маршрута
	TRoutePointFull_V1  Point[MaxRoutePoint_V1];    //указатель на точку маршрута
	u16              CurrentPoint;  //число принятых точек
	u32              Size;          //полный размер структуры маршрута, выровненный на размер кластера
} TReceptionRoute_V1;

int  LoadRouteHeader(u32 ID, TRouteMain_V1 *Buf);
int  CheckStructRoute(u32 index, TReceptionRoute_V1 *Route, u32 *OnePoint, u32  *CurPoint);
char LoadRouteName(u32 ID, char *buf);

int  DeleteRoutePointFunc(struct TreeNode *aNode);




//------------------------------ Маршруты VV-2 ------------------------------



//---------- Описание констант ----------
#define NameRoute_V2    64   //Длина имени в маршруте (В Атланте = 60)
#define MaxRouteNode_V2 1024
#define RouteVersion_V2 0x200 // Версия маршрутов 2.00


// TRouteNode_V2.Exists
#define rneFlagNone   0 // Не заполнено - не использовать
#define rneFlagFilled 1 // Параметры заполнены
#define rneFlagReaded 3 // rneFilled + Считан сигнал

// Флажки 0xFFFFFFFF, чтобы можно было дописывать во Flash  без стирания
#define rneNone   0xFFFFFFFF // Не заполнено - не использовать
#define rneFilled (~rneFlagFilled) // Параметры заполнены
#define rneReaded (~rneFlagReaded) // rneFilled + Считан сигнал



bool IsNodeFilled(const int32_t aIndex);
bool IsNodeReaded(const int32_t aIndex);


//---------- Структура Элемент ----------
typedef struct stRouteNode_V2
{
	u32   Exists;    // rneXXX
	s32   DataID;    // идентификатор замера во Flash или -1, если нет

	char  Name[NameRoute_V2];

	u32   Order;      //Из Атланта; для точек должно быть >0 ; для станций и прочего = 0

	// Только для точек
	u32   Type;        //тип сигнала (сигнал/спектр)
	u32   Units;      //единицы измерения
	u32   Channel;    //Канал 1..N; 0 - по-умолчанию
	s32   Lines;      //число линий в спектре
	s32   LoFreq;     //нижняя граничная частота, Гц
	s32   HiFreq;     //верхняя граничная частота, Гц
	s32   NAverg;     //число усреднений, только для спектра (может не использоваться прибором)
	u32   Stamper;    // 1 - старт по отметчику (может не использоваться прибором)

	s32   Deep;
	s32   Parent;      // Индекс предка
	s32   ChildCount;  // Число подэлементов
	u32   Expanded;    // Узел дерева раскрыт (для поддержки дерева)
	u32   Marked;      // Узел дерева отмечен (на будущее)

	//  Для поддержки передачи и разборки в Атланте
	u32   ID;        // идентификатор точки
	u32   Offset;    // смещение в скачанном файле
	u32   Len;       // длина в скачанном файле

	u32   Reserv[4];

	TCRC  Align;
	TCRC  CRC;
} TRouteNode_V2;



//---------- Заголовок структуры маршрута ----------
typedef struct stRouteHdr_V2
{
	u32  Version;       // 0x200 для этой версии

	char Name[NameRoute_V2];

	s32  Count;         // Число элементов Node

	u32  Reserv[16];

	TCRC Align;
	TCRC CRC;
} TRouteHdr_V2;


//---------- Маршрут ----------
typedef struct stRoute_V2
{
	TRouteHdr_V2     Hdr;           //заголовок маршрута

	TRouteNode_V2   Node[MaxRouteNode_V2];    // элементы маршрута

} TRoute_V2;


#define szTRouteNode_V2 sizeof(TRouteNode_V2)
#define szTRouteHdr_V2 sizeof(TRouteHdr_V2)
#define szTRoute_V2 sizeof(TRoute_V2) // ~140Кб






#endif	 //ROUTE_H

