class_name MuzzleFlash
extends Node3D

@onready var flash_node: Node3D = $MuzzleFlash2


func _ready():
	flash_node.visible = false


func flash():
	flash_node.rotation.z = randf_range(deg_to_rad(-180), deg_to_rad(180))
	flash_node.visible = true
	get_tree().create_tween().tween_property(flash_node, "visible", false, 0.1)
