class_name StuckChecker
extends Node

signal stuck()

@onready var mob: Node3D = $"../.."
@onready var stuck_checker_timer: Timer = $StuckCheckerTimer
@export var expected_min_movement_dist: float = 0.25
@export var stuck_check_time: float = 3.0

var do_check_for_stuck: bool = true : set = set_do_check_for_stuck
var last_position_xz: Vector2



func _ready():
	stuck_checker_timer.timeout.connect(check_if_stuck)
	stuck_checker_timer.wait_time = stuck_check_time
	stuck_checker_timer.start()


func check_if_stuck():
	if not do_check_for_stuck:
		return
	
	var current_pos_xz: Vector2 = Vector2(mob.global_position.x, mob.global_position.z)
	if last_position_xz == Vector2.ZERO:
		last_position_xz = current_pos_xz
		return
	
	if current_pos_xz.distance_to(last_position_xz) < expected_min_movement_dist:
		stuck.emit()
	
	last_position_xz = current_pos_xz


func set_do_check_for_stuck(do_check: bool):
	do_check_for_stuck = do_check
	if do_check_for_stuck:
		stuck_checker_timer.start()
	else:
		stuck_checker_timer.stop()
