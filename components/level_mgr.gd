extends Node

## Autoload for managing level


var current_level: Node
var respawn_points: Array[RespawnPoint]


func register_respawn_point(respawn_point: RespawnPoint):
	respawn_points.append(respawn_point)
	#print(respawn_points.size(), " respawn points registered")


## Returns the best available respawn spot
func get_respawn_spot() -> Node3D:
	if respawn_points.is_empty():
		push_warning("No respawn points available")
		return null
	
	respawn_points.shuffle()
	for respawn_point: RespawnPoint in respawn_points:
		if respawn_point.is_valid_spot():
			return respawn_point.spawn_spot
	push_warning("All respawn points are occupied/invalid, picking first")
	return respawn_points[0]
