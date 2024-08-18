@ECHO OFF

:MENU
CLS
ECHO.
ECHO  DOS TCP/IP Diagnostics
ECHO  ----------------------
ECHO.
ECHO  Local IP: %IP%/%NETMASK%
ECHO.
ECHO  Do you want to ...
ECHO.
ECHO    1) run SPDTEST listener on TCP:65501
ECHO    2) run PKTTOOL listener
ECHO    3) exit to shell
ECHO.
CHOICE /C:123 /N "Make your choice: "
IF ERRORLEVEL 3 GOTO END
IF ERRORLEVEL 2 GOTO PKTTOOL
IF ERRORLEVEL 1 GOTO SPDTEST


:PKTTOOL
        CLS
        ECHO  Local IP: %IP%/%NETMASK%
        ECHO  ----------------------
        ECHO.
        
        PKTTOOL listen %PACKETINT% -v
        PAUSE
GOTO MENU

:SPDTEST
        CLS
        ECHO  Local IP: %IP%/%NETMASK%
        ECHO  ----------------------
        ECHO.
        ECHO  to run network send test, invoke on other machine like this:
        ECHO    SPDTEST -send -target=%IP% 65501
        ECHO.
        SPDTEST -receive -listen 65501
        PAUSE
GOTO MENU


:END
ECHO Just type 'NETMENU' to come back.
ECHO Good bye.
