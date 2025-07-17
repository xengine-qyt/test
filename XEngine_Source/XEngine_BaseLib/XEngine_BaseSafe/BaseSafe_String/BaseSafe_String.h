#pragma once
/********************************************************************
//    Created:     2024/06/19  15:16:14
//    File Name:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\BaseSafe_String\BaseSafe_String.h
//    File Path:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\BaseSafe_String
//    File Base:   BaseSafe_String
//    File Ext:    h
//    Project:     XEngine(网络通信引擎)
//    Author:      qyt
//    Purpose:     安全的字符串操作函数
//    History:
*********************************************************************/

class CBaseSafe_String
{
public:
	CBaseSafe_String();
	~CBaseSafe_String();
public:
	size_t BaseSafe_String_Strcopy(XCHAR* ptszDestStr, LPCXSTR lpszSourceStr, size_t nDestSize);
	size_t BaseSafe_String_Strcat(XCHAR* ptszMSGBuffer, size_t nMSGSize, LPCXSTR lpszMSGBuffer);
protected:
private:
};