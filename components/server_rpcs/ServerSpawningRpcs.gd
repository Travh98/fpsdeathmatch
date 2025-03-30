extends Node

## RPCs for spawning things

signal spawned_entity(node_path: String, resource_path: String, global_pos: Vector3, global_rotation: Vector3)
signal despawned_entity(node_path: String)

@rpc("any_peer")
func spawn_entity(node_path: String, resource_path: String, global_pos: Vector3, global_rotation: Vector3):
	# Called from server
	spawned_entity.emit(node_path, resource_path, global_pos, global_rotation)


@rpc("any_peer")
func despawn_entity(node_path: String):
	# Called from server
	despawned_entity.emit(node_path)
