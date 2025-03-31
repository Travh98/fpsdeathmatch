class_name UseEquippedItem
extends Node

## Passes user input to trigger an item's functions


## The Node3D that items will be a child of
var hand_spot: Node3D
## The eye raycast used for clicking on things from player's point of view 
var eye_cast: RayCast3D


func handle_primary():
	if eye_cast.get_collider():
		print(name + " handle primary is hitting " + eye_cast.get_collider().to_string())
	
	pass
