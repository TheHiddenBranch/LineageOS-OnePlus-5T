# MSM8998 vendor radio compatibility

## `0001-enable-rtnetlink-for-msm8998.patch`

The 4.14 RMNET driver uses `NETLINK_ROUTE` instead of legacy protocol 31. Set
`rtm_rmnet_data_enabled=1` in the MSM8998 netmgr profile so modem data interfaces can be
created.

## `0002-match-bluetooth-uart-pm-ioctls.patch`

The Bluetooth HAL’s UART clock-vote requests do not match the selected kernel, allowing
autosuspend to interrupt firmware loading. Change 25 AArch64 MOV immediates from
requests `0x5441/2/3` to `0x544d/e/f`, matching the kernel UART UAPI. The binary delta
requires original HAL SHA-256
`d0e13fa82d159df377c38f1dd3c546ed339211079a0296d7041a127b04f99d40`; the patched hash is
`cb4d45fe7cd8c8c321edadd00d37dfbd0846bfd69e03302842f8fe2befef9848`.
