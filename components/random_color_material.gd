extends Node

@export var model: MeshInstance3D

func _ready():
	var material: StandardMaterial3D = model.material_override
	material.albedo_color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
