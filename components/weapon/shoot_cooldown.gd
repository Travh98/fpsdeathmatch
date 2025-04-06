class_name ShootCooldown
extends Node

## Used to apply a cooldown between shooting

#signal cooled_down()

@export var cooldown_time: float = 0.2

var cooldown_timer: Timer

func _ready():
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown_time
	#cooldown_timer.timeout.connect(func(): cooled_down.emit())


func is_cooling_down() -> bool:
	if not cooldown_timer.is_stopped():
		return true
	return false


func shot_taken():
	cooldown_timer.start()
