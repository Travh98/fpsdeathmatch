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
	
	# Tell the server we died
	ServerDamageRpcs.apply_player_was_killed.rpc_id(1, multiplayer.get_unique_id())
	
	# Delay respawning
	await get_tree().create_timer(respawn_delay).timeout
	
	respawn()


func respawn():
	if not is_multiplayer_authority(): return
	
	# Move player to a respawn point
	var respawn_spot: Node3D = LevelMgr.get_respawn_spot()
	mob.global_position = respawn_spot.global_position
	mob.global_rotation = respawn_spot.global_rotation
	
	# Restore health
	health_component.full_heal()
	
	# Reset player data
	ServerPlayerDataRpcs.request_update_player_data.rpc_id(1, multiplayer.get_unique_id(), "last_hurt_by", str(0))
