# MSM8998 display: kernel ION v2 allocation

## `0001-use-kernel-ion-v2-allocation-api.patch`

The ION-v2 allocator calls undeclared libion APIs, while the current default libion
allocation implementation is stubbed. Replace those calls with `open`, `close` and
`ION_IOC_ALLOC` using the exported kernel structures, returning the allocated dma-buf
descriptor and negative errno on failure.
