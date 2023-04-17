#ifndef ROUTE_H
#define ROUTE_H

#include "Protocol.h"
#include "SysUtil.h"




#define EnableRoute


//------------------------------ �������� �� �����-2� ------------------------------

//---------- �������� �������� ----------
#define NameRoute_V1          16   //����� ����� ��������


// ��������� �� �������
#define ztWaveformAtlant 2 // ������
#define ztSpectrumAtlant 4 // ������
#define ztEnvelopeAtlant 0x200 // ���������
#define ztEnvSpectrumAtlant  32 // ������ ���������

#define eiAccelerationAtlant 4 // ���������, �/�2
#define eiVelocityAtlant     2 // ��������, ��/�
#define eiDisplacementAtlant 1 // �����������, ���
#define eiVoltAtlant         16 // ������, �



//---------- ��������� ���������� ������� ----------
typedef struct stRouteSignalParameters_V1
{
	u16   Type;        //��� ������� (������/������)
	u16   Units;      //������� ���������
	u16   Lines;      //����� ����� � �������
	u16   LoFreq;     //������ ��������� �������
	u16   HiFreq;     //������� ��������� �������
	u16   NAverg;     //����� ����������, ������ ��� ������� (����� �� �������������� ��������)
	char  Stamper;    //����� �� ��������� (����� �� �������������� ��������)
	char  reserv[20];
} TRouteSignalParameters_V1;

//---------- ��������� ����� ----------
typedef struct stRoutePoint_V1
{
	u16    Order;
	char   Station[NameRoute_V1];        //----- ������� -----
	char   Shop[NameRoute_V1];           //----- ��� -----
	char   Department[NameRoute_V1];     //----- ������������� -----
	char   Agregat[NameRoute_V1];        //----- ������� -----
	char   Point[NameRoute_V1];          //----- ����� -----
	TRouteSignalParameters_V1 Param;     //������ �� ���� �������� ���������� ��������
	char   Reserv[4];
} TRoutePoint_V1;

//---------- ��������� ��������� �������� ----------
typedef struct stRouteMain_V1
{
	char Name[NameRoute_V1];
	u16  CountStation;    //����� ������� � ��������
	u16  CountShop;       //����� ����� � ��������
	u16  CountDepartment; //����� ������������� � ��������
	u16  CountAgregat;    //����� ��������� � ��������
	u16  CountPoint;
	char Version;
	char Reserv[59];
	TCRC CRC;
} TRouteMain_V1;

//---------- ������ ��������� ����� ----------
typedef struct stRoutePointFull_V1
{
	char        ID;        //������������� �����
	TRoutePoint_V1 Point;     //��������� �����
	u16         DataID;    //��������� �� ������������� ������
	char        Reserv[4];
	u16         CRC;         //CRC
} TRoutePointFull_V1;


#define MaxRoutePoint_V1 255

typedef struct stReceptionRoute_V1
{
	char             Enable;        //��������� ��� ���� ����� ��������
	TRouteMain_V1       Hdr;           //��������� ��������
	TRoutePointFull_V1  Point[MaxRoutePoint_V1];    //��������� �� ����� ��������
	u16              CurrentPoint;  //����� �������� �����
	u32              Size;          //������ ������ ��������� ��������, ����������� �� ������ ��������
} TReceptionRoute_V1;

int  LoadRouteHeader(u32 ID, TRouteMain_V1 *Buf);
int  CheckStructRoute(u32 index, TReceptionRoute_V1 *Route, u32 *OnePoint, u32  *CurPoint);
char LoadRouteName(u32 ID, char *buf);

int  DeleteRoutePointFunc(struct TreeNode *aNode);




//------------------------------ �������� VV-2 ------------------------------



//---------- �������� �������� ----------
#define NameRoute_V2    64   //����� ����� � �������� (� ������� = 60)
#define MaxRouteNode_V2 1024
#define RouteVersion_V2 0x200 // ������ ��������� 2.00


// TRouteNode_V2.Exists
#define rneFlagNone   0 // �� ��������� - �� ������������
#define rneFlagFilled 1 // ��������� ���������
#define rneFlagReaded 3 // rneFilled + ������ ������

// ������ 0xFFFFFFFF, ����� ����� ���� ���������� �� Flash  ��� ��������
#define rneNone   0xFFFFFFFF // �� ��������� - �� ������������
#define rneFilled (~rneFlagFilled) // ��������� ���������
#define rneReaded (~rneFlagReaded) // rneFilled + ������ ������



bool IsNodeFilled(const int32_t aIndex);
bool IsNodeReaded(const int32_t aIndex);


//---------- ��������� ������� ----------
typedef struct stRouteNode_V2
{
	u32   Exists;    // rneXXX
	s32   DataID;    // ������������� ������ �� Flash ��� -1, ���� ���

	char  Name[NameRoute_V2];

	u32   Order;      //�� �������; ��� ����� ������ ���� >0 ; ��� ������� � ������� = 0

	// ������ ��� �����
	u32   Type;        //��� ������� (������/������)
	u32   Units;      //������� ���������
	u32   Channel;    //����� 1..N; 0 - ��-���������
	s32   Lines;      //����� ����� � �������
	s32   LoFreq;     //������ ��������� �������, ��
	s32   HiFreq;     //������� ��������� �������, ��
	s32   NAverg;     //����� ����������, ������ ��� ������� (����� �� �������������� ��������)
	u32   Stamper;    // 1 - ����� �� ��������� (����� �� �������������� ��������)

	s32   Deep;
	s32   Parent;      // ������ ������
	s32   ChildCount;  // ����� ������������
	u32   Expanded;    // ���� ������ ������� (��� ��������� ������)
	u32   Marked;      // ���� ������ ������� (�� �������)

	//  ��� ��������� �������� � �������� � �������
	u32   ID;        // ������������� �����
	u32   Offset;    // �������� � ��������� �����
	u32   Len;       // ����� � ��������� �����

	u32   Reserv[4];

	TCRC  Align;
	TCRC  CRC;
} TRouteNode_V2;



//---------- ��������� ��������� �������� ----------
typedef struct stRouteHdr_V2
{
	u32  Version;       // 0x200 ��� ���� ������

	char Name[NameRoute_V2];

	s32  Count;         // ����� ��������� Node

	u32  Reserv[16];

	TCRC Align;
	TCRC CRC;
} TRouteHdr_V2;


//---------- ������� ----------
typedef struct stRoute_V2
{
	TRouteHdr_V2     Hdr;           //��������� ��������

	TRouteNode_V2   Node[MaxRouteNode_V2];    // �������� ��������

} TRoute_V2;


#define szTRouteNode_V2 sizeof(TRouteNode_V2)
#define szTRouteHdr_V2 sizeof(TRouteHdr_V2)
#define szTRoute_V2 sizeof(TRoute_V2) // ~140��






#endif	 //ROUTE_H

