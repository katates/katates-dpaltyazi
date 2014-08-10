@echo off
color 73

:ADMIN-CHECK

	:: BatchGotAdmin
	:-------------------------------------
	REM  --> Check for permissions
	>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

	REM --> If error flag set, we do not have admin.
	if '%errorlevel%' NEQ '0' (
	    echo Requesting administrative privileges...
	    GOTO DirCheck1
	) else ( GOTO gotAdmin )

	:DirCheck1

		copy /Y NUL "%~dp0\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK ( 
			del "%~dp0\.writable"
			GOTO UACPrompt1
		 ) else (
			echo Checking profile instead...
			GOTO DirCheck2
		)

	:DirCheck2

		copy /Y NUL "%USERPROFILE%\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK ( 
			del "%USERPROFILE%\.writable"
			GOTO UACPrompt2
		 ) else (
			echo Checking temp instead...
			GOTO DirCheck3
		)

	:DirCheck3

		copy /Y NUL "%tmp%\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK ( 
			del "%tmp%\.writable"
			GOTO UACPrompt3
		 ) else (
			GOTO UACFailed
		)

	:UACPrompt1

		echo Set UAC = CreateObject^("Shell.Application"^) > "%~dp0\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%~dp0\getadmin.vbs"

		"%~dp0\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%~dp0\getadmin.vbs"
			GOTO DirCheck2
		) else ( GOTO UACPrompt1Complete )

		:UACPrompt1Complete
			del "%~dp0\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACPrompt2

		echo Set UAC = CreateObject^("Shell.Application"^) > "%USERPROFILE%\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%USERPROFILE%\getadmin.vbs"

		"%USERPROFILE%\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%USERPROFILE%\getadmin.vbs"
			GOTO DirCheck3
		) else ( GOTO UACPrompt2Complete )

		:UACPrompt2Complete
			del "%USERPROFILE%\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACPrompt3

		echo Set UAC = CreateObject^("Shell.Application"^) > "%tmp%\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%tmp%\getadmin.vbs"

		"%tmp%\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%tmp%\getadmin.vbs"
			GOTO UACFailed
		) else ( GOTO UACPrompt3Complete )

		:UACPrompt3Complete
			del "%tmp%\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACFailed
		echo Upgrading to admin privliages failed.
		echo Please right click the file and run as administrator.
		echo PAUSE
		GOTO FINISH

	:gotAdmin
		pushd "%CD%"
		CD /D "%~dp0"
	:--------------------------------------

GOTO KONTROL

:KONTROL

if exist "C:\Program Files\katates-dpaltyazi\altyazi.bat" (
goto :KALDIR
) else (
goto :KURULSUN
)

:KURULSUN
set infoilk=# SAG TIK ILE DIVXPLANET ALTYAZI KONTROLU ########
set infoiki=# KATATES PIZARTMASI TARAFINDAN HAZIRLANMISTIR #############
set ilksatir2=Sag tik ile divxplanet altyazi kontrolunu kurmak icin 1, cikis icin 2.
set gecerlisecim2= gecerli bir secim degil.
set burayaz2=Buraya yazin
ECHO %infoilk%
ECHO %infoiki%
ECHO %ilksatir2%
set /p choice=%burayaz2%==
if '%choice%'=='' ECHO "%choice%" %gecerlisecim2%
if '%choice%'=='1' goto BASLA
if '%choice%'=='2' goto exit

:KALDIR
set ilksatir=Kaldirmak istiyorsaniz 1, cikmak istiyorsaniz 2.
set gecerlisecim= gecerli bir secim degil.
set burayaz=Buraya yazin
ECHO %ilksatir%
set /p choice=%burayaz%==
if '%choice%'=='' ECHO "%choice%" %gecerlisecim%
if '%choice%'=='1' goto KALDIR2
if '%choice%'=='2' goto exit

:KALDIR2

