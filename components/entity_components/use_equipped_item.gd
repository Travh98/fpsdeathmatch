class_name UseEquippedItem
extends Node

## Passes user input to trigger an item's functions


## The mob for this node
@onready var mob: Node = $"../.."

## The Node3D that items will be a child of
var hand_spot: Node3D
## The eye raycast used for clicking on things from player's point of view 
var eye_cast: RayCast3D
## The raycast for hitting hitboxes
var hitbox_cast: RayCast3D : set = set_hitbox_cast


func handle_primary():
	if hand_spot.get_child(0) is Revolver:
		var revolver: Revolver = hand_spot.get_child(0)
		revolver.mob = mob
		revolver.use_primary(eye_cast, hitbox_cast)
		#print("Using revolver")
		
	#print("Using primary")
	pass


func set_hitbox_cast(cast: RayCast3D):
	hitbox_cast = cast
	hitbox_cast.collide_with_areas = true
	hitbox_cast.set_collision_mask_value(4, true)
