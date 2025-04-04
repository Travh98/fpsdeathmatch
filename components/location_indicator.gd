extends Node3D

## Node that is visible in editor but not in game.
## Used for visualizing locations.


func _ready():
	$MeshInstance3D.visible = false
