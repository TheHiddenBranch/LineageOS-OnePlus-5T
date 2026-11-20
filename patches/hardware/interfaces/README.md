# Hardware-interface compatibility for the MSM8998 vendor stack

## `0001-restore-fcm-5-for-4.14-vendor-devices.patch`

The FCM-5 vendor stack needs a framework matrix absent from LineageOS 24. Restore the
FCM-5 XML and its build module, selecting only the 4.14 kernel requirements supplied by
the kernel/configs patch. Device patch 0006 installs the module.

## `0002-drop-unavailable-unused-fcm-5-hidl-entries.patch`

The restored XML references eight HIDL HAL definitions removed from the platform:
automotive audiocontrol/surround-view, dumpstate 1.1, health storage, input classifier,
IR, memtrack 1.0 and VR. Remove those entries so VINTF definition checking can resolve
the matrix. This intentionally edits the file introduced by 0001; these HALs are not
declared as HIDL by this product.

## `0003-unroll-health-event-filter-for-4.14.patch`

The 4.14 BPF verifier rejects bounded loops, while unrolling the original battery-uevent
filter exceeds its 4,096-instruction limit. Explicitly unroll the fixed scan window and
initialize its read buffer once outside the loop to reduce the generated instruction
count. The scan window remains unchanged.

## `0004-bound-opt-in-legacy-camera-initialization.patch`

A legacy camera provider can hang inside module initialization before registering its
service. Add a constructor-scoped monotonic timer that sends SIGABRT to the initializing
thread, allowing init to restart the provider; successful initialization cancels it. The
timeout property defaults to zero and is bounded to 60 seconds; device patch 0015
selects 20 seconds. This recovers from stalled initialization without fixing the
underlying HAL deadlock.
