class_name Jump
extends Node

@export var jump_force: float = 4.0

@onready var mob: CharacterBody3D = $"../.."


func apply_jump():
	mob.velocity.y = jump_force
