@tool
class_name SkeletonHeadLookAt
extends Node

var bone_index : int = -1;
@export var skeleton : Skeleton3D
@export var bone_name : String = "spine.005"
@export var do_look: bool = true
@onready var mob: Node3D = $".."
@onready var look_at_marker: Node3D = $LookAtMarker

func _ready():
	if skeleton:
		bone_index = skeleton.find_bone(bone_name)
	
	look_at_marker.top_level = true


func _physics_process(_delta):
	if bone_index == -1:
		return
	
	if not do_look:
		skeleton.clear_bones_global_pose_override()
		return
	
	if look_at_marker != null:
		head_look_at(look_at_marker.global_position)


func head_look_at(global_target_pos: Vector3):
	var bone_transform = skeleton.get_bone_global_pose_no_override(bone_index)
	var local_target_pos := mob.to_local(global_target_pos)
 
	if (look_at_marker == null):
		skeleton.set_bone_global_pose_override(bone_index,bone_transform,1.0,false)
		return
  
	var bone_origin = bone_transform.origin
	# The bone will have its basis looking at the target from the bone's origin
	bone_transform.basis = bone_transform.basis.looking_at( -(local_target_pos - bone_transform.origin).normalized())
	bone_transform.origin = bone_origin
	skeleton.set_bone_global_pose_override(bone_index,bone_transform,1.0,true)
