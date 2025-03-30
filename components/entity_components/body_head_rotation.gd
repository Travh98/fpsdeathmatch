class_name BodyHeadRotation
extends Node

## Rotates a body and head 


@export var mouse_sens: float = 0.25


func apply_mouse_rotation(event: InputEventMouseMotion, body: Node3D, head: Node3D):
	if not is_multiplayer_authority(): return
	
	if ClientGlobals.controls_locked:
		return
	
	body.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
	head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
