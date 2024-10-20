# Utilities

These are some bundled utilities to extended the batch files.

These were sourced from [Horst Schaefer's website](https://www.horstmuc.de):

 * [ipbats32.zip](https://www.horstmuc.de/int/pbats32.zip)
 * [varset12.zip](https://www.horstmuc.de/int/varset12.zip)

[MKBOOT.BAT](../MKBOOT.BAT) won't use all utilities by default,
but just these:

* `RANDOM.COM`
* `NSET.COM`
* `QECHO.COM`
* `VARSET.COM`

Adapt [MKBOOT.BAT](../MKBOOT.BAT) if you want to change the file lists.
Search for this section to adapt:

```
	SET RUNTIMEF2=%BUILDDIR%\UTILS\RANDOM.COM %BUILDDIR%\UTILS\NSET.COM %BUILDDIR%\UTILS\QECHO.COM
```

Change the `RUNTIMEF2` variable as you wish.

References:
[Horst Schaefer's website](https://web.archive.org/web/20060220035554/http://home.mnet-online.de/horst.muc)
