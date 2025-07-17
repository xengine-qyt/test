#include "pch.h"
#include "BaseSafe_Memory.h"
/********************************************************************
//    Created:     2024/06/26  14:38:40
//    File Name:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\BaseSafe_Memory\BaseSafe_Memory.cpp
//    File Path:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\BaseSafe_Memory
//    File Base:   BaseSafe_Memory
//    File Ext:    cpp
//    Project:     XEngine(网络通信引擎)
//    Author:      qyt
//    Purpose:     内存安全操作
//    History:
*********************************************************************/
CBaseSafe_Memory::CBaseSafe_Memory()
{
}
CBaseSafe_Memory::~CBaseSafe_Memory()
{
}
//////////////////////////////////////////////////////////////////////////
//                      公有函数
//////////////////////////////////////////////////////////////////////////
/********************************************************************
函数名称：BaseSafe_Memory_Memcopy
函数功能：安全的内存拷贝函数
 参数.一：ptszDestByte
  In/Out：Out
  类型：无类型指针
  可空：N
  意思：输出拷贝的内存
 参数.三：nDestSize
  In/Out：In
  类型：整数型
  可空：N
  意思：输入目标缓冲区最大大小
 参数.二：lpszSourceByte
  In/Out：In
  类型：常量字符指针
  可空：N
  意思：输入要拷贝的内存
 参数.三：nDestSize
  In/Out：In
  类型：整数型
  可空：N
  意思：输入要拷贝的缓冲区最大大小
返回值
  类型：逻辑型
  意思：是否拷贝成功
备注：
*********************************************************************/
bool CBaseSafe_Memory::BaseSafe_Memory_Memcopy(void* ptszDestByte, size_t nDestSize, LPCXBTR lpszSourceByte, size_t nSourceSize)
{
	
	return true;
}
/********************************************************************
函数名称：BaseSafe_Memory_Memmove
函数功能：安全的内存重叠区域处理拷贝函数
 参数.一：ptszDestByte
  In/Out：Out
  类型：无类型指针
  可空：N
  意思：输出拷贝的内存
 参数.三：nDestSize
  In/Out：In
  类型：整数型
  可空：N
  意思：输入目标缓冲区最大大小
 参数.二：lpszSourceByte
  In/Out：In
  类型：常量字符指针
  可空：N
  意思：输入要拷贝的内存
 参数.三：nDestSize
  In/Out：In
  类型：整数型
  可空：N
  意思：输入要拷贝的缓冲区最大大小
返回值
  类型：逻辑型
  意思：是否拷贝成功
备注：
*********************************************************************/
bool CBaseSafe_Memory::BaseSafe_Memory_Memmove(void* ptszDestByte, size_t nDestSize, LPCXBTR lpszSourceByte, size_t nSourceSize)
{
	

	return true;
}