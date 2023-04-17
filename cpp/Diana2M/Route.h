#ifndef ROUTE_H
#define ROUTE_H

#include "Protocol.h"
#include "SysUtil.h"
#ifndef __emulator
   #include "EFC.h"
   #include "BoardAdd.h"
#endif

#include "TreeWin.h"


#define EnableRoute

//---------- Описание констант ----------
#define NameRoute          16   //Длина имени маршрута

//---------- Структура параметров сигнала ----------
typedef struct stRouteSignalParameters
{
u16   Tip;        //тип сигнала (сигнал/спектр)
u16   EdIzm;      //единицы измерения
u16   Lines;      //число линий в спектре
u16   LoFreq;     //нижняя граничная частота
u16   HiFreq;     //верхняя граничная частота
u16   NAverg;     //число усреднений, только для спектра (может не использоваться прибором)
char  Stamper;    //старт по отметчику (может не использоваться прибором)
char  reserv[20];
}TRouteSignalParameters;

//---------- Структура точки ----------
typedef struct stRoutePoint
{
u16    Order;
char   Station[NameRoute];        //----- станция -----
char   Shop[NameRoute];           //----- Цех -----
char   Department[NameRoute];     //----- подразделение -----
char   Agregat[NameRoute];        //----- агрегат -----
char   Point[NameRoute];          //----- точка -----
TRouteSignalParameters Param;     //массив из трех структур параметров сигналов
char   Reserv[4];
}TRoutePoint;

//---------- Зоголовок структуры маршрута ----------
typedef struct stRouteMain
{
char Name[NameRoute];
u16  CountStation;    //число станций в маршруте
u16  CountShop;       //число цехов в маршруте
u16  CountDepartment; //число подразделений в маршруте
u16  CountAgregat;    //число агрегатов в маршруте
u16  CountPoint;
char Version;
char Reserv[59];
TCRC CRC;
}TRouteMain;

//---------- Полная структура точки ----------
typedef struct stRoutePointFull
{
char        ID;        //идентификатор точки
TRoutePoint Point;     //структура точки
u16         DataID;    //указатель на идентификатор замера
char        Reserv[4];
u16         CRC;         //CRC
}TRoutePointFull;

typedef struct stReceptionRoute
{
char             Enable;        //указывает что идет прием маршрута
TRouteMain       Hdr;           //заголовок маршрута
TRoutePointFull  Point[255];    //указатель на точку маршрута
u16              CurrentPoint;  //число принятых точек
u32              Size;          //полный размер структуры маршрута выравненый на разимер кластера
}TReceptionRoute;

int  LoadRouteHeader(u32 ID,TRouteMain *Buf);
int  CheckStructRoute(u32 index, TReceptionRoute *Route, u32 *OnePoint, u32  *CurPoint);
char LoadRouteName(u32 ID,char *buf);

s32  RunAddRoutePoint(u32 ID,TTreeView *Tree, s32 Root, u32 deep);
int  RunTreeRouteWin(TTreeView *Tree, char *Caption, char Option);

int  DeleteRoutePointFunc(struct TreeNode *aNode);


#endif	 //ROUTE_H

