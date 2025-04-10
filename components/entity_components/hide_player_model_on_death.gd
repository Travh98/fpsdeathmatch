class_name HidePlayerModelOnDeath
extends Node

@export var player_models: Array[Node3D]

@onready var health_component: HealthComponent = $"../../HealthComponent"

func _ready():
	health_component.health_died.connect(on_death)
	health_component.health_respawned.connect(on_respawn)


func on_death():
	# Only show/hide playermodels for other clients
	if is_multiplayer_authority(): return
	
	for model in player_models:
		model.visible = false


func on_respawn():
	# Only show/hide playermodels for other clients
	if is_multiplayer_authority(): return
	
	for model in player_models:
		model.visible = true
