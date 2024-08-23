# Trumpet TCP for DOS Distribution

Binary files of Trumpet TCP for DOS are included.

If in doubt, you may fetch a fresh copy from
[tcp201.zip](https://web.archive.org/web/20040604013649/ftp://ftp.trumpet.com.au/tcp-abi/tcp201.zip)
and unpack it into this folder.

[MKBOOT.BAT](../MKBOOT.BAT) won't use all utilities by default,
but only copy the ones mentioned below to disk:

* `TCPDRV.EXE`

Adapt [MKBOOT.BAT](../MKBOOT.BAT) if you want to change the file lists.
Search for this section to adapt:

```
REM ********************************
REM * copy network utils           *
REM ********************************
:NETUTIL
        SET MTCPF=DHCP.EXE PING.EXE PKTTOOL.EXE SPDTEST.EXE
        SET TTCPF=TCPDRV.EXE
```

Change the `TTCPF` variable as you wish.

References:
[Trumpet TCP for DOS (via archive.org)](https://web.archive.org/web/20040604013649/http://www.trumpet.com.au/dosapps/)

