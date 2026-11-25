# MSM8998 common device tree

## `0001-select-oneplus-4.14-vendor-kernel.patch`

The selected 4.14 kernel has no `lineage_oneplus5_defconfig`. Select
`msm8998_oneplus_android_defconfig`, set its UFS boot-device path, and raise
`loop.max_part` from 7 to 16 for partitioned loop devices.

## `0002-migrate-livedisplay-to-aidl.patch`

LineageOS 24 removed the LiveDisplay HIDL 2.0 modules. Migrate the implementation to
AIDL v1, including Binder registration, method signatures, build dependencies, init
service, VINTF declarations and SELinux service-manager access. The interfaces and
helpers come from `src/hardware/lineage/interfaces/livedisplay/aidl/` and
`src/hardware/oneplus/aidl/livedisplay/`.

## `0003-drop-obsolete-lineage-framework-matrix.patch`

The referenced `vendor/lineage/config/device_framework_matrix.xml` no longer exists.
Remove that input from the framework matrix list; the product already selects the
current `framework_compatibility_matrix.lineage.xml` module.

## `0004-drop-obsolete-configstore-override.patch`

The `disable_configstore` override module and the service it suppressed were removed
from the platform. Remove the undefined module from `PRODUCT_PACKAGES`.

## `0005-declare-vendor-kernel-version-early.patch`

Qualcomm Soong configuration reads the kernel version before automatic detection runs.
Declare `TARGET_KERNEL_VERSION := 4.14` in the board configuration so the media HAL
selects its matching UAPI branch.

## `0006-install-fcm-5-compatibility-matrix.patch`

The vendor manifest declares FCM 5, which the platform no longer installs by default.
Add `framework_compatibility_matrix.5.xml` to this product. It requires
hardware/interfaces patches 0001–0002 and the kernel/configs patch.

## `0007-install-device-recovery-init.patch`

The legacy recovery-directory setting no longer installs `init.recovery.qcom.rc`.
Explicitly copy the existing script into the root image so recovery can create the
bootdevice symlink used by its fstab.

## `0008-align-cgroup-and-power-profiles-with-uclamp.patch`

The selected kernel uses UCLAMP and has no SchedTune controller. Remove the Android-28
vendor cgroup/task-profile overrides, use the platform defaults, and replace
foreground/top-app SchedTune writes with UCLAMP settings. The interaction hint sets
top-app minimum utilization to 78 percent and resets it to zero; the unsupported
root-group boot boost is removed.

## `0009-enable-legacy-gralloc.patch`

Android 17 requires mapper 4 by default, but the vendor graphics stack supplies mapper
2.x. Enable the existing `libui.legacy_gralloc` fallback.

## `0010-select-legacy-bpf-programs.patch`

Enable `netbpfload.legacy_kernel` for the loader exception supplied by the Connectivity
patch. That patch and the kernel BPF backports are required together; this flag alone
supplies no missing BPF capabilities.

## `0011-restore-legacy-ion-policy.patch`

Android 17 removed the active platform ION labeling and permissions still needed by this
vendor stack. Label `/dev/ion` as `ion_device` and restore access for its app, graphics,
media and secure-service clients, excluding isolated apps.

## `0012-export-power-libperfmgr-namespace.patch`

The Power HAL links against vendor `libperfmgr.so`, but exporting only its parent
namespace leaves the library uninstalled. Export the nested
`hardware/google/pixel/power-libperfmgr` namespace to Make so the runtime dependency is
packaged.

## `0013-provide-cache-backed-metadata.patch`

Aconfig needs writable metadata storage before encrypted userdata is available, but this
device has no metadata partition. Add the root mount point and a system init `fs` action
that creates a cache subdirectory, bind-mounts it as metadata and restores its labels
before the platform post-fs retry. Mirror the platform's metadata file contexts at
the cache backing path so cache relabeling preserves Aconfig's specialized types.
Force the initial relabel to repair stale labels after ROM switches; otherwise
Aconfig initialization can fail and Advanced Protection crashes `system_server`
on a missing feature flag. Wiping cache also discards this flag storage.

## `0014-label-4.14-platform-sysfs-paths.patch`

The 4.14 kernel exposes hardware under platform-bus paths that the inherited SELinux
mappings miss. Add 24 `genfscon` mappings for power supplies, LEDs/backlight, vibrator,
extcon and subsystem names, using the existing device and Qualcomm MSM8998 types.

## `0015-recover-stalled-camera-initialization.patch`

A camera provider stuck before HIDL registration leaves camera and torch unavailable.
Set `vendor.camera.provider24.init_timeout_ms=20000` to enable hardware/interfaces patch
0004. This restarts stalled initialization after 20 seconds; it does not repair the
proprietary HAL deadlock.
