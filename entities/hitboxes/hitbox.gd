class_name HitBox
extends Area3D

## An Area3D that can get hit by things

## Signal emits when hit by an attack
signal hit_taken(vital: Vitalness, incoming_dmg: int)

## Enum for tracking how critical getting hit here is
enum Vitalness {
	## Hitting this is a critical hit (head)
	VITAL_CRITICAL,
	## High importance for survival (chest)
	VITAL_HIGH,
	## Moderately vital for survival (legs)
	VITAL_MID,
	## Not very vital for survival (feet, arms, hands)
	VITAL_LOW,
}
## How critical it is if this hitbox takes damage
@export var vitalness: Vitalness = Vitalness.VITAL_HIGH

## The mob that this hitbox belongs to
var mob: Node


func _ready():
	# Hitboxes will live on collision layer 4 (hitboxes)
	set_collision_layer_value(1, false)
	set_collision_layer_value(4, true)
	
	ClientGlobals.show_debug_colliders_toggled.connect(on_debug_colliders_toggled)
	on_debug_colliders_toggled(ClientGlobals.do_show_debug_colliders)


## Call this function when dealing dmg to this hitbox
func take_hit(incoming_dmg: int):
	hit_taken.emit(vitalness, incoming_dmg)


func on_debug_colliders_toggled(toggle_on: bool):
	# toggle seeing debug collision shapes in game
	if has_node("MeshInstance3D"):
		get_node("MeshInstance3D").visible = toggle_on
