class_name PlayerController
extends Node

## Connects the components used to drive a Player character

# Mob we are controlling
@onready var mob: CharacterBody3D = $".."

# Control components
@onready var relative_input: RelativeInput = $RelativeInput
@onready var body_head_rotation: BodyHeadRotation = $BodyHeadRotation
@onready var noclip: Noclip = $Noclip
@onready var gravity: Gravity = $Gravity
@onready var jump: Jump = $Jump
@onready var stamina: Stamina = $Stamina
@onready var sprint: Sprint = $Sprint
@onready var player_camera_mgr: PlayerCameraMgr = $PlayerCameraMgr
## Timer for allowing player to jump slightly after stepping off a platform
@onready var coyote_timer: Timer = $CoyoteTimer

# Mob nodes
@onready var head: Node3D = $"../Head"
@onready var fps_camera: Camera3D = $"../Head/FpsCamera"
@onready var health_component: HealthComponent = $"../HealthComponent"
#@onready var player_hud: PlayerHud = $"../Head/PlayerHUD"
@onready var player_name_label = $"../PlayerNameLabel"
#@onready var player_indicator: Sprite3D = $"../PlayerIndicator"

## The raw input from WASD keys
var input_axis: Vector2 = Vector2()
## The calculated move direction relative to the camera
var move_dir: Vector3
## Current move speed of the player
var move_speed: float = 5
## Current lerp speed for smooth animations
var lerp_speed: float = 8

## Speed of the player when walking
const WALK_SPEED: float = 5


func _ready():
	# Setup and connect nodes
	coyote_timer.one_shot = true
	
	# Disable or delete things that don't need to be included
	# on replicated peers
	if not is_multiplayer_authority(): 
		#player_hud.queue_free()
		return
	
	player_name_label.text = ClientGlobals.client_name
	#player_indicator.modulate = generate_random_hsv_color()


func _input(event):
	# Only handle input from this client.
	# If this is a replicated player, their 
	# position will be updated over the network
	if not is_multiplayer_authority(): return
	
	# Don't move if dead
	if health_component.is_dead:
		return
	
	# Rotate the player with the mouse
	if event is InputEventMouseMotion:
		body_head_rotation.apply_mouse_rotation(event, mob, head)


func _physics_process(delta: float) -> void:
	# Only run physics calculations for this client
	# since replicated clients will have their 
	# positions set over the network
	if not is_multiplayer_authority(): return
	
	if mob.is_on_floor():
		# Reset the coyote timer while on ground
		coyote_timer.start()
	
	if not mob.is_on_floor():
		# Apply gravity if not on ground
		gravity.apply_gravity(delta)
	
	if ClientGlobals.controls_locked:
		# If player is not allowed to move by the game,
		# still apply gravity forces
		mob.move_and_slide()
		return
	
	if health_component.is_dead:
		# Do not move if dead
		return
	
	# Get the WASD/Controller inputs
	input_axis = Input.get_vector(&"move_down", &"move_up", &"move_left", &"move_right")
	# Calculate move direction relative to the camera
	move_dir = relative_input.get_fps_relative_input(input_axis, mob)
	
	if noclip.is_noclip:
		# Allow player to fly through walls and floors (for debugging)
		noclip.handle_noclip(input_axis)
		return
	
	if mob.is_on_floor() or not coyote_timer.is_stopped():
		# Allow jumping if on the ground or if coyote timer is still running
		if Input.is_action_just_pressed("jump"):
			jump.apply_jump()
			coyote_timer.stop()
	
	# If sprinting
	var can_sprint: bool = sprint.sprint()
	if can_sprint:
		move_speed = WALK_SPEED * sprint.sprint_factor
		if move_dir != Vector3.ZERO:
			stamina.burn_stamina(sprint.sprint_burn_stamina_rate, delta)
			player_camera_mgr.fov = lerpf(player_camera_mgr.fov, sprint.sprint_fov, delta * 10)
		else:
			player_camera_mgr.fov = lerpf(player_camera_mgr.fov, player_camera_mgr.starting_fov, delta * 10)
			pass
	else:
		move_speed = WALK_SPEED
		player_camera_mgr.fov = lerpf(player_camera_mgr.fov, player_camera_mgr.starting_fov, delta * 10)
	
	# Lerp the velocity in x and z directions
	mob.velocity.x = lerp(mob.velocity.x, move_dir.x * move_speed, delta * lerp_speed)
	mob.velocity.z = lerp(mob.velocity.z, move_dir.z * move_speed, delta * lerp_speed)
	
	# Apply movement forces
	mob.move_and_slide()
