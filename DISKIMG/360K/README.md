# no 360k images available

There's only limited capability to test for available free disk space
upon image creation.

As a consequence, disk #2 is currently uncomplete,
as there's an unhandled overflow on copy, which leads
to an incomplete file transfer.

This needs some rewrites to [MKBOOT.BAT](../../MKBOOT.BAT)
to make it more reliable.

For the time, no 360k images are released.
