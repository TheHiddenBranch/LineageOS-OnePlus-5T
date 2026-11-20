# Explicit ANT receiver export state

## `0001-declare-dynamic-receiver-export-state.patch`

Modern receiver registration checks throw a SecurityException when the ANT service omits
its export state; the service runs in SystemServer. Add `Context.RECEIVER_EXPORTED` to
both registrations so external ANT clients and the separate Bluetooth UID can still
deliver their existing requests and broadcasts.
