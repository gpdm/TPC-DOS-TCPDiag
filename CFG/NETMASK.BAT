@ECHO OFF

IF "%MTCPCFG%/" == "/" GOTO NOMTCPCFG
IF NOT EXIST %MTCPCFG% GOTO NOMTCPCFG
IF NOT "%1/" == "/" GOTO SETMASK
IF "%1/" == "/" GOTO GETMASK

:GETMASK
        TYPE %MTCPCFG% | FIND "NETMASK" > _getmask.bat
        CALL _getmask.bat
        DEL _getmask.bat
GOTO DONE


:SETMASK
        SET NETMASK=%1
GOTO DONE


:NOMTCPCFG
        ECHO Error! MTCPCFG is not defined, or missing!
GOTO DONE


:DONE
