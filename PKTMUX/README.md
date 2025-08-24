# PKTMUX distribution

Binary files of PKTMUX 1.2I are included.

If in doubt, you may fetch a fresh copy of version 1.2 from
[archive.org](https://archive.org/details/PKTMUX12_ZIP)
and unpack it into this folder.

There's also a newer [version 1.2I](http://cd.textfiles.com/pdos9606/NETWORK/TCPIP/GENERAL/PKTMX12I.ZIP) available.

[MKBOOT.BAT](../MKBOOT.BAT) won't use all utilities by default,
but only copy the ones mentioned below to disk:

* `PKTDRV.EXE`
* `PKTMUX.EXE`

Adapt [MKBOOT.BAT](../MKBOOT.BAT) if you want to change the file lists.
Search for this section to adapt:

```
REM ********************************
REM * PKTMUX                       *
REM ********************************
:PKTMUX
        SET PKTMUXF=PKTMUX.EXE PKTDRV.EXE

        ECHO Copying Packet Driver Multiplexer ...
        FOR %%F IN (%PKTMUXF%) DO COPY %BUILDDIR%\PKTMUX\%%F %DESTDRV%

        SET PKTMUXF=
GOTO END
```

Change the `PKTMUXF` variable as you wish.

References:
[PKTMUX 1.2 on archive.org](https://archive.org/details/PKTMUX12_ZIP)
