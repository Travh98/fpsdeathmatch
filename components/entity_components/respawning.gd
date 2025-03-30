class_name Respawning
extends Node

## Allows respawning on death

@onready var mob: Node3D = $"../.."
@onready var health_component: HealthComponent = $"../../HealthComponent"

@export var respawn_delay: float = 3

func _ready():
	if not is_multiplayer_authority(): return
	health_component.health_died.connect(on_death)


func on_death():
	await get_tree().create_timer(respawn_delay).timeout
	mob.global_position = Vector3.ZERO
	health_component.full_heal()
