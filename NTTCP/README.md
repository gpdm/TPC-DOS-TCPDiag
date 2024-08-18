# New Trumpet TCP Driver for DOS

Binary files of Trumpet nTCP for DOS are not included by intention.
When downloading this repositoring, fetch 
[ntpcdrv.zip](https://web.archive.org/web/20040604013649/ftp://ftp.trumpet.com.au/tcp-abi/ntcpdrv.zip)
and unpack it into this folder.

[MKBOOT.BAT](../MKBOOT.BAT) won't use NTCPDRV default.

Adapt [MKBOOT.BAT](../MKBOOT.BAT) if you want to change the file lists.
Search for this section to adapt:

```
REM ********************************
REM * copy network utils           *
REM ********************************
:NETUTIL
        SET MTCPF=DHCP.EXE PING.EXE PKTTOOL.EXE SPDTEST.EXE
        SET TTCPF=TCPDRV.EXE

        ECHO Copying network stack and utilities ...
        FOR %%F IN (%MTCPF%) DO COPY %BUILDDIR%\MTCP\%%F %DESTDRV%
        FOR %%F IN (%TTCPF%) DO COPY %BUILDDIR%\TTCP\%%F %DESTDRV%
```

Change the `FOR %%F IN (%TTCPF%) DO COPY %BUILDDIR%\TTCP\%%F %DESTDRV%` variable
to read as `FOR %%F IN (%TTCPF%) DO COPY %BUILDDIR%\NTTCP\%%F %DESTDRV%`.

If you want a mix of both, TTCP and NTTCP, you may want to change it like so:

```
REM ********************************
REM * copy network utils           *
REM ********************************
:NETUTIL
        SET MTCPF=DHCP.EXE PING.EXE PKTTOOL.EXE SPDTEST.EXE
        SET TTCPF=PING2.EXE
        SET NTTCPF=TCPDRV.EXE

        ECHO Copying network stack and utilities ...
        FOR %%F IN (%MTCPF%) DO COPY %BUILDDIR%\MTCP\%%F %DESTDRV%
        FOR %%F IN (%TTCPF%) DO COPY %BUILDDIR%\TTCP\%%F %DESTDRV%
        FOR %%F IN (%NTTCPF%) DO COPY %BUILDDIR%\NTTCP\%%F %DESTDRV%

        SET MTCPF=
        SET TTCPF=
	SET NTTCPF=
GOTO END
```


References:
[Trumpet TCP for DOS (via archive.org)](https://web.archive.org/web/20040604013649/http://www.trumpet.com.au/dosapps/)

