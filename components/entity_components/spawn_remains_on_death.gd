class_name SpawnRemainsOnDeath
extends Node

@onready var mob: Node3D = $"../.."
@onready var health_component: HealthComponent = $"../../HealthComponent"

@export var remains: PackedScene

func _ready():
	health_component.health_died.connect(spawn_remains)
	pass


func spawn_remains():
	var remains_object: Node3D = remains.instantiate()
	get_tree().root.add_child(remains_object)
	remains_object.global_position = mob.global_position + Vector3.UP
	remains_object.global_rotation = mob.global_rotation
