class_name RotateTowardsMotion
extends Node

@onready var mob: Node3D = $"../.."
@export var lerp_speed: float = 8.0

func apply_rotate(delta):
	if mob is CharacterBody3D:
		mob.rotation.y = lerp_angle(mob.rotation.y, atan2(-mob.velocity.x, -mob.velocity.z), delta * lerp_speed)
