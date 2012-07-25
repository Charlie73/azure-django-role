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

REM allow write access to Python installation directory for byte-compiling
icacls %PYTHON_INSTALL_DIR% /grant "Everyone":F /T

call "%~dp0"install-requirements

echo Completed installation.

exit /b
