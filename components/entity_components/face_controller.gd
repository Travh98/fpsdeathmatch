@tool
class_name FaceController
extends Node

enum EyesPose {
	EYES_DEFAULT = 0,
	EYES_HAPPY,
	EYES_SAD,
	EYES_ANGRY,
	EYES_SURPRISED,
	EYES_CLOSED,
	EYES_WINK,
	EYES_THINK,
}

@export var eyes_mesh: MeshInstance3D
@export var eyes_pose: EyesPose = EyesPose.EYES_DEFAULT : set = set_eyes_pose
@export var eyes_color: Color

@onready var blink_timer: Timer = $BlinkTimer
var last_pose: EyesPose # Used to track when blinking
const BLINK_TIME: float = 0.2
const BLINK_WAIT_TIME: float = 10.0
const BLINK_WAIT_TIME_VAR: float = 1.5


func _ready():
	if eyes_mesh == null:
		push_warning("Missing eyes mesh for FaceController")
	
	blink_timer.wait_time = BLINK_WAIT_TIME + randf_range(-BLINK_WAIT_TIME_VAR, BLINK_WAIT_TIME_VAR)
	blink_timer.one_shot = true
	blink_timer.timeout.connect(blink)
	blink_timer.start()
	print("Starting blink timer")


func set_eyes_pose(pose: EyesPose):
	if pose == eyes_pose:
		return
	last_pose = eyes_pose
	eyes_pose = pose
	
	var shader_mat: ShaderMaterial = get_shader_mat()
	if shader_mat == null:
		push_warning("Missing eyes shader for FaceController")
		return
	
	var uv_offset: Vector3
	match eyes_pose:
		EyesPose.EYES_DEFAULT:
			uv_offset = Vector3.ZERO
		EyesPose.EYES_HAPPY:
			uv_offset = Vector3(0, 0.25, 0)
		EyesPose.EYES_SAD:
			uv_offset = Vector3(0, 0.50, 0)
		EyesPose.EYES_ANGRY:
			uv_offset = Vector3(0, 0.75, 0)
		EyesPose.EYES_SURPRISED:
			uv_offset = Vector3(0.5, 0,  0)
		EyesPose.EYES_CLOSED:
			uv_offset = Vector3(0.5, 0.25, 0)
		EyesPose.EYES_WINK:
			uv_offset = Vector3(0.5, 0.50, 0)
		EyesPose.EYES_THINK:
			uv_offset = Vector3(0.5, 0.75, 0)
	
	shader_mat.set_shader_parameter("uv_shift", uv_offset)


func set_eye_color(new_color: Color):
	if eyes_color == new_color:
		return
	eyes_color = new_color
	
	var shader_mat: ShaderMaterial = get_shader_mat()
	if shader_mat == null:
		push_warning("Missing eyes shader for FaceController")
		return
	
	shader_mat.set_shader_parameter("eye_color", eyes_color)


func get_shader_mat() -> ShaderMaterial:
	if eyes_mesh == null:
		return null
	var eyes_mat: ShaderMaterial = eyes_mesh.get_surface_override_material(0)
	return eyes_mat


func blink():
	eyes_pose = EyesPose.EYES_CLOSED
	await get_tree().create_timer(BLINK_TIME).timeout
	eyes_pose = last_pose
	blink_timer.wait_time = BLINK_WAIT_TIME + randf_range(-BLINK_WAIT_TIME_VAR, BLINK_WAIT_TIME_VAR)
	blink_timer.start()
