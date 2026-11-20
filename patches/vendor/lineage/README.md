# LineageOS build integration

## `0001-sanitize-exported-sched-param.patch`

The exported 4.14 `linux/sched/types.h` defines `struct sched_param`, conflicting with
Bionic’s definition when DRM utilities include both header sets. Extend
`tools/clean_headers.sh` to remove that structure from generated userspace headers while
retaining kernel-specific scheduling types.
