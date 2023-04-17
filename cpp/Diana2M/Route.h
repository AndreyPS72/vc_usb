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

//---------- �������� �������� ----------
#define NameRoute          16   //����� ����� ��������

//---------- ��������� ���������� ������� ----------
typedef struct stRouteSignalParameters
{
u16   Tip;        //��� ������� (������/������)
u16   EdIzm;      //������� ���������
u16   Lines;      //����� ����� � �������
u16   LoFreq;     //������ ��������� �������
u16   HiFreq;     //������� ��������� �������
u16   NAverg;     //����� ����������, ������ ��� ������� (����� �� �������������� ��������)
char  Stamper;    //����� �� ��������� (����� �� �������������� ��������)
char  reserv[20];
}TRouteSignalParameters;

//---------- ��������� ����� ----------
typedef struct stRoutePoint
{
u16    Order;
char   Station[NameRoute];        //----- ������� -----
char   Shop[NameRoute];           //----- ��� -----
char   Department[NameRoute];     //----- ������������� -----
char   Agregat[NameRoute];        //----- ������� -----
char   Point[NameRoute];          //----- ����� -----
TRouteSignalParameters Param;     //������ �� ���� �������� ���������� ��������
char   Reserv[4];
}TRoutePoint;

//---------- ��������� ��������� �������� ----------
typedef struct stRouteMain
{
char Name[NameRoute];
u16  CountStation;    //����� ������� � ��������
u16  CountShop;       //����� ����� � ��������
u16  CountDepartment; //����� ������������� � ��������
u16  CountAgregat;    //����� ��������� � ��������
u16  CountPoint;
char Version;
char Reserv[59];
TCRC CRC;
}TRouteMain;

//---------- ������ ��������� ����� ----------
typedef struct stRoutePointFull
{
char        ID;        //������������� �����
TRoutePoint Point;     //��������� �����
u16         DataID;    //��������� �� ������������� ������
char        Reserv[4];
u16         CRC;         //CRC
}TRoutePointFull;

typedef struct stReceptionRoute
{
char             Enable;        //��������� ��� ���� ����� ��������
TRouteMain       Hdr;           //��������� ��������
TRoutePointFull  Point[255];    //��������� �� ����� ��������
u16              CurrentPoint;  //����� �������� �����
u32              Size;          //������ ������ ��������� �������� ���������� �� ������� ��������
}TReceptionRoute;

int  LoadRouteHeader(u32 ID,TRouteMain *Buf);
int  CheckStructRoute(u32 index, TReceptionRoute *Route, u32 *OnePoint, u32  *CurPoint);
char LoadRouteName(u32 ID,char *buf);

s32  RunAddRoutePoint(u32 ID,TTreeView *Tree, s32 Root, u32 deep);
int  RunTreeRouteWin(TTreeView *Tree, char *Caption, char Option);

int  DeleteRoutePointFunc(struct TreeNode *aNode);


#endif	 //ROUTE_H

