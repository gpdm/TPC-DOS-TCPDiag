# DOS Packet Drivers

As only mTCP and Trumpet's TCP for DOS are supported,
this strictly requires NIC drivers for the Packer Driver specification.

You'll find a some collections on

* [georgpotthast.de](http://www.georgpotthast.de/sioux/packet.htm)
* [packetdriversdos.net (via archive.org)](https://web.archive.org/web/20240204203534/http://packetdriversdos.net/)

For now, as no auto-probing is implemented, there's no strictly defined
directory structure, thouch I recommend something like:

```
\NICS
\NICS\NE2000
\NICS\NE2000\NE2000.COM
```

Be careful when using the [AUTOLOAD](../README.md#auto-loading-of-nic-packet-drivers),
and adapt your pathnames to match the actual directory structure.

