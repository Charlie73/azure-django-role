@echo off

if not defined PYTHON_INSTALL_DIR set PYTHON_INSTALL_DIR=%SystemDrive%\Python27
if "%PYTHON_INSTALL_DIR:~-1%"=="\" set PYTHON_INSTALL_DIR=%PYTHON_INSTALL_DIR:~0,-1%

if not exist %PYTHON_INSTALL_DIR%\python.exe (
echo ERROR: %PYTHON_INSTALL_DIR%\python.exe is missing.
exit /b 1
)

if not defined LOCAL_RESOURCE_TMP_DIR set LOCAL_RESOURCE_TMP_DIR=%TMP%
if "%LOCAL_RESOURCE_TMP_DIR:~-1%"=="\" set LOCAL_RESOURCE_TMP_DIR=%LOCAL_RESOURCE_TMP_DIR:~0,-1%

REM configure FastCGI application
%appcmd% set config -section:system.webServer/fastCgi /-"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py']" /commit:apphosts
%appcmd% set config -section:system.webServer/fastCgi /+"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py',maxInstances='0',idleTimeout='300',activityTimeout='70',requestTimeout='90',queueLength='1000',instanceMaxRequests='200',protocol='NamedPipe',flushNamedPipe='False']" /commit:apphost

REM configure PYTHONPATH
%appcmd% set config -section:system.webServer/fastCgi /-"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py'].environmentVariables.[name='PYTHONPATH']" /commit:apphost
%appcmd% set config -section:system.webServer/fastCgi /+"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py'].environmentVariables.[name='PYTHONPATH',value='%RoleRoot%\approot\project;%RoleRoot%\approot\lib;']" /commit:apphost

REM configure WSGI_HANDLER
%appcmd% set config -section:system.webServer/fastCgi /-"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py'].environmentVariables.[name='WSGI_HANDLER']" /commit:apphost
%appcmd% set config -section:system.webServer/fastCgi /+"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py'].environmentVariables.[name='WSGI_HANDLER',value='project.wsgi.application']" /commit:apphost

REM configure WSGI_LOG
type nul > %LOCAL_RESOURCE_TMP_DIR%\wfastcgi.log
%appcmd% set config -section:system.webServer/fastCgi /-"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py'].environmentVariables.[name='WSGI_LOG']" /commit:apphost
%appcmd% set config -section:system.webServer/fastCgi /+"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py'].environmentVariables.[name='WSGI_LOG',value='%LOCAL_RESOURCE_TMP_DIR%\wfastcgi.log']" /commit:apphost

REM set the emulation status
%appcmd% set config -section:system.webServer/fastCgi /-"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py'].environmentVariables.[name='EMULATED']" /commit:apphost
%appcmd% set config -section:system.webServer/fastCgi /+"[fullPath='%PYTHON_INSTALL_DIR%\python.exe',arguments='%RoleRoot%\approot\wfastcgi.py'].environmentVariables.[name='EMULATED',value='%EMULATED%']" /commit:apphost

REM add handler mapping
%appcmd% set config -section:system.webServer/handlers /-"[name='Python-via-FastCGI']" /commit:apphost
%appcmd% set config -section:system.webServer/handlers /+"[name='Python-via-FastCGI',path='*',modules='FastCgiModule',verb='*',scriptProcessor='%PYTHON_INSTALL_DIR%\python.exe|%RoleRoot%\approot\wfastcgi.py']" /commit:apphost

exit /b
