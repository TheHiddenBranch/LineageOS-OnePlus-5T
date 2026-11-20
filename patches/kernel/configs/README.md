# Android R requirements for the 4.14 vendor kernel

## `0001-restore-r-4.14-vintf-kernel-requirements.patch`

The retained vendor manifest uses FCM 5, whose kernel requirements were removed from
this platform branch. Restore `r/android-4.14/` and its `kernel_config_r_4.14` module
for the restored hardware/interfaces matrix. The module selects the original
release/userdebug requirements.
