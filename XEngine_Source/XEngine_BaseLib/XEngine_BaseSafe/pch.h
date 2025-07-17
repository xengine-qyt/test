// pch.h: 这是预编译标头文件。
// 下方列出的文件仅编译一次，提高了将来生成的生成性能。
// 这还将影响 IntelliSense 性能，包括代码完成和许多代码浏览功能。
// 但是，如果此处列出的文件中的任何一个在生成之间有更新，它们全部都将被重新编译。
// 请勿在此处添加要频繁更新的文件，这将使得性能优势无效。

#ifndef PCH_H
#define PCH_H

// 添加要在此处预编译的标头
#ifdef _MSC_BUILD
#include "framework.h"
#include <tchar.h>
#endif
#endif //PCH_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>
#include <errno.h>
#include "../../XEngine_CommHdr.h"
#include "../../XEngine_Types.h"
#include "BaseSafe_Define.h"
#include "BaseSafe_Error.h"
/********************************************************************
//    Created:     2024/06/19  15:16:31
//    File Name:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe\pch.h
//    File Path:   D:\XEngine\XEngine_SourceCode\XEngine_BaseLib\XEngine_BaseSafe
//    File Base:   pch
//    File Ext:    h
//    Project:     XEngine(网络通信引擎)
//    Author:      qyt
//    Purpose:     通用头文件
//    History:
*********************************************************************/
extern bool BaseSafe_IsErrorOccur;
extern XLONG BaseSafe_dwErrorCode;