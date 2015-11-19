@echo off

if NOT "%~1" == "" goto :do_build

set CHERE_INVOKING=1

rem OK begin
call "%~0" "%~d0\cygwin\bin" "conemu-cyg-32.exe" "i686-pc-cygwin-" "i686-pc-mingw32-"
call "%~0" "%~d0\cygwin\bin" "conemu-cyg-64.exe" "x86_64-pc-cygwin-" "i686-w64-mingw32-"
call "%~0" "%~d0\GitSDK\usr\bin" "conemu-msys2-64.exe"
rem OK ends


rem call "%~0" "%~d0\cygwin64\bin" "conemu-cyg-64.exe"
rem call "%~0" "%~d0\GitSDK\mingw32\bin;%~d0\GitSDK\usr\bin" "conemu-msys2-32.exe"
rem call "%~0" "%~d0\MinGW\bin;%~d0\MinGW\msys32\bin" "conemu-msys1-32.exe"


goto :EOF

:do_build
setlocal
call cecho /yellow "Using: `%~1`, `%~3g++` and `%~4windres`"
set "PATH=%~1;%windir%;%windir%\System32;%ConEmuDir%;%ConEmuBaseDir%;"
if exist ConEmuT.res.o ( del ConEmuT.res.o > nul )
"%~4windres" -i ConEmuT.rc -o ConEmuT.res.o
"%~3g++" ConEmuT.cpp -o %2 -Xlinker ConEmuT.res.o 2> "%2.log"
if errorlevel 1 goto print_errors
endlocal
call sign %2
call cecho /green "Build succeeded: %2"
goto :EOF

:print_errors
set "err_msg=Build failed: %errorlevel%"
echo --- build errors (begin)
type "%2.log"
echo --- build errors (end)
call cecho "%err_msg%"
rem exit /B 99
endlocal
