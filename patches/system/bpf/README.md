# Ringbuffer test kernel compatibility

## `0001-gate-ringbuffer-test-by-kernel-abi.patch`

The Rust loader can fail creating the critical ringbuffer test map before applying the
program’s kernel-version restriction. Add an object-level minimum of 5.10 and skip the
entire object below it. This is needed for userdebug builds; user builds already skip
this test. The test remains critical on supported kernels.
