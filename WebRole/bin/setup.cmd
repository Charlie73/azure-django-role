@echo off

icacls %RoleRoot%\approot /grant "Everyone":F /T

REM specify your virtualenv here if you want to use it for local emulation
REM be sure to run "mklink python.exe Scripts\python.exe" in the root of the virtualenv directory in advance
set PYTHON_INSTALL_DIR=

REM run the command like this if you want to you use Python x64 instead
REM call "%~dp0"install.cmd amd64
call "%~dp0"install.cmd

:SETUP_FASTCGI
call "%~dp0"setup_fastcgi.cmd
