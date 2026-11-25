# OnePlus 5T device tree

## `0001-place-alert-slider-dialog-on-left.patch`

KeyHandler defaults to a right-hand slider, while the OnePlus 5T switch is on the
left. Override `alert_slider_dialog_left` to place and orient the mode dialog on
the physical switch's side. Set the middle-position anchor to 11.5% of the
display height in portrait, accounting for the existing 48dp upward/downward
state offsets. Retain the 25% anchor in landscape to leave room for the wider
dialog and its 116dp horizontal state offsets.
