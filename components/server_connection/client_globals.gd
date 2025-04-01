extends Node

## Contains global data for this client

signal ping_calculated
signal show_debug_colliders_toggled(toggled_on: bool)

var client_name: String
var controls_locked: bool = false
var do_show_debug_colliders: bool = false : set = set_do_show_debug_colliders


func set_do_show_debug_colliders(toggle_on: bool):
	if do_show_debug_colliders != toggle_on:
		do_show_debug_colliders = toggle_on
		show_debug_colliders_toggled.emit(do_show_debug_colliders)
