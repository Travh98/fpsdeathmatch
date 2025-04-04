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
	if not is_multiplayer_authority(): return
	
	# Delay respawning
	await get_tree().create_timer(respawn_delay).timeout
	
	respawn()


func respawn():
	# Move player to a respawn point
	var respawn_spot: Node3D = LevelMgr.get_respawn_spot()
	mob.global_position = respawn_spot.global_position
	mob.global_rotation = respawn_spot.global_rotation
	
	# Restore health
	health_component.full_heal()
