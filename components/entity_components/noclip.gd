class_name Noclip
extends Node

## Allows noclipping

@onready var mob: Node3D = $"../.."
@onready var camera: Node3D = $"../../Head/FpsCamera"
@onready var collision_shape: CollisionShape3D = $"../../CollisionShape3D"

const NOCLIP_SPEED: float = 0.25

var is_noclip: bool = false : set = set_noclip


func set_noclip(do_noclip: bool):
	is_noclip = do_noclip
	collision_shape.disabled = is_noclip


## Needs the raw input dir
func handle_noclip(raw_input_dir: Vector2):
	if Input.is_action_pressed("jump"):
		mob.global_position += Vector3.UP * NOCLIP_SPEED
	if Input.is_action_pressed("crouch"):
		mob.global_position += -Vector3.UP * NOCLIP_SPEED
	
	var aim: Basis = camera.global_transform.basis
	mob.global_position += (aim.z * -raw_input_dir.x + aim.x * raw_input_dir.y).normalized() * NOCLIP_SPEED


func _input(_event):
	if Input.is_action_just_pressed("noclip"):
		is_noclip = !is_noclip
