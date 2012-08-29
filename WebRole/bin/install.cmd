@echo off

if not "%EMULATED%"=="false" (
echo Python interpreter will only be installed on production Windows Azure.
exit /b
)

echo Starting installation...

REM install Python to the default location
set PYTHON_INSTALL_DIR=%SystemDrive%\Python27

if not defined LOCAL_RESOURCE_TMP_DIR set LOCAL_RESOURCE_TMP_DIR=%TMP%
if "%LOCAL_RESOURCE_TMP_DIR:~-1%"=="\" set LOCAL_RESOURCE_TMP_DIR=%LOCAL_RESOURCE_TMP_DIR:~0,-1%

echo installing Python...
set PYTHON_VERSION=2.7.3
set PYTHON_INSTALLER=python-%PYTHON_VERSION%.msi
if "%1"=="amd64" set PYTHON_INSTALLER=python-%PYTHON_VERSION%.%1.msi
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://www.python.org/ftp/python/%PYTHON_VERSION%/%PYTHON_INSTALLER%', '%LOCAL_RESOURCE_TMP_DIR%\%PYTHON_INSTALLER%')"
msiexec /i %LOCAL_RESOURCE_TMP_DIR%\%PYTHON_INSTALLER% /qn ALLUSERS=1 TARGET_DIR=%PYTHON_INSTALL_DIR%

echo installing WebPICmdLine...
set WEBPI_DIR=webpicmdline_anycpu
set WEBPI_INSTALLER=%WEBPI_DIR%.zip
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://www.iis.net/community/files/webpi/%WEBPI_INSTALLER%', '%LOCAL_RESOURCE_TMP_DIR%\%WEBPI_INSTALLER%')"
%PYTHON_INSTALL_DIR%\python -m zipfile -e %LOCAL_RESOURCE_TMP_DIR%\%WEBPI_INSTALLER% %LOCAL_RESOURCE_TMP_DIR%\%WEBPI_DIR%

echo installing SQL Server Native Client...
reg add "hku\.default\software\microsoft\windows\currentversion\explorer\user shell folders" /f /v "Local AppData" /t REG_EXPAND_SZ /d %LOCAL_RESOURCE_TMP_DIR%
%LOCAL_RESOURCE_TMP_DIR%\%WEBPI_DIR%\webpicmdline /Products:SQLNativeClient /AcceptEula
reg add "hku\.default\software\microsoft\windows\currentversion\explorer\user shell folders" /f /v "Local AppData" /t REG_EXPAND_SZ /d %%USERPROFILE%%\AppData\Local

REM allow write access to Python installation directory for byte-compiling
icacls %PYTHON_INSTALL_DIR% /grant "Everyone":F /T

call "%~dp0"install-requirements

echo Completed installation.

exit /b
