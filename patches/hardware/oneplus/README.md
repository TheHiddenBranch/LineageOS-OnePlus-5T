# OnePlus hardware support

## `0001-keep-alert-slider-service-persistent.patch`

Android can cache and freeze the background KeyHandler process while its
`UEventObserver` waits for hardware events. The frozen listener cannot process
alert-slider movements. Mark the system app persistent to keep the listener
runnable without disabling the app freezer globally.
