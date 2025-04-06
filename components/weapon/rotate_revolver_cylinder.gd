class_name RotateRevolverCylinder
extends Node

@export var cylinder: Node3D
@export var bullets: int = 6
@export var rotate_time: float = 0.3

var rotate_amt_deg: float

func _ready():
	rotate_amt_deg = 360.0 / bullets


func rotate_cylinder():
	#print("Rotate cylinder to ", cylinder.rotation.z + rotate_amt_deg)
	#get_tree().create_tween().tween_property(cylinder, 
		#"rotation", Vector3(0, 0, (cylinder.rotation.y + rotate_amt_deg)), rotate_time)
	#cylinder.rotation.z = lerp_angle(cylinder.rotation.z, cylinder.rotation.z + rotate_amt_deg, )
	#cylinder.rotation.z += rotate_amt_deg
	pass
