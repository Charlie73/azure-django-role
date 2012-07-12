@echo off

icacls %RoleRoot%\approot /grant "Everyone":F /T

set PYTHON_INSTALL_DIR=%SystemDrive%\Python27

REM the installer script will only be executed on production Windows Azure.
if "%EMULATED%"=="true" goto :SETUP_FASTCGI

REM run the command like this if you want to you use Python x64 instead
REM call "%~dp0"install.cmd amd64
call "%~dp0"install.cmd

:SETUP_FASTCGI
call "%~dp0"setup_fastcgi.cmd
