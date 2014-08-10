@echo off
IF EXIST "%tmp%\list2.txt" (

echo ATTRIB -R -S -H "%tmp%\list2.txt" 
del /q "%tmp%\list2.txt"
goto :BASLA

) ELSE (

goto :BASLA

)

:BASLA
SETLOCAL ENABLEDELAYEDEXPANSION
set seksi=%~n1
SET _no_spaces=%seksi: =%

set malok="curl http://katates.eu5.org/?v=%_no_spaces%" 

for /F "tokens=*" %%B in ('%malok%') do (
set token=%%B
)



echo !token:QMZ=^

!>>%tmp%\list2.txt



set vidx=0
for /F "tokens=*" %%A in (%tmp%\list2.txt) do (
    SET /A vidx=!vidx! + 1
    set FULLNAME!vidx!=%%A
)
set FULLNAME

   set ENDTEXT=!FULLNAME1:*=!
    call set TRIMMEDNAME=%%FULLNAME1:!ENDTEXT!=%%
echo %TRIMMEDNAME%
   SET _result=%TRIMMEDNAME:*/s=% 
echo %_result%

cscript //nologo "C:\Windows\addins\alt.vbs" 

if not errorlevel 1 (
start "" "http://divxplanet.com/s%_result%"
goto :CLEAN
)


:CLEAN
echo ATTRIB -R -S -H "%tmp%\list2.txt" 
del /q "%tmp%\list2.txt"
goto :SEKS

:SEKS
exit