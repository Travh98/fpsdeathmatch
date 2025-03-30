class_name InputMouseLocker
extends Node

## Locks the mouse to the screen when clicking


func _input(_event):
	if ClientGlobals.controls_locked:
		return
	
	if Input.is_action_just_pressed("primary"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
