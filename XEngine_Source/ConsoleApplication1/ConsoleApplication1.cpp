#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include <XEngine_Include/XEngine_CommHdr.h>
#include <XEngine_Include/XEngine_BaseLib/BaseLib_Define.h>
#include <XEngine_Include/XEngine_BaseLib/BaseLib_Error.h>


int main()
{
    printf("123\n");
    XCHAR tszTimeStr[MAX_PATH] = {};

    BaseLib_Time_TimeToStr(tszTimeStr);

    printf("%s\n", tszTimeStr);
    return 0;
}