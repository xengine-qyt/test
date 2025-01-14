#ifdef _MSC_BUILD
#include <Windows.h>
#include <tchar.h>
#pragma comment(lib,"Ws2_32.lib")
#else
#include <sys/socket.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>
#include <thread>
using namespace std;
#include <XEngine_Include/XEngine_CommHdr.h>
#include <XEngine_Include/XEngine_Types.h>
#include <XEngine_Include/XEngine_ProtocolHdr.h>
#include <XEngine_Include/XEngine_BaseLib/BaseLib_Define.h>
#include <XEngine_Include/XEngine_BaseLib/BaseLib_Error.h>
#include <XEngine_Include/XEngine_Core/NetCore_Define.h>
#include <XEngine_Include/XEngine_Core/NetCore_Error.h>

#pragma comment(lib,"XEngine_BaseLib/XEngine_BaseLib.lib")
#pragma comment(lib,"XEngine_Core/XEngine_Core.lib")

XHANDLE xhTCPCore = NULL;
XHANDLE xhUDPCore = NULL;
XHANDLE xhUDX = NULL;
XCHAR tszClientAddr[64];

bool CALLBACK TCPOverlapped_Login(LPCXSTR lpszClientAddr, XSOCKET hSocket, XPVOID lParam)
{
	printf("TCPOverlapped_Login:%s = %d\n", lpszClientAddr, hSocket);
	return true;
}
void CALLBACK TCPOverlapped_Recv(LPCXSTR lpszClientAddr, XSOCKET hSocket, LPCXSTR lpszRecvMsg, int nMsgLen, XPVOID lParam)
{
	printf("TCPOverlapped_Recv:%s = %s = %d\n", lpszClientAddr, lpszRecvMsg, nMsgLen);
}
void CALLBACK TCPOverlapped_Leave(LPCXSTR lpszClientAddr, XSOCKET hSocket, XPVOID lParam)
{
	printf("TCPOverlapped_Leave:%s\n", lpszClientAddr);
}
void CALLBACK Callback_UDPRecv(LPCXSTR lpszClientAddr, XSOCKET hSocket, LPCXSTR lpszRecvMsg, int nMsgLen, XPVOID lParam)
{
	printf("TCPOverlapped_Recv:%s = %s = %d\n", lpszClientAddr, lpszRecvMsg, nMsgLen);
	NetCore_UDPXCore_SendEx(xhUDPCore, lpszClientAddr, lpszRecvMsg, nMsgLen);
}

int test_tcpxpoll()
{
	if (NetCore_TCPXPoll_Start(5001))
	{
		printf(_X("test_tcpxpoll Start Is Ok!\n"));
	}
	else
	{
		printf(_X("test_tcpxpoll Start Is Failed!\n"));
	}
	NetCore_TCPXPoll_RegisterCallBack(TCPOverlapped_Login, TCPOverlapped_Recv, TCPOverlapped_Leave);
	return 0;
}
int test_tcpxcore()
{
	xhTCPCore = NetCore_TCPXCore_StartEx(5000);
	if (NULL != xhTCPCore)
	{
		printf(_X("NetCore_TCPXCore_StartEx Start Is Ok!\n"));
	}
	else
	{
		printf(_X("NetCore_TCPXCore_StartEx Start Is Failed!\n"));
	}
	NetCore_TCPXCore_RegisterCallBackEx(xhTCPCore, TCPOverlapped_Login, TCPOverlapped_Recv, TCPOverlapped_Leave);
	NetCore_TCPXCore_PasueRecvEx(xhTCPCore, tszClientAddr);

	int nCount = 0;
	XCHAR** ppszListClient;
	NetCore_TCPXCore_GetAllEx(xhTCPCore, &ppszListClient, &nCount);
	for (int i = 0; i < nCount; i++)
	{
		printf("%d:%s\n", i, ppszListClient[i]);
	}
	BaseLib_Memory_Free((XPPPMEM)&ppszListClient, nCount);

	NetCore_TCPXCore_CloseForClientEx(xhTCPCore, tszClientAddr);
	return 0;
}
int test_udpxcore()
{
	xhUDPCore = NetCore_UDPXCore_StartEx(5002);
	if (NULL != xhUDPCore)
	{
		printf(_X("NetCore_UDPXCore_StartEx Start Is Ok!\n"));
	}
	else
	{
		printf(_X("NetCore_UDPXCore_StartEx Start Is Failed!\n"));
	}
	NetCore_UDPXCore_RegisterCallBackEx(xhUDPCore, Callback_UDPRecv);
	return 0;
}
int test_unixdomain()
{
#ifdef _MSC_BUILD
	LPCXSTR lpszUnixName = _X("d:\\xengine_apps\\Debug\\unix.socket");
#else
	LPCXSTR lpszUnixName = "/tmp/unix.socket";
#endif
	if (NetCore_UnixDomain_Start(lpszUnixName))
	{
		printf(_X("NetCore_UnixDomain_Start Start Is Ok!\n"));
	}
	else
	{
		printf(_X("NetCore_UnixDomain_Start Start Is Failed!\n"));
	}
	NetCore_UnixDomain_SetCallback(TCPOverlapped_Login, TCPOverlapped_Recv, TCPOverlapped_Leave);

	return 1;
}
int main()
{
#ifdef _MSC_BUILD
	WSADATA st_WSAData;
	WSAStartup(MAKEWORD(2, 2), &st_WSAData);
#endif

	test_tcpxcore();
	printf("ok\n");
	NetCore_TCPXCore_DestroyEx(xhTCPCore);
#ifdef _MSC_BUILD
	WSACleanup();
#endif
	return 0;
}