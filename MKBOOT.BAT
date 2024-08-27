@ECHO OFF


REM ********************************
REM * Init                         *
REM ********************************

SET BUILDDIR=C:\BUILD
cd %BUILDDIR%

REM ********************************
REM * Shortcut to inline functions *
REM ********************************
IF "%1/" == "/" GOTO MAIN
GOTO %1


REM ********************************
REM * copy startup files           *
REM ********************************
:STARTUP
        SET STARTUPF=C:\DOS\HIMEM.SYS CFG\*.*

        ECHO Copying startup files ...
        FOR %%F IN (%STARTUPF%) DO COPY %%F %DESTDRV%

        SET STARTUPF=
GOTO END


REM ********************************
REM * copy runtime files           *
REM ********************************
:RUNTIME
        SET RUNTIMEF1=C:\DOS\COMMAND.COM C:\DOS\CHOICE.COM C:\DOS\FIND.EXE CFG\*.BAT
        SET RUNTIMEF2=UTILS\RANDOM.COM UTILS\NSET.COM UTILS\QECHO.COM 

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
        FOR %%F IN (%MTCPF%) DO COPY MTCP\%%F %DESTDRV%
        FOR %%F IN (%TTCPF%) DO COPY TTCP\%%F %DESTDRV%

        SET MTCPF=
        SET TTCPF=
GOTO END


REM ********************************
REM * copy NIC drivers             *
REM ********************************
:DRIVERS
        REM SWEEP must be local to NIC dir to parse
        CD %BUILDDIR%\NIC

        CALL %BUILDDIR%\BIN\SWEEP\SWEEP -s -c %BUILDDIR%\%0 IncludeDrivers & #

        REM Change back to %BUILDDIR%
        CD %BUILDDIR%
GOTO END

        
:IncludeDrivers
        REM Sanitize: Might be called with empty args
        if "%2/" == "/" GOTO END
        if "%3/" == "/" GOTO END

        REM SWEEP must run from selected drivers subdir
        REM CD to it to prevent spurious invalid CWD errors
        CD %2

        CHOICE /C:yn /T:Y,5 "Include %3 driver? (default=Y after 5 seconds) "
        IF ERRORLEVEL 2 GOTO END
        
        ECHO Processing %3 ...

        IF NOT EXIST %DESTDRV%\NIC\nul mkdir %DESTDRV%\NIC

        REM check if directory can be copied
        REM if it doesn't, ask for a new floppy to format
        %BUILDDIR%\BIN\CC\CC /S+ /N /Q+ %2 %DESTDRV%\NIC\%3
        IF ERRORLEVEL 1 GOTO WantDriversDisk
        
        REM perform actual copy
        %BUILDDIR%\BIN\CC\CC /S+ /Q+ %2 %DESTDRV%\NIC\%3
GOTO END

:WantDriversDisk
        REM Make sure next disk is formated, and includes runtime
        REM then go back to include the drivers, hopefully fitting
        REM the disk this time over
        CALL %0 AutoFormat 2
        CALL %0 RUNTIME
GOTO IncludeDrivers        



REM ********************************
REM * PKTMUX                       *
REM ********************************
:PKTMUX
        SET PKTMUXF=PKTMUX.EXE PKTDRV.EXE

        ECHO Copying Packet Driver Multiplexer ... 
        FOR %%F IN (%PKTMUXF%) DO COPY PKTMUX\%%F %DESTDRV%

        SET PKTMUXF=
GOTO END



REM ********************************
REM * Automatic Disk Format        *
REM ********************************
:AutoFormat
        shift

        echo. >  %BUILDDIR%\fmt.ans
        echo n>> %BUILDDIR%\fmt.ans
        echo. >> %BUILDDIR%\fmt.ans

        ECHO Label a new %DISKFMT% floppy disk as
        ECHO.
        ECHO     DOS TCP/IP Boot Floppy, Disk %1
        ECHO.                                  
        ECHO Disk will be formatted and all data will be lost.
        ECHO.
        CHOICE /C:C /N "Press 'C' to continue ... "

        FORMAT %DESTDRV% /F:%DISKFMT% /U /V:DOS_TCPIP_%1 < %BUILDDIR%\fmt.ans

        DEL %BUILDDIR%\fmt.ans
GOTO END


REM ********************************
REM * Main Program                 *
REM ********************************
:MAIN

:SelectDiskFormat
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
GOTO SelectDiskFormat


:D14M
        SET NETUTIL=DISK1
        SET DRIVERS=DISK1
        SET PKTMUX=DISK1
        SET LASTDISK=1
        SET DISKFMT=1.44
GOTO DISK1

:D12M
        SET NETUTIL=DISK1
        SET DRIVERS=DISK1
        SET PKTMUX=DISK1
        SET LASTDISK=1
        SET DISKFMT=1.2
GOTO DISK1

:D720
        SET NETUTIL=DISK1
        SET DRIVERS=DISK2
        SET PKTMUX=DISK1
        SET LASTDISK=2
        SET DISKFMT=720
GOTO DISK1

:D360
        SET NETUTIL=DISK2
        SET DRIVERS=DISK3
        SET PKTMUX=DISK2
        SET LASTDISK=3
        SET DISKFMT=360
GOTO DISK1



:DISK1
        REM Call myself to format new disk
        CALL %0 AutoFormat 1

        ECHO Transferring system files ...
        SYS %DESTDRV%

        REM calling myself to copy mandatory files for DISK1
        CALL %0 STARTUP
        CALL %0 RUNTIME

        REM Higher capacity disk may include this on DISK1 already
        IF "%PKTMUX%/" == "DISK1/" CALL %0 PKTMUX
        IF "%NETUTIL%/" == "DISK1/" CALL %0 NETUTIL
        
        REM Put drivers last
        IF "%DRIVERS%/" == "DISK1/" CALL %0 DRIVERS

        REM exit if this is the last disk
        IF "%LASTDISK%/" == "1/" GOTO ENDDISK


:DISK2
        REM Call myself to format new disk
        CALL %0 AutoFormat 2

        REM calling myself to copy mandatory files for DISK2
        CALL %0 RUNTIME

        REM As we're on DISK2 now, put drivers first.
        REM Routine will ask by itself for additional floppies
        IF "%DRIVERS%/" == "DISK2/" CALL %0 DRIVERS

        REM Include PKTMUX and NETUTIL
        IF "%PKTMUX%/" == "DISK2/" CALL %0 PKTMUX
        IF "%NETUTIL%/" == "DISK2/" CALL %0 NETUTIL

        REM exit if this is the last disk
        IF "%LASTDISK%/" == "2/" GOTO ENDDISK


:DISK3
        REM Call myself to format new disk
        CALL %0 AutoFormat 3

        REM calling myself to copy mandatory files for DISK3
        CALL %0 RUNTIME

        REM No need to bother for drivers, it was already
        REM being taken care of on previous disks.
        REM Include just the rest
        IF "%PKTMUX%/" == "DISK3/" CALL %0 PKTMUX
        IF "%NETUTIL%/" == "DISK3/" CALL %0 NETUTIL

        REM exit if this is the last disk
        IF "%LASTDISK%/" == "3/" GOTO ENDDISK


:ENDDISK
        CLS
        ECHO Disk set has been successfully created.
        ECHO.

:CLEANUP
        ECHO Performing cleanup ...
        SET BUILDDIR=
        SET DESTDRV=
        SET NETUTIL=
        SET PKTMUX=
        SET DRIVERS=
        SET DISKFMT=
        SET LASTDISK=

:END
