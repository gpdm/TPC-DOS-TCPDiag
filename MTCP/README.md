# mTCP Distribution

Binary files of mTCP are not included by intention.
When downloading this repositoring, fetch 
[UPX compressed binaries](http://www.brutman.com/mTCP/download/mTCP_2023-03-31_upx.zip)
and unpack it into this folder.

[MKBOOT.BAT](../MKBOOT.BAT) won't use all utilities by default,
but only copy the ones mentioned below to disk:

* `DHCP.EXE`
* `PING.EXE`
* `PKTTOOL.EXE`
* `SPDTEST.EXE`

Adapt [MKBOOT.BAT](../MKBOOT.BAT) if you want to change the file lists.
Search for this section to adapt:

```
REM ********************************
REM * copy network utils           *
REM ********************************
:NETUTIL
        SET MTCPF=DHCP.EXE PING.EXE PKTTOOL.EXE SPDTEST.EXE
```

Change the `MTCPF` variable as you wish.

References:
[mTCP website](http://www.brutman.com/mTCP)

