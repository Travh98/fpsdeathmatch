extends Node

## Contains global data for this client

## Emitted when a new ping is calculated
@warning_ignore("unused_signal")
signal ping_calculated
## Emitted to toggle debug collider visiblility
signal show_debug_colliders_toggled(toggled_on: bool)

## This client's username
var client_name: String
## If True, client cannot use inputs to move their player
var controls_locked: bool = false
## If True, debug colliders are visible
var do_show_debug_colliders: bool = false : set = set_do_show_debug_colliders


## Handle setting when to show debug colliders
func set_do_show_debug_colliders(toggle_on: bool):
	if do_show_debug_colliders != toggle_on:
		do_show_debug_colliders = toggle_on
		show_debug_colliders_toggled.emit(do_show_debug_colliders)
