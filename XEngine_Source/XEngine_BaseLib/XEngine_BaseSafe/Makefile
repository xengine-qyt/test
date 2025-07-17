CPPFLAG = 
LOADHDR = -I ./
LOADSO = 
LIB = 
LOADBIN = 
OBJECTS = BaseSafe_String.o BaseSafe_Memory.o \
		  pch.o


ifeq ($(PLATFORM),linux)
	LIB += -lrt -ldl -lpthread
else ifeq ($(PLATFORM),android)
	LIB = 
else ifeq ($(PLATFORM),mac)
	LIB = -liconv
	LOADBIN = -Wl,-rpath,@loader_path/./ -install_name /usr/local/lib/libXEngine_BaseSafe.$(FILEEXT)
else ifeq ($(PLATFORM),ios)
	LIB = -liconv
else ifeq ($(PLATFORM),web)
	LIB = 
endif

ifeq ($(PLATFORM),ios)
all:$(OBJECTS)
	ar $(LIBFLAG) libXEngine_BaseSafe.$(FILEEXT) $(OBJECTS)
	xcodebuild -create-xcframework -library libXEngine_BaseSafe.$(FILEEXT) -output libXEngine_BaseSafe.xcframework 
else
all:$(OBJECTS)
	$(CC) $(DEBUG) $(OBJECTS) -o libXEngine_BaseSafe.$(FILEEXT) $(LIBFLAG) $(LIB) $(LOADSO) $(LOADBIN)
endif

BaseSafe_String.o:./BaseSafe_String/BaseSafe_String.cpp                         
	$(CC) $(DEBUG) $(CPPFLAG) $(UNICODE) $(PLATVER) $(LOADHDR) ./BaseSafe_String/BaseSafe_String.cpp
BaseSafe_Memory.o:./BaseSafe_Memory/BaseSafe_Memory.cpp                         
	$(CC) $(DEBUG) $(CPPFLAG) $(UNICODE) $(PLATVER) $(LOADHDR) ./BaseSafe_Memory/BaseSafe_Memory.cpp

pch.o:./pch.cpp                          
	$(CC) $(DEBUG) $(CPPFLAG) $(UNICODE) $(PLATVER) $(LOADHDR) ./pch.cpp


install:InstallSo InstallHdr
InstallSo:./libXEngine_BaseSafe.$(FILEEXT)
	cp ./libXEngine_BaseSafe.$(FILEEXT) ../../../XEngine_Release/$(PLATDIR)/XEngine_BaseLib/libXEngine_BaseSafe.$(FILEEXT)

InstallHdr:./BaseSafe_Define.h ./BaseSafe_Error.h
	cp ./BaseSafe_Define.h ../../../XEngine_Release/XEngine_Include/XEngine_BaseLib/BaseSafe_Define.h
	cp ./BaseSafe_Error.h ../../../XEngine_Release/XEngine_Include/XEngine_BaseLib/BaseSafe_Error.h

clean:CleanObj CleanMk
CleanObj:
	rm *.o                                            
CleanMk:
	rm *.$(FILEEXT)                                         
	
