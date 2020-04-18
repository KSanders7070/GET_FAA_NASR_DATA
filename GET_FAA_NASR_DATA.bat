@echo off

TITLE DOWNLOAD, UNZIP, and MOVE FAA DATA

echo.
echo.
echo ---------------------------------------------------------------
echo.
echo  Type the Effictive date of the AIRAC in the following formats
echo.
echo ---------------------------------------------------------------
echo.
echo.

set /p AIRAC_YEAR=Type the 4 digit year: 
set /p AIRAC_MON=Type the 2 digit month: 
set /p AIRAC_DAY=Type the 2 digit day: 

CLS

ECHO * * * * * * * * * * * * *
ECHO   AIRAC EFFECTIVE DATE:
ECHO   %AIRAC_YEAR% %AIRAC_MON% %AIRAC_DAY%
ECHO * * * * * * * * * * * * *
echo.
echo.
echo --------------------------------------------------
echo.
echo  Choose where you want the AIRAC Data to be saved
echo.
echo --------------------------------------------------
echo.
echo.

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Choose where you want the AIRAC Data to be saved',0,0).self.path""

	for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "FAA_DATA_DIR=%%I"

CLS

CD "%userprofile%\Downloads"
IF EXIST "%userprofile%\Downloads\28DaySubscription_Effective_%AIRAC_YEAR%-%AIRAC_MON%-%AIRAC_DAY%" GOTO MOVE_DATA

IF EXIST "%userprofile%\Downloads\28DaySubscription_Effective_%AIRAC_YEAR%-%AIRAC_MON%-%AIRAC_DAY%.zip" GOTO UNZIP_DATA

CLS

powershell -Command "Invoke-WebRequest https://nfdc.faa.gov/webContent/28DaySub/28DaySubscription_Effective_%AIRAC_YEAR%-%AIRAC_MON%-%AIRAC_DAY%.zip -OutFile '%userprofile%\Downloads\28DaySubscription_Effective_%AIRAC_YEAR%-%AIRAC_MON%-%AIRAC_DAY%.zip'"

:CHECK

CLS

IF EXIST "%userprofile%\Downloads\28DaySubscription_Effective_%AIRAC_YEAR%-%AIRAC_MON%-%AIRAC_DAY%.zip" GOTO UNZIP_DATA

echo.
echo.
ECHO * * * * * * * * * * * * *
ECHO   AIRAC EFFECTIVE DATE:
ECHO   %AIRAC_YEAR% %AIRAC_MON% %AIRAC_DAY%
ECHO * * * * * * * * * * * * *
echo.
echo.
echo -----------------------------------------------
echo.
echo  Downloading the 28 Day NASR Subscription data
echo.
echo -----------------------------------------------
echo.
echo.
echo  Once the download is complete, press any key
echo  to have it unzipped and moved to a directory
echo  of your choice.
echo.
echo.

ECHO STILL DOWNLOADING. WILL CONTINUE WHEN COMPLETE
TIMEOUT 6
GOTO CHECK

:UNZIP_DATA

CLS

CD "%userprofile%\Downloads"
powershell -command "Expand-Archive -Force '%userprofile%\Downloads"\28DaySubscription_Effective_%AIRAC_YEAR%-%AIRAC_MON%-%AIRAC_DAY%.zip' '%userprofile%\Downloads\28DaySubscription_Effective_%AIRAC_YEAR%-%AIRAC_MON%-%AIRAC_DAY%'"

	PING 127.0.0.1 -n 3 >nul

		DEL /Q "%userprofile%\Downloads"\28DaySubscription_Effective_%AIRAC_YEAR%-%AIRAC_MON%-%AIRAC_DAY%.zip"

:MOVE_DATA

CD "%userprofile%\Downloads"
MOVE "%userprofile%\Downloads\28DaySubscription_Effective_%AIRAC_YEAR%-%AIRAC_MON%-%AIRAC_DAY%" "%FAA_DATA_DIR%"

:DONE

START %SystemRoot%\explorer.exe "%FAA_DATA_DIR%"
TIMEOUT 6
EXIT /B