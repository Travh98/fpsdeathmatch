class_name ReloadingCooldown
extends Node

@export var reload_time: float = 0.5

var cooldown_timer: Timer

func _ready():
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = reload_time


func reload():
	cooldown_timer.start()


func is_reloaded() -> bool:
	return cooldown_timer.is_stopped() 
