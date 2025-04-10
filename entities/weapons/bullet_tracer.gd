class_name BulletTracer
extends Node3D

@export var travel_time: float = 0.05

@onready var bullet_node: Node3D = $BulletNode
@onready var bullet_wizz_sfx: AudioStreamPlayer3D = $BulletNode/BulletWizzSfx

var tween: Tween


func _ready():
	bullet_node.visible = false
	bullet_node.top_level = true


func fire_visuals(target_position: Vector3):
	if tween != null:
		tween.stop()
	tween = get_tree().create_tween()
	
	# Reset bullet pos to where this tracer is
	bullet_node.global_position = global_position
	bullet_node.global_rotation = global_rotation
	
	bullet_node.visible = true
	
	var dist_to_travel: float = target_position.distance_to(global_position)
	
	bullet_wizz_sfx.play()
	tween.tween_property(bullet_node, "global_position", target_position, dist_to_travel * travel_time)
	tween.tween_property(bullet_node, "visible", false, 0)
	tween.tween_property(bullet_wizz_sfx, "playing", false, 0)
