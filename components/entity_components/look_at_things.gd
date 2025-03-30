extends Node3D

@export var skeleton_head_look_at: SkeletonHeadLookAt
@onready var update_look_timer: Timer = $UpdateLookTimer
@onready var look_at_things_area: Area3D = $LookAtThingsArea
@onready var mob: Node3D = $".."
@export var neck_range_deg: int = 130

var look_at_target: Node3D


func _ready():
	update_look_timer.timeout.connect(update_look_target)


func update_look_target():
	var look_targets: Array[Node3D]
	for obj in look_at_things_area.get_overlapping_bodies():
		if obj == get_parent():
			continue
		
		if obj is CharacterBody3D:
			if obj.has_node("Head"):
				var head = obj.get_node("Head")
				look_targets.append(head)
			else:
				look_targets.append(obj)
	
	var closest_target: Node3D = null
	for target: Node3D in look_targets:
		
		if not can_turn_to_look_at(target.global_position):
			#print("Found target: ", target, " but too far to turn head")
			continue
		
		if closest_target == null:
			closest_target = target
		else:
			if target.global_position.distance_to(mob.global_position) < closest_target.global_position.distance_to(mob.global_position):
				closest_target = target
	
	look_at_target = closest_target
	
	if look_at_target == null:
		skeleton_head_look_at.do_look = false
	else:
		skeleton_head_look_at.do_look = true


func _physics_process(_delta):
	if look_at_target == null:
		if skeleton_head_look_at.do_look:
			skeleton_head_look_at.do_look = false
		return
	
	if not can_turn_to_look_at(look_at_target.global_position):
		return
	
	#print("Angle to target: ", rad_to_deg(abs(-mob.transform.basis.z.signed_angle_to(look_at_target.global_position, Vector3.FORWARD))))
	
	skeleton_head_look_at.look_at_marker.global_position = look_at_target.global_position


func can_turn_to_look_at(target_pos: Vector3) -> bool:
	return abs(-mob.transform.basis.z.signed_angle_to(target_pos, Vector3.FORWARD)) < deg_to_rad(neck_range_deg)
