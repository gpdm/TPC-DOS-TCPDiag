# TPC-DOS-TCPDiag

Minimalist DOS TCP/IP Boot Floppies, just enough to get an old IBM compatible PC
onto an IP network, and conduct some basic diagnostics.

This was featured on my [video on YT](https://www.youtube.com/watch?v=18A993m9Pm8).

The reason to build this was simple: I wanted a set of boot disks that I could use
on 80s/90s retro PCs, to help in setting up and conducting base diagnostics on
vintage networks, like 10Base2 Ethernet using the TCP/IP protocol.

It's not meant for day-to-day use, as many things are intentionally left out.
It's meant for diagnostics, not much more.


## TLDR; Gimme the Disks!

Prebuilt Disk Images for various formats are available.

* [1.44M](DISKIMG/144M)
* [1.2M](DISKIMG/12M)
* [720K](DISKIMG/720K)
* [360K](DISKIMG/360K)

No disk images are available for 320K, 180K or 160K formats.

The disks include:

* DOS Packet Drivers for Ne2000, 3C509, 3C905, Kingston KNE2021LC, AMD PCNet, RTL8019, RTL8029, RTL8139
* Basic mTCP diag tools
* Trumpet TCP For DOS (just `TCPDRV`)
* PKTMUX, Packer Drive Multiplexer
* some utilities for the included batch files
* runtime configuration (read more below)


## How to Build yourself

You need a physical or virtual machine running DOS.
I created this on `IBM PC DOS 6.1`, and that's what's its intended for and tested with.
It will work on `MS-DOS 6.x`.

It will not properly work on earlier IBM/MS DOS, and definitely not with other
non IBM/MS DOS, without altering many things.

Most notably, the CONFIG.SYS boot menu is using IBM/MS DOS 6 specifics.


Start by cloning this repository, and place it onto a DOS machine where you have `PC DOS 6.1` installed.
Make sure the directory is placed at `C:\BUILD`. 


Some utilities are bundled in this repo.
But to fetch full upstream releases, read the
associated Read-me's in for details:

* [MTCP](MTCP/README.md)
* [TTCP](TTCP/README.md)
* [NTTCP](NTTCP/README.md)
* [PKTMUX](PKTMUX/README.md)

If the bundled drivers are not good enough,
download DOS packet drivers, as noted in:

* [NICS](NICS/README.md)

Once you have all files prepared run `MKBOOT.BAT` as follows:

```
CD C:\BUILD
MKBOOT.BAT
```

The rest should be self-explanatory.


## Runtime Configuration

I created this disk set with some minimalistic "usability" in mind.
It can run fully interactive, but also has some preconfiguration possibilities available.


### Preset for NIC Hardware Configuration

`AUTOEXEC.BAT` works with variables, so things are easier to adapt.

The settings for the network card and packet interface are hardcoded as follows in [AUTOEXEC.BAT](CFG/AUTOEXEC.BAT):

```
SET NETIRQ=5
SET NETIOADDR=0x300
```

But to faciliate a more dynamic approach for runtime configuring these parameters,
you can set overrides in [SETNIC.BAT](CFG/SETNIC.BAT), i.e. like so:

```
@ECHO OFF
SET NETIRQ=10
SET NETIOADDR=0x300
```

`SETNIC.BAT` is not mandatory to exist.
But if it does, `AUTOEXEC.BAT` will load it, and use the parameteres as defined in there.


### Auto-loading of NIC Packet Drivers

There's no such thing as hardware auto-detection, so it all depends on loading the drivers yourself.

`AUTOEXEC.BAT` can call up [AUTOLOAD.BAT](CFG/AUTOLOAD.BAT) if it exists, and load the defined
driver automatically.

A typical command line, which will use the environment variables defined as shown above, may look like this:

```
@\NIC\NE2000\NE2000 %PACKETINT% %NETIRQ% %NETIOADDR%
```

Please also note the further remarks in the [NIC Readme](NICS/README.md).


## To Do

Some things missing for now, that I might include eventually:

* XMS RamDisk for speeding things up
* maybe include `NC` (netcat)
* NIC drivers autoprobing
* add disk free checks before copying, split on available disk space 
