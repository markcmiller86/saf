# Microsoft Developer Studio Project File - Name="create_str_mesh" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=create_str_mesh - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "create_str_mesh.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "create_str_mesh.mak" CFG="create_str_mesh - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "create_str_mesh - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "create_str_mesh - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "create_str_mesh - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MD /w /W0 /GX /O2 /I "../../../../" /I "../../../../../../src/safapi/tools/ensight_reader" /I "../../../../../../src/safapi/lib" /I "../../../../../../src/sslib/lib" /I "$(HDF5_INSTALL_PATH)\include" /I "$(ZLIB_INCLUDE_DIR)" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /FD /c
# SUBTRACT CPP /YX
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 safapi.lib sslib.lib hdf5.lib $(ZLIB_LIBRARY) szlib.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /pdb:none /machine:I386 /nodefaultlib:"libc.lib" /libpath:"..\..\..\..\sslib\sslib_library\Release" /libpath:"..\..\..\lib\Release" /libpath:"$(HDF5_INSTALL_PATH)\lib" /libpath:"$(SZIP_INSTALL_DIR)\lib"
# Begin Special Build Tool
SOURCE="$(InputPath)"
PostBuild_Cmds=echo *	echo Note: the normal result of build_all is 8 errors (from sslib_test_terr1)	echo *
# End Special Build Tool

!ELSEIF  "$(CFG)" == "create_str_mesh - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /MDd /w /W0 /Gm /GX /ZI /Od /I "../../../../" /I "../../../../../../src/safapi/tools/ensight_reader" /I "../../../../../../src/safapi/lib" /I "../../../../../../src/sslib/lib" /I "$(HDF5_INSTALL_PATH)\include" /I "$(ZLIB_INCLUDE_DIR)" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /FD /GZ /c
# SUBTRACT CPP /YX
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 safapi.lib sslib.lib hdf5d.lib $(ZLIB_LIBRARY) szlib.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /pdb:none /debug /machine:I386 /nodefaultlib:"libc.lib" /libpath:"..\..\..\..\sslib\sslib_library\Debug" /libpath:"..\..\..\lib\Debug" /libpath:"$(HDF5_INSTALL_PATH)\lib" /libpath:"$(SZIP_INSTALL_DIR)\lib"
# Begin Special Build Tool
SOURCE="$(InputPath)"
PostBuild_Cmds=echo *	echo Note: the normal result of build_all is 8 errors (from sslib_test_terr1)	echo *
# End Special Build Tool

!ENDIF 

# Begin Target

# Name "create_str_mesh - Win32 Release"
# Name "create_str_mesh - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=..\..\..\..\..\..\src\safapi\tools\ensight_reader\create_str_mesh.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\..\..\src\safapi\tools\ensight_reader\str_mesh_reader.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\..\..\src\safapi\tools\ensight_reader\variable_names.c
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=..\..\..\..\..\..\src\safapi\tools\ensight_reader\str_mesh_reader.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\..\..\src\safapi\tools\ensight_reader\str_mesh_test.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group
# End Target
# End Project
