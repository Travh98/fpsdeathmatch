class_name DisableCollisionsOnDeath
extends Node

@export var collision: CollisionShape3D

@onready var health_component: HealthComponent = $"../../HealthComponent"

func _ready():
	health_component.health_died.connect(on_death)
	health_component.health_respawned.connect(on_respawn)


func on_death():
	collision.set_deferred("disabled", true)


func on_respawn():
	collision.set_deferred("disabled", false)
