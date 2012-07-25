azure-django-role
======================
This is a simple scaffold
for packaging Django applications to run on Windows Azure.

You can use this for an alternative to Django application project of
[Python Tools for Visual Stuido](http://pytools.codeplex.com/)
if you don't have Visual Studio 2010. 

Prerequisites
-------------

You will need to have the following software on your local computer to use this.
You can use [Web Platform Installer](http://www.microsoft.com/web/downloads/platform.aspx)
to install them easily.

* Python 2.7
* Windows Azure SDK 1.7
* Windows Azure PowerShell
* SQL Server Express 2008 R2

And the following packages are also required on your Python installation.
`WebRole/bin/install-requirements.cmd` may be helpful when you want to install them.

* Django 1.4
* pyodbc
* [django-pyodbc](https://github.com/avidal/django-pyodbc)

Usage
-----

1. Create your Django applications into `WebRole/project` directory,
and add required Python packages to `WebRole/requirements.txt`.

2. Run `Start-AzureEmulator` on your Windows Azure PowerShell
to run the applications on your local emulator.

3. Run `Publish-AzureServiceProject` on your Windows Azure PowerShell
to get the applications running in the cloud.

See [azure-sdk-tools](https://github.com/WindowsAzure/azure-sdk-tools)
for more details of Windows Azure PowerShell. And you can also use
the traditional Windows Azure SDK commands (`csrun` and `cspack`) instead.

License
-------

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)