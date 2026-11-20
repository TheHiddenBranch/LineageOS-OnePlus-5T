# Optional metadata fstab entry

## `0001-handle-devices-without-metadata-fstab-entry.patch`

Dumpling has no metadata fstab entry, so the wrapped-key helper dereferences null during
encryption setup. Return false when the entry is absent and otherwise use its
`wrapped_key` flag. The cache-backed metadata bind mount in device patch 0013 does not
add a fstab entry, so it does not replace this fix.
