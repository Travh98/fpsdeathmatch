@tool
extends SkeletonIK3D

@export var do_ik: bool = true

func _ready():
	if do_ik:
		start()
