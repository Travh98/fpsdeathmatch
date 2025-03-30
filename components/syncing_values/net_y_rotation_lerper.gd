class_name NetYRotationLerper
extends Node

## Replicates an objects rotation from host and lerps to it on clients

## The synchronizer for this position syncer.
## Set the Synchronizer to always sync this 
## node's networked_rotation_y variable.
## You can set the replication_interval of 
## this MultiplayerSyncronizer to free up bandwidth
@onready var multiplayer_synchronizer = $MultiplayerSynchronizer

## The variable to sync between clients (must be exported for Syncronizer to see it)
@export var networked_rotation_y: float
## The Node3D that is being controlled by this syncronizer
@export var controlled_object: Node3D
## Speed to lerp between synced values.
## Higher lerp speed means faster snapping between synced values.
@export var lerp_speed: float = 8

func _ready():
	if multiplayer_synchronizer == null:
		push_warning(name + " is missing MultiplayerSynchronizer")
	if controlled_object == null:
		push_warning(name + " is missing the object it is syncing")
	pass


func _physics_process(delta):
	# Clients will lerp their replicated object to the networked rotation
	if not is_multiplayer_authority(): 
		controlled_object.global_rotation.y = lerp_angle(controlled_object.global_rotation.y,
			networked_rotation_y, lerp_speed * delta)
		return
	
	# Host will update the networked rotation
	networked_rotation_y = controlled_object.global_rotation.y
