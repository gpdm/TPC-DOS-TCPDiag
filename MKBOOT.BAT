@ECHO OFF


REM ********************************
REM * Init                         *
REM ********************************

SET BUILDDIR=C:\BUILD


REM ********************************
REM * Shortcut to inline functions *
REM ********************************
IF "%1/" == "/" GOTO MAIN
GOTO %1


REM ********************************
REM * copy startup files           *
REM ********************************
:STARTUP
        SET STARTUPF=C:\DOS\HIMEM.SYS %BUILDDIR%\CFG\*.*

        ECHO Copying startup files ...
        FOR %%F IN (%STARTUPF%) DO COPY %%F %DESTDRV%

        SET STARTUPF=
GOTO END


REM ********************************
REM * copy runtime files           *
REM ********************************
:RUNTIME
        SET RUNTIMEF1=C:\DOS\COMMAND.COM C:\DOS\CHOICE.COM C:\DOS\FIND.EXE 
        SET RUNTIMEF2=%BUILDDIR%\CFG\*.BAT %BUILDDIR%\UTILS\RANDOM.COM %BUILDDIR%\UTILS\NSET.COM 

        ECHO Copying runtime files ...
        FOR %%F IN (%RUNTIMEF1%) DO COPY %%F %DESTDRV%
        FOR %%F IN (%RUNTIMEF2%) DO COPY %%F %DESTDRV%

        SET RUNTIMEF1=
        SET RUNTIMEF2=
GOTO END



REM ********************************
REM * copy network utils           *
REM ********************************
:NETUTIL
        SET MTCPF=DHCP.EXE PING.EXE PKTTOOL.EXE SPDTEST.EXE
        SET TTCPF=TCPDRV.EXE

        ECHO Copying network stack and utilities ... 
        FOR %%F IN (%MTCPF%) DO COPY %BUILDDIR%\MTCP\%%F %DESTDRV%
        FOR %%F IN (%TTCPF%) DO COPY %BUILDDIR%\TTCP\%%F %DESTDRV%

        SET MTCPF=
        SET TTCPF=
GOTO END


REM ********************************
REM * copy NIC drivers             *
REM ********************************
:NETDRV
        ECHO Copying NIC paket drivers ...
        MKDIR %DESTDRV%\NIC
        XCOPY /E /S %BUILDDIR%\NIC %DESTDRV%\NIC
GOTO END




:MAIN

:MKRESPF
echo. >  %BUILDDIR%\fmt.ans
echo n>> %BUILDDIR%\fmt.ans
echo. >> %BUILDDIR%\fmt.ans


:SELDSKF
CLS
ECHO This will create the TCP/IP DOS Boot Floppies.
ECHO.
ECHO Specify disk drive:
ECHO  A:
ECHO  B:
choice /C:AB "Make your choice: "
IF ERRORLEVEL 1 SET DESTDRV=A:
IF ERRORLEVEL 2 SET DESTDRV=B:

ECHO.
ECHO Dest drive %DESTDRV% selected.

ECHO.
ECHO Specify disk set to create:
ECHO 1: 1.44M
ECHO 2: 1.2M
ECHO 3: 720K
ECHO 4: 360K
choice /C:1234 /N "Make your choice: "
IF ERRORLEVEL 4 GOTO D360
IF ERRORLEVEL 3 GOTO D720
IF ERRORLEVEL 2 GOTO D12M
IF ERRORLEVEL 1 GOTO D14M
GOTO SELDSKF


:D14M
SET NETUTIL=DISK1
SET NETDRV=DISK1
SET LASTDISK=1
SET DISKFMT=1.44
GOTO DISK1

:D12M
SET NETUTIL=DISK1
SET NETDRV=DISK1
SET LASTDISK=1
SET DISKFMT=1.2
GOTO DISK1

:D720
SET NETUTIL=DISK2
SET NETDRV=DISK1
SET LASTDISK=2
SET DISKFMT=720
GOTO DISK1

:D360
SET NETUTIL=DISK3
SET NETDRV=DISK2
SET LASTDISK=3
SET DISKFMT=360
GOTO DISK1



:DISK1
CLS
ECHO Label a new %DISKFMT% floppy disk as
ECHO.
ECHO     DOS TCP/IP Boot Floppy, Disk 1/%LASTDISK% 
ECHO.
CHOICE /C:C /N "Press 'C' to continue ... "


FORMAT %DESTDRV% /F:%DISKFMT% /U /S /V:DOS_TCPIP_1 < %BUILDDIR%\fmt.ans


REM calling myself to copy files for DISK1
CALL %0 STARTUP
CALL %0 RUNTIME
IF "%NETUTIL%/" == "DISK1/" CALL %0 NETUTIL
IF "%NETDRV%/" == "DISK1/" CALL %0 NETDRV
IF "%LASTDISK%/" == "1/" GOTO ENDDISK


:DISK2
CLS
ECHO Label a new %DISKFMT% floppy disk as
ECHO.
ECHO     DOS TCP/IP Boot Floppy, Disk 2/%LASTDISK% 
ECHO.                                  
CHOICE /C:C /N "Press 'C' to continue ... "


FORMAT %DESTDRV% /F:%DISKFMT% /U /V:DOS_TCPIP_2 < %BUILDDIR%\fmt.ans


REM calling myself to copy files for DISK2
CALL %0 RUNTIME
IF "%NETUTIL%/" == "DISK2/" CALL %0 NETUTIL
IF "%NETDRV%/" == "DISK2/" CALL %0 NETDRV
IF "%LASTDISK%/" == "2/" GOTO ENDDISK


:DISK3
CLS
ECHO Label a new %DISKFMT% floppy disk as
ECHO.
ECHO     DOS TCP/IP Boot Floppy, Disk 3/%LASTDISK% 
ECHO.
CHOICE /C:C /N "Press 'C' to continue ... "


FORMAT %DESTDRV% /F:%DISKFMT% /U /V:DOS_TCPIP_2 < %BUILDDIR%\fmt.ans


REM calling myself to copy files for DISK3
CALL %0 RUNTIME
IF "%NETUTIL%/" == "DISK3/" CALL %0 NETUTIL
IF "%NETDRV%/" == "DISK3/" CALL %0 NETDRV
IF "%LASTDISK%/" == "3/" GOTO ENDDISK


:ENDDISK
CLS
ECHO Disk set has been successfully created.


:CLEANUP
ECHO Performing cleanup ...
DEL %BUILDDIR%\fmt.ans
SET BUILDDIR=
SET DESTDRV=
SET NETUTIL=
SET NETDRV=
SET DISKFMT=
SET LASTDISK=

:END
