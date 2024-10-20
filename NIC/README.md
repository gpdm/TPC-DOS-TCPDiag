# DOS Packet Drivers

As only mTCP and Trumpet's TCP for DOS are supported,
this strictly requires NIC drivers for the Packer Driver specification.

You'll find some collections on

* [georgpotthast.de](http://www.georgpotthast.de/sioux/packet.htm)
* [packetdriversdos.net (via archive.org)](https://web.archive.org/web/20240204203534/http://packetdriversdos.net/)
* [crynwr.com](http://crynwr.com/drivers/)

Unless stated otherwise, all packet drivers have been sourced from the locations above.

For now, as no auto-probing is implemented, there's no strictly defined
directory structure, thouch I recommend something like:

```
\NICS
\NICS\NE2000
\NICS\NE2000\NE2000.COM
```

Be careful when using the [AUTOLOAD](../README.md#auto-loading-of-nic-packet-drivers),
and adapt your pathnames to match the actual directory structure.


# Alternate Sources

Besides the more general collections above, some additional packet drivers
were sourced from:

* [SMC8013 from ardent-tool.com](https://ardent-tool.com/NIC/SMC_8013.html)
