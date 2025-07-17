#include "pch.h"
#include "BaseSafe_String/BaseSafe_String.h"
#include "BaseSafe_Memory/BaseSafe_Memory.h"
/********************************************************************
//    Created:     2024/06/19  15:16:54
//    File Name:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\pch.cpp
//    File Path:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe
//    File Base:   pch
//    File Ext:    cpp
//    Project:     XEngine(网络通信引擎)
//    Author:      qyt
//    Purpose:     导出实现
//    History:
*********************************************************************/
bool BaseSafe_IsErrorOccur = false;
XLONG BaseSafe_dwErrorCode = 0;
//////////////////////////////////////////////////////////////////////////
CBaseSafe_String m_SafeString;
CBaseSafe_Memory m_SafeMemory;
//////////////////////////////////////////////////////////////////////////////////
//                         导出函数实现
//////////////////////////////////////////////////////////////////////////////////
extern "C" XLONG BaseSafe_GetLastError(int* pInt_SysError)
{
	if (NULL != pInt_SysError)
	{
		*pInt_SysError = errno;
	}
	return BaseSafe_dwErrorCode;
}
/*********************************************************************************
*                         字符串安全操作                                         *
*********************************************************************************/
extern "C" size_t BaseSafe_String_Strcopy(XCHAR* ptszDestStr, LPCXSTR lpszSourceStr, size_t nDestSize)
{
	return m_SafeString.BaseSafe_String_Strcopy(ptszDestStr, lpszSourceStr, nDestSize);
}
extern "C" size_t BaseSafe_String_Strcat(XCHAR* ptszMSGBuffer, size_t nMSGSize, LPCXSTR lpszMSGBuffer)
{
	return m_SafeString.BaseSafe_String_Strcat(ptszMSGBuffer, nMSGSize, lpszMSGBuffer);
}
/*********************************************************************************
*                         内存安全操作                                           *
*********************************************************************************/
extern "C" bool BaseSafe_Memory_Memcopy(void* ptszDestByte, size_t nDestSize, LPCXBTR lpszSourceByte, size_t nSourceSize)
{
	return m_SafeMemory.BaseSafe_Memory_Memcopy(ptszDestByte, nDestSize, lpszSourceByte, nSourceSize);
}
extern "C" bool BaseSafe_Memory_Memmove(void* ptszDestByte, size_t nDestSize, LPCXBTR lpszSourceByte, size_t nSourceSize)
{
	return m_SafeMemory.BaseSafe_Memory_Memmove(ptszDestByte, nDestSize, lpszSourceByte, nSourceSize);
}