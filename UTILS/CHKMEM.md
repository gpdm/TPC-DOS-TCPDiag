CHKMEM was sourced from [AMD PCNET Driver, Metropoli BBS](https://files.mpoli.fi/unpacked/hardware/net/other/etherte2.zip/)

The sample below shows how it was used as part of the PCNET diagnostics.

That's it, folks!


```
 @echo off
REM -----------------------------------------------------------------
REM The current version of ETDIAG (v3.10) needs 375K of  free  memory
REM to  run.  This  batch-file  ensures  that  there is enough memory
REM available.
REM 
REM NOTE! If only configuration is concerned  (the  diagnostics  will
REM       not  be started), then the free space needed is less, about
REM       350K.
REM -----------------------------------------------------------------
if [%1] == [/C] goto start2_etdiag
if [%1] == [/c] goto start2_etdiag
REM
REM Enough memory to start ETDIAG normally?
REM 
chkmem 375
if errorlevel 99 goto end
if errorlevel 1 goto no_mem1
goto start_etdiag
REM
REM Enough memory for ETDIAG without diagnostics?
REM 
:start2_etdiag
chkmem 350
if errorlevel 1 goto end
REM
REM Start ETDIAG Utility.
REM
:start_etdiag
aminst.exe
goto end
REM
REM Output user info about not enough of free memory.
REM 
:no_mem1
echo -----------------------------------------------------------------
echo FATAL : The current version of ETDIAG (v3.10) needs 375K of  free
echo memory  to  run.  To  start  ETDIAG in your system, do any of the
echo following:
echo  .
echo  1. Use MEM command to get the actual free memory in your system.
echo     If possible, temporary free enough memory  from  your  system
echo     and try again.
echo  .
echo  2. Make  a  bootable MS-DOS diskette and copy the files from the
echo     root of ICL EtherTeam PCI/ISA Utilities disk to it. Then boot
echo     using this diskette and try again.
REM
REM Enough memory for ETDIAG without diagnostics?
REM 
chkmem 350
if errorlevel 1 goto no_mem2
REM
REM Output rest of user info.
REM 
echo  . 
echo  3. There is enough free memory to start ETDIAG for configuration
echo     only, but it is not possible to start the diagnostics from it.
echo     To continue from here, either:
echo  . 
echo        - Press any key to start ETDIAG.
echo        - Press "Ctrl-C" to exit ETDIAG.
echo -----------------------------------------------------------------
pause
goto start_etdiag
:no_mem2
echo -----------------------------------------------------------------
:end
```
