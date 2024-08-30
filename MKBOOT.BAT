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
        ECHO Copying runtime files ...

        SET RUNTIMEF1=C:\DOS\COMMAND.COM C:\DOS\CHOICE.COM C:\DOS\FIND.EXE CFG\*.BAT
        FOR %%F IN (%RUNTIMEF1%) DO COPY %%F %DESTDRV%
        SET RUNTIMEF1=

        SET RUNTIMEF2=RANDOM.COM NSET.COM QECHO.COM 
        FOR %%F IN (%RUNTIMEF2%) DO COPY UTILS\%%F %DESTDRV%
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

        REM Cleanup
        IF EXIST %BUILDDIR%\CURDISK.BAT DEL %BUILDDIR%\CURDISK.BAT

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
        %BUILDDIR%\BIN\CC\CC /S+ /N /Q+ %2 %DESTDRV%\NIC
        IF ERRORLEVEL 1 GOTO WantDriversDisk
        
        REM perform actual copy
        %BUILDDIR%\BIN\CC\CC /S+ /Q+ %2 %DESTDRV%\NIC
GOTO END

:WantDriversDisk
        REM Make sure next disk is formated, and includes runtime
        REM then go back to include the drivers, hopefully fitting
        REM the disk this time over

        REM increment CURDISK identifier
        REM NOTE: running via sub-shell, so var can't be
        REM       persistet in environment.
        REM       A temporary batch file must be used
        REM       to carry over the disk increment to
        REM       the next iteration.
        REM
        REM override CURDISK to last value, if it was persisted
        IF EXIST %BUILDDIR%\CURDISK.BAT CALL %BUILDDIR%\CURDISK.BAT
        
        REM Update CURDISK+1 and persist it to next run
        %BUILDDIR%\UTILS\VARSET CURDISK %CURDISK%+1 > %BUILDDIR%\CURDISK.BAT

        REM refresh CURDISK in environment
        IF EXIST %BUILDDIR%\CURDISK.BAT CALL %BUILDDIR%\CURDISK.BAT

        CALL %0 AutoFormat %CURDISK%
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
        REM Make sure potentially disturbing left-overs
        REM from previous (failed) runs aren't around before we start.
        IF EXIST %BUILDDIR%\CURDISK.BAT CALL %BUILDDIR%\CURDISK.BAT
        IF EXIST %BUILDDIR%\fmt.ans DEL %BUILDDIR%\fmt.ans


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
        SET NETUTIL=1
        SET DRIVERS=1
        SET PKTMUX=1
        SET CURDISK=0
        SET LASTDISK=1
        SET DISKFMT=1.44
GOTO DISK1

:D12M
        SET NETUTIL=1
        SET DRIVERS=1
        SET PKTMUX=1
        SET CURDISK=0
        SET LASTDISK=1
        SET DISKFMT=1.2
GOTO DISK1

:D720
        SET NETUTIL=1
        SET DRIVERS=2
        SET PKTMUX=1
        SET CURDISK=0
        SET LASTDISK=2
        SET DISKFMT=720
GOTO DISK1

:D360
        SET NETUTIL=2
        SET DRIVERS=3
        SET PKTMUX=2
        SET CURDISK=0
        SET LASTDISK=3
        SET DISKFMT=360
GOTO DISK1


:DISK1
        REM increment CURDISK identifier
        %BUILDDIR%\UTILS\VARSET CURDISK %CURDISK%+1 | %BUILDDIR%\UTILS\NSET CURDISK=$3

        REM Call myself to format new disk
        CALL %0 AutoFormat %CURDISK%

        ECHO Transferring system files ...
        SYS %DESTDRV%

        REM calling myself to copy mandatory files for DISK1
        CALL %0 STARTUP
        CALL %0 RUNTIME

        REM Higher capacity disk may include this on DISK1 already
        IF "%PKTMUX%/" == "1/" CALL %0 PKTMUX
        IF "%NETUTIL%/" == "1/" CALL %0 NETUTIL
        
        REM Put drivers last
        IF "%DRIVERS%/" == "1/" CALL %0 DRIVERS

        REM exit if this is the last disk
        IF "%LASTDISK%/" == "1/" GOTO ENDDISK


:DISK2
        REM increment CURDISK identifier
        %BUILDDIR%\UTILS\VARSET CURDISK %CURDISK%+1 | %BUILDDIR%\UTILS\NSET CURDISK=$3

        REM Call myself to format new disk
        CALL %0 AutoFormat %CURDISK%

        REM calling myself to copy mandatory files for DISK2
        CALL %0 RUNTIME

        REM Include PKTMUX and NETUTIL
        IF "%PKTMUX%/" == "2/" CALL %0 PKTMUX
        IF "%NETUTIL%/" == "2/" CALL %0 NETUTIL

        REM Put drivers last.
        REM Routine will ask by itself for additional floppies
        IF "%DRIVERS%/" == "2/" CALL %0 DRIVERS

        REM exit if this is the last disk
        IF "%LASTDISK%/" == "2/" GOTO ENDDISK


:DISK3
        REM increment CURDISK identifier
        %BUILDDIR%\UTILS\VARSET CURDISK %CURDISK%+1 | %BUILDDIR%\UTILS\NSET CURDISK=$3

        REM Call myself to format new disk
        CALL %0 AutoFormat %CURDISK%

        REM calling myself to copy mandatory files for DISK3
        CALL %0 RUNTIME

        REM Put drivers last.
        REM Routine will ask by itself for additional floppies
        IF "%DRIVERS%/" == "3/" CALL %0 DRIVERS


:ENDDISK
        CLS
        ECHO Disk set has been successfully created.
        ECHO.

:CLEANUP
        ECHO Performing cleanup ...
        IF EXIST %BUILDDIR%\CURDISK.BAT CALL %BUILDDIR%\CURDISK.BAT
        IF EXIST %BUILDDIR%\fmt.ans DEL %BUILDDIR%\fmt.ans
        SET BUILDDIR=
        SET DESTDRV=
        SET NETUTIL=
        SET PKTMUX=
        SET DRIVERS=
        SET DISKFMT=
        SET LASTDISK=

:END
