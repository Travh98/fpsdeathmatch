class_name LineOfSight
extends Node

## Calculates line of sight

@export var line_of_sight_cast: RayCast3D


func has_line_of_sight(target: Node3D, offset_to_center: Vector3):
	line_of_sight_cast.target_position = line_of_sight_cast.to_local(target.global_position + offset_to_center)
	line_of_sight_cast.force_raycast_update()
	if line_of_sight_cast.is_colliding():
		var hit_obj: Node3D = line_of_sight_cast.get_collider()
		if hit_obj == target:
			return true
	
	return false
