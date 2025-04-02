class_name PlayerCameraMgr
extends Node

## Manages the player's camera and CameraModes

signal camera_first_person()
signal camera_third_person()

enum CameraMode {
	CAMERA_FPS,
	CAMERA_THIRD_PERSON,
	CAMERA_STABLE,
}

@onready var mob: Node3D = $"../.."
@onready var fps_camera: Camera3D = $"../../Head/FpsCamera"
#@onready var third_person_camera: Camera3D = $"../../Head/ThirdPersonCamera"
#@onready var stable_camera: Camera3D = $"../../StableCameraRig/SpringArm3D/StableCamera"
#@onready var stable_camera_rig: Node3D = $"../../StableCameraRig"

var camera_mode: CameraMode = CameraMode.CAMERA_FPS : set = set_camera_mode
var _current_camera: Camera3D
var starting_fov: float
var fov: float = 75 : set = set_fov


func _ready():
	camera_mode = CameraMode.CAMERA_FPS
	starting_fov = fps_camera.fov
	fov = starting_fov
	#stable_camera_rig.top_level = true
	#print("Starting fov: ", fov)


func _input(_event):
	# Only allow input for the camera that this client is controlling
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("switch_view"):
		# Cycle between the CameraModes enum
		var next_view: int = camera_mode + 1
		if next_view >= CameraMode.values().size():
			next_view = 0
		camera_mode = CameraMode.values()[next_view]


func _process(_delta):
	#if camera_mode == CameraMode.CAMERA_STABLE:
		#stable_camera_rig.global_position = mob.global_position + Vector3.UP
	pass


func set_camera_mode(new_mode: CameraMode):
	if not is_multiplayer_authority(): return
	
	if camera_mode != new_mode:
		camera_mode = new_mode
	match camera_mode:
		CameraMode.CAMERA_FPS:
			fps_camera.make_current()
			_current_camera = fps_camera
		#CameraMode.CAMERA_THIRD_PERSON:
			#third_person_camera.make_current()
			#_current_camera = third_person_camera
		#CameraMode.CAMERA_STABLE:
			#stable_camera.make_current()
			#_current_camera = stable_camera
		_:
			# Default to FPS camera
			fps_camera.make_current()
			_current_camera = fps_camera
	
	if camera_mode == CameraMode.CAMERA_FPS:
		camera_first_person.emit()
	else:
		camera_third_person.emit()


func set_fov(new_fov: float):
	if not is_multiplayer_authority(): return
	
	if _current_camera:
		_current_camera.fov = new_fov
