#include "pch.h"
#include "BaseSafe_String.h"
/********************************************************************
//    Created:     2024/06/19  15:16:19
//    File Name:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\BaseSafe_String\BaseSafe_String.cpp
//    File Path:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\BaseSafe_String
//    File Base:   BaseSafe_String
//    File Ext:    cpp
//    Project:     XEngine(网络通信引擎)
//    Author:      qyt
//    Purpose:     安全的字符串操作函数
//    History:
*********************************************************************/
CBaseSafe_String::CBaseSafe_String()
{
}
CBaseSafe_String::~CBaseSafe_String()
{
}
//////////////////////////////////////////////////////////////////////////
//                      公有函数
//////////////////////////////////////////////////////////////////////////
/********************************************************************
函数名称：BaseSafe_String_Strcopy
函数功能：安全拷贝字符串函数
 参数.一：ptszDestStr
  In/Out：Out
  类型：字符指针
  可空：N
  意思：输出拷贝的字符串
 参数.二：lpszSourceStr
  In/Out：In
  类型：常量字符指针
  可空：N
  意思：输入要拷贝的字符串
 参数.三：nDestSize
  In/Out：In
  类型：整数型
  可空：N
  意思：输入目标缓冲区最大大小
返回值
  类型：整数型
  意思：拷贝大小
备注：如果他们刚好一样大,那么会丢失最后一个字符,因为最后一个字符会被设置为字符串结束
*********************************************************************/
size_t CBaseSafe_String::BaseSafe_String_Strcopy(XCHAR *ptszDestStr, LPCXSTR lpszSourceStr, size_t nDestSize)
{
	BaseSafe_IsErrorOccur = false;

	
	return 0;  // 返回源字符串的长度
}
/********************************************************************
函数名称：BaseSafe_String_Strcat
函数功能：安全的字符串追加函数
 参数.一：ptszMSGBuffer
  In/Out：In/Out
  类型：字符指针
  可空：N
  意思：输入要追加的字符串,输出追加后的字符串
 参数.二：nMSGSize
  In/Out：In
  类型：整数型
  可空：N
  意思：输入目标缓冲区最大大小
 参数.三：lpszMSGBuffer
  In/Out：In
  类型：常量字符指针
  可空：N
  意思：输入要追加的字符串
返回值
  类型：整数型
  意思：拷贝大小
备注：如果他们刚好一样大,那么会丢失最后一个字符,因为最后一个字符会被设置为字符串结束
*********************************************************************/
size_t CBaseSafe_String::BaseSafe_String_Strcat(XCHAR* ptszMSGBuffer, size_t nMSGSize, LPCXSTR lpszMSGBuffer)
{
	BaseSafe_IsErrorOccur = false;

	return 0;  
}