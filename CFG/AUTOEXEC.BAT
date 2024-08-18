@ECHO OFF

SET PATH=A:\
SET PROMPT=$P$G
SET MTCPCFG=A:\MTCP.CFG
SET AUTOLOAD=1

REM static definitions, don't override
REM set values in \SETNIC.BAT instead!
SET IP=undef
SET NETMASK=undef
SET PACKETINT=0x60
SET NETIRQ=5
SET NETIO=0x300


GOTO %CONFIG%


:NETPLAIN
:NETHMA
REM Nothing happening here, but label must exist


REM Switch to Driver Disk, if needed
:SWD_DRV
        CLS
        IF EXIST \NIC\nul GOTO SETNIC
        ECHO Insert disk labeled
        ECHO     DOS TCP/IP Boot Floppy, Disk 2
        CHOICE /C:C /N "and press 'C' to continue ... "
GOTO SWD_DRV


REM Call SETNIC.BAT to redefine NIC hw parameters
:SETNIC
        IF EXIST \SETNIC.BAT CALL \SETNIC.BAT


REM Bypass manual driver loading
REM   a) if AUTOLOAD.BAT exists
REM   b) and AUTOLOAD != 0
REM   c) or prompt is not skipped (N reply)
:AUTOLOAD
        IF "%AUTOLOAD%/" == "0/" GOTO DRVSHELL
        IF NOT EXIST \AUTOLOAD.BAT GOTO DRVSHELL
        CHOICE /C:YN /T:Y,5 "AUTOLOAD config exists, continue loading it (Y, default in 5)? "
        IF ERRORLEVEL 2 GOTO DRVSHELL
        CALL \AUTOLOAD.BAT
GOTO SWD_NET


:DRVSHELL
        ECHO There's no driver auto-detection configured.
        ECHO Inspect the NIC drivers directory, and load
        ECHO the NIC driver yourself from the shell, e.g.
        ECHO.
        ECHO   \NIC\NE2000\NE2000 %PACKETINT% %NETIRQ% %NETIO%
        ECHO.
        ECHO Then type 'exit' to resume startup.
        COMMAND /K CD \NIC
        CD \
GOTO SWD_NET


REM Switch to Network Disk, if needed
:SWD_NET
        IF EXIST \PKTTOOL.EXE GOTO INITNET
        CLS
        ECHO Insert disk labeled
        ECHO     DOS TCP/IP Boot Floppy, Disk 3
        CHOICE /C:C /N "and press 'C' to continue ... "
GOTO SWD_NET


:INITNET
        \PKTTOOL SCAN | FIND "No packet drivers found"
        IF ERRORLEVEL 1 GOTO STARTNET
        
        REM Fell-through!
        REM Obviously we have an issue with no packet driver loaded.
        REM Disable AUTOLOAD, then jump back to drivers disk,
        REM and enter manual shell for driver loading.
        SET AUTOLOAD=0
GOTO SWD_DRV


:STARTNET
        ECHO Creating %MTCPCFG% config ...
        ECHO PACKETINT %PACKETINT%>%MTCPCFG%
        ECHO MTU 1500>>%MTCPCFG%
        
        CHOICE /C:YN "Use DHCP client? "
        IF ERRORLEVEL 2 GOTO NODHCP

        ECHO Loading DHCP client ...
        DHCP -retries 2 -timeout 20
        IF ERRORLEVEL 2 GOTO DHCPFAIL

        REM If DHCP succeeded, push IP & Netmask to environment
        CALL \IPADDR
        CALL \NETMASK
GOTO ICMPRESPONDER


:DHCPFAIL
        ECHO DHCP Error: No IP address could be leased!
        ECHO Will proceed to manual IP configuration now.
        ECHO.

:NODHCP
        ECHO Use auto-config IP from 169.254.0.0/16 range instead of DHCP.
        ECHO No collision checking will be done when trying to
        ECHO pick a random IP from between 169.254.0.1-169.254.0.255
        ECHO.
        RANDOM 1,254 | NSET IP=169.254.0.$1
        SET NETMASK=255.255.255.0

        CHOICE /C:. /T:.,3 /N "Auto-assigned address: %IP%/%NETMASK%"

        ECHO Saving IP config ...
        ECHO IPADDR %IP%>>%MTCPCFG% 
        ECHO NETMASK %NETMASK%>>%MTCPCFG% 


:ICMPRESPONDER
        ECHO Running Trumpet TCP as permanent ICMP responder ...
        \TCPDRV

        CHOICE /C:. /T:.,3 /N ""

:SETPROMPT
        SET PROMPT=[%IP%] $p$g

:NETMENU
        CALL \NETMENU.BAT
GOTO END


:PLAIN
REM intentionally nothing configured for plain boot
:END
