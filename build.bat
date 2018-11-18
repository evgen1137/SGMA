@echo off

set COMPILER="C:\Documents and Settings\VirtualBox\Рабочий стол\fasmw17304\fasm.exe"
set "COMPILE_FLAGS=-d target_system=windows"
set "LINKER=C:\masm32\bin\link.exe"
set "LINKER_LIBPATH=C:\masm32\lib"
set "OUTFILE=bin/sgma.dll"

%COMPILER% src\main.asm tmp\main.obj %COMPILE_FLAGS%
%COMPILER% src\gamemode\gamemode.asm tmp\gamemode.obj %COMPILE_FLAGS%
%LINKER% "tmp/*.obj" "kernel32.lib" /dll /machine:x86 /subsystem:windows /def:"src\exports.def" /libpath:"%LINKER_LIBPATH%" /OUT:%OUTFILE%
del tmp\*.obj
pause