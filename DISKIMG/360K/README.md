# 360K images currently broken

There's no logic to test for availabl free disk space
upon image creation.

As a consequence, disk #2 is currently uncomplete,
as there's an unhandled overflow on copy, which leads
to an incomplete file transfer.

This shall be fixed soon.
