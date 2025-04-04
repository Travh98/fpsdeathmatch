class_name RespawnPoint
extends Node3D

## Spot to spawn at in the world
@onready var spawn_spot: Node3D = $SpawnSpot
## Raycast for checking if something is in the way
@onready var occupied_raycast: RayCast3D = $OccupiedRaycast


func _ready():
	# Collide with players
	occupied_raycast.set_collision_mask_value(2, true)
	
	LevelMgr.register_respawn_point(self)
	pass


func is_valid_spot() -> bool:
	if occupied_raycast.is_colliding():
		# Spot is occupied
		return false
	
	return true
