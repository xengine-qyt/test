#pragma once
/********************************************************************
//    Created:     2024/06/26  14:37:58
//    File Name:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\BaseSafe_Memory\BaseSafe_Memory.h
//    File Path:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\BaseSafe_Memory
//    File Base:   BaseSafe_Memory
//    File Ext:    h
//    Project:     XEngine(网络通信引擎)
//    Author:      qyt
//    Purpose:     内存安全操作
//    History:
*********************************************************************/

class CBaseSafe_Memory
{
public:
	CBaseSafe_Memory();
	~CBaseSafe_Memory();
public:
	bool BaseSafe_Memory_Memcopy(void* ptszDestByte, size_t nDestSize, LPCXBTR lpszSourceByte, size_t nSourceSize);
	bool BaseSafe_Memory_Memmove(void* ptszDestByte, size_t nDestSize, LPCXBTR lpszSourceByte, size_t nSourceSize);
protected:
private:
};