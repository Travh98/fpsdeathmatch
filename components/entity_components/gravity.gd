class_name Gravity
extends Node

## Manages being effected by gravity

@onready var mob: CharacterBody3D = $"../.."
@export var gravity_multiplier: float = 1.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") 


func apply_gravity(delta: float):
	mob.velocity.y -= gravity * gravity_multiplier * delta
