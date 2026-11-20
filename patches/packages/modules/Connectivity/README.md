# Legacy BPF networking

## `0001-retain-legacy-bpf-networking.patch`

The platform rejects the retained networking BPF path at its Android-25Q4 kernel
minimum. Add a device build opt-in for that exception, extend the API range of the
existing 5.4 ingress/egress programs, and guard ringbuffer consumers and uprobestats
loading. Device patch 0010 enables it; kernel patches 0011–0012 provide required
ABI/verifier support. The selected kernel already reports 5.4.186 to these loaders
despite being 4.14; that override supplies no capabilities. Ringbuffer local-network
events and loopback metrics remain unavailable. The separate Android-26Q4 minimum is
still enforced.
