@ECHO OFF

IF "%MTCPCFG%/" == "/" GOTO NOMTCPCFG
IF NOT EXIST %MTCPCFG% GOTO NOMTCPCFG
IF NOT "%1/" == "/" GOTO SETIP
IF "%1/" == "/" GOTO GETIP

:GETIP
        TYPE %MTCPCFG% | FIND "IPADDR" > _getip.bat
        CALL _getip.bat
        DEL _getip.bat
GOTO DONE


:SETIP
        SET IP=%1
GOTO DONE


:NOMTCPCFG
        ECHO Error! MTCPCFG is not defined, or missing!
GOTO DONE


:DONE
