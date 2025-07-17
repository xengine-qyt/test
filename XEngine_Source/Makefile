CC = 
FILEEXT = 
LIBFLAG = 
ARCH = x86
RELEASE = 0
UNICODE = 0
PLATFORM = linux
PLATVER = 
PLATDIR = 
CPPFLAG = -c 
DEBUG = 
FLAGS = 

#UNICODE标记
ifeq ($(UNICODE),1)
UNICODE = "-D _UNICODE"
else
UNICODE = "-D _ANSI"
endif
#编译发布类型
ifeq ($(PLATFORM), mac)

else ifeq ($(PLATFORM), android)

else ifeq ($(PLATFORM), web)

else ifeq ($(PLATFORM), ios)
	FILEEXT = a
	
	LIBFLAG = rcs
	PLATVER = "-D __IOS__"
	PLATDIR = XEngine_IOS
	SDKPATH = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
	CC = "g++ -Wall -fPIC -std=c++20 -arch arm64 -Wno-deprecated-declarations -isysroot ${SDKPATH} -miphoneos-version-min=16.0"
	ifeq ($(RELEASE), 0)
		DEBUG = "-g -D _DEBUG"
	else
		DEBUG = "-O2 -D _RELEASE"
	endif
else

endif

#基础组件
BASE_SAFE_PATH = ./XEngine_BaseLib/XEngine_BaseSafe

#编译集合
XENGINE_MODULE = libXEngien_BaseSafe.so  

.PHONY:MakeAll 
MakeAll:$(XENGINE_MODULE)

libXEngien_BaseSafe.so:
	make -C $(BASE_SAFE_PATH) CC=$(CC) ARCH=$(ARCH) PLATFORM=$(PLATFORM) PLATVER=$(PLATVER) PLATDIR=$(PLATDIR) CPPFLAG=$(CPPFLAG) DEBUG=$(DEBUG) UNICODE=$(UNICODE) FILEEXT=$(FILEEXT) LIBFLAG=$(LIBFLAG) $(FLAGS)