If exist "%Temp%\~import.reg" (
 Attrib -R -S -H "%Temp%\~import.reg"
 del /F /Q "%Temp%\~import.reg"
 If exist "%Temp%\~import.reg" (
  Echo Could not delete file "%Temp%\~import.reg"
  Pause
 )
)
> "%Temp%\~import.reg" ECHO Windows Registry Editor Version 5.00
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Directory\shell\runas3]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\katates-dpaltyazi\\divx2.ico\""
>> "%Temp%\~import.reg" ECHO "MUIVerb"="Divxplaneti kontrol et"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Directory\shell\runas3\command]
>> "%Temp%\~import.reg" ECHO @="C:\\Program Files\\katates-dpaltyazi\\hstart.exe /NOCONSOLE \"cmd /c C:\\Program Files\\katates-dpaltyazi\\altyazi.bat \"%%1\"\""
>> "%Temp%\~import.reg" ECHO "IsolatedCommand"="C:\\Program Files\\katates-dpaltyazi\\hstart.exe /NOCONSOLE \"cmd /c C:\\Program Files\\katates-dpaltyazi\\altyazi.bat \"%%1\"\""
START /WAIT REGEDIT /S "%Temp%\~import.reg"
DEL "%Temp%\~import.reg"


DEL /Q "C:\Program Files\katates-dpaltyazi\hstart.exe"
DEL /Q "C:\Program Files\katates-dpaltyazi\curl.exe"
DEL /Q "C:\Program Files\katates-dpaltyazi\altyazi.bat"
DEL /Q "C:\Program Files\katates-dpaltyazi\alt.vbs"
DEL /Q "C:\Program Files\katates-dpaltyazi\divx2.ico"
RD /S /Q "C:\Program Files\katates-dpaltyazi\"

goto son



:BASLA
if defined ProgramFiles(x86) (
set taskyol="https://raw.githubusercontent.com/katates/katates-dpaltyazi/master/hstart64.exe"
) else (
set taskyol="https://raw.githubusercontent.com/katates/katates-dpaltyazi/master/hstart.exe
)

If exist "%Temp%\~import.reg" (
 Attrib -R -S -H "%Temp%\~import.reg"
 del /F /Q "%Temp%\~import.reg"
 If exist "%Temp%\~import.reg" (
  Echo Could not delete file "%Temp%\~import.reg"
  Pause
 )
)
> "%Temp%\~import.reg" ECHO Windows Registry Editor Version 5.00
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Directory\shell\runas3]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\katates-dpaltyazi\\divx2.ico\""
>> "%Temp%\~import.reg" ECHO "MUIVerb"="Divxplaneti kontrol et"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Directory\shell\runas3\command]
>> "%Temp%\~import.reg" ECHO @="C:\\Progra~1\\katates-dpaltyazi\\hstart.exe /NOCONSOLE \"cmd /c C:\\Progra~1\\katates-dpaltyazi\\altyazi.bat \"%%1\"\""
>> "%Temp%\~import.reg" ECHO "IsolatedCommand"="C:\\Progra~1\\katates-dpaltyazi\\hstart.exe /NOCONSOLE \"cmd /c C:\\Progra~1\\katates-dpaltyazi\\altyazi.bat \"%%1\"\""
START /WAIT REGEDIT /S "%Temp%\~import.reg"
DEL "%Temp%\~import.reg"

mkdir "C:\Program Files\katates-dpaltyazi\"
bitsadmin.exe /transfer "Icon" /priority foreground  "https://raw.githubusercontent.com/katates/katates-dpaltyazi/master/divx.ico" "C:\Program Files\katates-dpaltyazi\divx2.ico"
bitsadmin.exe /transfer "VBS" /priority foreground  "https://raw.githubusercontent.com/katates/katates-dpaltyazi/master/alt.vbs" "C:\Program Files\katates-dpaltyazi\alt.vbs"
bitsadmin.exe /transfer "BAT" /priority foreground  "https://raw.githubusercontent.com/katates/katates-dpaltyazi/master/altyazi.bat" "C:\Program Files\katates-dpaltyazi\altyazi.bat"
bitsadmin.exe /transfer "EXE" /priority foreground  %taskyol% "C:\Program Files\katates-dpaltyazi\hstart.exe"
bitsadmin.exe /transfer "EXE2" /priority foreground  "https://raw.githubusercontent.com/katates/katates-dpaltyazi/master/curl.exe" "C:\Program Files\katates-dpaltyazi\curl.exe"

goto son

:son
echo.
echo.
echo.
echo ISLEM TAMAMLANDI
echo.
pause


:exit
exit

