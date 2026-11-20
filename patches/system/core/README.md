# First-stage init correctness

## `0001-fix-init-fatal-reboot-target-parsing.patch`

Fatal-reboot target parsing advances by the size of a C++ string object instead of the
parameter prefix length. Use `.size()` to locate the value correctly. This affects
explicit fatal-reboot target parameters.

## `0002-use-real-reboot-handlers-in-first-stage-init.patch`

First-stage init includes the host verifier’s inline reboot stubs, which call abort
instead of the real reboot handler. Under `FIRST_STAGE_INIT`, include the actual
declarations and omit those stubs. This corrects failure handling; it is not a
requirement for a successful boot path.
