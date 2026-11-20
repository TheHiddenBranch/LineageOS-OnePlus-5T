# OnePlus MSM8998 vendor kernel

## `0001-stop-android-module-discovery-in-kernel.patch`

Android module discovery descends into the kernel’s standalone driver makefiles and
registers a duplicate `audio_kernel_headers` module. Add a comment-only top-level
`Android.mk` to stop Make module discovery at the kernel root; Kbuild still builds its
drivers.

## `0002-honor-clang-triple-without-gcc-prefix.patch`

The Android LLVM build supplies `CLANG_TRIPLE` without a GCC cross-prefix. Apply that
Clang target independently of `CROSS_COMPILE` so ARM64 compilation does not default to
the host architecture.

## `0003-guard-openssl-engine-only-code.patch`

The supplied BoringSSL defines `OPENSSL_NO_ENGINE`, but the certificate/signing tools
still call ENGINE APIs. Guard those PKCS#11 paths with the same condition as their
header includes and report unsupported ENGINE input explicitly.

## `0004-initialize-const-qualified-temporaries.patch`

Clang rejects uninitialized const-qualified temporary objects. Zero-initialize the
`typecheck()` dummy objects and the USF 32-bit compatibility input structures so the
existing type checks and userspace copies compile.

## `0005-return-qdf-status-in-wlan-error-paths.patch`

Three WLAN error paths return constants from `A_STATUS` in functions returning
`QDF_STATUS`, causing enum conversion errors. Return `QDF_STATUS_E_FAILURE` from those
paths.

## `0006-create-fortify-test-output-directory.patch`

Separate kernel output directories lack the Fortify test-log parent directory, so shell
redirection fails before compilation. Create that directory in the Kbuild log rule.
Patch 0008 fixes a separate compiler-probe problem in the same Makefile.

## `0007-use-matching-audio-service-status-enums.patch`

Audio error paths mix CPE service, CPE processing and CMI result enums. Use
`CPE_PROC_FAILED` and `CMI_API_NO_MEMORY` in functions returning those types to fix
Clang enum conversion errors.

## `0008-enable-builtins-in-fortify-compile-tests.patch`

Inherited `-fno-builtin` prevents Clang from folding known string lengths in Fortify
compile-time probes. Add `-fbuiltin` only to those probes so overflow detection can be
evaluated; their objects are not linked into the kernel.

## `0009-backport-initramfs-ignore-skip-flag.patch`

The bootloader’s `skip_initramfs` argument can bypass the boot ramdisk containing
Android first-stage init. Add `CONFIG_INITRAMFS_IGNORE_SKIP_FLAG` to ignore that
argument and expose `want_initramfs` in the proc command line instead. Backported from
[LineageOS commit
bb4b6b5](https://github.com/LineageOS/android_kernel_oneplus_msm8998/commit/bb4b6b58378e24ed7d7e9cf6500846136caaecfb).
Patch 0010 enables the option.

## `0010-enable-initramfs-for-oneplus-normal-boot.patch`

Enable `CONFIG_INITRAMFS_IGNORE_SKIP_FLAG` in the selected defconfig so the behavior
implemented by 0009 takes effect. This follows [LineageOS commit
25349e8](https://github.com/LineageOS/android_kernel_oneplus_msm8998/commit/25349e86fa1586d8283af18d0690cc28dffc55b1).

## `0011-align-skb-context-and-backport-gso-access.patch`

Android networking BPF objects use canonical `__sk_buff` offsets and GSO fields missing
from the vendor layout. Restore those offsets and translate GSO reads to real
`skb_shared_info` values, including aliased registers; timestamp/wire-length slots
remain inaccessible. Adapted from Linux v5.7, [GSO
support](https://github.com/torvalds/linux/commit/cf62089b0edd7e74a1f474844b4d9f7b5697fb5c)
and its [register-alias
prerequisite](https://github.com/torvalds/linux/commit/06a22d897d82f12776d44dbf0850f5895469cb2a).
Existing BPF objects using the old vendor offsets require rebuilding.

## `0012-backport-arsh-verifier-range-tracking.patch`

The verifier loses scalar bounds through arithmetic right shifts and rejects netd’s
sign-extended 0/1 verdicts. Add tracked-number ARSH and signed/unsigned range
propagation for the existing ALU64 operation, preserving verdict and opcode validation.
Backported from [Linux commit
9cbe1f5](https://github.com/torvalds/linux/commit/9cbe1f5a32dcd6d0508326f7d9098e5bc380a4fe).

## `0013-backport-memfd-future-write-seal.patch`

Android 17 bitmap parceling requests `F_SEAL_FUTURE_WRITE`, which this shmem
implementation rejects. Implement the seal for writes, hole punching, new shared
mappings and mprotect while preserving existing shared writers and private fork-time
COW. Adapted from Linux commits
[ab3948f](https://github.com/torvalds/linux/commit/ab3948f58ff841e51feb845720624665ef5b7ef3)
and
[05d3511](https://github.com/torvalds/linux/commit/05d351102dbe4e103d6bdac18b1122cd3cd04925).
