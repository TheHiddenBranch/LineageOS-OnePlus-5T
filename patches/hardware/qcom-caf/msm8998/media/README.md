# MSM8998 media HAL

## `0001-select-newer-vidc-uapi-for-4.14.patch`

The default codec branch includes VIDC headers absent from the 4.14 kernel. Select the
existing `_TARGET_KERNEL_VERSION_49_` branch for kernels 4.9 and 4.14 in the common,
decoder and encoder libraries. Device patch 0005 supplies the kernel version early
enough for this selection.

## `0002-adapt-ion-and-buffer-abi-for-4.14.patch`

The codec buffer code expects older ION names and layouts. Add compatibility definitions
for the selected kernel’s `CONFIG_ION_LEGACY` allocation/map/import/free API, system
heap and secure flag; use DMA-BUF cache synchronization and current 64-bit
prefetch/drain structures. Update the V4L2 corruption flag and reject unsupported H.264
levels. Gralloc’s fd-based allocation patch targets a different supported kernel ioctl.
